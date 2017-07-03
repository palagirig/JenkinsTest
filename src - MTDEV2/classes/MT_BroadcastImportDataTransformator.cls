/**
 * Transform all entries in the MT_MediaBroadcastImportData__c to MT_MediaBroadcastData__c, log errors in MT_MediaBroadcastImportError__c
 */
public with sharing class MT_BroadcastImportDataTransformator implements Database.Batchable<sObject>, Database.Stateful {
  public List<String> loggedErrors;
  public Integer insertedRecords;
  public Integer updatedRecords;
  public Integer unchangedRecords;
  public Integer failedRecords;
  public Integer processedRecords;

  private final String baseUrl;

  /**
   * Initialize this instance.
   */
  public MT_BroadcastImportDataTransformator() {
    loggedErrors = new List<String>();
    insertedRecords = 0;
    updatedRecords = 0;
    unchangedRecords = 0;
    failedRecords = 0;
    processedRecords = 0;

    baseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/console#%2F';
  }

  /**
   * Query the affected records for transformation
   *
   * @param Database.BatchableContext bc The execution context
   *
   * @return Database.QueryLocator
   */
  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator('SELECT ID, MT_CampaignID__c, MT_ProSaOrderID__c, MT_Month__c, MT_OrderType__c, MT_SenderNumber__c, MT_SenderName__c, MT_Timeslot__c, MT_LastExport__c, MT_MB1__c, MT_MB3__c, MT_MN3__c FROM MT_MediaBroadcastImportData__c ORDER BY Name ASC');
  }

  /**
   * Execute the actual transformation on a chunk of the records.
   *
   * @param Database.BatchableContext bc The execution context
   * @param List<sObject> scope The records to transform
   */
  public void execute(Database.BatchableContext bc, List<sObject> scope) {
    try {
      doExecute(bc, scope);
    } catch (Exception e) {
      system.debug(e);
      loggedErrors.add('Eine Ausnahme ist aufgetreten:\n' + e.getMessage());
      throw e;
    }
  }

  /**
   * Send out the status email for the run.
   *
   * @param Database.BatchableContext info
   */
  public void finish(Database.BatchableContext info) {
    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

    message.setSaveAsActivity(false);
    message.setTargetObjectId(UserInfo.getUserId());

    message.setSubject('Transformation der Ausstrahlungsimportdaten - Ergebnis');

    String body = 'Die Transformation der Ausstrahlungsimportdaten wurde mit folgendem Ergebnis beendet:\n';
    body += '\n';
    body += 'Anzahl der verarbeiteten Datensätze: ' + processedRecords + '\n';
    body += 'Neu angelegte Ausstrahlungsdatensätze: ' + insertedRecords + '\n';
    body += 'Aktualisierte Ausstrahlungsdatensätze: ' + updatedRecords + '\n';
    body += 'Nicht geänderte Ausstrahlungsdatensätze: ' + unchangedRecords + '\n';
    body += 'Aufgetretene Fehler: ' + failedRecords + '\n';
    body += '\n';

    if (!loggedErrors.isEmpty()) {
      body += '- ' + String.join(loggedErrors, '\n- ') + '\n';
      body += '\n';
    }

    if (failedRecords > 0) {
      try {
        Report r = [SELECT Id FROM Report WHERE Name = 'MT Broadcast Import Errors' LIMIT 1];
        body += 'Fehlerbericht ansehen: ' + baseUrl + r.Id + '\n';
      } catch (Exception e) {
        body += 'Der Bericht "MT Broadcast Import Errors" ist in dieser Instanz nicht verfügbar.\n';
      }
      body += '\n';
    }

    message.setPlainTextBody(body);
    message.setTreatBodiesAsTemplate(false);

    Messaging.SendEmailResult[] results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{
      message
    });
  }

  private void doExecute(Database.BatchableContext bc, List<sObject> scope) {
    /* track errors and processed records */
    List<MT_MediaBroadcastImportError__c> errors = new List<MT_MediaBroadcastImportError__c>();
    List<MT_MediaBroadcastImportData__c> processedImportRecords = new List<MT_MediaBroadcastImportData__c>();

    /* extract the affected prosa order ids and months, prepare the combination keys for the import data */
    Map<String, List<Id>> importRecordIdsByProSaOrderId = new Map<String, List<Id>>();
    Map<String, Date> affectedMonths = new Map<String, Date>();
    Map<String, MT_MediaBroadcastImportData__c> importRecordsByKey = new Map<String, MT_MediaBroadcastImportData__c>();

    for (sObject record : scope) {
      MT_MediaBroadcastImportData__c importRecord = (MT_MediaBroadcastImportData__c) record;

      String monthKey = importRecord.MT_Month__c.year() + '-' + importRecord.MT_Month__c.month();
      if (!affectedMonths.containsKey(monthKey)) {
        affectedMonths.put(monthKey, Date.newInstance(importRecord.MT_Month__c.year(), importRecord.MT_Month__c.month(), 1));
      }

      String bcdKey = importRecord.MT_ProSaOrderID__c + '-' + monthKey + '-' + importRecord.MT_SenderNumber__c + '-' + importRecord.MT_Timeslot__c;

      if (importRecordsByKey.containsKey(bcdKey)) {
        logError(importRecordsByKey.get(bcdKey), Label.MT_BC_ImportDataTransformator_ERROR_NewerRecordFound, errors, null);
      }

      importRecordsByKey.put(bcdKey, importRecord);

      String proSaOrderId = importRecord.MT_ProSaOrderID__c;

      if (!importRecordIdsByProSaOrderId.containsKey(proSaOrderId)) {
        importRecordIdsByProSaOrderId.put(proSaOrderId, new List<Id>());
      }

      importRecordIdsByProSaOrderId.get(proSaOrderId).add(importRecord.Id);
    }

    /* load all affected prosa orders */
    Map<Id, MT_ProSaOrder__c> orders = new Map<Id, MT_ProSaOrder__c>([SELECT Id, MT_OrderNumber__c, MT_MediaCampaign_ref__c, MT_MediaCampaign_ref__r.MT_KRSID__c, MT_MediaCampaign_ref__r.MT_MediaCampaignType_ref__r.MT_BMV_SourceField__c FROM MT_ProSaOrder__c WHERE MT_OrderNumber__c IN :importRecordIdsByProSaOrderId.keySet()]);

    /* track the orders for each campaign */
    Map<Id, List<Id>> proSaOrderIdsByCampaignId = new Map<Id, List<Id>>();

    /* map the order number to the order ids */
    Map<String, Id> proSaOrderIdsByOrderNumber = new Map<String, Id>();

    for (MT_ProSaOrder__c order : orders.values()) {
      proSaOrderIdsByOrderNumber.put(order.MT_OrderNumber__c, order.Id);

      if (!proSaOrderIdsByCampaignId.containsKey(order.MT_MediaCampaign_ref__c)) {
        proSaOrderIdsByCampaignId.put(order.MT_MediaCampaign_ref__c, new List<Id>());
      }

      proSaOrderIdsByCampaignId.get(order.MT_MediaCampaign_ref__c).add(order.Id);
    }

    /* and all monthly plans */
    List<MT_MediaBuildingBlockMonthlyPlan__c> plans = [SELECT Id, MT_PlanningDate__c, MT_MediaBuildingBlock_ref__r.MT_MediaCampaign_ref__c FROM MT_MediaBuildingBlockMonthlyPlan__c WHERE MT_PlanningDate__c IN :affectedMonths.values() AND MT_MediaBuildingBlock_ref__r.MT_MediaCampaign_ref__c IN :proSaOrderIdsByCampaignId.keySet()];

    System.debug('Found ' + plans.size() + ' monthly plans to add broadcast data for');
    System.debug(plans);

    List<Id> monthlyPlanIds = new List<Id>();

    /* track the available monthly plans for each order, this may relate one monthly plan to multiple orders */
    Map<Id, Map<String, Id>> monthlyPlanIdsByProSaOrderId = new Map<Id, Map<String, Id>>();

    for (MT_MediaBuildingBlockMonthlyPlan__c plan : plans) {
      monthlyPlanIds.add(plan.Id);

      String monthKey = plan.MT_PlanningDate__c.year() + '-' + plan.MT_PlanningDate__c.month();
      Id campaignId = plan.MT_MediaBuildingBlock_ref__r.MT_MediaCampaign_ref__c;

      for (Id orderId : proSaOrderIdsByCampaignId.get(campaignId)) {
        if (!monthlyPlanIdsByProSaOrderId.containsKey(orderId)) {
          monthlyPlanIdsByProSaOrderId.put(orderId, new Map<String, Id>());
        }

        monthlyPlanIdsByProSaOrderId.get(orderId).put(monthKey, plan.Id);
      }
    }

    List<MT_MediaBroadcastData__c> existingBroadcastData = [SELECT Id, MT_ProSaOrder_ref__c, MT_ProSaOrder_ref__r.MT_OrderNumber__c, MT_MonthlyPlan_ref__c, MT_MonthlyPlan_ref__r.MT_Year__c, MT_MonthlyPlan_ref__r.MT_Month__c, MT_BMV__c, MT_MN3__c, MT_TvSenderNumber__c, MT_Timeslot__c, MT_LastImportDate__c FROM MT_MediaBroadcastData__c WHERE MT_MonthlyPlan_ref__c IN :monthlyPlanIds];
    List<MT_MediaBroadcastData__c> updBroadcastData = new List<MT_MediaBroadcastData__c>();

    /* update the existing broadcast data records, remove the found ones from import records */
    for (MT_MediaBroadcastData__c bcd : existingBroadcastData) {
      String bcdKey = bcd.MT_ProSaOrder_ref__r.MT_OrderNumber__c + '-' + bcd.MT_MonthlyPlan_ref__r.MT_Year__c + '-' + bcd.MT_MonthlyPlan_ref__r.MT_Month__c + '-' + String.valueOf(bcd.MT_TvSenderNumber__c) + '-' + bcd.MT_Timeslot__c;

      if (importRecordsByKey.containsKey(bcdKey)) {
        MT_MediaBroadcastImportData__c importData = importRecordsByKey.get(bcdKey);

        String sourceField = orders.get(proSaOrderIdsByOrderNumber.get(importData.MT_ProSaOrderID__c)).MT_MediaCampaign_ref__r.MT_MediaCampaignType_ref__r.MT_BMV_SourceField__c;
        Decimal newBrutVolume = sourceField == 'MB1' ? importData.MT_MB1__c : importData.MT_MB3__c;

        if (bcd.MT_BMV__c != newBrutVolume || bcd.MT_MN3__c != importData.MT_MN3__c || bcd.MT_LastImportDate__c != importData.MT_LastExport__c) {
          bcd.MT_MN3__c = importData.MT_MN3__c;
          bcd.MT_BMV__c = newBrutVolume;
          bcd.MT_LastImportDate__c = importData.MT_LastExport__c;
          updBroadcastData.add(bcd);
        } else {
          unchangedRecords++;
        }

        processedImportRecords.add(importData);
        importRecordsByKey.remove(bcdKey);
      }
    }

    /* the remaining import records must be new, search for the prosa order and monthly plan */
    List<MT_MediaBroadcastData__c> insBroadcastData = new List<MT_MediaBroadcastData__c>();
    for (String bcdKey : importRecordsByKey.keySet()) {
      MT_MediaBroadcastImportData__c importData = importRecordsByKey.get(bcdKey);

      if (!proSaOrderIdsByOrderNumber.containsKey(importData.MT_ProSaOrderID__c)) {
        logError(importData, Label.MT_BC_ImportDataTransformator_ERROR_NoProSaOrderFound, errors, processedImportRecords);
        continue;
      }

      Id orderId = proSaOrderIdsByOrderNumber.get(importData.MT_ProSaOrderID__c);
      MT_ProSaOrder__c order = orders.get(orderId);

      if (order.MT_MediaCampaign_ref__r.MT_KRSID__c != importData.MT_CampaignID__c) {
        logError(importData, Label.MT_BC_ImportDataTransformator_ERROR_ProSaOrderCampaignMismatch, order.MT_MediaCampaign_ref__r, order, errors, processedImportRecords);
        continue;
      }

      String monthKey = importData.MT_Month__c.year() + '-' + importData.MT_Month__c.month();
      if (!monthlyPlanIdsByProSaOrderId.get(orderId).containsKey(monthKey)) {
        logError(importData, Label.MT_BC_ImportDataTransformator_ERROR_MonthOutsideContractRuntime, order.MT_MediaCampaign_ref__r, order, errors, processedImportRecords);
        continue;
      }

      String sourceField = order.MT_MediaCampaign_ref__r.MT_MediaCampaignType_ref__r.MT_BMV_SourceField__c;
      Decimal brutVolume = sourceField == 'MB1' ? importData.MT_MB1__c : importData.MT_MB3__c;

      insBroadcastData.add(new MT_MediaBroadcastData__c(
        MT_MonthlyPlan_ref__c = monthlyPlanIdsByProSaOrderId.get(orderId).get(monthKey),
        MT_ProSaOrder_ref__c = proSaOrderIdsByOrderNumber.get(importData.MT_ProSaOrderID__c),
        MT_TvSenderNumber__c = Decimal.valueOf(importData.MT_SenderNumber__c),
        MT_BMV__c = brutVolume,
        MT_MN3__c = importData.MT_MN3__c,
        MT_Timeslot__c = importData.MT_Timeslot__c,
        MT_TvSenderName__c = importData.MT_SenderName__c,
        MT_LastImportDate__c = importData.MT_LastExport__c
      ));

      processedImportRecords.add(importData);
    }

    if (!updBroadcastData.isEmpty()) {
      updatedRecords += updBroadcastData.size();
      update updBroadcastData;
    }

    if (!insBroadcastData.isEmpty()) {
      insertedRecords += insBroadcastData.size();
      insert insBroadcastData;
    }

    if (!processedImportRecords.isEmpty()) {
      processedRecords += processedImportRecords.size();
      delete processedImportRecords;
    }

    if (!errors.isEmpty()) {
      failedRecords += errors.size();
      insert errors;

      for (MT_MediaBroadcastImportError__c error : errors) {
        loggedErrors.add(baseUrl + error.Id + '\t' + error.MT_ProSaOrderID__c + '\t' + error.MT_CampaignID__c + '\t' + error.MT_Error__c);
      }
    }
  }

  private void logError(MT_MediaBroadcastImportData__c affected, String errorMessage, List<MT_MediaBroadcastImportError__c> errors, List<MT_MediaBroadcastImportData__c> processedImportRecords) {
    logError(affected, errorMessage, null, null, errors, processedImportRecords);
  }

  private void logError(MT_MediaBroadcastImportData__c affected, String errorMessage, MT_MediaCampaign__c campaign, MT_ProSaOrder__c order, List<MT_MediaBroadcastImportError__c> errors, List<MT_MediaBroadcastImportData__c> processedImportRecords) {
    errors.add(new MT_MediaBroadcastImportError__c(
      MT_CampaignID__c = affected.MT_CampaignID__c,
      MT_Error__c = errorMessage,
      MT_LastExport__c = affected.MT_LastExport__c,
      MT_MB1__c = affected.MT_MB1__c,
      MT_MB3__c = affected.MT_MB3__c,
      MT_MN3__c = affected.MT_MN3__c,
      MT_Month__c = affected.MT_Month__c,
      MT_OrderType__c = affected.MT_OrderType__c,
      MT_ProSaOrderID__c = affected.MT_ProSaOrderID__c,
      MT_SenderName__c = affected.MT_SenderName__c,
      MT_SenderNumber__c = affected.MT_SenderNumber__c,
      MT_Timeslot__c = affected.MT_Timeslot__c,
      MT_MediaCampaign_ref__c = campaign != null ? campaign.Id : null,
      MT_ProSaOrder_ref__c = order != null ? order.Id : null
    ));

    if (processedImportRecords != null) {
      processedImportRecords.add(affected);
    }
  }
}