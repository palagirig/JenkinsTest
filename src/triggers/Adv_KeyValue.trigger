/**
 *  This trigger controls the events on ADvendio__KeyValue__c and modifies data if required.
 */
trigger Adv_KeyValue on ADvendio__KeyValue__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

    
    if (Trigger.isAfter && Trigger.isInsert) {
    	Adv_CampaignItem_AutoPopulationKv.addBt0KeyLine(trigger.new);
    }
}