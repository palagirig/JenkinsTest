public class P7S1_ExternalId_TriggerHandler extends TriggerController{

    public P7S1_ExternalId_TriggerHandler(Boolean isAfter, Boolean isBefore, Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate,
                                         List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems) {
        super(isAfter, isBefore, isDelete, isInsert, isUndelete, isUpdate, lstNewItems, mapNewItems, lstOldItems, mapOldItems);
    }
    
    public override void runAfterUpdate(){
        P7S1_ExternalID_DebNrSync.getDebitor(lstNewItems, (Map<Id, P7S1_ExternalId__c>)mapOldItems, isInsert, isUpdate);
    }
    
    public override void runAfterInsert(){
        P7S1_ExternalID_DebNrSync.getDebitor(lstNewItems, (Map<Id, P7S1_ExternalId__c>)mapOldItems, isInsert, isUpdate);
    }
    
    public override void runBeforeDelete(){
        P7S1_ExternalID_DebNrSync.removeDebitor(lstOldItems);
    }
}