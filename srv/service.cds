using { indirectreq.ust.db.transaction as my } from '../db/schema';

service Myservice @(path:'IndirectReq' ){

    entity Request_Header @(odata.draft.enabled: true ) as projection on my.Request_Header
     actions{
        action sendforapproval();
    };
    
    
}