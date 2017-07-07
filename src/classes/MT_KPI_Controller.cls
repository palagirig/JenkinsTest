/************************************************************************************************************
Name:       MT_KPI_Controller
======================================================
Purpose:    Controller for all MT_KPI vf pages
======================================================
History
-------
Date        AUTHOR                      DETAIL
19.01.2017  Duc Nguyen Tien             Initial architecture & development
15.02.2017  Falco Aulitzky              Updated tvBlock and istBlock to finalize the functionality
*************************************************************************************************************/
public with sharing class MT_KPI_Controller {

  private final sObject mysObject;
  private Schema.SObjectType objType;
  public ContextObjectWrapper context { get; set; }

  public MT_KPI_Controller(ApexPages.StandardController stdController) {
    this.mysObject = (sObject) stdController.getRecord();
    this.objType = this.mysObject.getSobjectType();

    if (this.objType == MT_MediaCampaign__c.SobjectType) {
      context = new MT_KPI_Global_ConsoleComp(this.mysObject);
    }
  }

  public void init(Schema.SobjectType objType) {
  }

  public abstract class ContextObjectWrapper {
    public Map<String, Object> var { get; set; }
    abstract void init();
  }

  public class MT_KPI_Global_ConsoleComp extends ContextObjectWrapper {
    public MT_MediaCampaign__c mCamp;

    public MT_KPI_Global_ConsoleComp(Sobject obj) {
      this.mCamp = (MT_MediaCampaign__c) obj;

      var = new Map<String, Object>();

      init();
    }

    public override void init() {
      load_BMV_TV_SOLL();
      calculatedProgressBar();
    }

    public void load_BMV_TV_SOLL() {
      List<MT_MediaBuildingBlock__c> blocks = new MT_MediaBuildingBlockSelector().getTVRecordsByMediaCampaignIds(new Set<Id>{
        this.mCamp.Id
      }, new Set<String>{
        'MT_MediaCampaign_BMV__c', 'MT_SumBMVMonthlyPlan__c', 'MT_Amount__c'
      });

      MT_MediaBuildingBlock__c tvBlock;

      if (blocks.isEmpty()) {
        tvBlock = new MT_MediaBuildingBlock__c();
      } else {
        tvBlock = blocks.get(0);
      }

      var.put('tvBlock', tvBlock);
    }

    public void calculatedProgressBar() {
      MT_MediaBuildingBlock__c tvBlock = (MT_MediaBuildingBlock__c) var.get('tvBlock');

      Double d = Math.min(tvBlock.MT_SumBMVMonthlyPlan__c == 0 ? 0 : tvBlock.MT_SumBMVMonthlyPlan__c / tvBlock.MT_MediaCampaign_BMV__c, 1);
      var.put('progressBarPercentage', d * 100);
    }
  }
}