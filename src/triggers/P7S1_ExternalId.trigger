trigger P7S1_ExternalId on P7S1_ExternalId__c (before insert, after insert, before update, after update, before delete, after delete) {
 new P7S1_ExternalId_TriggerHandler(
        Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUnDelete, Trigger.isUpdate,
        Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    ).run();
}