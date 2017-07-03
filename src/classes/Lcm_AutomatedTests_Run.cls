global class Lcm_AutomatedTests_Run implements Schedulable{
    
    global void execute(SchedulableContext SC) {
        runLocalTestsAsync();
    }    
    
    @future (callout=true)
    public static void runLocalTestsAsync(){
        system.debug('### Lcm_AutomatedTests_Run.runLocalTestsAsync - entering');
        
        Lcm_ToolingUtil toolingUtil = new Lcm_ToolingUtil();
        P7S1_Settings__c CS = P7S1_Settings__c.getOrgDefaults();
        Lcm_Tooling.Result toolingResult = toolingUtil.tooling('run-tests', null);
        
        /*** CAN REMOVED IF LAST TEST RUN CAN CALLED BY TOOLING API ***/
        if (toolingResult.success){
			system.debug('### Lcm_AutomatedTests_Run.runLocalTestsAsync sId: '  + toolingResult.message);
            CS.P7S1_AutoTestQueueAsyncId__c = extractId(toolingResult);//.message.replace('"','').substring(0,15);
            CS.Lcm_AutoTestExecError__c = null;
        } else {
            CS.P7S1_AutoTestQueueAsyncId__c = null;
            CS.Lcm_AutoTestExecError__c = toolingResult.message;
            system.debug(LOGGINGLEVEL.ERROR, '### Lcm_AutomatedTests_Run.runLocalTestsAsync toolingResult faild: '  + toolingResult.message);
        }
        upsert CS;
        system.debug('### leaving Lcm_AutomatedTests_Run.runLocalTestsAsync');
    }
    
    private static String extractId(Lcm_Tooling.Result toolingResult){
        String response = toolingResult.message;
        
        return response.replace('"','').substring(0,15);
    }
    
}