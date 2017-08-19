@isTest
public class Adv_MediaCampaign_Storno_Test{

    @isTest
    public static void cancelMKwithCI(){

        // Create Objects
        ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(true);
        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMC);
        
        // Set Date in Future
        objCI.ADvendio__from_Date__c = System.today().addDays(30);
        objCI.ADvendio__until_Date__c = System.today().addDays(30);        
        insert objCI;

        Test.startTest();

        // Set Mediacampaign to Storno
        objMC.ADvendio__Reason_for_refusal__c = 'Cancellation';
        objMC.ADvendio__Stage__c = 'Offer denied';
        update objMC;

        Test.stopTest();

        objCI = [SELECT ADvendio__AdserverStatus__c FROM ADvendio__Campaign_Item__c WHERE ID = :objCI.Id];
        System.assertEquals('Released',objCI.ADvendio__AdserverStatus__c);

    }

    @isTest
    public static void cancelMKwithBilling(){
        User objUserBilling = [SELECT Id, IsActive, Name, P7S1_Sphere__c, ProfileId, Profile.Name, Username, SomDig_SalesTeam__c FROM User WHERE IsActive = true AND Profile.Name = 'SomDig_Billing' LIMIT 1];

        ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(false);
        objMC.ADvendio__BillMe__c = false;
        insert objMC;

        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMC);
        // Set Date in Future
        objCI.ADvendio__from_Date__c = System.today().addDays(30);
        objCI.ADvendio__until_Date__c = System.today().addDays(30); 
        objCI.ADvendio__Rate_Discount_4_Name__c = 'Storno ohne Leistungsfluss';
        insert objCI;

        objCI.ADvendio__AdserverStatus__c = '';
        update objCI;

        Test.startTest();

        objCI = [SELECT ADvendio__AdserverStatus__c FROM ADvendio__Campaign_Item__c WHERE ID = :objCI.Id];
        System.assertNotEquals('Released',objCI.ADvendio__AdserverStatus__c);

        System.runAs(objUserBilling) {
            // Set Mediacampaign to Storno
            objMC.ADvendio__Reason_for_refusal__c = 'Cancellation';
            objMC.ADvendio__Stage__c = 'Offer denied';
            update objMC;
        }

        Test.stopTest();

        objCI = [SELECT ADvendio__AdserverStatus__c FROM ADvendio__Campaign_Item__c WHERE ID = :objCI.Id];
        System.assertNotEquals('Released',objCI.ADvendio__AdserverStatus__c);

    }

    @isTest
    public static void cancelMKwithBillingAndNoStorno(){
        User objUserBilling = [SELECT Id, IsActive, Name, P7S1_Sphere__c, ProfileId, Profile.Name, Username, SomDig_SalesTeam__c FROM User WHERE IsActive = true AND Profile.Name = 'SomDig_Billing' LIMIT 1];

        ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(false);
        objMC.ADvendio__BillMe__c = false;
        insert objMC;

        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMC);
        // Set Date in Future
        objCI.ADvendio__from_Date__c = System.today().addDays(30);
        objCI.ADvendio__until_Date__c = System.today().addDays(30); 
        insert objCI;

        Test.startTest();

        objCI = [SELECT ADvendio__AdserverStatus__c FROM ADvendio__Campaign_Item__c WHERE ID = :objCI.Id];
        System.assertNotEquals('Released',objCI.ADvendio__AdserverStatus__c);

        System.runAs(objUserBilling) {
            // Set Mediacampaign to Storno
            objMC.ADvendio__Reason_for_refusal__c = 'Cancellation';
            objMC.ADvendio__Stage__c = 'Offer denied';
            update objMC;
        }

        Test.stopTest();

        objCI = [SELECT ADvendio__AdserverStatus__c FROM ADvendio__Campaign_Item__c WHERE ID = :objCI.Id];
        System.assertEquals('Released',objCI.ADvendio__AdserverStatus__c);

    }

    @isTest
    public static void cancelMKwithOldCI() {
        ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(false);
        objMC.ADvendio__BillMe__c = false;
        insert objMC;

        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMC);
        // Set Date in Future
        objCI.ADvendio__from_Date__c = System.today().addDays(-1);
        objCI.ADvendio__until_Date__c = System.today().addDays(30); 
        insert objCI;

        Test.startTest();


        // Set Mediacampaign to Storno
        objMC.ADvendio__Reason_for_refusal__c = 'Cancellation';
        objMC.ADvendio__Stage__c = 'Offer denied';

        Boolean catchedError = false;

        try {
            update objMC;
        } catch(Exception e) {
            catchedError = true;
        }

        Test.stopTest();

        System.assert(catchedError);

    }
    
}