@isTest
public class SomTv_OLI_AdfExport_Test
{
    
    @TestSetup
    public static void dataSetup()
    {
        SomTv_AdfProjekt__c adfProjekt = createTestAdfProjekt(true);
        
        Opportunity opp = cls_P7S1_TestData.createTestOpportunity(false);
        opp.SomTv_AdFProjekt__c = adfProjekt.id;
        insert opp;
        
        List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
		olis.add(cls_P7S1_TestData.createTestOpportunityLineItem(false, opp));
		olis.add(cls_P7S1_TestData.createTestOpportunityLineItem(false, opp));
        insert olis;
    }
    
    @isTest
    public static void Test_Container()
    {
        Id projId = [SELECT Id FROM SomTv_AdfProjekt__c].id;
        Test.startTest();        
        SomTv_OLI_AdfExportData  data = new SomTv_OLI_AdfExportData (projId);
        String query = data.buildQuery();
        List<SObject> result = Database.query(query);
        system.assertEquals(2, result.size());
        Test.stopTest();
    }
    
    @isTest
    public static void Test_Controller()
    {
        Id projId = [SELECT Id FROM SomTv_AdfProjekt__c].id;
        Test.startTest();        
        SomTv_OLI_AdfExportCtrl controller = new SomTv_OLI_AdfExportCtrl(projId);
        String contentString = controller.content;
        Test.stopTest();
    }
    
    @isTest
    public static void test_IntegerDataElement()
    {
        Integer intValue = 4711;
        Xmlstreamwriter xmlWriter = new Xmlstreamwriter();
        xmlWriter.writeStartDocument(null, '1.0');
        Test.startTest();
        
        P7S1_ExcelExportUtils.XmlExcelExport_Base dataElement = P7S1_ExcelExportUtils.getDataElement(intValue, xmlWriter);
        dataElement.addToXmlStream();
        String result = xmlWriter.getXmlString();
        
        Test.stopTest();
        xmlWriter.writeEndDocument();
        system.assert(dataElement instanceOf P7S1_ExcelExportUtils.IntegerDataElement);
        String expectedString = '<?xml version="1.0"?><ss:Data ss:Type="String">4.711</ss:Data>';
        system.assertEquals(expectedString, result);
    }
    
    
    @isTest
    public static void test_DateDataElement()
    {
        Date dateValue = Date.newInstance(2000,1,30);
        Xmlstreamwriter xmlWriter = new Xmlstreamwriter();
        xmlWriter.writeStartDocument(null, '1.0');
        Test.startTest();
        
        P7S1_ExcelExportUtils.XmlExcelExport_Base dataElement = P7S1_ExcelExportUtils.getDataElement(dateValue, xmlWriter);
        dataElement.addToXmlStream();
        String result = xmlWriter.getXmlString();
        
        Test.stopTest();
        xmlWriter.writeEndDocument();
        system.assert(dataElement instanceOf P7S1_ExcelExportUtils.DateDataElement);
        String expectedString = '<?xml version="1.0"?><ss:Data ss:Type="String">30.01.2000</ss:Data>';
        system.assertEquals(expectedString, result);
    }
    
    //TODO: Auslagern
    
 	public static SomTv_AdfProjekt__c createTestAdfProjekt (Boolean insertObject)
    {
        SomTv_AdfProjekt__c adfProjekt = new SomTv_AdfProjekt__c();
        adfProjekt.Name = 'Testprojekt';
        if(insertObject)
            insert adfProjekt;
        return adfProjekt;
    }
    
}