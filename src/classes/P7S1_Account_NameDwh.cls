/**
* This class replaces all chars which cannot be read by the DWH
*
* @author  Sebastian Listl, Jan Schweighart
* @version 0.1
* created 2016-07-12 - sli,jsc
* lastmod 2016-07-12 sli,jsc
* 
*/

/*** Removes chars DWH can't read ***/
public class P7S1_Account_NameDwh {
    public static void writeNameDwhField(Boolean isInsert, List<Account> newAccounts, Map<Id,Account> oldAccMap ){
        system.debug('### P7S1_Account_NameDwh - writeNameDwhField - isInsert : ' + isInsert);
        system.debug('### P7S1_Account_NameDwh - writeNameDwhField - newAccounts : ' + newAccounts);
        system.debug('### P7S1_Account_NameDwh - writeNameDwhField - oldAccMap : ' + oldAccMap);
        
		for (Account soActual : newAccounts) {
        	if ( isInsert || ( !isInsert && nameDwhOrNameChanged(soActual, oldAccMap) ) ) {
				system.debug('### P7S1_Account_NameDwh - writeNameDwhField - soActual.Name  : ' + soActual.Name );
                soActual.P7S1_NameDwh__c =  cls_P7S1_Utils.replaceUnsupportedCharsForDwh( soActual.Name );
            } else {
                system.debug('### P7S1_Account_NameDwh - writeNameDwhField - else ');
            }
        }
    }
	private static Boolean nameDwhOrNameChanged(Account newAccount, Map<Id,Account> oldAccMap){
    	Boolean hasChanged = false;        
        if ( oldAccMap.get(newAccount.Id).Name != newAccount.Name || newAccount.P7S1_NameDwh__c != oldAccMap.get(newAccount.Id).P7S1_NameDwh__c ){
            hasChanged = true;
        }             
        return hasChanged;
    }  
}