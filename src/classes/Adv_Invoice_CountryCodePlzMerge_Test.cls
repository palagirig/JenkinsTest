@isTest
private class Adv_Invoice_CountryCodePlzMerge_Test {

	@isTest 
	private static void insertPostalCodeAndCountryCode() {
		ADvendio__MediaCampaign__c objMediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(true);
		ADvendio__Invoice__c objInvoice = cls_P7S1_TestData.createTestInvoice(false, objMediaCampaign);

		Test.startTest();

		objInvoice.ADvendio__RecipientBillingCountry__c = 'D';
		objInvoice.ADvendio__RecipientBillingPostalCode__c = '12345';
		insert objInvoice;

		Test.stopTest();

		ADvendio__Invoice__c objCheckInvoice = [SELECT ADvendio__RecipientBillingCountry__c, ADvendio__RecipientBillingPostalCode__c FROM ADvendio__Invoice__c WHERE ID = :objInvoice.Id];
		System.assertEquals('D - 12345', objCheckInvoice.ADvendio__RecipientBillingPostalCode__c);
	}
	
	@isTest 
	private static void insertOnlyPostalCode() {
		ADvendio__MediaCampaign__c objMediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(true);
		ADvendio__Invoice__c objInvoice = cls_P7S1_TestData.createTestInvoice(false, objMediaCampaign);

		Test.startTest();

		objInvoice.ADvendio__RecipientBillingCountry__c = '';
		objInvoice.ADvendio__RecipientBillingPostalCode__c = '12345';
		insert objInvoice;

		Test.stopTest();

		ADvendio__Invoice__c objCheckInvoice = [SELECT ADvendio__RecipientBillingCountry__c, ADvendio__RecipientBillingPostalCode__c FROM ADvendio__Invoice__c WHERE ID = :objInvoice.Id];
		System.assertEquals('12345', objCheckInvoice.ADvendio__RecipientBillingPostalCode__c);
	}

	@isTest 
	private static void insertOnlyCountryCode() {
		ADvendio__MediaCampaign__c objMediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(true);
		ADvendio__Invoice__c objInvoice = cls_P7S1_TestData.createTestInvoice(false, objMediaCampaign);

		Test.startTest();

		objInvoice.ADvendio__RecipientBillingCountry__c = 'D';
		objInvoice.ADvendio__RecipientBillingPostalCode__c = '';
		insert objInvoice;

		Test.stopTest();

		ADvendio__Invoice__c objCheckInvoice = [SELECT ADvendio__RecipientBillingCountry__c, ADvendio__RecipientBillingPostalCode__c FROM ADvendio__Invoice__c WHERE ID = :objInvoice.Id];
		System.assertEquals('D', objCheckInvoice.ADvendio__RecipientBillingPostalCode__c);

	}

	@isTest 
	private static void updateOnlyPostalCode() {
		ADvendio__MediaCampaign__c objMediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(true);
		ADvendio__Invoice__c objInvoice = cls_P7S1_TestData.createTestInvoice(false, objMediaCampaign);
		objInvoice.ADvendio__RecipientBillingCountry__c = 'D';
		objInvoice.ADvendio__RecipientBillingPostalCode__c = '12345';
		insert objInvoice;

		ADvendio__Invoice__c objCheckInvoice = [SELECT ADvendio__RecipientBillingCountry__c, ADvendio__RecipientBillingPostalCode__c FROM ADvendio__Invoice__c WHERE ID = :objInvoice.Id];
		System.assertEquals('D - 12345', objCheckInvoice.ADvendio__RecipientBillingPostalCode__c);

		Test.startTest();

		objInvoice.ADvendio__RecipientBillingPostalCode__c = '12346';
		update objInvoice;

		Test.stopTest();

		objCheckInvoice = [SELECT ADvendio__RecipientBillingCountry__c, ADvendio__RecipientBillingPostalCode__c FROM ADvendio__Invoice__c WHERE ID = :objInvoice.Id];
		System.assertEquals('D - 12346', objCheckInvoice.ADvendio__RecipientBillingPostalCode__c);

	}

	@isTest 
	private static void updateOnlyPostalCodeWhenCountryIsEmpty() {
		ADvendio__MediaCampaign__c objMediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(true);
		ADvendio__Invoice__c objInvoice = cls_P7S1_TestData.createTestInvoice(false, objMediaCampaign);
		objInvoice.ADvendio__RecipientBillingCountry__c = '';
		objInvoice.ADvendio__RecipientBillingPostalCode__c = '12345';
		insert objInvoice;

		ADvendio__Invoice__c objCheckInvoice = [SELECT ADvendio__RecipientBillingCountry__c, ADvendio__RecipientBillingPostalCode__c FROM ADvendio__Invoice__c WHERE ID = :objInvoice.Id];
		System.assertEquals('12345', objCheckInvoice.ADvendio__RecipientBillingPostalCode__c);

		Test.startTest();

		objInvoice.ADvendio__RecipientBillingPostalCode__c = '12346';
		update objInvoice;

		Test.stopTest();

		objCheckInvoice = [SELECT ADvendio__RecipientBillingCountry__c, ADvendio__RecipientBillingPostalCode__c FROM ADvendio__Invoice__c WHERE ID = :objInvoice.Id];
		System.assertEquals('12346', objCheckInvoice.ADvendio__RecipientBillingPostalCode__c);

	}

