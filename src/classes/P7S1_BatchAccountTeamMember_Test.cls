/**
* ===================================================================
* (c) factory42 GmbH 2016, Germany, All rights reserved
* P7S1_BatchAccountTeamMember_Test
* @author       vvonrekowski factory42 GmbH
* @email        vvonrekowski@factory42.com
* @version      V0.1
* @ date        2016/02/16  
* @description  
* @last change  
* @objects      
* =================================================================
*/ 
@isTest
private class P7S1_BatchAccountTeamMember_Test{
	private static Date dateToday = date.today();
    private static Integer maxNumber = 10;  
	private static list<Account> lstAccount = new list<Account>();
	private static Account AccKunde = new Account();
	private static Account AccAgentur = new Account();
	private static Account AccAgentur2 = new Account();
    private static SomTv_KundeAgenturBeziehung__c KaB = new SomTv_KundeAgenturBeziehung__c();
    private static SomTv_KundeAgenturBeziehung__c KaB2 = new SomTv_KundeAgenturBeziehung__c();
	
	/*********************
	EXECUTE BATCH
	*/
    static testMethod void test_Batch() {
        createTestData();
        //--------------- 
		
        system.assertEquals(null, [SELECT P7S1_RelevantAgency__c from Account where id = :AccKunde.id].P7S1_RelevantAgency__c);

		Test.startTest();
    	     
        P7S1_BatchAccountTeamMember newBatch = new P7S1_BatchAccountTeamMember();
    	Database.executeBatch(newBatch);
    			
		Test.stopTest();
		Account a = [select id,SOM_TVKundenverkaeufer__c,SOM_Einkaufsagenturverkaeufer__c,SOM_Planungsagenturverkaeufer__c, P7S1_RelevantAgency__c from Account where id = :AccKunde.id];
		system.assertEquals(1,[select count() from AccountTeamMember]);
		system.assertEquals(Userinfo.getUserId(),a.SOM_TVKundenverkaeufer__c);
		system.assertEquals(Userinfo.getUserId(),a.SOM_Einkaufsagenturverkaeufer__c);
		system.assertEquals(Userinfo.getUserId(),a.SOM_Planungsagenturverkaeufer__c);
        system.assertEquals([SELECT Id FROM Account WHERE ID = :accAgentur.Id].ID, a.P7S1_RelevantAgency__c);
    }
    
    static testMethod void test_clear_Relevant_Agency() {
        createTestData();
        //--------------- 
		
        AccKunde.P7S1_RelevantAgency__c = accAgentur.Id;
        update accKunde;
        
        KaB.SomTv_RelevanteBeziehung__c = false;
        update KaB;
        
        system.assertEquals(accAgentur.Id, [SELECT P7S1_RelevantAgency__c from Account where id = :AccKunde.id].P7S1_RelevantAgency__c);

		Test.startTest();
    	     
        P7S1_BatchAccountTeamMember newBatch = new P7S1_BatchAccountTeamMember();
    	Database.executeBatch(newBatch);
        
		Test.stopTest();
        
        system.assertEquals(null, [SELECT P7S1_RelevantAgency__c from Account where id = :AccKunde.id].P7S1_RelevantAgency__c);

    }
    
    static testMethod void test_reassign_Relevant_Agency() {
        createTestData();
        //--------------- 
		
        AccKunde.P7S1_RelevantAgency__c = accAgentur.Id;
        update accKunde;
        
        KaB.SomTv_RelevanteBeziehung__c = false;
        update KaB;
        
        KaB2.SomTv_RelevanteBeziehung__c = true;
        update KaB2;
        
        system.assertEquals(accAgentur.Id, [SELECT P7S1_RelevantAgency__c from Account where id = :AccKunde.id].P7S1_RelevantAgency__c);

		Test.startTest();
    	     
        P7S1_BatchAccountTeamMember newBatch = new P7S1_BatchAccountTeamMember();
    	Database.executeBatch(newBatch);
        
		Test.stopTest();
        
        system.assertEquals(accAgentur2.Id, [SELECT P7S1_RelevantAgency__c from Account where id = :AccKunde.id].P7S1_RelevantAgency__c);

    }

