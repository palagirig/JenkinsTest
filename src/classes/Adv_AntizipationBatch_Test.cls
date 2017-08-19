@isTest
public class Adv_AntizipationBatch_Test {
    
    static testMethod void testNotSevenOneNetworkPlacement() {
        
        ADvendio__Site__c testSite = cls_P7S1_TestData.createTestSite(false);
        testSite.Name = 'Not SevenOne Network';
        insert testSite;
        
        //parenty adServerId 
        ADvendio__AdServer_ID__c parent5AdServerId = cls_P7S1_TestData.createTestAdServerId(true);
        
        ADvendio__AdServer_ID__c parent4AdServerId = cls_P7S1_TestData.createTestAdServerId(false);
        parent4AdServerId.ADvendio__Parent_AdServer_ID__c = parent5AdServerId.Id;
        parent4AdServerId.ADvendio__Site__c = testSite.Id;
        parent4AdServerId.ADvendio__Type__c = 'Ad Unit';
        insert parent4AdServerId; 
        
        ADvendio__AdServer_ID__c parent3AdServerId = cls_P7S1_TestData.createTestAdServerId(false);
        parent3AdServerId.ADvendio__Parent_AdServer_ID__c = parent4AdServerId.Id;
        insert parent3AdServerId;
        
        ADvendio__AdServer_ID__c parent2AdServerId = cls_P7S1_TestData.createTestAdServerId(false);
        parent2AdServerId.ADvendio__Parent_AdServer_ID__c = parent3AdServerId.Id;
        insert parent2AdServerId;
        
        ADvendio__AdServer_ID__c parent1AdServerId = cls_P7S1_TestData.createTestAdServerId(false);
        parent1AdServerId.ADvendio__Parent_AdServer_ID__c = parent2AdServerId.Id;
        parent1AdServerId.ADvendio__Site__c = testSite.Id;
        insert parent1AdServerId;
        
        
        ADvendio__Placement__c testPlacement = cls_P7S1_TestData.createTestPlacement(false, testSite);
        testPlacement.SomDig_AdServerID__c = parent1AdServerId.Id;
        testPlacement.ADvendio__Site__c = testSite.Id;
        insert testPlacement;
        
        Test.startTest();
        
        Database.executeBatch(new Adv_AntizipationBatch(), 10);
         
        Test.stopTest();
       	
        // assert that AZDistKey was created and assigned.
        ADvendio__Placement__c checkPlacement = [SELECT SomDig_AntizipationsVS__c FROM ADvendio__Placement__c WHERE Id = :testPlacement.Id];
        System.assertNotEquals(Null, checkPlacement.SomDig_AntizipationsVS__c);
        
        // assert that our AZDistKey only has 1 Dist Key, with 100% and assigned the correct AdServerId.
        SomDig_AntizipationsVS__c checkAZVS = [SELECT Id, (SELECT SomDig_AdServerId__c, SomDig_Prozentsatz__c FROM SomDig_Verteilungsschluessel__r) FROM SomDig_AntizipationsVS__c WHERE Id = :checkPlacement.SomDig_AntizipationsVS__c];
        System.assertEquals(1, checkAZVS.SomDig_Verteilungsschluessel__r.size());
        System.assertEquals(parent4AdServerId.Id, checkAZVS.SomDig_Verteilungsschluessel__r[0].SomDig_AdServerId__c);
        System.assertEquals(100, checkAZVS.SomDig_Verteilungsschluessel__r[0].SomDig_Prozentsatz__c);
    }
    
