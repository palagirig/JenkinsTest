@isTest
private with sharing class Adv_OptimizingChange_DeliverPrio_Test {

    static testMethod void testDeliverPriority() {
        SomDig_MediagattungsDifferenzierung__c md = cls_P7S1_TestData.createTestMediagattungsDifferenzierung(true);

        SomDig_Auftragstyp__c auftragstyp = cls_P7S1_TestData.createTestAuftragstyp(true);

        SomDig_DeliverPrio__c p1 = cls_P7S1_TestData.createTestAuslieferungsprioritaet(false, md, auftragstyp);
        p1.SomDig_Gueltig_ab__c = Date.today();
        p1.SomDig_Gueltig_bis__c = Date.today().addYears(1);
        p1.SomDig_Werbeform_Kurzform__c = 'PR1/MR';
        p1.SomDig_Rotationstyp__c = 'Umfeld';
        p1.SomDig_Prio__c ='3';
        insert p1;


        ADvendio__Pricelist__c rateCard1 = cls_P7S1_TestData.createTestPricelist(true, auftragstyp);

        ADvendio__Site__c site1 = cls_P7S1_TestData.createTestSite(true);

        ADvendio__Placement__c placement1 = cls_P7S1_TestData.createTestPlacement(false, site1);
        placement1.SomDig_Rotationstyp__c = 'Umfeld';
        placement1.SomDig_Typ__c = '71m intern';
        insert placement1;

        ADvendio__Ad_Type__c type1 = cls_P7S1_TestData.createTestAdType(false, md);
        type1.ADvendio__Advertising_Form_Shortform__c = 'PR1/MR';
        insert type1;

        ADvendio__Ad_Specs__c adspecs1 = cls_P7S1_TestData.createTestAdSpec(true, placement1, type1);
        ADvendio__Ad_price__c price1 = cls_P7S1_TestData.createTestAdPrice(true, adspecs1, rateCard1);
        ADvendio__MediaCampaign__c mc1 = cls_P7S1_TestData.createTestMediaCampaign(true, null, rateCard1, null);
        
        ADvendio__Campaign_Item__c ci1 = cls_P7S1_TestData.createTestCampaignItem(false, mc1, price1);
        ci1.ADvendio__from_Date__c = Date.today().addDays(1);
        ci1.ADvendio__until_Date__c=Date.today().addDays(2);
        insert ci1;        

        
        ADvendio__OptimizingVersion__c objOV = new ADvendio__OptimizingVersion__c(Name = 'TestOpti');
        objOV.ADvendio__MediaCampaign__c = mc1.ID;
        insert objOV;
        
        List<ADvendio__OptimizingChange__c> listOC = new List<ADvendio__OptimizingChange__c>();

        ADvendio__OptimizingChange__c objOCName = new ADvendio__OptimizingChange__c(ADvendio__OptimizingVersion__c = objOV.ID);
        objOCName.ADvendio__FieldName__c = 'name';
        objOCName.ADvendio__OptimizedValue__c = 'neue Position';        
        objOCName.ADvendio__NewCiIdentifier__c = ci1.ID;                
        objOCName.ADvendio__CampaignItem__c = ci1.ID;        
        listOC.add(objOCName);
        
        ADvendio__OptimizingChange__c objAdPrice = new ADvendio__OptimizingChange__c(ADvendio__OptimizingVersion__c = objOV.ID);
        objAdPrice.ADvendio__FieldName__c = 'advendio__ad_price__c';
        objAdPrice.ADvendio__OptimizedValue__c = price1.ID;        
        objAdPrice.ADvendio__NewCiIdentifier__c = ci1.ID;                
        objAdPrice.ADvendio__CampaignItem__c = ci1.ID;
        listOC.add(objAdPrice);        
        
        ADvendio__OptimizingChange__c objFromDate = new ADvendio__OptimizingChange__c(ADvendio__OptimizingVersion__c = objOV.ID);
        objFromDate.ADvendio__FieldName__c = 'advendio__from_date__c';
        objFromDate.ADvendio__OptimizedValue__c = String.valueOf(Date.today().addDays(1));
        objFromDate.ADvendio__NewCiIdentifier__c = ci1.ID;                
        objFromDate.ADvendio__CampaignItem__c = ci1.ID;
        listOC.add(objFromDate);        
        
        ADvendio__OptimizingChange__c objUntilDate = new ADvendio__OptimizingChange__c(ADvendio__OptimizingVersion__c = objOV.ID);
        objUntilDate.ADvendio__FieldName__c = 'advendio__until_date__c';
        objUntilDate.ADvendio__OptimizedValue__c = String.valueOf(Date.today().addDays(2));
        objUntilDate.ADvendio__NewCiIdentifier__c = ci1.ID;                
        objUntilDate.ADvendio__CampaignItem__c = ci1.ID;
        listOC.add(objUntilDate);  
        
        ADvendio__OptimizingChange__c objBillingCategory = new ADvendio__OptimizingChange__c(ADvendio__OptimizingVersion__c = objOV.ID);
        objBillingCategory.ADvendio__FieldName__c = 'advendio__billing_category__c';
        objBillingCategory.ADvendio__OptimizedValue__c = 'CPM';
        objBillingCategory.ADvendio__NewCiIdentifier__c = ci1.ID;                
        objBillingCategory.ADvendio__CampaignItem__c = ci1.ID;
        listOC.add(objBillingCategory);                                



        Test.startTest();
        insert listOC;        
        
        List<ADvendio__OptimizingChange__c> listOCPrio = new List<ADvendio__OptimizingChange__c>([SELECT ID FROM ADvendio__OptimizingChange__c WHERE ADvendio__OptimizingVersion__c = :objOV.ID AND ADvendio__FieldName__c = 'advendio__priority__c']);
        System.assert(listOCPrio.size() > 0);
        
        List<ADvendio__OptimizingChange__c> listOCAdType = new List<ADvendio__OptimizingChange__c>([SELECT ID FROM ADvendio__OptimizingChange__c WHERE ADvendio__OptimizingVersion__c = :objOV.ID AND ADvendio__FieldName__c = 'advendio__adType__c']);
        System.assert(listOCAdType.size() > 0);        
        
        Test.stopTest();
    }

}