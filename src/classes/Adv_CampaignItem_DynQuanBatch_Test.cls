@isTest
private class Adv_CampaignItem_DynQuanBatch_Test {
    static testmethod void testDynamicQuantityItem() {

		ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(true);

		// Pakethülle
		ADvendio__Ad_Specs__c objSpecPH = cls_P7S1_TestData.createTestAdSpec(false);
		objSpecPH.ADvendio__Distribution__c = 'Prorated';
		insert objSpecPH;

		ADvendio__Ad_price__c objPricePH = cls_P7S1_TestData.createTestAdPrice(true, objSpecPH);

		ADvendio__Campaign_Item__c objPH = cls_P7S1_TestData.createTestCampaignItem(false, objMC, objPricePH);
		objPH.ADvendio__Quantity__c = 1100;
		objPH.ADvendio__From_Date__c = System.Today().addDays(-1);
		objPH.SomDig_Naturalrabatt__c = 10;
		objPH.SomDig_Menge__c = 1000;
		insert objPH;

		// Create Youtube Item
		ADvendio__Placement__c objPlacement = cls_P7S1_TestData.createTestPlacement(false, null);
		objPlacement.SomDig_Typ__c = 'YouTube';
		insert objPlacement;

		ADvendio__Ad_Specs__c objSpec = cls_P7S1_TestData.createTestAdSpec(false, objPlacement);
		objSpec.ADvendio__Distribution__c = 'Prorated';
		insert objSpec;

		ADvendio__Ad_price__c objPrice = cls_P7S1_TestData.createTestAdPrice(true, objSpec);

		// Create 2 component items
		ADvendio__Campaign_Item__c objCI1 = cls_P7S1_TestData.createTestCampaignItem(false, objMC, objPrice);
		objCI1.ADvendio__PacketItem__c = objPH.Id;
		objCI1.ADvendio__Quantity__c = 220;
		objCI1.SomDig_Naturalrabatt__c = 10;
		objCI1.SomDig_Menge__c = 200;

		ADvendio__Campaign_Item__c objCI2 = cls_P7S1_TestData.createTestCampaignItem(false, objMC, objPrice);
		objCI2.ADvendio__PacketItem__c = objPH.Id;
		objCI2.ADvendio__Quantity__c = 880;
		objCI2.SomDig_Naturalrabatt__c = 10;
		objCI2.SomDig_Menge__c = 800;
		insert new List<ADvendio__Campaign_Item__c>{objCI1,objCI2};

		// Create Deliry Data
		ADvendio__DeliveryData__c objDDCI1 = new ADvendio__DeliveryData__c(ADvendio__DeliveredImpressions__c = 100, ADvendio__CampaignItem__c = objCI1.ID, ADvendio__Type__c = 'Daily');
		insert objDDCI1;

		ADvendio__DeliveryData__c objDDCI2 = new ADvendio__DeliveryData__c(ADvendio__DeliveredImpressions__c = 700, ADvendio__CampaignItem__c = objCI2.ID, ADvendio__Type__c = 'Daily');
		insert objDDCI2;

		Test.startTest();
		
		system.assertEquals('Bitte wähle eine Kampagnen-Position aus', Adv_CampaignItem_DynQuanBatch.startDynamicQuantityBatch(null));
		system.assertEquals('Die Mengen-Verteilung für die Position ist abgeschlossen', Adv_CampaignItem_DynQuanBatch.startDynamicQuantityBatch((String) objPH.Id));
		Test.stopTest();

		objCI1 = [SELECT ADvendio__Quantity__c, SomDig_Menge__c FROM ADvendio__Campaign_Item__c WHERE ID = :objCI1.ID];
		System.assertEquals(objCI1.ADvendio__Quantity__c, 137);
		System.assertEquals(objCI1.SomDig_Menge__c, 125);

		objCI2 = [SELECT ADvendio__Quantity__c, SomDig_Menge__c FROM ADvendio__Campaign_Item__c WHERE ID = :objCI2.ID];
		System.assertEquals(objCI2.ADvendio__Quantity__c, 962);
		System.assertEquals(objCI2.SomDig_Menge__c, 875);
    }
    
    static testmethod void testBatch() {
		ADvendio__MediaCampaign__c objMC = cls_P7S1_TestData.createTestMediaCampaign(true);

		// Pakethülle
		ADvendio__Ad_Specs__c objSpecPH = cls_P7S1_TestData.createTestAdSpec(false);
		objSpecPH.ADvendio__Distribution__c = 'Prorated';
		insert objSpecPH;

		ADvendio__Ad_price__c objPricePH = cls_P7S1_TestData.createTestAdPrice(true, objSpecPH);

		ADvendio__Campaign_Item__c objPH = cls_P7S1_TestData.createTestCampaignItem(false, objMC, objPricePH);
		objPH.ADvendio__Quantity__c = 1000;
		objPH.ADvendio__From_Date__c = System.Today().addDays(-1);		     
		insert objPH;

		// Create Youtube Item
		ADvendio__Placement__c objPlacement = cls_P7S1_TestData.createTestPlacement(false, null);
		objPlacement.SomDig_Typ__c = 'YouTube';
		insert objPlacement;

		ADvendio__Ad_Specs__c objSpec = cls_P7S1_TestData.createTestAdSpec(false, objPlacement);
		objSpec.ADvendio__Distribution__c = 'Prorated';
		insert objSpec;

		ADvendio__Ad_price__c objPrice = cls_P7S1_TestData.createTestAdPrice(true, objSpec);

		// Create 2 component items
		ADvendio__Campaign_Item__c objCI1 = cls_P7S1_TestData.createTestCampaignItem(false, objMC, objPrice);
		objCI1.ADvendio__PacketItem__c = objPH.Id;
		objCI1.ADvendio__Quantity__c = 200;

		ADvendio__Campaign_Item__c objCI2 = cls_P7S1_TestData.createTestCampaignItem(false, objMC, objPrice);
		objCI2.ADvendio__PacketItem__c = objPH.Id;
		objCI2.ADvendio__Quantity__c = 800;
		insert new List<ADvendio__Campaign_Item__c>{objCI1,objCI2};

		// Create Deliry Data
		ADvendio__DeliveryData__c objDDCI1 = new ADvendio__DeliveryData__c(ADvendio__DeliveredImpressions__c = 100, ADvendio__CampaignItem__c = objCI1.ID, ADvendio__Type__c = 'Daily');
		insert objDDCI1;

		ADvendio__DeliveryData__c objDDCI2 = new ADvendio__DeliveryData__c(ADvendio__DeliveredImpressions__c = 700, ADvendio__CampaignItem__c = objCI2.ID, ADvendio__Type__c = 'Daily');
		insert objDDCI2;

		Test.startTest();
		Database.executeBatch(new Adv_CampaignItem_DynQuanBatch());
		Test.stopTest();

		objCI1 = [SELECT ADvendio__Quantity__c FROM ADvendio__Campaign_Item__c WHERE ID = :objCI1.ID];
		System.assertEquals(objCI1.ADvendio__Quantity__c, 125);

		objCI2 = [SELECT ADvendio__Quantity__c FROM ADvendio__Campaign_Item__c WHERE ID = :objCI2.ID];
		System.assertEquals(objCI2.ADvendio__Quantity__c, 875);
    }
}