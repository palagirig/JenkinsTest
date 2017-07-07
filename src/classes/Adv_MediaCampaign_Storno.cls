// class for KV: 02512
public class Adv_MediaCampaign_Storno{

    public static void setToStorno(Boolean isAfter, Boolean isBefore, Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate, List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems){
        
        if(lstNewItems.size() != 1) return;
        
        ADvendio__MediaCampaign__c objMC = (ADvendio__MediaCampaign__c) lstNewItems[0];
        ADvendio__MediaCampaign__c objMCOld = (ADvendio__MediaCampaign__c) mapOldItems.get(objMC.ID);              
        
        // If Set to Cancellation, Offer denied
        if(objMC.ADvendio__Reason_for_refusal__c == 'Cancellation' && objMC.ADvendio__Stage__c == 'Offer denied' && !(objMCOld.ADvendio__Reason_for_refusal__c == 'Cancellation' && objMCOld.ADvendio__Stage__c == 'Offer denied')){

            Boolean bAllowSaving = true;
            
            List<ADvendio__Campaign_Item__c> listCI = new List<ADvendio__Campaign_Item__c>([SELECT SomDig_AdServerRelevant__c, ADvendio__Delivered_Impressions__c, ADvendio__from_Date__c, ADvendio__Rate_Discount_4_Name__c FROM ADvendio__Campaign_Item__c WHERE ADvendio__Media_Campaign__c = :objMC.ID]);
            
            // Filter for Ticket 03817
            if(UserInfo.getProfileId().contains('00eD0000001Qk4n') && objMC.ADvendio__BillMe__c == false) {
                Boolean bAllCIsAreStorno = true;
                for(ADvendio__Campaign_Item__c ci : listCI) {
                    if(ci.ADvendio__Rate_Discount_4_Name__c == null || !ci.ADvendio__Rate_Discount_4_Name__c.contains('Storno')) {
                        bAllCIsAreStorno = false;
                        break;
                    }
                }
                if(bAllCIsAreStorno) return;
            }

            for(ADvendio__Campaign_Item__c o : listCI){                   
                if(o.ADvendio__from_Date__c <= System.Today())                        
                    bAllowSaving = false;
            }
            
            if(bAllowSaving){
                List<ADvendio__Campaign_Item__c> listUpdateCI = new List<ADvendio__Campaign_Item__c>();
                for(ADvendio__Campaign_Item__c o : listCI){
                    if(o.SomDig_AdServerRelevant__c){
                        o.ADvendio__AdserverStatus__c = 'Released';
                        listUpdateCI.add(o);
                    }
                }
                update listUpdateCI;    

            }else
                objMC.addError('Die Mediakampagne darf nicht von Sales storniert werden, da sie bereits angelaufen ist.');       

        }
    }
}