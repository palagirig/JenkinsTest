/**
* Testclass for P7S1_Account_Steuerkennzeichen  
*
* @author  Sebastian Listl
* @email listl@ambuorg.de 
* created 2014-10-23 -sli
* lastmod 2014-10-23 -sli 
* @see Account.trigger, P7S1_Account_Steuerkennzeichen
*/
@IsTest
public class P7S1_Account_LandSteuerkz_Test {
    
    private static String testname = 'P7S1_Account_Steuerkennzeichen_Test';
    
	@testSetup static void setupTestData() {
        insert new P7S1_Settings__c(P7S1_SteuerkennzeichenSyncActive__c = true);
	}

    private testmethod static void writeSteuerkennzeichen(){
        List<P7S1_Country__c> countries = new List<P7S1_Country__c>();
        P7S1_Country__c countryDeu = new P7S1_Country__c(P7S1_Abbreviation__c  ='D', P7S1_Steuerkennzeichen__c = 'AS',Alpha_3_Code__c='DEU',Alpha_2_Code__c='DE');
        P7S1_Country__c countryAut = new P7S1_Country__c(P7S1_Abbreviation__c  ='A', P7S1_Steuerkennzeichen__c = 'AE',Alpha_3_Code__c='AUT',Alpha_2_Code__c='AU');
        countries.add(countryDeu);
        countries.add(countryAut);
        insert countries;
        system.assertEquals(2, [Select Id, P7S1_Abbreviation__c, P7S1_Steuerkennzeichen__c FROM P7S1_Country__c WHERE P7S1_Abbreviation__c IN :(new String[]{'D','A'}) LIMIT 10000].size());
        
        Test.startTest();
        printLimits('after startTest');
        
        /*** TEST INSERT ***/
        Account account = cls_P7S1_TestData.createTestAccount(false);
        account.P7S1_Konzernmitglied__c = false;
        account.BillingCountry = 'D';
        
        insert account;
        
        Account accountToTest = [Select Id, P7S1_Steuerkennzeichen__c FROM Account WHERE Id = :account.Id ];
        system.assertEquals(countryDeu.P7S1_Steuerkennzeichen__c,accountToTest.P7S1_Steuerkennzeichen__c);
        
        /*** TEST UPDATE WITH CHANGE ***/
        account.BillingCountry = 'A';
        update account;
        
        accountToTest = [Select Id, P7S1_Steuerkennzeichen__c FROM Account WHERE Id = :account.Id ];
        system.assertEquals(countryAut.P7S1_Steuerkennzeichen__c,accountToTest.P7S1_Steuerkennzeichen__c);
        
        /*** TEST UPDATE WITHOUT CHANGE ***/
        account.BillingCountry = 'A';
        update account;
        
        accountToTest = [Select Id, P7S1_Steuerkennzeichen__c FROM Account WHERE Id = :account.Id ];
        system.assertEquals(countryAut.P7S1_Steuerkennzeichen__c,accountToTest.P7S1_Steuerkennzeichen__c);
        
        /*** TEST UPDATE NO MAPPING FOUND ***/
        account.BillingCountry = 'Y';
        try {
            update account;
            throw new MyException('An exception should have been thrown by the trigger but was not.');
        } catch(Exception e) {
            System.assert(e.getMessage().contains(Label.P7S1_Account_InvalidBillingCountry));
        }
        
        Test.stopTest();
        printLimits('after stopTest');
    }
            