    static testMethod void testSevenOneNetworkPlacementWithoutDeliveryData() {
        
        createStandardAZDistKey();
        ADvendio__Site__c testSite = cls_P7S1_TestData.createTestSite(false);
        testSite.Name = 'SevenOne Network';
        insert testSite;
        ADvendio__Placement__c testPlacement = cls_P7S1_TestData.createTestPlacement(true, testSite);
        
        Test.startTest();
        
        Database.executeBatch(new Adv_AntizipationBatch(), 10);
        
        Test.stopTest();
        
        ADvendio__Placement__c checkPlacement = [SELECT SomDig_AntizipationsVS__c FROM ADvendio__Placement__c WHERE Id = :testPlacement.Id];
        System.assertNotEquals(Null, checkPlacement.SomDig_AntizipationsVS__c);
        SomDig_AntizipationsVS__c checkAZVS = [SELECT Name, (SELECT SomDig_AdServerId__c, SomDig_Prozentsatz__c FROM SomDig_Verteilungsschluessel__r) FROM SomDig_AntizipationsVS__c WHERE Id = :checkPlacement.SomDig_AntizipationsVS__c];
        System.assertEquals('Generischer Verteilungsschlüssel Rotation', checkAZVS.Name);
    }
    
    static testMethod void testSevenOneNetworkPlacementWithDeliveryData() {

        ADvendio__Site__c testSite = cls_P7S1_TestData.createTestSite(false);
        testSite.Name = 'SevenOne Network';
        insert testSite;
        
        ADvendio__Placement__c testPlacement = cls_P7S1_TestData.createTestPlacement(true, testSite);
        
        ADvendio__Ad_Type__c testAdType = cls_P7S1_TestData.createTestAdType(false);
        testAdType.recordTypeId = cls_P7S1_Utils.getRecordTypeID('ADvendio__Ad_Type__c', 'DFP');
        insert testAdType;
        
        ADvendio__Ad_Specs__c testAdSpec = cls_P7S1_TestData.createTestAdSpec(true, testPlacement, testAdType);
        ADvendio__Ad_price__c testAdPrice = cls_P7S1_TestData.createTestAdPrice(true, testAdSpec);
        ADvendio__Campaign_Item__c testCampaignItem = cls_P7S1_TestData.createTestCampaignItem(true, testAdPrice);
        
        ADvendio__AdServer_ID__c kabel1AdsID = cls_P7S1_TestData.createTestAdServerId(false);
        ADvendio__AdServer_ID__c sat1AdsID = cls_P7S1_TestData.createTestAdServerId(false);
        ADvendio__AdServer_ID__c pro7AdsID = cls_P7S1_TestData.createTestAdServerId(false);
        ADvendio__AdServer_ID__c sport1AdsID = cls_P7S1_TestData.createTestAdServerId(false);
        ADvendio__AdServer_ID__c n24AdsID = cls_P7S1_TestData.createTestAdServerId(false);
        ADvendio__AdServer_ID__c otherAdsID = cls_P7S1_TestData.createTestAdServerId(false);
        insert new List<ADvendio__AdServer_ID__c>{kabel1AdsID,sat1AdsID,pro7AdsID,sport1AdsID,n24AdsID,otherAdsID};
        
		List<ADvendio__DeliveryData__c> testDeliveryData = new List<ADvendio__DeliveryData__c>();
        testDeliveryData.add(new ADvendio__DeliveryData__c(ADvendio__CampaignItem__c = testCampaignItem.Id, ADvendio__Type__c = 'Monthly', ADvendio__Day__c  = Date.today().addMonths(-1), ADvendio__AdServerID__c = kabel1AdsID.Id, ADvendio__DeliveredImpressions__c = 5000));
        testDeliveryData.add(new ADvendio__DeliveryData__c(ADvendio__CampaignItem__c = testCampaignItem.Id, ADvendio__Type__c = 'Monthly', ADvendio__Day__c  = Date.today().addMonths(-1), ADvendio__AdServerID__c = sat1AdsID.Id, ADvendio__DeliveredImpressions__c = 20000));
        testDeliveryData.add(new ADvendio__DeliveryData__c(ADvendio__CampaignItem__c = testCampaignItem.Id, ADvendio__Type__c = 'Monthly', ADvendio__Day__c  = Date.today().addMonths(-1), ADvendio__AdServerID__c = pro7AdsID.Id, ADvendio__DeliveredImpressions__c = 19000));
        testDeliveryData.add(new ADvendio__DeliveryData__c(ADvendio__CampaignItem__c = testCampaignItem.Id, ADvendio__Type__c = 'Monthly', ADvendio__Day__c  = Date.today().addMonths(-1), ADvendio__AdServerID__c = sport1AdsID.Id, ADvendio__DeliveredImpressions__c = 15000));
        testDeliveryData.add(new ADvendio__DeliveryData__c(ADvendio__CampaignItem__c = testCampaignItem.Id, ADvendio__Type__c = 'Monthly', ADvendio__Day__c  = Date.today().addMonths(-1), ADvendio__AdServerID__c = n24AdsID.Id, ADvendio__DeliveredImpressions__c = 5000));
        testDeliveryData.add(new ADvendio__DeliveryData__c(ADvendio__CampaignItem__c = testCampaignItem.Id, ADvendio__Type__c = 'Monthly', ADvendio__Day__c  = Date.today().addMonths(-1), ADvendio__AdServerID__c = otherAdsID.Id, ADvendio__DeliveredImpressions__c = 300));
        insert testDeliveryData;

        Test.startTest();
        
        Database.executeBatch(new Adv_AntizipationBatch(), 10);
        
        Test.stopTest();
        
        ADvendio__Placement__c checkPlacement = [SELECT SomDig_AntizipationsVS__c FROM ADvendio__Placement__c WHERE Id = :testPlacement.Id];
        System.assertNotEquals(Null, checkPlacement.SomDig_AntizipationsVS__c);
        SomDig_AntizipationsVS__c checkAZVS = [SELECT Name, SomDig_SummeProzentsaetze__c, (SELECT SomDig_AdServerId__c, SomDig_Prozentsatz__c FROM SomDig_Verteilungsschluessel__r ORDER BY SomDig_Prozentsatz__c DESC) FROM SomDig_AntizipationsVS__c WHERE Id = :checkPlacement.SomDig_AntizipationsVS__c];
        System.assertEquals(5, checkAZVS.SomDig_Verteilungsschluessel__r.size());
        System.assertEquals(31.2500, checkAZVS.SomDig_Verteilungsschluessel__r[0].SomDig_Prozentsatz__c.setScale(4));
        System.assertEquals(29.6875, checkAZVS.SomDig_Verteilungsschluessel__r[1].SomDig_Prozentsatz__c.setScale(4));
        System.assertEquals(23.4375, checkAZVS.SomDig_Verteilungsschluessel__r[2].SomDig_Prozentsatz__c.setScale(4));
        System.assertEquals(7.8125, checkAZVS.SomDig_Verteilungsschluessel__r[3].SomDig_Prozentsatz__c.setScale(4));
        System.assertEquals(7.8125, checkAZVS.SomDig_Verteilungsschluessel__r[4].SomDig_Prozentsatz__c.setScale(4));
        System.assertEquals(100, checkAZVS.SomDig_SummeProzentsaetze__c);
    }
     
