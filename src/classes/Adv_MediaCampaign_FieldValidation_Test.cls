@isTest
public class Adv_MediaCampaign_FieldValidation_Test{

    public static testMethod void testChangeWtAgWhenUserIsNoTeamLeadNorBilling(){
        //When a user that is not billing or Lead changes wtag-beziehung in status auftrag, error should appear.
        ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(false);
        objMC.RecordTypeID = cls_P7S1_Utils.getRecordTypeId('ADvendio__MediaCampaign__c', 'SomDig_Auftrag');
        insert objMC;

        Boolean expectedExceptionThrown = false;

        Test.startTest();

        try{
            // Create WTAG
            SomDig_WtAgBeziehung__c objNewWTAG = cls_P7S1_TestData.createTestWTAG(true, null, null);
            objMC.SomDig_WtAgBeziehung__c = objNewWTAG.ID;
            update objMC;
        }catch(Exception e){
            expectedExceptionThrown =  e.getMessage().contains(Adv_MediaCampaign_FieldValidation.WTAGBEZIEHUNGERROR);
        }

        Test.stopTest();

        System.AssertEquals(expectedExceptionThrown, true);
    }

    public static testMethod void testChangeWtAgWithBillingUser(){
        User objUserBilling = [SELECT Id, IsActive, Name, P7S1_Sphere__c, ProfileId, Profile.Name, Username, SomDig_SalesTeam__c FROM User WHERE IsActive = true AND Profile.Name = 'SomDig_Billing' AND P7S1_Unit__c = '71M' LIMIT 1];

        ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(false);
        objMC.RecordTypeID = cls_P7S1_Utils.getRecordTypeId('ADvendio__MediaCampaign__c', 'SomDig_Auftrag');
        insert objMC;

        Boolean exceptionThrown = false;

        Test.startTest();

        System.runAs(objUserBilling) {
            try{
                // Create WTAG
                SomDig_WtAgBeziehung__c objNewWTAG = cls_P7S1_TestData.createTestWTAG(true, null, null);
                objMC.SomDig_WtAgBeziehung__c = objNewWTAG.ID;
                update objMC;
            }catch(Exception e){
               exceptionThrown = true;
            }
        }



        Test.stopTest();

        System.AssertEquals(exceptionThrown, false);
    }

    public static testMethod void testChangeWtAgWithTeamLeadUser(){
        User objUserLead = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_PAM');
        objUserLead.SomDig_IsTeamLead__c = true;
        update objUserLead;

        ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(false);
        objMC.RecordTypeID = cls_P7S1_Utils.getRecordTypeId('ADvendio__MediaCampaign__c', 'SomDig_Auftrag');
        insert objMC;

        Boolean exceptionThrown = false;

        Test.startTest();

        System.runAs(objUserLead) {
            try{
                // Create WTAG
                SomDig_WtAgBeziehung__c objNewWTAG = cls_P7S1_TestData.createTestWTAG(true, null, null);
                objMC.SomDig_WtAgBeziehung__c = objNewWTAG.ID;
                update objMC;
            }catch(Exception e){
                exceptionThrown = true;
            }
        }

        Test.stopTest();

        System.AssertEquals(exceptionThrown, false);
    }

    public static testMethod void testChangeWtAgWithInvoicedInvoices(){
        User objUserLead = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_PAM');
        objUserLead.SomDig_IsTeamLead__c = true;
        update objUserLead;

        // New MC
        ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(false);
        objMC.RecordTypeID = cls_P7S1_Utils.getRecordTypeId('ADvendio__MediaCampaign__c', 'SomDig_Auftrag');
        insert objMC;

        ADvendio__Invoice__c objInv = cls_P7S1_TestData.createTestInvoice(false, objMC);
        objInv.ADvendio__InvoiceType__c = 'Invoice';
        objInv.ADvendio__Status__c = 'Invoiced';
        insert objInv;

        Boolean expectedExceptionThrown = false;

        Test.startTest();

        System.runAs(objUserLead) {
            try{
                // Create WTAG
                SomDig_WtAgBeziehung__c objNewWTAG = cls_P7S1_TestData.createTestWTAG(true, null, null);
                objMC.SomDig_WtAgBeziehung__c = objNewWTAG.ID;
                update objMC;

            }catch(Exception e){
                expectedExceptionThrown =  e.getMessage().contains(Adv_MediaCampaign_FieldValidation.WTAGBEZIEHUNGERROR) ? true : false;
            }
        }

        Test.stopTest();

        System.AssertEquals(expectedExceptionThrown, true);

    }

