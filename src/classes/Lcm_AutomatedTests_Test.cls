@isTest
public class Lcm_AutomatedTests_Test {
    public static final String RESP_RUNTESTS = '"7074E000002Y0uyAAQ"';
    public static final String RESP_AGGREGATE = '{"size":5,"totalSize":5,"done":true,"queryLocator":null,"entityTypeName":"ApexCodeCoverageAggregate","records":[{"attributes":{"type":"ApexCodeCoverageAggregate","url":"/services/data/v36.0/tooling/sobjects/ApexCodeCoverageAggregate/715D0000000CsuJIAS"},"ApexClassOrTrigger":{"attributes":{"type":"Name","url":"/services/data/v36.0/tooling/sobjects/ApexClass/01pD0000000KB9PIAW"},"Type":"01p","Name":"z_SchedulableBatchableMetadataDump1","Id":"01pD0000000KB9PIAW"},"Coverage":{"coveredLines":[],"uncoveredLines":[]},"NumLinesCovered":0,"NumLinesUncovered":13},{"attributes":{"type":"ApexCodeCoverageAggregate","url":"/services/data/v36.0/tooling/sobjects/ApexCodeCoverageAggregate/715D0000000CtLAIA0"},"ApexClassOrTrigger":{"attributes":{"type":"Name","url":"/services/data/v36.0/tooling/sobjects/ApexTrigger/01qD0000000QFn4IAG"},"Type":"01q","Name":"User","Id":"01qD0000000QFn4IAG"},"Coverage":{"coveredLines":[],"uncoveredLines":[3,6]},"NumLinesCovered":0,"NumLinesUncovered":2},{"attributes":{"type":"ApexCodeCoverageAggregate","url":"/services/data/v36.0/tooling/sobjects/ApexCodeCoverageAggregate/715D0000000CtLBIA0"},"ApexClassOrTrigger":{"attributes":{"type":"Name","url":"/services/data/v36.0/tooling/sobjects/ApexClass/01pD0000000KZoVIAW"},"Type":"01p","Name":"cls_P7S1_Utils","Id":"01pD0000000KZoVIAW"},"Coverage":{"coveredLines":[],"uncoveredLines":[]},"NumLinesCovered":0,"NumLinesUncovered":0},{"attributes":{"type":"ApexCodeCoverageAggregate","url":"/services/data/v36.0/tooling/sobjects/ApexCodeCoverageAggregate/715D0000000CtLCIA0"},"ApexClassOrTrigger":{"attributes":{"type":"Name","url":"/services/data/v36.0/tooling/sobjects/ApexClass/01pD0000000KaJsIAK"},"Type":"01p","Name":"cls_P7S1_GroupMember_SphereProfile","Id":"01pD0000000KaJsIAK"},"Coverage":{"coveredLines":[],"uncoveredLines":[]},"NumLinesCovered":0,"NumLinesUncovered":0},{"attributes":{"type":"ApexCodeCoverageAggregate","url":"/services/data/v36.0/tooling/sobjects/ApexCodeCoverageAggregate/715D0000000CtPuIAK"},"ApexClassOrTrigger":{"attributes":{"type":"Name","url":"/services/data/v36.0/tooling/sobjects/ApexTrigger/01qD0000000QGTvIAO"},"Type":"01q","Name":"Ven_FinancialModelVersion","Id":"01qD0000000QGTvIAO"},"Coverage":{"coveredLines":[],"uncoveredLines":[3,4]},"NumLinesCovered":0,"NumLinesUncovered":2}]}';
    public static final String RESP_ORGWIDE_COVERAGE = '{"size":1,"totalSize":1,"done":true,"queryLocator":null,"entityTypeName":"ApexOrgWideCoverage","records":[{"attributes":{"type":"ApexOrgWideCoverage","url":"/services/data/v36.0/tooling/sobjects/ApexOrgWideCoverage/716D00000008OQYIA2"},"Id":"716D00000008OQYIA2","PercentCovered":37}]}';
    
    
    @isTest
    public static void coverExecute()
    {
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        Test.startTest();   
        system.schedule('TestJob', CRON_EXP, new Lcm_AutomatedTests_Run());
        Test.stopTest();
    }
    
    
    @isTest
    public static void test_Failure()
    {
        system.assertEquals(NULL, P7S1_Settings__c.getOrgDefaults().Id);
        insert new P7S1_Settings__c();
        system.assertNotEquals(NULL, P7S1_Settings__c.getOrgDefaults().Id);
        
        Test.startTest();
        Lcm_AutomatedTests_Run.runLocalTestsAsync();
        Test.stopTest();
        
        system.assertNotEquals(NULL, P7S1_Settings__c.getOrgDefaults().Lcm_AutoTestExecError__c);
        system.assertEquals(NULL, P7S1_Settings__c.getOrgDefaults().P7S1_AutoTestQueueAsyncId__c);
        
    }
    
    @isTest
    public static void test_Success() {
        Lcm_ToolingApiReqMock fakeExecuteTestsResp = new Lcm_ToolingApiReqMock(RESP_RUNTESTS);
        Test.setMock(HttpCalloutMock.class, fakeExecuteTestsResp);
        
        system.assertEquals(NULL, P7S1_Settings__c.getOrgDefaults().Id);
        insert new P7S1_Settings__c();
        system.assertNotEquals(NULL, P7S1_Settings__c.getOrgDefaults().Id);
        
        Test.startTest();
        
        // Schedule the test job
        //String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new Lcm_AutomatedTests_Run());
        Lcm_AutomatedTests_Run.runLocalTestsAsync();
        Test.stopTest();
        P7S1_Settings__c setting = P7S1_Settings__c.getInstance();
        
        system.assertNotEquals(NULL,setting);
        system.assert(RESP_RUNTESTS.contains(setting.P7S1_AutoTestQueueAsyncId__c));
        system.assertEquals(NULL, P7S1_Settings__c.getOrgDefaults().Lcm_AutoTestExecError__c);
    }	
    
    @isTest
    public static void processAsyncResults() {
        Lcm_ToolingApiReqMock fakeOrgwideResp = new Lcm_ToolingApiReqMock(RESP_ORGWIDE_COVERAGE);
        Lcm_ToolingApiReqMock fakeAggregateResp = new Lcm_ToolingApiReqMock(RESP_AGGREGATE);
        
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(Lcm_ToolingUtil.INSTANCE_BASE_URL+Lcm_ToolingUtil.TOOLING_API_PATH_QUERY+Lcm_ToolingUtil.ORGWIDE_COVERAGE_QUERY,fakeOrgwideResp);
        endpoint2TestResp.put(Lcm_ToolingUtil.INSTANCE_BASE_URL+Lcm_ToolingUtil.TOOLING_API_PATH_QUERY+Lcm_ToolingUtil.CODE_COVERAGE_AGG_QUERY,fakeAggregateResp);
        
        Lcm_MultiRequestMock_Test multiCalloutMock = new Lcm_MultiRequestMock_Test(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Test.startTest();
        Lcm_AutomatedTests_Results.processAsyncResults(); 
        Test.stopTest();
            
    }
    
    @testSetup
    public static void setup(){
        insert new P7S1_EmailRecipients__c
            (
                Name='Lcm Automated Tests',
                P7S1_Recipients__c='listl@ambuorg.de;test@ambuorg.de',
                P7S1_Location__c='Lcm_AutomatedTests_Test'
            );
        Lcm_ToolingUtil_Test.createTestdata();
    }
}