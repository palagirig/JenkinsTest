/**
 * Import any delivery data (RSD, RS, Lifetime, DeliveryData (daily + monthly))
 * @author	stefan.voss@advendio.com
**/
global with sharing class Adv_CampaignItem_DeliveryDataImport {

    /**
     * start importing delivery data for given campaign / campaign items
	 * @param	campaignId		- a media campaign id
	 * @param	campaignItemIds	- a list campaign item ids
	 * @param	endpoint		- salesforce enterprise url
	 * @param	sessionId		- user session id
	 * @param	orgId			- salesforce organization id
	**/
	webservice static String doDeliveryDataImport(Id campaignId, String campaignItemIds, String endpoint, String sessionId, String orgId) {
        try {
            // ADvendio report service types
            List<String> reportTypes	= new List<String>{'total','monthlysite', 'dailysite'};
			for (String reportType : reportTypes) {
				sendRequest(reportType, campaignId, campaignItemIds, endpoint, sessionId, orgId);
			}

			return null;
		}
		catch(Exception e) {
			return e.getMessage();
		}
	}

    /** Create an HttpRequest with given session or salesforce url. **/
	private static HttpRequest createRequest(String reportType, Id campaignId, String itemIds, String endpoint, String sessionId, String orgId) {
		String serviceURL	= System.Label.ADvendio.ServiceURL + 'MediaCloudServlets_' + System.Label.ADvendio.ServiceVersion + '/MediaCloudService';
        
        if (sessionId == null) {
            sessionId	= UserInfo.getSessionId();
        }
        if (orgId == null) {
            orgId	= UserInfo.getOrganizationId();
        }
        
		serviceURL += '?operation=statistic';
		serviceURL += '&endpoint='		+ Encodingutil.urlEncode(endpoint,					'UTF-8');
		serviceURL += '&orgid='			+ Encodingutil.urlEncode(orgId,						'UTF-8');
		serviceURL += '&sessionid='		+ Encodingutil.urlEncode(sessionId,					'UTF-8');
		serviceURL += '&type='			+ Encodingutil.urlEncode(reportType,				'UTF-8');
		serviceURL += '&smail='			+ Encodingutil.urlEncode(UserInfo.getUserEmail(),	'UTF-8');
		serviceURL += '&fmail='			+ Encodingutil.urlEncode(UserInfo.getUserEmail(),	'UTF-8');
		serviceURL += '&campaignid='	+ Encodingutil.urlEncode(campaignId,				'UTF-8');
		serviceURL += '&recordid='		+ Encodingutil.urlEncode(itemIds,	'UTF-8');
        serviceURL += '&recordid='+itemIds;

        System.url url		= new system.url(serviceURL);
		HttpRequest request	= new HttpRequest();
		request.setMethod('POST');
		request.setEndpoint(serviceURL);
		request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		request.setBody(url.getQuery());
		
		return request;
	}
	
    /** callout for ADvendio service **/
	@future(callout=true)
	private static void sendRequest(String reportType, Id campaignId, String itemIds, String endpoint, String sessionId, String orgId) {
		try {
			HttpResponse result	=	new Http().send( createRequest(reportType, campaignId, itemIds, endpoint, sessionId, orgId) );
		}
		catch(Exception e) {
			system.debug(e);
		}
	}
}