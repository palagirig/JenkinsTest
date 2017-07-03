@isTest
public class P7S1_RollUpValidator_Test {

    @TestSetup
    public static void setUpDate()
    {   
        Account acc = cls_P7S1_TestData.createTestAccount(true);
        Opportunity opp = cls_P7S1_TestData.createTestOpportunity(true, acc);
        OpportunityLineItem oli = cls_P7S1_TestData.createTestOpportunityLineItem(true, opp);
        insert new P7S1_EmailRecipients__c(Name = 'P7S1 RollUpValidator', P7S1_Location__c = 'P7S1_RollUpValidator_Test', P7S1_Recipients__c = 'max@example.de;john@example.com');
    }
    
    
    @isTest
    public static void testDataStructure()
    {
        Test.startTest();
        List<OpportunityLineItem> olis = [SELECT Id, OpportunityId FROM OpportunityLineItem];
        List<Opportunity> opps = [SELECT Id, AccountId FROM Opportunity];
        List<Account> accs = [SELECT Id FROM Account];
        Test.stopTest();
        system.assertEquals(opps[0].id, olis[0].opportunityId);
        system.assertEquals(accs[0].id, opps[0].accountId);
    }
    
    @isTest
    public static void testValidRecord()
    {
        P7S1_Rollup__c validRollup = createTestRollUp(true);
        
        Test.startTest();
        P7S1_RollUpValidator.performAction();
        Integer invocations = System.Limits.getEmailInvocations();
        Test.stopTest();
        system.assertEquals(0, invocations);
    }
    
    @isTest
    public static void testInvalidParentObjectRollup()
    {
        P7S1_Rollup__c validRollup = createTestRollUp(false);
        validRollup.ParentObject__c = 'Totalrice';
        insert validRollup;
        
        Test.startTest();
        P7S1_RollUpValidator.performAction();
        Integer invocations = System.Limits.getEmailInvocations();
        Test.stopTest();
        system.assertEquals(1, invocations);
    }

    @isTest
    public static void testInvalidParentResultFieldRollup()
    {
        P7S1_Rollup__c validRollup = createTestRollUp(false);
        validRollup.ParentResultField__c = 'Totalrice';
        insert validRollup;
        
        Test.startTest();
        P7S1_RollUpValidator.performAction();
        Integer invocations = System.Limits.getEmailInvocations();
        Test.stopTest();
        system.assertEquals(1, invocations);
    }

    @isTest
    public static void testInvalidChildCalculationFieldRollup()
    {
        P7S1_Rollup__c validRollup = createTestRollUp(false);
        validRollup.ChildCalculationField__c = 'Totalrice';
        insert validRollup;
        
        Test.startTest();
        P7S1_RollUpValidator.performAction();
        Integer invocations = System.Limits.getEmailInvocations();
        Test.stopTest();
        system.assertEquals(1, invocations);
    }

    @isTest
    public static void testInvalidChildObjectRollup()
    {
        P7S1_Rollup__c validRollup = createTestRollUp(false);
        validRollup.ChildObject__c  = 'Totalrice';
        insert validRollup;
        
        Test.startTest();
        P7S1_RollUpValidator.performAction();
        Integer invocations = System.Limits.getEmailInvocations();
        Test.stopTest();
        system.assertEquals(1, invocations);
    }
    
    //TODO: Auslagern
    public static P7S1_Rollup__c createTestRollUp(Boolean insertObject)
    {
        P7S1_Rollup__c validRollup = new P7S1_Rollup__c();
        validRollup.CurrencyIsoCode = 'EUR';
        validRollup.Active__c = true;
        validRollup.Beschreibung__c = '';
        validRollup.ChildCalculationField__c = 'Totalprice';
        validRollup.ChildObject__c = 'OpportunityLineItem';
        validRollup.ParentObject__c = 'Opportunity';
        validRollup.ParentResultField__c = 'MN1__c';
        validRollup.RelationshipField__c = 'OpportunityId';
        validRollup.Type__c = '';
        validRollup.WhereCondition__c = '';
        validRollup.P7S1_BatchFilter__c = '';
        validRollup.P7S1_BatchResult__c = '';
        if(insertObject) insert validRollup;
        return validRollup;
    }
}