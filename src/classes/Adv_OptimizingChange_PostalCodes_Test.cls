@isTest
public with sharing class Adv_OptimizingChange_PostalCodes_Test {
	@isTest
	static void testPlzChanged() {

		ADvendio__Pricelist__c priceList	= cls_P7S1_TestData.createTestPricelist(true);
		ADvendio__Ad_price__c adPrice		= cls_P7S1_TestData.createTestAdPrice(true, null, pricelist);

		ADvendio__MediaCampaign__c mc					= cls_P7S1_TestData.createTestMediaCampaign(true, null, priceList);
		
		ADvendio__Campaign_Item__c ci1					= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
		ci1.ADvendio__SelectedAdServerIdInformation__c	= 'Postal Code: 20097';
		ci1.ADvendio__SelectedContentInformation__c		= '20097';
		
		ADvendio__Campaign_Item__c ci2					= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
		ci2.ADvendio__SelectedAdServerIdInformation__c	= 'Postal Code: 20097';
		ci2.ADvendio__SelectedContentInformation__c		= '20097';
		
		ADvendio__Campaign_Item__c ci3					= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
		ci3.ADvendio__SelectedAdServerIdInformation__c	= null;
		ci3.ADvendio__SelectedContentInformation__c		= null;
		
		ADvendio__Campaign_Item__c ci4					= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
		ci4.ADvendio__SelectedAdServerIdInformation__c	= 'Postal Code: 20097';
		ci4.ADvendio__SelectedContentInformation__c		= '20097';
		
		
		insert new List<ADvendio__Campaign_Item__c> {ci1 ,ci2, ci3, ci4};
		
		ADvendio__OptimizingVersion__c version = new ADvendio__OptimizingVersion__c(ADvendio__MediaCampaign__c=mc.Id);
		insert version;

		ADvendio__OptimizingChange__c change1 = new ADvendio__OptimizingChange__c();
		change1.ADvendio__CampaignItem__c		= ci1.Id;
		change1.ADvendio__OptimizingVersion__c	= version.Id;
		change1.ADvendio__FieldName__c			= 'ADvendio__SelectedAdServerIdInformation__c';
		change1.ADvendio__OptimizedValue__c		= 'Postal Code: 20095';
		change1.ADvendio__OriginalValue__c		= ci1.ADvendio__SelectedAdServerIdInformation__c;

		ADvendio__OptimizingChange__c change2 = new ADvendio__OptimizingChange__c();
		change2.ADvendio__CampaignItem__c		= ci2.Id;
		change2.ADvendio__OptimizingVersion__c	= version.Id;
		change2.ADvendio__FieldName__c			= 'ADvendio__SelectedAdServerIdInformation__c';
		change2.ADvendio__OptimizedValue__c		= null;
		change2.ADvendio__OriginalValue__c		= ci2.ADvendio__SelectedAdServerIdInformation__c;
		
		ADvendio__OptimizingChange__c change3 = new ADvendio__OptimizingChange__c();
		change3.ADvendio__CampaignItem__c		= ci3.Id;
		change3.ADvendio__OptimizingVersion__c	= version.Id;
		change3.ADvendio__FieldName__c			= 'ADvendio__SelectedAdServerIdInformation__c';
		change3.ADvendio__OptimizedValue__c		= 'Postal Code: 20095';
		change3.ADvendio__OriginalValue__c		= ci3.ADvendio__SelectedAdServerIdInformation__c;
		
		ADvendio__OptimizingChange__c change4 = new ADvendio__OptimizingChange__c();
		change4.ADvendio__CampaignItem__c		= ci4.Id;
		change4.ADvendio__OptimizingVersion__c	= version.Id;
		change4.ADvendio__FieldName__c			= 'ADvendio__SelectedContentInformation__c';
		change4.ADvendio__OptimizedValue__c		= '';
		change4.ADvendio__OriginalValue__c		= '20097';

		Test.startTest();
		insert new List<ADvendio__OptimizingChange__c> {change1 ,change2, change3, change4};
		Test.stopTest();
		
		for (ADvendio__OptimizingChange__c oc : [SELECT Id, ADvendio__CampaignItem__c, ADvendio__FieldName__c, ADvendio__OriginalValue__c, ADvendio__OptimizedValue__c FROM ADvendio__OptimizingChange__c WHERE ADvendio__OptimizingVersion__c = :version.Id]) {
			if (oc.ADvendio__CampaignItem__c == ci1.Id) {
				if ('ADvendio__SelectedAdServerIdInformation__c'.equalsIgnoreCase(oc.ADvendio__FieldName__c)) {
					system.assertEquals(change1.ADvendio__OptimizedValue__c, oc.ADvendio__OptimizedValue__c);
					system.assertEquals(change1.ADvendio__OriginalValue__c, oc.ADvendio__OriginalValue__c);
				}
				if ('ADvendio__SelectedContentInformation__c'.equalsIgnoreCase(oc.ADvendio__FieldName__c)) {
					system.assertEquals('20095', oc.ADvendio__OptimizedValue__c);
					system.assertEquals('20097', oc.ADvendio__OriginalValue__c);
				}
			}
			else if (oc.ADvendio__CampaignItem__c == ci2.Id) {
				if ('ADvendio__SelectedAdServerIdInformation__c'.equalsIgnoreCase(oc.ADvendio__FieldName__c)) {
					system.assertEquals(change2.ADvendio__OptimizedValue__c, oc.ADvendio__OptimizedValue__c);
					system.assertEquals(change2.ADvendio__OriginalValue__c, oc.ADvendio__OriginalValue__c);
				}
				if ('ADvendio__SelectedContentInformation__c'.equalsIgnoreCase(oc.ADvendio__FieldName__c)) {
					system.assertEquals(null, oc.ADvendio__OptimizedValue__c);
					system.assertEquals('20097', oc.ADvendio__OriginalValue__c);
				}
			}
			else if (oc.ADvendio__CampaignItem__c == ci3.Id) {
				if ('ADvendio__SelectedAdServerIdInformation__c'.equalsIgnoreCase(oc.ADvendio__FieldName__c)) {
					system.assertEquals(change3.ADvendio__OptimizedValue__c, oc.ADvendio__OptimizedValue__c);
					system.assertEquals(change3.ADvendio__OriginalValue__c, oc.ADvendio__OriginalValue__c);
				}
				if ('ADvendio__SelectedContentInformation__c'.equalsIgnoreCase(oc.ADvendio__FieldName__c)) {
					system.assertEquals('20095', oc.ADvendio__OptimizedValue__c);
					system.assertEquals(null, oc.ADvendio__OriginalValue__c);
				}
			}
			else {
				system.assert(false, 'this change should have been deleted - maybe @future was to slow');
			}
		}
	}
}