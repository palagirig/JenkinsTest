@isTest
public class Adv_CampaignItem_PDFCheckboxes_Test {

    static testMethod void testSetPDFCheckboxes(){
        

        List<ADvendio__Campaign_Item__c> listCI = new List<ADvendio__Campaign_Item__c>();
        
        ADvendio__Ad_Price__c adprice = cls_P7S1_TestData.createTestAdPrice(true, cls_P7S1_TestData.createTestPricelist(true));
        ADvendio__MediaCampaign__c camp = cls_P7S1_TestData.createTestMediaCampaign(true);

        // Nachlieferung           
        ADvendio__Campaign_Item__c objCINL = cls_P7S1_TestData.createTestCampaignItem(false, camp, adprice);
        objCINL.ADvendio__Rate_Discount_4_Name__c = 'Nachlieferung';
        listCI.add(objCINL);
        
        // Storno mit Leistungsfluss
        ADvendio__Campaign_Item__c objCISML = cls_P7S1_TestData.createTestCampaignItem(false, camp, adprice);
        objCISML.ADvendio__Rate_Discount_4_Name__c = 'Storno mit Leistungsfluss';
        listCI.add(objCISML);

        // Storno ohne Leistungsfluss        
        ADvendio__Campaign_Item__c objCISOL = cls_P7S1_TestData.createTestCampaignItem(false, camp, adprice);
        objCISOL.ADvendio__from_Date__c = Date.today().addDays(1);
        objCISOL.ADvendio__Rate_Discount_4_Name__c = 'Storno ohne Leistungsfluss';
        listCI.add(objCISOL);

        // Default campaign item        
        ADvendio__Campaign_Item__c objCIdef = cls_P7S1_TestData.createTestCampaignItem(false, camp, adprice);
        listCI.add(objCIdef);                 
        
        Test.startTest();
        insert listCI;
        Test.stopTest();        
        
        objCINL = [SELECT ADvendio__DoNotShowOnProposalPDF__c, ADvendio__ShowOnInvoicePDF__c, ADvendio__BillMe__c, ADvendio__NotRelevantForTurnover__c FROM ADvendio__Campaign_Item__c WHERE ID = :objCINL.ID limit 1];
        System.assert(objCINL.ADvendio__DoNotShowOnProposalPDF__c == true);                
        System.assert(objCINL.ADvendio__ShowOnInvoicePDF__c == false);
        System.assert(objCINL.ADvendio__BillMe__c == false);   
        System.assert(objCINL.ADvendio__NotRelevantForTurnover__c == true);                  
        
        objCISML = [SELECT ADvendio__DoNotShowOnProposalPDF__c, ADvendio__ShowOnInvoicePDF__c, ADvendio__BillMe__c, ADvendio__NotRelevantForTurnover__c FROM ADvendio__Campaign_Item__c WHERE ID = :objCISML.ID limit 1];
        System.assert(objCISML.ADvendio__DoNotShowOnProposalPDF__c == true);                
        System.assert(objCISML.ADvendio__ShowOnInvoicePDF__c == false);   
        System.assert(objCISML.ADvendio__BillMe__c == false);   
        System.assert(objCISML.ADvendio__NotRelevantForTurnover__c == true);                          
        
        objCISOL = [SELECT ADvendio__DoNotShowOnProposalPDF__c, ADvendio__ShowOnInvoicePDF__c, ADvendio__BillMe__c, ADvendio__NotRelevantForTurnover__c FROM ADvendio__Campaign_Item__c WHERE ID = :objCISOL.ID limit 1];
        System.assert(objCISOL.ADvendio__DoNotShowOnProposalPDF__c == true);                
        System.assert(objCISOL.ADvendio__ShowOnInvoicePDF__c == false);
        System.assert(objCISOL.ADvendio__BillMe__c == false);   
        System.assert(objCISOL.ADvendio__NotRelevantForTurnover__c == true);

        objCIdef = [SELECT ADvendio__DoNotShowOnProposalPDF__c, ADvendio__ShowOnInvoicePDF__c, ADvendio__BillMe__c, ADvendio__NotRelevantForTurnover__c FROM ADvendio__Campaign_Item__c WHERE ID = :objCIdef.ID limit 1];
        System.assert(objCIdef.ADvendio__DoNotShowOnProposalPDF__c == false);                
        System.assert(objCIdef.ADvendio__ShowOnInvoicePDF__c == true);
        System.assert(objCIdef.ADvendio__BillMe__c == true);   
        System.assert(objCIdef.ADvendio__NotRelevantForTurnover__c == false);                                            
    }
}