@isTest
public class Adv_CampaignItem_DeliveryDataImport_Test {
	
    @isTest
    private static void testDeliveryDataImport() {
        
        String sessionId	= UserInfo.getSessionId();
        String orgId		= UserInfo.getOrganizationId();
        String sfURL		= Url.getSalesforceBaseUrl().toExternalForm();
        
        ADvendio__MediaCampaign__c mc	= cls_P7S1_TestData.createTestMediaCampaign(true);
        ADvendio__Campaign_Item__c ci	= cls_P7S1_TestData.createTestCampaignItem(false, mc);
        ci.ADvendio__from_Date__c		= Date.newInstance(system.today().year(), 5, 1);
        ci.ADvendio__until_Date__c		= Date.newInstance(system.today().year(), 12, 31);
        insert ci;

        Test.startTest();
        Adv_CampaignItem_DeliveryDataImport.doDeliveryDataImport(mc.Id, ''+ci.Id, sfURL, null, null);
        Test.stopTest();
    }
}