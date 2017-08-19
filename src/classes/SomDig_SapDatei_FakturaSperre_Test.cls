/**
* @author	stefan.voss@advendio.com
**/
@isTest
private class SomDig_SapDatei_FakturaSperre_Test {
	
	@isTest (seeAllData=false)
    static void testRemoveFakturaSperre() {
    	Id rtHrSapDatei	= SomDig_Buchungssatz_EaBase.getRecordTypeIdByName('SomDig_SapDatei__c', 'SomDig_Hochrechnung');
    	Id rtEaSapDatei	= SomDig_Buchungssatz_EaBase.getRecordTypeIdByName('SomDig_SapDatei__c', 'SomDig_Erloesaufteilung');
    	
    	SomDig_SapDatei__c sapDateiEa1	= new SomDig_SapDatei__c();
    	sapDateiEa1.RecordTypeId	= rtEaSapDatei;
    	
    	SomDig_SapDatei__c sapDateiHr2	= new SomDig_SapDatei__c();
    	sapDateiHr2.RecordTypeId	= rtHrSapDatei;
    	
    	SomDig_SapDatei__c sapDateiHr1	= new SomDig_SapDatei__c();
    	sapDateiHr1.RecordTypeId	= rtHrSapDatei;
    	insert new List<SomDig_SapDatei__c> {sapDateiHr1, sapDateiHr2, sapDateiEa1};
    	
    	for (SomDig_SapDatei__c sapDatei : [SELECT Id, SomDig_FakturaSperre__c FROM SomDig_SapDatei__c]) {
    		if (sapDatei.Id == sapDateiHr1.Id) {
    			system.assert(sapDatei.SomDig_FakturaSperre__c);
    		}
    		if (sapDatei.Id == sapDateiHr2.Id) {
    			system.assert(sapDatei.SomDig_FakturaSperre__c);
    		}
    		if (sapDatei.Id == sapDateiEa1.Id) {
    			system.assert(!sapDatei.SomDig_FakturaSperre__c);
    			sapDatei.SomDig_FakturaSperre__c	= true;
    			update sapDatei;
    		}
    	}
    	
    	Test.startTest();
        SomDig_SapDatei_FakturaSperre fs	= new SomDig_SapDatei_FakturaSperre();
        fs.removeFakturaSperre();
        
        for (SomDig_SapDatei__c sapDatei : [SELECT Id, SomDig_FakturaSperre__c FROM SomDig_SapDatei__c]) {
        	if (sapDatei.Id == sapDateiEa1.Id) {
    			system.assert(sapDatei.SomDig_FakturaSperre__c);
    		}
    		else {
    			system.assert(!sapDatei.SomDig_FakturaSperre__c);
    		}
        }
        Test.stopTest();
    }
}