/**
* Name:     MT_MediaBuildingBlockMonthlyPlanSelector
* Purpose:  Service class for MT_MediaBuildingBlockMonthlyPlan__c object
*
* History
* -------
* DATE        AUTHOR                      DETAIL
* 17.11.2016  Duc Nguyen Tien             Initial architecture and development
* 16.03.2017  Falco Aulitzky              Added missing functions
* 12.04.2017  Falco Aulitzky              Adding JavaDoc-Styled documentation
*
*/

/* Selector class to fetch data from the database */
public with sharing class MT_MediaBuildingBlockMonthlyPlanSelector extends MT_Selector {
  public static final String objectAPIName = MT_MediaBuildingBlockMonthlyPlan__c.SobjectType.getDescribe().getName();

  /*
  * Method to fetch data stored in salesforce
  *
  * @param    Set<Id>       recordIds is a set of MediaBuildingBlockMonthlyPlan ids
  *           Set<String>   fields is a set of Strings that determines which fields are queried of the MediaBuildingBlockMonthlyPlan object
  * @returns  List<SObject> a list of MediaBuildingBlockMonthlyPlan objects that are treated and stored as a generic type
  *
  */
  public List<SObject> getRecordsByIds(Set<Id> recordIds, Set<String> fields) {
    if (recordIds.isEmpty()) {
      return new List<SObject>();
    }
    String query = 'SELECT ' + constructFieldString(fields) + ' FROM ' + objectAPIName + ' where Id in ' + constructInClauseString(recordIds);
    return Database.query(query);
  }

  /*
  * Method to fetch data stored in salesforce
  *
  * @param    Set<Id>       recordIds is a set of MediaBuildingBlock ids
  *           Set<String>   fields is a set of Strings that determines which fields are queried of the MediaBuildingBlockMonthlyPlan object
  * @returns  List<SObject> a list of MediaBuildingBlockMonthlyPlan objects that are treated and stored as a generic type ordered by PlanningDate
  *
  */
  public List<SObject> getRecordsByParentIds(Set<Id> parentIds, Set<String> fields) {
    if (parentIds.isEmpty()) {
      return new List<SObject>();
    }
    String query = 'SELECT ' + constructFieldString(fields) + ' FROM ' + objectAPIName + ' where MT_MediaBuildingBlock_ref__c in ' + constructInClauseString(parentIds) + ' order by MT_PlanningDate__c asc';
    return Database.query(query);
  }

  /*
  * Method to fetch data stored in salesforce
  *
  * @param    Set<Id>       recordIds is a set of MediaTransparencyCampaign ids
  *           Set<String>   fields is a set of Strings that determines which fields are queried of the MediaBuildingBlockMonthlyPlan object
  * @returns  List<SObject> a list of MediaBuildingBlockMonthlyPlan objects that are treated and stored as a generic type with type TV and a matching MediaTransparencyCampaign id ordered by PlanningDate
  *
  */
  public List<SObject> getTVRecordsByMediaCampaignIds(Set<Id> parentIds, Set<String> fields) {
    if (parentIds.isEmpty()) {
      return new List<SObject>();
    }
    String query = 'SELECT ' + constructFieldString(fields) + ' FROM ' + objectAPIName + ' where MT_MediaBuildingBlock_ref__r.MT_Type__c = \'' + MT_Constants.getInstance().MediaBuildingBlock_Type_TV + '\' and MT_MediaBuildingBlock_ref__r.MT_MediaCampaign_ref__c in ' + constructInClauseString(parentIds) + ' order by MT_PlanningDate__c asc';
    return Database.query(query);
  }

  /*
  * Method to fetch data stored in salesforce
  *
  * @param    Set<Id>       recordIds is a set of MediaBuildingBlock ids
  *           Set<String>   fields is a set of Strings that determines which fields are queried of the MediaBuildingBlockMonthlyPlan object
  *           Set<String>   fields is a set of Strings that determines which fields are queried of the MediaFlights object
  * @returns  List<SObject> a list of MediaBuildingBlockMonthlyPlan objects that are treated and stored as a generic type with MediaFlight objects matching MediaBuildingBlock ids ordered by PlanningDate
  *
  */
  public List<SObject> getRecordsWithMediaFlightsByParentIds(Set<Id> parentIds, Set<String> planningFields, Set<String> flightFieds) {
    if (parentIds.isEmpty()) {
      return new List<SObject>();
    }
    String query = 'SELECT ' + constructFieldString(planningFields) + ', ( SELECT ' + constructFieldString(flightFieds) + ' FROM MediaFlights__r order by MT_Position__c asc) FROM ' + objectAPIName + ' where MT_MediaBuildingBlock_ref__c in ' + constructInClauseString(parentIds) + ' order by MT_PlanningDate__c asc';
    return Database.query(query);
  }
}