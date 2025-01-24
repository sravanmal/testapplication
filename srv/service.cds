using { indirectreq.ust.db.transaction as my } from '../db/schema';

service Myservice @(path:'IndirectReq' ){

    entity Request_Header @(odata.draft.enabled: true ) as projection on my.Request_Header
     actions{
        action sendforapproval();
        action responsefrombpa(status : String , ID : UUID) ;
    };

    entity MaterialSet as projection on my.material;
    entity PlantSet as projection on my.plant;
    
    
}