    /*** TEST KONZERNMITGLIED ***/
    private testmethod static void writeSteuerkennzeichenIgnoreKonzernmitglied(){
        List<P7S1_Country__c> countries = new List<P7S1_Country__c>();
        P7S1_Country__c countryDeu = new P7S1_Country__c(P7S1_Abbreviation__c  ='D', P7S1_Steuerkennzeichen__c = 'AS',Alpha_3_Code__c='DEU',Alpha_2_Code__c='DE');
        P7S1_Country__c countryAut = new P7S1_Country__c(P7S1_Abbreviation__c  ='A', P7S1_Steuerkennzeichen__c = 'AE',Alpha_3_Code__c='AUT',Alpha_2_Code__c='AU');
        countries.add(countryDeu);
        countries.add(countryAut);
        insert countries;
        system.assertEquals(2, [Select Id, P7S1_Abbreviation__c, P7S1_Steuerkennzeichen__c FROM P7S1_Country__c WHERE P7S1_Abbreviation__c IN :(new String[]{'D','A'}) LIMIT 10000].size());
        
        Test.startTest();
        printLimits('after startTest');
        /*** TEST INSERT ***/
        Account account = cls_P7S1_TestData.createTestAccount(false);
        account.P7S1_Konzernmitglied__c = true;
        account.P7S1_Organschaft__c = true;
        account.BillingCountry = 'D';
        account.SomDig_PartnerId__c = '91820';
        //account.P7S1_Steuerkennzeichen__c = 'A0';
        insert account;
        
        Account accountToTest = [Select Id, P7S1_Steuerkennzeichen__c FROM Account WHERE Id = :account.Id ];
        system.assertEquals('A6',accountToTest.P7S1_Steuerkennzeichen__c);
        
        /*** TEST UPDATE ***/
        account.BillingCountry = 'A';
        update account;
        
        accountToTest = [Select Id, P7S1_Steuerkennzeichen__c FROM Account WHERE Id = :account.Id ];
        system.assertEquals(countryAut.P7S1_Steuerkennzeichen__c,accountToTest.P7S1_Steuerkennzeichen__c);
        
        
        /*** TEST Konzernmitglied Field changed ***/
        account.P7S1_Konzernmitglied__c = false;
        account.SomDig_PartnerId__c = '';
        update account;
        
        accountToTest = [Select Id, P7S1_Steuerkennzeichen__c FROM Account WHERE Id = :account.Id ];
        system.assertEquals(countryAut.P7S1_Steuerkennzeichen__c,accountToTest.P7S1_Steuerkennzeichen__c);
        
        Test.stopTest();
        printLimits('after stopTest');
    }
    