    static testMethod void test_selflookup_Relevant_Agency() {
        createTestData();
        //--------------- 
		
        AccKunde.P7S1_RelevantAgency__c = null;
        update accKunde;

        KaB.Agentur__c = AccKunde.Id;
        update KaB;
        
        system.assertEquals(null, [SELECT P7S1_RelevantAgency__c from Account where id = :AccKunde.id].P7S1_RelevantAgency__c);

		Test.startTest();
    	     
        P7S1_BatchAccountTeamMember newBatch = new P7S1_BatchAccountTeamMember();
    	Database.executeBatch(newBatch);
        
		Test.stopTest();
        
        system.assertEquals(null, [SELECT P7S1_RelevantAgency__c from Account where id = :AccKunde.id].P7S1_RelevantAgency__c);

    }
     
    
    /*********************
	test BATCH SCHEDULE 
	*/
	static testMethod void testScheduleForBatch(){
		Test.startTest();
		
		Date dtToday = Date.today();
		DateTime dtNextRun = DateTime.newInstance(dtToday.year(), dtToday.month(), dtToday.day(), 1, 0, 0);
		dtNextRun = dtNextRun.addDays(1);
		
		String ss = String.valueOf(dtNextRun.second());
		String mm = String.valueOf(dtNextRun.minute());
		String hh = String.valueOf(dtNextRun.hour());
		String d = String.valueOf(dtNextRun.day());
		String m = String.valueOf(dtNextRun.month());
		String y = String.valueOf(dtNextRun.year());
		
		String jobName = 'TEST Batch: ' + dtNextRun.formatLong();
		String ScheduleParam = '00' + ' ' + mm + ' ' + hh + ' ' + d + ' ' + m + ' ? ' + y;
		
		//Start Scheduled Job
		String jobId = System.schedule(jobName, ScheduleParam, new P7S1_BatchAccountTeamMember());
		
		//Get the information from the CronTrigger API object
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
		
		// Verify the expressions are the same
		System.assertEquals(ScheduleParam, ct.CronExpression);
		
		// Verify the job has not run
		System.assertEquals(0, ct.TimesTriggered);
		
		Test.stopTest();
	}
	
	
    /*********************
    test HELPER EXECUTE
    */
    static testMethod void testBatchMethod_Execute() {    	  	    	
    	createTestData();
    	//-------------------------
		Test.startTest(); 
        		
		P7S1_BatchAccountTeamMemberHelper batchHelper = new P7S1_BatchAccountTeamMemberHelper();
				
		//EXECUTE
		batchHelper.Batch_Execute(lstAccount);
		
		Test.stopTest();



	}
	    
	
	/*********************
	test HELPER FINISH 
	*/
    static testMethod void testBatchMethod_Finish() {      	
		Test.startTest();
        		
		//FINISH
		P7S1_BatchAccountTeamMemberHelper batchHelper = new P7S1_BatchAccountTeamMemberHelper();		
		batchHelper.Batch_Finish();	
		
		Test.stopTest();
	} 
    
	
    /*---------------------------------
    Create Test Data
    ---------------------------------*/
    private static void createTestData(){
		AccAgentur = cls_P7S1_TestData.createTestAccount(false);
		accAgentur.SomTv_Accounttypen__c = 'Agentur';
		insert accAgentur;

		AccAgentur2 = cls_P7S1_TestData.createTestAccount(false);
		AccAgentur2.SomTv_Accounttypen__c = 'Agentur';
		AccAgentur2.Name = 'Agentur 2';
		insert AccAgentur2;

        AccKunde = cls_P7S1_TestData.createTestAccount(true);  

        KaB = new SomTv_KundeAgenturBeziehung__c();
        KaB.Kunde__c = AccKunde.id;
        KaB.Agentur__c = AccAgentur.id;
        Kab.SomTv_RelevanteBeziehung__c = true;
        Kab.GueltigVon__c =system.today()-2;
        Kab.GueltigBis__c =system.today()+2;
        insert Kab;

        KaB2 = new SomTv_KundeAgenturBeziehung__c();
        KaB2.Kunde__c = AccKunde.id;
        KaB2.Agentur__c = AccAgentur2.id;
        KaB2.SomTv_RelevanteBeziehung__c = false;
        KaB2.GueltigVon__c =system.today()-2;
        KaB2.GueltigBis__c =system.today()+2;
        insert KaB2;
        
        List<SomTv_Verkaeuferzuordnung__c> vkzList = new List<SomTv_Verkaeuferzuordnung__c>();
        SomTv_Verkaeuferzuordnung__c vz = new SomTv_Verkaeuferzuordnung__c();
		vz.SomTv_KdAgenturBeziehung__c = KaB.Id;
		vz.SomTv_Verkaeufer__c = Userinfo.GetUserID();
		vz.SomTv_GueltigVon__c = system.today()-2;
		vz.SomTv_GueltigBis__c = system.today()+2;
		vz.SomTv_Verkaeuferrolle__c = 'TV_Kundenverkäufer';
		vkzList.add(vz);
		
		vz = new SomTv_Verkaeuferzuordnung__c();
		vz.SomTv_KdAgenturBeziehung__c = KaB.Id;
		vz.SomTv_Verkaeufer__c = Userinfo.GetUserID();
		vz.SomTv_GueltigVon__c = system.today()-2;
		vz.SomTv_GueltigBis__c = system.today()+2;
		vz.SomTv_Verkaeuferrolle__c = 'TV_Einkaufsagenturverkäufer';
		vkzList.add(vz);
		
		vz = new SomTv_Verkaeuferzuordnung__c();
		vz.SomTv_KdAgenturBeziehung__c = KaB.Id;
		vz.SomTv_Verkaeufer__c = Userinfo.GetUserID();
		vz.SomTv_GueltigVon__c = system.today()-2;
		vz.SomTv_GueltigBis__c = system.today()+2;
		vz.SomTv_Verkaeuferrolle__c = 'TV_Planungsagenturverkäufer';
		vkzList.add(vz);	

		vz = new SomTv_Verkaeuferzuordnung__c();
		vz.SomTv_KdAgenturBeziehung__c = KaB2.Id;
		vz.SomTv_Verkaeufer__c = Userinfo.GetUserID();
		vz.SomTv_GueltigVon__c = system.today()-2;
		vz.SomTv_GueltigBis__c = system.today()+2;
		vz.SomTv_Verkaeuferrolle__c = 'TV_Kundenverkäufer';
		vkzList.add(vz);
		
		vz = new SomTv_Verkaeuferzuordnung__c();
		vz.SomTv_KdAgenturBeziehung__c = KaB2.Id;
		vz.SomTv_Verkaeufer__c = Userinfo.GetUserID();
		vz.SomTv_GueltigVon__c = system.today()-2;
		vz.SomTv_GueltigBis__c = system.today()+2;
		vz.SomTv_Verkaeuferrolle__c = 'TV_Einkaufsagenturverkäufer';
		vkzList.add(vz);
		
		vz = new SomTv_Verkaeuferzuordnung__c();
		vz.SomTv_KdAgenturBeziehung__c = KaB2.Id;
		vz.SomTv_Verkaeufer__c = Userinfo.GetUserID();
		vz.SomTv_GueltigVon__c = system.today()-2;
		vz.SomTv_GueltigBis__c = system.today()+2;
		vz.SomTv_Verkaeuferrolle__c = 'TV_Planungsagenturverkäufer';
		vkzList.add(vz);

		insert vkzList;
           	  
    }
}