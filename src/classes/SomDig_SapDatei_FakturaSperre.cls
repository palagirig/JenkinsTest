/**
* @author	stefan.voss@advendio.com
**/
public with sharing class SomDig_SapDatei_FakturaSperre implements Schedulable {

    /**
     * remove any active Faktura-Sperre from HR SAP-Datei records 
     */
    @TestVisible
	private void removeFakturaSperre() {
		Id rtHrSapDatei	= SomDig_Buchungssatz_EaBase.getRecordTypeIdByName('SomDig_SapDatei__c', 'SomDig_Hochrechnung');
		
		List<SomDig_SapDatei__c> sapDateiRecords	= [SELECT Id, SomDig_FakturaSperre__c FROM SomDig_SapDatei__c WHERE SomDig_FakturaSperre__c = true AND RecordTypeId = :rtHrSapDatei];
		for (SomDig_SapDatei__c sapDatei : sapDateiRecords) {
			sapDatei.SomDig_FakturaSperre__c	= false;
		}
		update sapDateiRecords;
	}

    /**
     * Schedule job execution routine.
     *
     * @param   sc      Context of the Scheduleable job.
     */
    public void execute(SchedulableContext sc) {
        removeFakturaSperre();
    } 
}