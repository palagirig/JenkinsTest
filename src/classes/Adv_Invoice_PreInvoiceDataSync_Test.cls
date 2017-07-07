@isTest
public class Adv_Invoice_PreInvoiceDataSync_Test {
    
    @TestSetup
    private static void testSetup(){
        Account acc = cls_P7S1_TestData.createTestAccount(true);
        
        //ADvendio__MediaCampaign__c camp = cls_P7S1_TestData.createTestMediaCampaign(false);
        ADvendio__MediaCampaign__c camp = cls_P7S1_TestData.createTestMediaCampaign(true, acc, cls_P7S1_TestData.createTestPricelist(true));
        camp.ADvendio__Agency__c = [SELECT Id FROM Account LIMIT 1].Id;
        camp.ADvendio__Account__c = acc.id;
        update camp;
        
        ADvendio__Campaign_Item__c item = cls_P7S1_TestData.createTestCampaignItem(true, camp);   
    }
    
    @isTest
    private static void test_updateAccount(){
        Account oneAcc = [SELECT Id, Name, BillingCountry FROM Account LIMIT 1];
        //oneAcc.BillingCountry = 'Schweiz';
        oneAcc.Name = '03981';
        
        Test.startTest();
        update oneAcc;
        Test.stopTest();
        
        System.assert([SELECT Id, Name, BillingCountry FROM Account WHERE Id = :oneAcc.Id].Name == '03981');
    }
    
    @isTest
    private static void test_updateCampItem(){
        ADvendio__Campaign_Item__c oneItem = [SELECT Id, Name, ADvendio__LineDescription__c FROM ADvendio__Campaign_Item__c LIMIT 1];
        oneItem.ADvendio__LineDescription__c = 'Schweiz';
        
        Test.startTest();
        update oneItem;
        Test.stopTest();
    }
    
    @isTest
    private static void test_updateCamp(){
        ADvendio__MediaCampaign__c oneCamp = [SELECT Id, Name, ADvendio__Description__c FROM ADvendio__MediaCampaign__c LIMIT 1];
        oneCamp.ADvendio__Description__c = 'Schweiz';
        
        Test.startTest();
        update oneCamp;
        Test.stopTest();
    }
    
    @isTest
    private static void test_nullValues(){
        Test.startTest();
        	Set<Id> setItemToId = Adv_Invoice_PreInvoiceDataSync.getMediaCampaignsFromCampaignItems(null);
        	Set<Id> setAccToId = Adv_Invoice_PreInvoiceDataSync.getMediaCampaignsFromAccounts(null);
        Test.stopTest();
        
        System.assert(setItemToId == null);
		System.assert(setAccToId == null);
    }
    
    @isTest
    private static void test_specialCaseNotInMap(){
        List<Account> listAcc = [SELECT Id, SomDig_PartnerId__c, AccountNumber, ADvendio__InvoiceEmail__c, ADvendio__VATID__c, P7S1_Steuerkennzeichen__c, P7S1_Konzernmitglied__c, Name, BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity FROM Account];
        Map<Id, Account> mapAcc = new Map<Id,Account>();
        mapAcc.putAll(listAcc);
        mapAcc.remove(listAcc.get(0).Id);
        
        Test.startTest();
		Adv_Invoice_PreInvoiceDataSync.filterAccounts(listAcc, mapAcc);
        Test.stopTest();
    }
    
    @isTest
    private static void testAccountQuery(){
        Account oneAcc = [SELECT Id, Name, BillingCountry FROM Account LIMIT 1];
        Set<Id> setIds = new Set<Id>();
        setIds.add(oneAcc.Id);
        
        Test.startTest();
        Set<Id> result = Adv_Invoice_PreInvoiceDataSync.getMediaCampaignsFromAccounts(setIds);
        Test.stopTest();
        
        System.assert(result.size() == 1, 'Expected value: 1 / returned value: '+result.size());
    }

    @isTest
    private static void testAccountFieldChanges() {
        Account testAcc = new Account();
        Account testOldAcc = new Account();

        Test.startTest();

        for(Schema.SObjectField field : Adv_Invoice_PreInvoiceDataSync.accountFields) {
            testAcc.put(field, getTestValue(field));
            System.assert(Adv_Invoice_PreInvoiceDataSync.hasAccountFieldChanged(testAcc, testOldAcc), 'Error on field: '+field);
            testAcc.put(field, null);
        }

        Test.stopTest();

    }

    @isTest
    private static void testAccountFieldChangesNegative() {
        Account testAcc = new Account(NumberOfEmployees = 1);
        Account testOldAcc = new Account(NumberOfEmployees = 2);
        System.assert(!Adv_Invoice_PreInvoiceDataSync.hasAccountFieldChanged(testAcc, testOldAcc), 'Error on field: NumberOfEmployees');

    }

    public static Object getTestValue(Schema.SObjectField fieldName) {
        String fieldType = String.valueOf(fieldName.getDescribe().getType());
        if(fieldType == 'Boolean') return true;
        else if(fieldType == 'String') return 'string';
        else if(fieldType == 'Textarea') return 'Textarea';
        else if(fieldType == 'Picklist') return 'A6';
        else if(fieldType == 'Email') return 'test@prosieben.de';

        return null;
    }

}