    public static testMethod void testChangeWtAgWithUnreviewedCancellation(){
        User objUserLead = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_PAM');
        objUserLead.SomDig_IsTeamLead__c = true;
        update objUserLead;

        // New MC
        ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(false);
        objMC.RecordTypeID = cls_P7S1_Utils.getRecordTypeId('ADvendio__MediaCampaign__c', 'SomDig_Auftrag');
        insert objMC;

        ADvendio__Invoice__c objInv = cls_P7S1_TestData.createTestInvoice(false, objMC);
        objInv.ADvendio__InvoiceType__c = 'Invoice';
        objInv.ADvendio__Status__c = 'Cancelled';
        objInv.SomDig_Rechnungsfreigabe__c = false;
        insert objInv;

        ADvendio__Invoice__c objCancel = cls_P7S1_TestData.createTestInvoice(false, objMC);
        objCancel.ADvendio__InvoiceType__c = 'Cancellation';
        objCancel.ADvendio__Status__c = 'Invoiced';
        objCancel.SomDig_Rechnungsfreigabe__c = false;
        insert objCancel;

        Boolean expectedExceptionThrown = false;

        Test.startTest();

        System.runAs(objUserLead) {
            try{
                // Create WTAG
                SomDig_WtAgBeziehung__c objNewWTAG = cls_P7S1_TestData.createTestWTAG(true, null, null);
                objMC.SomDig_WtAgBeziehung__c = objNewWTAG.ID;
                update objMC;

            }catch(Exception e){
                expectedExceptionThrown =  e.getMessage().contains(Adv_MediaCampaign_FieldValidation.WTAGBEZIEHUNGERROR) ? true : false;
            }
        }

        Test.stopTest();

        System.AssertEquals(expectedExceptionThrown, true);

    }

    @isTest
    public static void testCampaignHasChanged(){
        ADvendio__MediaCampaign__c objMC1 = cls_P7S1_TestData.createTestMediaCampaign(false);
        objMC1.RecordTypeID = cls_P7S1_Utils.getRecordTypeId('ADvendio__MediaCampaign__c', 'SomDig_Auftrag');
        insert objMC1;
        ADvendio__MediaCampaign__c objMC2 = cls_P7S1_TestData.createTestMediaCampaign(false);
        objMC2.RecordTypeID = cls_P7S1_Utils.getRecordTypeId('ADvendio__MediaCampaign__c', 'SomDig_Auftrag');
        insert objMC2;

        Test.startTest();

        Boolean bTeamChanged = Adv_MediaCampaign_FieldValidation.isBetreuerTeamChanged(objMC1, objMC2);
        Boolean bPriceListChanged = Adv_MediaCampaign_FieldValidation.isPriceListChanged(objMC1, objMC2);
        Boolean bFieldChanged = Adv_MediaCampaign_FieldValidation.isFixedFieldChange(objMC1, objMC2);

        Test.stopTest();

        System.assert(!bTeamChanged);
        System.assert(bPriceListChanged);
        System.assert(bFieldChanged);
    }

    @isTest
    public static void testChangeBetreuerTeamAsPAM() {
        User objUserPAM = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_PAM');
        objUserPAM.SomDig_SalesTeam__c = 'test';
        update objUserPAM;


        ADvendio__MediaCampaign__c objMC1 = cls_P7S1_TestData.createTestMediaCampaign(false);
        objMC1.RecordTypeID = cls_P7S1_Utils.getRecordTypeId('ADvendio__MediaCampaign__c', 'SomDig_Auftrag');
        insert objMC1;

        Boolean bCatchedExceptionForPAM = false;

        Test.startTest();

        System.runAs(objUserPAM) {

            objMC1.SomDig_BetreuerTeam__c = cls_P7S1_TestData.createTestBetreuerTeam(true).Id;
            try{
                update objMC1;
            } catch(Exception e){
                bCatchedExceptionForPAM = true;
            }

        }

        Test.stopTest();

        System.assertEquals(true, bCatchedExceptionForPAM);
    }

    @isTest
    public static void testChangeBetreuerTeamAsBilling() {
        User objUserBilling = [SELECT Id, IsActive, Name, P7S1_Sphere__c, ProfileId, Profile.Name, Username, SomDig_SalesTeam__c FROM User WHERE IsActive = true AND Profile.Name = 'SomDig_Billing' AND P7S1_Unit__c = '71M' LIMIT 1];

        ADvendio__MediaCampaign__c objMC1 = cls_P7S1_TestData.createTestMediaCampaign(false);
        objMC1.RecordTypeID = cls_P7S1_Utils.getRecordTypeId('ADvendio__MediaCampaign__c', 'SomDig_Auftrag');
        insert objMC1;

        Boolean bCatchedExceptionForBilling = false;

        Test.startTest();

        System.runAs(objUserBilling) {

            objMC1.SomDig_BetreuerTeam__c = cls_P7S1_TestData.createTestBetreuerTeam(true).Id;
            try{
                update objMC1;
            } catch(Exception e){
                bCatchedExceptionForBilling = true;
            }

        }

        Test.stopTest();

        System.assertEquals(false, bCatchedExceptionForBilling);
    }

