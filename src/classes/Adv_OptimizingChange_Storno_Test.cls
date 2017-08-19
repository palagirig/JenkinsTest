@isTest
public class Adv_OptimizingChange_Storno_Test{

    @TestSetup
    static void test_Setup(){
        List<User> listUsers = new List<User>();
        User Billing_User = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_Billing');
        User AdTech_User = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_AdTech');
        User BI_User = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_BI');
        Billing_User.isActive = true;
        AdTech_User.isActive = true;
        BI_User.isActive = true;
        listUsers.add(Billing_User);
        listUsers.add(AdTech_User);
        listUsers.add(BI_User);
        update listUsers;
     }

    @isTest
    public static void testPreventStornoOhneLeistungsflussFail() {
        ADvendio__MediaCampaign__c testMediaCampaign	= cls_P7S1_TestData.createTestMediaCampaign(true);
        ADvendio__Campaign_Item__c objCI				= cls_P7S1_TestData.createTestCampaignItem(false, testMediaCampaign);
        objCI.ADvendio__From_Date__c					= system.today().addDays(-2);
        objCI.ADvendio__Until_Date__c					= system.today().addDays(-2);
        insert objCI;
        ADvendio__OptimizingVersion__c objOV			= createADvendioOptimizingVersion(true, testMediaCampaign);

        Test.startTest();

        ADvendio__OptimizingChange__c objOC = createADvendioOptimizingChange(false, objOV, objCI);
        objOC.ADvendio__FieldName__c		= 'advendio__billingstatus__c';
        objOC.ADvendio__OptimizedValue__c	= 'cancelled';

        try {
            insert objOC;
        }
        catch(Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('Es darf kein Positionstorno vor Leistungsfluss durchgeführt werden, wenn die Position bereits gestartet ist.');
            System.assert(expectedExceptionThrown);
        }

        Test.stopTest();
    }
    
    @isTest
    public static void testPreventStornoOhneLeistungsflussPass() {
        ADvendio__MediaCampaign__c testMediaCampaign	= cls_P7S1_TestData.createTestMediaCampaign(true);
        ADvendio__Campaign_Item__c objCI				= cls_P7S1_TestData.createTestCampaignItem(false, testMediaCampaign);
        objCI.ADvendio__From_Date__c					= system.today().addDays(2);
        objCI.ADvendio__Until_Date__c					= system.today().addDays(2);
        insert objCI;
        ADvendio__OptimizingVersion__c objOV			= createADvendioOptimizingVersion(true, testMediaCampaign);

        Test.startTest();

        ADvendio__OptimizingChange__c objOC = createADvendioOptimizingChange(false, objOV, objCI);
        objOC.ADvendio__FieldName__c		= 'advendio__billingstatus__c';
        objOC.ADvendio__OptimizedValue__c	= 'cancelled';

        insert objOC;

        Test.stopTest();
    }

    public static testMethod void testpreventStornoMitLeistungsflussInvoice() {
        ADvendio__MediaCampaign__c testMediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(true);

        // Campaign Item
        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(true, testMediaCampaign);

        ADvendio__Invoice__c testInvoice = cls_P7S1_TestData.createTestInvoice(false, testMediaCampaign);
        testInvoice.ADvendio__Status__c = 'Reviewed';
        insert testInvoice;

        ADvendio__InvoiceItem__c testInvoiceItem = cls_P7S1_TestData.createTestInvoiceItem(false, testInvoice, objCI);
        testInvoiceItem.ADvendio__Salesprice__c = objCI.ADvendio__Sales_Price__c;
        testInvoiceItem.ADvendio__BookedQuantity__c = 1;
        testInvoiceItem.ADvendio__FromDate__c = objCI.ADvendio__from_Date__c;
        testInvoiceItem.ADvendio__UntilDate__c = objCI.ADvendio__until_Date__c;
        insert testInvoiceItem;

        // Optimizing Version
        ADvendio__OptimizingVersion__c objOV = createADvendioOptimizingVersion(true, testMediaCampaign);
        
        ADvendio__OptimizingChange__c objOC = createADvendioOptimizingChange(false, objOV, objCI);
        objOC.ADvendio__FieldName__c = 'advendio__rate_discount_4_name__c';
        objOC.ADvendio__OptimizedValue__c = 'Storno mit Leistungsfluss';

        Boolean expectedExceptionThrown = false;

        Test.startTest();

        try {
            insert objOC;
        }
        catch(Exception e) {
            expectedExceptionThrown = e.getMessage().contains(Label.Adv_OptimizingChange_Storno_ErrorMessage);
        }

        Test.stopTest();

        System.assert(expectedExceptionThrown);
    }

