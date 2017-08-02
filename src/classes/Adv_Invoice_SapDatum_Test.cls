@isTest
private class Adv_Invoice_SapDatum_Test {
	
	@isTest static void testAssignSapDateWithValidInvoiceMonth() {

		ADvendio__MediaCampaign__c mediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(true);
		ADvendio__Invoice__c invoice = cls_P7S1_TestData.createTestInvoice(false, mediaCampaign);

		SomDig_InvoiceMonth__c invoiceMonth = new SomDig_InvoiceMonth__c(SomDig_Month__c = 5, SomDig_Year__c = 2016, SomDig_To__c = Date.today().addMonths(-2));
		insert invoiceMonth;

		SomDig_InvoiceMonth__c invoiceMonth2 = new SomDig_InvoiceMonth__c(SomDig_Month__c = 6, SomDig_Year__c = 2016, SomDig_To__c = Date.today().addMonths(-1));
		insert invoiceMonth2;

		SomDig_InvoiceMonth__c invoiceMonth3 = new SomDig_InvoiceMonth__c(SomDig_Month__c = 8, SomDig_Year__c = 2016, SomDig_To__c = Date.today().addMonths(1));
		insert invoiceMonth3;

		SomDig_InvoiceMonth__c invoiceMonth4 = new SomDig_InvoiceMonth__c(SomDig_Month__c = 9, SomDig_Year__c = 2016, SomDig_To__c = Date.today().addMonths(2));
		insert invoiceMonth4;

		

		Test.startTest();

		insert invoice;
		ADvendio__Invoice__c checkInvoice = [SELECT SomDig_SapBuchungsdatumAuto__c, ADvendio__InvoiceDate__c FROM ADvendio__Invoice__c WHERE Id = :invoice.Id];

		invoice.ADvendio__InvoiceDate__c = Date.today().addMonths(-2);
		update invoice;
		ADvendio__Invoice__c checkInvoice2 = [SELECT SomDig_SapBuchungsdatumAuto__c, ADvendio__InvoiceDate__c FROM ADvendio__Invoice__c WHERE Id = :invoice.Id];

		invoice.ADvendio__InvoiceDate__c = Date.today().addMonths(-2).addDays(1);
		update invoice;
		ADvendio__Invoice__c checkInvoice3 = [SELECT SomDig_SapBuchungsdatumAuto__c, ADvendio__InvoiceDate__c FROM ADvendio__Invoice__c WHERE Id = :invoice.Id];
        
        invoiceMonth2.SomDig_To__c = Date.today().addMonths(-3);
        update invoiceMonth2;
        Adv_Invoice_SapDatum.cachedInvoiceMonths = null;
        
		invoice.ADvendio__Status__c = 'Invoiced';
        update invoice;
        ADvendio__Invoice__c checkInvoice4 = [SELECT SomDig_SapBuchungsdatumAuto__c, ADvendio__InvoiceDate__c FROM ADvendio__Invoice__c WHERE Id = :invoice.Id];
        
        
		Test.stopTest();

		System.assertEquals('08.2016', checkInvoice.SomDig_SapBuchungsdatumAuto__c);
		System.assertEquals('05.2016', checkInvoice2.SomDig_SapBuchungsdatumAuto__c);
		System.assertEquals('06.2016', checkInvoice3.SomDig_SapBuchungsdatumAuto__c);
        System.assertEquals('08.2016', checkInvoice4.SomDig_SapBuchungsdatumAuto__c);
        
        System.assertEquals(checkInvoice3.ADvendio__InvoiceDate__c, checkInvoice4.ADvendio__InvoiceDate__c);
	}

	@isTest static void testAssignSapDateWithoutValidInvoiceMonth() {

		ADvendio__MediaCampaign__c mediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(true);
		ADvendio__Invoice__c invoice = cls_P7S1_TestData.createTestInvoice(false, mediaCampaign);
		
		Test.startTest();

		insert invoice;

		Test.stopTest();

		ADvendio__Invoice__c checkInvoice = [SELECT SomDig_SapBuchungsdatumAuto__c, ADvendio__InvoiceDate__c FROM ADvendio__Invoice__c WHERE Id = :invoice.Id];
		String month = String.valueOf(checkInvoice.ADvendio__InvoiceDate__c.month());
		if(month.length() == 1) month = '0' + month;
		String result = month + '.' + checkInvoice.ADvendio__InvoiceDate__c.year();
		System.assertEquals(result, checkInvoice.SomDig_SapBuchungsdatumAuto__c);
	
	}
	
}