    @isTest
    public static void testChangeBetreuerTeamAsVertriebSteuerung() {
        User objUserPAM = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_PAM');
        objUserPAM.SomDig_SalesTeam__c = 'Vertrieb Steuerung';
        update objUserPAM;

        ADvendio__MediaCampaign__c objMC1 = cls_P7S1_TestData.createTestMediaCampaign(false);
        objMC1.RecordTypeID = cls_P7S1_Utils.getRecordTypeId('ADvendio__MediaCampaign__c', 'SomDig_Auftrag');
        insert objMC1;

        Boolean bCatchedExceptionForVertriebSteuerung = false;

        Test.startTest();

        System.runAs(objUserPAM) {

            objMC1.SomDig_BetreuerTeam__c = cls_P7S1_TestData.createTestBetreuerTeam(true).Id;
            try{
                update objMC1;
            } catch(Exception e){
                bCatchedExceptionForVertriebSteuerung = true;
            }

        }

        Test.stopTest();

        System.assertEquals(false, bCatchedExceptionForVertriebSteuerung);
    }

    @isTest
    public static void testValidateBillMe(){
        User objUserBilling = [SELECT Id, IsActive, Name, P7S1_Sphere__c, ProfileId, Profile.Name, Username, SomDig_SalesTeam__c FROM User WHERE IsActive = true AND Profile.Name = 'SomDig_Billing' AND P7S1_Unit__c = '71M' LIMIT 1];

        System.runAs(objUserBilling) {
            SomDig_Auftragstyp__c auftragstyp = cls_P7S1_TestData.createTestAuftragstyp(false);
            auftragstyp.SomDig_Rechnungstellung__c = false;
            insert auftragstyp;

            ADvendio__Pricelist__c pricelist = cls_P7S1_TestData.createTestPricelist(true, auftragstyp);
            // New MC
            ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(false, null, pricelist);
            objMC.RecordTypeID = '012D0000000Qj9BIAS';
            objMC.ADvendio__BillMe__c = false;
            insert objMC;

            ADvendio__Invoice__c objInv = cls_P7S1_TestData.createTestInvoice(false, objMC);
            objInv.ADvendio__Status__c = 'Invoiced';
            objInv.SomDig_Rechnungsfreigabe__c = TRUE;
            insert objInv;

            String sErrorMessage;

            Test.startTest();

            objMC.ADvendio__BillMe__c = !objMC.ADvendio__BillMe__c;

            try {
                update objMC;
            } catch(Exception e) {
                sErrorMessage = e.getMessage();
            }


            Test.stopTest();

            System.assert(sErrorMessage.contains(Label.Adv_MediaCampaign_BillMeValidationError));
            System.assertEquals('Invoice', [SELECT ADvendio__InvoiceType__c FROM ADvendio__Invoice__c WHERE ID = :objInv.Id].ADvendio__InvoiceType__c);
        }
    }

    @isTest
    public static void validateBillMeUserIsTeamLead(){

        User objUserPAM = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_PAM');
        objUserPAM.SomDig_IsTeamLead__c = true;
        update objUserPAM;

        System.runAs(objUserPAM) {
            boolean bCatchedException = false;

            Test.startTest();
            try{
                // New MC
                ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(false);
                objMC.RecordTypeID = cls_P7S1_Utils.getRecordTypeId('ADvendio__MediaCampaign__c', 'SomDig_Auftrag');
                insert objMC;
            }catch(Exception e){
                bCatchedException = true;
            }
            Test.stopTest();

            System.assert(!bCatchedException, 'Validation Rule for billMe fired');
        }
    }

    @isTest
    public static void validateBillMeStornierungReviewed(){
        User objUserBilling = [SELECT Id, IsActive, Name, P7S1_Sphere__c, ProfileId, Profile.Name, Username, SomDig_SalesTeam__c FROM User WHERE IsActive = true AND Profile.Name = 'SomDig_Billing' AND P7S1_Unit__c = '71M' LIMIT 1];

        System.runAs(objUserBilling) {
            // New MC
            ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(false);
            objMC.RecordTypeID = '012D0000000Qj9BIAS';
            insert objMC;

            ADvendio__Invoice__c objInv = cls_P7S1_TestData.createTestInvoice(false, objMC);
            objInv.ADvendio__Status__c = 'Reviewed';
            insert objInv;

            objInv.ADvendio__InvoiceType__c = 'Cancellation';
            update objInv;

            Boolean bException = false;
            Test.startTest();

            objMC.ADvendio__BillMe__c = !objMC.ADvendio__BillMe__c;

            try {
                update objMC;
            } catch(Exception e) {
                bException = true;
            }


            Test.stopTest();

            System.assert(bException == false, 'Expected Value: false  Actuall Value: '+bException);
            System.assert([SELECT ADvendio__InvoiceType__c FROM ADvendio__Invoice__c WHERE ID = :objInv.Id] != null);
        }
    }

