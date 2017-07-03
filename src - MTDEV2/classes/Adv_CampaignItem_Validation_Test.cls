@isTest
public with sharing class Adv_CampaignItem_Validation_Test {
    public static ADvendio__MediaCampaign__c camp;
    public static ADvendio__Campaign_Item__c campItem1;

    public static ADvendio__Invoice__c invoice1;
    public static ADvendio__InvoiceItem__c invoiceItem1;

    @TestSetup
    public static void Adv_CampaignItem_Validation_TestSetup(){
        camp = cls_P7S1_TestData.createTestMediaCampaign(true);

        System.debug('## insert CampaignItems');
        campItem1 = cls_P7S1_TestData.createTestCampaignItem(false, camp);
        campItem1.ADvendio__Ad_Id__c = '123';
        insert campItem1;

        System.debug('# insert Invoice');
        invoice1 = cls_P7S1_TestData.createTestInvoice(false, camp);
        invoice1.ADvendio__Status__c = 'Draft';
        insert invoice1;
        
        invoiceItem1 = cls_P7S1_TestData.createTestInvoiceItem(false, invoice1, campItem1);
        invoiceItem1.ADvendio__Salesprice__c = campItem1.ADvendio__Sales_Price__c;
        invoiceItem1.ADvendio__BookedQuantity__c = 1;
        invoiceItem1.ADvendio__FromDate__c = campItem1.ADvendio__from_Date__c;
        invoiceItem1.ADvendio__UntilDate__c = campItem1.ADvendio__until_Date__c;
        insert invoiceItem1;
    }

    @isTest
    public static void testCampaignItemValidation_isNotInvoiced(){
        campItem1 = [SELECT Id, ADvendio__Quantity__c FROM ADvendio__Campaign_Item__c LIMIT 1];
        
        Test.startTest();
        campItem1.ADvendio__Quantity__c = 1000;
        update campItem1;
        Test.stopTest();

        ADvendio__Campaign_Item__c result = [SELECT Id, ADvendio__Quantity__c FROM ADvendio__Campaign_Item__c WHERE Id = :campItem1.Id LIMIT 1];
        System.assert(result.ADvendio__Quantity__c == 1000, 'Quantity is not 1000');
    }
    
    @isTest
    public static void testCampaignItemValidation_isInvoiced(){
        boolean bCatchedException = false;
        
        invoice1 = [SELECT Id, ADvendio__Status__c FROM ADvendio__Invoice__c LIMIT 1];
        invoice1.ADvendio__Status__c = 'Invoiced';
        update invoice1;
        
        campItem1 = [SELECT Id, ADvendio__AC__c, ADvendio__Quantity__c FROM ADvendio__Campaign_Item__c LIMIT 1];
        try{
            Test.startTest();
            campItem1.ADvendio__AC__c  = !campItem1.ADvendio__AC__c;
            update campItem1;
            Test.stopTest();
        }
        catch(Exception e){
            bCatchedException = true;
        }

        ADvendio__Campaign_Item__c result = [SELECT Id, ADvendio__Quantity__c FROM ADvendio__Campaign_Item__c WHERE Id = :campItem1.Id LIMIT 1];
        System.assert(result.ADvendio__Quantity__c != 1000, 'Quantity is 1000');
        System.assert(bCatchedException, 'No Exception found');
        
    }
    
     @isTest
    public static void testCampaignItemValidation_isCanceled(){
        boolean bCatchedException = false;
        
        invoice1 = [SELECT Id, ADvendio__Status__c FROM ADvendio__Invoice__c LIMIT 1];
        invoice1.ADvendio__Status__c = 'Canceled';
        update invoice1;
        
        campItem1 = [SELECT Id, ADvendio__AC__c, ADvendio__Quantity__c FROM ADvendio__Campaign_Item__c LIMIT 1];
        try{
            Test.startTest();
            campItem1.ADvendio__AC__c  = !campItem1.ADvendio__AC__c;
            update campItem1;
            Test.stopTest();
        }
        catch(Exception e){
            bCatchedException = true;
        }

        ADvendio__Campaign_Item__c result = [SELECT Id, ADvendio__Quantity__c FROM ADvendio__Campaign_Item__c WHERE Id = :campItem1.Id LIMIT 1];
        System.assert(result.ADvendio__Quantity__c != 1000, 'Quantity is 1000');
        System.assert(!bCatchedException, 'Exception found');
        
    }

    @isTest
    public static void testCampaignItemValidation_AdIdOnInsert() {
        Boolean bCatchedException = false;
        camp = [SELECT Id FROM ADvendio__MediaCampaign__c LIMIT 1];
        ADvendio__Campaign_Item__c ci = cls_P7S1_TestData.createTestCampaignItem(false, camp);
        
        Test.startTest();

        try {
            ci.ADvendio__Ad_Id__c = '123';
            insert ci;
        } catch(Exception e) {
            bCatchedException = true;
        }

        Test.stopTest();

        System.assert(bCatchedException);

    }

    @isTest
    public static void testCampaignItemValidation_AdIdOnUpdate() {
        Boolean bCatchedException = false;
        camp = [SELECT Id FROM ADvendio__MediaCampaign__c LIMIT 1];
        ADvendio__Campaign_Item__c ci = cls_P7S1_TestData.createTestCampaignItem(true, camp);
        
        System.assertEquals('123', [SELECT ADvendio__Ad_Id__c FROM ADvendio__Campaign_Item__c LIMIT 1].ADvendio__Ad_Id__c);

        Test.startTest();

        try {
            ci.ADvendio__Ad_Id__c = '123';
            update ci;
        } catch(Exception e) {
            bCatchedException = true;
        }

        Test.stopTest();

        System.assert(bCatchedException);

    }

    @isTest
    public static void testCampaignItemValidation_AdIdOnInsertNegativ() {
        Boolean bCatchedException = false;
        campItem1 = [SELECT ADvendio__from_Date__c, ADvendio__until_Date__c, ADvendio__Ad_Id__c FROM ADvendio__Campaign_Item__c LIMIT 1];
        campItem1.ADvendio__from_Date__c = Date.newInstance(Date.today().addyears(-1).year(), 12, 1);
        campItem1.ADvendio__until_Date__c = Date.newInstance(Date.today().addyears(-1).year(), 12, 31);
        update campItem1;

        cls_P7S1_TestData.Zahlungsbedingung_TestData = [SELECT Id FROM SomDig_Zahlungsbedingung__c LIMIT 1];

        Test.startTest();

        ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(true);
        ADvendio__Campaign_Item__c ci = cls_P7S1_TestData.createTestCampaignItem(false, objMC);

        try {
            ci.ADvendio__Ad_Id__c = '123';
            insert ci;
        } catch(Exception e) {
            bCatchedException = true;
        }

        Test.stopTest();

        System.assert(!bCatchedException);

    }

    @isTest
    public static void testCampaignItemValidation_AdIdOnUpdateNegativ() {
        Boolean bCatchedException = false;
        campItem1 = [SELECT ADvendio__from_Date__c, ADvendio__until_Date__c, ADvendio__Ad_Id__c FROM ADvendio__Campaign_Item__c LIMIT 1];
        campItem1.ADvendio__from_Date__c = Date.newInstance(Date.today().addyears(-1).year(), 12, 1);
        campItem1.ADvendio__until_Date__c = Date.newInstance(Date.today().addyears(-1).year(), 12, 31);
        update campItem1;

        cls_P7S1_TestData.Zahlungsbedingung_TestData = [SELECT Id FROM SomDig_Zahlungsbedingung__c LIMIT 1];
       
        Test.startTest();

        ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(true);
        ADvendio__Campaign_Item__c ci = cls_P7S1_TestData.createTestCampaignItem(true, objMC);

        try {
            ci.ADvendio__Ad_Id__c = '123';
            update ci;
        } catch(Exception e) {
            bCatchedException = true;
        }

        Test.stopTest();

        System.assert(!bCatchedException);

    }

}