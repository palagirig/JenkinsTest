public class P7S1_ExternalID_DebNrSync{
    /**
    * Sync the debitornumber from the P7S1_ExternalId__c to the account
    * 
    * @param trigger.new (List<P7S1_ExternalId__c>)
    **/
    public static void getDebitor(List<P7S1_ExternalId__c> lstExtId, Map<Id, P7S1_ExternalId__c> mapOldItems, Boolean isInsert, Boolean isUpdate) {
        Set<Id> accountIDs = new Set<Id>(); 

        P7S1_ExternalId__c oldObjExtId;
        
        for(P7S1_ExternalId__c objExtId : lstExtID){
            
            oldObjExtId = isUpdate ? mapOldItems.get(objExtId.Id) : null;
                
            if(isInsert && isValidSource(objExtId)) {
                accountIDs.add(objExtId.P7S1_Account__c);
            } else if(isUpdate && isSourceChanged(objExtId, oldObjExtId) && isValidSource(objExtId)) {
                accountIDs.add(objExtId.P7S1_Account__c);
            } else if(isUpdate && isNameChanged(objExtId, oldObjExtId))
                accountIDs.add(objExtId.P7S1_Account__c);

        }
        
        if(accountIDs.isEmpty()) return;
        
        Map<Id, Account> mapAccounts = new Map<Id, Account>([SELECT Id, SomDig_Debitorennr__c, SomDig_DebitorennrBarter__c FROM Account WHERE ID in :accountIDs]);
        for(P7S1_ExternalId__c objExtId: lstExtID){
            if(objExtId.P7S1_Source__c == 'Debitorennr BK 29') mapAccounts.get(objExtId.P7S1_Account__c).SomDig_Debitorennr__c = objExtId.Name;
            else if(objExtId.P7S1_Source__c == 'Debitorennr BK 29 - Barter') mapAccounts.get(objExtId.P7S1_Account__c).SomDig_DebitorennrBarter__c = objExtId.Name;
        }

        update mapAccounts.values();

    }
    
    private static Boolean isValidSource(P7S1_ExternalId__c objExtId) {
        return (objExtId.P7S1_Source__c == 'Debitorennr BK 29' || objExtId.P7S1_Source__c == 'Debitorennr BK 29 - Barter');
    }

    private static Boolean isSourceChanged(P7S1_ExternalId__c objExtId, P7S1_ExternalId__c oldObjExtId) {
        return objExtId.P7S1_Source__c != oldObjExtId.P7S1_Source__c;
    }

    private static Boolean isNameChanged(P7S1_ExternalId__c objExtId, P7S1_ExternalId__c oldObjExtId) {
        return objExtId.Name != oldObjExtId.Name;
    }


    public static void removeDebitor(List<P7S1_ExternalId__c> lstExtId){
        Set<Id> setId = new Set<Id>();
        
        for(P7S1_ExternalId__c objExtId: lstExtID){
            if(!(objExtId.P7S1_Source__c == 'Debitorennr BK 29' || objExtId.P7S1_Source__c == 'Debitorennr BK 29 - Barter')) continue;
            setId.add(objExtId.P7S1_Account__c);
        }
        
        if(setId.isEmpty()) return;
        
        Map<Id, Account> mapAccounts = new Map<Id, Account>([SELECT Id, SomDig_Debitorennr__c, SomDig_DebitorennrBarter__c FROM Account WHERE ID in :setId]);
 
        
        for(P7S1_ExternalId__c objExtId: lstExtID){
            if(objExtId.P7S1_Source__c == 'Debitorennr BK 29'){
                mapAccounts.get(objExtId.P7S1_Account__c).SomDig_Debitorennr__c = '';
            }
            else if(objExtId.P7S1_Source__c == 'Debitorennr BK 29 - Barter'){
                mapAccounts.get(objExtId.P7S1_Account__c).SomDig_DebitorennrBarter__c = '';
            }
        }
        
        update mapAccounts.values();
    }
}