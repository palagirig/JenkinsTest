/**
* Util class with methods for SFDC Tooling API
* Check if the right Baseurl is set and the Remotesitesettings allows to make the callout
*
* @author  Sebastian Listl
* @version 0.1
* created 2016-06-27 - sli
* lastmod 2016-07-05 - sli
* 
*/
global with sharing class Lcm_ToolingUtil {
    
    public static String ID_PREFIX_CLASS = '01q';
    public static String ID_PREFIX_TRIGGER = '01p';
	public static String TOOLING_CMD_CODE_COVERAGE = 'code-coverage';
	public static String TOOLING_CMD_TEST_RUN = 'run-tests';
    public static String TOOLING_ARGV_ORGWIDE = 'orgwide';
    public static String TOOLING_ARGV_AGGREGATE = 'aggregate';
    //public static String TOOLING_ARGV_ALL_LOCAL = '';
	public static String HTTP_MTH_GET = 'GET';
	public static String HTTP_MTH_POST = 'POST';
    /*** SETTING FROM CS ***/
    public static Lcm_ToolingApi__c TOOLING_API_SETTINGS = Lcm_ToolingApi__c.getInstance('Default'); 
    public static String USERNAME = TOOLING_API_SETTINGS.Lcm_ApiUsername__c + cls_P7S1_Utils.getSandboxname(true) ;
    public static String PASSWORD = TOOLING_API_SETTINGS.Lcm_ApiPassword__c; 
    public static String CLIENT_ID = TOOLING_API_SETTINGS.Lcm_ApiClientId__c;
    public static String SECRET = TOOLING_API_SETTINGS.Lcm_ApiClientSecret__c;
	public static String API_VERSION = 'v'+TOOLING_API_SETTINGS.Lcm_ApiVersion__c;
	/*** URLS ***/
    public static String INSTANCE_BASE_URL = URL.getSalesforceBaseUrl().toExternalForm();
    public static String TOKEN_PATH = '/services/oauth2/token';
	public static String TOOLING_API_BASE_PATH = '/services/data/'+API_VERSION+'/tooling/';
	public static String TOOLING_API_PATH_RUN_TESTS_ASYNC = TOOLING_API_BASE_PATH + 'runTestsAsynchronous/';
	public static String TOOLING_API_PATH_QUERY = TOOLING_API_BASE_PATH + 'query/?q=';
	public static String ORGWIDE_COVERAGE_QUERY = 'Select+Id,+PercentCovered+FROM+ApexOrgWideCoverage';
	public static String CODE_COVERAGE_AGG_QUERY = 'SELECT+ApexClassOrTrigger.Type,+ApexClassOrTrigger.Name,+ApexClassOrTrigger.Id,+Coverage,+NumLinesCovered,+NumLinesUncovered+FROM+ApexCodeCoverageAggregate';
	
	
	/*** CSV AND FILE NAMES ***/
    public static String CSV_SEPERATOR = ',';
    public static String CSV_NEWLINE = '\n';
	public static String CSV_FILENAME_OUTPUT = 'code-coverage-aggregate';
	public static String CSV_FILENAME_SUFFIX = '.csv';
    public static String FILENAME_ERROR = 'error.txt';
    /*
   	String sessionId {get;set;}
    public Lcm_ToolingUtil( String sessionId ){
        this.sessionId = sessionId;
    }
    public Lcm_ToolingUtil(){
    }
	*/
    public Lcm_Tooling.Result tooling(String command, String argv){
        system.debug('### Lcm_ToolingUtil - tooling - entering - TOOLING_API_SETTINGS  :' + TOOLING_API_SETTINGS);
		Lcm_Tooling.Result toolingResult = new Lcm_Tooling.Result();
        //String status = 'failed';
        try {
        	HttpRequest request = null;    
			if (command.equals(TOOLING_CMD_CODE_COVERAGE)){
				String url = INSTANCE_BASE_URL + TOOLING_API_PATH_QUERY;
                if (argv.equals(TOOLING_ARGV_ORGWIDE)){
					url += ORGWIDE_COVERAGE_QUERY;
                    request = getHttpRequest(url,HTTP_MTH_GET);
				}
                if (argv.equals(TOOLING_ARGV_AGGREGATE)){
					url += CODE_COVERAGE_AGG_QUERY;
                    request = getHttpRequest(url,HTTP_MTH_GET);
				}
				
			}
			if (command.equals(TOOLING_CMD_TEST_RUN)){
               	String url = INSTANCE_BASE_URL + TOOLING_API_PATH_RUN_TESTS_ASYNC;	
                request = getHttpRequest(url,HTTP_MTH_POST,'{"tests":null,"testLevel":"RunLocalTests"}');
			}
            if (request != null){
				Http http = new Http();
				system.debug('### Lcm_ToolingUtil - tooling - request : ' + request);
                HttpResponse response = http.send(request);
				////System.HttpResponse[Status=Bad Request, StatusCode=400]
                if (response.getStatusCode() == 200){
                    toolingResult = new Lcm_Tooling.Result(true,response.getStatusCode(), response.getBody());
                	system.debug('### Lcm_ToolingUtil - tooling - status 200 toolingResult : ' + toolingResult);
                } else {
                    toolingResult = new Lcm_Tooling.Result(false,response.getStatusCode(), response.getBody());
                    system.debug('### Lcm_ToolingUtil - tooling - status !200 toolingResult : ' + toolingResult);
                }
            }
		} catch(Exception e){
			system.debug(logginglevel.debug, '### Lcm_ToolingUtil - tooling - Exception : '+e);
            toolingResult = new Lcm_Tooling.Result(false,666, ''+e);
		}
		
		return toolingResult;			
	}
    /*
    public static string executeTests(){
    	HttpRequest request = new HttpRequest();
    	String accessToken = UserInfo.getSessionID() != null ? UserInfo.getSessionID() : getAccessToken();
		request.setHeader('Authorization', 'Bearer ' + accessToken);
		request.setHeader('Content-Type', 'application/json');
    	request.setEndpoint(INSTANCE_BASE_URL+'/services/data/v37.0/tooling/runTestsAsynchronous/');
        request.setMethod(HTTP_MTH_POST);
		request.setBody('{"tests":null,"testLevel":"RunLocalTests"}');
		
		Http http = new Http();
		system.debug('### Lcm_ToolingUtil - tooling - request : ' + request);
        HttpResponse response = http.send(request);
		system.debug('### Lcm_ToolingUtil - tooling - response : ' + response);
		String returnValue = response.getBody().replace('"','')
    	return returnValue;
    }
    */
    public String writeCoverageCsv(){
        String csvAsString = '';
        String apexOrgWideCoverageAsJson = '';
        String apexCodeCoverageAggregateAsJson = '';
        try {
            /*** orgwide coverage ***/
            Lcm_Tooling.Result toolingResultOrgWideCoverage = tooling(TOOLING_CMD_CODE_COVERAGE, 'orgwide');
            system.debug('### Lcm_ToolingUtil - writeCoverageCsv - csvAsString after toolingResultOrgWideCoverage : ' + toolingResultOrgWideCoverage);
            if (toolingResultOrgWideCoverage.success){
                system.debug('### Lcm_ToolingUtil - writeCoverageCsv - toolingResultOrgWideCoverage.message : ' + toolingResultOrgWideCoverage.message);
            	ApexOrgWideCoverageResponse apexOrgWideCoverages = (ApexOrgWideCoverageResponse) JSON.deserialize(toolingResultOrgWideCoverage.message, ApexOrgWideCoverageResponse.class);
				csvAsString += writeOrgwideCovage(apexOrgWideCoverages.records);
                system.debug('### Lcm_ToolingUtil - writeCoverageCsv - apexOrgWideCoverages : ' + apexOrgWideCoverages);
            } else {
                csvAsString += writeToolingResultInCsv('APEX Organisationwide Coverage', toolingResultOrgWideCoverage);
            }
            system.debug('### Lcm_ToolingUtil - writeCoverageCsv - csvAsString after orgWideCoverage : ' + csvAsString);
            
            Lcm_Tooling.Result toolingResultCodeCoverageAggregate = tooling(TOOLING_CMD_CODE_COVERAGE, 'aggregate');
            if (toolingResultCodeCoverageAggregate.success){
                system.debug('### Lcm_ToolingUtil - writeCoverageCsv - toolingResultCodeCoverageAggregate.message : ' + toolingResultCodeCoverageAggregate.message);
            	ApexCodeCoverageAggregateResponse apexCodeCoverageAggregates = (ApexCodeCoverageAggregateResponse) JSON.deserialize(toolingResultCodeCoverageAggregate.message,ApexCodeCoverageAggregateResponse.class);            
				csvAsString += writeApexCodeCoverageAggregate(apexCodeCoverageAggregates.records);
                system.debug('### Lcm_ToolingUtil - writeCoverageCsv - apexCodeCoverageAggregates : ' + apexCodeCoverageAggregates);
            } else {
                csvAsString += writeToolingResultInCsv('Code Coverage Aggregate', toolingResultCodeCoverageAggregate);
            }
            system.debug('### Lcm_ToolingUtil - writeCoverageCsv - csvAsString after codeCoverageAggregates : ' + csvAsString);
            
        	/*
            apexOrgWideCoverageAsJson = tooling(TOOLING_CMD_CODE_COVERAGE, 'orgwide');
			system.debug('apexOrgWideCoverageAsJson : ' + apexOrgWideCoverageAsJson);
            
            ApexOrgWideCoverageResponse apexOrgWideCoverages = (ApexOrgWideCoverageResponse) JSON.deserialize(apexOrgWideCoverageAsJson,ApexOrgWideCoverageResponse.class);
			system.debug('apexOrgWideCoverages : ' + apexOrgWideCoverages);
            
            csvAsString += writeOrgwideCovage(apexOrgWideCoverages.records);
            system.debug('csvAsString 1: ' + csvAsString);
            */
			/*** Coverage from the classes ***/
            /*
            apexCodeCoverageAggregateAsJson = tooling(TOOLING_CMD_CODE_COVERAGE, 'aggregate');
            system.debug('apexCodeCoverageAggregateAsJson : ' + apexCodeCoverageAggregateAsJson);
            
            ApexCodeCoverageAggregateResponse apexCodeCoverageAggregates = (ApexCodeCoverageAggregateResponse) JSON.deserialize(apexCodeCoverageAggregateAsJson,ApexCodeCoverageAggregateResponse.class);
            system.debug('apexCodeCoverageAggregates : ' + apexCodeCoverageAggregates);
            csvAsString += writeApexCodeCoverageAggregate(apexCodeCoverageAggregates.records);
        	system.debug('csvAsString 2: ' + csvAsString);
            */
        } catch (Exception e){
            system.debug(logginglevel.debug, 'Help me i\'m chrashed in writeCoverageCsv @  Lcm_ToolingUtil : ' + e);
            csvAsString += '!ERROR in writeCoverageCsv @ Lcm_ToolingUtil : ' + e+ CSV_NEWLINE;
            csvAsString += 'apexOrgWideCoverageAsJson @ Lcm_ToolingUtil : ' + apexOrgWideCoverageAsJson + CSV_NEWLINE;
            csvAsString += 'apexCodeCoverageAggregateAsJson @ Lcm_ToolingUtil : ' + apexCodeCoverageAggregateAsJson;
        }
        return csvAsString;
	}
    public Messaging.EmailFileAttachment getCoverageCsvAsEmailAttachment(){
        String content = writeCoverageCsv();
        String name = content.startsWith('!ERROR') ? FILENAME_ERROR : CSV_FILENAME_OUTPUT+CSV_FILENAME_SUFFIX;
        return getStringContentAsEmailAttachment(content, name);
    }
    public Messaging.EmailFileAttachment getStringContentAsEmailAttachment(String content,String name){
        Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
		emailAttachment.setFileName(name);
		emailAttachment.setBody(Blob.valueOf(content));
        emailAttachment.setContentType('text/csv');
        system.debug('emailAttachment : ' + emailAttachment);
        return emailAttachment;
    }
    public String writeToolingResultInCsv(String operation, Lcm_Tooling.Result toolingResult){
        String csvAsString = '!ERROR while ' + operation;
        csvAsString += CSV_NEWLINE;
        csvAsString += 'Status '+ CSV_SEPERATOR + toolingResult.statusCode;
 		csvAsString += CSV_NEWLINE;
        csvAsString += 'Message '+ CSV_SEPERATOR + toolingResult.message;
 		csvAsString += CSV_NEWLINE;
        return csvAsString;
    }
    public String writeOrgwideCovage(ApexOrgWideCoverage[] records){
        String csvAsString = 'APEX Organisationwide Coverage';
 		csvAsString += CSV_NEWLINE;
        csvAsString += CSV_NEWLINE;
        csvAsString += 'Id'+CSV_SEPERATOR+'Coverage';
        csvAsString += CSV_NEWLINE;
        for (ApexOrgWideCoverage record : records){
            csvAsString += record.Id;
            csvAsString += CSV_SEPERATOR;
        	csvAsString += record.PercentCovered;
            csvAsString += CSV_NEWLINE;
        }
        csvAsString += CSV_NEWLINE;
        return csvAsString;
    }
    public String writeApexCodeCoverageAggregate(List<ApexCodeCoverageAggregate> records){
        records.sort();

        String csvAsString = 'APEX Code Coverage Aggregate';
        csvAsString += CSV_NEWLINE;
        csvAsString += CSV_NEWLINE;
        csvAsString += 'Id'+CSV_SEPERATOR+'Name'+CSV_SEPERATOR+'Type'+CSV_SEPERATOR+'Coverage'+CSV_SEPERATOR+'Lines'+CSV_SEPERATOR+'NumLinesCovered'+CSV_SEPERATOR+'NumLinesUncovered';
        csvAsString += CSV_NEWLINE;
        for (ApexCodeCoverageAggregate record : records){
        	if (record.ApexClassOrTrigger != null){
               	csvAsString += record.ApexClassOrTrigger.Id;
               	csvAsString += CSV_SEPERATOR;
               	csvAsString += record.ApexClassOrTrigger.Name;
				csvAsString += CSV_SEPERATOR;
                csvAsString += record.ApexClassOrTrigger.Type;
				csvAsString += CSV_SEPERATOR;
            }
           	csvAsString += (record.codeCoverage+' %');
            csvAsString += CSV_SEPERATOR;
            csvAsString += String.valueOf(record.NumLinesCovered+record.NumLinesUncovered);
            csvAsString += CSV_SEPERATOR;
            csvAsString += String.valueOf(record.NumLinesCovered);
            csvAsString += CSV_SEPERATOR;
            csvAsString += String.valueOf(record.NumLinesUncovered);
            csvAsString += CSV_NEWLINE;
       }
       csvAsString += CSV_NEWLINE;
       return csvAsString;
    }
    public String runAllTests(){
    	return tooling('run-tests',null).message;
    }
    
    /*** Connection ***/
    public HttpRequest getHttpRequest(String endpoint, String method, String body){
    	HttpRequest req = getHttpRequest(endpoint,method);
    	req.setBody(body);
    	return req;
    }
	public HttpRequest getHttpRequest(String endpoint, String method){
        //For better performance make accesstoken cachable cachedAccessToken != null && cachedAccessToken.issued > Datetime.now()-5.... -sli
        String sessionId = UserInfo.getSessionID();
		String accessToken = sessionId != null ? sessionId : getAccessToken();
		//String accessToken = getAccessToken();
        HttpRequest req = new HttpRequest();
		req.setHeader('Authorization', 'Bearer ' + accessToken);
		req.setHeader('Content-Type', 'application/json');
		req.setEndpoint(endpoint);
		req.setMethod(method != null ? method : HTTP_MTH_GET);

		return req;
	}
	/*** Authorize ***/
    public static String getAccessToken(){
        String token = '';
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(INSTANCE_BASE_URL+TOKEN_PATH);
        	req.setMethod(HTTP_MTH_POST);
            req.setBody(buildHttpQuery(new Map<String, String> {
                'grant_type' => 'password',
                'username' => USERNAME,
                'password' => PASSWORD,
                'client_id' => CLIENT_ID,
                'client_secret' => SECRET
            }));
            system.debug('### request body : ' +req.getBody());
            Http http = new Http();
        	HttpResponse resp = http.send(req);

            system.debug('Authorize HTTP response:\n'+resp.getBody());
            
            AccessTokenResponse accessTokenResp = (AccessTokenResponse) JSON.deserialize(resp.getBody(), AccessTokenResponse.class);
       		token = accessTokenResp.access_token;
			system.debug('access token : ' + token );
        } catch (Exception e){
            token = '!ERROR ' + e;
        }
        system.debug('Token: '+token);
        return token;
    }
    private static String buildHttpQuery(Map<String, String> queryParams) {
        if (queryParams.isEmpty()) {
            return '';
        }
        String[] params = new String[] {};
        for (String k : queryParams.keySet()) {
            String v = EncodingUtil.urlEncode(queryParams.get(k), 'UTF-8');
            params.add(String.format('{0}={1}', new String[] { k, v }));
        }
        return String.join(params, '&');
    }
    
    /*** Response Wrapper ***/
    /*
    public abstract class ToolingRestResponse{
        Integer size {get;set;}
    }
	*/
    public class  AccessTokenResponse {
        public String id;	
        public String issued_at;
        public String instance_url;	
        public String signature;	
        public String access_token;	
        public String token_type;
    }
    public class ApexOrgWideCoverageResponse /*extends ToolingRestResponse*/{
        ApexOrgWideCoverage[] records {get;set;}
    }
    public class ApexCodeCoverageAggregateResponse /*extends ToolingRestResponse*/{
        //Integer size {get;set;}
        //Integer totalSize {get;set;}
		//boolean done {get;set;}
        List<ApexCodeCoverageAggregate> records {get;set;}
    }
    
    /*** Json Wrapper Tooling Objects ***/
    public class ApexOrgWideCoverage {
        String Id {get;set;}
        Integer PercentCovered {get;set;}
    }
    global class ApexCodeCoverageAggregate implements Comparable {
        Integer NumLinesUncovered {set;get;}
        Integer NumLinesCovered {set;get;}
        Double codeCoverage {
            get{
                return ((NumLinesCovered + NumLinesUncovered) > 0 ? (Double.valueOf( NumLinesCovered) * 100.00) / Double.valueOf(NumLinesCovered + NumLinesUncovered): 0.0).setScale(2);
           	}
            set;
        }
        ApexClassOrTrigger ApexClassOrTrigger {set;get;}
        
        global Integer compareTo(Object compareToObject) {
            ApexCodeCoverageAggregate compareTo = (ApexCodeCoverageAggregate) compareToObject;
            Integer value;
            if (codeCoverage == compareTo.codeCoverage){
				return 0;
            } 
            if (codeCoverage > compareTo.codeCoverage){
				return 1;
            } 
            return -1;       
    	}
    }
    class ApexClassOrTrigger {
  		//Attributes attributes {set;get;}
        String Type {set;get {
            if (Type == ID_PREFIX_CLASS){
                Type = 'class';
            }
            if (Type == ID_PREFIX_TRIGGER){
                Type = 'trigger';
            } 
            return Type;
        }}
  		String Name {set;get;}
  		String Id {set;get;}
	}
	class Attributes {
  		public String type;
  		public String url;
	}
	
}