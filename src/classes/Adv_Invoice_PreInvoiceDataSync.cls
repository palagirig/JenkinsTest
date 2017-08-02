public class Adv_Invoice_PreInvoiceDataSync {
private static boolean hasRun = false;
public static final Set<Schema.SObjectField> accountFields = new Set<Schema.SObjectField>{
  Account.BillingCountry,
  Account.BillingCity,
  Account.BillingPostalCode,
  Account.BillingState,
  Account.BillingStreet,
  Account.P7S1_Konzernmitglied__c,
  Account.P7S1_Steuerkennzeichen__c,
  Account.ADvendio__VATID__c,
  Account.AccountNumber,
  Account.ADvendio__InvoiceEmail__c,
  Account.Name
};

    public static void syncDataToPreInvoices(List<sObject> listObject, Map<Id, sObject> mapOldItems, String sObjName){
        if(System.isBatch() || System.isFuture() || System.isQueueable() || System.isScheduled() || (Limits.getQueries() > Limits.getLimitQueries()*0.75) || hasRun)
            return;
        Set<Id> setAffectedRecords = new Set<Id>();
        Set<Id> setCampaignIds = new Set<ID>();
            
        //setAffectedRecords = filter(listObject, mapOldItems, sObjName);
        if(sObjName == 'Account'){
            setAffectedRecords = filterAccounts((List<Account>)listObject, (Map<Id,Account>)mapOldItems);
            setCampaignIds = getMediaCampaignsFromAccounts(setAffectedRecords); 
        }
        else if(sObjName == 'ADvendio__Campaign_Item__c'){
            setAffectedRecords = filterCampItems((List<ADvendio__Campaign_Item__c>) listObject, (Map<Id, ADvendio__Campaign_Item__c>)mapOldItems);
            setCampaignIds = getMediaCampaignsFromCampaignItems(setAffectedRecords);
        }
        else if(sObjName == 'ADvendio__MediaCampaign__c'){
            setAffectedRecords = filterMediaCamps((List<ADvendio__MediaCampaign__c>) listObject, (Map<Id,ADvendio__MediaCampaign__c>)mapOldItems);
            setCampaignIds = setAffectedRecords;
        }
        
        // To-Do: start the batchjob with the ids in setCampaignIds
        //System.debug('### Resultset: '+setCampaignIds);
        
        // Ticket 03981, skip test from ADvendio batch for testing reasons. only one batch per testmethod
        if(setCampaignIds != NULL && !setCampaignIds.isEmpty()){
            hasRun = true;
            if(!Test.isRunningTest()){
                Adv_Invoice_PreInvoiceDeleteInsert c = new Adv_Invoice_PreInvoiceDeleteInsert();
                
                c.setRecordIds(setCampaignIds);
                c.deletePreInvoice();
                c.createPreInvoice();
            }
        }
    }
    
    /*
     * 
    @TestVisible
    private static Set<Id> filter(List<sObject> listObject, Map<Id, sObject> mapOldItems, String sObjName){
        Set<Id> resultSet = new Set<Id>();

        List<Mapping_BA_Fieldlist__c> listFields = Mapping_BA_Fieldlist__c.getAll().values();
        for(Integer i = 0;i<listFields.size();i++){
            if(listFields[i].Object__c != sObjName){
                listFields.remove(i);
                i--;
            }
        }
        
        for(SObject obj: listObject){
            if(!mapOldItems.containsKey(obj.Id))
                continue;
            for(Mapping_BA_Fieldlist__c field: listFields){
                if(obj.get(field.Field__c) != mapOldItems.get(obj.Id).get(field.Field__c)){
                    resultSet.add(obj.Id);    
                    break;
                }
            }         
        }        
        return resultSet;
    }*/
    
    @TestVisible
    private static Set<Id> filterMediaCamps(List<ADvendio__MediaCampaign__c> lstCamps, Map<Id,ADvendio__MediaCampaign__c> mapOldCamps){
        Set<Id> resultSet = new Set<Id>();
        
        for(ADvendio__MediaCampaign__c camp: lstCamps){
            if(!mapOldCamps.containsKey(camp.Id))
                continue;
            
            ADvendio__MediaCampaign__c oldCamp = mapOldCamps.get(camp.id);
            if(camp.ADvendio__Account__c != oldCamp.ADvendio__Account__c
               || camp.ADvendio__Agency__c != oldCamp.ADvendio__Agency__c
               || camp.ADvendio__your_reference_number2__c != oldCamp.ADvendio__your_reference_number2__c
               || camp.ADvendio__Third_party_commission__c != oldCamp.ADvendio__Third_party_commission__c
               || camp.SomDig_VATExempt__c != oldCamp.SomDig_VATExempt__c
               || camp.SomDig_DebitorennrHelp__c != oldCamp.SomDig_DebitorennrHelp__c
               || camp.ADvendio__Show_Third_Party_Commission__c != oldCamp.ADvendio__Show_Third_Party_Commission__c
               || camp.ADvendio__ReverseChargeMechanism__c != oldCamp.ADvendio__ReverseChargeMechanism__c
               || camp.ADvendio__Rate_Discount_3__c != oldCamp.ADvendio__Rate_Discount_3__c
               || camp.ADvendio__Rate_Discount_2__c != oldCamp.ADvendio__Rate_Discount_2__c
               || camp.ADvendio__Rate_Discount_1__c != oldCamp.ADvendio__Rate_Discount_1__c
               || camp.ADvendio__Quote_Locale__c != oldCamp.ADvendio__Quote_Locale__c
               || camp.ADvendio__Quote_Language__c != oldCamp.ADvendio__Quote_Language__c
               || camp.ADvendio__Pricelist__c != oldCamp.ADvendio__Pricelist__c
               || camp.ADvendio__PostalRecipient__c != oldCamp.ADvendio__PostalRecipient__c
               || camp.ADvendio__BillMe__c != oldCamp.ADvendio__BillMe__c
               || camp.ADvendio__Campaign_End_Date__c != oldCamp.ADvendio__Campaign_End_Date__c
               || camp.ADvendio__Campaign_Start_Date__c != oldCamp.ADvendio__Campaign_Start_Date__c
               || camp.CurrencyIsoCode != oldCamp.CurrencyIsoCode
               || camp.ADvendio__Dispatch__c != oldCamp.ADvendio__Dispatch__c
               || camp.ADvendio__external_Media_Campaign_Name__c != oldCamp.ADvendio__external_Media_Campaign_Name__c
               || camp.ADvendio__Intermediary__c != oldCamp.ADvendio__Intermediary__c
               || camp.ADvendio__invoice_recipient__c != oldCamp.ADvendio__invoice_recipient__c
               || camp.ADvendio__MediaCampaignFullNumber__c != oldCamp.ADvendio__MediaCampaignFullNumber__c
               || camp.Name != oldCamp.Name
               || camp.P7S1_IdOld__c != oldCamp.P7S1_IdOld__c
               || camp.ADvendio__PaymentDueDate__c != oldCamp.ADvendio__PaymentDueDate__c
               || camp.ADvendio__PaymentInterval__c != oldCamp.ADvendio__PaymentInterval__c
               || camp.ADvendio__PaymentStart__c != oldCamp.ADvendio__PaymentStart__c
               || camp.ADvendio__PaymentTerms__c != oldCamp.ADvendio__PaymentTerms__c
               || camp.ADvendio__Description__c != oldCamp.ADvendio__Description__c){
                   resultSet.add(camp.id);
               }
        }
        
        return resultSet;
    }

    public static Boolean hasAccountFieldChanged(Account newAcc, Account oldAcc) {
      Boolean isChanged = false;
      for(Schema.SObjectField fieldName : accountFields) {
        if(newAcc.get(fieldName) != oldAcc.get(fieldName)) {
          isChanged = true;
          break;
        }
      }
      return isChanged;
    }
    
    @TestVisible
    private static Set<Id> filterAccounts(List<Account> lstAcc,  Map<Id, Account> mapOldAcc){
        Set<Id> resultSet = new Set<Id>();
        
        for(Account acc: lstAcc){
            if(!mapOldAcc.containsKey(acc.Id))
                continue;
            
            Account oldAcc = mapOldAcc.get(acc.id);
            System.debug('### Acc.Name: '+acc.Name+' / oldAcc.Name: '+oldAcc.Name);
            if(hasAccountFieldChanged(acc, oldAcc)){
                resultSet.add(acc.Id);
            }
        }
        
        return resultSet;
    }


    
    @TestVisible
    private static Set<Id> filterCampItems(List<ADvendio__Campaign_Item__c> lstItems,  Map<Id, ADvendio__Campaign_Item__c> mapOldItems){
        Set<Id> resultSet = new Set<Id>();
        
        for(ADvendio__Campaign_Item__c item: lstItems){
            if(!mapOldItems.containsKey(item.Id))
                continue;
            
            ADvendio__Campaign_Item__c oldItem = mapOldItems.get(item.id);
            if(  item.ADvendio__Rate_Discount_4__c != oldItem.ADvendio__Rate_Discount_4__c
              || item.ADvendio__Rate_Discount_4_Name__c != oldItem.ADvendio__Rate_Discount_4_Name__c
              || item.ADvendio__RateDiscount2Name__c != oldItem.ADvendio__RateDiscount2Name__c
              || item.RecordType.DeveloperName != oldItem.RecordType.DeveloperName  
              || item.ADvendio__SelectedCityInformation__c != oldItem.ADvendio__SelectedCityInformation__c
              || item.ADvendio__SelectedContentInformation__c != oldItem.ADvendio__SelectedContentInformation__c
              || item.ADvendio__SelectedCountryInformation__c != oldItem.ADvendio__SelectedCountryInformation__c
              || item.ADvendio__SelectedPublicationDateInformation__c != oldItem.ADvendio__SelectedPublicationDateInformation__c
              || item.ADvendio__SelectedRegionInformation__c != oldItem.ADvendio__SelectedRegionInformation__c
              || item.ADvendio__ShowPacketComponentsOnQuote__c != oldItem.ADvendio__ShowPacketComponentsOnQuote__c
              || item.ADvendio__SortOrder__c != oldItem.ADvendio__SortOrder__c
              || item.ADvendio__SurchargeB2__c != oldItem.ADvendio__SurchargeB2__c
              || item.ADvendio__SurchargeB2Abs__c != oldItem.ADvendio__SurchargeB2Abs__c
              || item.ADvendio__SurchargeB3__c != oldItem.ADvendio__SurchargeB3__c
              || item.ADvendio__SurchargeB3Abs__c != oldItem.ADvendio__SurchargeB3Abs__c
              || item.ADvendio__SurchargeSalesPrice__c != oldItem.ADvendio__SurchargeSalesPrice__c
              || item.ADvendio__Third_party_commission__c != oldItem.ADvendio__Third_party_commission__c
              || item.ADvendio__until_Date__c != oldItem.ADvendio__until_Date__c
              || item.ADvendio__AdDayOfWeek__c != oldItem.ADvendio__AdDayOfWeek__c
              || item.ADvendio__AdHourOfDay__c != oldItem.ADvendio__AdHourOfDay__c  
              || item.ADvendio__AdKeyValues__c != oldItem.ADvendio__AdKeyValues__c  
              || item.ADvendio__AdOperatingSystems__c != oldItem.ADvendio__AdOperatingSystems__c    
              || item.ADvendio__AdWebBrowsers__c != oldItem.ADvendio__AdWebBrowsers__c  
              || item.ADvendio__Billing_category__c != oldItem.ADvendio__Billing_category__c
              || item.ADvendio__BillingStatus__c != oldItem.ADvendio__BillingStatus__c
              || item.ADvendio__BillMe__c != oldItem.ADvendio__BillMe__c    
              || item.ADvendio__ConnectedItemID__c != oldItem.ADvendio__ConnectedItemID__c  
              || item.ADvendio__DistributionPeriod__c != oldItem.ADvendio__DistributionPeriod__c    
              || item.ADvendio__DistributionUnit__c != oldItem.ADvendio__DistributionUnit__c    
              || item.ADvendio__EffectiveAgencyCommission__c != oldItem.ADvendio__EffectiveAgencyCommission__c
              || item.ADvendio__Frequency__c != oldItem.ADvendio__Frequency__c  
              || item.ADvendio__from_Date__c != oldItem.ADvendio__from_Date__c  
              || item.ADvendio__Guaranteed_AI__c != oldItem.ADvendio__Guaranteed_AI__c  
              || item.ADvendio__HideContentTargetingOnQuote__c != oldItem.ADvendio__HideContentTargetingOnQuote__c  
              || item.ADvendio__HideFCOnQuote__c != oldItem.ADvendio__HideFCOnQuote__c  
              || item.ADvendio__HideGeoTargetingOnQuote__c != oldItem.ADvendio__HideGeoTargetingOnQuote__c  
              || item.ADvendio__HideKeyValueTargetingOnQuote__c != oldItem.ADvendio__HideKeyValueTargetingOnQuote__c    
              || item.ADvendio__HidePublicationDateTargetingOnQuote__c != oldItem.ADvendio__HidePublicationDateTargetingOnQuote__c  
              || item.ADvendio__HideTechnicalTargetingOnQuote__c != oldItem.ADvendio__HideTechnicalTargetingOnQuote__c  
              || item.ADvendio__HideTimeTargetingOnQuote__c != oldItem.ADvendio__HideTimeTargetingOnQuote__c    
              || item.ADvendio__IsCPMPrice__c != oldItem.ADvendio__IsCPMPrice__c
              || item.ADvendio__LinearDistribution__c != oldItem.ADvendio__LinearDistribution__c    
              || item.ADvendio__Media_Campaign__c != oldItem.ADvendio__Media_Campaign__c    
              || item.ADvendio__Package__c != oldItem.ADvendio__Package__c  
              || item.ADvendio__PacketItem__c != oldItem.ADvendio__PacketItem__c
              || item.ADvendio__PositionNumber__c != oldItem.ADvendio__PositionNumber__c    
              || item.ADvendio__PositionNumberAppendix__c != oldItem.ADvendio__PositionNumberAppendix__c    
              || item.ADvendio__Prorated__c != oldItem.ADvendio__Prorated__c    
              || item.ADvendio__Quantity__c != oldItem.ADvendio__Quantity__c    
              || item.ADvendio__Rate_Discount_1__c != oldItem.ADvendio__Rate_Discount_1__c  
              || item.ADvendio__Rate_Discount_2__c != oldItem.ADvendio__Rate_Discount_2__c  
              || item.ADvendio__Rate_Discount_3__c != oldItem.ADvendio__Rate_Discount_3__c
              || item.ADvendio__LineDescription__c != oldItem.ADvendio__LineDescription__c  
              ){
                resultSet.add(item.Id);
            }
        }
        
        return resultSet;
    }
    
    @TestVisible
    private static Set<Id> getMediaCampaignsFromAccounts(Set<Id> setAccIds){
        if(setAccIds == null || setAccIds.isEmpty())
            return null;
        Set<Id> resultSet = new Set<Id>();
        List<ADvendio__MediaCampaign__c> listCamps = new List<ADvendio__MediaCampaign__c>();
        
        listCamps = [SELECT Id, Name FROM ADvendio__MediaCampaign__c WHERE
                        ADvendio__Agency__c in :setAccIds 
                        OR ADvendio__Account__c in :setAccIds
                        OR ADvendio__invoice_recipient__c in :setAccIds
                        OR ADvendio__Intermediary__c in :setAccIds
                        OR ADvendio__PostalRecipient__c in :setAccIds];
        
        for(ADvendio__MediaCampaign__c oneCamp: listCamps){
            resultSet.add(oneCamp.Id);
        }
        
        return resultSet;
    }
    
    @TestVisible
    private static Set<Id> getMediaCampaignsFromCampaignItems(Set<Id> setCampaignItems){
        if(setCampaignItems == null || setCampaignItems.isEmpty())
            return null;
        Set<Id> resultSet = new Set<Id>();
        List<ADvendio__Campaign_Item__c> listCampItems = [SELECT Id, Name, ADvendio__Media_Campaign__c FROM ADvendio__Campaign_Item__c WHERE
                        ID in :setCampaignItems];
        
        for(ADvendio__Campaign_Item__c item: listCampItems){
            resultSet.add(item.ADvendio__Media_Campaign__c);
        }
        
        return resultSet;
    }
}