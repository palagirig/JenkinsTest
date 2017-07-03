/**
* This class tests the P7S1_Account_NameDwh trigger class
*
* @author  Sebastian Listl, Jan Schweighart
* @version 0.1
* created 2016-07-12 - sli,jsc
* lastmod 2016-07-12 sli,jsc
* @see P7S1_Account_NameDwh
*/

@isTest
public class P7S1_Account_NameDwh_Test {
	
    @isTest
    private static void writeNameDwhField() {
    	
        Account testAccount = cls_P7S1_TestData.createTestAccount(false);
        testAccount.Name = cls_P7S1_Utils_Test.STRING_TO_REPLACE_WITH_REPLACEMENT;
        insert testAccount;
        
        Test.startTest();
        	/*** check insert ***/
        	system.assertEquals(cls_P7S1_Utils_Test.EXPECTED_STRING_WITH_REPLACEMENT, [Select P7S1_NameDwh__c FROM Account WHERE Id = :testAccount.Id].P7S1_NameDwh__c); 
        	
        	/*** check update field change ***/
        	testAccount.Name = cls_P7S1_Utils_Test.STRING_WITHOUT_REPLACEMENT;
        	update testAccount; 
        	system.assertEquals(cls_P7S1_Utils_Test.STRING_WITHOUT_REPLACEMENT, [Select P7S1_NameDwh__c FROM Account WHERE Id = :testAccount.Id].P7S1_NameDwh__c);
        	/*** check update no field change ***/
        	update testAccount; 
        	system.assertEquals(cls_P7S1_Utils_Test.STRING_WITHOUT_REPLACEMENT, [Select P7S1_NameDwh__c FROM Account WHERE Id = :testAccount.Id].P7S1_NameDwh__c);
        	/*** check update field change dwh (dummy update)***/
        	testAccount.P7S1_NameDwh__c = 'chuck norris';
        	update testAccount;
        	system.assertEquals(cls_P7S1_Utils_Test.STRING_WITHOUT_REPLACEMENT, [Select P7S1_NameDwh__c FROM Account WHERE Id = :testAccount.Id].P7S1_NameDwh__c);
        
        Test.stopTest();
        
    }
}