/**
* ===================================================================
* (c) factory42 GmbH 2016, Germany, All rights reserved
* P7S1_Account_SalesTeamEditor_Test
* @author:          BS / VVR factory42
* @email:           bschneider@factory42.com
* @version:         V0.1
* @date:            2016-01-27
* @last change:
* @description:    Test for Controller for VF to edit Sales-Team - NEED TO BE REFACTORED (NO ASSERTS INCLUDED)
* @objects:         Account, SomTv_KundeAgenturBeziehung__c, SomTv_Verkaeuferzuordnung__c
* =================================================================
*/
@isTest
private class P7S1_Account_SalesTeamEditor_Test {

    public static final String SALES_USER_EMAIL = 'salesuser@test.user';
    public static final String FACTORY_USER_EMAIL = 'factoryuser@test.user';

    @TestSetup
    public static void insertTestData()
    {
        List<Profile> profiles = [SELECT ID, Name FROM Profile WHERE Name in ('SomTv_Sales','SomTv_ADFactory') ORDER BY Name ASC];
        system.assertEquals(2, profiles.size());
        system.assertEquals('SomTv_ADFactory', profiles.get(0).Name);
        System.runAs(new User(Id = UserInfo.getUserId()))
        {
            User factoryUser = cls_P7S1_testData.createTestUser(false, profiles.get(0));
            factoryUser.UserName = FACTORY_USER_EMAIL;
            factoryUser.email = FACTORY_USER_EMAIL;

            User salesUser = cls_P7S1_testData.createTestUser(false, profiles.get(1));
            salesUser.UserName = SALES_USER_EMAIL;
            salesUser.email = SALES_USER_EMAIL;
            insert new List<User>{factoryUser, salesUser};
        }

        Account AccAgentur = cls_P7S1_TestData.createTestAccount(false);
        AccAgentur.name = 'Agentur';
        AccAgentur.SomTv_Accounttypen__c = 'Agentur';
        
        Account AccKunde = cls_P7S1_TestData.createTestAccount(false);
        AccKunde.name = 'Kunde';
        insert new List<Account>{AccAgentur, AccKunde};

    }

    private class TestDataContainer
    {
        public User userAf;
        public User userSales;
        public Account agentur;
        public Account kunde;

        public TestDataContainer()
        {
            List<User> users = [SELECT ID, Email FROM User WHERE email in :(new Set<String>{SALES_USER_EMAIL, FACTORY_USER_EMAIL}) ORDER BY email ASC];
            system.assertEquals(2, users.size());
            system.assertEquals(FACTORY_USER_EMAIL, users.get(0).email);
            this.userAf = users.get(0);
            this.userSales = users.get(1);

            List<Account> accounts = [SELECT ID, Name, P7S1_RelevantAgency__c FROM Account ORDER BY Name ASC];
            system.assertEquals(2, accounts.size());
            system.assertEquals('Agentur', accounts.get(0).Name);
            this.agentur = accounts.get(0);
            this.kunde = accounts.get(1);
        }
    }


    public static testMethod void testSalesTeamEditorAgentur()
    {

        TestDataContainer data = new TestDataContainer();
        Account AccKunde = data.kunde;
        Account AccAgentur = data.agentur;
        User userSales = data.userSales;
        User userAf =  data.userAf;

        AccountTeamMember ATMSales = createTestAccountTeamMember(true, AccKunde, UserSales, 'TV_Kundenverkäufer');
        AccountTeamMember ATMAf = createTestAccountTeamMember(true, AccAgentur, UserAf, 'TV_Einkaufsagenturverkäufer');

        Test.startTest();
            PageReference pageRef = Page.P7S1_Account_SalesTeamEditor;
            Test.setCurrentPage(pageRef);
            system.currentPageReference().getParameters().put('accId', AccAgentur.Id);
            P7S1_Account_SalesTeamEditorCtrl con = new P7S1_Account_SalesTeamEditorCtrl();
            //String searchTerm, String figure, String curAgency, String curCust, String curAccId, String curAccType
            P7S1_Account_SalesTeamEditorCtrl.searchUser('Tester', '0', AccAgentur.Id, AccKunde.id, AccKunde.id, 'agency');
            P7S1_Account_SalesTeamEditorCtrl.searchUser('Tester', '2', AccAgentur.Id, AccKunde.id, AccKunde.id, 'agency');
            con.checkBeforeSave();
            con.SaveNotRelevant();
        Test.stopTest();

        
    }

    public static testMethod void testSalesTeamEditorKunde(){

        TestDataContainer data = new TestDataContainer();

        Account AccAgentur = data.agentur;
        Account AccKunde = data.kunde;

        Test.startTest();
            PageReference pageRef = Page.P7S1_Account_SalesTeamEditor;
            Test.setCurrentPage(pageRef);
            system.currentPageReference().getParameters().put('accId', AccKunde.Id);
            P7S1_Account_SalesTeamEditorCtrl con = new P7S1_Account_SalesTeamEditorCtrl();
            con.lstKAB = new list<SomTv_KundeAgenturBeziehung__c>();
            con.showKAB = true;
            con.checkBeforeSave();
            con.SaveRelevant();
            con.changeAccOwner();
            con.Cancel();
            con.changeTvSalesEav();
            con.openModal();
            con.prefillKVK();
            con.prefillEavPav();
        Test.stopTest();


    }

    public static AccountTeamMember createTestAccountTeamMember(Boolean insertObject,Account account, User user, String sRole) {
        AccountTeamMember AccountTeamMember = new AccountTeamMember();
        AccountTeamMember.UserID = user.ID;
        AccountTeamMember.accountID = account.ID;
        AccountTeamMember.TeamMemberRole = sRole;
        if (insertObject)
            insert AccountTeamMember;
        return AccountTeamMember;
    }

}