    private static void createStandardAZDistKey() {
        
        List<ADvendio__Site__c> sites = new List<ADvendio__Site__c>();
        for (Integer i=0;i<10;i++) {
            ADvendio__Site__c site = cls_P7S1_TestData.createTestSite(false);
            site.Name = 'Site '+i;
            sites.add(site);
        } 
        insert sites;
        
        List<ADvendio__AdServer_ID__c> adServerIDs = new List<ADvendio__AdServer_ID__c>();
        for (Integer i=0;i<10;i++) {
            ADvendio__AdServer_ID__c adserverID = cls_P7S1_TestData.createTestAdServerID(false);
            adserverID.ADvendio__Site__c = sites[i].Id;
            adServerIDs.add(adserverID);
        }
        insert adServerIDs;
        
        SomDig_AntizipationsVS__c azDistKey = new SomDig_AntizipationsVS__c(Name = 'Generischer Verteilungsschlüssel Rotation');
        insert azDistKey;

        List<SomDig_Verteilungsschluessel__c> distKeys = new List<SomDig_Verteilungsschluessel__c>();
        for (Integer i=0;i<10;i++) {
            distKeys.add(new SomDig_Verteilungsschluessel__c(SomDig_AdServerId__c = adServerIDs[i].Id, SomDig_AntizipationsVS__c = azDistKey.Id, SomDig_Prozentsatz__c = 10));
        }
        insert distKeys;
        
    }
    
}