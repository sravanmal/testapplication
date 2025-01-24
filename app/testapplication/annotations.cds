using Myservice as service from '../../srv/service';

annotate service.Request_Header with @(
    // selection fields 
    UI.SelectionFields:[

        Request_No,
        Status_Code,
        createdBy,

     ],

     // line items (request header)

     UI.LineItem:[

        {
            $Type : 'UI.DataField',
            Value : Request_No,
            Label: 'Request Number'
        },

        {
            $Type : 'UI.DataField',
            Value : Request_Description,
            Label: 'Request Description'
        },

        {
            $Type : 'UI.DataField',
            Value : TotalPrice,
            Label: 'Total Price'
        },

        {
            $Type : 'UI.DataField',
            Value : Status_Code,
            Label: 'Status Code'
        },

        {
            $Type : 'UI.DataField',
            Value : createdAt,
            Label: 'Created At'
        },

        {
            $Type : 'UI.DataField',
            Value : createdBy,
            Label: 'Created By'
        },

        {
            $Type : 'UI.DataField',
            Value : PR_Number,
            Label: 'Purchase Requisition NO'
        }

     ],

     // Header info 

     UI.HeaderInfo:{
        TypeName: 'Request Header',
        TypeNamePlural: 'Request Header',
        Title: {Value : Request_No},
        Description: {Value : Request_Description}
    },

    // facets 

    UI.Facets:[
        {
            $Type : 'UI.CollectionFacet',
            Facets : [
                {
                    $Type : 'UI.ReferenceFacet',
                    Target : '@UI.Identification'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#Spiderman'
                },
            ],
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label: 'PO Items',
            Target : '_Items/@UI.LineItem',
        },
    ],

    // identification facet 

     UI.Identification:[
        {
            $Type : 'UI.DataField',
            Value : Request_No,
            Label : 'Request No',
        },
        {
            $Type : 'UI.DataField',
            Value : Request_Description,
             Label : 'Request Description'
        },
        {
            $Type : 'UI.DataField',
            Value : TotalPrice,
             Label : 'Total Price'
        },
        {
            $Type : 'UI.DataField',
            Value : Status_Code,
             Label : 'Status'
        }
    ],

    // Reference Facet

     UI.FieldGroup #Spiderman: {
        Data : [
            {
                $Type : 'UI.DataField',
                Value : createdBy,
                 Label : 'Created By'
            },
            {
                $Type : 'UI.DataField',
                Value : createdAt,
                Label : 'Created On'
            },
            {
                $Type : 'UI.DataField',
                Value : modifiedAt,
                Label : 'Changed On'
            },
            {
                $Type : 'UI.DataField',
                Value : modifiedBy,
                Label : 'Changed By'
            }
        ],
    }
);


annotate service.Request_Item with @(

    // Line Items ( Request Items)

    UI.LineItem:[

        {
            $Type : 'UI.DataField',
            Value : Req_Item_No,
            Label : 'Request Item Number'
        },

        {
            $Type : 'UI.DataField',
            Value : Material_Description,
            Label : 'Material Description'
        },

        {
            $Type : 'UI.DataField',
            Value : Price,
            Label : 'price'
        },

        {
            $Type : 'UI.DataField',
            Value : Material,
            Label : 'Material'
        },

        {
            $Type : 'UI.DataField',
            Value : Plant,
            Label : 'Plant'
        },


        {
            $Type : 'UI.DataField',
            Value : Quantity,
            Label : 'Quantity'
        },

        {
            $Type : 'UI.DataField',
            Value : UoM,
            Label : 'Unit of Mass'
        },

        
    ],

    // Header info

    UI.HeaderInfo:{
        TypeName : 'Request Items',
        TypeNamePlural: 'Request Items',
        Title : {Value: PR_Item_Number},
        Description: {Value: Material_Description}
    },

    // facet 

     UI.Facets:[
        {
            $Type : 'UI.CollectionFacet',
            Label: 'General Information',
            Facets : [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label: 'Plant Details',
                    Target : '@UI.Identification'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label: 'Pricing and Quantity Details',
                    Target : '@UI.FieldGroup#Spiderman'
                },
            ],
        }
    ],

    // identification facet

    UI.Identification:[
        {
            $Type : 'UI.DataField',
            Value : Plant,
            Label : 'Plant'
        },
        {
            $Type : 'UI.DataField',
            Value : PurOrg,
            Label : 'PurOrg'
        },
        {
            $Type : 'UI.DataField',
            Value : Material,
            Label : 'Material'
        },
        {
            $Type : 'UI.DataField',
            Value : Material_Description,
            Label : 'Material Description'
        }
    ],

    // reference facet 

    UI.FieldGroup #Spiderman: {
        Data : [
            {
                $Type : 'UI.DataField',
                Value : Quantity,
                Label : 'Quantity'
            },
            {
                $Type : 'UI.DataField',
                Value : UnitPrice,
                Label : 'Unit Price'
            },
            {
               $Type : 'UI.DataField',
                Value : UoM,
                Label : 'Unit of Mass'
            },
            {
                $Type : 'UI.DataField',
                Value : Currency_code,
                Label : 'Currency'
            },
            {
                $Type : 'UI.DataField',
                Value : Price,
                Label : 'Price'
            }
        ],
    }

);

// refreshing the page when deleted 
annotate service.Request_Header @(Common.SideEffects #ReactonItemDeletion: {
    SourceEntities  : [_Items],   // The source entity being modified (deleted in this case)
    TargetEntities  : ['_Items'], // The target collection/table to be refreshed (the list of bookings)
    TargetProperties: []  // This can be left empty or specify relevant properties if needed
});


annotate service.Request_Header @(Common.SideEffects #ReactOnCommentCreation: {
    SourceEntities  : ['_Comments'],      // The entity triggering the side effect (Comments)
    TargetEntities  : ['_Comments'],          // Refresh the current Request_Header entity
    TargetProperties: []                  // Refresh all relevant fields, no specific property defined
});




// disable the status field so that no one can edit during create or edit 

annotate service.Request_Header with {
    Status_Code  @(
        readonly,
    );
    Request_No  @(
        readonly,
    );
    TotalPrice  @(
        readonly,
    );
};


annotate service.Request_Item {
    Material @Common.ValueList: { 
        CollectionPath : 'MaterialSet', 
    Parameters : [ 
      {$Type: 'Common.ValueListParameterInOut', LocalDataProperty: Material, ValueListProperty: 'ID'},
      {$Type: 'Common.ValueListParameterOut', LocalDataProperty: Material_Description, ValueListProperty: 'Desc'},   
    ] 
    }
}


annotate service.Request_Item {
    Plant @Common.ValueList: { 
        CollectionPath : 'PlantSet', 
    Parameters : [ 
      {$Type: 'Common.ValueListParameterOut', LocalDataProperty: Plant, ValueListProperty: 'plant'}
    ] 
    }
}


