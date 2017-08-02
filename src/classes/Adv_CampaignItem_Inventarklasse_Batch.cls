global class Adv_CampaignItem_Inventarklasse_Batch implements Database.Batchable<sObject>, Schedulable {
    
    public Adv_CampaignItem_Inventarklasse_Batch() {
        
    }
    
    global void execute(SchedulableContext sc) {
        Database.executeBatch(this, 20);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        String sQuery = 'SELECT SomDig_Inventarklasse__c, ADvendio__Ad_Price__c FROM ADvendio__Campaign_Item__c WHERE SomDig_Inventarklasse__c = NULL';
        
        return Database.getQueryLocator(sQuery);
    }
    
    global void execute(Database.BatchableContext bc, List<ADvendio__Campaign_Item__c> scope) {
        Adv_CampaignItem_Inventarklasse.setInventarklassen(scope);
        update scope;
    }
    
    global void finish(Database.BatchableContext bc) {
        
    }

}