    @isTest
    public static void validateBillMeGutschrift(){
        User objUserBilling = [SELECT Id, IsActive, Name, P7S1_Sphere__c, ProfileId, Profile.Name, Username, SomDig_SalesTeam__c FROM User WHERE IsActive = true AND Profile.Name = 'SomDig_Billing' AND P7S1_Unit__c = '71M' LIMIT 1];

        System.runAs(objUserBilling) {
            // New MC
            SomDig_Zahlungsbedingung__c objZB = cls_P7S1_TestData.createTestZahlungsbedingung(false);
            objZB.SomDig_Skontowert__c = 0.0;
            insert objZB;

            ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(false);
            objMC.RecordTypeID = '012D0000000Qj9BIAS';
            objMC.SomDig_GutschriftPerformance__c = true;
            objMC.SomDig_Zahlungsbedingung__c = objZB.Id;
            insert objMC;

            ADvendio__Invoice__c objInv = cls_P7S1_TestData.createTestInvoice(false, objMC);
            objInv.ADvendio__Status__c = 'Invoiced';
            objInv.SomDig_Rechnungsfreigabe__c = TRUE;
            insert objInv;

            String sErrorMessage;

            Boolean bException = false;
            Test.startTest();

            objMC.ADvendio__BillMe__c = !objMC.ADvendio__BillMe__c;

            try {
                update objMC;
            } catch(Exception e) {
                bException = true;
            }

            Test.stopTest();

            System.assert(bException == false, 'Expected Value: false  Actuall Value: '+bException);
            System.assert([SELECT ADvendio__InvoiceType__c FROM ADvendio__Invoice__c WHERE ID = :objInv.Id] != null);
        }
    }

    @isTest
    public static void testChangeSACConceptionManagerAsBilling() {

        User objUserBilling = [SELECT Id, IsActive, Name, P7S1_Sphere__c, ProfileId, Profile.Name, Username, SomDig_SalesTeam__c FROM User WHERE IsActive = true AND Profile.Name = 'SomDig_Billing' AND P7S1_Unit__c = '71M' LIMIT 1];

        ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(false);
        objMC.RecordTypeID = cls_P7S1_Utils.getRecordTypeId('ADvendio__MediaCampaign__c', 'SomDig_Auftrag');
        insert objMC;

        Boolean exceptionThrown = false;

        Test.startTest();

        System.runAs(objUserBilling) {
            try{
                objMC.SomDig_SACConceptionManager__c = objUserBilling.ID;
                update objMC;
            }catch(Exception e){
               exceptionThrown = e.getMessage().contains(Adv_MediaCampaign_FieldValidation.SACCONCEPTIONMANAGERERROR);
            }
        }

        Test.stopTest();

        System.Assert(!exceptionThrown);

    }

    @isTest
    public static void testChangeSACConceptionManagerAsTeamLead() {

        User objUserLead = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_PAM');
        objUserLead.SomDig_IsTeamLead__c = true;
        update objUserLead;

        ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(false);
        objMC.RecordTypeID = cls_P7S1_Utils.getRecordTypeId('ADvendio__MediaCampaign__c', 'SomDig_Auftrag');
        insert objMC;

        Boolean exceptionThrown = false;

        Test.startTest();

        System.runAs(objUserLead) {
            try{
                objMC.SomDig_SACConceptionManager__c = objUserLead.ID;
                update objMC;
            }catch(Exception e){
               exceptionThrown = e.getMessage().contains(Adv_MediaCampaign_FieldValidation.SACCONCEPTIONMANAGERERROR);
            }
        }

        Test.stopTest();

        System.Assert(!exceptionThrown);

    }

    @isTest
    public static void testChangeSACConceptionManagerAsPAM() {

        User objUserPAM = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_PAM');
        objUserPAM.SomDig_IsTeamLead__c = false;
        update objUserPAM;

        ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(false);
        objMC.RecordTypeID = cls_P7S1_Utils.getRecordTypeId('ADvendio__MediaCampaign__c', 'SomDig_Auftrag');
        insert objMC;

        Boolean exceptionThrown = false;

        Test.startTest();

        System.runAs(objUserPAM) {
            try{
                objMC.SomDig_SACConceptionManager__c = objUserPAM.ID;
                update objMC;
            }catch(Exception e){
               exceptionThrown = e.getMessage().contains(Adv_MediaCampaign_FieldValidation.SACCONCEPTIONMANAGERERROR);
            }
        }

        Test.stopTest();

        System.Assert(exceptionThrown);

    }


}