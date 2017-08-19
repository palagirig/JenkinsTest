global class Lcm_AutomatedTests_Results implements Schedulable{
    private static final String EXCEPTION_NO_EMAIL_ADDRESS = 'No emailReceipients set please check CustomSetting Field P7S1_Recipients__c in P7S1_EmailRecipients__c';

    private static P7S1_EmailRecipients__c emailReceipients = P7S1_EmailRecipients__c.getInstance('Lcm Automated Tests');
    
    global void execute(SchedulableContext SC) {
        processAsyncResults();
    }
    
    // Have to use a future method so the email will be sent out.
    @future (callout=true)    
    public static void processAsyncResults() {
        
        // Get the latest Job ID from P7S1_Settings__c org default.
        P7S1_Settings__c cs = P7S1_Settings__c.getOrgDefaults();
        ID testsJobId = (ID)cs.P7S1_AutoTestQueueAsyncId__c;
        
        if (testsJobId != null || Test.isRunningTest()) {
            
            List<ApexTestQueueItem> queuedItems = getQueuedItems(testsJobId);
            
            // Continue if all the test classes related to our job id are finished.
            if (isJobCompleted(queuedItems) || Test.isRunningTest()) {
                List<ApexTestResult> testResult = checkMethodStatus(testsJobId);
                sendTestResultEmail(testResult);
            }
        }
    }    
    
    
    // Get the status and pass rate for each class 
    // whose tests were run by the job. 
    // that correspond to the specified job ID. 
    public static List<ApexTestQueueItem> getQueuedItems(ID jobId) {
        ApexTestQueueItem[] items = [SELECT ApexClass.Name, Status, ExtendedStatus, ParentJobId FROM ApexTestQueueItem WHERE ParentJobId = :jobId];
        for (ApexTestQueueItem item : items) {
            String extStatus = item.extendedstatus == null ? '' : item.extendedStatus;
            System.debug(item.ApexClass.Name + ': ' + item.Status + extStatus);
        }
        
        return items;
    }
    
    
    // Check if all test items are finished.
    public static Boolean isJobCompleted(List<ApexTestQueueItem> testItems){
        
        Boolean isCompleted = true;
        for (ApexTestQueueItem test : testItems){
            if (test.Status != 'Completed' && test.Status != 'Failed' && test.Status != 'Aborted'){
                isCompleted = false;
                break;
            }
        }
        return isCompleted;
    }
    
    
    // Get the result for each test method that was executed. 
    public static List<ApexTestResult> checkMethodStatus(ID jobIds) {
        ApexTestResult[] results = 
            [SELECT Outcome,
             MethodName,
             Message,
             StackTrace,
             AsyncApexJobId, 
             ApexClass.Name,
             ApexClass.Body,
             ApexClass.LengthWithoutComments,
             ApexClass.NamespacePrefix,
             ApexClass.Status,
             ApexLogId,
             ApexLog.DurationMilliseconds,
             ApexLog.Operation,
             ApexLog.Request,
             ApexLog.Status,
             ApexLog.Location,
             ApexLog.Application
             FROM ApexTestResult 
             WHERE AsyncApexJobId = :jobIds];
        
        for (ApexTestResult atr : results) {
            System.debug(atr.ApexClass.Name + '.' + atr.MethodName + ': ' + atr.Outcome);
            if (atr.message != null) {
                System.debug(atr.Message + '\n at ' + atr.StackTrace);
            }
        }
        
        return results;
    }
    
    public static void sendTestResultEmail(List<ApexTestResult> jobTestResults){
        Lcm_ToolingUtil toolingUtil = new Lcm_ToolingUtil();
        if (emailReceipients != null && String.isNotBlank(emailReceipients.P7S1_Recipients__c)){
        	String[] toAddresses = emailReceipients.P7S1_Recipients__c.split(';');
            String sandboxName = cls_P7S1_Utils.getSandboxName(false);
            String emailSubject = '(' + (sandboxName.length() > 0 ? sandboxName : 'Prod') + ') Unit Test Results ' + String.valueOf(Date.today());
            String testResultEmailbody = getTestResultHtmlEmailBody(jobTestResults);
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setFileAttachments(new Messaging.EmailFileAttachment[]{toolingUtil.getCoverageCsvAsEmailAttachment()});
            mail.setToAddresses(toAddresses);
            mail.setSubject(emailSubject); 
            mail.setHtmlBody(testResultEmailbody);
            Messaging.sendEmail(new Messaging.Email[] { mail });
        } else {
            throw new AutomatedTestsException(EXCEPTION_NO_EMAIL_ADDRESS);
        }
    }
    
    
    private static String getTestResultHtmlEmailBody(List<ApexTestResult> jobTestResults){
        
        if (Test.isRunningTest()) {
            jobTestResults = new List<ApexTestResult>();
            jobTestResults.add(new ApexTestResult(Outcome = 'Pass'));
            jobTestResults.add(new ApexTestResult(Outcome = 'Fail'));
        }
        
        List<ApexTestResult> successTests = new List<ApexTestResult>();
        List<ApexTestResult> failedTests = new List<ApexTestResult>();
        
        for (ApexTestResult jobTestResult : jobTestResults){
            if (jobTestResult.Outcome == 'Pass'){
                successTests.add(jobTestResult);
            }
            else{
                failedTests.add(jobTestResult);
            }
        }
        
        Integer numTestsRun = successTests.size() + failedTests.size();
        Integer numFailures = failedTests.size();
        Integer successNum = numTestsRun - numFailures;
        
        if (successNum < 0){
            successNum = 0;
        }
        
        
        String testResultBody = '<table border="1"><tr><td>Tests Run:</td><td>Failure Count:</td><td>Success Count:</td></tr>';
        testResultBody += '<tr>';
        testResultBody += '<td style="padding: 5px; vertical-align: top;">' + numTestsRun 	+ '</td>';
        testResultBody += '<td style="padding: 5px; vertical-align: top;">' + numFailures 	+ '</td>';
        testResultBody += '<td style="padding: 5px; vertical-align: top;">' + successNum 	+ '</td>';
        testResultBody += '</tr></table>';
        
        return testResultBody;
    }
    class AutomatedTestsException extends Exception {}
}