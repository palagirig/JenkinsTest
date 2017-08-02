/************************************************************************************************************
Name:  		MT_MediaBuildingBlockMonthlyPlans_Test
======================================================
Purpose: 	Test class for class MT_MediaBuildingBlockMonthlyPlans, MT_MediaBuildingBlockMonthlyPlanService and MT_MediaBuildingBlockMonthlySelector
======================================================
History
-------
Date		AUTHOR						DETAIL
06.02.2017	Duc Nguyen Tien             Initial development
16.03.2017  Falco Aulitzky				Additional Tests for Service and Selector
*************************************************************************************************************/
@isTest
private class MT_MediaBuildingBlockMonthlyPlans_Test {
  @testSetup static void setup() {
    MT_Test.init();
  }

  @isTest static void constructor() {
    MT_MediaBuildingBlockMonthlyPlans cls = new MT_MediaBuildingBlockMonthlyPlans(new List<MT_mediaBuildingBlockMonthlyPlan__c>());
  }

  @isTest static void createMonthlyPlans() {
    Test.startTest();
    Date today = Date.newInstance(Date.today().Year(), Date.today().Month(), 1);
    Date endDate = today.addMonths(14);
    List<MT_mediaBuildingBlockMonthlyPlan__c> bMonthlyPlans = MT_MediaBuildingBlockMonthlyPlans.createMonthlyPlans(new MT_MediaBuildingBlock__c(), today, endDate);

    system.assertEquals(15, bMonthlyPlans.size());
    Integer i = 0;
    while (today <= endDate) {
      system.assertEquals(today, bMonthlyPlans.get(i).MT_PlanningDate__c);

      today = today.addMonths(1);
      i++;
    }

    Test.stopTest();
  }

  @isTest static void create() {
    Test.startTest();
    MT_MediaBuildingBlockMonthlyPlan__c plan = MT_MediaBuildingBlockMonthlyPlans.create(new MT_MediaBuildingBlock__c(), Date.today());
    system.assertEquals(Date.today(), plan.MT_PlanningDate__c);
    system.assertEquals(null, plan.MT_MediaBuildingBlock_ref__c);
    Test.stopTest();
  }

  testmethod static void getRecordsByIds() {
    MT_MediaBuildingBlockMonthlyPlan__c mbbmp = [SELECT Id FROM MT_MediaBuildingBlockMonthlyPlan__c limit 1];
    System.assertNotEquals(null, mbbmp);

    Test.startTest();

    System.assert(!MT_MediaBuildingBlockMonthlyPlanService.getRecordsByIds(new Set<Id>{
      mbbmp.Id
    }).isEmpty());
    System.assert(MT_MediaBuildingBlockMonthlyPlanService.getRecordsByIds(new Set<Id>()).isEmpty());

    Test.stopTest();
  }

  testmethod static void getMediaBuildingBlockMonthlyPlansByParentIds() {
    MT_MediaBuildingBlock__c mbb = [SELECT Id FROM MT_MediaBuildingBlock__c limit 1];
    System.assertNotEquals(null, mbb);

    Test.startTest();

    System.assert(!MT_MediaBuildingBlockMonthlyPlanService.getMediaBuildingBlockMonthlyPlansByParentIds(new Set<Id>{
      mbb.Id
    }).isEmpty());
    System.assert(MT_MediaBuildingBlockMonthlyPlanService.getMediaBuildingBlockMonthlyPlansByParentIds(new Set<Id>()).isEmpty());
    System.assertEquals(mbb.Id, MT_MediaBuildingBlockMonthlyPlanService.getMediaBuildingBlockMonthlyPlansByParentIds(new Set<Id>{
      mbb.Id
    }).get(0).MT_MediaBuildingBlock_ref__c);

    Test.stopTest();
  }

  testmethod static void getTVRecordsByMediaCampaignIds() {
    MT_MediaCampaign__c mc = [SELECT Id FROM MT_MediaCampaign__c limit 1];
    System.assertNotEquals(null, mc);

    Test.startTest();

    System.assert(!MT_MediaBuildingBlockMonthlyPlanService.getTVRecordsByMediaCampaignIds(new Set<Id>{
      mc.Id
    }).isEmpty());
    System.assert(MT_MediaBuildingBlockMonthlyPlanService.getTVRecordsByMediaCampaignIds(new Set<Id>()).isEmpty());

    Test.stopTest();
  }

  testmethod static void getMediaBuildingBlockMonthlyPlansWithMediaFlightsByParentIds() {
    MT_MediaBuildingBlock__c mbb = [SELECT Id FROM MT_MediaBuildingBlock__c limit 1];
    System.assertNotEquals(null, mbb);

    Test.startTest();

    System.assert(!MT_MediaBuildingBlockMonthlyPlanService.getMediaBuildingBlockMonthlyPlansWithMediaFlightsByParentIds(new Set<Id>{
      mbb.Id
    }).isEmpty());
    System.assert(MT_MediaBuildingBlockMonthlyPlanService.getMediaBuildingBlockMonthlyPlansWithMediaFlightsByParentIds(new Set<Id>()).isEmpty());
    System.assertEquals(mbb.Id, MT_MediaBuildingBlockMonthlyPlanService.getMediaBuildingBlockMonthlyPlansWithMediaFlightsByParentIds(new Set<Id>{
      mbb.Id
    }).get(0).MT_MediaBuildingBlock_ref__c);

    Test.stopTest();
  }
}