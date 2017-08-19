/**
 *	Testabdeckung für Adv_CampaignItem_Naturalrabatt
 */
@isTest
private class Adv_CampaignItem_Naturalrabatt_Test {

	@isTest
	static void presetNaturalrabatt() {
		
		ADvendio__Pricelist__c rc			= cls_P7S1_TestData.createTestPricelist(true);
		
		ADvendio__Ad_price__c ap			= cls_P7S1_TestData.createTestAdPrice(true, rc);
		ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true, null, rc);
		
		ADvendio__Campaign_Item__c ci1		= cls_P7S1_TestData.createTestCampaignItem(false, mc, ap); // no SomDig_Menge__c, SomDig_Naturalrabatt__c
		ci1.ADvendio__Quantity__c			= 1000;
		
		ADvendio__Campaign_Item__c ci2		= cls_P7S1_TestData.createTestCampaignItem(false, mc, ap); // no SomDig_Menge__c
		ci2.ADvendio__Quantity__c			= 1000;
		ci2.SomDig_Naturalrabatt__c			= 10;
		
		ADvendio__Campaign_Item__c ci3		= cls_P7S1_TestData.createTestCampaignItem(false, mc, ap);
		ci3.ADvendio__Quantity__c			= 1100;
		ci3.SomDig_Menge__c					= 1000;
		ci3.SomDig_Naturalrabatt__c			= 10;
		
		List<ADvendio__Campaign_Item__c> cis	= new List<ADvendio__Campaign_Item__c>{ci1, ci2, ci3};
		insert cis;
		
		Test.startTest();
		for (ADvendio__Campaign_Item__c ci : [SELECT Id, SomDig_Menge__c, ADvendio__Quantity__c, SomDig_Naturalrabatt__c FROM ADvendio__Campaign_Item__c WHERE Id IN :cis]) {
			if (ci.Id == ci1.Id) {
				system.assertEquals(1000.0,	ci.SomDig_Menge__c);
				system.assertEquals(1000.0,	ci.ADvendio__Quantity__c);
				system.assertEquals(0,		ci.SomDig_Naturalrabatt__c);
			}
			if (ci.Id == ci2.Id) {
				system.assertEquals(1000.0,	ci.SomDig_Menge__c);
				system.assertEquals(1000.0,	ci.ADvendio__Quantity__c);
				system.assertEquals(10,		ci.SomDig_Naturalrabatt__c);
			}
			if (ci.Id == ci3.Id) {
				system.assertEquals(1000.0,	ci.SomDig_Menge__c);
				system.assertEquals(1100.0,	ci.ADvendio__Quantity__c);
				system.assertEquals(10,		ci.SomDig_Naturalrabatt__c);
			}
		}

