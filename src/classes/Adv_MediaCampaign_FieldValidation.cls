// class for KV: 03672
public class Adv_MediaCampaign_FieldValidation{

  public static final Id ORDER_RECORDTYPE_ID = cls_P7S1_Utils.getRecordTypeID('ADvendio__MediaCampaign__c', 'SomDig_Auftrag');
  public static final Id OFFER_RECORDTYPE_ID = cls_P7S1_Utils.getRecordTypeID('ADvendio__MediaCampaign__c', 'SomDig_Angebot');
  public static final Id BILLING_PROFILE_ID = '00eD0000001Qk4n';
  public static final Id SALES_PROFILE_ID = '00e20000001QBtU';
  public static final Id PAM_PROFILE_ID = '00eD0000001Qf2o';
  public static final Id SYSADM_PROFILE_ID = '00e20000000lfOjAAI';

  @TestVisible
  private static final String WTAGBEZIEHUNGERROR = 'Das Feld WT AG Beziehung auf der Mediakampagne darf nicht editiert werden.';

  @TestVisible
  private static final string SACCONCEPTIONMANAGERERROR = 'Conception Manager darf nicht mehr im Auftragsstatus durch StandardUser geändert werden.';

  // Ticket 5787
  public static void validateWtAgBeziehung(List<ADvendio__MediaCampaign__c> lstNewItems, Map<Id, ADvendio__MediaCampaign__c> mapOldItems) {
    ID auftragRCID = cls_P7S1_Utils.getRecordTypeID('ADvendio__MediaCampaign__c', 'SomDig_Auftrag');
    Set<ID> setMediaCampaignIDs = new Set<ID>();
    for(ADvendio__MediaCampaign__c mc : lstNewItems){
      ADvendio__MediaCampaign__c oldMc = mapOldItems.get(mc.Id);
      if(isWtAgBeziehungChanged(mc, oldMc) && mc.RecordTypeID == auftragRCID) {
        // If user is not Billing nor Teamlead -> error.
        if(!isUserBilling() && !isUserTeamlead()) {
          mc.addError(WTAGBEZIEHUNGERROR);
        } else {
          setMediaCampaignIDs.add(mc.Id);
        }
      }
    }

    if(setMediaCampaignIDs.isEmpty()) return;

    Map<Id, ADvendio__MediaCampaign__c> mediaCampaignsWithInvoices = new Map<Id, ADvendio__MediaCampaign__c>([SELECT ID, (SELECT ID FROM ADvendio__Invoices__r WHERE (ADvendio__InvoiceType__c = 'Invoice' AND (ADvendio__Status__c = 'Invoiced' OR ADvendio__Status__c = 'Reviewed')) OR (ADvendio__InvoiceType__c = 'Cancellation' AND SomDig_Rechnungsfreigabe__c = false))
                                                                                                              FROM ADvendio__MediaCampaign__c
                                                                                                              WHERE ID IN :setMediaCampaignIDs]);

    for(ADvendio__MediaCampaign__c mc : lstNewItems) {
      // If query returned rows -> error. 
      if(!mediaCampaignsWithInvoices.get(mc.Id).ADvendio__Invoices__r.isEmpty()){
        mc.addError(WTAGBEZIEHUNGERROR);
      }
    }

  }



  public static void validateReviewedInvoices(List<ADvendio__MediaCampaign__c> listNewItems, Map<Id, ADvendio__MediaCampaign__c> mapOldItems) {

    // Reduce the SOQL values for this methode
    List<ADvendio__MediaCampaign__c> listCamps = new List<ADvendio__MediaCampaign__c>();
    for(integer index = 0;index<listNewItems.size();index++){
      ADvendio__MediaCampaign__c oneCamp = listNewItems.get(index);
      if(mapOldItems.containsKey(oneCamp.Id)
        && (oneCamp.ADvendio__external_Media_Campaign_Name__c != mapOldItems.get(oneCamp.Id).ADvendio__external_Media_Campaign_Name__c
          || oneCamp.ADvendio__your_reference_number2__c != mapOldItems.get(oneCamp.Id).ADvendio__your_reference_number2__c
          || oneCamp.SomDig_BetreuerPam__c != mapOldItems.get(oneCamp.Id).SomDig_BetreuerPam__c
          || oneCamp.SomDig_BetreuerSales__c != mapOldItems.get(oneCamp.Id).SomDig_BetreuerSales__c
          || oneCamp.SomDig_Zahlungsbedingung__c != mapOldItems.get(oneCamp.Id).SomDig_Zahlungsbedingung__c)){
        listCamps.add(oneCamp);
      }
    }

    if(listCamps.isEmpty()) return;

    System.debug('### listCamps: '+listCamps);

    List<Advendio__Invoice__c> listInvoices = [SELECT Name, ADvendio__Status__c, ADvendio__MediaCampaign__c
    FROM Advendio__Invoice__c
    WHERE ADvendio__MediaCampaign__c in :listCamps
    AND ADvendio__Status__c LIKE 'Reviewed'
    AND ADvendio__InvoiceType__c LIKE 'Invoice'];

    System.debug('### listInvoices: '+listInvoices);

    Map<Id,Advendio__Invoice__c> mapInvoices = new Map<Id,Advendio__Invoice__c>();
    for(Advendio__Invoice__c invoice : listInvoices) {
      mapInvoices.put(invoice.ADvendio__MediaCampaign__c, invoice);
    }

    for(ADvendio__MediaCampaign__c oneCamp : listCamps) {
      if(mapInvoices.containsKey(oneCamp.Id)) {
        oneCamp.addError(Label.Adv_MediaCampaign_FieldValidationError);
      }
    }
  }



