@isTest
public with sharing class Adv_CampaignItem_FieldChanges_Test {

    @isTest (seeAllData=false)
    static public void setPlzWorkaroundTest() {
        
        ADvendio__Pricelist__c pricelist = cls_P7S1_TestData.createTestPricelist(true);
        ADvendio__MediaCampaign__c mediaCampaign = createTestMediaCampaign(true, pricelist);
        ADvendio__Ad_price__c adPrice = cls_P7S1_TestData.createTestAdPrice(false, pricelist);
        ADvendio__Campaign_Item__c campaignItem1 = cls_P7S1_TestData.createTestCampaignItem(false, mediaCampaign, adPrice);
        campaignItem1.ADvendio__SelectedAdServerIdInformation__c	= 'TEST:123 ;Postal Code: 12345;';
        ADvendio__Campaign_Item__c campaignItem2 = cls_P7S1_TestData.createTestCampaignItem(false, mediaCampaign, adPrice);

        Test.startTest();
        insert new List<ADvendio__Campaign_Item__c>{campaignItem1, campaignItem2};

        
        for (ADvendio__Campaign_Item__c ci : [SELECT Id, ADvendio__SelectedContentInformation__c FROM ADvendio__Campaign_Item__c limit 2]) {
        	if (ci.Id == campaignItem1.Id ) {
        		system.assertEquals('12345', ci.ADvendio__SelectedContentInformation__c);
        	}
            else if (ci.Id == campaignItem2.Id ) {
        		system.assertEquals(null, ci.ADvendio__SelectedContentInformation__c);
        	}
        	else {
        		system.assert(false, 'unexpected item!');
        	}
        }

        campaignItem1.ADvendio__SelectedAdServerIdInformation__c	= 'TEST:123 ;Postal Cxxx: 12345;';
        campaignItem2.ADvendio__SelectedAdServerIdInformation__c	= 'Postal Code: 12345,23456';
        update new List<ADvendio__Campaign_Item__c>{campaignItem1, campaignItem2};
        
        for (ADvendio__Campaign_Item__c ci : [SELECT Id, ADvendio__SelectedContentInformation__c FROM ADvendio__Campaign_Item__c limit 2]) {
        	if (ci.Id == campaignItem1.Id ) {
        		system.assertEquals(null, ci.ADvendio__SelectedContentInformation__c);
        	}
            else if (ci.Id == campaignItem2.Id ) {
        		system.assertEquals('12345,23456', ci.ADvendio__SelectedContentInformation__c);
        	}
        	else {
        		system.assert(false, 'unexpected item!');
        	}
        }

        Test.stopTest();
    }
    
    static testMethod void setLineDescriptionOnInsert() {
        ADvendio__Pricelist__c pricelist = cls_P7S1_TestData.createTestPricelist(true);
        ADvendio__MediaCampaign__c mediaCampaign = createTestMediaCampaign(true, pricelist);
        ADvendio__Ad_price__c adPrice = cls_P7S1_TestData.createTestAdPrice(false, pricelist);
        adPrice.ADvendio__RateCriterion__c = 'bis 15 Sekunden';
        insert adPrice;

        Test.startTest();

        ADvendio__Campaign_Item__c campaignItem = cls_P7S1_TestData.createTestCampaignItem(false, mediaCampaign, adPrice);
        campaignItem.ADvendio__Rate_Discount_4_Name__c = 'Positionsrabatt Natural';
        campaignItem.SomDig_Freitextnotiz__c = 'random text';
        campaignItem.SomDig_Retargeting__c = true;
        insert campaignItem;

        Test.stopTest();

        campaignItem = reloadCampaignItem(campaignItem);
        System.assertEquals('-random text\n-NR\n-Re-Targeting-Aufschlag\n-Videolänge: bis 15 Sekunden', campaignItem.ADvendio__LineDescription__c);
    }

    static testMethod void setLineDescriptionOnUpdate() {
        ADvendio__Pricelist__c pricelist = cls_P7S1_TestData.createTestPricelist(true);
        ADvendio__MediaCampaign__c mediaCampaign = createTestMediaCampaign(true, pricelist);
        ADvendio__Ad_price__c adPrice = cls_P7S1_TestData.createTestAdPrice(false, pricelist);
        adPrice.ADvendio__RateCriterion__c = 'bis 20 Sekunden';
        insert adPrice;

        ADvendio__Campaign_Item__c campaignItem = cls_P7S1_TestData.createTestCampaignItem(false, mediaCampaign, adPrice);
        campaignItem.ADvendio__Rate_Discount_4_Name__c = 'Nachlieferung';
        campaignItem.SomDig_Freitextnotiz__c = 'random text 1';
        campaignItem.SomDig_Retargeting__c = true;
        insert campaignItem;

        campaignItem = reloadCampaignItem(campaignItem);
        System.assertEquals('-random text 1\n-Nachlieferung\n-Re-Targeting-Aufschlag\n-Videolänge: bis 20 Sekunden', campaignItem.ADvendio__LineDescription__c);

        Test.startTest();

        adPrice.ADvendio__RateCriterion__c = 'bis 30 Sekunden';
        update adPrice;

        campaignItem.ADvendio__Rate_Discount_4_Name__c = 'Storno mit Leistungsfluss';
        campaignItem.SomDig_Freitextnotiz__c = 'random text 2';
        campaignItem.SomDig_Retargeting__c = false;
        update campaignItem;

        Test.stopTest();

        campaignItem = reloadCampaignItem(campaignItem);
        System.assertEquals('-random text 2\n-Storno\n-Videolänge: bis 30 Sekunden', campaignItem.ADvendio__LineDescription__c);
    }

    static testMethod void setAdServerStatusOnInsert() {
        ADvendio__Pricelist__c pricelist = cls_P7S1_TestData.createTestPricelist(true);
        ADvendio__MediaCampaign__c mediaCampaign = createTestMediaCampaign(true, pricelist);
        ADvendio__Ad_price__c adPrice = cls_P7S1_TestData.createTestAdPrice(true, pricelist);

        Test.startTest();

        ADvendio__Campaign_Item__c campaignItem = cls_P7S1_TestData.createTestCampaignItem(false, mediaCampaign, adPrice);
        campaignItem.ADvendio__Rate_Discount_4_Name__c = 'Storno mit Leistungsfluss';
        insert campaignItem;

        Test.stopTest();

        campaignItem = reloadCampaignItem(campaignItem);
        System.assertEquals('Released', campaignItem.ADvendio__AdserverStatus__c);
    }

    static testMethod void setAdServerStatusOnUpdate() {
        ADvendio__Pricelist__c pricelist = cls_P7S1_TestData.createTestPricelist(true);
        ADvendio__MediaCampaign__c mediaCampaign = createTestMediaCampaign(true, pricelist);
        ADvendio__Ad_price__c adPrice = cls_P7S1_TestData.createTestAdPrice(true, pricelist);

        ADvendio__Campaign_Item__c campaignItem = cls_P7S1_TestData.createTestCampaignItem(false, mediaCampaign, adPrice);
        campaignItem.ADvendio__Rate_Discount_4_Name__c = 'Nachlieferung';
        campaignItem.ADvendio__from_Date__c = Date.today().addDays(1);
        insert campaignItem;

        campaignItem = reloadCampaignItem(campaignItem);
        System.assertEquals('Active', campaignItem.ADvendio__AdserverStatus__c);

        Test.startTest();

        campaignItem.ADvendio__Rate_Discount_4_Name__c = 'Storno ohne Leistungsfluss';
        update campaignItem;

        Test.stopTest();

        campaignItem = reloadCampaignItem(campaignItem);
        System.assertEquals('Released', campaignItem.ADvendio__AdserverStatus__c);
    }

    @isTest
    public static void setLineDescriptionKompensation(){
        ADvendio__Pricelist__c pricelist = cls_P7S1_TestData.createTestPricelist(true);
        ADvendio__MediaCampaign__c mediaCampaign = createTestMediaCampaign(true, pricelist);
        ADvendio__Ad_price__c adPrice = cls_P7S1_TestData.createTestAdPrice(true, pricelist);

        Test.startTest();

        ADvendio__Campaign_Item__c campaignItem = cls_P7S1_TestData.createTestCampaignItem(false, mediaCampaign, adPrice);
        campaignItem.ADvendio__Rate_Discount_4_Name__c = 'Kompensation';
        insert campaignItem;

        Test.stopTest();

        campaignItem = reloadCampaignItem(campaignItem);
        System.assert(campaignItem.ADvendio__LineDescription__c.contains('Kompensation'));
    }

    @isTest
    public static void setLineDescriptionWithoutKompensation(){
        ADvendio__Pricelist__c pricelist = cls_P7S1_TestData.createTestPricelist(true);
        ADvendio__MediaCampaign__c mediaCampaign = createTestMediaCampaign(true, pricelist);
        ADvendio__Ad_price__c adPrice = cls_P7S1_TestData.createTestAdPrice(true, pricelist);

        Test.startTest();

        ADvendio__Campaign_Item__c campaignItem = cls_P7S1_TestData.createTestCampaignItem(false, mediaCampaign, adPrice);
        campaignItem.ADvendio__Rate_Discount_4_Name__c = 'Nachlieferung';
        insert campaignItem;

        Test.stopTest();

        campaignItem = reloadCampaignItem(campaignItem);
        System.assert(!(campaignItem.ADvendio__LineDescription__c.contains('Kompensation')));
    }

    private static ADvendio__Campaign_Item__c reloadCampaignItem(ADvendio__Campaign_Item__c campaignItem) {
        return [
            SELECT ADvendio__AdserverStatus__c, ADvendio__LineDescription__c
              FROM ADvendio__Campaign_Item__c
             WHERE Id = :campaignItem.Id
        ];
    }



    // TODO: in TestData auslagern
    public static ADvendio__MediaCampaign__c createTestMediaCampaign(Boolean insertObject, ADvendio__Pricelist__c pricelist) {
        return cls_P7S1_TestData.createTestMediaCampaign(insertObject, null, pricelist, null);
    }


}