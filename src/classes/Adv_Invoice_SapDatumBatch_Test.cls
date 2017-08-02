@isTest
private class Adv_Invoice_SapDatumBatch_Test {
    
    @isTest static void testAdv_Invoice_SapDatumBatch() {

        ADvendio__Invoice__c invoice = cls_P7S1_TestData.createTestInvoice(true, null);
        
        ADvendio__Invoice__c invoice2 = cls_P7S1_TestData.createTestInvoice(true, null);
        invoice2.ADvendio__InvoiceDate__c = Date.today().addDays(-61);
        update invoice2;        

        SomDig_InvoiceMonth__c invoiceMonth = new SomDig_InvoiceMonth__c(SomDig_Month__c = 2, SomDig_Year__c = 2015, SomDig_To__c = Date.today().addMonths(2));
        insert invoiceMonth;

        SomDig_InvoiceMonth__c invoiceMonth2 = new SomDig_InvoiceMonth__c(SomDig_Month__c = 3, SomDig_Year__c = 2016, SomDig_To__c = Date.today().addMonths(5));
        insert invoiceMonth2;

        //need to clear the cache, since new invoicemonth records have been inserted during current execution context.
        Adv_Invoice_SapDatum.cachedInvoiceMonths = null;

        ADvendio__Invoice__c invoice3 = cls_P7S1_TestData.createTestInvoice(true, null);
        invoice3.ADvendio__InvoiceDate__c = Date.today().addMonths(4);
        update invoice3;

        System.assertEquals('03.2016',[SELECT SomDig_SapBuchungsdatumAuto__c FROM ADvendio__Invoice__c WHERE Id = :invoice3.Id].SomDig_SapBuchungsdatumAuto__c);

        invoiceMonth2.SomDig_To__c = Date.today().addMonths(3);
        update invoiceMonth2;

        Test.startTest();

        Adv_Invoice_SapDatumBatch b = new Adv_Invoice_SapDatumBatch();
        Database.executeBatch(b);   

        Test.stopTest();

        System.assertNotEquals('03.2016',[SELECT SomDig_SapBuchungsdatumAuto__c FROM ADvendio__Invoice__c WHERE Id = :invoice3.Id].SomDig_SapBuchungsdatumAuto__c);
        System.assertEquals('02.2015',[SELECT SomDig_SapBuchungsdatumAuto__c FROM ADvendio__Invoice__c WHERE Id = :invoice.Id].SomDig_SapBuchungsdatumAuto__c);
//        System.assertNotEquals('02.2015',[SELECT SomDig_SapBuchungsdatumAuto__c FROM ADvendio__Invoice__c WHERE Id = :invoice2.Id].SomDig_SapBuchungsdatumAuto__c);
        
    }
    
}