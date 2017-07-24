/**
 * Test utility for Media Transparency to
 * handle basic test stuff like creating
 * test data.
 *
 */
@isTest
public class MT_Test {

  private final static Id MT_MEDIACAMPAIGN_RECTYPEID_INTERNAL;
  static {
    MT_MEDIACAMPAIGN_RECTYPEID_INTERNAL = [SELECT Id
                                                 FROM RecordType
                                                WHERE SObjectType = :MT_MediaCampaignSelector.objectAPIName
                                                  AND DeveloperName = :MT_Constants.getInstance().MediaCampaign_RecordType_Internal].Id;
  }

  @isTest public static void Init() {
    Account acc = new Account(Name = 'Test');
    insert acc;

    Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
    List<Schema.PicklistEntry> ples = fieldResult.getPicklistValues();

    Opportunity opp = new Opportunity(Name = 'TestOpp1', AccountId = acc.Id, StageName = ples.get(0).getValue(), CloseDate = Date.today().addMonths(15), P7S1_HasMediaTV__c = true);
    Opportunity opp2 = new Opportunity(Name = 'TestOpp2', AccountId = acc.Id, StageName = ples.get(0).getValue(), CloseDate = Date.today().addMonths(15), P7S1_HasMediaTV__c = true);

    List<Opportunity> opps = new List<Opportunity>{
      opp, opp2
    };
    insert opps;

    P7S1_Unit__c un = MT_Units.create('D&A', 'Test Unit');
    insert un;

    P7S1_Asset__c ass = MT_Assets.create(un, 'New Asset');
    insert ass;

    P7S1_OpportunityApproval__c oppApp = new P7S1_OpportunityApproval__c(
      P7S1_Opportunity__c = opp.Id,
      Name = 'TestOppApp',
      P7S1_BmvTv__c = 100000,
      P7S1_BmvTvCustomerIntegration__c = 30,
      P7S1_Mn3TvCustomerIntegration__c = 20,
      P7S1_TvSpotLengthCustomer__c = 10,
      P7S1_TvSpotLength__c = 30,
      MT_RunTimeTVEnd__c = Date.today().addMonths(2),
      MT_RunTimeTVStart__c = Date.today().addMonths(-2),
      P7S1_internerPartner__c = ass.Name,
      MT_Asset_ref__c = ass.Id
    );
    insert oppApp;

    MT_MediaCampaignType__c mct = MT_MediaCampaignTypes.create('Test', true, ass);
    mct.MT_Type__c = 'Internal';
    insert mct;

    MT_MediaCampaign__c mc = MT_MediaCampaigns.create(opp, oppApp, mct);
    mc.RecordTypeId = MT_MEDIACAMPAIGN_RECTYPEID_INTERNAL;
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
    [SELECT Id FROM MT_MediaBuildingBlockMonthlyPlan__c LIMIT 1]
    );
    insert mf;

    MT_AdvertisedMediaProduct__c amp = MT_AdvertisedMediaProducts.create(acc, 'Test Product', '12345');
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
}
