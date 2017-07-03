/**
 * Media Transparency Trigger handler for P7S1_OpportunityApproval__c object.
 *
 * History
 * -------
 * Date       	AUTHOR            		DETAIL
 * 30.11.2016	Balaji Munirathinam		Initial architecture & development
 * 20.04.2017 	Falco Aulitzky    		Code documentation
 **/
public class MT_OpportunityApproval_TriggerHandler extends TriggerController {
  public MT_OpportunityApproval_TriggerHandler(Boolean isAfter, Boolean isBefore, Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate,
    List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems) {
    super(isAfter, isBefore, isDelete, isInsert, isUndelete, isUpdate, lstNewItems, mapNewItems, lstOldItems, mapOldItems);
  }

  public override void runBeforeUpdate() {
  }
  public override void runAfterUpdate() {
  }

}