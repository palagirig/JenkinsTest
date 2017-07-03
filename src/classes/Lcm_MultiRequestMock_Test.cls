@isTest
public class Lcm_MultiRequestMock_Test implements HttpCalloutMock {
	Map<String, HttpCalloutMock> requests;

	public Lcm_MultiRequestMock_Test(Map<String, HttpCalloutMock> requests) {
		this.requests = requests;
	}
	public HTTPResponse respond(HTTPRequest req) {
		system.debug('###Lcm_MultiRequestMock_Test req : ' + req);
        HttpCalloutMock mock = requests.get(req.getEndpoint());
        system.debug('###Lcm_MultiRequestMock_Test HttpCalloutMock : ' + mock);
		if (mock != null) {
			return mock.respond(req);
		} else {
    		throw new Lcm_MultiRequestMockException('Mock Excetion No Mock for url found');
		}
	}
	public void addRequestMock(String url, HttpCalloutMock mock) {
		requests.put(url, mock);
	}
    class Lcm_MultiRequestMockException extends Exception{
        
    }
}