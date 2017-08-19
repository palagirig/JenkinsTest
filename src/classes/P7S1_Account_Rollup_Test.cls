@isTest
public class P7S1_Account_Rollup_Test{
    
    public static testMethod void testopportunityToAccountRollups() {
        
        Account acc = cls_P7S1_TestData.createTestAccount(true);
        
        // Opportunities for current year.
        Opportunity opp1 = cls_P7S1_TestData.createTestOpportunity(false,acc);
        opp1.RecordTypeId = '012D0000000QmVy';
        opp1.StageName = 'Geschlossene und gewonnene';
        opp1.SomTv_Plattform__c = 'P7MAXX';
        opp1.SomTv_MN3__c  = 101;
        opp1.SomTv_Jahr__c = String.valueOf(Date.today().year());
        opp1.amount = 1;
        
        Opportunity opp2 = cls_P7S1_TestData.createTestOpportunity(false,acc);
        opp2.RecordTypeId = '012D0000000QmVz';
        opp2.StageName = 'Rabatt freigegeben';
        opp2.SomTv_Plattform__c = 'P7MAXX';
        opp2.SomTv_MN3__c  = 102;
        opp2.SomTv_Jahr__c = String.valueOf(Date.today().year());
        opp2.amount = 2;
        
        // Opportunities for last year.
        Opportunity opp3 = cls_P7S1_TestData.createTestOpportunity(false,acc);
        opp3.RecordTypeId = '012D0000000QmVy';
        opp3.StageName = 'Geschlossene und gewonnene';
        opp3.SomTv_Plattform__c = 'P7MAXX';
        opp3.SomTv_MN3__c  = 103;
        opp3.SomTv_Jahr__c = String.valueOf(Date.today().addyears(-1).year());
        opp3.amount = 2;
        
        Opportunity opp4 = cls_P7S1_TestData.createTestOpportunity(false,acc);
        opp4.RecordTypeId = '012D0000000QmVz';
        opp4.StageName = 'Rabatt freigegeben';
        opp4.SomTv_Plattform__c = 'P7MAXX';
        opp4.SomTv_MN3__c  = 104;
        opp4.SomTv_Jahr__c = String.valueOf(Date.today().addyears(-1).year());
        opp4.amount = 2;
        
        // Sixx plattform
        Opportunity opp5 = cls_P7S1_TestData.createTestOpportunity(false,acc);
        opp5.RecordTypeId = '012D0000000QmVy';
        opp5.StageName = 'Geschlossene und gewonnene';
        opp5.SomTv_Plattform__c = 'Sixx';
        opp5.SomTv_MN3__c  = 105;
        opp5.SomTv_Jahr__c = String.valueOf(Date.today().addyears(-1).year());
        opp5.amount = 2;
        
        Opportunity opp6 = cls_P7S1_TestData.createTestOpportunity(false,acc);
        opp6.RecordTypeId = '012D0000000QmVz';
        opp6.StageName = 'Rabatt freigegeben';
        opp6.SomTv_Plattform__c = 'Sixx';
        opp6.SomTv_MN3__c  = 106;
        opp6.SomTv_Jahr__c = String.valueOf(Date.today().addyears(-1).year());
        opp6.amount = 2;
        
        test.startTest();
        
        // Mix bulk and single inserts.
        insert new List<Opportunity>{ opp1, opp2, opp3, opp5 };
        Account accAfterOppBulkInsert = [SELECT SomTv_OpptiVJP7MAXX__c, SomTv_OpptiVJsixx__c, SomTv_OpptiVJK1Doku__c, SomTv_OpptiVJSat1GOLD__c, SomTv_OpptiK1Doku__c, SomTv_OpptiP7MAXX__c, SomTv_OpptiSat1GOLD__c, SomTv_Opptisixx__c FROM Account WHERE Id = :acc.Id];
        
        insert opp4;
        insert opp6;
        Account accAfterOppSingleInserts = [SELECT SomTv_OpptiVJP7MAXX__c, SomTv_OpptiVJsixx__c, SomTv_OpptiVJK1Doku__c, SomTv_OpptiVJSat1GOLD__c, SomTv_OpptiK1Doku__c, SomTv_OpptiP7MAXX__c, SomTv_OpptiSat1GOLD__c, SomTv_Opptisixx__c FROM Account WHERE Id = :acc.Id];
        
        opp1.SomTv_MN3__c = 201;
        update opp1;
        Account accAfterOpp1stUpdate = [SELECT SomTv_OpptiVJP7MAXX__c, SomTv_OpptiVJsixx__c, SomTv_OpptiVJK1Doku__c, SomTv_OpptiVJSat1GOLD__c, SomTv_OpptiK1Doku__c, SomTv_OpptiP7MAXX__c, SomTv_OpptiSat1GOLD__c, SomTv_Opptisixx__c FROM Account WHERE Id = :acc.Id];
        
        opp2.SomTv_MN3__C = 202;
        opp3.SomTv_MN3__C = 203;
		opp5.SomTv_MN3__C = 205;
        update new List<Opportunity>{ opp2, opp3, opp5};
        Account accAfterOpp2ndUpdate = [SELECT SomTv_OpptiVJP7MAXX__c, SomTv_OpptiVJsixx__c, SomTv_OpptiVJK1Doku__c, SomTv_OpptiVJSat1GOLD__c, SomTv_OpptiK1Doku__c, SomTv_OpptiP7MAXX__c, SomTv_OpptiSat1GOLD__c, SomTv_Opptisixx__c FROM Account WHERE Id = :acc.Id];
        
        test.stopTest();
        
        opp4.SomTv_MN3__C = 204;
		opp6.SomTv_MN3__C = 206; 
        update opp4;
        update opp6;
        Account accAfterOpp3rdUpdate = [SELECT SomTv_OpptiVJP7MAXX__c, SomTv_OpptiVJsixx__c, SomTv_OpptiVJK1Doku__c, SomTv_OpptiVJSat1GOLD__c, SomTv_OpptiK1Doku__c, SomTv_OpptiP7MAXX__c, SomTv_OpptiSat1GOLD__c, SomTv_Opptisixx__c FROM Account WHERE Id = :acc.Id];
        
        
        
        delete opp1;
        Account accAfterOpp1stDelete = [SELECT SomTv_OpptiVJP7MAXX__c, SomTv_OpptiVJsixx__c, SomTv_OpptiVJK1Doku__c, SomTv_OpptiVJSat1GOLD__c, SomTv_OpptiK1Doku__c, SomTv_OpptiP7MAXX__c, SomTv_OpptiSat1GOLD__c, SomTv_Opptisixx__c FROM Account WHERE Id = :acc.Id];
        
        
        
        
        System.assertEquals(203, accAfterOppBulkInsert.SomTv_OpptiP7MAXX__c);
        System.assertEquals(103, accAfterOppBulkInsert.SomTv_OpptiVJP7MAXX__c);
		System.assertEquals(105, accAfterOppBulkInsert.SomTv_OpptiVJsixx__c);		
        
        System.assertEquals(203, accAfterOppSingleInserts.SomTv_OpptiP7MAXX__c);
        System.assertEquals(207, accAfterOppSingleInserts.SomTv_OpptiVJP7MAXX__c);
		System.assertEquals(211, accAfterOppSingleInserts.SomTv_OpptiVJsixx__c);
        
		System.assertEquals(303, accAfterOpp1stUpdate.SomTv_OpptiP7MAXX__c);
        
        System.assertEquals(403, accAfterOpp2ndUpdate.SomTv_OpptiP7MAXX__c);
        System.assertEquals(307, accAfterOpp2ndUpdate.SomTv_OpptiVJP7MAXX__c);
		System.assertEquals(311, accAfterOpp2ndUpdate.SomTv_OpptiVJsixx__c);
        
        System.assertEquals(403, accAfterOpp3rdUpdate.SomTv_OpptiP7MAXX__c);
        System.assertEquals(407, accAfterOpp3rdUpdate.SomTv_OpptiVJP7MAXX__c);
		System.assertEquals(411, accAfterOpp3rdUpdate.SomTv_OpptiVJsixx__c);
        
        System.assertEquals(202, accAfterOpp1stDelete.SomTv_OpptiP7MAXX__c);
        System.assertEquals(407, accAfterOpp1stDelete.SomTv_OpptiVJP7MAXX__c);
		System.assertEquals(411, accAfterOpp1stDelete.SomTv_OpptiVJsixx__c);
    }
    
