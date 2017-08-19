trigger Adv_InvoiceItem on ADvendio__InvoiceItem__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    new Adv_InvoiceItem_FieldChanges(
        Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUnDelete, Trigger.isUpdate,
        Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    ).run();

}