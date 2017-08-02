@IsTest
public with sharing class MT_BroadcastImportDataTransformator_Test {
  private static final Integer TEST_VOLUME = 4;
  private static final Integer PROSA_ORDER_NUMBER_OFFSET = 794000;
  private static final Integer DEFAULT_MB1_VALUE = 1000000;
  private static final Integer DEFAULT_MB3_VALUE = 2000000;
  private static final Integer DEFAULT_MN3_VALUE = 3000000;

  @TestSetup
  public static void setupData() {
    List<Account> accounts = new List<Account>();
    List<Opportunity> opps = new List<Opportunity>();
    List<P7S1_OpportunityApproval__c> oppApps = new List<P7S1_OpportunityApproval__c>();
    List<MT_MediaCampaign__c> campaigns = new List<MT_MediaCampaign__c>();
    List<MT_ProSaOrder__c> orders = new List<MT_ProSaOrder__c>();
    List<MT_MediaBroadcastImportData__c> imports = new List<MT_MediaBroadcastImportData__c>();

    for (Integer i = 0; i < TEST_VOLUME; i++) {
      Account a = new Account(Name = 'Test Account ' + i);
      accounts.add(a);
    }

    insert accounts;

    for (Integer i = 0; i < TEST_VOLUME; i++) {
      Opportunity o = new Opportunity(
        Name = 'Test Opp ' + i,
        StageName = 'Closed Won',
        CloseDate = System.today(),
        AccountId = accounts.get(i).Id,
        Kampagnenstart__c = Date.today().toStartOfMonth(),
        Kampagnenende__c = Date.today().toStartOfMonth().addDays(-1).addMonths(1),
        P7S1_HasMediaTV__c = true
      );

      opps.add(o);
    }

    insert opps;

    P7S1_Unit__c unit = new P7S1_Unit__c(Name = 'Test Unit');
    insert unit;

    P7S1_Asset__c asset = new P7S1_Asset__c(Name = 'Test Asset', P7S1_Unit__c = unit.Id);
    insert asset;

    for (Integer i = 0; i < TEST_VOLUME; i++) {
      P7S1_OpportunityApproval__c oa = new P7S1_OpportunityApproval__c(
        P7S1_Opportunity__c = opps.get(i).Id,
        P7S1_BmvTv__c = 1000000,
        P7S1_BmvTvCustomerIntegration__c = 500000,
        P7S1_Mn3TvCustomerIntegration__c = 250000,
        P7S1_TvSpotLength__c = 20,
        P7S1_TvSpotLengthCustomer__c = 15,
        MT_RunTimeTVStart__c = Date.today().toStartOfMonth(),
        MT_RunTimeTVEnd__c = Date.today().toStartOfMonth().addDays(-1).addMonths(1),
        P7S1_internerPartner__c = asset.Name,
        MT_Asset_ref__c = asset.Id
      );
      oppApps.add(oa);
    }

    insert oppApps;

    List<MT_MediaCampaignType__c> mct = new List<MT_MediaCampaignType__c>();

    mct.add(MT_MediaCampaignTypes.create('Test', true, asset));
    mct.get(0).MT_BMV_SourceField__c = 'MB3';
    mct.get(0).MT_Type__c = 'Internal';

    mct.add(MT_MediaCampaignTypes.create('Test2', true, asset));
    mct.get(1).MT_BMV_SourceField__c = 'MB1';
    mct.get(1).MT_Type__c = 'Internal';

    insert mct;

    RecordType campRecordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'MT_InternalMediaCampaign' LIMIT 1][0];

    for (Integer i = 0; i < TEST_VOLUME; i++) {
      MT_MediaCampaign__c c = new MT_MediaCampaign__c(
        Name = 'Test Campaign ' + i,
        MT_Opportunity_ref__c = opps.get(i).Id,
        MT_OpportunityApproval_ref__c = oppApps.get(i).Id,
        MT_MediaCampaignType_ref__c = mct.get(Math.mod(i, 2)).Id,
        MT_BmvTv__c = 1000000,
        RecordTypeId = campRecordType.Id,
        MT_KRSID__c = '0815' + i
      );
      campaigns.add(c);
    }

    insert campaigns;

    for (Integer i = 0; i < TEST_VOLUME; i++) {
      MT_ProSaOrder__c o = new MT_ProSaOrder__c(MT_OrderNumber__c = String.valueOf(PROSA_ORDER_NUMBER_OFFSET + i), MT_MediaCampaign_ref__c = campaigns.get(i).Id);
      orders.add(o);
    }

    insert orders;

    for (Integer i = 0; i < TEST_VOLUME; i++) {
      MT_MediaBroadcastImportData__c id = new MT_MediaBroadcastImportData__c(
        MT_CampaignID__c = campaigns.get(i).MT_KRSID__c,
        MT_Status__c = 'New',
        MT_Month__c = Date.today().toStartOfMonth(),
        MT_OrderType__c = 'Spot',
        MT_ProSaOrderID__c = orders.get(i).MT_OrderNumber__c,
        MT_SenderName__c = 'ProSieben',
        MT_SenderNumber__c = '1',
        MT_Timeslot__c = '1.[06-09]',
        MT_MB1__c = DEFAULT_MB1_VALUE,
        MT_MB3__c = DEFAULT_MB3_VALUE,
        MT_MN3__c = DEFAULT_MN3_VALUE,
        MT_LastExport__c = Date.today()
      );

      imports.add(id);
    }

    insert imports;
  }

  @IsTest
  public static void testInitialImport() {
    Test.startTest();

    MT_BroadcastImportDataTransformator batch = new MT_BroadcastImportDataTransformator();
    Database.executeBatch(batch);

    Test.stopTest();

    // ensure that all MT_MediaBroadcastImportData records were deleted
    System.assertEquals(0, [SELECT COUNT() FROM MT_MediaBroadcastImportData__c]);

    // ensure no errors occured
    List<MT_MediaBroadcastImportError__c> errorImports = [SELECT Id, MT_Error__c from MT_MediaBroadcastImportError__c];
    System.debug(errorImports);
    System.assert(errorImports.isEmpty(), 'Errors occurred during import.');

    // ensure that all MT_MediaBroadcastData records were created
    List<MT_MediaBroadcastData__c> imported = [SELECT Id, MT_BMV__c, MT_MN3__c FROM MT_MediaBroadcastData__c ORDER BY Name ASC];

    System.assertEquals(TEST_VOLUME, imported.size(), 'Wrong number of records were imported.');

    // ensure MB1 / MB3 selection works (it's setup with modulo 2, so even index uses MB3, odd index uses MB1)
    System.assertEquals(DEFAULT_MB3_VALUE, imported.get(0).MT_BMV__c, 'Imported record #0 has wrong BMV.');
    System.assertEquals(DEFAULT_MN3_VALUE, imported.get(0).MT_MN3__c, 'Imported record #0 has wrong MN3.');

    System.assertEquals(DEFAULT_MB1_VALUE, imported.get(1).MT_BMV__c, 'Imported record #1 has wrong BMV.');
    System.assertEquals(DEFAULT_MN3_VALUE, imported.get(1).MT_MN3__c, 'Imported record #1 has wrong MN3.');

    System.assertEquals(DEFAULT_MB3_VALUE, imported.get(2).MT_BMV__c, 'Imported record #2 has wrong BMV.');
    System.assertEquals(DEFAULT_MN3_VALUE, imported.get(2).MT_MN3__c, 'Imported record #2 has wrong MN3.');

    System.assertEquals(DEFAULT_MB1_VALUE, imported.get(3).MT_BMV__c, 'Imported record #3 has wrong BMV.');
    System.assertEquals(DEFAULT_MN3_VALUE, imported.get(3).MT_MN3__c, 'Imported record #3 has wrong MN3.');
  }

  @IsTest
  public static void testUpdateImport() {
    MT_MediaCampaign__c c = [SELECT Id FROM MT_MediaCampaign__c LIMIT 1];
    MT_MediaCampaignMonthlyPlan__c p = [SELECT Id FROM MT_MediaCampaignMonthlyPlan__c WHERE MT_MediaCampaign_ref__c = :c.Id LIMIT 1];

    MT_ProSaOrder__c o = [SELECT Id FROM MT_ProSaOrder__c WHERE MT_MediaCampaign_ref__c = :c.Id LIMIT 1];

    MT_MediaBroadcastData__c bcd = new MT_MediaBroadcastData__c(
      MT_BMV__c = DEFAULT_MB3_VALUE / 2,
      MT_MonthlyPlan_ref__c = p.Id,
      MT_TvSenderNumber__c = 1,
      MT_Timeslot__c = '1.[06-09]',
      MT_ProSaOrder_ref__c = o.Id,
      MT_TvSenderName__c = 'ProSieben'
    );

    insert bcd;

    System.assertEquals(1, [SELECT COUNT() FROM MT_MediaBroadcastData__c], 'Test data not setup correctly, invalid number of test data records.');

    MT_BroadcastImportDataTransformator batch = new MT_BroadcastImportDataTransformator();

    Test.startTest();
    Database.executeBatch(batch);
    Test.stopTest();

    System.assertEquals(0, [SELECT COUNT() FROM MT_MediaBroadcastImportData__c], 'Not all MT_MediaBroadcastImportData records were deleted');

    System.assertEquals(TEST_VOLUME, [SELECT COUNT() FROM MT_MediaBroadcastData__c], 'Not all MT_MediaBroadcastData records were created');

    bcd = [SELECT Id, MT_BMV__c FROM MT_MediaBroadcastData__c WHERE Id = :bcd.Id LIMIT 1];
    System.assertEquals(DEFAULT_MB3_VALUE, bcd.MT_BMV__c, 'Imported record has wrong BMV.');
  }

  @IsTest
  public static void testFailedImport() {
    MT_MediaCampaign__c c = [SELECT Id, MT_KRSID__c FROM MT_MediaCampaign__c LIMIT 1];
    MT_MediaCampaignMonthlyPlan__c p = [SELECT Id FROM MT_MediaCampaignMonthlyPlan__c WHERE MT_MediaCampaign_ref__c = :c.Id LIMIT 1];

    MT_ProSaOrder__c o = [SELECT Id, MT_OrderNumber__c FROM MT_ProSaOrder__c WHERE MT_MediaCampaign_ref__c = :c.Id LIMIT 1];

    List<MT_MediaBroadcastImportData__c> imports = new List<MT_MediaBroadcastImportData__c>();

    // update to an already existing import record, making the old one obsolete and throw an error
    imports.add(new MT_MediaBroadcastImportData__c(
      MT_CampaignID__c = c.MT_KRSID__c,
      MT_Status__c = 'New',
      MT_Month__c = Date.today().toStartOfMonth(),
      MT_OrderType__c = 'Spot',
      MT_ProSaOrderID__c = o.MT_OrderNumber__c,
      MT_SenderName__c = 'ProSieben',
      MT_SenderNumber__c = '1',
      MT_Timeslot__c = '1.[06-09]',
      MT_MB3__c = 1,
      MT_MN3__c = DEFAULT_MN3_VALUE,
      MT_LastExport__c = Date.today()
    ));

    // outside range
    imports.add(new MT_MediaBroadcastImportData__c(
      MT_CampaignID__c = c.MT_KRSID__c,
      MT_Status__c = 'New',
      MT_Month__c = Date.today().toStartOfMonth().addDays(-1).toStartOfMonth(),
      MT_OrderType__c = 'Spot',
      MT_ProSaOrderID__c = o.MT_OrderNumber__c,
      MT_SenderName__c = 'ProSieben',
      MT_SenderNumber__c = '1',
      MT_Timeslot__c = '1.[06-09]',
      MT_MB3__c = 2,
      MT_MN3__c = DEFAULT_MN3_VALUE,
      MT_LastExport__c = Date.today()
    ));

    // invalid prosa order number
    imports.add(new MT_MediaBroadcastImportData__c(
      MT_CampaignID__c = c.MT_KRSID__c,
      MT_Status__c = 'New',
      MT_Month__c = Date.today().toStartOfMonth(),
      MT_OrderType__c = 'Spot',
      MT_ProSaOrderID__c = String.valueOf(PROSA_ORDER_NUMBER_OFFSET - 1),
      MT_SenderName__c = 'ProSieben',
      MT_SenderNumber__c = '1',
      MT_Timeslot__c = '1.[06-09]',
      MT_MB3__c = 3,
      MT_MN3__c = DEFAULT_MN3_VALUE,
      MT_LastExport__c = Date.today()
    ));

    // invalid campaign id number
    imports.add(new MT_MediaBroadcastImportData__c(
      MT_CampaignID__c = c.MT_KRSID__c + '1',
      MT_Status__c = 'New',
      MT_Month__c = Date.today().toStartOfMonth(),
      MT_OrderType__c = 'Spot',
      MT_ProSaOrderID__c = o.MT_OrderNumber__c,
      MT_SenderName__c = 'SAT.1',
      MT_SenderNumber__c = '2',
      MT_Timeslot__c = '1.[06-09]',
      MT_MB3__c = 4,
      MT_MN3__c = DEFAULT_MN3_VALUE,
      MT_LastExport__c = Date.today()
    ));

    insert imports;

    MT_BroadcastImportDataTransformator batch = new MT_BroadcastImportDataTransformator();

    Test.startTest();
    Database.executeBatch(batch);
    Test.stopTest();

    System.assertEquals(0, [SELECT COUNT() FROM MT_MediaBroadcastImportData__c], 'not all MT_MediaBroadcastImportData records were deleted');

    // order by name (autonumber) - which is insert order
    List<MT_MediaBroadcastImportError__c> errorImports = [SELECT Id, MT_Error__c, MT_MB3__c FROM MT_MediaBroadcastImportError__c ORDER BY Name ASC];
    System.debug(errorImports);
    System.assertEquals(4, errorImports.size(), 'Unexpected number of errors occurred.');

    //* the older records will be marked as erroneous and ignored, so the basic setup entry will be affected
    System.assertEquals(DEFAULT_MB3_VALUE, errorImports.get(0).MT_MB3__c, 'Error record #0 has wrong MB3 value stored.');
    System.assertEquals(Label.MT_BC_ImportDataTransformator_ERROR_NewerRecordFound, errorImports.get(0).MT_Error__c, 'Error record #0 is logged with wrong error.');

    System.assertEquals(2, errorImports.get(1).MT_MB3__c, 'Error record #1 has wrong MB3 value stored.');
    System.assertEquals(Label.MT_BC_ImportDataTransformator_ERROR_MonthOutsideContractRuntime, errorImports.get(1).MT_Error__c, 'Error record #1 is logged with wrong error.');

    System.assertEquals(3, errorImports.get(2).MT_MB3__c, 'Error record #2 has wrong MB3 value stored.');
    System.assertEquals(Label.MT_BC_ImportDataTransformator_ERROR_NoProSaOrderFound, errorImports.get(2).MT_Error__c, 'Error record #2 is logged with wrong error.');

    System.assertEquals(4, errorImports.get(3).MT_MB3__c, 'Error record #3 has wrong MB3 value stored.');
    System.assertEquals(Label.MT_BC_ImportDataTransformator_ERROR_ProSaOrderCampaignMismatch, errorImports.get(3).MT_Error__c, 'Error record #3 is logged with wrong error.');

    // ensure that all other MT_MediaBroadcastData records were created
    System.assertEquals(TEST_VOLUME, [SELECT COUNT() FROM MT_MediaBroadcastData__c], 'Correct test data has not been transformed correctly, invalid number of transformed records.');
  }

  //  >>> BEGIN MT-564 Multiple Campaigns per ProSa Order in 2016 or earlier
  // HANDLING FOR LEGACY DATA OF 2016 OR EARLIER
  private static final Integer PROSA_ORDER_NUMBER_OFFSET_LEGACY = 694000;

  private static void setupLegacyTestData() {
    List<MT_ProSaOrder__c> orders = [SELECT MT_OrderNumber__c,
      MT_MediaCampaign_ref__r.MT_KRSID__c
    FROM MT_ProSaOrder__c];
    for (MT_ProSaOrder__c order : orders) {
      order.MT_OrderNumber__c = String.valueOf(Integer.valueOf(order.MT_OrderNumber__c) - PROSA_ORDER_NUMBER_OFFSET + PROSA_ORDER_NUMBER_OFFSET_LEGACY) + '_KRS' + order.MT_MediaCampaign_ref__r.MT_KRSID__c;
    }
    update orders;

    List<MT_MediaBroadcastImportData__c> importData = [SELECT MT_ProSaOrderID__c,
      MT_LastExport__c
    FROM MT_MediaBroadcastImportData__c];
    for (MT_MediaBroadcastImportData__c importRec : importData) {
      importRec.MT_ProSaOrderID__c = String.valueOf(Integer.valueOf(importRec.MT_ProSaOrderID__c) - PROSA_ORDER_NUMBER_OFFSET + PROSA_ORDER_NUMBER_OFFSET_LEGACY);
      importRec.MT_LastExport__c = Date.today().addYears(2017 - Date.today().year());
    }
    update importData;
  }

  @IsTest
  private static void testInitialImportWithLegacyData() {
    setupLegacyTestData();
    MT_BroadcastImportDataTransformator batch = new MT_BroadcastImportDataTransformator();

    Test.startTest();
    Database.executeBatch(batch);
    Test.stopTest();

    // ensure that all MT_MediaBroadcastImportData records were deleted
    System.assertEquals(0, [SELECT COUNT() FROM MT_MediaBroadcastImportData__c]);

    // ensure no errors occured
    List<MT_MediaBroadcastImportError__c> errorImports = [SELECT Id, MT_Error__c from MT_MediaBroadcastImportError__c];
    System.debug(errorImports);
    System.assert(errorImports.isEmpty(), 'Errors occurred during import.');

    // ensure that all MT_MediaBroadcastData records were created
    List<MT_MediaBroadcastData__c> imported = [SELECT Id, MT_BMV__c, MT_MN3__c FROM MT_MediaBroadcastData__c ORDER BY Name ASC];

    System.assertEquals(TEST_VOLUME, imported.size(), 'Wrong number of records were imported.');

    // ensure MB1 / MB3 selection works (it's setup with modulo 2, so even index uses MB3, odd index uses MB1)
    System.assertEquals(DEFAULT_MB3_VALUE, imported.get(0).MT_BMV__c, 'Imported record #0 has wrong BMV.');
    System.assertEquals(DEFAULT_MN3_VALUE, imported.get(0).MT_MN3__c, 'Imported record #0 has wrong MN3.');

    System.assertEquals(DEFAULT_MB1_VALUE, imported.get(1).MT_BMV__c, 'Imported record #1 has wrong BMV.');
    System.assertEquals(DEFAULT_MN3_VALUE, imported.get(1).MT_MN3__c, 'Imported record #1 has wrong MN3.');

    System.assertEquals(DEFAULT_MB3_VALUE, imported.get(2).MT_BMV__c, 'Imported record #2 has wrong BMV.');
    System.assertEquals(DEFAULT_MN3_VALUE, imported.get(2).MT_MN3__c, 'Imported record #2 has wrong MN3.');

    System.assertEquals(DEFAULT_MB1_VALUE, imported.get(3).MT_BMV__c, 'Imported record #3 has wrong BMV.');
    System.assertEquals(DEFAULT_MN3_VALUE, imported.get(3).MT_MN3__c, 'Imported record #3 has wrong MN3.');
  }

  @IsTest
  private static void testUpdateImportWithLegacyData() {
    setupLegacyTestData();

    MT_MediaCampaign__c c = [SELECT Id FROM MT_MediaCampaign__c LIMIT 1];
    MT_MediaCampaignMonthlyPlan__c p = [SELECT Id FROM MT_MediaCampaignMonthlyPlan__c WHERE MT_MediaCampaign_ref__c = :c.Id LIMIT 1];

    MT_ProSaOrder__c o = [SELECT Id FROM MT_ProSaOrder__c WHERE MT_MediaCampaign_ref__c = :c.Id LIMIT 1];

    MT_MediaBroadcastData__c bcd = new MT_MediaBroadcastData__c(
      MT_BMV__c = DEFAULT_MB3_VALUE / 2,
      MT_MonthlyPlan_ref__c = p.Id,
      MT_TvSenderNumber__c = 1,
      MT_Timeslot__c = '1.[06-09]',
      MT_ProSaOrder_ref__c = o.Id,
      MT_TvSenderName__c = 'ProSieben'
    );
    insert bcd;

    System.assertEquals(1, [SELECT COUNT() FROM MT_MediaBroadcastData__c], 'Test data not setup correctly, invalid number of test data records.');

    MT_BroadcastImportDataTransformator batch = new MT_BroadcastImportDataTransformator();

    Test.startTest();
    Database.executeBatch(batch);
    Test.stopTest();

    System.assertEquals(0, [SELECT COUNT() FROM MT_MediaBroadcastImportData__c], 'Not all MT_MediaBroadcastImportData records were deleted');

    System.assertEquals(TEST_VOLUME, [SELECT COUNT() FROM MT_MediaBroadcastData__c], 'Not all MT_MediaBroadcastData records were created');

    bcd = [SELECT Id, MT_BMV__c FROM MT_MediaBroadcastData__c WHERE Id = :bcd.Id LIMIT 1];
    System.assertEquals(DEFAULT_MB3_VALUE, bcd.MT_BMV__c, 'Imported record has wrong BMV.');
  }
  //  <<< END MT-564

}