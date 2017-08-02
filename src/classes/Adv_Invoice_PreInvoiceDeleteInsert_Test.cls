@isTest
private class Adv_Invoice_PreInvoiceDeleteInsert_Test {

    @isTest
    static void testAdv_Invoice_PreInvoiceDeleteInsert() {
        ADvendio__MediaCampaign__c mc1 = cls_P7S1_TestData.createTestMediaCampaign(false);
        mc1.Name='Test MediaCampaign 1';
        mc1.ADvendio__BillMe__c=true;
        mc1.ADvendio__Stage__c='Booked';
        mc1.ADvendio__PaymentStart__c='after Billingperiod';
        mc1.ADvendio__PaymentDueDate__c='due to the end of interval';
        mc1.ADvendio__PaymentInterval__c='monthly';
        insert mc1;

        ADvendio__Campaign_Item__c ci1 = cls_P7S1_TestData.createTestCampaignItem(true, mc1);

        Test.startTest();
        // Now test the right class.
        // Can't verify the results because it will call a batch job.
        // So just test it for code coverage.
        Adv_Invoice_PreInvoiceDeleteInsert c = new Adv_Invoice_PreInvoiceDeleteInsert();

        c.setRecordIds(null);

        c.addRecordId(mc1.Id);

        c.createPreInvoice();

        String sch = '0 0 23 * * ?';

        System.schedule('Test Adv_Invoice_PreInvoiceDeleteInsert', sch, c);

        Test.stopTest();
    }

    @isTest
    static void addRecordId(){
        ADVendio__Ad_Price__c price = cls_P7S1_TestData.createTestAdPrice(true, cls_P7S1_TestData.createTestAdSpec(true));
        ADvendio__Campaign_Item__c campItem1 = cls_P7S1_TestData.createTestCampaignItem(true, cls_P7S1_TestData.createTestMediaCampaign(true), price);
        
        Test.startTest();
        Adv_Invoice_PreInvoiceDeleteInsert c = new Adv_Invoice_PreInvoiceDeleteInsert();
        c.addRecordId(campItem1.ADvendio__Media_Campaign__c);
        Test.stopTest();

        System.assert(c.recIds != null && c.recIds.contains(campItem1.ADvendio__Media_Campaign__c));
    }

    @isTest
    static void setRecordIds(){
        ADVendio__Ad_Price__c price = cls_P7S1_TestData.createTestAdPrice(true, cls_P7S1_TestData.createTestAdSpec(true));
        ADvendio__Campaign_Item__c campItem1 = cls_P7S1_TestData.createTestCampaignItem(true, cls_P7S1_TestData.createTestMediaCampaign(true), price);
        ADvendio__Campaign_Item__c campItem2 = cls_P7S1_TestData.createTestCampaignItem(true, cls_P7S1_TestData.createTestMediaCampaign(true), price);
        
        Set<Id> setIds = new Set<Id>();
        setIds.add(campItem1.ADvendio__Media_Campaign__c);
        setIds.add(campItem2.ADvendio__Media_Campaign__c);

        Test.startTest();
        Adv_Invoice_PreInvoiceDeleteInsert c = new Adv_Invoice_PreInvoiceDeleteInsert();
        c.setRecordIds(setIds);
        Test.stopTest();

        System.assert(c.recIds != null && c.recIds.containsAll(setIds));
    }

    @isTest
    static void deletePreInvoiceWithBillMeFalse(){
        SomDig_Auftragstyp__c auftragstyp = cls_P7S1_TestData.createTestAuftragstyp(false);
        auftragstyp.SomDig_Rechnungstellung__c = false;
        insert auftragstyp;
        ADvendio__Pricelist__c pricelist = cls_P7S1_TestData.createTestPricelist(true, auftragstyp);
        
        ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(true, null, pricelist);
        objMC.ADvendio__BillMe__c = false;
        update objMC;
        
        ADvendio__Invoice__c invoice = cls_P7S1_TestData.createTestInvoice(false, objMC);
        invoice.ADvendio__Status__c = 'Draft';
        insert invoice;
		
        Test.startTest();
        new Adv_Invoice_PreInvoiceDeleteInsert().deletePreInvoice();
        Test.stopTest();

        System.assert([SELECT Id FROM ADvendio__Invoice__c].size() == 0);

    }

    @isTest
    static void deletePreInvoiceWithBillMeTrue(){
        ADvendio__MediaCampaign__c camp = cls_P7S1_TestData.createTestMediaCampaign(false);
        camp.ADvendio__BillMe__c = true;
        camp.ADvendio__Stage__c = 'Booked';
        insert camp;

        ADvendio__Invoice__c invoice = cls_P7S1_TestData.createTestInvoice(false, camp);
        invoice.ADvendio__Status__c = 'Draft';
        insert invoice;

        Test.startTest();
        new Adv_Invoice_PreInvoiceDeleteInsert().deletePreInvoice();
        Test.stopTest();

        System.assert([SELECT Id FROM ADvendio__Invoice__c].size() > 0);

    }

    @isTest
    static void deletePreInvoiceWithAnValidInvoice(){
        ADvendio__Invoice__c invoice = cls_P7S1_TestData.createTestInvoice(false, cls_P7S1_TestData.createTestMediaCampaign(true));
        invoice.ADvendio__Status__c = 'Invoiced';
        insert invoice;

        Test.startTest();
        new Adv_Invoice_PreInvoiceDeleteInsert().deletePreInvoice();
        Test.stopTest();

        System.assert([SELECT Id FROM ADvendio__Invoice__c].size() > 0);

    }
}