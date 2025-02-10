using {
    cuid,
    managed,
    Currency
} from '@sap/cds/common';

using { OP_API_PRODUCT_SRV_0001 as product_api } from '../srv/external/OP_API_PRODUCT_SRV_0001';
using { API_PLANT_SRV as plant_api } from '../srv/external/API_PLANT_SRV';



namespace indirectreq.ust.db;

context transaction {

    //request header entity

    entity Request_Header : cuid, managed {

        PR_Number           : String(10) @readonly; // PR number
        Status_Code         : String(1) default 'O'  @readonly ; // Status Code
        PRType              : String; // PR type
        _Items              : Composition of many Request_Item
                                  on _Items._Header = $self; // items
        Request_Description : String     @mandatory; //  .Request Description
        _Comments           : Composition of many Comments
                                  on _Comments._headercomment = $self; // comments
        Request_No          : String(10); // Request No
        insertrestrictions  : Integer default 1;     // restrictions for buttons
        TotalPrice          : Integer;     // total price

    }

    // request items entity

    entity Request_Item : cuid, managed {

        PR_Item_Number       : String(10) @readonly; // PR number
        Material             : String  @mandatory; // .Material
        Material_Description : String  @mandatory; // Material Description
        PurOrg               : String; // .PurOrg
        Plant                : String  @mandatory; // .Plant
        Status               : String; // Status
        Quantity             : Integer @mandatory; // Quantity
        UoM                  : String; // Unit of Mass (uom)
        UnitPrice            : Integer; // Unit price
        Price                : Decimal = Quantity * UnitPrice; // Price
        Currency             : Currency; // currency
        PurchasingGroup      : String;
        Req_Item_No          : Integer ; // Request Item Number
        _Header              : Association to Request_Header;

    }


    // Comments entity

    entity Comments : cuid, managed {
        _headercomment : Association to Request_Header;
        text           : String // Text
    }

    // projections for product and plant 

    entity material  as projection on product_api.A_Product{
        key Product as ID,
        ProductType as Desc
     };

     entity plant  as projection on product_api.A_ProductPlant{
        key Plant as plant,
        
     };

     entity plantapi as projection on plant_api.A_Plant{
        key Plant as plant_id,
        PlantName as plantname,
        
     };


}
