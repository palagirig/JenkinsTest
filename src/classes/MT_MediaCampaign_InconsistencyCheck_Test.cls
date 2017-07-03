@isTest
private class MT_MediaCampaign_InconsistencyCheck_Test {
  @testSetup static void setup() {
    MT_Test.init();
  }
  testmethod static void checkConsistency() {

    P7S1_OpportunityApproval__c oppApp = [Select P7S1_BmvTv__c, ID from P7S1_OpportunityApproval__c limit 1]; // If no oppApp is returned it will throw an error. testSetup method must be adjusted
    oppApp.P7S1_ApprovalState__c = MT_Constants.getInstance().OpportunityApproval_ApprovalStatus_Submitted;
    update oppApp;
    oppApp.P7S1_ApprovalState__c = MT_Constants.getInstance().OpportunityApproval_ApprovalStatus_Approved;
    update oppApp;

    List<MT_MediaCampaign__c> mcs = [Select ID, MT_BmvTv__c, MT_RunTimeTVEnd__c from MT_MediaCampaign__c];

    system.assertEquals(1, mcs.size(), 'Not found Media Campaign for test');

    mcs.get(0).MT_RunTimeTVEnd__c = mcs.get(0).MT_RunTimeTVEnd__c.addDays(3);
    mcs.get(0).MT_BmvTv__c = mcs.get(0).MT_BmvTv__c + 1000000;
    update mcs;

    MT_MediaCampaign_InconsistencyCheckCtlr mCtrl = new MT_MediaCampaign_InconsistencyCheckCtlr(new ApexPages.StandardController(mcs.get(0)));

    mCtrl.checkConsistency();
  }
}