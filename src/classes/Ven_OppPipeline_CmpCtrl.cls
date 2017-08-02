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
public with sharing class Ven_OppPipeline_CmpCtrl {

    private String oppId{get;set;}

    private static Map<String, String> OPP_STAGES{get;set;}
    private static List<String> IMS_ROLES{get;set;}
    private static List<String> SCOUT_ROLE{get;set;}
    private static List<String> ANALYST_ROLE{get;set;}
    private static String IM_ROLE{get;set;}
    private static String AUSTRIA_ROLE{get;set;}
    private static String SWITZERLAND_ROLE{get;set;}

    /*****************
    *
    *****************/
    public PageReference redirect(){
        return new PageReference('/c/Ven_OppPipeApp.app');
    }

    public Ven_OppPipeline_CmpCtrl(ApexPages.StandardController sc){
        oppId = sc.getId();
    }

    public Ven_OppPipeline_CmpCtrl(){

    }

    private static void initSettings(){

        OPP_STAGES = new Map<String,String>();
        OPP_STAGES.put('Potential', 'SE_Potenzial');
        OPP_STAGES.put('Contacted', 'SE_Erstgespräch Bedarf/Bestand');
        OPP_STAGES.put('In Briefing', 'SE_In Briefing/Erstgespräch');
        OPP_STAGES.put('M2N', 'SE_Rabatt freigegeben');
        OPP_STAGES.put('Deal approval', 'SE_Deal Approval');
        OPP_STAGES.put('Closed Won', 'SE_Closed Won');
        OPP_STAGES.put('Closed Lost', 'SE_Closed Lost');
        OPP_STAGES.put('Cancelled', 'SE_Storniert');
        OPP_STAGES.put('Parked', 'SE_Parked');

        IMS_ROLES           = new List<String>{'Ven_Investment_Manager', 'Ven_ManagingDirectors', 'Ven_OpsStrat', 'Ven_BusinessDevelopment', 'Ven_Austria', 'Ven_Switzerland'};
        SCOUT_ROLE          = new List<String>{'Ven_Scout'};
        ANALYST_ROLE        = new List<String>{'Ven_Analyst'};
        IM_ROLE             = 'Ven_Investment_Manager';
        AUSTRIA_ROLE        = 'Ven_Austria';
        SWITZERLAND_ROLE    = 'Ven_Switzerland';
    }

    /*****************
    *
    *****************/
    @AuraEnabled
    public static Opportunity saveOppPipeDetail(Opportunity opp, List<Ven_OppPipeline__c> oppPipes){
    //public static Opportunity saveOppPipeDetail(Opportunity opp, P7S1_OpportunityApproval__c approval, List<Ven_OppPipeline__c> oppPipes){
        initSettings();

        try{
            opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Ventures Default').getRecordTypeId();

            //Convert Scout for save
            convertScoutSaving(opp);

            // Only set SE_ Stages
            if(OPP_STAGES.containsKey(opp.StageName)){
                opp.StageName = OPP_STAGES.get(opp.StageName);
            }

            if(opp.CloseDate == null){
                opp.CloseDate = Date.today().addMonths(6);
            }
            upsert opp;

            //Update or create OpportunityApproval object
            /*if(approval.P7S1_Opportunity__c == null){
              approval.P7S1_Opportunity__c = opp.Id;
            }
            upsert approval;*/

            List<Ven_OppPipeline__c> newOppPipes = new List<Ven_OppPipeline__c>();
            Integer dealStartMonth = null;
            Integer dealStartYear = null;
            for(Ven_OppPipeline__c op : oppPipes){
                if(op.Id == null){
                    op.Ven_Opp__c = opp.Id;
                }
                newOppPipes.add((Ven_OppPipeline__c) op);

                //Calculate start month of deal
                if((dealStartMonth == null || (op.Ven_Month__c < dealStartMonth && op.Ven_Year__c == dealStartYear) ||  op.Ven_Year__c < dealStartYear) && op.Ven_Amount__c != null && op.Ven_Amount__c > 0){
                    dealStartMonth = (Integer) op.Ven_Month__c;
                    dealStartYear = (Integer) op.Ven_Year__c;
                }
            }
            upsert newOppPipes;

            //Fill field for deal start month on Opp
            if(dealStartMonth != null && dealStartYear != null){
                String dealStart = dealStartMonth +'/' + dealStartYear;
                opp.Ven_DealStartMonth__c = dealStart;
            }else{
                opp.Ven_DealStartMonth__c = null;
            }

            //Second Update to run trigger correctly
            update opp;

            Opportunity backOpp = getOppById(opp.Id);

            //Convert scout loading
            convertScoutLoading(backOpp);

            // Set visible StageName
            backOpp.StageName = getTranslatedStageName(backOpp.StageName);

            return backOpp;
        }
        catch(Exception e){
            system.debug(LoggingLevel.ERROR, e.getLineNumber() +' => '+ e.getMessage());
        }

        return null;
    }


    /*****************
    *
    *****************/
    @AuraEnabled
    public static List<Opportunity> saveOpps(List<Opportunity> opps){

        initSettings();

        // Only set SE_ Stages
        for(Opportunity opp : opps){
            if(OPP_STAGES.containsKey(opp.StageName)){
                opp.StageName = OPP_STAGES.get(opp.StageName);
            }
            //Convert scout for save
            convertScoutSaving(opp);
        }

        try{
            update opps;

            List<Id> oppIds = new List<Id>();
            for(Opportunity opp : opps){
                oppIds.add(opp.Id);
            }

            List<Opportunity> lstBackOpps = new List<Opportunity>();

            // Set visible StageName
            for(Opportunity opp : getOppsByIds(oppIds)){
                opp.StageName = getTranslatedStageName(opp.StageName);
                //Convert scout loading
                convertScoutLoading(opp);
                lstBackOpps.add(opp);
            }

            return lstBackOpps;
        }
        catch(Exception e){
            system.debug(LoggingLevel.ERROR, e.getLineNumber() +' => '+ e.getMessage());
        }

        return null;
    }

    /*****************
    * Convert Scout-Fields - Saving
    *****************/
    private static void convertScoutSaving(Opportunity opp){
        if(opp.Ven_ScoutText__c != null && opp.Ven_ScoutText__c != ''){
            if(opp.Ven_ScoutText__c.startsWith('#+#')){
                opp.Ven_ScoutText__c = opp.Ven_ScoutText__c.replace('#+#', '');
                opp.Ven_Scout__c = null;
            }else{
                opp.Ven_Scout__c = opp.Ven_ScoutText__c;
                opp.Ven_ScoutText__c = null;
            }
        }else{
            opp.Ven_Scout__c = null;
            opp.Ven_ScoutText__c = null;
        }
    }

    /*****************
    * Convert Scout-Fields - Loading
    *****************/
    private static void convertScoutLoading(Opportunity opp){
        if(opp.Ven_Scout__c != null){
            opp.Ven_ScoutText__c = opp.Ven_Scout__c;
        }else if(opp.Ven_ScoutText__c != null && opp.Ven_ScoutText__c != ''){
            opp.Ven_ScoutText__c = '#+#' + opp.Ven_ScoutText__c;
        }
    }

    /*****************
    *
    *****************/
    @AuraEnabled
    public static void pipelineChecked(){
    	update new User(Id = UserInfo.getUserId(), Ven_PipelineChecked__c = Datetime.now());
    }

    /*****************
    *
    *****************/
    @AuraEnabled
    public static void deleteOppPipeDetail(String oppId){
        delete [SELECT Id FROM Opportunity WHERE Id = :oppId];
    }



    @AuraEnabled
    public static OppPipeDetail getOppPipeDetail(Opportunity opp){
        OppPipeDetailYear currentYear = getOppId2OppLineYearByYear(new Set<Id>{opp.Id}, System.today().year()).values()[0];
        OppPipeDetailYear nextYear =  getOppId2OppLineYearByYear(new Set<Id>{opp.Id}, System.today().year()+1).values()[0];

        P7S1_OpportunityApproval__c approval = getOppApproval(opp.Id);

        return new OppPipeDetail(opp, approval, currentYear, nextYear);
    }


    @AuraEnabled
    public static List<ExportData> getExportData(Boolean isInPermissionSet){

        Map<Id, Opportunity> oppId2Opp = getExportOpps(isInPermissionSet);

        Map<Id, OppPipeDetailYear> oppId2CurrentYear = getOppId2OppLineYearByYear(oppId2Opp.keySet(), System.today().year());
        Map<Id, OppPipeDetailYear> oppId2NextYear = getOppId2OppLineYearByYear(oppId2Opp.keySet(), System.today().year()+1);

        List<ExportData> exportDatas = new List<ExportData>();

        for(Opportunity opp : oppId2Opp.values()){

            //Convert scout loading
            convertScoutLoading(opp);

            exportDatas.add(new ExportData(opp, oppId2CurrentYear.get(opp.Id), oppId2NextYear.get(opp.Id)));
        }

        return exportDatas;
    }


    /*****************
    *
    *****************/
    @AuraEnabled
    public static OppPipeData getOppPipeData(){
        initSettings();

        Set<Id> assigneeIds = new Set<Id>();

        User currentUser = [SELECT Id, Ven_PipelineChecked__c FROM User WHERE Id = :UserInfo.getUserId()];

        for(PermissionSetAssignment psa : [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Ven_OppPipeAccessAll']){
            assigneeIds.add(psa.AssigneeId);
        }

        Map<Id, Opportunity> oppId2Opp;
        Boolean isInPermissionSet;
        List<Opportunity> summaryItems = new List<Opportunity>();

        if(assigneeIds.contains(UserInfo.getUserId())){
            summaryItems = getAllOpps().values();
            isInPermissionSet  = true;
        }
        else {
            summaryItems = getOppsByOppTeam().values();
            isInPermissionSet  = false;
        }

        for(Opportunity opp : summaryItems){
            opp.StageName = getTranslatedStageName(opp.StageName);
            opp.Ven_EffectiveYield__c = (opp.Ven_EffectiveYield__c == null ? 0 : opp.Ven_EffectiveYield__c);

            //Convert Scout - Loading
            convertScoutLoading(opp);
        }

        List<Ven_Utility.InputSelectOpt> stageNames = new List<Ven_Utility.InputSelectOpt>();
        for(String stageName : OPP_STAGES.keySet()){
            stageNames.add(new Ven_Utility.InputSelectOpt(stageName, stageName));
        }

        List<Ven_Utility.InputSelectOpt> imOptions = Ven_Utility.getUsersByRoleNames(IMS_ROLES, false);

        List<String> userIds = new List<String>();

        for(Ven_Utility.InputSelectOpt iso : imOptions){
            userIds.add(iso.text);
        }


        SelectOptionLists selectOptLsts = new SelectOptionLists(    Ven_Utility.getInputSelectOptsByPicklistValues('Opportunity', 'Ven_DealType__c'),
                                                                    Ven_Utility.getInputSelectOptsByPicklistValues('Opportunity', 'Ven_SubCategory__c'),
                                                                    getCountries(false),
                                                                    getCountries(true),
                                                                    Ven_Utility.getInputSelectOptsByPicklistValues('Opportunity', 'Ven_Stage_Finished_Subcategory__c'),
                                                                    stageNames,
                                                                    imOptions,
                                                                    Ven_Utility.getUsersByRoleNames(IMS_ROLES, true),
                                                                    Ven_Utility.getUsersByRoleNames(SCOUT_ROLE, false),
                                                                    Ven_Utility.getUsersOfInvestmentTeam('Scout', '#+#'),
                                                                    Ven_Utility.getUsersOfInvestmentTeam('Media Planner', ''),
                                                                    Ven_Utility.getVerticalsInputSelect(),
                                                                    Ven_Utility.getInputSelectOptsByPicklistValues('Opportunity', 'Ven_DealCategory__c'),
                                                                    getCurrencies(),
                                                                    Ven_Utility.getInputSelectOptsByPicklistValues('Opportunity', 'Ven_TargetPL__c'),
                                                                    Ven_Utility.getInputSelectOptsByPicklistValues('Opportunity', 'Ven_BusinessModel__c'),
                                                                    Ven_Utility.getInputSelectOptsByPicklistValues('Opportunity', 'Ven_BusinessType__c'),
                                                                    Ven_Utility.getInputSelectOptsByPicklistValues('Opportunity', 'Ven_RiskProfile__c'),
                                                                    Ven_Utility.getInputSelectOptsByPicklistValues('Opportunity', 'Ven_CustomerAssesment__c'),
                                                                    Ven_Utility.getInputSelectOptsByPicklistValues('P7S1_OpportunityApproval__c', 'Ven_FeedbackAdMarketDevInitiative__c'),
                                                                    Ven_Utility.getInputSelectOptsByPicklistValues('P7S1_OpportunityApproval__c', 'Ven_InterestOfData__c'),
                                                                    Ven_Utility.getInputSelectOptsByPicklistValues('P7S1_OpportunityApproval__c', 'Ven_SLM__c'));


        Boolean isAlreadyCheckedThisWeek = false;


        if(currentUser.Ven_PipelineChecked__c != NULL)
        {
            Date dateOfLastCheck = Date.newInstance(currentUser.Ven_PipelineChecked__c.year(), currentUser.Ven_PipelineChecked__c.month(), currentUser.Ven_PipelineChecked__c.day());
            isAlreadyCheckedThisWeek = wasInThisCycle(dateOfLastCheck);
        }

        // ############################



        return new OppPipeData( UserInfo.getUserId(),
                                UserInfo.getFirstName()+' '+UserInfo.getLastName(),
                                UserInfo.getUserRoleId(),
                                isAlreadyCheckedThisWeek,
                                Ven_Utility.getRoleIdByName(IM_ROLE),
                                Ven_Utility.getRoleIdByName(SCOUT_ROLE[0]),
                                Ven_Utility.getRoleIdByName(ANALYST_ROLE[0]),
                                isInPermissionSet,
                                summaryItems,
                                selectOptLsts,
                                buildCountryInternationalMap(),
                                Ven_Utility.getRoleIdByName(AUSTRIA_ROLE),
                                Ven_Utility.getRoleIdByName(SWITZERLAND_ROLE),
                                buildUserRoleMap(userIds));
    }

    public static Boolean wasInThisCycle(Date dateToCheck)
    {
        Date wednessdayOfThisWeek = Date.today().toStartOfWeek().addDays(2);
        if(Date.today() >= wednessdayOfThisWeek)
        {
            return dateToCheck >= wednessdayOfThisWeek;
        }
        else
        {
            return dateToCheck >= wednessdayOfThisWeek.addDays(-7);
        }
    }


    /*****************
    *
    *****************/
    private static Map<String, String> buildUserRoleMap(List<String> userIds){

        Map<String, String> result = new Map<String, String>();

        for(User u : [  SELECT Id, UserRoleId
                        FROM User
                        WHERE Id IN :userIds]){
            result.put(u.Id, u.UserRoleId);
        }

        return result;
    }


    /*****************
    *
    *****************/
    private static Map<String, Boolean> buildCountryInternationalMap(){

        Map<String, Boolean> result = new Map<String, Boolean>();

        for(P7S1_Country__c country : [ SELECT Id, Ven_International__c
                                        FROM P7S1_Country__c
                                        WHERE Active__c = true
                                            AND P7S1_Sphere__c INCLUDES ('Ven')]){
            result.put(country.Id, country.Ven_International__c);
        }

        return result;
    }


    /*****************
    *
    *****************/
    private static List<Ven_Utility.InputSelectOpt> getCurrencies(){
        List<Ven_Utility.InputSelectOpt> currencyTypes = new List<Ven_Utility.InputSelectOpt>();

        for(CurrencyType cy : [ SELECT Id, IsoCode
                                FROM CurrencyType
                                WHERE isactive = true
                                ORDER BY isocode]){
            currencyTypes.add(new Ven_Utility.InputSelectOpt(cy.IsoCode, cy.IsoCode));
        }

        return currencyTypes;
    }

    /*****************
    *
    *****************/
    private static List<Ven_Utility.InputSelectOpt> getCountries(Boolean alpha3){
        List<Ven_Utility.InputSelectOpt> countries = new List<Ven_Utility.InputSelectOpt>();

        for(P7S1_Country__c country : [ SELECT Id, Name_EN__c, Alpha_3_Code__c
                                        FROM P7S1_Country__c
                                        WHERE Active__c = true
                                            AND P7S1_Sphere__c INCLUDES ('Ven')
                                        ORDER BY P7S1_TopCountry__c DESC, Name_EN__c]){

            if(alpha3){
            	countries.add(new Ven_Utility.InputSelectOpt(country.Id, country.Alpha_3_Code__c));
            }else{
            	countries.add(new Ven_Utility.InputSelectOpt(country.Id, country.Name_EN__c));
            }
        }

        return countries;
    }



    /*****************
    *
    *****************/
    private static String getBaseQueryString(){

    	String thisYear = String.valueOf(Date.today().year());
    	String thisMonth = String.valueOf(Date.today().month());

        return
            'SELECT '+
                'Id, '+
                'Name, '+
                'Ven_TotalGmvCurrentYear__c, '+
                'Ven_TotalGmvNextYear__c, '+
                'Ven_DealType__c,  '+
                'Ven_SubCategory__c, '+
                'Ven_CashInvest__c, '+
                'Ven_DealCategory__c, '+
                'StageName,  '+
                'Ven_Stage_Finished_Subcategory__c, '+
                'Ven_Comment__c, '+
                'Ven_Vertical__c, '+
                'Ven_Verticals__c, '+
                'Ven_International__c, '+
                'Ven_EstimateCashYieldCurrentYear__c, '+
                'Ven_EffectiveYield__c, '+
                'Ven_EstimatePrapYieldCurrentYear__c, '+
                'Account.Ven_SomApproval__c, '+
                'CurrencyIsoCode, '+
                'Probability, '+
                'OwnerId, '+
                'Ven_Country__c, '+
                'Ven_Country__r.Name_EN__c, '+
                'Owner.Firstname, '+
                'Owner.Lastname, '+
                'CloseDate, '+
                'CreatedDate, '+
                'AccountId, '+
                'Account.Name, '+
                'Account.CreatedDate, '+
                'Ven_NetPotentialCurrentYear__c, '+
                'Ven_NetPotentialNextYear__c, '+
                'Ven_TotalNetPotential__c, '+
                'Ven_TotalGmv__c, '+
                'Ven_LastModifiedBy__c, '+
                'Ven_LastModifiedDate__c, '+
                'Ven_Im2__c, '+
                'Ven_Scout__c, '+
                'Ven_ScoutText__c, ' +
                'Ven_Analyst__c, '+
                'Ven_MediaPlanner__c, ' +
                'Ven_Contacted__c, '+
                'Ven_m2n__c, '+
                'Ven_DealApproval__c, '+
                'Ven_ClosedWon__c, '+
                'Ven_ClosedLost__c, '+
                'Ven_ParkedDate__c, '+
                'Ven_Cancellation__c, '+
                'Ven_TargetPL__c, '+
                'Ven_Ep__c, '+
                'Ven_EpLight__c, '+
                'Ven_RevShare__c, '+
                'Ven_DealStartMonth__c,' +
                'Ven_TestDeal__c, ' +
                'Ven_ShowInPipe__c, ' +
                'Ven_IndustryChampion__c, ' +
                'Ven_BusinessModel__c, ' +
                'Ven_BusinessType__c, ' +
                'Ven_CustomerAssesment__c, ' +
                'Ven_RiskProfile__c, ' +
                '(SELECT Ven_Amount__c FROM Opportunity_Pipelines__r WHERE Ven_Year__c = ' + thisYear + ' AND Ven_Month__c = ' + thisMonth + ' AND Ven_Amount__c > 0 LIMIT 1) ' +
            'FROM '+
            'Opportunity '+
            'WHERE '+
                'RecordTypeId IN (SELECT Id FROM RecordType WHERE Name LIKE \'Ven%\')';
    }


    /*****************
    *
    *****************/
    private static Map<Id, Opportunity> getExportOpps(Boolean isInPermissionSet){

        String baseQueryString = getBaseQueryString();
        String whereClause = '';

        if(!isInPermissionSet){
        	Set<Id> oppIds = new Set<Id>();
	        for(OpportunityTeamMember otm : [SELECT OpportunityId FROM OpportunityTeamMember WHERE UserId = :UserInfo.getUserId()]){
	            oppIds.add(otm.OpportunityId);
	        }

	        whereClause = ' AND Id IN :oppIds AND StageName != \'Inbox\'';
        }else{
        	whereClause = ' AND StageName != \'Inbox\'';
        }



        return new Map<Id, Opportunity>((List<Opportunity>) Database.query(baseQueryString + whereClause));
    }


    /*****************
    *
    *****************/
    private static Opportunity getOppById(Id oppId){
        String baseQueryString = getBaseQueryString();
        String whereClause = ' AND Id = :oppId';

        return ((List<Opportunity>) Database.query(baseQueryString + whereClause))[0];
    }


    /*****************
    *
    *****************/
    private static List<Opportunity> getOppsByIds(List<Id> oppIds){
        String baseQueryString = getBaseQueryString();
        String whereClause = ' AND Id IN :oppIds';

        return (List<Opportunity>) Database.query(baseQueryString + whereClause);
    }


    /*****************
    *
    *****************/
    private static Map<Id, Opportunity> getAllOpps(){
        String baseQueryString = getBaseQueryString();
        String whereClause = ' AND StageName IN (\'In Briefing\', \'M2N (Mandate to Negotiate)\', \'Deal approval\', \'Potential\', \'Contacted\',\'SE_Potenzial\', \'SE_Erstgespräch Bedarf/Bestand\', \'SE_In Briefing/Erstgespräch\', \'SE_Rabatt freigegeben\', \'SE_Deal Approval\', \'Parked\', \'SE_Parked\') ORDER BY OwnerId';

        return new Map<Id, Opportunity>((List<Opportunity>) Database.query(baseQueryString + whereClause));
    }


    /*****************
    *
    *****************/
    private static Map<Id, Opportunity> getOppsByOppTeam(){
        Set<Id> oppIds = new Set<Id>();
        for(OpportunityTeamMember otm : [SELECT OpportunityId FROM OpportunityTeamMember WHERE UserId = :UserInfo.getUserId()]){
            oppIds.add(otm.OpportunityId);
        }

        String baseQueryString = getBaseQueryString();
        String whereClause = ' AND Id IN :oppIds AND StageName IN (\'In Briefing\', \'M2N (Mandate to Negotiate)\', \'Deal approval\', \'Potential\', \'Contacted\', \'SE_Potenzial\', \'SE_Erstgespräch Bedarf/Bestand\', \'SE_In Briefing/Erstgespräch\', \'SE_Rabatt freigegeben\', \'SE_Deal Approval\', \'Parked\', \'SE_Parked\') ORDER BY OwnerId';

        return new Map<Id, Opportunity>((List<Opportunity>) Database.query(baseQueryString + whereClause));
    }


    /*****************
    *
    ******************/
    private static Map<Id, OppPipeDetailYear> getOppId2OppLineYearByYear(Set<Id> oppIds, Integer year){
        Map<Id, OppPipeDetailYear> oppId2OppPipelineYear            = new Map<Id, OppPipeDetailYear>();
        Map<Id, List<Ven_OppPipeline__c>> oppId2OppPipelineMonths   = new Map<Id, List<Ven_OppPipeline__c>>();

        for(Ven_OppPipeline__c oppPipeline : [  SELECT Ven_Amount__c, Ven_Year__c, Ven_Month__c, Ven_Opp__c, Ven_Cash__c
                                                FROM Ven_OppPipeline__c
                                                WHERE Ven_Opp__c IN :oppIds
                                                    AND Ven_Year__c = :year
                                                ORDER BY Ven_Opp__c, Ven_Year__c, Ven_Month__c DESC]){


            if(oppId2OppPipelineMonths.get(oppPipeline.Ven_Opp__c) != null){
                oppId2OppPipelineMonths.get(oppPipeline.Ven_Opp__c).add(oppPipeline);
            } else {
                oppId2OppPipelineMonths.put(oppPipeline.Ven_Opp__c, new List<Ven_OppPipeline__c>{oppPipeline});
            }
        }

        for(Id oppId : oppIds){
            Decimal totalAmount = 0;
            Decimal totalCash   = 0;

            List<Ven_OppPipeline__c> ops = new List<Ven_OppPipeline__c>();

            for(Integer i=1; i <= 12; i++){
                Boolean opmFound = false;

                if(oppId2OppPipelineMonths.get(oppid) != null){

                    for(Ven_OppPipeline__c op : oppId2OppPipelineMonths.get(oppId)){
                        if(op.Ven_Month__c == i){
                            totalAmount += (op.Ven_Amount__c == null ? 0 : op.Ven_Amount__c);
                            totalCash   += (op.Ven_Cash__c == null ? 0 : op.Ven_Cash__c);
                            opmFound    = true;
                            ops.add(op);
                        }
                    }
                }
            }

            OppPipeDetailYear opy = new OppPipeDetailYear(ops, totalAmount, totalCash, String.valueOf(year));
            oppId2OppPipelineYear.put(oppId, opy);
        }

        return oppId2OppPipelineYear;
    }

    private static P7S1_OpportunityApproval__c getOppApproval(String oppId){

      String soql = 'SELECT ' + Ven_Utility.getFieldListFromObject('P7S1_OpportunityApproval__c') +
                    ' FROM P7S1_OpportunityApproval__c ' +
                    ' WHERE P7S1_Opportunity__c = \'' + oppId + '\' ';

      List<P7S1_OpportunityApproval__c> lstApproval = Database.query(soql);
      if(lstApproval != null && lstApproval.size() > 0){
        return lstApproval[0];
      }else{
        return new P7S1_OpportunityApproval__c();
      }
    }


    /*****************
    *
    *****************/
    private static String getTranslatedStageName(String stageName){

        for(String stageFromMap : OPP_STAGES.keySet()){
            if(stageName == OPP_STAGES.get(stageFromMap)){
                stageName = stageFromMap;
            }
        }

        return stageName;
    }





    /* ====================================== WRAPPER CLASSES ======================================== */

    public class ExportData{
        @AuraEnabled
        OppPipeDetailYear currentYear{get;set;}

        @AuraEnabled
        OppPipeDetailYear nextYear{get;set;}

        @AuraEnabled
        Opportunity opp{get;set;}

        public ExportData(Opportunity opp, OppPipeDetailYear currentYear, OppPipeDetailYear nextYear){
            this.opp           = opp;
            this.currentYear   = currentYear;
            this.nextYear      = nextYear;
        }
    }


    /* OPP PIPELINE DATA */
    public class OppPipeData{
        @AuraEnabled
        public String userId;

        @AuraEnabled
        public String userName;

        @AuraEnabled
        public String userRole;

        @AuraEnabled
        public Boolean isAlreadyCheckedThisWeek;

        @AuraEnabled
        public String imRoleId;

        @AuraEnabled
        public String scoutRoleId;

        @AuraEnabled
        public String analystRoleId;

        @AuraEnabled
        public String austriaRoleId;

        @AuraEnabled
        public String switzerlandRoleId;

        @AuraEnabled
        public Map<String, Boolean> countryId2International;

        @AuraEnabled
        public Map<String, String> userId2RoleId;

        @AuraEnabled
        public List<Opportunity> summaryItems;

        @AuraEnabled
        public SelectOptionLists selectOptLsts;

        @AuraEnabled
        public Boolean isInPermissionSet;

        @AuraEnabled
        public Integer currentYear;

        @AuraEnabled
        public List<Ven_SomLikelihood__c> somLikelihoods;

        public OppPipeData( String userId,
                            String userName,
                            String userRole,
                            Boolean isAlreadyCheckedThisWeek,
                            String imRoleId,
                            String scoutRoleId,
                            String analystRoleId,
                            Boolean isInPermissionSet,
                            List<Opportunity> summaryItems,
                            SelectOptionLists selectOptLsts,
                            Map<String, Boolean> countryId2International,
                            String austriaRoleId,
                            String switzerlandRoleId,
                            Map<String, String> userId2RoleId){
            this.userId                     = userId;
            this.userName                   = userName;
            this.userRole                   = userRole;
            this.isAlreadyCheckedThisWeek   = isAlreadyCheckedThisWeek;
            this.imRoleId                   = imRoleId;
            this.scoutRoleId                = scoutRoleId;
            this.analystRoleId              = analystRoleId;
            this.isInPermissionSet          = isInPermissionSet;
            this.summaryItems               = summaryItems;
            this.selectOptLsts              = selectOptLsts;
            this.countryId2International    = countryId2International;
            this.austriaRoleId              = austriaRoleId;
            this.switzerlandRoleId          = switzerlandRoleId;
            this.userId2RoleId              = userId2RoleId;
            this.currentYear                = System.today().year();
            this.somLikelihoods             = Ven_SomLikelihood__c.getAll().values();
        }
    }

    /* OPP PIPELINE TABLE ROW */
    public class OppPipeDetail{
        @AuraEnabled
        public Opportunity opp;

        @AuraEnabled
        public P7S1_OpportunityApproval__c approval;

        @AuraEnabled
        public OppPipeDetailYear currentYear;

        @AuraEnabled
        public OppPipeDetailYear nextYear;

        public OppPipeDetail(Opportunity opp, P7S1_OpportunityApproval__c approval , OppPipeDetailYear currentYear, OppPipeDetailYear nextYear){
            this.opp            = opp;
            this.approval       = approval;
            this.currentYear    = currentYear;
            this.nextYear       = nextYear;
        }
    }



    /* OPP PIPELINE YEAR */
    public class OppPipeDetailYear{
        @AuraEnabled
        public List<Ven_OppPipeline__c> oppPipeMonths;

        @AuraEnabled
        public Decimal totalAmount;

        @AuraEnabled
        public Decimal totalCash;

        @AuraEnabled
        public String year;

        public OppPipeDetailYear(List<Ven_OppPipeline__c> oppPipeMonths, Decimal totalAmount, Decimal totalCash, String year){
            this.oppPipeMonths      = oppPipeMonths;
            this.totalAmount        = totalAmount;
            this.totalCash          = totalCash;
            this.year               = year;
        }
    }


    public class SelectOptionLists{
        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> dealTypes;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> subCats;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> countries;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> countriesAlpha3;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> reasons;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> stageNames;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> ims;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> imsAlias;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> scouts;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> analysts;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> verticals;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> dealCats;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> currencies;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> targetPls;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> businessmodel;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> businesstype;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> risk;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> customerAssesment;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> adMarket;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> interestData;

        @AuraEnabled
        public List<Ven_Utility.InputSelectOpt> slm;

        public SelectOptionLists(   List<Ven_Utility.InputSelectOpt> dealTypes,
                                    List<Ven_Utility.InputSelectOpt> subCats,
                                    List<Ven_Utility.InputSelectOpt> countries,
                                    List<Ven_Utility.InputSelectOpt> countriesAlpha3,
                                    List<Ven_Utility.InputSelectOpt> reasons,
                                    List<Ven_Utility.InputSelectOpt> stageNames,
                                    List<Ven_Utility.InputSelectOpt> ims,
                                    List<Ven_Utility.InputSelectOpt> imsAlias,
                                    List<Ven_Utility.InputSelectOpt> scouts,
                                    List<Ven_Utility.InputSelectOpt> scoutsNonSFUser,
                                    List<Ven_Utility.InputSelectOpt> analysts,
                                    List<Ven_Utility.InputSelectOpt> verticals,
                                    List<Ven_Utility.InputSelectOpt> dealCats,
                                    List<Ven_Utility.InputSelectOpt> currencies,
                                    List<Ven_Utility.InputSelectOpt> targetPls,
                                    List<Ven_Utility.InputSelectOpt> businessmodel,
                                    List<Ven_Utility.InputSelectOpt> businesstype,
                                    List<Ven_Utility.InputSelectOpt> risk,
                                    List<Ven_Utility.InputSelectOpt> customerAssesment,
                                    List<Ven_Utility.InputSelectOpt> adMarket,
                                    List<Ven_Utility.InputSelectOpt> interestData,
                                    List<Ven_Utility.InputSelectOpt> slm){
            this.dealTypes      = dealTypes;
            this.subCats        = subCats;
            this.countries      = countries;
            this.countriesAlpha3 = countriesAlpha3;
            this.reasons        = reasons;
            this.stageNames     = stageNames;
            this.ims            = ims;
            this.imsAlias       = imsAlias;
            this.scouts         = scouts;
            this.scouts.addAll(scoutsNonSFUser);
            this.analysts       = analysts;
            this.verticals      = verticals;
            this.dealCats       = dealCats;
            this.currencies     = currencies;
            this.targetPls      = targetPls;
            this.businessmodel = businessmodel;
            this.businesstype = businesstype;
            this.risk = risk;
            this.customerAssesment = customerAssesment;
            this.adMarket = adMarket;
            this.interestData = interestData;
            this.slm = slm;
        }
    }
}