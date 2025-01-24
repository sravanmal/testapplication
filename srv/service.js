const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {
  const { Request_Header, Request_Item, media } = this.entities;
  const { uuid } = cds.utils

  // Request_No auto-numbering for Request_Header 
  this.before('CREATE', 'Request_Header', async (req) => {
    const DEFAULT_START = 1000000000; // Starting value for Request_No

    // Fetch the highest existing Request_No
    const existingRecords = await SELECT.columns('Request_No')
      .from(Request_Header)
      .orderBy`Request_No desc`
      .limit(1);

    if (existingRecords.length === 0) {
      req.data.Request_No = DEFAULT_START; // Assign default start value if no records exist
    } else {
      const highestRequestNo = existingRecords[0].Request_No;
      req.data.Request_No = Number(highestRequestNo) + 1; // Increment and assign
    }
  });

  // updating the req_item_no when user delete any record 
  this.after('DELETE', 'Request_Item.drafts', async req => {

    // Step 1: Select all remaining items after the deletion
    var existingItems = await SELECT.from(Request_Item.drafts);
    console.log(existingItems)

    // Step 2: Renumber the remaining items
    let baseNumber = 10;

    // Loop through the existing items and update their Req_Item_No
    for (let item of existingItems) {
      item.Req_Item_No = baseNumber;

      // Step 3: Update each item in the drafts table
      await UPDATE(Request_Item.drafts)
        .set({ Req_Item_No: item.Req_Item_No })  // Update the Req_Item_No field
        .where({ ID: item.ID });  // Use the item's ID to identify it for updating

      const updateitems = await SELECT.from(Request_Item.drafts);
      console.log(updateitems);

      baseNumber += 10;  // Increment baseNumber for the next item
    }

    // Optionally, log the updated data to verify
    console.log('Items renumbered successfully');
  });



  // Request_No auto-numbering for Request_Items_no
  this.before('NEW', 'Request_Item.drafts', async req => {

    const DEFAULT_START = 10;

    // Check existing items for the same header
    const existingItems = await SELECT.columns('Req_Item_No')
      .from(Request_Item.drafts)
      .orderBy`Req_Item_No desc`
      .limit(1);

    // if no items present . items should start with 10 

    if (existingItems.length === 0) {
      req.data.Req_Item_No = DEFAULT_START;

      // if items present . items should increase with 10 
    } else {
      const highestReqItemNo = Math.max(...existingItems.map(item => item.Req_Item_No));
      req.data.Req_Item_No = highestReqItemNo + 10;
    }

  });


  // status code logic and Total Price logic for req header


  this.after('CREATE', 'Request_Header', async (req) => {

    // status code logic 

    var item = req;
    var status_code = req.Status_Code
    console.log(status_code)

    if (status_code = "open") {
      await UPDATE(Request_Header)
        .set({ Status_code: 'Saved' })  // Update the Req_Item_No field
        .where({ ID: item.ID });  // Use the item's ID to identify it for updating

      const updateitems = await SELECT.from(Request_Header).where({ ID: item.ID });;
      console.log(updateitems);
    }

  });




  this.after(['CREATE', 'UPDATE'], 'Request_Header', async (req) => {

    console.log("hi")
    console.log(req._Items);

    let data = req._Items

    let totalPrice = 0;

    data.forEach((item) => {
      if (item.Quantity && item.UnitPrice) {
        totalPrice += item.Quantity * item.UnitPrice;
      }
    });

    console.log("Total Price: " + totalPrice); // Output the total price

    await UPDATE(Request_Header)
      .set({ TotalPrice: totalPrice })  // Update the Req_Item_No field
      .where({ ID: req.ID });  // Use the item's ID to identify it for updating


  })


  // send for approval action button 

  this.on('sendforapproval', async (req) => {


    console.log(req.params[0].ID)

    await UPDATE(Request_Header)
      .set({ Status_Code: 'InApproval' })  // Update the Req_Item_No field
      .where({ ID: req.params[0].ID });  // Use the item's ID to identify it for updating

    const updateitems = await SELECT.from(Request_Header).where({ ID: req.params[0].ID });
    console.log(updateitems);


    // payload for bpa 

    const payload_bpa_header = await SELECT.from(Request_Header).where({ ID: req.params[0].ID });
    const payload_bpa_items = await SELECT.from(Request_Item).where({ _Header_ID: req.params[0].ID });
    const product_api = await cds.connect.to('bpa_destination');




    let payload = {
      "definitionId": "us10.buyerportalpoc-aeew31u1.directrequsitiont1.directRequsitionT1",
      "context": {
        "input": {
          "RequestNo": payload_bpa_header[0]?.Request_No,
          "RequestDesc": payload_bpa_header[0]?.Request_Description,
          "RequestBy": payload_bpa_header[0]?.createdBy,
          "TotalPrice": payload_bpa_header[0]?.TotalPrice,
          "RequestItem": payload_bpa_items.map(item => ({
            "ItemPrice": item.UnitPrice,
            "Quantity": item.Quantity,
            "Material": item.Material,
            "Plant": item.Plant,
            "ItemNumber": item.Req_Item_No,
            "ItemDescription": item.Material_Description
          }))
        }
      }
    };



    let oResult = await product_api.tx(req).post('/workflow/rest/v1/workflow-instances', payload);


  });

  // getting materialset and plantset data

  const { MaterialSet, PlantSet } = this.entities;
  const product_api1 = await cds.connect.to('OP_API_PRODUCT_SRV_0001');
  this.on("READ", MaterialSet, async (req) => {

    req.query.where("Product <> ''");
    req.query.SELECT.count = false;
    return await product_api1.run(req.query);
  });

  this.on("READ", PlantSet, async (req) => {
    req.query.where("Product <> ''");
    req.query.SELECT.count = false;
    return await product_api1.run(req.query);
  });



  // event handler for responsefrombpa

  this.on('responsefrombpa', async (req) => {

    console.log(req.data.status);

    if (req.data.status === "approved") {
      console.log("hi")

      // updated status to ordered 

      await UPDATE(Request_Header)
        .set({ Status_Code: 'Ordered' })
        .where({ ID: req.data.ID });


    } else {
      console.log("bye")

      // update status to rejected 

      await UPDATE(Request_Header)
        .set({ Status_Code: 'Rejected' })
        .where({ ID: req.data.ID });
    }

  })
});