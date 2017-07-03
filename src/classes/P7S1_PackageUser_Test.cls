@isTest
public class P7S1_PackageUser_Test{
    
    public static testMethod void testPackageUserList(){
        
        PageReference p1 = Page.P7S1_PackageUser;
        Test.setCurrentPageReference(p1);
        
        Test.startTest();
        
        P7S1_PackageUser con = new P7S1_PackageUser();
       
        List<User> u_list = P7S1_PackageUser.userlist;
        string p_name = P7S1_PackageUser.PACKAGE_NAME;
        string u_count = P7S1_PackageUser.USER_COUNT;        
        
        Test.stopTest();
        
        system.AssertEquals('advendio',p_name);
        system.Assert(!u_list.isEmpty());
        system.AssertEquals(u_count,string.valueOf(u_list.size()));
    }
}