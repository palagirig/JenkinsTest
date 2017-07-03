@isTest
public class P7S1_ExternalID_DebNrSync_Test {
    
    @TestSetup
    public static void testSetup(){
        cls_P7S1_TestData.createTestAccount(true);
    }

    @isTest
    public static void test_syncDebNrOnInsert(){
        Account oneAcc = [SELECT ID, SomDig_DebitorennrBarter__c, SomDig_Debitorennr__c FROM Account LIMIT 1];
        P7S1_ExternalId__c oneExtId = cls_P7S1_TestData.createTestExternalId(false, oneAcc);
        oneExtId.P7S1_Source__c = 'Debitorennr BK 29 - Barter';      
        
        Test.startTest();
        insert oneExtId;
        Test.stopTest();
        
        Account uptAcc = [SELECT ID, SomDig_DebitorennrBarter__c, SomDig_Debitorennr__c FROM Account LIMIT 1];
        System.assert(uptAcc.SomDig_DebitorennrBarter__c.contains(oneExtId.Name), 'Expected Value: '+oneExtId.Name+' , Existing Value: '+uptAcc.SomDig_DebitorennrBarter__c);
    }
    
    @isTest
    public static void test_syncDebNrOnInsert_negative(){
        delete [SELECT Id, Name, P7S1_Source__c FROM P7S1_ExternalId__c];
        
        Account oneAcc = [SELECT ID, SomDig_DebitorennrBarter__c, SomDig_Debitorennr__c FROM Account LIMIT 1];
        P7S1_ExternalId__c oneExtId = cls_P7S1_TestData.createTestExternalId(false, oneAcc);
        oneExtId.P7S1_Source__c = 'Nielsen-ID';      
        
        Test.startTest();
        insert oneExtId;
        Test.stopTest();
        
        Account uptAcc = [SELECT ID, SomDig_DebitorennrBarter__c, SomDig_Debitorennr__c FROM Account LIMIT 1];
        System.assert(uptAcc.SomDig_DebitorennrBarter__c == Null, 'Expected Value: '+null+' , Existing Value: '+uptAcc.SomDig_DebitorennrBarter__c);
        System.assert(uptAcc.SomDig_Debitorennr__c == Null, 'Expected Value: '+null+' , Existing Value: '+uptAcc.SomDig_Debitorennr__c);
    }
    
    @isTest
    public static void test_syncDebNrOnUpdate(){
        P7S1_ExternalId__c oneExtId = [SELECT Id, Name, P7S1_Source__c FROM P7S1_ExternalId__c LIMIT 1];
        oneExtId.P7S1_Source__c = 'Debitorennr BK 29 - Barter';
        
        Test.startTest();
        update oneExtId;
        Test.stopTest();
        
        Account uptAcc = [SELECT ID, SomDig_DebitorennrBarter__c, SomDig_Debitorennr__c FROM Account LIMIT 1];
        System.assert(uptAcc.SomDig_DebitorennrBarter__c.contains(oneExtId.Name), 'Expected Value: '+oneExtId.Name+' , Existing Value: '+uptAcc.SomDig_DebitorennrBarter__c);
        System.assert(uptAcc.SomDig_Debitorennr__c.contains(oneExtId.Name), 'Expected Value: '+oneExtId.Name+' , Existing Value: '+uptAcc.SomDig_Debitorennr__c);
    }
    
    @isTest
    public static void test_syncDebNrOnDelete(){
        P7S1_ExternalId__c oneExtId = [SELECT Id, Name, P7S1_Source__c FROM P7S1_ExternalId__c LIMIT 1];
        
        Test.startTest();
        delete oneExtId;
        Test.stopTest();
        
        System.assert([SELECT Id FROM P7S1_ExternalId__c].size() == 0);
        System.assert([SELECT ID, SomDig_DebitorennrBarter__c, SomDig_Debitorennr__c FROM Account LIMIT 1].SomDig_Debitorennr__c == null);
    }
    
    @isTest
    public static void test_syncDebNrOnDeleteBarter(){
        P7S1_ExternalId__c oneExtId = [SELECT Id, Name, P7S1_Source__c FROM P7S1_ExternalId__c LIMIT 1];
        oneExtId.P7S1_Source__c = 'Debitorennr BK 29 - Barter';
        update oneExtId;
        
        Test.startTest();
        delete oneExtId;
        Test.stopTest();
        
        System.assert([SELECT Id FROM P7S1_ExternalId__c].size() == 0);
        System.assert([SELECT ID, SomDig_DebitorennrBarter__c, SomDig_Debitorennr__c FROM Account LIMIT 1].SomDig_DebitorennrBarter__c == null);
    }
    
}