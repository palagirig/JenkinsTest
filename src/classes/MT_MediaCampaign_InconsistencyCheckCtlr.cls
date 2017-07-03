/************************************************************************************************************
Name:  		MT_MediaCampaign_InconsistencyCheckCtlr
======================================================
Purpose: 	Service class for MT_MediaCampaign__c object
======================================================
History
-------
Date		AUTHOR						DETAIL
12.12.2016	Duc Nguyen Tien             Initial architecture & development
16.01.2017  Duc Nguyen Tien             Synchronisation Module refactoring update
*************************************************************************************************************/
public with sharing class MT_MediaCampaign_InconsistencyCheckCtlr {
  private ID mediaCampaignID = null;
  Map<String, MT_Config.ObjectSchemaDTO> schemas = null;
  Map<String, MT_Config.FieldSchemaDTO> mediaBlockFieldSchema = null;
  Map<String, MT_Config.FieldSchemaDTO> opportunityFieldSchema = null;
  Map<String, MT_Config.FieldSchemaDTO> opportunityApprovalFieldSchema = null;

  public MT_MediaCampaign_InconsistencyCheckCtlr(ApexPages.StandardController stdCtlr) {
    mediaCampaignID = stdCtlr.getId();
    MT_Config conf = MT_Config.getInstance().loadObjectsSchemaConf(new list<Schema.sObjectType>{
      MT_MediaCampaign__c.SobjectType, Opportunity.SobjectType, P7S1_OpportunityApproval__c.SobjectType
    });
    schemas = conf.objectsSchema;
    mediaBlockFieldSchema = schemas.get('MT_MediaCampaign__c').fieldsLabel;
    opportunityFieldSchema = schemas.get('Opportunity').fieldsLabel;
    opportunityApprovalFieldSchema = schemas.get('P7S1_OpportunityApproval__c').fieldsLabel;
  }
  public PageReference checkConsistency() {
    try {
      Set<String> mcFields = new Set<String>();
      mcFields.addAll(MT_SynchronisationModule.getTargetFields(MT_SynchronisationModule.MC, MT_SynchronisationModule.Opp));
      mcFields.addAll(MT_SynchronisationModule.getTargetFields(MT_SynchronisationModule.MC, MT_SynchronisationModule.OppApp));
      mcFields.add('MT_OpportunityApproval_ref__c');
      mcFields.add('MT_Opportunity_ref__c');
      mcFields.add('MT_Status__c');

      List<MT_MediaCampaign__c> mcs = MT_MediaCampaignService.getMediaCampaignsByIds(new Set<Id>{
        this.mediaCampaignId
      }, mcFields);
      List<Opportunity> opps = new List<Opportunity>();
      List<P7S1_OpportunityApproval__c> oppApps = new List<P7S1_OpportunityApproval__c>();

      if (!mcs.isEmpty()) {
        Set<String> oppFields = new Set<String>();
        Set<String> oppAppFields = new Set<String>();
        oppFields.addAll(MT_SynchronisationModule.getDestFields(MT_SynchronisationModule.MC, MT_SynchronisationModule.Opp));
        oppAppFields.addAll(MT_SynchronisationModule.getDestFields(MT_SynchronisationModule.MC, MT_SynchronisationModule.OppApp));

        opps = MT_OpportunityService.getRecordsByIds(new Set<Id>{
          mcs.get(0).MT_Opportunity_ref__c
        }, oppFields);
        oppApps = (List<P7S1_OpportunityApproval__c>) new MT_OpportunityApprovalSelector().getRecordsByIds(new Set<Id>{
          mcs.get(0).MT_OpportunityApproval_ref__c
        }, oppAppFields);
      }
      if (!mcs.isEmpty() && !opps.isEmpty()) {
        MT_MediaCampaign__c mc = mcs.get(0);

        Opportunity opp = opps.get(0);
        P7S1_OpportunityApproval__c oppApp = oppApps.get(0);

        Boolean isConsistent = true;

        Set<MT_SynchronisationModule.SyncItem> mappingOpp = MT_SynchronisationModule.getSyncItems(MT_SynchronisationModule.MC, MT_SynchronisationModule.Opp);
        for (MT_SynchronisationModule.SyncItem syncItem : mappingOpp) {
          if (syncItem.hasCustomSyncMapping)
            continue;
          if (mc.get(syncItem.target) != opp.get(syncItem.dest)) {
            isConsistent = false;
            system.debug('sync item ' + syncItem);
            String message = '@cfield(' + schemas.get('MT_MediaCampaign__c').label + ') value: @cvalue and @ofield(' + schemas.get('Opportunity').label + ') value: @ovalue';
            message = message.replace('@cfield', this.mediaBlockFieldSchema.get(syncItem.target).label);
            message = message.replace('@ofield', this.opportunityFieldSchema.get(syncItem.dest).label);
            message = message.replace('@cvalue', String.valueOf(mc.get(syncItem.target)));
            message = message.replace('@ovalue', String.valueOf(opp.get(syncItem.dest)));
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning, message);
            ApexPages.addMessage(myMsg);

          }
        }
        Set<MT_SynchronisationModule.SyncItem> mappingOppApp = MT_SynchronisationModule.getSyncItems(MT_SynchronisationModule.MC, MT_SynchronisationModule.OppApp);
        for (MT_SynchronisationModule.SyncItem syncItem : mappingOppApp) {
          if (syncItem.hasCustomSyncMapping)
            continue;
          if (mc.get(syncItem.target) != oppApp.get(syncItem.dest)) {
            isConsistent = false;
            String message = '@cfield (' + schemas.get('MT_MediaCampaign__c').label + ') value: @cvalue and @ofield (' + schemas.get('P7S1_OpportunityApproval__c').label + ') value: @ovalue';

            MT_Config.FieldSchemaDTO targetField = this.mediaBlockFieldSchema.get(syncItem.target);
            MT_Config.FieldSchemaDTO destField = this.opportunityApprovalFieldSchema.get(syncItem.dest);

            String targetFieldLabel = targetField != null ? targetField.label : 'UNRESOLVED FIELD: ' + syncItem.target;
            String destFieldLabel = destField != null ? destField.label : 'UNRESOLVED FIELD: ' + syncItem.dest;

            message = message.replace('@cfield', targetFieldLabel);
            message = message.replace('@ofield', destFieldLabel);

            Object mcValue = mc.get(syncItem.target);
            Object oppAppValue = oppApp.get(syncItem.dest);

            message = message.replace('@cvalue', mcValue == null ? 'null' : String.valueOf(mcValue));
            message = message.replace('@ovalue', oppAppValue == null ? 'null' : String.valueOf(oppAppValue));

            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning, message);
            ApexPages.addMessage(myMsg);

          }
        }

        if (isConsistent) {
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Campaign is consistent (Status: ' + mc.MT_Status__c + ')');
          ApexPages.addMessage(myMsg);
        }
      } else {

        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Could not query Opportunity');
        ApexPages.addMessage(myMsg);

      }
    } catch (Exception e) {
      ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Exception in line ' + e.getLineNumber() + ' occured: ' + e.getMessage());
      ApexPages.addMessage(myMsg);
    }

    return null;
  }
}