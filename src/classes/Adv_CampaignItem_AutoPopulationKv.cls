public with sharing class Adv_CampaignItem_AutoPopulationKv {
    // before update, remove Behavioural Targeting=0 from ADvendio__AdKeyValues__c
    public static void removeBt0(Map<Id, ADvendio__Campaign_Item__c> triggerNewMap, Map<Id, ADvendio__Campaign_Item__c> triggerOldMap) {
        Set<Id> changedItemIds = new Set<Id>();
        for (Id id : triggerNewMap.keySet()) {
            if (triggerNewMap.get(id).ADvendio__AdKeyValues__c != triggerOldMap.get(id).ADvendio__AdKeyValues__c) {
                changedItemIds.add(id);
            }
        }
        for (Id id : changedItemIds) {
            triggerNewMap.get(id).ADvendio__AdKeyValues__c = removeBt0String(triggerNewMap.get(id).ADvendio__AdKeyValues__c);
        }
    }
    
    // before insert, remove Behavioural Targeting=0 from ADvendio__AdKeyValues__c
    public static void removeBt0(List<ADvendio__Campaign_Item__c> triggerNew) {
        for (ADvendio__Campaign_Item__c ci : triggerNew) {
            ci.ADvendio__AdKeyValues__c = removeBt0String(ci.ADvendio__AdKeyValues__c);
        }
    }
    
    // remove Behavioural Targeting=0 and operators from a key value string.
    private static String removeBt0String(String kvString) {
        if (kvString != null) {
            return kvString.replace(' OR ((Behavioural Targeting=0))','')
                            .replace('((Behavioural Targeting=0)) OR ','')
                            .replace(' AND (Behavioural Targeting=0)','')
                            .replace('(Behavioural Targeting=0) AND ','')
                            .replace('((Behavioural Targeting=0))','');
        } else {
            return null;
        }
    }
    
    /** Salesforce id of the key named "Behavioural Targeting"*/
    private static String btKeyId {
	    get {
	    	if (btKeyId == null) {
	    		List<ADvendio__Key__c> btKeys = [SELECT Id FROM ADvendio__Key__c WHERE Name='Behavioural Targeting'];
	    		if (btKeys.size() == 1) {
	    			btKeyId = btKeys[0].Id;
	    		}
	    	}
	    	return btKeyId;
	    }
	    set;
    }
    
    /** Add a keyline with Behavioural Targeting=0 if there is one key with SomDig_TargetingProvider__c=nugg.ad*/
    public static void addBt0KeyLine(List<ADvendio__KeyValue__c> triggerNew) {
    	if (btKeyId != null) {
    		// collect data
    		Set<Id> affectedCis = new Set<Id>();
    		for (ADvendio__KeyValue__c kv : [SELECT ADvendio__Key__c, ADvendio__KeyLine__r.ADvendio__CampaignItem__c 
    										FROM ADvendio__KeyValue__c 
    										WHERE Id IN :triggerNew 
    												AND ADvendio__KeyLine__r.ADvendio__CampaignItem__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_Multiscreen__c = true
    												AND ADvendio__KeyLine__r.ADvendio__CampaignItem__r.SomDig_MediagattungsDifferenzierungName__c = 'InStream/Video']) {
   				affectedCis.add(kv.ADvendio__KeyLine__r.ADvendio__CampaignItem__c);
    		}
    		// check if Behavioural Targeting=0 is required
	    	Set<Id> ciIdsWithNugAdd = new Set<Id>();
	    	Set<Id> ciIdsWithBt0 = new Set<Id>();
	    	for (ADvendio__KeyValue__c kv : [SELECT Id, ADvendio__Values__c, ADvendio__Key__r.Name, ADvendio__Key__r.SomDig_TargetingProvider__c, 
	    											ADvendio__KeyLine__r.ADvendio__CampaignItem__c, 
	    											ADvendio__KeyLine__r.ADvendio__CampaignItem__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_Multiscreen__c 
	    									FROM ADvendio__KeyValue__c 
	    									WHERE ADvendio__KeyLine__r.ADvendio__CampaignItem__c IN :affectedCis]) {
	    		if (kv.ADvendio__Key__r.SomDig_TargetingProvider__c != null && kv.ADvendio__Key__r.SomDig_TargetingProvider__c.contains('nugg.ad')) {
	    			ciIdsWithNugAdd.add(kv.ADvendio__KeyLine__r.ADvendio__CampaignItem__c);
	    		}
	    		if (kv.ADvendio__Key__c == btKeyId && kv.ADvendio__Values__c.startsWith('0')) {
	    			ciIdsWithBt0.add(kv.ADvendio__KeyLine__r.ADvendio__CampaignItem__c);
	    		}
	    	}
	    	
	    	// check for wrong Behavioural Targeting=0 keylines
	    	for (Id ciId : ciIdsWithBt0) {
	    		if (!ciIdsWithNugAdd.contains(ciId)) {
	    			throw new AutoPopulationKeyValuesException('Behavioural Targeting=0 Key Values sind nur in Kombination mit nugg.ad Keys erlaubt. Bitte entfernen Sie Behavioural Targeting=0!');
	    		}
	    	}
	    	
	    	// add key line
	    	List<ADvendio__KeyLine__c> newKeyLines = new List<ADvendio__KeyLine__c>();
	    	for (Id ciId : ciIdsWithNugAdd) {
	    		if (!ciIdsWithBt0.contains(ciId)) {
	    			newKeyLines.add(new ADvendio__KeyLine__c(ADvendio__CampaignItem__c = ciId));
	    		}
	    	}
	    	insert newKeyLines;
	    	
	    	// add key Value
	    	List<ADvendio__KeyValue__c> newKeyValues = new List<ADvendio__KeyValue__c>();
	    	for (ADvendio__KeyLine__c keyLine : newKeyLines) {
	    		newKeyValues.add(new ADvendio__KeyValue__c(ADvendio__KeyLine__c = keyLine.Id, ADvendio__Key__c = btKeyId, ADvendio__Values__c = '0', ADvendio__Operator__c = 'equal to'));
	    	}
	    	insert newKeyValues;
    	} else {
    		if (ApexPages.currentPage() != null) {
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Es wurde kein Key mit dem Namen "Behavioural Targeting" gefunden'));
    		}
    	}
    }

	public class AutoPopulationKeyValuesException extends Exception {}
}