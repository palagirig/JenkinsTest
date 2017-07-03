public with sharing class Adv_CampaignItem_Validation {

  public static void validateCampaignItems(List<ADvendio__Campaign_Item__c> listNewItems, Map<Id,ADvendio__Campaign_Item__c> mapOldItems ){
    validateFieldAE(listNewItems, mapOldItems);
    validateRevInvoice(listNewItems, mapOldItems);
  }

  /* Block editing for all fields (excluding ADvendio__ConnectedItem__c and ADvendio__BillingStatus__c) if an reviewed invoice exsits
   * Ticket 2291, move for validation rule to apex code in ticket 4421
   */
  private static void validateRevInvoice(List<ADvendio__Campaign_Item__c> listNewItems, Map<Id,ADvendio__Campaign_Item__c> mapOldItems){
    Set<ID> setCamps = new Set<ID>();
    List<ADvendio__Campaign_Item__c> listCampItems = new List<ADvendio__Campaign_Item__c>();
    for(integer index = 0;index<listNewItems.size();index++){
      ADvendio__Campaign_Item__c oneCampItem = listNewItems.get(index);
      if(mapOldItems.containsKey(oneCampItem.Id)
          && oneCampItem.ADvendio__ConnectedItem__c == mapOldItems.get(oneCampItem.Id).ADvendio__ConnectedItem__c
          && oneCampItem.ADvendio__BillingStatus__c == mapOldItems.get(oneCampItem.Id).ADvendio__BillingStatus__c){
        setCamps.add(oneCampItem.ADvendio__Media_Campaign__c);
        listCampItems.add(oneCampItem);
      }
    }
    if(setCamps.isEmpty())
      return;
    System.debug('### listCampItems: '+listCampItems);
    System.debug('### setCamps: '+setCamps);

    List<Advendio__Invoice__c> listInvoices = [SELECT Name, ADvendio__Status__c, ADvendio__MediaCampaign__c
                                                FROM Advendio__Invoice__c
                                                WHERE ADvendio__MediaCampaign__c in :setCamps
                                                  AND ADvendio__Status__c LIKE 'Reviewed'
                                                  AND ADvendio__InvoiceType__c LIKE 'Invoice'];

    System.debug('### listInvoices: '+listInvoices);

    Map<Id,Advendio__Invoice__c> mapInvoices = new Map<Id,Advendio__Invoice__c>();
    for(Advendio__Invoice__c invoice: listInvoices){
      mapInvoices.put(invoice.ADvendio__MediaCampaign__c, invoice);
    }
    String sError = Label.Adv_CampaignItem_Validationerror;

    for(ADvendio__Campaign_Item__c oneCampItem: listCampItems){
      if(mapInvoices.containsKey(oneCampItem.ADvendio__Media_Campaign__c)){
        oneCampItem.addError(Label.Adv_MediaCampaign_FieldValidationError);
      }
    }
  }

  private static void validateFieldAE(List<ADvendio__Campaign_Item__c> listNewItems, Map<Id,ADvendio__Campaign_Item__c> mapOldItems){

       // Reduce the SOQL values for this methode
        List<ADvendio__Campaign_Item__c> listCampItems = new List<ADvendio__Campaign_Item__c>();
        for(integer index = 0;index<listNewItems.size();index++){
            ADvendio__Campaign_Item__c oneCampItem = listNewItems.get(index);
            if(mapOldItems.containsKey(oneCampItem.Id)
                && oneCampItem.ADvendio__AC__c != mapOldItems.get(oneCampItem.Id).ADvendio__AC__c){
               listCampItems.add(oneCampItem);
            }
        }
        if(listCampItems.isEmpty())
            return;

    List<ADvendio__InvoiceItem__c> listInvoiceItems = [SELECT Name, ADvendio__Invoice__r.ADvendio__Status__c, ADvendio__CampaignItem__c
                                FROM ADvendio__InvoiceItem__c
                                WHERE ADvendio__CampaignItem__c in :listCampItems
                                                              AND ADvendio__Invoice__r.ADvendio__Status__c != 'Draft'
                                                              AND ADvendio__Invoice__r.ADvendio__Status__c != 'Canceled'
                                                              AND ADvendio__Invoice__r.ADvendio__InvoiceType__c != 'Cancellation'];

    Map<Id,ADvendio__InvoiceItem__c> mapInvoiceItems = new Map<Id,ADvendio__InvoiceItem__c>();
    for(ADvendio__InvoiceItem__c item: listInvoiceItems){
      mapInvoiceItems.put(item.ADvendio__CampaignItem__c, item);
    }
    String sError = Label.Adv_CampaignItem_Validationerror;

    for(ADvendio__Campaign_Item__c oneCampItem: listCampItems){
      if(mapInvoiceItems.containsKey(oneCampItem.Id)){
        oneCampItem.addError(sError);
      }
    }
  }

  public static void validateAdId(List<ADvendio__Campaign_Item__c> listNewItems, Map<Id,ADvendio__Campaign_Item__c> mapOldItems){

    List<ADvendio__Campaign_Item__c> listCampItems = new List<ADvendio__Campaign_Item__c>();
    Set<String> setAdIDs = new Set<String>();

    for(ADvendio__Campaign_Item__c objNewCI : listNewItems){
      ADvendio__Campaign_Item__c objOldCI = (mapOldItems != null ? mapOldItems.get(objNewCI.Id) : null);
      if(objNewCI.ADvendio__Ad_Id__c != null && (objOldCI == null || isAdIdChanged(objNewCI, objOldCI))) {
        if(!setAdIDs.contains(objNewCI.ADvendio__Ad_Id__c)) {
          listCampItems.add(objNewCI);
          setAdIDs.add(objNewCI.ADvendio__Ad_Id__c);
        } else {
          objNewCI.addError('There are duplicate Ad IDs in this Media Campaign.');
        }
      }
    }

    if(!listCampItems.isEmpty()) {

      Map<String, ADvendio__Campaign_Item__c> mapCampaignItems = new Map<String, ADvendio__Campaign_Item__c>();
      for(ADvendio__Campaign_Item__c ci : [SELECT Name, ADvendio__Ad_Id__c FROM ADvendio__Campaign_Item__c WHERE ADvendio__from_Date__c = THIS_YEAR AND ADvendio__Ad_Id__c IN :setAdIDs]) {
        mapCampaignItems.put(ci.ADvendio__Ad_Id__c, ci);
      }

      for(ADvendio__Campaign_Item__c objCI : listCampItems) {
        // Second IF condition shouldn't be necessary as the campaign position shouldn't be in the DB with the new ad id at this point(before context). 
        // But in some cases, possibly due to recursive trigger execution, it needs to be checked.
        if(mapCampaignItems.containsKey(objCI.ADvendio__Ad_Id__c) && mapCampaignItems.get(objCI.ADvendio__Ad_Id__c).Id != objCI.Id) {
            String sError = Label.Adv_CampaignItem_AdIdValidation1.replace('%1', mapCampaignItems.get(objCI.ADvendio__Ad_Id__c).Name);
            sError = sError.replace('%2', mapCampaignItems.get(objCI.ADvendio__Ad_Id__c).Id);
            objCI.addError(sError);
        }
      }

    }
 
  }

  private static Boolean isAdIdChanged(ADvendio__Campaign_Item__c ci, ADvendio__Campaign_Item__c oldci) { 
    return ci.ADvendio__Ad_Id__c != oldci.ADvendio__Ad_Id__c;
  }

}