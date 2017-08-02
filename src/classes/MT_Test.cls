/**
 * Test utility for Media Transparency to
 * handle basic test stuff like creating
 * test data.
 *
 */
@isTest
public class MT_Test {
  @IsTest
  private static void selfTest() {
    Test.startTest();
    Init();
    Test.stopTest();

    // just validate that all DB operation went fine without any exception
  }

  public static void Init() {
    List<P7S1_OpportunityApproval__c> oppApps = initMediaCampaignPreparationTestData();

    P7S1_OpportunityApproval__c oppApp = oppApps.get(0);

    MT_MediaCampaignType__c mct = [SELECT Id
                                     FROM MT_MediaCampaignType__c
                                    WHERE MT_Type__c = :MT_Constants.getInstance().MediaCampaignType_External
                                      AND MT_IsActive__c = true
                                      AND MT_Asset_ref__c = :oppApp.MT_Asset_ref__c
                                    LIMIT 1];

    MT_MediaCampaign__c mc = MT_MediaCampaigns.create(oppApp.P7S1_Opportunity__r, oppApp, mct);
    mc.RecordTypeId = MT_MediaCampaigns.getRecordTypeIdForExternalCampaign();
    mc.MT_RunTimeTVStart__c = oppApp.MT_RunTimeTVStart__c;
    mc.MT_RunTimeTVEnd__c = oppApp.MT_RunTimeTVEnd__c;
    mc.MT_BmvTv__c = oppApp.P7S1_BmvTv__c; // WE NEED TO DEFINE THAT SPECIFICALLY AND MANUALLY IN TEST. Usually this value is prepopulated in standard UI. The trigger only handles null values but not zero values. For purpose of this test, it must be assigned manually
    mc.MT_HasMediaTV__c = true;
    insert mc;

    MT_ProSaOrder__c pso = MT_ProSaOrders.create(mc, '123334');
    insert pso;

    MT_ForecastVersion__c fver = MT_MediaForecastVersions.create('Test Version');
    insert fver;

    MT_ForecastValue__c fv = MT_MediaForecastValues.create(mct, fver);
    fv.MT_April__c = 1000;
    insert fv;

    MT_MediaFlight__c mf = MT_MediaFlights.create(
      Date.today().addMonths(-5),
      Date.today().addMonths(7),
    [SELECT Id FROM MT_MediaCampaignMonthlyPlan__c LIMIT 1]
    );
    insert mf;

    MT_AdvertisedMediaProduct__c amp = MT_AdvertisedMediaProducts.create(oppApp.P7S1_Opportunity__r.Account, 'Test Product', '12345');
    insert amp;

    MT_MediaMotive__c mm = MT_MediaMotives.create(amp, 'Test Motive');
    mm.MT_AgencyProductNumber__c = '12345';
    insert mm;

    MT_MediaFlightMotiveAllocation__c mfma = MT_MediaFlightMotiveAllocations.create(
      mf,
      mm,
      amp);
    insert mfma;

  }

  /**
   * Prepares all test data structures that are required to create Media Campaigns.
   *
   * @return created and inserted test data with references filled
   */
  public static List<P7S1_OpportunityApproval__c> initMediaCampaignPreparationTestData() {
    List<P7S1_OpportunityApproval__c> oppApprovals = initOpportunityApprovalTestData();

    MT_MediaCampaignType__c mct = MT_MediaCampaignTypes.create('Test', true, oppApprovals.get(0).MT_Asset_ref__r);
    mct.MT_Type__c = MT_Constants.getInstance().MediaCampaignType_External;
    insert mct;

    return oppApprovals;
  }

  /**
   * Initializes all the required test data structure for campaign imports.
   *
   * @return created campaign import data with all references filled
   */
  public static List<MT_CampaignImportData__c> initCampaignImportTestData() {
    List<P7S1_OpportunityApproval__c> oppApprovals = initMediaCampaignPreparationTestData();

    List<MT_CampaignImportData__c> testData = createCampaignImportTestData(oppApprovals);
    insert testData;
    return testData;
  }

