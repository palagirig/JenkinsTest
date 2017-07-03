/**
* Util class with methods for SFDC Tooling API
* Check if the right Base Url is set and the Remote Site Settings allows to make the callout
*
* @author  Sebastian Listl
* @version 0.1, 2014-10-15
* created 2016-06-27 - sli
* lastmod 2016-06-30 - sli
* 
*/
@isTest
public class Lcm_ToolingUtil_Test {
	static final String RESP_AGGREGATE = '{"size":5,"totalSize":5,"done":true,"queryLocator":null,"entityTypeName":"ApexCodeCoverageAggregate","records":[{"attributes":{"type":"ApexCodeCoverageAggregate","url":"/services/data/v36.0/tooling/sobjects/ApexCodeCoverageAggregate/715D0000000CsuJIAS"},"ApexClassOrTrigger":{"attributes":{"type":"Name","url":"/services/data/v36.0/tooling/sobjects/ApexClass/01pD0000000KB9PIAW"},"Type":"01p","Name":"z_SchedulableBatchableMetadataDump1","Id":"01pD0000000KB9PIAW"},"Coverage":{"coveredLines":[],"uncoveredLines":[]},"NumLinesCovered":0,"NumLinesUncovered":13},{"attributes":{"type":"ApexCodeCoverageAggregate","url":"/services/data/v36.0/tooling/sobjects/ApexCodeCoverageAggregate/715D0000000CtLAIA0"},"ApexClassOrTrigger":{"attributes":{"type":"Name","url":"/services/data/v36.0/tooling/sobjects/ApexTrigger/01qD0000000QFn4IAG"},"Type":"01q","Name":"User","Id":"01qD0000000QFn4IAG"},"Coverage":{"coveredLines":[],"uncoveredLines":[3,6]},"NumLinesCovered":0,"NumLinesUncovered":2},{"attributes":{"type":"ApexCodeCoverageAggregate","url":"/services/data/v36.0/tooling/sobjects/ApexCodeCoverageAggregate/715D0000000CtLBIA0"},"ApexClassOrTrigger":{"attributes":{"type":"Name","url":"/services/data/v36.0/tooling/sobjects/ApexClass/01pD0000000KZoVIAW"},"Type":"01p","Name":"cls_P7S1_Utils","Id":"01pD0000000KZoVIAW"},"Coverage":{"coveredLines":[],"uncoveredLines":[]},"NumLinesCovered":0,"NumLinesUncovered":0},{"attributes":{"type":"ApexCodeCoverageAggregate","url":"/services/data/v36.0/tooling/sobjects/ApexCodeCoverageAggregate/715D0000000CtLCIA0"},"ApexClassOrTrigger":{"attributes":{"type":"Name","url":"/services/data/v36.0/tooling/sobjects/ApexClass/01pD0000000KaJsIAK"},"Type":"01p","Name":"cls_P7S1_GroupMember_SphereProfile","Id":"01pD0000000KaJsIAK"},"Coverage":{"coveredLines":[],"uncoveredLines":[]},"NumLinesCovered":0,"NumLinesUncovered":0},{"attributes":{"type":"ApexCodeCoverageAggregate","url":"/services/data/v36.0/tooling/sobjects/ApexCodeCoverageAggregate/715D0000000CtPuIAK"},"ApexClassOrTrigger":{"attributes":{"type":"Name","url":"/services/data/v36.0/tooling/sobjects/ApexTrigger/01qD0000000QGTvIAO"},"Type":"01q","Name":"Ven_FinancialModelVersion","Id":"01qD0000000QGTvIAO"},"Coverage":{"coveredLines":[],"uncoveredLines":[3,4]},"NumLinesCovered":0,"NumLinesUncovered":2}]}';
    static final String RESP_ORGWIDE_COVERAGE = '{"size":1,"totalSize":1,"done":true,"queryLocator":null,"entityTypeName":"ApexOrgWideCoverage","records":[{"attributes":{"type":"ApexOrgWideCoverage","url":"/services/data/v36.0/tooling/sobjects/ApexOrgWideCoverage/716D00000008OQYIA2"},"Id":"716D00000008OQYIA2","PercentCovered":37}]}';
    static final String RESP_ACCESS_TOKEN = '{"id":"https://login.salesforce.com/id/00Dx0000000BV7z/005x00000012Q9P","issued_at":"1278448832702","instance_url":"https://yourInstance.salesforce.com/","signature":"0CmxinZir53Yex7nE0TD+zMpvIWYGb/bdJh6XfOH6EQ=","access_token":"9ye6PE3Ds1eQz3z8jr3W7_VbWmEu4Q8TVGSTHxs","token_type":"Bearer"}';
    static final String RESP_RUN_ALL_TESTS = '0704E0000002CQIP';
    static final String RESP_RUN_ALL_TESTS_FAILED = '{"message":"This test is already in the execution queue.","errorCode":"ALREADY_IN_PROCESS"}';
    
