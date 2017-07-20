/************************************************************************************************************
Name:      Test blah
======================================================
Purpose: Test
======================================================
History
-------
Date        AUTHOR                      DETAIL
19.07.2017  Gokul-Prasad Palagiri       Test
*************************************************************************************************************/
public class zFeature1_TriggerHandler_1 extends TriggerController {
  public zFeature1_TriggerHandler_1 (Boolean isAfter, Boolean isBefore, Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate,
    List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems) {
    super(isAfter, isBefore, isDelete, isInsert, isUndelete, isUpdate, lstNewItems, mapNewItems, lstOldItems, mapOldItems);
  }
  
  public override void runBeforeInsert() {
   //blah blah
  }

  public override void runAfterInsert() {
   //blah blah
  }


}