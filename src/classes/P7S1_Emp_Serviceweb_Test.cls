@isTest
public class P7S1_Emp_Serviceweb_Test {

    @isTest(seeAllData=true)
    private static void testForValidDefaultCompId() { 
        List<P7S1_Comp__c> compList = new list<P7S1_Comp__c>([SELECT ID FROM P7S1_Comp__c WHERE ID = :P7S1_Settings__c.getOrgDefaults().P7S1_Emp_Serviceweb_DefaultCompID__c]);
        System.assertEquals(compList.size(), 1,'P7S1_Settings__c.P7S1_Emp_Serviceweb_DefaultCompID__c needs a valid P7S1_Comp__c ID!');
    }

    @isTest
    private static void testForCorrectValues() {
        
        // Prepare mail and envelope.
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // Insert Organisation, Kollege & Manager
        P7S1_Comp__c objComp = cls_P7S1_TestData.createTestFirma(False);
        objComp.Name = 'Company Name';
        insert objComp;
        
        P7S1_Emp__c objKollege = cls_P7S1_TestData.createTestMitarbeiter(False, objComp);
        objKollege.P7S1_Firstname__c = 'Kollege';
        objKollege.P7S1_Unit__c = '71M';
        objKollege.P7S1_Role__c = 'CRM';
        insert objKollege;
        
        P7S1_Emp__c objManager = cls_P7S1_TestData.createTestMitarbeiter(True, objComp);
        
        // Set mail body, email matches the inserted Contact.
        email.subject = 'BOO01234567 - Antrag Salesforce';
        email.plainTextBody = 'Benutzername=MaxMustermann\nVorname=Max\nNachname=Mustermann\nBemerkungen=Effective\nAustrittsdatum=19.07.2015\nEmail=maxmustermann@email.de\nKollege='+objKollege.P7S1_Lastname__c + ' ' + objKollege.P7S1_Firstname__c +'\nFirma=' + objComp.Name + '\nManager='+objManager.P7S1_Lastname__c + ' ' + objManager.P7S1_Firstname__c +'';
        
        Test.startTest();
        
        // Instantiate the service, and run once.
        P7S1_Emp_Serviceweb cls = new P7S1_Emp_Serviceweb();
        cls.handleInboundEmail(email, env);
        
        Test.stopTest();
        
        // Asserts
        List<P7S1_Emp__c> listTestEmp = new List<P7S1_Emp__c>([SELECT	P7S1_Comp__c, P7S1_Manager__c, P7S1_Colleague__c,
                                                               		  	P7S1_Unit__c, P7S1_Profile__c, P7S1_Role__c
                                                               FROM 	P7S1_Emp__c
                                                               WHERE  	P7S1_Email__c = 'maxmustermann@email.de'
                                                               LIMIT  	1]);
        
        P7S1_Emp__c testEmp = listTestEmp[0];
        
        // Found and matched the Organization correctly.
        System.assertEquals(objComp.ID, testEmp.P7S1_Comp__c);
        
        // Found and matched the Manager correctly.
        System.assertEquals(objManager.ID, testEmp.P7S1_Manager__c);  
        
        System.assertEquals(objKollege.P7S1_Profile__c, testEmp.P7S1_Profile__c);
        System.assertEquals(objKollege.P7S1_Role__c, testEmp.P7S1_Role__c);
        System.assertEquals(objKollege.P7S1_Unit__c, testEmp.P7S1_Unit__c);
        
    }

