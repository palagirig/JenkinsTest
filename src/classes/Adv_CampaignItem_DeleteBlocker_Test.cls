@isTest
private class Adv_CampaignItem_DeleteBlocker_Test {

	@isTest static void testPreventDeleteWithInvoiceItem() {
		ADvendio__MediaCampaign__c mediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(true);
		ADvendio__Campaign_Item__c campaignItem = cls_P7S1_TestData.createTestCampaignItem(true, mediaCampaign);

		ADvendio__Invoice__c invoice = cls_P7S1_TestData.createTestInvoice(true, mediaCampaign);
		ADvendio__InvoiceItem__c invoiceItem = cls_P7S1_TestData.createTestInvoiceItem(false, invoice, campaignItem);
		invoiceItem.ADvendio__BookedQuantity__c		= 100000;
        invoiceItem.ADvendio__SalesPrice__c			= 10;
        invoiceItem.ADvendio__BillingCategory__c	= 'CPM';
        invoiceItem.ADvendio__FromDate__c			= system.today();
        invoiceItem.ADvendio__UntilDate__c			= system.today();
        insert invoiceItem;

		Test.startTest();

		// Ticket 4402 Magneto: keine Pr�fung mehr auf korrekten Fehlertext, Pr�fung bleibt aber erst mal bestehen
		try {
			delete campaignItem;
			System.assert(false);
		} catch(Exception e) {
			//System.assert(e.getMessage().contains(Label.Adv_CampaignItem_DeleteBlocker_Message));
			System.assert(true);
		}

		Test.stopTest();

	}

	@isTest static void testPreventDeleteWithoutInvoiceItem() {
		ADvendio__MediaCampaign__c mediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(true);
		ADvendio__Campaign_Item__c campaignItem = cls_P7S1_TestData.createTestCampaignItem(true, mediaCampaign);

		ADvendio__Invoice__c invoice = cls_P7S1_TestData.createTestInvoice(true, mediaCampaign);

		Test.startTest();

		delete campaignItem;

		Test.stopTest();

		List<ADvendio__Campaign_Item__c> checkCampaignItem = new List<ADvendio__Campaign_Item__c>([SELECT Id FROM ADvendio__Campaign_Item__c WHERE Id = :campaignItem.Id]);
		System.assert(checkCampaignItem.isEmpty());

	}

}