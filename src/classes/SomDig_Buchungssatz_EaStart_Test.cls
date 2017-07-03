/**
 * Test class for SomDig_Buchungssatz_EaStart.
 */
@IsTest
public with sharing class SomDig_Buchungssatz_EaStart_Test {

	@IsTest
	public static void testEaStartPagination()  {
		Test.StartTest();

		PageReference pr = Page.SomDig_Buchungssatz_EaStart;
		Test.setCurrentPage(pr);		

		SomDig_Buchungssatz_EaStart crtl = new SomDig_Buchungssatz_EaStart();
		
		for (Integer i = 0; i <= SomDig_Buchungssatz_EaStart.MAX_NUMBER_MCS_PER_PAGE; i++) {
			crtl.allMediaCampaigns.add(new ADvendio__MediaCampaign__c(Name=('Test Mc ' + (i+1))));
		}
		
		crtl.initPagination();
		
		System.assertEquals(true, crtl.getHasResult());
		System.assertEquals(2, crtl.getTotalPages());

		System.assertEquals(1, crtl.getPageNumber());
		System.assertEquals(true, crtl.getHasNext());
		System.assertEquals(false, crtl.getHasPrevious());
		
		crtl.next();
		System.assertEquals(2, crtl.getPageNumber());
		System.assertEquals(false, crtl.getHasNext());
		System.assertEquals(true, crtl.getHasPrevious());
		
		crtl.previous();
		System.assertEquals(1, crtl.getPageNumber());
		System.assertEquals(true, crtl.getHasNext());
		System.assertEquals(false, crtl.getHasPrevious());

		crtl.last();
		System.assertEquals(2, crtl.getPageNumber());
		System.assertEquals(false, crtl.getHasNext());
		System.assertEquals(true, crtl.getHasPrevious());
		
		crtl.first();
		System.assertEquals(1, crtl.getPageNumber());
		System.assertEquals(true, crtl.getHasNext());
		System.assertEquals(false, crtl.getHasPrevious());
				
		crtl.filterMediaCampaign.ADvendio__Closed_Lost__c = false;
		crtl.changeProcessRunningDate();

		Test.StopTest();
	}

	@isTest
	public static void testFilterMonthly()  {
		Date today	= Date.newInstance(System.today().year(), System.today().month(), 15);
		
		SomDig_Mediagattungssegment__c mgs			= cls_P7S1_TestData.createTestMediagattungsSegment(true);
				
		ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true, null, null);
   		ADvendio__Campaign_Item__c ci		= cls_P7S1_TestData.createTestCampaignItem(false, mc, null);
        insert new List<ADvendio__Campaign_Item__c>{ci};
		
		ADvendio__Invoice__c i						= cls_P7S1_TestData.createTestInvoice(false, mc);
		i.ADvendio__Status__c						= 'Invoiced';
		i.ADvendio__PaymentInterval__c				= 'monthly (1 month)';
        i.ADvendio__PaymentStart__c					= 'after Billingperiod';
        i.ADvendio__AccountingDate__c				= today.toStartOfMonth().addMonths(-1);
        i.ADvendio__BillingPeriodEndDate__c			= today.addDays(-20);
        i.ADvendio__InvoiceDateManual__c			= today.toStartOfMonth();
        i.ADvendio__InvoiceDate__c					= today.toStartOfMonth();
        i.SomDig_RG_Empfaenger_P7S1_Konzernmitgl__c	= true;
        i.SomDig_PartnerId__c						= '12345';
		insert i;
        
		ADvendio__InvoiceItem__c ii			= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci);
		ii.ADvendio__Salesprice__c			= 10;
		ii.ADvendio__BookedQuantity__c		= 1000;
		ii.ADvendio__BillingCategory__c		= 'CPM';
        ii.ADvendio__LinearDistribution__c	= true;
		ii.ADvendio__FromDate__c			= today.addDays(-25);
		ii.ADvendio__UntilDate__c			= today.addDays(-19);
		ii.ADvendio__InvoiceItemStartDate__c = today.addDays(-25);
		ii.ADvendio__InvoiceItemEndDate__c	= today.addDays(-19);
		ii.SomDig_Adservertyp__c			= 'DFP';
		ii.SomDig_Mediagattungs_Segement_Name__c = mgs.Name;
		insert ii;

		Test.StartTest();
		SomDig_Buchungssatz_EaStart cls = new SomDig_Buchungssatz_EaStart();
		cls.filterMediaCampaign.ADvendio__Close_Date__c	= today;
		cls.changeProcessRunningDate();
		cls.doSearch();
		
		system.assertEquals(1, cls.allMediaCampaigns.size());
		cls.toggleSelection();

        // Item Storno
        ADvendio__Invoice__c iNeg	= i.clone();
        iNeg.ADvendio__Invoice__c	= i.Id;
        iNeg.ADvendio__Status__c	= 'Invoiced';
        insert iNeg;
        
        ADvendio__InvoiceItem__c iiNeg					= ii.clone();
        iiNeg.ADvendio__InvoicedQuantityMultiplier__c	= -1;
        iiNeg.ADvendio__Invoice__c						= iNeg.Id;
        iiNeg.ADvendio__InvoicedAmountNet2__c			= 10;
        iiNeg.ADvendio__ConnectedItem__c				= ii.Id;
        iiNeg.ADvendio__UniqueKey__c					= 'rtz';//ii.ADvendio__UniqueKey__c + '|tmp|';
        insert iiNeg;
				
		Test.StopTest();
		cls.filterMediaCampaign.ADvendio__Close_Date__c	= today;
		cls.changeProcessRunningDate();
		cls.doSearch();
		
		system.assertEquals(1, cls.allMediaCampaigns.size());
		
		cls.runProcess();
	}

	@isTest
	public static void testFilterTotal()  {
		Date today	= Date.newInstance(System.today().year(), System.today().month(), 15);
		
		SomDig_Mediagattungssegment__c mgs			= cls_P7S1_TestData.createTestMediagattungsSegment(true);
				
		ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true, null, null);
   		ADvendio__Campaign_Item__c ci		= cls_P7S1_TestData.createTestCampaignItem(false, mc, null);
        insert new List<ADvendio__Campaign_Item__c>{ci};
		
        ADvendio__Invoice__c i				= cls_P7S1_TestData.createTestInvoice(false, mc);
		i.ADvendio__Status__c				= 'Invoiced';
		i.ADvendio__PaymentInterval__c		= 'total account (one Invoice)';
        i.ADvendio__PaymentStart__c			= 'before / during Billingperiod';
        i.ADvendio__AccountingDate__c		= today.toStartOfMonth();
        i.ADvendio__BillingPeriodEndDate__c	= today.addDays(90);
		insert i;
        
		ADvendio__InvoiceItem__c ii			= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci);
		ii.ADvendio__Salesprice__c			= 300;
		ii.ADvendio__BookedQuantity__c		= 1000;
		ii.ADvendio__BillingCategory__c		= 'CPM';
        ii.ADvendio__LinearDistribution__c	= true;
		ii.ADvendio__FromDate__c			= today;
		ii.ADvendio__UntilDate__c			= today.addDays(90);
		ii.ADvendio__InvoiceItemStartDate__c = today;
		ii.ADvendio__InvoiceItemEndDate__c	= today.addDays(90);
		ii.SomDig_Adservertyp__c			= 'DFP';
		ii.SomDig_Mediagattungs_Segement_Name__c = mgs.Name;
		insert ii;

		Test.StartTest();
		SomDig_Buchungssatz_EaStart cls = new SomDig_Buchungssatz_EaStart();
		cls.filterMediaCampaign.ADvendio__Close_Date__c	= today;
		cls.changeProcessRunningDate();
		cls.doSearch();
		
		system.assertEquals(1, cls.allMediaCampaigns.size());
		cls.toggleSelection();

		SomDig_PRAP__c prap	= new SomDig_PRAP__c();
		prap.SomDig_Status__C	= 'Aufgelöst';
		prap.SomDig_Rechnungsposition__c	= ii.Id;
		prap.SomDig_AbgerechneteErloese__c	= 10;
		prap.SomDig_AbzugrenzendeErloese__c	= 10;
		insert prap;

		cls = new SomDig_Buchungssatz_EaStart();
		cls.filterMediaCampaign.ADvendio__Close_Date__c	= today;
		cls.changeProcessRunningDate();
		cls.doSearch();
		
		system.assertEquals(0, cls.allMediaCampaigns.size());
	}
}