trigger Adv_AdType on ADvendio__Ad_Type__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    if (Trigger.isBefore && Trigger.isUpdate){
       for ( ADvendio__Ad_Type__c aAdType : Trigger.newMap.values() ){
           if (aAdType.ADvendio__ReportSlots__c != null){
               aAdType.SomDig_ReportSlots__c = aAdType.ADvendio__ReportSlots__c + '';
           }
       }
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        Adv_AdSpec_InheritFromAdType.runFromAdTypeTrigger(Trigger.newMap, Trigger.oldMap);
    }


}