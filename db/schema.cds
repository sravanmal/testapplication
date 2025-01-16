using {
    cuid,
    managed,
    Currency
} from '@sap/cds/common';


namespace indirectreq.ust.db;

context transaction {

    //request header entity

    entity Request_Header : cuid, managed {

        PR_Number           : String(10) @readonly; // PR number
        Status_Code         : String     @readonly enum {
            InApproval = 'I';
            Approved   = 'A';
            Rejected   = 'R';
            Saved      = 'S';
            Open       = 'OP';
        } default 'Open'; // Status Code
        PRType              : String; // PR type
        _Items              : Composition of many Request_Item
                                  on _Items._Header = $self; // items
        Request_Description : String     @mandatory; //  .Request Description
        _Comments           : Composition of many Comments
                                  on _Comments._headercomment = $self; // comments
        Request_No          : String(10); // Request No
        _attachments        : Composition of many media
                                  on _attachments._HeaderAttachments = $self;
        TotalPrice          : Integer;

    }

    // request items entity

    entity Request_Item : cuid, managed {

        PR_Item_Number       : String(10); // PR number
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
        Req_Item_No          : Integer; // Request Item Number
        _Header              : Association to Request_Header;

    }


    // Comments entity

    entity Comments : cuid, managed {
        _headercomment : Association to Request_Header;
        text           : String // Text
    }


    // media
    entity media : cuid, managed {
        @Core.ContentDisposition.Filename: fileName
        @Core.ContentDisposition.Type    : 'inline'
        _HeaderAttachments : Association to Request_Header;

        @Core.MediaType                  : MediaType
        content            : LargeBinary;
        fileName           : String;

        @Core.IsMediaType                : true
        MediaType          : String;
        size               : Integer;
        url                : String;

    }


}
