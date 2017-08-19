trigger Adv_CampaignItem on ADvendio__Campaign_Item__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if (Trigger.isBefore && Trigger.isUpdate) {
        Adv_CampaignItem_Storno.storeAdIds(Trigger.New, Trigger.oldMap);
    }

    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        Adv_CampaignItem_Validation.validateAdId(Trigger.New, Trigger.oldMap);
    }

    // KV 04273 Löschen Kamp.Position verhindern, wenn Rechnungspositionen existieren
    new Adv_CampaignItem_DeleteBlocker(
        Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUnDelete, Trigger.isUpdate,
        Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    ).run();

    new Adv_CampaignItem_Naturalrabatt(
        Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUnDelete, Trigger.isUpdate,
        Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    ).run();

    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
        Adv_CampaignItem_PDFCheckboxes.setPDFCheckboxes(Trigger.new);

    new Adv_CampaignItem_FieldChanges(
        Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUnDelete, Trigger.isUpdate,
        Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    ).run();

    new Adv_CampaignItem_ResetAvailability(
        Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUnDelete, Trigger.isUpdate,
        Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    ).run();
    
    new Adv_CampaignItem_PositionStatus(
        Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUnDelete, Trigger.isUpdate,
        Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    ).run();
    if (Trigger.isBefore && Trigger.isUpdate)
        Adv_CampaignItem_PositionStatus.setStatus(Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUndelete, Trigger.isUpdate, Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);


    if (Trigger.isAfter && Trigger.isUpdate)
        Adv_CampaignItem_DurationChanged.deleteOtherOVs(Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUndelete, Trigger.isUpdate, Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);

    if (Trigger.isBefore && Trigger.isInsert) {
        Adv_CampaignItem_Inventarklasse.setInventarklassen(Trigger.new);
    }

    new Adv_MediaCampaign_Status(
        Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUnDelete, Trigger.isUpdate,
        Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    ).run();

    new Adv_MediaCampaign_Dates(
        Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUnDelete, Trigger.isUpdate,
        Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    ).run();

    new Adv_CampaignItem_DeliverPrio(
        Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUnDelete, Trigger.isUpdate,
        Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    ).run();

    new Adv_CampaignItem_DynamicQuantity(
        Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUnDelete, Trigger.isUpdate,
        Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    ).run();


    if(Trigger.isBefore && Trigger.isInsert) {
        Adv_CampaignItem_Commitment.setCampaignItemDiscounts(Trigger.new);
    }


    new Adv_CampaignItem_LineareVerteilung(
        Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUnDelete, Trigger.isUpdate,
        Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    ).run();

    if (Trigger.isInsert)
        Adv_CampaignItem_Storno.updateFields(Trigger.new, Trigger.isAfter);

    new Adv_CampaignItem_PackageSumDeliveries(
        Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUnDelete, Trigger.isUpdate, Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    ).run();


		// TI 4359
    if(Trigger.isBefore && Trigger.isUpdate) {
        Adv_CampaignItem_Validation.validateCampaignItems(Trigger.new, Trigger.oldMap);
    }


     /*
    Added new Methode for Case 3981
    */
    if(Trigger.isAfter && Trigger.isUpdate){
        Adv_Invoice_PreInvoiceDataSync.syncDataToPreInvoices(Trigger.new, Trigger.oldMap, 'ADvendio__Campaign_Item__c');
    }

    if (Trigger.isBefore && Trigger.isInsert) {
        Adv_CampaignItem_AutoPopulationKv.removeBt0(trigger.new);
    }
    if (Trigger.isBefore && Trigger.isUpdate) {
        Adv_CampaignItem_AutoPopulationKv.removeBt0(trigger.newMap, trigger.OldMap);
    }
}