  /*  Ticket 04209 & 5290
  *   Mediakampagne im Auftragsstatus und keine freigegebene Rechnung (Datensatztyp = "Rechnung" und Rechnungsfreigabe = "true") verknüpft, dann Wert "Abrechnen" nur von Billing- oder Admin-Profil änderbar.
  */
  public static void validate_BillMe(List<ADvendio__MediaCampaign__c> listNewItems, Map<Id, ADvendio__MediaCampaign__c> mapOldItems){
    if(UserInfo.getProfileId() == SYSADM_PROFILE_ID) return; //admins are allowed to delete.
    String sError = Label.Adv_MediaCampaign_BillMeValidationError;
    // Reduce the SOQL values for this methode
    List<ADvendio__MediaCampaign__c> listCamps = new List<ADvendio__MediaCampaign__c>();
    Set<Id> setCampIDs = new Set<Id>();


    for(ADvendio__MediaCampaign__c oneCamp : listNewItems){
      ADvendio__MediaCampaign__c oldCampaign = mapOldItems.get(oneCamp.Id);
      if(oneCamp.SomDig_GutschriftPerformance__c) continue;  // Gutschriften ueberspringen


      if(! isValid_BillingSwitch(oldCampaign, oneCamp)) continue;      
      if(isValid_NutzerBeiStorno() || isValid_StornoVorLeistungsfluss(oldCampaign, oneCamp))
      {
        listCamps.add(oneCamp);
        setCampIDs.add(oneCamp.Id);
      }
      else
      {
        oneCamp.addError(sError);
      }
    }

    if(listCamps.isEmpty()) return;


    List<Advendio__Invoice__c> listInvoices = getInvoices(setCampIDs);

    Map<Id,Advendio__Invoice__c> mapInvoices = new Map<Id,Advendio__Invoice__c>();
    for(Advendio__Invoice__c invoice: listInvoices){
      mapInvoices.put(invoice.ADvendio__MediaCampaign__c, invoice);
    }

    for(ADvendio__MediaCampaign__c oneCamp : listCamps) {
      if(mapInvoices.containsKey(oneCamp.Id)) {
        oneCamp.addError(sError);
        System.debug('Error added in line 150 MC_FielVal');
      }
    }
  }

  public static Boolean isValid_StornoVorLeistungsfluss(ADvendio__MediaCampaign__c oldCampaign, ADvendio__MediaCampaign__c newCampaign)
  {
    Set<Id> validProfiles =  new Set<ID>{BILLING_PROFILE_ID, SALES_PROFILE_ID, PAM_PROFILE_ID};
    Boolean isUserAllowedToCancel = validProfiles.contains(UserInfo.getProfileId());
    Boolean isStartIntheFuture = newCampaign.ADvendio__Campaign_Start_Date__c > Date.today();
    Boolean isSwitchedCanceled = oldCampaign.ADvendio__Stage__c != newCampaign.ADvendio__Stage__c && newCampaign.ADvendio__Stage__c == 'geschlossen und abgelehnt';


    Boolean result = isUserAllowedToCancel && isStartIntheFuture && isSwitchedCanceled;
    return true;
  }