    /*** TEST CHANGE STEUERKENNZEICHEN ***/
    private testmethod static void writeSteuerkennzeichenChangeSteuerkennzeichen(){
    	List<P7S1_Country__c> countries = new List<P7S1_Country__c>();
        P7S1_Country__c countryDeu = new P7S1_Country__c(P7S1_Abbreviation__c  ='D', P7S1_Steuerkennzeichen__c = 'AS',Alpha_3_Code__c='DEU',Alpha_2_Code__c='DE');
        P7S1_Country__c countryAut = new P7S1_Country__c(P7S1_Abbreviation__c  ='A', P7S1_Steuerkennzeichen__c = 'AE',Alpha_3_Code__c='AUT',Alpha_2_Code__c='AU');
        countries.add(countryDeu);
        countries.add(countryAut);
        insert countries;
        system.assertEquals(2, [Select Id, P7S1_Abbreviation__c, P7S1_Steuerkennzeichen__c FROM P7S1_Country__c WHERE P7S1_Abbreviation__c IN :(new String[]{'D','A'}) LIMIT 10000].size());
        
        Test.startTest();
        printLimits('after startTest');
        
        /*** TEST INSERT ***/
        Account account = cls_P7S1_TestData.createTestAccount(false);
        account.P7S1_Konzernmitglied__c = false;
        account.BillingCountry = 'D';
        
        insert account;
        
        Account accountToTest = [Select Id, P7S1_Steuerkennzeichen__c FROM Account WHERE Id = :account.Id ];
        system.assertEquals(countryDeu.P7S1_Steuerkennzeichen__c,accountToTest.P7S1_Steuerkennzeichen__c);
        
        account.P7S1_Steuerkennzeichen__c = 'AE';
		update account;
		
		accountToTest = [Select Id, P7S1_Steuerkennzeichen__c FROM Account WHERE Id = :account.Id ];
        system.assertEquals(countryDeu.P7S1_Steuerkennzeichen__c,accountToTest.P7S1_Steuerkennzeichen__c);
        
		Test.stopTest();
		printLimits('after stopTest');
        
    }
    private testmethod static void getCountryByBillingCountryValue(){
        
        P7S1_Country__c countryDeu = new P7S1_Country__c(P7S1_Abbreviation__c  ='D', P7S1_Steuerkennzeichen__c = 'AS',	Name = 'Deuschland', Alpha_3_Code__c='DEU',Alpha_2_Code__c='DE',Name_EN__c='Germany',Name_DE__c='Schland');
        insert countryDeu;
    	
    	Test.startTest();
        printLimits('after startTest');
        
        /*** Test get country by P7S1_Abbreviation__c ***/
        Account account = cls_P7S1_TestData.createTestAccount(false);
        account.P7S1_Konzernmitglied__c = false;
        account.P7S1_Steuerkennzeichen__c ='Ax';
        account.BillingCountry = 'D';
        insert account;
        
        Account accountToTest = [Select Id, P7S1_Steuerkennzeichen__c,BillingCountry FROM Account WHERE Id = :account.Id ];
        system.assertEquals(countryDeu.P7S1_Steuerkennzeichen__c,accountToTest.P7S1_Steuerkennzeichen__c);
        system.assertEquals(countryDeu.P7S1_Abbreviation__c,accountToTest.BillingCountry);
        
        /*** Test get country by Name ***/
        account.BillingCountry = 'Deuschland';
        account.P7S1_Steuerkennzeichen__c ='Ax';
        
        update account;
        
        accountToTest = [Select Id, P7S1_Steuerkennzeichen__c,BillingCountry FROM Account WHERE Id = :account.Id ];
        system.assertEquals(countryDeu.P7S1_Steuerkennzeichen__c,accountToTest.P7S1_Steuerkennzeichen__c);
        system.assertEquals(countryDeu.P7S1_Abbreviation__c,accountToTest.BillingCountry);
        
        /*** Test get country by Name_DE__c ***/
        account.BillingCountry = 'Schland';
        account.P7S1_Steuerkennzeichen__c ='Ax';
        
        update account;
        
        accountToTest = [Select Id, P7S1_Steuerkennzeichen__c,BillingCountry FROM Account WHERE Id = :account.Id ];
        system.assertEquals(countryDeu.P7S1_Steuerkennzeichen__c,accountToTest.P7S1_Steuerkennzeichen__c);
        system.assertEquals(countryDeu.P7S1_Abbreviation__c,accountToTest.BillingCountry);
        
        /*** Test get country by Name_EN__c ***/
        account.BillingCountry = 'Germany';
        account.P7S1_Steuerkennzeichen__c ='Ax';
        
        update account;
        
        accountToTest = [Select Id, P7S1_Steuerkennzeichen__c,BillingCountry FROM Account WHERE Id = :account.Id ];
        system.assertEquals(countryDeu.P7S1_Steuerkennzeichen__c,accountToTest.P7S1_Steuerkennzeichen__c);
        system.assertEquals(countryDeu.P7S1_Abbreviation__c,accountToTest.BillingCountry);
        
        /*** Test get country by Alpha_2_Code__c ***/
        account.BillingCountry = 'DE';
        account.P7S1_Steuerkennzeichen__c ='Ax';
        
        update account;
        
        accountToTest = [Select Id, P7S1_Steuerkennzeichen__c,BillingCountry FROM Account WHERE Id = :account.Id ];
        system.assertEquals(countryDeu.P7S1_Steuerkennzeichen__c,accountToTest.P7S1_Steuerkennzeichen__c);
        system.assertEquals(countryDeu.P7S1_Abbreviation__c,accountToTest.BillingCountry);
        
        /*** Test get country by Alpha_3_Code__c ***/
        account.BillingCountry = 'DEU';
        account.P7S1_Steuerkennzeichen__c ='Ax';
        
        update account;
        
        accountToTest = [Select Id, P7S1_Steuerkennzeichen__c,BillingCountry FROM Account WHERE Id = :account.Id ];
        system.assertEquals(countryDeu.P7S1_Steuerkennzeichen__c,accountToTest.P7S1_Steuerkennzeichen__c);
        system.assertEquals(countryDeu.P7S1_Abbreviation__c,accountToTest.BillingCountry);
        
        /*** Test BillingCountry equals null ***/
        account.BillingCountry = null;
        
        try {
            update account;
            throw new MyException('An exception should have been thrown by the trigger but was not.');
        } catch(Exception e) {
            System.assert(e.getMessage().contains(Label.P7S1_Account_InvalidBillingCountry));
        }
        
        Test.stopTest();
		printLimits('after stopTest');
    }
    
    private static void printLimits(String info){
        info = (info == null  ? info : '');
        System.debug(testname + ' ' + info + ' Total Number of SOQL Queries allowed in this apex code context: ' +  Limits.getLimitQueries());
        System.debug(testname + ' ' + info + ' Total Number of records that can be queried  in this apex code context: ' +  Limits.getLimitDmlRows());
        System.debug(testname + ' ' + info + ' Total Number of DML statements allowed in this apex code context: ' +  Limits.getLimitDmlStatements());
        System.debug(testname + ' ' + info + ' Queries used in this : ' + Limits.getQueries());
        System.debug(testname + ' ' + info + ' Rows queried in this : ' + Limits.getDmlRows());
        System.debug(testname + ' ' + info + ' Number of script statements : ' +  Limits.getDmlStatements());
        System.debug(testname + ' ' + info + ' Number of Queries : ' + Limits.getQueries());
        System.debug(testname + ' ' + info + ' Number of rows queried: ' + Limits.getDmlRows());
    }

    public class MyException extends Exception {}

}