		try {
			ci3.SomDig_Menge__c					= null;
			update ci3;
		}
		catch (Exception e) {
			system.debug(e.getMessage());
			system.assert(e.getMessage().contains(Label.ADvendio.Required_field_missing_BA + ' ' + ADvendio__Campaign_Item__c.SomDig_Menge__c.getDescribe().getLabel()));
		}
		Test.stopTest();
	}
	
	@isTest
	static void setNaturalrabatt() {
		
		ADvendio__Pricelist__c rc			= cls_P7S1_TestData.createTestPricelist(true);
		
		ADvendio__Ad_price__c ap			= cls_P7S1_TestData.createTestAdPrice(true, rc);
		ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true, null, rc);
		
		ADvendio__Campaign_Item__c ci1		= cls_P7S1_TestData.createTestCampaignItem(false, mc, ap); 
		ci1.SomDig_Menge__c					= 1000;
		ci1.SomDig_Naturalrabatt__c			= 0;
		
		ADvendio__Campaign_Item__c ci2		= cls_P7S1_TestData.createTestCampaignItem(false, mc, ap);
		ci2.SomDig_Menge__c					= 1000;
		ci2.SomDig_Naturalrabatt__c			= 100;
		
		ADvendio__Campaign_Item__c ci3		= cls_P7S1_TestData.createTestCampaignItem(false, mc, ap);
		ci3.SomDig_Menge__c					= 1000;
		ci3.SomDig_Naturalrabatt__c			= 300;
		
		Adv_CampaignItem_Naturalrabatt.setNaturalrabatt(ci1);
		Adv_CampaignItem_Naturalrabatt.setNaturalrabatt(ci2);
		Adv_CampaignItem_Naturalrabatt.setNaturalrabatt(ci3);
		
		List<ADvendio__Campaign_Item__c> cis	= new List<ADvendio__Campaign_Item__c>{ci1, ci2, ci3};
		insert cis;
		
		Test.startTest();
		for (ADvendio__Campaign_Item__c ci : [SELECT Id, ADvendio__Amount_B2APEX__c, ADvendio__Amount_B3APEX__c, ADvendio__SurchargeB3Abs__c, SomDig_Menge__c, ADvendio__Quantity__c, SomDig_Naturalrabatt__c FROM ADvendio__Campaign_Item__c WHERE Id IN :cis]) {
			system.debug(ci);
			if (ci.Id == ci1.Id) {
				system.assertEquals(1000.0,		ci.SomDig_Menge__c);
				system.assertEquals(1000.0,		ci.ADvendio__Quantity__c);
				system.assertEquals(0,			ci.ADvendio__SurchargeB3Abs__c);
				system.assertEquals(0,			ci.SomDig_Naturalrabatt__c);
				system.assertEquals(30,			ci.ADvendio__Amount_B3APEX__c);
				system.assertEquals(30,			ci.ADvendio__Amount_B2APEX__c);
			}
			if (ci.Id == ci2.Id) {
				system.assertEquals(1000.0,		ci.SomDig_Menge__c);
				system.assertEquals(2000.0,		ci.ADvendio__Quantity__c);
				system.assertEquals(100,		ci.SomDig_Naturalrabatt__c);
				system.assertEquals(-30,		ci.ADvendio__SurchargeB3Abs__c);
				system.assertEquals(60,			ci.ADvendio__Amount_B3APEX__c);
				system.assertEquals(30,			ci.ADvendio__Amount_B2APEX__c);
			}
			if (ci.Id == ci3.Id) {
				system.assertEquals(1000.0,		ci.SomDig_Menge__c);
				system.assertEquals(4000.0,		ci.ADvendio__Quantity__c);
				system.assertEquals(300,		ci.SomDig_Naturalrabatt__c);
				system.assertEquals(-90,		ci.ADvendio__SurchargeB3Abs__c);
				system.assertEquals(120,		ci.ADvendio__Amount_B3APEX__c);
				system.assertEquals(30,		ci.ADvendio__Amount_B2APEX__c);
			}
		}
		Test.stopTest();
	}

	
	@isTest
	static void setNegativeQuantityOnCancellation() {
		
		ADvendio__Pricelist__c rc			= cls_P7S1_TestData.createTestPricelist(true);
		
		ADvendio__Ad_price__c ap			= cls_P7S1_TestData.createTestAdPrice(true, rc);
		ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true, null, rc);
		
		ADvendio__Campaign_Item__c ci1		= cls_P7S1_TestData.createTestCampaignItem(false, mc, ap); 
		ci1.SomDig_Menge__c					= 1000;
		ci1.SomDig_Naturalrabatt__c			= 0;
		
		ADvendio__Campaign_Item__c ci2		= cls_P7S1_TestData.createTestCampaignItem(false, mc, ap);
		ci2.SomDig_Menge__c					= 1000;
		ci2.SomDig_Naturalrabatt__c			= 100;
		
		ci1	= Adv_CampaignItem_Naturalrabatt.setNaturalrabatt(ci1);
		ci2	= Adv_CampaignItem_Naturalrabatt.setNaturalrabatt(ci2);
		
		List<ADvendio__Campaign_Item__c> cis	= new List<ADvendio__Campaign_Item__c>{ci1, ci2};
		insert cis;
		
		List<String> campaignItemFieldsToQuery = new List<String>();
		for (Schema.SObjectField soField : Sobjecttype.ADvendio__Campaign_Item__c.fields.getMap().values()) {
			if (soField.getDescribe().isCreateable()) {
				campaignItemFieldsToQuery.add(soField.getDescribe().getName());
			}
		}
		String campaignItemFieldsString	= String.join(campaignItemFieldsToQuery, ',');
		
		ADvendio__Campaign_Item__c ci1Clone	= new ADvendio__Campaign_Item__c();
		ADvendio__Campaign_Item__c ci2Clone	= new ADvendio__Campaign_Item__c();
		
		Test.startTest();
		for (ADvendio__Campaign_Item__c ci : (List<ADvendio__Campaign_Item__c>)Database.query('SELECT Id, '+campaignItemFieldsString+' FROM ADvendio__Campaign_Item__c WHERE Id IN :cis')) {
			if (ci.Id == ci1.Id) {
				ci1	= ci;
				system.assertEquals(1000.0, ci.SomDig_Menge__c);
				system.assertEquals(1000.0, ci.ADvendio__Quantity__c);
				system.assertEquals(0, ci.SomDig_Naturalrabatt__c);
				system.assertEquals(30, ci.ADvendio__Amount_B3APEX__c);
				system.assertEquals(0, ci.ADvendio__SurchargeB3Abs__c);
				ci1Clone										= ci.clone();
				ci1Clone.ADvendio__Ad_Id__c						= null;
				ci1Clone.ADvendio__Additional_Ad_Ids__c			= null;
				ci1Clone.ADvendio__Quantity__c					= - ci.ADvendio__Quantity__c;
				ci1Clone.ADvendio__SurchargeB2Abs__c			= ci.ADvendio__SurchargeB2Abs__c != null ? - ci.ADvendio__SurchargeB2Abs__c : null;
				ci1Clone.ADvendio__SurchargeB3Abs__c			= ci.ADvendio__SurchargeB3Abs__c != null ? - ci.ADvendio__SurchargeB3Abs__c : null;
				ci1Clone.ADvendio__Submit_to_AdServer__c		= false;
				ci1Clone.ADvendio__Query_Inventory__c			= false;
				ci1Clone.ADvendio__Delivered_Clicks__c			= null;
				ci1Clone.ADvendio__Delivered_Impressions__c		= null;
				ci1Clone.ADvendio__OptimizationExclusion__c		= Label.ADvendio.ExclusionContra;
				ci1Clone.ADvendio__PositionReference__c			= ci.Id;
				ci1Clone.ADvendio__ConnectedItem__c				= ci.Id;
			}
			if (ci.Id == ci2.Id) {
				ci2	= ci;
				system.assertEquals(1000.0, ci.SomDig_Menge__c);
				system.assertEquals(2000.0, ci.ADvendio__Quantity__c);
				system.assertEquals(100, ci.SomDig_Naturalrabatt__c);
				system.assertEquals(60, ci.ADvendio__Amount_B3APEX__c);
				system.assertEquals(-30, ci.ADvendio__SurchargeB3Abs__c);
				ci2Clone										= ci.clone();
				ci2Clone.ADvendio__Ad_Id__c						= null;
				ci2Clone.ADvendio__Additional_Ad_Ids__c			= null;
				ci2Clone.ADvendio__Quantity__c					= - ci.ADvendio__Quantity__c;
				ci2Clone.ADvendio__SurchargeB2Abs__c			= ci.ADvendio__SurchargeB2Abs__c != null ? - ci.ADvendio__SurchargeB2Abs__c : null;
				ci2Clone.ADvendio__SurchargeB3Abs__c			= ci.ADvendio__SurchargeB3Abs__c != null ? - ci.ADvendio__SurchargeB3Abs__c : null;
				ci2Clone.ADvendio__Submit_to_AdServer__c		= false;
				ci2Clone.ADvendio__Query_Inventory__c			= false;
				ci2Clone.ADvendio__Delivered_Clicks__c			= null;
				ci2Clone.ADvendio__Delivered_Impressions__c		= null;
				ci2Clone.ADvendio__OptimizationExclusion__c		= Label.ADvendio.ExclusionContra;
				ci2Clone.ADvendio__PositionReference__c			= ci.Id;
				ci2Clone.ADvendio__ConnectedItem__c				= ci.Id;
			}
		}
		
		cis	= new List<ADvendio__Campaign_Item__c>{ci1Clone, ci2Clone};
		insert cis;
		
		for (ADvendio__Campaign_Item__c ci : (List<ADvendio__Campaign_Item__c>)Database.query('SELECT Id, '+campaignItemFieldsString+' FROM ADvendio__Campaign_Item__c WHERE Id IN :cis')) {
			if (ci.Id == ci1Clone.Id) {
				system.assertEquals(-ci1.SomDig_Menge__c.setScale(2, System.RoundingMode.HALF_UP),			ci.SomDig_Menge__c);
				system.assertEquals(-ci1.ADvendio__Quantity__c.setScale(2, System.RoundingMode.HALF_UP),	ci.ADvendio__Quantity__c);
				system.assertEquals(ci1.SomDig_Naturalrabatt__c,											ci.SomDig_Naturalrabatt__c);
				system.assertEquals(-ci1.ADvendio__Amount_B3APEX__c,										ci.ADvendio__Amount_B3APEX__c);
				system.assertEquals(-ci1.ADvendio__SurchargeB3Abs__c,										ci.ADvendio__SurchargeB3Abs__c);
			}
			if (ci.Id == ci2Clone.Id) {
				system.assertEquals(-ci2.SomDig_Menge__c.setScale(2, System.RoundingMode.HALF_UP),			ci.SomDig_Menge__c);
				system.assertEquals(-ci2.ADvendio__Quantity__c.setScale(2, System.RoundingMode.HALF_UP),	ci.ADvendio__Quantity__c);
				system.assertEquals(ci2.SomDig_Naturalrabatt__c,											ci.SomDig_Naturalrabatt__c);
				system.assertEquals(-ci2.ADvendio__Amount_B3APEX__c,										ci.ADvendio__Amount_B3APEX__c);
				system.assertEquals(-ci2.ADvendio__SurchargeB3Abs__c,										ci.ADvendio__SurchargeB3Abs__c);
			}
		}
		Test.stopTest();
	}
}