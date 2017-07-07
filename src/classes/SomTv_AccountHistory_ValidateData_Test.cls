@isTest
public class SomTv_AccountHistory_ValidateData_Test{

  @testSetup
  public static void testSetup() {
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' OR Name='Systemadministrator' Limit 1];
    User u = new User(Username='testAZT@test.com', LastName='testAZT', 
                         Email='testAZT@test.com', Alias='test', CommunityNickname='testAZT',
                         TimeZoneSidKey='Europe/Berlin', LocaleSidKey='en_US', EmailEncodingKey='UTF-8',
                         ProfileId=p.Id, LanguageLocaleKey='en_US');
    insert u;

    Account acc1 = cls_P7S1_TestData.createTestAccount(false);
    Account acc2 = cls_P7S1_TestData.createTestAccount(false);
    acc1.Name = 'Account 1';
    acc2.Name = 'Account 2';
    insert new List<Account>{acc1,acc2};

  }

  @isTest
  public static void testGueltigVonNull() {

    User u = [SELECT Id FROM User WHERE Username = 'testAZT@test.com'];

    Boolean exceptionThrown = false;
    Account acc1 = [SELECT Id FROM Account WHERE Name = 'Account 1'];
    Account acc2 = [SELECT Id FROM Account WHERE Name = 'Account 2'];

    Test.startTest();

    System.runAs(u) {

      AccountHistory__c a1 = createTestAccountHistory(false, acc1, acc2);
      a1.GueltigVon__c = null;
                
      try {  
        insert a1;
      } catch (Exception e) {
        exceptionThrown = e.getMessage().contains('Bitte ein Startdatum für die Gültigkeit eingeben!');
      }

    }

    Test.stopTest();

    System.assert(exceptionThrown);

  }

  @isTest
  public static void testGueltigVonBiggerThanGueltigBis() {

    User u = [SELECT Id FROM User WHERE Username = 'testAZT@test.com'];

    Boolean exceptionThrown = false;
    Account acc1 = [SELECT Id FROM Account WHERE Name = 'Account 1'];
    Account acc2 = [SELECT Id FROM Account WHERE Name = 'Account 2'];

    Test.startTest();

    System.runAs(u) {

      AccountHistory__c a1 = createTestAccountHistory(false, acc1, acc2);
      
      a1.GueltigVon__c = Date.newinstance(2012, 08, 01);
      a1.GueltigBis__c = Date.newinstance(2012, 07, 01);

      try {  
        insert a1;
      } catch (Exception e) {
        exceptionThrown = e.getMessage().contains('Das Enddatum muss nach dem Startdatum sein!');
      }

    }

    Test.stopTest();

    System.assert(exceptionThrown);

  }

  @isTest
  public static void testUeberGeordneterEqualsUntergeordneter() {

    User u = [SELECT Id FROM User WHERE Username = 'testAZT@test.com'];

    Boolean exceptionThrown = false;
    Account acc1 = [SELECT Id FROM Account WHERE Name = 'Account 1'];

    Test.startTest();

    System.runAs(u) {

      AccountHistory__c a1 = createTestAccountHistory(false, acc1, acc1);

      a1.GueltigVon__c = Date.newinstance(2012, 08, 01);
      a1.GueltigBis__c = Date.newinstance(2012, 08, 31);

      try {  
        insert a1;
      } catch (Exception e) {
        exceptionThrown = e.getMessage().contains('Der übergeordnete und untergeordnete Account dürfen nicht geleich sein!');
      }

    }

    Test.stopTest();

    //2014-04-02, SOTV-28. This validation was disabled.
    System.assert(!exceptionThrown);
    
  }

