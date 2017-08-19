public with sharing class Adv_InvoiceItem_FieldChanges extends TriggerController {
    public Adv_InvoiceItem_FieldChanges(Boolean isAfter, Boolean isBefore, Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate,
                                        List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems) {
        super(isAfter, isBefore, isDelete, isInsert, isUndelete, isUpdate, lstNewItems, mapNewItems, lstOldItems, mapOldItems);
    }
    protected override void runBeforeInsert() {
    	setLineDescription((List<ADvendio__InvoiceItem__c>) lstNewItems, (Map<Id, ADvendio__InvoiceItem__c>) mapOldItems);
    }
    
    protected override void runBeforeUpdate() {
        setLineDescription((List<ADvendio__InvoiceItem__c>) lstNewItems, (Map<Id, ADvendio__InvoiceItem__c>) mapOldItems);
    }

    private void setLineDescription(List<ADvendio__InvoiceItem__c> invoiceItems, Map<Id, ADvendio__InvoiceItem__c> oldInvoiceItems) {
    	Set<ID> campaignItemIDs = new Set<ID>();
    	for (ADvendio__InvoiceItem__c ii : invoiceItems) {
            if (isInsert ||
                ii.ADvendio__InvoicedQuantity__c    != oldInvoiceItems.get(ii.Id).ADvendio__InvoicedQuantity__c ||
                ii.SomDig_Naturalrabatt__c          != oldInvoiceItems.get(ii.Id).SomDig_Naturalrabatt__c ||
                ii.ADvendio__LineDescription__c     != oldInvoiceItems.get(ii.Id).ADvendio__LineDescription__c) {
                campaignItemIDs.add(ii.ADvendio__CampaignItem__c);
            }
        }

        Map<Id, ADvendio__Campaign_Item__c> campaignItems = new Map<Id, ADvendio__Campaign_Item__c>([SELECT Id, ADvendio__Quantity__c, SomDig_Menge__c, SomDig_Freitextnotiz__c, ADvendio__Rate_Discount_4_Name__c, SomDig_Naturalrabatt__c, SomDig_OtpAufschlag__c, SomDig_Retargeting__c, SomDig_Preiskriterium__c FROM ADvendio__Campaign_Item__c WHERE ID IN :campaignItemIDs]);

        for (ADvendio__InvoiceItem__c ii : invoiceItems) {
        	if(campaignItems.containsKey(ii.ADvendio__CampaignItem__c)) {
        		ADvendio__Campaign_Item__c ci = campaignItems.get(ii.ADvendio__CampaignItem__c);
                if(ii.SomDig_Naturalrabatt__c != null && ii.ADvendio__InvoicedQuantity__c != null) {
        			ci.SomDig_Menge__c = (ii.ADvendio__InvoicedQuantity__c / (100 + ii.SomDig_Naturalrabatt__c) * 100).round();
                }
                ci.ADvendio__Quantity__c = ii.ADvendio__InvoicedQuantity__c;
                ci.SomDig_Naturalrabatt__c = ii.SomDig_Naturalrabatt__c;
    			ii.ADvendio__LineDescription__c = Adv_CampaignItem_FieldChanges.buildLineDescription(ci,'abgerechnete Menge');

        	}
        }

    }   

}