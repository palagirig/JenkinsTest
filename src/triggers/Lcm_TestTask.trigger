trigger Lcm_TestTask on Lcm_TestTask__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    Lcm_TestTask_CaseClone l_oTask = new Lcm_TestTask_CaseClone();

    l_oTask.RunTrigger(
        Trigger.isBefore, Trigger.isAfter,
        Trigger.isInsert, Trigger.isUpdate,
        Trigger.isDelete, Trigger.isUnDelete,
        Trigger.new, Trigger.newMap,
        Trigger.old, Trigger.oldMap
    );

}