@isTest
public class SomDig_PartnerWSDL_Test {
	@isTest (seeAllData=false)
    public static void testWSDL() {
        String user		= '';
        String pass		= '';
        String token	= '';
        String session	= '';
        
        SomDig_PartnerWSDL.Soap handle				= new SomDig_PartnerWSDL.Soap();
        SomDig_PartnerWSDL.LoginResult loginResult	= handle.login(user, pass);
        handle.getUserInfo();
        handle.invalidateSessions(new String[] {session});
        
        new SomDig_PartnerWSDL.LimitInfo();
        new SomDig_PartnerWSDL.SearchResult();
        new SomDig_PartnerWSDL.LoginScopeHeader_element();
        new SomDig_PartnerWSDL.InvalidateSessionsResult();
        new SomDig_PartnerWSDL.NameValuePair();
        new SomDig_PartnerWSDL.Error();
        new SomDig_PartnerWSDL.SearchSnippet();
        new SomDig_PartnerWSDL.SessionHeader_element();
        
        new SomDig_PartnerWSDL.LoginResult();
        new SomDig_PartnerWSDL.sObject_x();
        new SomDig_PartnerWSDL.LimitInfoHeader_element();
        new SomDig_PartnerWSDL.GetUserInfoResult();
        new SomDig_PartnerWSDL.SearchRecord();
        new SomDig_PartnerWSDL.LimitInfo();
        new SomDig_PartnerWSDL.CallOptions_element();
    }
}