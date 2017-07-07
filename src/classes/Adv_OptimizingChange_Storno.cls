/*
Used in Trigger "Adv_OptimizingChange".
Creates an Optimizing change record which sets the "Verkaufspreis" to 0, if the user chose "Storno mit Leistungsfluss" or "Kompensation"
KV 2517
*/
public class Adv_OptimizingChange_Storno extends TriggerController{

    public static final Id BILLING_PROFILE_ID	= '00eD0000001Qk4n';
    public static final Id SYSADM_PROFILE_ID	= '00e20000000lfOj';
    public static final Id BI_PROFILE_ID		= '00e570000012uRg';

     public Adv_OptimizingChange_Storno(Boolean isAfter, Boolean isBefore, Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate,
                                        List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems) {
        super(isAfter, isBefore, isDelete, isInsert, isUndelete, isUpdate, lstNewItems, mapNewItems, lstOldItems, mapOldItems);
    }
    
    protected override void runBeforeInsert() {
        preventStornoOhneLeistungsfluss((List<ADvendio__OptimizingChange__c>) lstNewItems);
        preventStornoMitLeistungsfluss((List<ADvendio__OptimizingChange__c>) lstNewItems);
    }
    
    private void preventStornoOhneLeistungsfluss(List<ADvendio__OptimizingChange__c> optChanges) {
    	Set<Id> canceldCampaignItems	= new Set<Id>();
    	for (ADvendio__OptimizingChange__c change : optChanges) {
    		if ('advendio__billingstatus__c'.equalsIgnoreCase(change.ADvendio__FieldName__c) &&
    			'canceled'.equalsIgnoreCase(change.ADvendio__OptimizedValue__c)) { // cancelled position (X)
    			canceldCampaignItems.add(change.ADvendio__CampaignItem__c);
    		}
    	}
    	
    	Set<Id> blockedCampaignItems	= new Set<Id>();
    	if (!canceldCampaignItems.isEmpty()) {
    		for (ADvendio__Campaign_Item__c ci : [SELECT Id  FROM ADvendio__Campaign_Item__c WHERE Id IN :canceldCampaignItems AND ADvendio__From_Date__c <= TODAY]) {
    			blockedCampaignItems.add(ci.Id);
    		}
    	}
    	
    	if (!blockedCampaignItems.isEmpty()) {
    		for (ADvendio__OptimizingChange__c change : optChanges) {
    			if (blockedCampaignItems.contains(change.ADvendio__CampaignItem__c)) {
    				change.addError('Es darf kein Positionstorno vor Leistungsfluss durchgeführt werden, wenn die Position bereits gestartet ist.');
	    		}
    		}
    	}
    }
    
	private void preventStornoMitLeistungsfluss(List<ADvendio__OptimizingChange__c> optChanges){
        Set<Id> canceldCampaignItems = new Set<Id>();
		for (ADvendio__OptimizingChange__c change : optChanges) {
            if(change.ADvendio__FieldName__c == 'advendio__rate_discount_4_name__c' && change.ADvendio__OptimizedValue__c == 'Storno mit Leistungsfluss') {
                canceldCampaignItems.add(change.ADvendio__CampaignItem__c);
			}
		}
		
		if(canceldCampaignItems.size() > 0){
            // Check if there are Invoiced or Reviewed Invoices for the optimized Campaign Items
            Integer invoiceItems = [SELECT Count() FROM ADVendio__InvoiceItem__c WHERE ADvendio__CampaignItem__c IN :canceldCampaignItems AND (ADvendio__Invoice__r.ADvendio__Status__c = 'Invoiced' OR ADvendio__Invoice__r.ADvendio__Status__c = 'Reviewed')];
            
            if(invoiceItems > 0 || (!isUserBilling() && !isUserAdmin() && !isUserTeamLead() && !isUserBI())) {
                optChanges[0].addError(Label.Adv_OptimizingChange_Storno_ErrorMessage);
            }
        }
	}

    @TestVisible
    private static Boolean isUserAdmin() {
        return UserInfo.getProfileId().contains(SYSADM_PROFILE_ID);
    }

    @TestVisible
    private static Boolean isUserBilling() {
        return UserInfo.getProfileId().contains(BILLING_PROFILE_ID);
    }

    @TestVisible
    private static Boolean isUserBI() {
        return UserInfo.getProfileId().contains(BI_PROFILE_ID);
    }   

    @TestVisible
    private static Boolean isUserTeamLead() {
        return currentUser.SomDig_IsTeamLead__c;
    }

    private static User currentUser {
        get {
            if(currentUser == null) currentUser = [SELECT SomDig_IsTeamLead__c FROM User WHERE ID = :UserInfo.getUserId() LIMIT 1];
            return currentUser;
        }
        set; 
    }

}