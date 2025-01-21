using { indirectreq.ust.db.transaction as my } from '../db/schema';
using { Attachments } from '@cap-js/sdm';

extend my.Request_Header with { attachments: Composition of many Attachments }