  /**
   * Creates campaign import records referencing the provided opportunity
   * approvals <code>oppApprovals</code>. The records are not inserted into
   * the database.
   *
   * @param oppApprovals list of opportunity approvals
   * @return list of created but not inserted campaign import data
   */
  public static List<MT_CampaignImportData__c> createCampaignImportTestData(List<P7S1_OpportunityApproval__c> oppApprovals) {
    List<MT_CampaignImportData__c> testData = new List<MT_CampaignImportData__c>();

    // FIXME increase to 30 once 1:n relationship between oppty approval and campaign is established with MT-413
    final Integer importDataCount = 2; // = 30;
    for (Integer i = 0; i < importDataCount; i++) {
      Integer oppAppIndex = Math.mod(i, oppApprovals.size());
      MT_CampaignImportData__c rec = MT_CampaignImportData.create(i, oppApprovals.get(oppAppIndex).P7S1_Opportunity__c);
      rec.MT_CampaignName__c = 'KRS test import campaign #' + i;
      testData.add(rec);
    }

    return testData;
  }

  /**
   * Initializes all the required test data structure down to Opportunity Approvals.
   *
   * @return created and inserted test data with references filled
   */
  public static List<P7S1_OpportunityApproval__c> initOpportunityApprovalTestData() {
    Account acc = new Account(
      Name = 'Test'
    );
    insert acc;

    List<Schema.PicklistEntry> oppStagePicklistEntries = Opportunity.StageName.getDescribe().getPicklistValues();

    Opportunity opp = new Opportunity(
      Name = 'TestOpp1',
      AccountId = acc.Id,
      Account = acc,
      StageName = oppStagePicklistEntries.get(0).getValue(),
      CloseDate = Date.today().addMonths(15),
      P7S1_HasMediaTV__c = true
    );
    Opportunity opp2 = new Opportunity(
      Name = 'TestOpp2',
      AccountId = acc.Id,
      Account = acc,
      StageName = oppStagePicklistEntries.get(0).getValue(),
      CloseDate = Date.today().addMonths(15),
      P7S1_HasMediaTV__c = true
    );

    insert new List<Opportunity> { opp, opp2 };

    P7S1_Unit__c un = MT_Units.create('D&A', 'Test Unit');
    insert un;

    P7S1_Asset__c ass = MT_Assets.create(un, 'New Asset');
    insert ass;

    P7S1_OpportunityApproval__c oppApp = new P7S1_OpportunityApproval__c(
      P7S1_Opportunity__c = opp.Id,
      P7S1_Opportunity__r = opp,
      Name = 'TestOppApp',
      P7S1_BmvTv__c = 100000,
      P7S1_BmvTvCustomerIntegration__c = 30,
      P7S1_Mn3TvCustomerIntegration__c = 20,
      P7S1_TvSpotLengthCustomer__c = 10,
      P7S1_TvSpotLength__c = 30,
      MT_RunTimeTVEnd__c = Date.today().addMonths(2),
      MT_RunTimeTVStart__c = Date.today().addMonths(-2),
      P7S1_internerPartner__c = ass.Name,
      MT_Asset_ref__c = ass.Id,
      MT_Asset_ref__r = ass
    );
    P7S1_OpportunityApproval__c oppApp2 = new P7S1_OpportunityApproval__c(
      P7S1_Opportunity__c = opp2.Id,
      P7S1_Opportunity__r = opp2,
      Name = 'TestOppApp2',
      P7S1_BmvTv__c = 100000,
      P7S1_BmvTvCustomerIntegration__c = 30,
      P7S1_Mn3TvCustomerIntegration__c = 20,
      P7S1_TvSpotLengthCustomer__c = 10,
      P7S1_TvSpotLength__c = 30,
      MT_RunTimeTVEnd__c = Date.today().addMonths(2),
      MT_RunTimeTVStart__c = Date.today().addMonths(-2),
      P7S1_internerPartner__c = ass.Name,
      MT_Asset_ref__c = ass.Id,
      MT_Asset_ref__r = ass
    );

    List<P7S1_OpportunityApproval__c> oppApps = new List<P7S1_OpportunityApproval__c> { oppApp, oppApp2 };
    insert oppApps;
    return oppApps;
  }
}