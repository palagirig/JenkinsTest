@isTest
public class Adv_CampaignItem_ResetAvailability_Test {

    @isTest (seeAllData=false)
    public static void testSetAvailability(){
        ADvendio__MediaCampaign__c mc	= cls_P7S1_TestData.createTestMediaCampaign(true);
        
        // Create Component with SomDig_BelegungseinheitTyp__c = 'YouTube'
        ADvendio__Placement__c objPlacement_YT		= cls_P7S1_TestData.createTestPlacement(false);
        objPlacement_YT.SomDig_Typ__c = 'YouTube';

        ADvendio__Placement__c objPlacement_noYT	= cls_P7S1_TestData.createTestPlacement(false);
        insert new List<ADvendio__Placement__c>{objPlacement_YT, objPlacement_noYT};
        
        ADvendio__Ad_Specs__c objSpec_Package		= cls_P7S1_TestData.createTestAdSpec(false, objPlacement_noYT);
        objSpec_Package.ADvendio__Distribution__c	= 'Prorated';
        ADvendio__Ad_Specs__c objSpec_YT			= cls_P7S1_TestData.createTestAdSpec(false, objPlacement_YT);
        ADvendio__Ad_Specs__c objSpec_noYT			= cls_P7S1_TestData.createTestAdSpec(false, objPlacement_noYT);
        insert new List<ADvendio__Ad_Specs__c>{objSpec_Package,objSpec_YT, objSpec_noYT};
            
        ADvendio__Ad_price__c objPrice_package	= cls_P7S1_TestData.createTestAdPrice(false, objSpec_Package);
        ADvendio__Ad_price__c objPrice_YT		= cls_P7S1_TestData.createTestAdPrice(false, objSpec_YT);
        ADvendio__Ad_price__c objPrice_noYT		= cls_P7S1_TestData.createTestAdPrice(false, objSpec_noYT);
        insert new List<ADvendio__Ad_price__c>{objPrice_YT, objPrice_noYT, objPrice_package};

        // Create Paket
        ADvendio__Campaign_Item__c objCIPaket		= cls_P7S1_TestData.createTestCampaignItem(true, mc, objPrice_package);
        system.debug([select id, SomDig_Verteilung__c from ADvendio__Campaign_Item__c]);
        
        ADvendio__Campaign_Item__c objCIComponent_YT	= cls_P7S1_TestData.createTestCampaignItem(false, mc, objPrice_YT);
        objCIComponent_YT.Name							= 'Component YT';
        objCIComponent_YT.ADvendio__PacketItem__c		= objCIPaket.Id;
        objCIComponent_YT.ADvendio__Availability__c		= 1231;
        
        ADvendio__Campaign_Item__c objCIComponent_noYT	= cls_P7S1_TestData.createTestCampaignItem(false, mc, objPrice_noYT);
        objCIComponent_noYT.Name						= 'Component no YT';
        objCIComponent_noYT.ADvendio__PacketItem__c		= objCIPaket.Id;
        objCIComponent_noYT.ADvendio__Availability__c	= 1232;

        ADvendio__Campaign_Item__c objCI_noYT		= cls_P7S1_TestData.createTestCampaignItem(false, mc, objPrice_noYT);
        objCI_noYT.Name								= 'no YT';
        objCI_noYT.ADvendio__Availability__c		= 1233;
        
        ADvendio__Campaign_Item__c objCI_YT			= cls_P7S1_TestData.createTestCampaignItem(false, mc, objPrice_YT);
        objCI_YT.Name								= 'YT';
        objCI_YT.ADvendio__Availability__c			= 1234;
        objCI_YT.ADvendio__FC_Period__c				= 'day';
        objCI_YT.ADvendio__FC_Quantity__c 			= 1;
        
        List<ADvendio__Campaign_Item__c> campaignItems	= new List<ADvendio__Campaign_Item__c>{objCIComponent_YT, objCIComponent_noYT, objCI_noYT, objCI_YT};
        insert campaignItems;
        
        Test.startTest();
        
        objCIComponent_noYT.ADvendio__until_Date__c	= objCIComponent_noYT.ADvendio__until_Date__c.addDays(1);
        objCI_noYT.ADvendio__AdDayOfWeek__c			= 'Monday';
        //objCI_YT.ADvendio__FC_Quantity__c			= 2;
        update campaignItems;
            
        Test.stopTest();        
        
        for (ADvendio__Campaign_Item__c ci :[SELECT Id, Name, ADvendio__Availability__c, ADvendio__PacketItem__c, SomDig_BelegungseinheitTyp__c, SomDig_Verteilung__c
                              				 FROM ADvendio__Campaign_Item__c
                                             WHERE ID IN :campaignItems]) {
                                                 system.debug(ci);
        	if (ci.Id == objCI_noYT.Id) {
            	system.assertEquals(null, ci.ADvendio__Availability__c);
            }
            else if (ci.Id == objCI_YT.Id) {
            //	system.assertEquals(null, ci.ADvendio__Availability__c);
            }
            else if (ci.Id == objCIComponent_noYT.Id) {
            	system.assertEquals(objCIComponent_noYT.ADvendio__Availability__c, ci.ADvendio__Availability__c);
            }
            else if (ci.Id == objCIComponent_YT.Id) {
            	system.assertEquals(objCIComponent_YT.ADvendio__Availability__c, ci.ADvendio__Availability__c);
            }
        }
    }
}