@isTest
public with sharing class Adv_CampaignItem_AutoPopulationKv_Test {
    @isTest public static void testRemoveBt0() {
        ADvendio__MediaCampaign__c mc = cls_P7S1_TestData.createTestMediaCampaign(true);
        
        ADvendio__Campaign_Item__c ci1 = cls_P7S1_TestData.createTestCampaignItem(false, mc);
        ci1.ADvendio__AdKeyValues__c = null;
        ADvendio__Campaign_Item__c ci2 = cls_P7S1_TestData.createTestCampaignItem(false, mc);
        ci2.ADvendio__AdKeyValues__c = '((Behavioural Targeting=0))';
        ADvendio__Campaign_Item__c ci3 = cls_P7S1_TestData.createTestCampaignItem(false, mc);
        ci3.ADvendio__AdKeyValues__c = '((Behavioural Targeting=0)) OR ((Gender=female))';
        ADvendio__Campaign_Item__c ci4 = cls_P7S1_TestData.createTestCampaignItem(false, mc);
        ci4.ADvendio__AdKeyValues__c = '((Gender=female)) OR ((Behavioural Targeting=0))';
        insert new List<ADvendio__Campaign_Item__c>{ci1, ci2, ci3, ci4};
        
        Test.startTest();
        // insert tests
        List<ADvendio__Campaign_Item__c> cis = [SELECT Id, ADvendio__AdKeyValues__c FROM ADvendio__Campaign_Item__c WHERE Id IN (:ci1.Id, :ci2.Id, :ci3.Id, :ci4.Id)];
        for (ADvendio__Campaign_Item__c ci : cis) {
            if (ci.Id == ci1.Id) {
                System.assertEquals(null, ci.ADvendio__AdKeyValues__c);
            } else if (ci.Id == ci2.Id) {
                System.assertEquals(null, ci.ADvendio__AdKeyValues__c);
            } else if (ci.Id == ci3.Id) {
                System.assertEquals('((Gender=female))', ci.ADvendio__AdKeyValues__c);
            } else if (ci.Id == ci4.Id) {
                System.assertEquals('((Gender=female))', ci.ADvendio__AdKeyValues__c);
            }
        }
        
        ci1.ADvendio__AdKeyValues__c = '((age=1,2,3)) OR ((Behavioural Targeting=0)) OR ((Gender=female))';
        ci2.ADvendio__AdKeyValues__c = '((age=1,2,3)) OR ((Behavioural Targeting=0))';
        ci3.ADvendio__AdKeyValues__c = '((Behavioural Targeting=0))';
        ci4.ADvendio__AdKeyValues__c = null;
        update new List<ADvendio__Campaign_Item__c>{ci1, ci2, ci3, ci4};
        
        cis = [SELECT Id, ADvendio__AdKeyValues__c FROM ADvendio__Campaign_Item__c WHERE Id IN (:ci1.Id, :ci2.Id, :ci3.Id, :ci4.Id)];
        for (ADvendio__Campaign_Item__c ci : cis) {
            if (ci.Id == ci1.Id) {
                System.assertEquals('((age=1,2,3)) OR ((Gender=female))', ci.ADvendio__AdKeyValues__c);
            } else if (ci.Id == ci2.Id) {
                System.assertEquals('((age=1,2,3))', ci.ADvendio__AdKeyValues__c);
            } else if (ci.Id == ci3.Id) {
                System.assertEquals(null, ci.ADvendio__AdKeyValues__c);
            } else if (ci.Id == ci4.Id) {
                System.assertEquals(null, ci.ADvendio__AdKeyValues__c);
            }
        }
        Test.stopTest();
    }
    
    @isTest public static void testAddBt0KeyLine() {
        ADvendio__MediaCampaign__c mc = cls_P7S1_TestData.createTestMediaCampaign(true);
        
        ADvendio__Placement__c placement = cls_P7S1_TestData.createTestPlacement(false);
        placement.SomDig_Multiscreen__c = true;
        insert placement;
        SomDig_MediagattungsDifferenzierung__c mediagattungsDifferenzierung = cls_P7S1_TestData.createTestMediagattungsDifferenzierung(true, 'InStream/Video');
        ADvendio__Ad_Type__c adType = cls_P7S1_TestData.createTestAdType(true, mediagattungsDifferenzierung);
        ADvendio__Ad_Specs__c adSpec = cls_P7S1_TestData.createTestAdSpec(true, placement, adType);
        ADvendio__Ad_Price__c adPrice = cls_P7S1_TestData.createTestAdPrice(true, adSpec);
        
        ADvendio__Campaign_Item__c ci1 = cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
        ADvendio__Campaign_Item__c ci2 = cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
        ADvendio__Campaign_Item__c ci3 = cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
        ADvendio__Campaign_Item__c ci4 = cls_P7S1_TestData.createTestCampaignItem(false, mc); // no multiscreen
		insert new List<ADvendio__Campaign_Item__c>{ci1, ci2, ci3, ci4};
		
		ADvendio__AdServer_Id__c adServerId = new ADvendio__AdServer_Id__c(Name='a Key');
		insert adServerId;
		
		ADvendio__Key__c key1 = new ADvendio__Key__c(ADvendio__AdServerId__c = adServerId.Id, Name='age', SomDig_TargetingProvider__c='nugg.ad;lokalisten');
		ADvendio__Key__c key2 = new ADvendio__Key__c(ADvendio__AdServerId__c = adServerId.Id, Name='cars', SomDig_TargetingProvider__c='Bundesliga');
		ADvendio__Key__c key3 = new ADvendio__Key__c(ADvendio__AdServerId__c = adServerId.Id, Name='Behavioural Targeting');
		insert new List<ADvendio__Key__c>{key1, key2, key3};
		
		ADvendio__KeyLine__c keyLine1 = new ADvendio__KeyLine__c(ADvendio__CampaignItem__c = ci1.Id);
		ADvendio__KeyLine__c keyLine2 = new ADvendio__KeyLine__c(ADvendio__CampaignItem__c = ci2.Id);
		ADvendio__KeyLine__c keyLine4 = new ADvendio__KeyLine__c(ADvendio__CampaignItem__c = ci4.Id);
		insert new List<ADvendio__KeyLine__c>{keyLine1, keyLine2, keyLine4};
		
		Test.startTest();
		ADvendio__KeyValue__c kv11 = new ADvendio__KeyValue__c(ADvendio__KeyLine__c = keyLine1.Id, ADvendio__Key__c = key2.Id, ADvendio__Values__c='no nugg ad');
		ADvendio__KeyValue__c kv12 = new ADvendio__KeyValue__c(ADvendio__KeyLine__c = keyLine1.Id, ADvendio__Key__c = key1.Id, ADvendio__Values__c='nugg ad');
		ADvendio__KeyValue__c kv2 = new ADvendio__KeyValue__c(ADvendio__KeyLine__c = keyLine2.Id, ADvendio__Key__c = key2.Id, ADvendio__Values__c='no nugg ad');
		ADvendio__KeyValue__c kv4 = new ADvendio__KeyValue__c(ADvendio__KeyLine__c = keyLine4.Id, ADvendio__Key__c = key1.Id, ADvendio__Values__c='nugg ad');
		insert new List<ADvendio__KeyValue__c>{kv11, kv12, kv2, kv4};

		// SomDig_TargetingProvider__c == Nugg.ad
		System.assertEquals(2, [SELECT Id FROM ADvendio__KeyLine__c WHERE ADvendio__CampaignItem__c = :ci1.Id].size());
		
		// SomDig_TargetingProvider__c != Nugg.ad
		System.assertEquals(1, [SELECT Id FROM ADvendio__KeyLine__c WHERE ADvendio__CampaignItem__c = :ci2.Id].size());
		
		// No Key Lines
		System.assertEquals(0, [SELECT Id FROM ADvendio__KeyLine__c WHERE ADvendio__CampaignItem__c = :ci3.Id].size());

		// SomDig_TargetingProvider__c == Nugg.ad but no multiscreen
		System.assertEquals(1, [SELECT Id FROM ADvendio__KeyLine__c WHERE ADvendio__CampaignItem__c = :ci4.Id].size());
		
		// no nugg.ad but Behavioural Targeting=0
		ADvendio__KeyLine__c keyLine3 = new ADvendio__KeyLine__c(ADvendio__CampaignItem__c = ci3.Id);
		insert keyLine3;
		ADvendio__KeyValue__c kv3 = new ADvendio__KeyValue__c(ADvendio__KeyLine__c = keyLine3.Id, ADvendio__Key__c = key3.Id, ADvendio__Values__c='0');
		try {
			insert kv3;
			System.assert(false, 'Behavioural Targeting=0 must not be inserted as only key value');
		} catch(Exception e){} 
		Test.stopTest();    	
    }
}