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


	/***************************
	* BS 22.06.16 - Not needed anymore
	***************************
	public static String getMonthNameByDate(Date d, Boolean compact) {
		Integer month = d.month();

		if(month == 1){
			return compact ? 'Jan' : 'January';
		}
		else if(month == 2){
			return compact ? 'Feb' : 'February';
		}
		else if(month == 3){
			return compact ? 'Mar' : 'March';
		}
		else if(month == 4){
			return compact ? 'Apr' : 'April';
		}
		else if(month == 5){
			return 'May';
		}
		else if(month == 6){
			return compact ? 'Jun' : 'June';
		}
		else if(month == 7){
			return compact ? 'Jul' : 'July';
		}
		else if(month == 8){
			return compact ? 'Aug' : 'August';
		}
		else if(month == 9){
			return compact ? 'Sep' : 'September';
		}
		else if(month == 10){
			return compact ? 'Oct' : 'October';
		}
		else if(month == 11){
			return compact ? 'Nov' : 'November';
		}
		else if(month == 12){
			return compact ? 'Dec' : 'December';
		}

		return null;
	}*/


	/***************************
	* BS 22.06.16 - Not needed anymore
	***************************
	public static List<SObject> convertJSONToListOfSObject(String json) {
        Object[] values = (Object[])System.JSON.deserializeUntyped(json);

        List<SObject> newSObjectsList = new List<SObject>();
        for (Object v : values) {
            Map<String, Object> m = (Map<String, Object>) v;

            Schema.SObjectType targetType = Schema.getGlobalDescribe().get((String) m.get('sobjectType'));

            SObject o = targetType.newSObject();

            Map<String, Schema.SObjectField> fields = targetType.getDescribe().fields.getMap();
            for (String fieldName : m.keySet()) {

            	if(fieldName == 'Id' || fieldName == 'id'){
            		o.put(fieldName, m.get(fieldName));
            	}
            	else {
            		// Filter out any psuedo fields such as LastNameLocal
	                Schema.SObjectField fi = fields.get(fieldName);
	                if (fi != null) {
	                    if (fi.getDescribe().isCreateable() && fi.getDescribe().isUpdateable()) {
	                        o.put(fieldName, m.get(fieldName));
	                    }
	                }
            	}
            }

            newSObjectsList.add(o);
        }

        return newSObjectsList;
    }*/


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