	@isTest 
	private static void updateOnlyCountryCode() {
		ADvendio__MediaCampaign__c objMediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(true);
		ADvendio__Invoice__c objInvoice = cls_P7S1_TestData.createTestInvoice(false, objMediaCampaign);
		objInvoice.ADvendio__RecipientBillingCountry__c = 'D';
		objInvoice.ADvendio__RecipientBillingPostalCode__c = '12345';
		insert objInvoice;

		ADvendio__Invoice__c objCheckInvoice = [SELECT ADvendio__RecipientBillingCountry__c, ADvendio__RecipientBillingPostalCode__c FROM ADvendio__Invoice__c WHERE ID = :objInvoice.Id];
		System.assertEquals('D - 12345', objCheckInvoice.ADvendio__RecipientBillingPostalCode__c);

		Test.startTest();

		objInvoice.ADvendio__RecipientBillingCountry__c = 'E';
		update objInvoice;

		Test.stopTest();

		objCheckInvoice = [SELECT ADvendio__RecipientBillingCountry__c, ADvendio__RecipientBillingPostalCode__c FROM ADvendio__Invoice__c WHERE ID = :objInvoice.Id];
		System.assertEquals('E - 12345', objCheckInvoice.ADvendio__RecipientBillingPostalCode__c);

	}

	@isTest 
	private static void updateOnlyCountryCodeWhenPostalCodeIsEmpty() {
		ADvendio__MediaCampaign__c objMediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(true);
		ADvendio__Invoice__c objInvoice = cls_P7S1_TestData.createTestInvoice(false, objMediaCampaign);
		objInvoice.ADvendio__RecipientBillingCountry__c = 'D';
		objInvoice.ADvendio__RecipientBillingPostalCode__c = '';
		insert objInvoice;

		ADvendio__Invoice__c objCheckInvoice = [SELECT ADvendio__RecipientBillingCountry__c, ADvendio__RecipientBillingPostalCode__c FROM ADvendio__Invoice__c WHERE ID = :objInvoice.Id];
		System.assertEquals('D', objCheckInvoice.ADvendio__RecipientBillingPostalCode__c);

		Test.startTest();

		objInvoice.ADvendio__RecipientBillingCountry__c = 'E';
		update objInvoice;

		Test.stopTest();

		objCheckInvoice = [SELECT ADvendio__RecipientBillingCountry__c, ADvendio__RecipientBillingPostalCode__c FROM ADvendio__Invoice__c WHERE ID = :objInvoice.Id];
		System.assertEquals('E', objCheckInvoice.ADvendio__RecipientBillingPostalCode__c);

	}
	
	@isTest 
	private static void updatePostalCodeAndCountryCode() {
		ADvendio__MediaCampaign__c objMediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(true);
		ADvendio__Invoice__c objInvoice = cls_P7S1_TestData.createTestInvoice(false, objMediaCampaign);
		objInvoice.ADvendio__RecipientBillingCountry__c = 'D';
		objInvoice.ADvendio__RecipientBillingPostalCode__c = '12345';
		insert objInvoice;

		ADvendio__Invoice__c objCheckInvoice = [SELECT ADvendio__RecipientBillingCountry__c, ADvendio__RecipientBillingPostalCode__c FROM ADvendio__Invoice__c WHERE ID = :objInvoice.Id];
		System.assertEquals('D - 12345', objCheckInvoice.ADvendio__RecipientBillingPostalCode__c);

		Test.startTest();
		objInvoice.ADvendio__RecipientBillingCountry__c = 'E';
		objInvoice.ADvendio__RecipientBillingPostalCode__c = '12346';
		update objInvoice;

		Test.stopTest();

		objCheckInvoice = [SELECT ADvendio__RecipientBillingCountry__c, ADvendio__RecipientBillingPostalCode__c FROM ADvendio__Invoice__c WHERE ID = :objInvoice.Id];
		System.assertEquals('E - 12346', objCheckInvoice.ADvendio__RecipientBillingPostalCode__c);

	}

	@isTest 
	private static void updatePostalCodeAndCountryCodeWhenBothAreEmpty() {
		ADvendio__MediaCampaign__c objMediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(true);
		ADvendio__Invoice__c objInvoice = cls_P7S1_TestData.createTestInvoice(false, objMediaCampaign);
		objInvoice.ADvendio__RecipientBillingCountry__c = '';
		objInvoice.ADvendio__RecipientBillingPostalCode__c = '';
		insert objInvoice;

		ADvendio__Invoice__c objCheckInvoice = [SELECT ADvendio__RecipientBillingCountry__c, ADvendio__RecipientBillingPostalCode__c FROM ADvendio__Invoice__c WHERE ID = :objInvoice.Id];
		System.assert(String.isBlank(objCheckInvoice.ADvendio__RecipientBillingPostalCode__c));

		Test.startTest();
		objInvoice.ADvendio__RecipientBillingCountry__c = 'E';
		objInvoice.ADvendio__RecipientBillingPostalCode__c = '12346';
		update objInvoice;

		Test.stopTest();

		objCheckInvoice = [SELECT ADvendio__RecipientBillingCountry__c, ADvendio__RecipientBillingPostalCode__c FROM ADvendio__Invoice__c WHERE ID = :objInvoice.Id];
		System.assertEquals('E - 12346', objCheckInvoice.ADvendio__RecipientBillingPostalCode__c);

	}

}