  /**
   * Check if the campaign is an order and the ADvendio__BillMe__c was changed
  **/
  public static Boolean isValid_BillingSwitch(ADvendio__MediaCampaign__c oldCampaign, ADvendio__MediaCampaign__c newCampaign)
  {
      if(oldCampaign.ADvendio__BillMe__c == newCampaign.ADvendio__BillMe__c) return false;

      Set<Id> validRecordTypes =  new Set<ID>{ORDER_RECORDTYPE_ID};   
      if(! validRecordTypes.contains(newCampaign.RecordTypeId) )return false;

      return true; 
  }

  public static Boolean isValid_NutzerBeiStorno()
  {       
      Set<Id> validProfiles =  new Set<ID>{BILLING_PROFILE_ID};
      if(! validProfiles.contains(UserInfo.getProfileId())) return false;

      return true;
  }

  public static List<Advendio__Invoice__c> getInvoices(Set<Id> setCampIDs)
  {
    return [SELECT Name, ADvendio__InvoiceType__c, ADvendio__Status__c, ADvendio__MediaCampaign__c, SomDig_Rechnungsfreigabe__c
                                                FROM Advendio__Invoice__c
                                                WHERE 
                                                  ADvendio__MediaCampaign__c in :setCampIDs
                                                  AND 
                                                  (
                                                    (
                                                      (ADvendio__InvoiceType__c = 'Invoice' OR ADvendio__InvoiceType__c = 'Credit Note')
                                                      AND
                                                      (ADvendio__Status__c = 'Reviewed' OR ADvendio__Status__c = 'Invoiced')
                                                    )
                                                    OR 
                                                    (
                                                      (ADvendio__InvoiceType__c = 'Cancellation' OR ADvendio__InvoiceType__c = 'Credit Note Cancellation')
                                                      AND
                                                      ADvendio__Status__c = 'Draft'
                                                    )
                                                  )
                                                ];
  }




  public static void mediakampagneAuftragFeldfixierung(List<ADvendio__MediaCampaign__c> lstNewItems, Map<Id, ADvendio__MediaCampaign__c> mapOldItems) {

    if(!P7S1_Settings__c.getOrgDefaults().SomDig_MediaCampaign_FieldFixierung__c && !Test.isRunningTest()) return;

    ID auftragRCID = cls_P7S1_Utils.getRecordTypeID('ADvendio__MediaCampaign__c', 'SomDig_Auftrag');
    Set<ID> setMediaCampaignIDs = new Set<ID>();
    for(ADvendio__MediaCampaign__c o : lstNewItems){

      if(o.RecordTypeID == auftragRCID) {
        ADvendio__MediaCampaign__c oldMc = mapOldItems.get(o.Id);

        if(isPriceListChanged(o, oldMc)) {
          o.addError(Label.SomDig_MediaCampaign_FieldFixierungError);
        } else if(isBetreuerTeamChanged(o, oldMc) && !isUserBilling() && !isUserAdmin() && !isUserVertriebSteuerung() ) {
          o.addError(Label.SomDig_MediaCampaign_FieldFixierungError);
        } else if(isFixedFieldChange(o, oldMc)) {
          if(!isUserBilling() && !isUserAdmin() && o.ADvendio__Stage__c == oldMC.ADvendio__Stage__c) {
            o.addError(Label.SomDig_MediaCampaign_FieldFixierungError);
          } else {
            setMediaCampaignIDs.add(o.Id);
          }
        }
      }
    }

    if(setMediaCampaignIDs.isEmpty()) return;

    Map<Id, ADvendio__MediaCampaign__c> mediaCampaignsWithInvoices = new Map<Id, ADvendio__MediaCampaign__c>([SELECT ID, (SELECT ID FROM ADvendio__Invoices__r WHERE (ADvendio__Status__c = 'Invoiced' OR ADvendio__Status__c = 'Reviewed') AND ADvendio__InvoiceType__c != 'Cancellation')
      FROM ADvendio__MediaCampaign__c
      WHERE ID IN :setMediaCampaignIDs]);

    for(ADvendio__MediaCampaign__c o : lstNewItems) {
      if(!mediaCampaignsWithInvoices.containsKey(o.Id)) continue;

      // If the Campaign is in the map it has more than 0 Invoices
      if(!mediaCampaignsWithInvoices.get(o.Id).ADvendio__Invoices__r.isEmpty()){
        o.addError('invoice '+Label.SomDig_MediaCampaign_FieldFixierungError);
      }
    }

  }

