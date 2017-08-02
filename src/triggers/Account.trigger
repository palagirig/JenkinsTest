trigger Account on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        /*
        Added new method for writing Steuerkennzeichen From Country to Account
        Ticket 04176-AMBU-SLI-16.06.2016
        https://p7s1.my.salesforce.com/5005700001CxHp9
        */
        // Ticket 04474-JS-18.08.2016 Nielsen und Laender/Steuerkennzeichen getauscht.
        P7S1_Account_LandSteuerkz.writeSteuerkennzeichen(Trigger.isInsert, Trigger.isUpdate, Trigger.newMap, Trigger.oldMap, Trigger.new);
        P7S1_Account_NielsenArea.setNielsenArea(Trigger.oldMap, Trigger.new, Trigger.isUpdate);
    }

    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        P7S1_Account_Visibility.updateVisibility(Trigger.oldMap, Trigger.new, Trigger.isInsert, Trigger.isUpdate);
    }

    if (Trigger.isBefore && ( Trigger.isInsert ||  Trigger.isUpdate  ) ) {
        P7S1_Account_NameDwh.writeNameDwhField(Trigger.isInsert, Trigger.new, (Map<Id,Account>) Trigger.oldMap);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        Som_Contact_Address.runFromAccountTrigger(Trigger.new, Trigger.oldMap);
    }

    new AccountTrigger(
        Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUnDelete, Trigger.isUpdate,
        Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    ).run();

    new P7S1_Account_Sphere(
        Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUnDelete, Trigger.isUpdate,
        Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    ).run();

    /*
    Added new Method for Account Index creation
    factory42 - VVR - 26.10.2015
    */
    new P7S1_Account_Index_Creator(
        Trigger.isAfter, Trigger.isBefore, Trigger.isDelete, Trigger.isInsert, Trigger.isUnDelete, Trigger.isUpdate,
        Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    ).run();

    /*
    Added new Method for setting sales fields on Account
    factory42 - BS - 25.11.2015
    */
    if(Trigger.isAfter && Trigger.isUpdate){
        P7S1_Account_SetSalesFields.getAccIdsFromAccount(Trigger.new);
    }
    
    /*
    Added new Method for Case 3981
    */
    if(Trigger.isAfter && Trigger.isUpdate){
        Adv_Invoice_PreInvoiceDataSync.syncDataToPreInvoices(Trigger.new, Trigger.oldMap, 'Account');
    }

}