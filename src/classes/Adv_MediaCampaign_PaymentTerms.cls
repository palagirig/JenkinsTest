public with sharing class Adv_MediaCampaign_PaymentTerms extends TriggerController {

    public Adv_MediaCampaign_PaymentTerms(Boolean isAfter, Boolean isBefore, Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate,
                                          List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems) {
        super(isAfter, isBefore, isDelete, isInsert, isUndelete, isUpdate, lstNewItems, mapNewItems, lstOldItems, mapOldItems);
    }

    protected override void runBeforeInsert() {
        inheritPaymentTerms((List<ADvendio__MediaCampaign__c>)lstNewItems);
        switchPaymentTermsLanguage((List<ADvendio__MediaCampaign__c>)lstNewItems, null);
    }

    protected override void runBeforeUpdate() {
        inheritPaymentTerms((List<ADvendio__MediaCampaign__c>)lstNewItems);
        switchPaymentTermsLanguage((List<ADvendio__MediaCampaign__c>)lstNewItems, (Map<Id, ADvendio__MediaCampaign__c>) mapOldItems);
    }

	/**
	 * set proper payment-terms-text (ADvendio__PaymentTerms__c) according to choosen payment terms (SomDig_Zahlungsbedingung__c) and language (ADvendio__Quote_Language__c)
	 * @param	a list of media campaigns (trigger.new)
	 * @param	a map of media campaigns with their Id as key (trigger.oldMap) 
	 **/
    private void switchPaymentTermsLanguage(List<ADvendio__MediaCampaign__c> mediaCampaigns, Map<Id, ADvendio__MediaCampaign__c> oldMediaCampaignById) {
        Map<Id, SomDig_Zahlungsbedingung__c> paymentTermsById	= new Map<Id, SomDig_Zahlungsbedingung__c>();
        // check for todos
        for (ADvendio__MediaCampaign__c mc : mediaCampaigns) {
            if (isInsert ||
                mc.SomDig_Zahlungsbedingung__c	!= oldMediaCampaignById.get(mc.Id).SomDig_Zahlungsbedingung__c ||
               	mc.ADvendio__Quote_Language__c	!= oldMediaCampaignById.get(mc.Id).ADvendio__Quote_Language__c ||
              	mc.ADvendio__PaymentTerms__c	!= oldMediaCampaignById.get(mc.Id).ADvendio__PaymentTerms__c) {
                
                paymentTermsById.put(mc.SomDig_Zahlungsbedingung__c, null);
            }
        }
        
        if (!paymentTermsById.isEmpty()) {
            // get information for relevant payment terms
            for (SomDig_Zahlungsbedingung__c paymentTerms : [SELECT Id,
                                                             		Name,
                                                             		SomDig_ZahlungsbedingungEnglisch__c
                                                             FROM SomDig_Zahlungsbedingung__c
                                                             WHERE Id IN :paymentTermsById.keySet()]) {
                paymentTermsById.put(paymentTerms.Id, paymentTerms);
            }
            
            for (ADvendio__MediaCampaign__c mc : mediaCampaigns) {
                if (paymentTermsById.containsKey(mc.SomDig_Zahlungsbedingung__c)) {
                    // clear payment-terms-text if no payment term is choosen
                    if (mc.SomDig_Zahlungsbedingung__c == null) {
                        mc.ADvendio__PaymentTerms__c	= null;
                    }
                    // german payment-terms-text if german is choosen as language or no english term is given
                    else if ('German'.equalsIgnoreCase(mc.ADvendio__Quote_Language__c) ||
                             paymentTermsById.get(mc.SomDig_Zahlungsbedingung__c).SomDig_ZahlungsbedingungEnglisch__c == null) {
                        mc.ADvendio__PaymentTerms__c	= paymentTermsById.get(mc.SomDig_Zahlungsbedingung__c).Name;
                    }
                    // english payment-terms-text for other languages - incl. no given language
                    else {
                        mc.ADvendio__PaymentTerms__c	= paymentTermsById.get(mc.SomDig_Zahlungsbedingung__c).SomDig_ZahlungsbedingungEnglisch__c;
                    }
                }
            }
        }
    }
    
    /*
     * Initialize a static variable for the default SomDig_Zahlungsbedingung__c
     */
    private static SomDig_Zahlungsbedingung__c[] defaultPaymentTerms {
        get {
            if (defaultPaymentTerms == null) {
                defaultPaymentTerms = [Select Id FROM SomDig_Zahlungsbedingung__c WHERE SomDig_SAPCode__c = 'ZB01'];
            }
            return defaultPaymentTerms;
        }
        set;
    }

    /*
     * Set the default SomDig_Zahlungsbedingung__c for all MediaCampaigns in the trigger context
     */
    private void inheritPaymentTerms(List<ADvendio__MediaCampaign__c> lstNewRecords) {
        if (!defaultPaymentTerms.isEmpty()) {
            for (ADvendio__MediaCampaign__c mc : lstNewRecords) {
                if (mc.SomDig_Zahlungsbedingung__c == null) {
                    mc.SomDig_Zahlungsbedingung__c = defaultPaymentTerms[0].Id;
                }
            }
        }
    }
}