/**
* ===================================================================
* (c) factory42 GmbH 2015, Germany, All rights reserved
* Ven_OppPipelineCmpCtrl
* @author       MS factory42 GmbH
* @email        mschmit@factory42.com
* @version      V0.1
* @date         2015/10/12
* @description
* @lastchange
* @objects
* =================================================================
*/
public without sharing class Ven_Utility {

	public class InputSelectOpt{
		@AuraEnabled
		public String text;

		@AuraEnabled
		public String label;

		public InputSelectOpt(String text, String label){
			this.text 	= text;
			this.label 	= label;
		}
	}

	/*****************
	*
	*****************/
	public static List<String> getPicklistValues(String objName, String fieldName){
		List<Schema.PicklistEntry> picklistEntries	= Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(fieldName).getDescribe().getPickListValues();

		List<String> picklistValues = new List<String>();

		for(Schema.PicklistEntry pe : picklistEntries){
			picklistValues.add(pe.getValue());
		}

		return picklistValues;
	}

	/*****************
	*
	*****************/
	public static List<InputSelectOpt> getInputSelectOptsByPicklistValues(String objName, String fieldName){
		List<InputSelectOpt> selects = new List<InputSelectOpt>();

		for(String picklistValue : getPicklistValues(objName, fieldName)){
			selects.add(new InputSelectOpt(picklistValue, picklistValue));
		}

		return selects;
	}

	/*****************
	* Get Picklistvalues for Verticals
	*****************/
	public static List<InputSelectOpt> getVerticalsInputSelect(){
		List<InputSelectOpt> selects = new List<InputSelectOpt>();

		for(Ven_Vertical__c vertical : [SELECT Id, Name FROM Ven_Vertical__c ORDER BY Name]){
			selects.add(new InputSelectOpt(vertical.Id, vertical.Name));
		}
		return selects;
	}

    /*****************
    * Get Picklistvalues for different Roles
    *****************/
    public static List<Ven_Utility.InputSelectOpt> getUsersByRoleNames(List<String> roleNames, Boolean alias){
        List<Ven_Utility.InputSelectOpt> users = new List<Ven_Utility.InputSelectOpt>();

        Map<Id, UserRole> roleId2Role = new Map<Id, UserRole>([ SELECT Id
                                                                FROM UserRole
                                                                WHERE DeveloperName IN :roleNames]);

        for(User u : [  SELECT Id, Firstname, Lastname, Alias
                        FROM User
                        WHERE UserRoleId IN :roleId2Role.keySet()
                            AND isactive = true]){
			if(alias){
				users.add( new Ven_Utility.InputSelectOpt(u.Id, u.Alias));
			}else{
				users.add( new Ven_Utility.InputSelectOpt(u.Id, u.Firstname + ' ' + u.Lastname));
			}
        }

        return users;
    }

    /*****************
    * Get Picklistvalues for NON-Salesforce Scouts/MediaPlanner from object Investment Team
    *****************/
    public static List<Ven_Utility.InputSelectOpt> getUsersOfInvestmentTeam(String type, String idPrefix){
    	List<Ven_Utility.InputSelectOpt> users = new List<Ven_Utility.InputSelectOpt>();

    	for(Ven_InvestTeam__c member : [SELECT Name FROM Ven_InvestTeam__c WHERE Type__c = :type]){
    		users.add(new Ven_Utility.InputSelectOpt(idPrefix + member.Name, member.Name));
    	}

    	return users;
    }

	/*****************
	*
	*****************/
	public static Id getRoleIdByName(String roleName){
		return [SELECT Id FROM UserRole WHERE DeveloperName = :roleName LIMIT 1][0].Id;
	}

  /*****************
	*
	*****************/
  public static Map<String, Schema.SObjectField> getFieldMapFromObject(String objName)
  {
    return Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
  }

  /*****************
	*
	*****************/
  public static String getFieldListFromObject(String objName)
  {
    Map<String, Schema.SObjectField> mapFields = getFieldMapFromObject(objName);

    String strFields='';

    for ( String f : mapFields.keySet() )
    {
      strFields += f;
      strFields += ',';
    }

    strFields = strFields.subString(0,strFields.Length() -1);
    return strFields;
  }

    /***************************
    * Get monthly values fro SOM Likelihood from custom setting
    ***************************/
    public static Map<Integer, Decimal> getSomLikelihoodByEffYield(Decimal effYield){
        List<Ven_SomLikelihood__c> somLikelihoods = Ven_SomLikelihood__c.getAll().values();
        Map<Integer, Decimal> mapMonth2Value = new Map<Integer, Decimal>();

        for(Ven_SomLikelihood__c slh : somLikelihoods){
            if(effYield >= slh.Ven_Min__c && effYield <= slh.Ven_Max__c){

                mapMonth2Value.put(1, slh.Ven_Jan__c);
                mapMonth2Value.put(2, slh.Ven_Feb__c);
                mapMonth2Value.put(3, slh.Ven_Mar__c);
                mapMonth2Value.put(4, slh.Ven_Apr__c);
                mapMonth2Value.put(5, slh.Ven_May__c);
                mapMonth2Value.put(6, slh.Ven_Jun__c);
                mapMonth2Value.put(7, slh.Ven_Jul__c);
                mapMonth2Value.put(8, slh.Ven_Aug__c);
                mapMonth2Value.put(9, slh.Ven_Sep__c);
                mapMonth2Value.put(10, slh.Ven_Oct__c);
                mapMonth2Value.put(11, slh.Ven_Nov__c);
                mapMonth2Value.put(12, slh.Ven_Dec__c);

	   break;
	}
        }

        return mapMonth2Value;
    }
}