    @isTest
    private static void testForMissingCompany() {
        P7S1_Comp__c testFirma = cls_P7S1_TestData.createTestFirma(true);
        upsert new P7S1_Settings__c(SetupOwnerId = Userinfo.getOrganizationId(), P7S1_Emp_Serviceweb_DefaultCompID__c = testFirma.Id);

         // Prepare mail and envelope.
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // Insert Organisation, Kollege & Manager
        P7S1_Comp__c objComp = cls_P7S1_TestData.createTestFirma(False);
        objComp.Name = 'Company Name';
        insert objComp;

        P7S1_Emp__c objKollege = cls_P7S1_TestData.createTestMitarbeiter(False, objComp);
        objKollege.P7S1_Firstname__c = 'Kollege';
        objKollege.P7S1_Unit__c = '71M';
        objKollege.P7S1_Role__c = 'CRM';
        insert objKollege;
        
        P7S1_Emp__c objManager = cls_P7S1_TestData.createTestMitarbeiter(True, objComp);
        
        // Set mail body, email matches the inserted Contact.
        email.subject = 'BOO01234567 - Antrag Salesforce';
        email.plainTextBody = 'Benutzername=MaxMustermann\nVorname=Max\nNachname=Mustermann\nBemerkungen=Effective\nAustrittsdatum=19.07.2015\nEmail=maxmustermann@email.de\nKollege='+objKollege.P7S1_Lastname__c + ' ' + objKollege.P7S1_Firstname__c +'\nFirma=NoComp\nManager='+objManager.P7S1_Lastname__c + ' ' + objManager.P7S1_Firstname__c +'';
        
        Test.startTest();
        
        // Instantiate the service, and run once.
        P7S1_Emp_Serviceweb cls = new P7S1_Emp_Serviceweb();
        cls.handleInboundEmail(email, env);

        Test.stopTest();

        
        // Asserts
        List<P7S1_Emp__c> listTestEmp = new List<P7S1_Emp__c>([SELECT   P7S1_Comp__c, P7S1_Manager__c, P7S1_Colleague__c,
                                                                        P7S1_Unit__c, P7S1_Profile__c, P7S1_Role__c
                                                               FROM     P7S1_Emp__c
                                                               WHERE    P7S1_Email__c = 'maxmustermann@email.de'
                                                               LIMIT    1]);
        P7S1_Emp__c testEmp = listTestEmp[0];
        
        // Did not find a matching company, fall back to default value.
        System.assertEquals(P7S1_Settings__c.getOrgDefaults().P7S1_Emp_Serviceweb_DefaultCompID__c, testEmp.P7S1_Comp__c);
        
        // Found and matched the Manager correctly.
        System.assertEquals(objManager.Id, testEmp.P7S1_Manager__c);

        // Found and matched the Colleague correctly.
        System.assertEquals(objKollege.P7S1_Profile__c, testEmp.P7S1_Profile__c);
        System.assertEquals(objKollege.P7S1_Role__c, testEmp.P7S1_Role__c);
        System.assertEquals(objKollege.P7S1_Unit__c, testEmp.P7S1_Unit__c);
    }

    @isTest
    private static void testForMissingColleague() {

        // Prepare mail and envelope.
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // Insert Organisation, Kollege & Manager
        P7S1_Comp__c objComp = cls_P7S1_TestData.createTestFirma(False);
        objComp.Name = 'Company Name';
        insert objComp;
        
        P7S1_Emp__c objKollege = cls_P7S1_TestData.createTestMitarbeiter(False, objComp);
        objKollege.P7S1_Firstname__c = 'Kollege';
        objKollege.P7S1_Unit__c = '71M';
        objKollege.P7S1_Role__c = 'CRM';
        insert objKollege;
        
        P7S1_Emp__c objManager = cls_P7S1_TestData.createTestMitarbeiter(True, objComp);
        
        // Set mail body, email matches the inserted Contact.
        email.subject = 'BOO01234567 - Antrag Salesforce';
        email.plainTextBody = 'Benutzername=MaxMustermann\nVorname=Max\nNachname=Mustermann\nBemerkungen=Effective\nAustrittsdatum=19.07.2015\nEmail=maxmustermann@email.de\nKollege=No One\nFirma=' + objComp.Name + '\nManager='+objManager.P7S1_Lastname__c + ' ' + objManager.P7S1_Firstname__c +'';
        
        Test.startTest();
        
        // Instantiate the service, and run once.
        P7S1_Emp_Serviceweb cls = new P7S1_Emp_Serviceweb();
        cls.handleInboundEmail(email, env);
        
        Test.stopTest();
        
        // Asserts
        List<P7S1_Emp__c> listTestEmp = new List<P7S1_Emp__c>([SELECT   P7S1_Comp__c, P7S1_Manager__c, P7S1_Colleague__c,
                                                                        P7S1_Unit__c, P7S1_Profile__c, P7S1_Role__c
                                                               FROM     P7S1_Emp__c
                                                               WHERE    P7S1_Email__c = 'maxmustermann@email.de'
                                                               LIMIT    1]);
        
        P7S1_Emp__c testEmp = listTestEmp[0];
        
        // Found and matched the Organization correctly.
        System.assertEquals(objComp.ID, testEmp.P7S1_Comp__c);
        
        // Found and matched the Manager correctly.
        System.assertEquals(objManager.ID, testEmp.P7S1_Manager__c);  
        
        // Didnt found matching colleague, thus no field values where copied.
        System.assertEquals(null, testEmp.P7S1_Profile__c);
        System.assertEquals(null, testEmp.P7S1_Role__c);
        System.assertEquals(null, testEmp.P7S1_Unit__c);
    }

