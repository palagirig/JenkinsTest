@isTest
public class P7S1_CampaignMember_ReadOnlyBlock_Test {

    static testMethod void CampaignMember_UpdateSharingRecords() {
        Test.startTest();

        Profile profile = [select Id FROM Profile WHERE Name = 'Marketing-Benutzer' or Name = 'Marketing User'];
        User user = createTestUser(true, profile);

        system.runAs(user) {
            Campaign cam = new Campaign(Name = 'Test Campaign', Status = 'Planung');
            insert cam;
        }

        Campaign cam = [SELECT Id FROM Campaign WHERE Name = 'Test Campaign' LIMIT 1];

        CampaignShare cs = new CampaignShare(CampaignID = cam.Id, CampaignAccessLevel = 'Edit', RowCause = 'Manual', UserOrGroupId = UserInfo.getUserID());
        insert cs;

        Contact objContact = new Contact(FirstName = 'Test-FistName', LastName = 'Test-LastName', Email = 'testmail@test.com');
        insert objContact;

        CampaignMember cm = new CampaignMember(CampaignId = cam.ID, ContactId = objContact.ID, Status = 'Sent');
        insert cm;

        Test.stopTest();
    }


    // TODO: in TestData auslagern
    public static User User_TestData;
    public static User createTestUser(Boolean insertObject, Profile profile) {
        Long rand = (Math.random()*1000000).round();
        User_TestData = new User();
        User_TestData.IsActive = true;
        User_TestData.Username = 'test' + rand + '@p7s1.net';
        User_TestData.Email = 'test' + rand + '@p7s1.net';
        User_TestData.Alias = 'tester';
        User_TestData.LastName = 'Tester';
        User_TestData.ProfileId = profile.Id;
        User_TestData.Country = 'Deutschland';
        User_TestData.EmailEncodingKey = 'UTF-8';
        User_TestData.LanguageLocaleKey = 'en_US';
        User_TestData.LocaleSidKey = 'en_US';
        User_TestData.TimeZoneSidKey = 'Europe/Berlin';
        if (insertObject) insert User_TestData;
        return User_TestData;
    }

}