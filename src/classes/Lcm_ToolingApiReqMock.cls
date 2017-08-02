@isTest
global class Lcm_ToolingApiReqMock implements HttpCalloutMock {
    String fakeBody{get;set;}
    Integer statusCode {get;set;}
    
    global Lcm_ToolingApiReqMock(String bodyAsString){
    	this.fakebody = bodyAsString;
        this.statusCode = 200;
    }
    global Lcm_ToolingApiReqMock(String bodyAsString, Integer statusCode){
    	this.fakebody = bodyAsString;
        this.statusCode = statusCode;
    }    
    global HTTPResponse respond(HTTPRequest req) {
        system.debug('req + ' + req);
        system.debug('fakeBody ' + fakeBody);
        
		HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(fakeBody);
        res.setStatusCode(StatusCode);
        return res;
    }
}