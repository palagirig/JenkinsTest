/*
 *   // KV 04273 Löschen Kamp.Position verhindern, wenn Rechnungspositionen existieren
 */
public class Adv_CampaignItem_DeleteBlocker extends TriggerController {
    
    public Adv_CampaignItem_DeleteBlocker(Boolean isAfter, Boolean isBefore, Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate,
                                        List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems) {
        super(isAfter, isBefore, isDelete, isInsert, isUndelete, isUpdate, lstNewItems, mapNewItems, lstOldItems, mapOldItems);
    }

    protected override void runBeforeDelete() {
        preventDelete((List<ADvendio__Campaign_Item__c>) lstOldItems, (Map<Id, ADvendio__Campaign_Item__c>) mapOldItems);
    }

    private void preventDelete(List<ADvendio__Campaign_Item__c> listCampaignItems, Map<Id, ADvendio__Campaign_Item__c> mapCampaignItems) {
        List<ADvendio__InvoiceItem__c> invoiceItems = new List<ADvendio__InvoiceItem__c>([SELECT Id FROM ADvendio__InvoiceItem__c WHERE ADvendio__CampaignItem__c IN :mapCampaignItems.keySet()]);
        if(invoiceItems.size() > 0) {
            listCampaignItems[0].addError(Label.Adv_CampaignItem_DeleteBlocker_Message);
        }
    }

}