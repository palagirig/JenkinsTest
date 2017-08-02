/*
* Name:     MT_BuildingBlockMonthPlan_TriggerHandler
* Purpose:  Trigger; As soon as a Building Block Monthly Plan object is created and nearly saved, the trigger is called.
*			It then will compare Monthly Plans to Parameter Versions and their time frame, when the range passes the PV is stored as a reference on the Plan
* History
* -------
* DATE        AUTHOR                      DETAIL
* 28.04.2017  Falco Aulitzky              Initial architecture and development
*
*/
public with sharing class MT_BuildingBlockMonthPlan_TriggerHandler extends TriggerController {
  public MT_BuildingBlockMonthPlan_TriggerHandler(Boolean isAfter, Boolean isBefore, Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate,
    List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems) {
    super(isAfter, isBefore, isDelete, isInsert, isUndelete, isUpdate, lstNewItems, mapNewItems, lstOldItems, mapOldItems);
  }

	/* Finds the right Parameter Version for each created Monthly Plan */
  public override void runBeforeInsert() {
    List<MT_MediaBuildingBlockMonthlyPlan__c> mbbmps = ((List<MT_MediaBuildingBlockMonthlyPlan__c>) lstNewItems);
    Map<Id, List<MT_MediaBuildingBlockMonthlyPlan__c>> mctIdsToMbbmp = new Map<Id, List<MT_MediaBuildingBlockMonthlyPlan__c>>();
    List<MT_MediaBuildingBlockMonthlyPlan__c> mbbmpsList = new List<MT_MediaBuildingBlockMonthlyPlan__c>();
    List<MT_MediaBuildingBlockMonthlyPlan__c> toBeUpdatedList = new List<MT_MediaBuildingBlockMonthlyPlan__c>();

    List<Id> mbbIds = new List<Id>();

    for (MT_MediaBuildingBlockMonthlyPlan__c mbbmp: mbbmps) {
      mbbIds.add(mbbmp.MT_MediaBuildingBlock_ref__c);
    }

    List<MT_MediaBuildingBlock__c> mbbs = MT_MediaBuildingBlockService.getMediaBuildingBlocksByIds(new Set<Id>(mbbIds), new Set<String>{
      'Id', 'MT_MediaCampaign_ref__r.MT_MediaCampaignType_ref__c'
    });

    for (MT_MediaBuildingBlockMonthlyPlan__c mbbmp: mbbmps) {
      for (MT_MediaBuildingBlock__c mbb: mbbs) {
        if (mbb.Id == mbbmp.MT_MediaBuildingBlock_ref__c) {
          if (!mctIdsToMbbmp.containsKey(mbb.MT_MediaCampaign_ref__r.MT_MediaCampaignType_ref__c)) {
            mctIdsToMbbmp.put(mbb.MT_MediaCampaign_ref__r.MT_MediaCampaignType_ref__c, new List<MT_MediaBuildingBlockMonthlyPlan__c>());
          }

          mctIdsToMbbmp.get(mbb.MT_MediaCampaign_ref__r.MT_MediaCampaignType_ref__c).add(mbbmp);
        }
      }
    }

    List<MT_CampaignTypeParameterVersion__c> ctpvs = [SELECT Id, MT_MediaCampaignType_ref__c, MT_ValidFrom__c FROM MT_CampaignTypeParameterVersion__c WHERE MT_MediaCampaignType_ref__c IN :mctIdsToMbbmp.keySet() ORDER BY MT_ValidFrom__c ASC];

    for (MT_CampaignTypeParameterVersion__c ctpv: ctpvs) {
      mbbmpsList = mctIdsToMbbmp.get(ctpv.MT_MediaCampaignType_ref__c);

      for (MT_MediaBuildingBlockMonthlyPlan__c mbbp: mbbmpsList) {
        if (ctpv.MT_ValidFrom__c <= mbbp.MT_PlanningDate__c) {
          mbbp.MT_MediaCampaignTypeParameterVersion_ref__c = ctpv.Id;
          toBeUpdatedList.add(mbbp);
        }
      }
    }
  }
}