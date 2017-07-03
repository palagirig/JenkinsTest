@isTest
public class Adv_CampaignItem_DurationChanged_Test {
    
    
    @isTest
    public static void testdeleteOtherOVs() {
        
        ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(true);
        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(true, objMC);
        
        ADvendio__OptimizingVersion__c objOV = createADvendioOptimizingVersion(true);
        ADvendio__OptimizingChange__c objOC = createADvendioOptimizingChange(true, objOV, objCI);
        
        ADvendio__OptimizingVersion__c objOV2 = createADvendioOptimizingVersion(true);
        
        Test.startTest();
        
        System.assertEquals(2, [SELECT count() FROM ADvendio__OptimizingVersion__c]);
        
        objCI.ADvendio__until_Date__c = Date.today().addDays(9);
        update objCI;
        
        Test.stopTest();
        
        System.assertEquals(1, [SELECT count() FROM ADvendio__OptimizingVersion__c]);
        
    }
    
    
    
    // TODO: move to TESTClass
    public static ADvendio__OptimizingVersion__c createADvendioOptimizingVersion(Boolean isInsert){
        ADvendio__OptimizingVersion__c objOV = new ADvendio__OptimizingVersion__c();
        if(isInsert) insert objOV;
        return objOV;
    }    
    
    public static ADvendio__OptimizingChange__c createADvendioOptimizingChange(Boolean isInsert, ADvendio__OptimizingVersion__c objOV, ADvendio__Campaign_Item__c objCI){
        
        ADvendio__OptimizingChange__c objOC = new ADvendio__OptimizingChange__c();
        objOC.ADvendio__OptimizingVersion__c = objOV.ID;
        objOC.ADvendio__CampaignItem__c = objCI.ID;
        
        if(isInsert) insert objOC;
        return objOC;    
    }    
    
}