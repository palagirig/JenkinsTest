public class P7S1_Account_Rollup {
    
 
    
    public static void opportunityToAccountRollups(List<Opportunity> newOppsList, Map<Id, Opportunity> oldOppsMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isAfter) {
        Map<String, string> lastyearPlattformToAccFieldMap = new Map<String, String>{'P7MAXX' => 'SomTv_OpptiVJP7MAXX__c',
            																		 'Sixx'	  => 'SomTv_OpptiVJsixx__c',
                                                                                     'K1Doku' => 'SomTv_OpptiVJK1Doku__c',
                                                                                     'S1G'    => 'SomTv_OpptiVJSat1GOLD__c'};
                                                                                         
        Map<String, string> thisyearPlattformToAccFieldMap = new Map<String, String>{'P7MAXX' => 'SomTv_OpptiP7MAXX__c',
            																		 'Sixx'	  => 'SomTv_Opptisixx__c',
                                                                                     'K1Doku' => 'SomTv_OpptiK1Doku__c',
                                                                                     'S1G'    => 'SomTv_OpptiSat1GOLD__c'};
                                                                                         
		Set<String> oppStageNames = new Set<String>{'Geschlossene und gewonnene', 'Rabatt freigegeben', 'In Briefing', 'Angebot abgegeben'};                                                                              
		
        Integer thisYear = Date.today().year();
        Integer lastYear = Date.today().addYears(-1).year();
        
		Set<Id> parentIDs = new Set<ID>();
        
        if(isInsert && isAfter) {
            
            // on insert, always rollup.
            for(Opportunity opp : newOppsList) {
                if(oppStageNames.contains(opp.StageName))
                	parentIDs.add(opp.AccountID);
            }
            
        } else if(isUpdate && isAfter) {
            
            for(Opportunity opp : newOppsList) {
                Opportunity oldOpp = oldOppsMap.get(opp.Id);
                if(oppStageNames.contains(opp.StageName) || oppStageNames.contains(oldOpp.StageName)) {
                    if(opp.P7S1_StartdateofselectedOppYear__c.year() == thisYear || opp.P7S1_StartdateofselectedOppYear__c.year() == lastYear) {
                        parentIDs.add(opp.AccountID);
                    }
                }
            }

        } else if(isDelete && isAfter) {
            
            for (Id key : oldOppsMap.keySet()) {
                Opportunity opp = oldOppsMap.get(key);
                parentIDs.add(opp.AccountID);
            }
            
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        if(!parentIDs.isEmpty()) accountsToUpdate = new List<Account>([SELECT SomTv_OpptiVJP7MAXX__c, SomTv_OpptiVJsixx__c, SomTv_OpptiVJK1Doku__c, SomTv_OpptiVJSat1GOLD__c, SomTv_OpptiK1Doku__c, SomTv_OpptiP7MAXX__c, SomTv_OpptiSat1GOLD__c, SomTv_Opptisixx__c,
                                                                       (SELECT P7S1_MN3__c, SomTv_Plattform__c, P7S1_StartdateofselectedOppYear__c FROM Opportunities WHERE StageName IN :oppStageNames AND (P7S1_StartdateofselectedOppYear__c = THIS_YEAR OR P7S1_StartdateofselectedOppYear__c = LAST_YEAR))
                                                                       FROM Account
                                                                       WHERE Id IN :parentIDs]);
        
        // Combine this year and last year values.
        List<String> thisAndLastYearAccountFields = new List<String>();
        thisAndLastYearAccountFields.addAll(lastyearPlattformToAccFieldMap.values());
        thisAndLastYearAccountFields.addAll(thisyearPlattformToAccFieldMap.values());
        
        for(Account acc: accountsToUpdate) {
           
            // Set values to 0.
            for(String fieldName : thisAndLastYearAccountFields) {
                acc.put(fieldName, 0);
            }
            
            for(Opportunity opp : acc.Opportunities) {
                
                Integer oppYear = opp.P7S1_StartdateofselectedOppYear__c.year();
                
                if( (oppYear == thisYear || oppYear == lastYear) && (thisyearPlattformToAccFieldMap.containsKey(opp.SomTv_Plattform__c) || lastyearPlattformToAccFieldMap.containsKey(opp.SomTv_Plattform__c))) {
                    
                    String fieldName = oppYear == thisYear ? thisyearPlattformToAccFieldMap.get(opp.SomTv_Plattform__c) : lastyearPlattformToAccFieldMap.get(opp.SomTv_Plattform__c);
                	Decimal acumulatedValue = (Decimal) acc.get(fieldName);
                    Decimal oppValue = (Decimal) opp.get('P7S1_MN3__c');
                    
					acc.put(fieldName, acumulatedValue + oppValue);
                }
            }
            
        }
        
        update accountsToUpdate;
        
    }
    
    
    
    
    public static void forecastToAccountRollups(List<SomTv_ForecastTV__c> newForecastsList, Map<Id, SomTv_ForecastTV__c> oldForecastsMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isAfter) {
        System.debug('+++ forecastToAccountRollups');
        Map<String, String> forecastToAccFieldMap = new Map<String, String>{'SomTv_ForecastK1DokuMN3__c' => 'SomTv_ForecastK1DokuMN3__c',
            																'SomTv_ForecastPro7MAXXMN3__c' => 'SomTv_ForecastPro7MAXXMN3__c',
            																'SomTv_ForecastSAT1GOLDMN3__c' => 'SomTv_ForecastSAT1GOLDMN3__c',
            																'SomTv_ForecastsixxMN3__c' => 'SomTv_ForecastsixxMN3__c',
            																'SomTv_ForecastCommitmentsKernsenderMN3__c' => 'SomTv_PrognoseCommitment__c',
            																'SomTv_ForecastPaketeKernsenderMN3__c' => 'SomTv_PrognosePaket__c',
            																'SomTv_ForecastZubuchungKernsenderMN3__c' => 'SomTv_PrognoseZubuchung__c'};
        Set<Id> parentIDs = new Set<ID>();
        
        if(isInsert && isAfter) {
            // on insert, always rollup.
            System.debug('+++ after insert');
            for(SomTv_ForecastTV__c forecast : newForecastsList) {
                System.debug('+++ after insert forecast loop');
                parentIDs.add(forecast.SomTV_Account__c);
            }
            
        } else if(isUpdate && isAfter) {
            //on update, rollup if any field has changed.
            System.debug('+++ after update');
            for(SomTv_ForecastTV__c forecast : newForecastsList) {
                System.debug('+++ after update forecast loop');
                SomTv_ForecastTV__c oldForecast = oldForecastsMap.get(forecast.Id);
                
                // if parent change, update old and new parent.
                if(forecast.SomTV_Account__c != oldForecast.SomTV_Account__c) parentIDs.addAll(new Set<ID>{forecast.SomTV_Account__c, oldForecast.SomTV_Account__c});
                else {
                    // if at least one field has changed, do rollup.
                    for(String fieldName : forecastToAccFieldMap.keySet()) {
                        if(forecast.get(fieldName) != oldForecast.get(fieldName)) {
                            parentIDs.add(forecast.SomTV_Account__c);
                            continue;
                        }
                    }
                }
            }
        } else if(isDelete && isAfter) {
            System.debug('+++ after delete');
            for (Id key : oldForecastsMap.keySet()) {
                System.debug('+++ after delete forecast loop');
                SomTv_ForecastTV__c forecast = oldForecastsMap.get(key);
                parentIDs.add(forecast.SomTV_Account__c);
            }
        }
        
        
        
        List<Account> accountsToUpdate = new List<Account>();
        if(!parentIDs.isEmpty()) accountsToUpdate = new List<Account>([SELECT SomTv_ForecastK1DokuMN3__c, SomTv_ForecastPro7MAXXMN3__c, SomTv_ForecastSAT1GOLDMN3__c, SomTv_ForecastsixxMN3__c, SomTv_PrognoseCommitment__c, SomTv_PrognosePaket__c,SomTv_PrognoseZubuchung__c,
                                                           (SELECT SomTv_ForecastK1DokuMN3__c, SomTv_ForecastPro7MAXXMN3__c, SomTv_ForecastSAT1GOLDMN3__c, SomTv_ForecastsixxMN3__c, SomTv_ForecastCommitmentsKernsenderMN3__c, SomTv_ForecastPaketeKernsenderMN3__c, SomTv_ForecastZubuchungKernsenderMN3__c FROM Forecasts_TV__r WHERE SomTv_ForecastTVfueraktuellesJahr__c = TRUE)
                                                           FROM Account
                                                           WHERE Id IN :parentIDs]);
        System.debug('+++accountsToUpdate.size: '+accountsToUpdate.size());
        
        for(Account acc: accountsToUpdate) {
            System.debug('+++acc.Forecasts_TV__r.size: '+acc.Forecasts_TV__r.size());
            // Set values to 0.
            for(String fieldName : forecastToAccFieldMap.values()) {
                System.debug('+++forecastToAccFieldMap loop');
                acc.put(fieldName, 0);
            }
            for(SomTv_ForecastTV__c forecast : acc.Forecasts_TV__r) {
                System.debug('+++forecast loop');
                for(String fieldName : forecastToAccFieldMap.keySet()) {
                    System.debug('+++forecast fieldname loop');
                    Decimal acumulatedValue = (Decimal)acc.get(forecastToAccFieldMap.get(fieldName));
                    acumulatedValue = acumulatedValue == NULL ? 0 : acumulatedValue;
                    Decimal currentForecastValue = (Decimal)forecast.get(fieldName);
                    currentForecastValue = currentForecastValue == NULL ? 0 : currentForecastValue;
                    acc.put(forecastToAccFieldMap.get(fieldName), acumulatedValue + currentForecastValue);
                }
            }
        }
        
        update accountsToUpdate;
        
    }

}