  // Ticket 05788 - Conception Manager darf im Auftragsstatus nur von Sales Steering und C&B geändert werden
  public static void validateSACConceptionManager(List<ADvendio__MediaCampaign__c> lstNewItems, Map<Id, ADvendio__MediaCampaign__c> mapOldItems) {

    ID auftragRCID = cls_P7S1_Utils.getRecordTypeID('ADvendio__MediaCampaign__c', 'SomDig_Auftrag');
    for(ADvendio__MediaCampaign__c mc : lstNewItems){
      ADvendio__MediaCampaign__c oldMc = mapOldItems.get(mc.Id);
      if(isSACConceptionManagerChanged(mc, oldMc) && mc.RecordTypeID == auftragRCID && !isUserBilling() && !isUserSalesSteering) {
          mc.addError(SACCONCEPTIONMANAGERERROR);
      }
    }

  }

  private static Boolean isUserSalesSteering {
    get {
      if(isUserSalesSteering == null) {
        List<PermissionSetAssignment> objPSA = new List<PermissionSetAssignment>([SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId() AND PermissionSet.Name = 'SomDig_SalesSteering']);
        isUserSalesSteering = !objPSA.isEmpty();
      }
      return isUserSalesSteering;
    }
    set;
  }
  
  private static User currentUser {
      get {
          if(currentUser == null) currentUser = [SELECT SomDig_IsTeamLead__c, SomDig_SalesTeam__c FROM User WHERE ID = :UserInfo.getUserId() LIMIT 1];
          return currentUser;
      }
      set; 
  }

  @TestVisible
  private static Boolean isPriceListChanged(ADvendio__MediaCampaign__c mc, ADvendio__MediaCampaign__c oldMc) {
    return mc.ADvendio__Pricelist__c != oldMc.ADvendio__Pricelist__c;
  }

  @TestVisible
  private static Boolean isUserTeamLead() {
    return currentUser.SomDig_IsTeamLead__c;
  }

  @TestVisible
  private static Boolean isUserAdmin() {
    return UserInfo.getProfileId().contains('00e20000000lfOj');
  }

  @TestVisible
  private static Boolean isUserBilling() {
    return UserInfo.getProfileId().contains('00eD0000001Qk4n');
  }

  @TestVisible
  private static Boolean isWtAgBeziehungChanged(ADvendio__MediaCampaign__c mc, ADvendio__MediaCampaign__c oldMc) {
    return mc.SomDig_WtAgBeziehung__c != oldMc.SomDig_WtAgBeziehung__c;
  }

  @TestVisible
  private static Boolean isUserVertriebSteuerung() {
    return currentUser.SomDig_SalesTeam__c == 'Vertrieb Steuerung';
  }

  @TestVisible
  private static Boolean isBetreuerTeamChanged(ADvendio__MediaCampaign__c mc, ADvendio__MediaCampaign__c oldMc) {
    return mc.SomDig_BetreuerTeam__c != oldMc.SomDig_BetreuerTeam__c;
  }

  @TestVisible
  private static Boolean isSACConceptionManagerChanged(ADvendio__MediaCampaign__c mc, ADvendio__MediaCampaign__c oldMc) {
    return mc.SomDig_SACConceptionManager__c != oldMc.SomDig_SACConceptionManager__c;
  }
  
  @TestVisible
  private static Boolean isFixedFieldChange(ADvendio__MediaCampaign__c mc, ADvendio__MediaCampaign__c oldMc) {
    Boolean isGutschriftPerformanceChanged = mc.SomDig_GutschriftPerformance__c != oldMc.SomDig_GutschriftPerformance__c;
    Boolean isInvoiceRecipientChanged = mc.ADvendio__invoice_recipient__c != oldMc.ADvendio__invoice_recipient__c;
    Boolean isZahlungsbedingungChanged = mc.SomDig_Zahlungsbedingung__c != oldMc.SomDig_Zahlungsbedingung__c;
    Boolean isPaymentStartChanged = mc.ADvendio__PaymentStart__c != oldMc.ADvendio__PaymentStart__c;
    Boolean isPaymentIntervalChanged = mc.ADvendio__PaymentInterval__c != oldMc.ADvendio__PaymentInterval__c;
    Boolean isPaymentDueDateChanged = mc.ADvendio__PaymentDueDate__c != oldMc.ADvendio__PaymentDueDate__c;

    return isGutschriftPerformanceChanged ||isInvoiceRecipientChanged || isZahlungsbedingungChanged || isPaymentStartChanged || isPaymentIntervalChanged || isPaymentDueDateChanged;
  }

}