    // Run without Billing Profile
    public static testMethod void testpreventStornoMitLeistungsflussNoBillingProfile() {
        User objAdTechUser = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_AdTech');

        ADvendio__MediaCampaign__c testMediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(true);
        ADvendio__Campaign_Item__c objCI             = cls_P7S1_TestData.createTestCampaignItem(true, testMediaCampaign);
        ADvendio__OptimizingVersion__c objOV         = createADvendioOptimizingVersion(true, testMediaCampaign);

        ADvendio__OptimizingChange__c objOC = createADvendioOptimizingChange(false, objOV, objCI);
        objOC.ADvendio__FieldName__c = 'advendio__rate_discount_4_name__c';
        objOC.ADvendio__OptimizedValue__c = 'Storno mit Leistungsfluss';

        Boolean expectedExceptionThrown = false;

        Test.startTest();

        System.runAs(objAdTechUser){
            try {
                insert objOC;
            }
            catch(Exception e) {
                expectedExceptionThrown = e.getMessage().contains(Label.Adv_OptimizingChange_Storno_ErrorMessage);
            }
        }

        Test.stopTest();

        System.assert(expectedExceptionThrown);
    }


    // Run with Billing Profile
    public static testMethod void testpreventStornoMitLeistungsflussWithBillingProfile() {
        User objBillingUser = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_Billing');

        ADvendio__MediaCampaign__c testMediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(true);
        ADvendio__Campaign_Item__c objCI             = cls_P7S1_TestData.createTestCampaignItem(true, testMediaCampaign);
        ADvendio__OptimizingVersion__c objOV         = createADvendioOptimizingVersion(true, testMediaCampaign);

        ADvendio__OptimizingChange__c objOC = createADvendioOptimizingChange(false, objOV, objCI);
        objOC.ADvendio__FieldName__c = 'advendio__rate_discount_4_name__c';
        objOC.ADvendio__OptimizedValue__c = 'Storno mit Leistungsfluss';

        Test.startTest();

        System.runAs(objBillingUser){
            insert objOC;
        }

        Test.stopTest();

    }   

    // Run with BI Profile
    public static testMethod void testpreventStornoMitLeistungsflussWithBIProfile() {
        User objBIUser = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_BI');

        ADvendio__MediaCampaign__c testMediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(true);
        ADvendio__Campaign_Item__c objCI             = cls_P7S1_TestData.createTestCampaignItem(true, testMediaCampaign);
        ADvendio__OptimizingVersion__c objOV         = createADvendioOptimizingVersion(true, testMediaCampaign);

        ADvendio__OptimizingChange__c objOC = createADvendioOptimizingChange(false, objOV, objCI);
        objOC.ADvendio__FieldName__c = 'advendio__rate_discount_4_name__c';
        objOC.ADvendio__OptimizedValue__c = 'Storno mit Leistungsfluss';

        Test.startTest();

        System.runAs(objBIUser){
            insert objOC;
        }

        Test.stopTest();
    }

    // User is not in public group
    public static testMethod void testpreventStornoMitLeistungsflussNoPublicGroup() {
        ADvendio__MediaCampaign__c testMediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(true);
        ADvendio__Campaign_Item__c objCI             = cls_P7S1_TestData.createTestCampaignItem(true, testMediaCampaign);
        ADvendio__OptimizingVersion__c objOV         = createADvendioOptimizingVersion(true, testMediaCampaign);

        ADvendio__OptimizingChange__c objOC = createADvendioOptimizingChange(false, objOV, objCI);
        objOC.ADvendio__FieldName__c = 'advendio__rate_discount_4_name__c';
        objOC.ADvendio__OptimizedValue__c = 'Storno mit Leistungsfluss';

        Test.startTest();

        insert objOC;

        Test.stopTest();
    }



    // TODO: move to TESTClass
    public static ADvendio__OptimizingVersion__c createADvendioOptimizingVersion(Boolean isInsert, ADvendio__MediaCampaign__c objMC){
        ADvendio__OptimizingVersion__c objOV = new ADvendio__OptimizingVersion__c();
        objOV.ADvendio__MediaCampaign__c = objMC.Id;
        if(isInsert) insert objOV;
        return objOV;
    }


    public static ADvendio__OptimizingChange__c createADvendioOptimizingChange(Boolean isInsert, ADvendio__OptimizingVersion__c objOV, ADvendio__Campaign_Item__c objCI){

        ADvendio__OptimizingChange__c objOC = new ADvendio__OptimizingChange__c();
        objOC.ADvendio__OptimizingVersion__c = objOV.ID;
        objOC.ADvendio__CampaignItem__c = objCI.ID;

        if(isInsert) insert objOC;
        return objOC;
    }

}