  @isTest
  public static void testUndelete() {

    User u = [SELECT Id FROM User WHERE Username = 'testAZT@test.com'];

    Boolean exceptionThrown = false;
    Account acc1 = [SELECT Id FROM Account WHERE Name = 'Account 1'];
    Account acc2 = [SELECT Id FROM Account WHERE Name = 'Account 2'];
    AccountHistory__c a1 = createTestAccountHistory(false, acc1, acc2);
    a1.GueltigVon__c = Date.newinstance(2012, 08, 01);
    a1.GueltigBis__c = Date.newinstance(2012, 08, 31);
    insert a1;

    Test.startTest();

    System.runAs(u) {
      
      delete a1;
      undelete a1;

    }

    Test.stopTest();

    List<AccountHistory__c> a1check = new List<AccountHistory__c>([SELECT Id FROM AccountHistory__c]); 
    System.assertEquals(a1check.size(), 1);

  }

  @isTest
  public static void testBulkInsert() {
    User u = [SELECT Id FROM User WHERE Username = 'testAZT@test.com'];

    Boolean exceptionThrown = false;
    Account acc1 = [SELECT Id FROM Account WHERE Name = 'Account 1'];
    Account acc2 = [SELECT Id FROM Account WHERE Name = 'Account 2'];
    AccountHistory__c a1 = createTestAccountHistory(false, acc1, acc2);
    a1.GueltigVon__c = Date.newinstance(2012, 08, 01);
    a1.GueltigBis__c = Date.newinstance(2012, 08, 31);
    insert a1;

    AccountHistory__c a2 = new AccountHistory__c(GueltigVon__c = Date.newinstance(2012, 09, 01),
                                 GueltigBis__c = Date.newinstance(2012, 09, 30),
                                 UntergeordneterAccount__c = acc1.Id,
                                 UebergeordneterAccount__c = acc2.Id);

    AccountHistory__c a3 = new AccountHistory__c(GueltigVon__c = Date.newinstance(2012, 09, 01),
                           GueltigBis__c = Date.newinstance(2012, 09, 30),
                           UntergeordneterAccount__c = acc1.Id,
                           UebergeordneterAccount__c = acc2.Id);

    AccountHistory__c a4 = new AccountHistory__c(GueltigVon__c = Date.newinstance(2012, 08, 01),
                           GueltigBis__c = Date.newinstance(2012, 08, 31),
                           UntergeordneterAccount__c = acc1.Id,
                           UebergeordneterAccount__c = acc2.Id);

    List<AccountHistory__c> lst = new List<AccountHistory__c>{a2,a3,a4};
    

    Test.startTest();

    System.runAs(u) {
      
      try {
        insert lst;
      } catch(Exception e){
        exceptionThrown = e.getMessage().contains('Für den untergeordneten Account existiert bereits ein übergeordneter Account im gegebenen Zeitraum. Bitte prüfen Sie Ihre Angaben');
      }

      lst.remove(2);
      lst.remove(1);

      insert lst;    

    }

    Test.stopTest();

    System.assert(exceptionThrown);
    List<AccountHistory__c> a1a2check = new List<AccountHistory__c>([SELECT Id FROM AccountHistory__c]); 
    System.assertEquals(a1a2check.size(), 2);

  } 

   // TO DO: move to cls_P7S1_TestData
  public static AccountHistory__c createTestAccountHistory(Boolean insertObject) {
    return createTestAccountHistory(insertObject, null, null);
  }

  public static AccountHistory__c createTestAccountHistory(Boolean insertObject, Account uebergeordneterAcc, Account untergeordnetenAcc) {
    AccountHistory__c accountHistory_TestData = new AccountHistory__c();
    accountHistory_TestData.GueltigVon__c = Date.today();
    accountHistory_TestData.GueltigBis__c = Date.today().addDays(10);
    accountHistory_TestData.UebergeordneterAccount__c = (uebergeordneterAcc == null) ? cls_P7S1_TestData.createTestAccount(true).Id : uebergeordneterAcc.Id;
    accountHistory_TestData.UntergeordneterAccount__c = (untergeordnetenAcc == null) ? cls_P7S1_TestData.createTestAccount(true).Id : untergeordnetenAcc.Id;
    if(insertObject) insert accountHistory_TestData;
    return accountHistory_TestData;
  }

}