    @isTest
    private static void testForMissingManager() {
        
        // Prepare mail and envelope.
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // Insert Organisation, Kollege & Manager
        P7S1_Comp__c objComp = cls_P7S1_TestData.createTestFirma(False);
        objComp.Name = 'Company Name';
        insert objComp;
        
        P7S1_Emp__c objKollege = cls_P7S1_TestData.createTestMitarbeiter(False, objComp);
        objKollege.P7S1_Firstname__c = 'Kollege';
        objKollege.P7S1_Unit__c = '71M';
        objKollege.P7S1_Role__c = 'CRM';
        insert objKollege;
        
        P7S1_Emp__c objManager = cls_P7S1_TestData.createTestMitarbeiter(True, objComp);
        
        // Set mail body, email matches the inserted Contact.
        email.subject = 'BOO01234567 - Antrag Salesforce';
        email.plainTextBody = 'Benutzername=MaxMustermann\nVorname=Max\nNachname=Mustermann\nBemerkungen=Effective\nAustrittsdatum=19.07.2015\nEmail=maxmustermann@email.de\nKollege='+objKollege.P7S1_Lastname__c + ' ' + objKollege.P7S1_Firstname__c +'\nFirma=' + objComp.Name + '\nManager=No One';
        
        Test.startTest();
        
        // Instantiate the service, and run once.
        P7S1_Emp_Serviceweb cls = new P7S1_Emp_Serviceweb();
        cls.handleInboundEmail(email, env);
        
        Test.stopTest();
        
        // Asserts
        List<P7S1_Emp__c> listTestEmp = new List<P7S1_Emp__c>([SELECT   P7S1_Comp__c, P7S1_Manager__c, P7S1_Colleague__c,
                                                                        P7S1_Unit__c, P7S1_Profile__c, P7S1_Role__c
                                                               FROM     P7S1_Emp__c
                                                               WHERE    P7S1_Email__c = 'maxmustermann@email.de'
                                                               LIMIT    1]);
        
        P7S1_Emp__c testEmp = listTestEmp[0];
        
        // Found and matched the Organization correctly.
        System.assertEquals(objComp.ID, testEmp.P7S1_Comp__c);
        
        // Didnt found matching Manager.
        System.assertEquals(null, testEmp.P7S1_Manager__c);  
        
        // Found and matched the Colleague correctly.
        System.assertEquals(objKollege.P7S1_Profile__c, testEmp.P7S1_Profile__c);
        System.assertEquals(objKollege.P7S1_Role__c, testEmp.P7S1_Role__c);
        System.assertEquals(objKollege.P7S1_Unit__c, testEmp.P7S1_Unit__c);
        
    }
    
}