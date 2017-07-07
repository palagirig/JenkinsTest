@isTest
public class SomTv_CampaignShare_SetReadOnly_Test {

    static testMethod void CampaignMember_UpdateSharingRecords() {
        Test.startTest();

        Profile profile = [select Id FROM Profile WHERE Name = 'Marketing-Benutzer' or Name = 'Marketing User'];
        User user = P7S1_CampaignMember_ReadOnlyBlock_Test.createTestUser(true, profile);

        Campaign cam;
        //system.runAs(user) {
            cam = new Campaign(Name = 'Test Campaign', Status = 'Planung');
            insert cam;
        ///}

        CampaignShare cs = new CampaignShare(CampaignID = cam.Id, CampaignAccessLevel = 'Edit', RowCause = 'Manual',
                                             UserOrGroupId = user.ID);
        insert cs;

        cam.Status = 'Abgeschlossen';
        update cam;

        CampaignShare csUpdated = [select ID, CampaignAccessLevel FROM CampaignShare WHERE ID =: cs.ID];

        System.assertEquals('Read', csUpdated.CampaignAccessLevel, 'Campaign-Trigger did not update CampaignShare record!');

        Test.stopTest();
    }
}