    public static testMethod void testforecastToAccountRollups() {
        
        // Test data.
        Account acc = cls_P7S1_TestData.createTestAccount(true);
        SomTv_ForecastTV__c forecast1 = createTestForecast(acc, 101, false);
        SomTv_ForecastTV__c forecast2 = createTestForecast(acc, 102, false);
        
        Test.startTest();
        
        insert forecast1;
        Account accAfter1Insert = [SELECT SomTv_ForecastK1DokuMN3__c, SomTv_ForecastPro7MAXXMN3__c FROM Account WHERE Id = :acc.ID];
        
        insert forecast2;
        Account accAfter2Insert = [SELECT SomTv_ForecastK1DokuMN3__c, SomTv_ForecastPro7MAXXMN3__c FROM Account WHERE Id = :acc.ID];
        
        forecast1.SomTv_ForecastPro7MAXXMN3__c = 201;
        update forecast1;
        Account accAfter1update = [SELECT SomTv_ForecastK1DokuMN3__c, SomTv_ForecastPro7MAXXMN3__c FROM Account WHERE Id = :acc.ID];
        
        delete forecast1;
        Account accAfter1delete = [SELECT SomTv_ForecastK1DokuMN3__c, SomTv_ForecastPro7MAXXMN3__c FROM Account WHERE Id = :acc.ID];
        
        Test.stopTest();
        
        //first insert
        System.assertEquals(101, accAfter1Insert.SomTv_ForecastK1DokuMN3__c);
        System.assertEquals(101, accAfter1Insert.SomTv_ForecastPro7MAXXMN3__c);
        
        
        //Second insert
        System.assertEquals(203, accAfter2Insert.SomTv_ForecastK1DokuMN3__c);
        System.assertEquals(203, accAfter2Insert.SomTv_ForecastPro7MAXXMN3__c);
        
        //first update
        System.assertEquals(203, accAfter1update.SomTv_ForecastK1DokuMN3__c);
        System.assertEquals(303, accAfter1update.SomTv_ForecastPro7MAXXMN3__c);
        
        //first delete
        System.assertEquals(102, accAfter1delete.SomTv_ForecastK1DokuMN3__c);
        System.assertEquals(102, accAfter1delete.SomTv_ForecastPro7MAXXMN3__c);
    }
    
    private static SomTV_ForecastTV__c createTestForecast(Account acc, Integer forecastValue, Boolean doInsert) {
        SomTv_ForecastTV__c testForecast = new SomTv_ForecastTV__c();
        testForecast.SomTv_Agentur__c = cls_P7S1_TestData.createTestAccount(true).Id;
        testForecast.SomTV_Account__c = acc.Id;
        testForecast.SomTv_Jahr__c = String.valueOf(Date.today().year());
        testForecast.SomTv_ForecastK1DokuMN3__c = forecastValue;
        testForecast.SomTv_ForecastPro7MAXXMN3__c = forecastValue;
        testForecast.SomTv_ForecastSAT1GOLDMN3__c = forecastValue;
        testForecast.SomTv_ForecastsixxMN3__c = forecastValue;
        testForecast.SomTv_ForecastCommitmentsKernsenderMN3__c = forecastValue;
        testForecast.SomTv_ForecastPaketeKernsenderMN3__c = forecastValue;
        testForecast.SomTv_ForecastZubuchungKernsenderMN3__c = forecastValue;
        if(doInsert) insert testForecast;
        return testForecast;
    }

}