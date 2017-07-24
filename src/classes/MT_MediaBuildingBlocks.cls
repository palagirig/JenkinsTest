/************************************************************************************************************
Name:  		MT_MediaBuildingBlocks
======================================================
Purpose: 	Domain class for MT_MediaBuildingBlock__c object
======================================================
History
-------
Date		AUTHOR						DETAIL
17.11.2016	Duc Nguyen Tien             Initial architecture & development
23.01.2017  Duc Nguyen Tien             Update the media building block structure
*************************************************************************************************************/
public with sharing class MT_MediaBuildingBlocks {
  private List<MT_MediaBuildingBlock__c> scope;

  public MT_MediaBuildingBlocks(List<MT_mediaBuildingBlock__c> scope) {
    this.scope = scope;
  }

  public static MT_MediaBuildingBlock__c create(MT_MediaCampaign__c mc, String type) {
    return new MT_MediaBuildingBlock__c(
      MT_MediaCampaign_ref__c = mc.Id,
      MT_Type__c = type
    );
  }

  public class MT_MediaBuildingBlocksException extends Exception {
  }
}