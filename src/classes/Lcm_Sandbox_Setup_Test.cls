@isTest
public class Lcm_Sandbox_Setup_Test {

	@testSetup
	static void testSetup(){
		List<User> listUsers = new List<User>();

		User emptyUser = createTestUser();
		emptyUser.Lcm_Sandboxes__c = 'empty';
		listUsers.add(emptyUser);
		
		User vpUser = createTestUser();
		vpUser.Lcm_Sandboxes__c = 'VP';
		listUsers.add(vpUser);
		
		User rkUser = createTestUser();
		rkUser.Lcm_Sandboxes__c = 'VP,Adv,rk';
		listUsers.add(rkUser);
		
		User rkPlusUser = createTestUser();
		rkPlusUser.Lcm_Sandboxes__c = 'VP,Adv,rk*';
		listUsers.add(rkPlusUser);
		
		insert listUsers;
	}

	@isTest
	public static void testVPRefresh(){
		Lcm_Sandbox_Setup classSetup = new Lcm_Sandbox_Setup();
		List<User> listUsers = [SELECT Name, EMail, Lcm_Sandboxes__c FROM User WHERE Alias LIKE 'test' AND Lcm_Sandboxes__c != null];
		for(User oneUser: listUsers){
			System.debug('### Email before Test: '+ oneUser.Email);
		}

		Test.startTest();
			Test.testSandboxPostCopyScript(classSetup, UserInfo.getOrganizationId(), UserInfo.getOrganizationId(), 'VP');
		Test.stopTest();

		listUsers = [SELECT Name, EMail, Lcm_Sandboxes__c FROM User WHERE Alias LIKE 'test' AND Lcm_Sandboxes__c != null];
		
		for(User oneUser: listUsers){
			System.debug('### Email after Test: '+ oneUser.Email);
			if(oneUser.Lcm_Sandboxes__c.contains('VP')){
				System.assert(!oneUser.Email.contains('example.com'),'### Assertion failed: User: '+oneUser.Name+' // EMail: '+oneUser.EMail+' // Sandboxes: '+oneUser.Lcm_Sandboxes__c);
			}else
				System.assert(oneUser.Email.contains('example.com'),'### Assertion failed: User: '+oneUser.Name+' // EMail: '+oneUser.EMail+' // Sandboxes: '+oneUser.Lcm_Sandboxes__c);
		}
	}

	@isTest
	public static void testRKRefresh(){
		Lcm_Sandbox_Setup classSetup = new Lcm_Sandbox_Setup();
		List<User> listUsers = [SELECT Name, EMail, Lcm_Sandboxes__c FROM User WHERE Alias LIKE 'test' AND Lcm_Sandboxes__c != null];
		for(User oneUser: listUsers){
			System.debug('### Email before Test: '+ oneUser.Email);
		}

		Test.startTest();
			Test.testSandboxPostCopyScript(classSetup, UserInfo.getOrganizationId(), UserInfo.getOrganizationId(), 'rk');
		Test.stopTest();

		listUsers = [SELECT Name, EMail, Lcm_Sandboxes__c FROM User WHERE Alias LIKE 'test' AND Lcm_Sandboxes__c != null];
		
		for(User oneUser: listUsers){
			System.debug('### Email after Test: '+ oneUser.Email);
			if(oneUser.Lcm_Sandboxes__c.contains('rk')){
				System.assert(!oneUser.Email.contains('example.com'),'### Assertion failed: User: '+oneUser.Name+' // EMail: '+oneUser.EMail+' // Sandboxes: '+oneUser.Lcm_Sandboxes__c);
			}else
				System.assert(oneUser.Email.contains('example.com'),'### Assertion failed: User: '+oneUser.Name+' // EMail: '+oneUser.EMail+' // Sandboxes: '+oneUser.Lcm_Sandboxes__c);
		}
	}

	@isTest
	public static void testRK_TestRefresh(){
		Lcm_Sandbox_Setup classSetup = new Lcm_Sandbox_Setup();
		List<User> listUsers = [SELECT Name, EMail, Lcm_Sandboxes__c FROM User WHERE Alias LIKE 'test' AND Lcm_Sandboxes__c != null];
		for(User oneUser: listUsers){
			System.debug('### Email before Test: '+ oneUser.Email);
		}

		Test.startTest();
			Test.testSandboxPostCopyScript(classSetup, UserInfo.getOrganizationId(), UserInfo.getOrganizationId(), 'RK_Test');
		Test.stopTest();

		listUsers = [SELECT Name, EMail, Lcm_Sandboxes__c FROM User WHERE Alias LIKE 'test' AND Lcm_Sandboxes__c != null];
		
		for(User oneUser: listUsers){
			System.debug('### Email after Test: '+ oneUser.Email);
			if(oneUser.Lcm_Sandboxes__c.contains('rk*')){
				System.assert(!oneUser.Email.contains('example.com'),'### Assertion failed: User: '+oneUser.Name+' // EMail: '+oneUser.EMail+' // Sandboxes: '+oneUser.Lcm_Sandboxes__c);
			}else
				System.assert(oneUser.Email.contains('example.com'),'### Assertion failed: User: '+oneUser.Name+' // EMail: '+oneUser.EMail+' // Sandboxes: '+oneUser.Lcm_Sandboxes__c);
		}
	}

	
	@isTest
	public static void testRefreshWithData() {
		Lcm_Sandbox_Setup classSetup = new Lcm_Sandbox_Setup();

		
		P7S1_Comp__c objDefaultComp = cls_P7S1_TestData.createTestFirma(true);
		upsert new P7S1_Settings__c(SetupOwnerId = Userinfo.getOrganizationId(), P7S1_Emp_Serviceweb_DefaultCompID__c = objDefaultComp.Id);

		Test.startTest();
			Test.testSandboxPostCopyScript(classSetup, UserInfo.getOrganizationId(), UserInfo.getOrganizationId(), 'VP');
		Test.stopTest();

		List<P7S1_Comp__c> compList = new List<P7S1_Comp__c>([SELECT ID FROM P7S1_Comp__c]); 
		System.assertEquals(compList.size(), 1);
		System.assertEquals(objDefaultComp.Id, compList[0].Id);

	}

	
	@isTest
	public static void testRefreshWithoutData() {
		Lcm_Sandbox_Setup classSetup = new Lcm_Sandbox_Setup();

		Test.startTest();
			Test.testSandboxPostCopyScript(classSetup, UserInfo.getOrganizationId(), UserInfo.getOrganizationId(), 'FML1');
		Test.stopTest();

		List<P7S1_Comp__c> compList = new List<P7S1_Comp__c>([SELECT ID FROM P7S1_Comp__c]); 
		System.assertEquals(compList.size(), 1);
		System.assertEquals(compList[0].Id, P7S1_Settings__c.getOrgDefaults().P7S1_Emp_Serviceweb_DefaultCompID__c);

	}

	
	/***** HELPER *****/

	static User createTestUser(){
        Profile profile = [select Id FROM Profile WHERE Name = 'Standard User' or Name = 'Standardbenutzer'];
        User user = P7S1_CampaignMember_ReadOnlyBlock_Test.createTestUser(false, profile);
        user.Email = user.lastName.left(16)+'=example.net@example.com';

        return user;	
	}
}