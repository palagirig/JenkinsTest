/**
* This Class is used by the Account.trigger to set the right VAT for the BillingCoutry in the Acocunt 
*
* @author  Sebastian Listl
* @email listl@ambuorg.de
* created 2014-10-23 -sli
* @see Account.trigger
*/
public class P7S1_Account_LandSteuerkz {
    private static List<P7S1_Country__c> countries = [Select P7S1_Abbreviation__c, Name, Name_DE__c, Alpha_3_Code__c,Alpha_2_Code__c, Name_EN__c, P7S1_Steuerkennzeichen__c FROM P7S1_Country__c LIMIT 10000]; 

	/**
	* This method looks checks the BillingCountry of a Account and writes the right VAT values to the Account 
	*
	* @param newMap Map from trigger with objects after changes
	* @param oldMap Map from trigger with objects before changes
	* @param newAccounts List of Accounts need for inserts
	*/
    public static void writeSteuerkennzeichen(Boolean isInsert, Boolean isUpdate,Map<Id, Account> newMap, Map<Id, Account> oldMap, List<Account> newAccounts){
        if (P7S1_Settings__c.getOrgDefaults().P7S1_SteuerkennzeichenSyncActive__c) {
            system.debug('### P7S1_Account_SteuerkzTrigger - writeSteuerkennzeichen - entering method');

            List<Account> accountsWithRelevantChanges  = isInsert ? newAccounts : getAccountsWithRelevantChanges(newMap, oldMap);

            for (Account account : accountsWithRelevantChanges){
                P7S1_Country__c country = getCountryByBillingCountryValue(account.BillingCountry);
                if (country != null){
                    account.P7S1_Steuerkennzeichen__c = country.P7S1_Steuerkennzeichen__c;
                    account.BillingCountry = country.P7S1_Abbreviation__c;

                    if(account.P7S1_Konzernmitglied__c && account.P7S1_Organschaft__c && account.BillingCountry == 'D') account.P7S1_Steuerkennzeichen__c = 'A6';

                } else {
                    account.BillingCountry.addError(Label.P7S1_Account_InvalidBillingCountry);
                }      
            }
        } else {
            system.debug('### P7S1_Account_SteuerkzTrigger - writeSteuerkennzeichen - sync is deactivated');
        }
    }

    /**
	* This method search for a matching Country Object with the following conditions 
	* P7S1_Abbreviation__c 
	* Name
	* Name_DE__c
	* Name_EN__c
	* Alpha_2_Code__c
	* Alpha_3_Code__c
	* @param bcValue value from the accounts billing country
	* @return Matching Conuutry Object null if no one is found
	*/
    private static P7S1_Country__c getCountryByBillingCountryValue(String bcValue){
    	P7S1_Country__c country =  null;
    	if (bcValue != null){
	    	for (P7S1_Country__c c : countries){
	    		if (bcValue == c.P7S1_Abbreviation__c || bcValue == c.Name || bcValue == c.Name_DE__c || bcValue == c.Name_EN__c || bcValue == c.Alpha_2_Code__c || bcValue == c.Alpha_3_Code__c ){
	    			country = c;
					break;	
	    		}
			}
    	}
   		return country;
    }
    
    /**
	* This method filters the incomming list for the following conditions 
	* Field BillingCountry has changed
	* Field P7S1_Steuerkennzeichen__c has changed
	* @param newMap Map from trigger with objects after changes
	* @param oldMap Map from trigger with objects before changes
	* @return filtered list of accounts
	*/
    private static List<Account> getAccountsWithRelevantChanges(Map<Id, Account> newMap, Map<Id, Account> oldMap){
        List<Account> accountsWithRelevantChanges = new List<Account>();
        for (String key : newMap.keySet()){
	            if (newMap.get(key).BillingCountry != oldMap.get(key).BillingCountry  || newMap.get(key).P7S1_Steuerkennzeichen__c != oldMap.get(key).P7S1_Steuerkennzeichen__c || newMap.get(key).P7S1_Konzernmitglied__c != oldMap.get(key).P7S1_Konzernmitglied__c || newMap.get(key).P7S1_Organschaft__c != oldMap.get(key).P7S1_Organschaft__c){
	                accountsWithRelevantChanges.add(newMap.get(key));   
	            }
        }
        return accountsWithRelevantChanges;
    }
}