    static final String CSV_STRING_EXPECTED = 'APEX Organisationwide Coverage\n\nId,Coverage\n716D00000008OQYIA2,37\n\nAPEX Code Coverage Aggregate\n\nId,Name,Type,Coverage,Lines,NumLinesCovered,NumLinesUncovered\n01pD0000000KB9PIAW,z_SchedulableBatchableMetadataDump1,trigger,0.0 %,13,0,13\n01qD0000000QFn4IAG,User,class,0.0 %,2,0,2\n01pD0000000KZoVIAW,cls_P7S1_Utils,trigger,0.0 %,0,0,0\n01pD0000000KaJsIAK,cls_P7S1_GroupMember_SphereProfile,trigger,0.0 %,0,0,0\n01qD0000000QGTvIAO,Ven_FinancialModelVersion,class,0.0 %,2,0,2\n';
    static Lcm_ToolingUtil TOOLING_UTIL {get;set;}    
    
    @testSetup
	public static void createTestdata(){
        insert new Lcm_ToolingApi__c(
            Name = 'Default',
            Lcm_ApiVersion__c = 37.0,
            Lcm_ApiPassword__c	='pwd',
			Lcm_ApiClientId__c = '3MV',	
			Lcm_ApiClientSecret__c = '123',
			Lcm_ApiUsername__c = 'test@ambuorg.de',
			Lcm_ApiName__c = 'lcm-app');
    }
    
    @isTest 
    static void toolingOrgwide() {
        TOOLING_UTIL = new Lcm_ToolingUtil();
        // Set mock callout class 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Lcm_ToolingApiReqMock(RESP_ORGWIDE_COVERAGE));       
        Lcm_Tooling.Result toolingResult = TOOLING_UTIL.tooling('code-coverage','orgwide');
        System.assert(toolingResult.success);
        System.assertEquals(200,toolingResult.statusCode);
        System.assertEquals(RESP_ORGWIDE_COVERAGE,toolingResult.message);
    	Test.stopTest();
    }
    @isTest 
    static void toolingOrgwideException() {
        TOOLING_UTIL = new Lcm_ToolingUtil();
        // Set mock callout class 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Lcm_ToolingApiReqMock('asdfsafd'));       
        TOOLING_UTIL.tooling('code-coverage','orgwide');
    	Test.stopTest();
    }
    @isTest 
    static void toolingAggregate() {
        TOOLING_UTIL = new Lcm_ToolingUtil();
        // Set mock callout class 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Lcm_ToolingApiReqMock(RESP_AGGREGATE,200));
        Lcm_Tooling.Result toolingResult = TOOLING_UTIL.tooling('code-coverage','aggregate');
        System.assert(toolingResult.success);
        System.assertEquals(200,toolingResult.statusCode);
        System.assertEquals(RESP_AGGREGATE,toolingResult.message);

		Test.stopTest();
    }
    @isTest 
    static void toolingAggregateException() {
        TOOLING_UTIL = new Lcm_ToolingUtil();
        // Set mock callout class 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Lcm_ToolingApiReqMock('blabla',200));       
        TOOLING_UTIL.tooling('code-coverage','aggregate');
    	Test.stopTest();
    }
    
