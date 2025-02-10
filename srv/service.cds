using { indirectreq.ust.db.transaction as my } from '../db/schema';

service Myservice @(path:'IndirectReq' ){

    @Common.SideEffects: {TargetProperties: ['/Myservice/Request_Header/Status_Code']}
     action responsefrombpa(status : String , ID : String(10));
     
    @Common.SideEffects: {TargetEntities: ['/Myservice/Request_Header/Status_Code']}
    action responsefrombparejected(status : String , ID : String(10));

    entity Request_Header @(odata.draft.enabled: true ) as projection on my.Request_Header{
        *,
         case Status_Code
            when 'P' then 'Inapproval'
            when 'N' then 'Saved'
            when 'O' then 'Open'
            when 'A' then 'Approved'
            when 'X' then 'Rejected'
            end as Status_Code : String(10),
        case Status_Code
            when 'P' then 2
            when 'O' then 2
            when 'N' then 2
            when 'A' then 3
            when 'X' then 1
            end as ColorCode : Integer,
    }
     actions{
        @Common.SideEffects : {
            TargetProperties : [
                'in/Status_Code',
                'in/insertrestrictions'
            ]
        }
        action sendforapproval() ;
        action copyheader() returns {
            ID : UUID;
        }
    };
    
    

    entity MaterialSet as projection on my.material;
    entity PlantSet as projection on my.plant;
    entity plantapi as projection on my.plantapi;
    
    
}