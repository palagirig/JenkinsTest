trigger Adv_OptimizingChange on ADvendio__OptimizingChange__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    new Adv_OptimizingChange_Storno(
        Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUnDelete, Trigger.isUpdate, Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    ).run();

    if (Trigger.isBefore && Trigger.isInsert) {
        Adv_OptimizingChange_ReduceAmount.checkAmountReduced(Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUndelete, Trigger.isUpdate, Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
    }


    if (Trigger.isAfter && Trigger.isInsert) {

        Adv_OptimizingChange_LineDesc.setLineDescription(Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUndelete, Trigger.isUpdate, Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);


        Adv_OptimizingChange_Cancel.cancelPosition(Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUndelete, Trigger.isUpdate, Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);

        Adv_OptimizingChange_DeliverPrio.calculatePriority(Trigger.new);
    }


    new Adv_OptimizingChange_DynamicQuantity(
        Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUnDelete, Trigger.isUpdate,
        Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    ).run();

}