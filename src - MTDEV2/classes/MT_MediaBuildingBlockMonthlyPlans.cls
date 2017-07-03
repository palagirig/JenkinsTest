/************************************************************************************************************
Name:  		MT_MediaBuildingBlockMonthlyPlans
======================================================
Purpose: 	Domain class for MT_MediaBuildingBlockMonthlyPlan__c object
======================================================
History
-------
Date		AUTHOR						DETAIL
07.12.2016	Duc Nguyen Tien             Initial architecture & development
*************************************************************************************************************/
public with sharing class MT_MediaBuildingBlockMonthlyPlans {
  private List<MT_mediaBuildingBlockMonthlyPlan__c> scope;

  public MT_MediaBuildingBlockMonthlyPlans(List<MT_mediaBuildingBlockMonthlyPlan__c> scope) {
    this.scope = scope;
  }

  public static List<MT_mediaBuildingBlockMonthlyPlan__c> createMonthlyPlans(MT_MediaBuildingBlock__c mbb, Date startDate, Date endDate) {
    List<MT_MediaBuildingBlockMonthlyPlan__c> ret = new List<MT_MediaBuildingBlockMonthlyPlan__c>();

    Date iteratorDate = Date.newInstance(startDate.year(), startDate.month(), 1);
    Date cacheEnd = Date.newInstance(endDate.year(), endDate.month(), 1);

    while (iteratorDate <= cacheEnd) {
      system.debug('iteratorDate: ' + iteratorDate + ' cacheEnd: ' + cacheEnd);

      ret.add(
        new MT_MediaBuildingBlockMonthlyPlan__c(
          MT_MediaBuildingBlock_ref__c = mbb.Id,
          MT_PlanningDate__c = iteratorDate
        )
      );
      iteratorDate = iteratorDate.addMonths(1);
    }
    return ret;
  }
  public static MT_mediaBuildingBlockMonthlyPlan__c create(MT_MediaBuildingBlock__c mbb, Date planningDate) {
    return new MT_MediaBuildingBlockMonthlyPlan__c(
      MT_MediaBuildingBlock_ref__c = mbb.Id,
      MT_PlanningDate__c = planningDate
    );

  }
}