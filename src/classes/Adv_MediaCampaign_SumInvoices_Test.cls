@isTest
public with sharing class Adv_MediaCampaign_SumInvoices_Test {
	
	@isTest
	static void testSumInvoices() {

		ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(true);

		ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(true, objMC);

		ADvendio__Invoice__c objInvoice = cls_P7S1_TestData.createTestInvoice(true, objMC);
		ADvendio__InvoiceItem__c objInvoiceItem = cls_P7S1_TestData.createTestInvoiceItem(false, objInvoice, objCI);
        objInvoiceItem.ADvendio__Salesprice__c = objCI.ADvendio__Sales_Price__c;
        objInvoiceItem.ADvendio__BookedQuantity__c = 1000;
        objInvoiceItem.ADvendio__FromDate__c = objCI.ADvendio__from_Date__c;
        objInvoiceItem.ADvendio__UntilDate__c = objCI.ADvendio__until_Date__c;
        objInvoiceItem.ADvendio__QuantityDelivered__c = 1000;
        objInvoiceItem.ADvendio__BillingCategory__c = 'CPM';
        insert objInvoiceItem;

        objInvoice.ADvendio__InvoiceType__c = 'Invoice';
		objInvoice.ADvendio__Status__c = 'Invoiced';
		update objInvoice;

		Test.startTest();

		Database.executeBatch(new Adv_MediaCampaign_SumInvoices(), 5);

		Test.stopTest();

		System.assertEquals(30, [SELECT ADvendio__InvoicedAmountNet2__c FROM ADvendio__Invoice__c WHERE ID = :objInvoice.Id].ADvendio__InvoicedAmountNet2__c);
		System.assertEquals('Invoice', [SELECT ADvendio__InvoiceType__c FROM ADvendio__Invoice__c WHERE ID = :objInvoice.Id].ADvendio__InvoiceType__c);
		System.assertEquals('Invoiced', [SELECT ADvendio__Status__c FROM ADvendio__Invoice__c WHERE ID = :objInvoice.Id].ADvendio__Status__c);
		System.assertEquals(30, [SELECT SomDig_AbgerechneterMN2__c FROM ADvendio__MediaCampaign__c WHERE Id = :objMC.Id].SomDig_AbgerechneterMN2__c);


	}

	@isTest
	static void testSumInvoices2() {

		ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(true);

		ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(true, objMC);

		ADvendio__Invoice__c objInv = cls_P7S1_TestData.createTestInvoice(false, objMC);
        objInv.ADvendio__InvoiceType__c = 'Invoice';
        objInv.SomDig_Rechnungsfreigabe__c = false;
        insert objInv;

        ADvendio__InvoiceItem__c objInvoiceItem = cls_P7S1_TestData.createTestInvoiceItem(false, objInv, objCI);
        objInvoiceItem.ADvendio__Salesprice__c = objCI.ADvendio__Sales_Price__c;
        objInvoiceItem.ADvendio__BookedQuantity__c = 1000;
        objInvoiceItem.ADvendio__FromDate__c = objCI.ADvendio__from_Date__c;
        objInvoiceItem.ADvendio__UntilDate__c = objCI.ADvendio__until_Date__c;
        objInvoiceItem.ADvendio__QuantityDelivered__c = 1000;
        objInvoiceItem.ADvendio__BillingCategory__c = 'CPM';
        insert objInvoiceItem;

        objInv.ADvendio__Status__c = 'Canceled';
        update objInv;

        ADvendio__Invoice__c objCancel = cls_P7S1_TestData.createTestInvoice(false, objMC);
        objCancel.SomDig_Rechnungsfreigabe__c = false;
        insert objCancel;

        ADvendio__InvoiceItem__c objInvoiceItem2 = cls_P7S1_TestData.createTestInvoiceItem(false, objCancel, objCI);
        objInvoiceItem2.ADvendio__Salesprice__c = objCI.ADvendio__Sales_Price__c;
        objInvoiceItem2.ADvendio__BookedQuantity__c = 1000;
        objInvoiceItem2.ADvendio__FromDate__c = objCI.ADvendio__from_Date__c;
        objInvoiceItem2.ADvendio__UntilDate__c = objCI.ADvendio__until_Date__c;
        objInvoiceItem2.ADvendio__QuantityDelivered__c = 1000;
        objInvoiceItem2.ADvendio__BillingCategory__c = 'CPM';
        objInvoiceItem2.ADvendio__ConnectedItem__c = objInvoiceItem.Id;
        objInvoiceItem2.ADvendio__InvoicedQuantityMultiplier__c	= -1;
        objInvoiceItem2.ADvendio__InvoicedAmountNet2__c = 30;
        insert objInvoiceItem2;

        objCancel.ADvendio__InvoiceType__c = 'Cancellation';
        objCancel.ADvendio__Status__c = 'Invoiced';
        update objCancel;


        ADvendio__Invoice__c objCancel2 = cls_P7S1_TestData.createTestInvoice(false, objMC);
        objCancel2.ADvendio__InvoiceType__c = 'Cancellation';
        objCancel2.SomDig_Rechnungsfreigabe__c = true;
        objCancel2.ADvendio__Invoice__c = objInv.Id;
        insert objCancel2;

        ADvendio__InvoiceItem__c objInvoiceItem3 = cls_P7S1_TestData.createTestInvoiceItem(false, objCancel2, objCI);
        objInvoiceItem3.ADvendio__Salesprice__c = objCI.ADvendio__Sales_Price__c;
        objInvoiceItem3.ADvendio__BookedQuantity__c = 1000;
        objInvoiceItem3.ADvendio__FromDate__c = objCI.ADvendio__from_Date__c;
        objInvoiceItem3.ADvendio__UntilDate__c = objCI.ADvendio__until_Date__c;
        objInvoiceItem3.ADvendio__QuantityDelivered__c = 1000;
        objInvoiceItem3.ADvendio__BillingCategory__c = 'CPM';
        objInvoiceItem3.ADvendio__ConnectedItem__c = objInvoiceItem.Id;
        objInvoiceItem3.ADvendio__InvoicedQuantityMultiplier__c	= -1;
        objInvoiceItem3.ADvendio__GrossAmountB1__c = 30;	
        objInvoiceItem3.ADvendio__InvoicedAmountNet2__c = 30;
        insert objInvoiceItem3;

        System.assertEquals(-30, [SELECT ADvendio__InvoicedAmountNet2__c FROM ADvendio__Invoice__c WHERE ID = :objCancel2.Id].ADvendio__InvoicedAmountNet2__c);
		System.assertEquals(-30, [SELECT ADvendio__InvoicedAmountNet2__c FROM ADvendio__InvoiceItem__c WHERE ID = :objInvoiceItem3.Id].ADvendio__InvoicedAmountNet2__c);

		ADvendio__Invoice__c objDraft = cls_P7S1_TestData.createTestInvoice(true, objMC);

        ADvendio__InvoiceItem__c objDraftInvoiceItem = cls_P7S1_TestData.createTestInvoiceItem(false, objDraft, objCI);
        objDraftInvoiceItem.ADvendio__Salesprice__c = objCI.ADvendio__Sales_Price__c;
        objDraftInvoiceItem.ADvendio__BookedQuantity__c = 1000;
        objDraftInvoiceItem.ADvendio__FromDate__c = objCI.ADvendio__from_Date__c;
        objDraftInvoiceItem.ADvendio__UntilDate__c = objCI.ADvendio__until_Date__c;
        objDraftInvoiceItem.ADvendio__QuantityDelivered__c = 1000;
        objDraftInvoiceItem.ADvendio__BillingCategory__c = 'CPM';
        insert objDraftInvoiceItem;


		Test.startTest();

		Database.executeBatch(new Adv_MediaCampaign_SumInvoices(), 5);

		Test.stopTest();

		System.assertEquals(30, [SELECT ADvendio__InvoicedAmountNet2__c FROM ADvendio__Invoice__c WHERE ID = :objInv.Id].ADvendio__InvoicedAmountNet2__c);
		System.assertEquals(-30, [SELECT ADvendio__InvoicedAmountNet2__c FROM ADvendio__Invoice__c WHERE ID = :objCancel.Id].ADvendio__InvoicedAmountNet2__c);
		System.assertEquals(-30, [SELECT ADvendio__InvoicedAmountNet2__c FROM ADvendio__Invoice__c WHERE ID = :objCancel2.Id].ADvendio__InvoicedAmountNet2__c);
		System.assertEquals('Invoice', [SELECT ADvendio__InvoiceType__c FROM ADvendio__Invoice__c WHERE ID = :objInv.Id].ADvendio__InvoiceType__c);
		System.assertEquals('Canceled', [SELECT ADvendio__Status__c FROM ADvendio__Invoice__c WHERE ID = :objInv.Id].ADvendio__Status__c);
		System.assertEquals('Cancellation', [SELECT ADvendio__InvoiceType__c FROM ADvendio__Invoice__c WHERE ID = :objCancel.Id].ADvendio__InvoiceType__c);
		System.assertEquals('Invoiced', [SELECT ADvendio__Status__c FROM ADvendio__Invoice__c WHERE ID = :objCancel.Id].ADvendio__Status__c);
		System.assertEquals('Cancellation', [SELECT ADvendio__InvoiceType__c FROM ADvendio__Invoice__c WHERE ID = :objCancel2.Id].ADvendio__InvoiceType__c);
		System.assertEquals('Reviewed', [SELECT ADvendio__Status__c FROM ADvendio__Invoice__c WHERE ID = :objCancel2.Id].ADvendio__Status__c);
		System.assertEquals('Invoice', [SELECT ADvendio__InvoiceType__c FROM ADvendio__Invoice__c WHERE ID = :objDraft.Id].ADvendio__InvoiceType__c);
		System.assertEquals('Draft', [SELECT ADvendio__Status__c FROM ADvendio__Invoice__c WHERE ID = :objDraft.Id].ADvendio__Status__c);
		
		System.assertEquals(-30, [SELECT SomDig_AbgerechneterMN2__c FROM ADvendio__MediaCampaign__c WHERE Id = :objMC.Id].SomDig_AbgerechneterMN2__c);


	}

}