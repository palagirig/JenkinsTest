public with sharing class Ven_Opportunity_PipelineHandler extends TriggerController{
    /**
    * @Methodname   Ven_Opportunity_PipelineHandler
    * @description  Constructor
    * @param        Trigger based values
    * @return       -
    */
    public Ven_Opportunity_PipelineHandler(Boolean isAfter, Boolean isBefore,
        Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate,
        List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems){
        super(isAfter, isBefore, isDelete, isInsert, isUndelete, isUpdate, lstNewItems, mapNewItems, lstOldItems, mapOldItems);
    }

    /**
    * @Methodname       runBeforeUpdate
    * @description
    * @param            -
    * @return           void
    */
    protected override void runBeforeUpdate() {
        // VVR: 05.11.2015: Unterscheidung für VEN RecordTypes
        try{
            updateTotalValues(lstNewItems);
        }
        catch(Exception e){}
    }


    /**
    * @Methodname       updateTotalValues
    * @description
    * @param            List<sObject>
    * @return           void
    */
    static void updateTotalValues(List<sObject> lstNewItems){

        Map<Id, Opportunity> oppId2Opp                  = buildOppId2Opp(lstNewItems);

        Map<Id, Decimal> oppId2TotalGmvCurrentYear      = new Map<Id, Decimal>();
        Map<Id, Decimal> oppId2TotalCashCurrentYear     = new Map<Id, Decimal>();
        Map<Id, Decimal> oppId2TotalGmvNextYear         = new Map<Id, Decimal>();
        Map<Id, Decimal> oppId2TotalCashNextYear        = new Map<Id, Decimal>();
        Map<String, Map<Integer,Decimal>> mapOppYear2Pipes = new Map<String, Map<Integer, Decimal>>();

        buildTotalMaps(oppId2Opp.keySet(), oppId2TotalGmvCurrentYear, oppId2TotalCashCurrentYear, oppId2TotalGmvNextYear, oppId2TotalCashNextYear, mapOppYear2Pipes);

        for(Id oppId : oppId2Opp.keySet()){

            Opportunity opp = oppId2Opp.get(oppId);
            
            if(oppId2TotalGmvCurrentYear.containsKey(oppId)){
            	opp.Ven_TotalGmvCurrentYear__c = oppId2TotalGmvCurrentYear.get(oppId).round(System.roundingMode.CEILING);
            }else{
            	opp.Ven_TotalGmvCurrentYear__c = 0;
            }
            
            if(oppId2TotalCashCurrentYear.containsKey(oppId)){
            	opp.Ven_TotalCashCurrentYear__c = oppId2TotalCashCurrentYear.get(oppId).round(System.roundingMode.CEILING);
            }else{
            	opp.Ven_TotalCashCurrentYear__c = 0;
            }

            if(oppId2TotalGmvNextYear.containsKey(oppId)){
            	opp.Ven_TotalGmvNextYear__c = oppId2TotalGmvNextYear.get(oppId).round(System.roundingMode.CEILING);
            }else{
            	opp.Ven_TotalGmvNextYear__c = 0;
            }
            
            if(oppId2TotalCashNextYear.containsKey(oppId)){
            	opp.Ven_TotalCashNextYear__c = oppId2TotalCashNextYear.get(oppId).round(System.roundingMode.CEILING);
            }else{
            	opp.Ven_TotalCashNextYear__c = 0;
            }

            //**** New BS 29.08.2016 *** Needed for calculation of Ven_NetPotentialCurrentYear__c
            Map<Integer, Decimal> mapMonths2Likelihood = Ven_Utility.getSomLikelihoodByEffYield(opp.Ven_EffectiveYield__c);
            Decimal somLikelihoodThisYear = calcSomLikelihood(mapMonths2Likelihood, mapOppYear2Pipes.get(oppId + '#+#' + Date.today().year()));
            Decimal somLikelihoodNextYear = calcSomLikelihood(mapMonths2Likelihood, mapOppYear2Pipes.get(oppId + '#+#' + (Date.today().year()+1)));

            opp.Ven_NetPotentialCurrentYear__c = ((opp.Ven_EffectiveYield__c/100) * (opp.Probability/100) * somLikelihoodThisYear).round(System.roundingMode.CEILING);
            opp.Ven_NetPotentialNextYear__c = ((opp.Ven_EffectiveYield__c/100)* (opp.Probability/100) * somLikelihoodNextYear).round(System.roundingMode.CEILING);

            /*** OLD BS 29.08.2016 ***
            opp.Ven_NetPotentialCurrentYear__c  = (opp.Ven_TotalGmvCurrentYear__c * (opp.Ven_EffectiveYield__c/100) * (somLikelihood/100) * (opp.Probability/100)).round(System.roundingMode.CEILING);
            opp.Ven_NetPotentialNextYear__c     = (opp.Ven_TotalGmvNextYear__c * (opp.Ven_EffectiveYield__c/100) * (somLikelihood/100) * (opp.Probability/100)).round(System.roundingMode.CEILING);
            ***/
        }
    }

    //**** New BS 29.08.2016 *** Needed for calculation of Ven_NetPotentialCurrentYear__c
    static Decimal calcSomLikelihood(Map<Integer, Decimal> mapMonths2Likelihood, Map<Integer, Decimal> mapMonths2Amounts){
        Decimal somLikelihood = 0;

        if(mapMonths2Likelihood != null && mapMonths2Amounts != null){
            for(Integer i : mapMonths2Likelihood.keySet()){
                if(mapMonths2Amounts.containsKey(i) && mapMonths2Amounts.get(i) != null){
                    somLikelihood += (mapMonths2Likelihood.get(i) / 100) * mapMonths2Amounts.get(i);
                }
            }
        }
        return somLikelihood;
    }

    static Map<Id, Opportunity> buildOppId2Opp(List<sObject> lstNewItems){
        Map<Id, Opportunity> oppId2Opp = new Map<Id, Opportunity>();

        for(sObject obj : lstNewItems){
            Opportunity opp = (Opportunity) obj;
            oppId2Opp.put(opp.Id, opp);
        }

        return oppId2Opp;
    }

    static void buildTotalMaps(Set<Id> oppIds, Map<Id, Decimal> oppId2TotalGmvCurrentYear, Map<Id, Decimal> oppId2TotalCashCurrentYear, Map<Id, Decimal> oppId2TotalGmvNextYear, Map<Id, Decimal> oppId2TotalCashNextYear,
                               Map<String, Map<Integer, Decimal>> mapOppYear2Pipes){

        Decimal thisYear = Date.today().year();
        Decimal nextYear = thisYear+1;

        for(AggregateResult ar : [  SELECT Ven_Opp__c oppId, SUM(Ven_Amount__c) totalGmv, SUM(Ven_Cash__c) totalCash
                                    FROM Ven_OppPipeline__c
                                    WHERE Ven_Opp__c IN :oppIds AND Ven_Year__c = :thisYear
                                    GROUP BY Ven_Opp__c]){

            oppId2TotalGmvCurrentYear.put((Id) ar.get('oppId'), (Decimal) ar.get('totalGmv'));
            oppId2TotalCashCurrentYear.put((Id) ar.get('oppId'), (Decimal) ar.get('totalCash'));
        }

        for(AggregateResult ar : [  SELECT Ven_Opp__c oppId, SUM(Ven_Amount__c) totalGmv, SUM(Ven_Cash__c) totalCash
                                    FROM Ven_OppPipeline__c
                                    WHERE Ven_Opp__c IN :oppIds AND Ven_Year__c = :nextYear
                                    GROUP BY Ven_Opp__c]){

            oppId2TotalGmvNextYear.put((Id) ar.get('oppId'), (Decimal) ar.get('totalGmv'));
            oppId2TotalCashNextYear.put((Id) ar.get('oppId'), (Decimal) ar.get('totalCash'));
        }

        //**** New BS 29.08.2016 *** Needed for calculation of Ven_NetPotentialCurrentYear__c
        for(Ven_OppPipeline__c op : [SELECT Ven_Opp__c, Ven_Year__c, Ven_Month__c, Ven_Amount__c, Ven_Cash__c
                                                        FROM Ven_OppPipeline__c
                                                        WHERE Ven_Opp__c IN :oppIds AND (Ven_Year__c = :thisYear OR Ven_Year__c = :nextYear)
                                                        ORDER BY Ven_Opp__c, Ven_Year__c]){

            String key = op.Ven_Opp__c + '#+#' + op.Ven_Year__c;
            if(mapOppYear2Pipes.containsKey(key)){
                Map<Integer, Decimal> mapMonths2Amounts = mapOppYear2Pipes.get(key);
                mapMonths2Amounts.put((Integer) op.Ven_Month__c, op.Ven_Amount__c);
                mapOppYear2Pipes.put(key, mapMonths2Amounts);
            }else{
                mapOppYear2Pipes.put(key, new Map<Integer, Decimal>{(Integer) op.Ven_Month__c => op.Ven_Amount__c});
            }
        }
    }
}