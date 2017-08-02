/*
* Name:     MT_MediaBuildingBlock_TriggerHandler
* Purpose:  Trigger; As soon as a Building Block object is created or updated the trigger will be fired.
*			
* History
* -------
* DATE        AUTHOR                      DETAIL
* 19.05.2017  Falco Aulitzky              Initial architecture and development
*
*/
public with sharing class MT_MediaBuildingBlock_TriggerHandler extends TriggerController {
  public MT_MediaBuildingBlock_TriggerHandler(Boolean isAfter, Boolean isBefore, Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate,
    List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems) {
    super(isAfter, isBefore, isDelete, isInsert, isUndelete, isUpdate, lstNewItems, mapNewItems, lstOldItems, mapOldItems);
  }

  public override void runAfterUpdate() {
    insert createHistoryObject(((List<MT_MediaBuildingBlock__c>) lstOldItems));
  }

  private List<MT_MediaBuildingBlockHistory__c> createHistoryObject(List<MT_MediaBuildingBlock__c> mbbs) {
    List<MT_MediaBuildingBlockHistory__c> mbbhs = new List<MT_MediaBuildingBlockHistory__c>();

    String objNameMBB = 'MT_MediaBuildingBlock__c'; // Object name you wish to extract lookup fields for
    String objNameMBBH = 'MT_MediaBuildingBlockHistory__c'; // Object name you wish to extract lookup fields for
    Map<String, Schema.SObjectField> objectFieldsMBB = Schema.getGlobalDescribe().get(objNameMBB).getDescribe().fields.getMap();
    Map<String, Schema.SObjectField> objectFieldsMBBH = Schema.getGlobalDescribe().get(objNameMBBH).getDescribe().fields.getMap();

    for (Schema.SObjectField fld :objectFieldsMBB.values()) {
      Schema.describeFieldResult dfield = fld.getDescribe();
    }

    for (MT_MediaBuildingBlock__c mbb : mbbs) {
      MT_MediaBuildingBlockHistory__c mbbh = new MT_MediaBuildingBlockHistory__c(MT_MediaBuildingBlock_ref__c = mbb.Id);
      for (Schema.SObjectField fld :objectFieldsMBB.values()) {
        String field = fld.getDescribe().getName();

        if (objectFieldsMBBH.containsKey(field) && field.contains('__c') || field == 'Name') {
          mbbh.put(field, mbb.get(field));
        }
      }
      mbbhs.add(mbbh);

    }

    return mbbhs;
  }
}