    @isTest 
    static void writeCoverageCsv() {
		TOOLING_UTIL = new Lcm_ToolingUtil();
        Lcm_ToolingApiReqMock fakeAccessTokenResp = new Lcm_ToolingApiReqMock(RESP_ACCESS_TOKEN,200);
        Lcm_ToolingApiReqMock fakeOrgwideResp = new Lcm_ToolingApiReqMock(RESP_ORGWIDE_COVERAGE,200);
        Lcm_ToolingApiReqMock fakeAggregateResp = new Lcm_ToolingApiReqMock(RESP_AGGREGATE,200);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        
        
        endpoint2TestResp.put(Lcm_ToolingUtil.INSTANCE_BASE_URL+Lcm_ToolingUtil.TOKEN_PATH,fakeAccessTokenResp);
        endpoint2TestResp.put(Lcm_ToolingUtil.INSTANCE_BASE_URL+Lcm_ToolingUtil.TOOLING_API_PATH_QUERY+Lcm_ToolingUtil.ORGWIDE_COVERAGE_QUERY,fakeOrgwideResp);
        endpoint2TestResp.put(Lcm_ToolingUtil.INSTANCE_BASE_URL+Lcm_ToolingUtil.TOOLING_API_PATH_QUERY+Lcm_ToolingUtil.CODE_COVERAGE_AGG_QUERY,fakeAggregateResp);

        Lcm_MultiRequestMock_Test multiCalloutMock = new Lcm_MultiRequestMock_Test(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
                     
        Test.startTest();
       	String csvOutput = TOOLING_UTIL.writeCoverageCsv();
        
        System.assert(csvOutput.contains('APEX Organisationwide Coverage'));
        System.assert(csvOutput.contains('Id,Coverage'));
    	System.assert(csvOutput.contains('APEX Code Coverage Aggregate'));
        System.assert(csvOutput.contains('Id,Name,Type,Coverage,Lines,NumLinesCovered,NumLinesUncovered'));
        System.assert(csvOutput.contains('01pD0000000KB9PIAW,z_SchedulableBatchableMetadataDump1,trigger,0.0 %,13,0,13'));
        System.assert(csvOutput.contains('01qD0000000QFn4IAG,User,class,0.0 %,2,0,2'));
        System.assert(csvOutput.contains('01pD0000000KZoVIAW,cls_P7S1_Utils,trigger,0.0 %,0,0,0'));
        System.assert(csvOutput.contains('01pD0000000KaJsIAK,cls_P7S1_GroupMember_SphereProfile,trigger,0.0 %,0,0,0'));
        System.assert(csvOutput.contains('01qD0000000QGTvIAO,Ven_FinancialModelVersion,class,0.0 %,2,0,2'));
        
        Test.stopTest();
    }
    @isTest
    private static void getCoverageCsvAsEmailAttachment(){
        TOOLING_UTIL = new Lcm_ToolingUtil();
        Test.startTest();
        Messaging.EmailFileAttachment emailAttachment = TOOLING_UTIL.getCoverageCsvAsEmailAttachment();
        system.assert(emailAttachment != null);
    	Test.stopTest();
    } 
    @isTest
    private static void getAccessToken(){
        Test.setMock(HttpCalloutMock.class, new Lcm_ToolingApiReqMock(RESP_ACCESS_TOKEN));
        Test.startTest();
        system.assertEquals('9ye6PE3Ds1eQz3z8jr3W7_VbWmEu4Q8TVGSTHxs',Lcm_ToolingUtil.getAccessToken());
    	Test.stopTest();
    }  
    @isTest
    private static void getAccessTokenException(){
        Test.startTest();
        system.assert( Lcm_ToolingUtil.getAccessToken().startsWith('!ERROR'));
    	Test.stopTest();
    }  
    @isTest
    private static void runAllTests(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Lcm_ToolingApiReqMock(RESP_RUN_ALL_TESTS));       
        Lcm_Tooling.Result toolingResult = new Lcm_ToolingUtil().tooling('run-tests',null);
        
        system.assertEquals(RESP_RUN_ALL_TESTS,toolingResult.message);
    	Test.stopTest();
    }
}