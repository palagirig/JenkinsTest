@isTest
private class Adv_MediaCampaign_PaymentTerms_Test {

    private static testmethod void testAdv_MediaCampaign_PaymentTerms_InsertTest_01() {
        ADvendio__MediaCampaign__c mediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(false);

        Test.StartTest();

        insert mediaCampaign;

        Test.stopTest();

        mediaCampaign = [SELECT ADvendio__PaymentTerms__c, ADvendio__Quote_Language__c, SomDig_Zahlungsbedingung__c FROM ADvendio__MediaCampaign__c WHERE Id = :mediaCampaign.Id];

        System.assertNotEquals(null, mediaCampaign.SomDig_Zahlungsbedingung__c);
        System.assertEquals(cls_P7S1_TestData.Zahlungsbedingung_TestData.Id, mediaCampaign.SomDig_Zahlungsbedingung__c);
        System.assertEquals(cls_P7S1_TestData.Zahlungsbedingung_TestData.Name, mediaCampaign.ADvendio__PaymentTerms__c);
    }

    private static testmethod void testAdv_MediaCampaign_PaymentTerms_InsertTest_02() {
        SomDig_Zahlungsbedingung__c zahlungsbedingung0 = cls_P7S1_TestData.createTestZahlungsbedingung(false);
        SomDig_Zahlungsbedingung__c zahlungsbedingung1 = cls_P7S1_TestData.createTestZahlungsbedingung(false);
        zahlungsbedingung1.SomDig_SAPCode__c = '1234';
        zahlungsbedingung1.SomDig_ZahlungsbedingungEnglisch__c = 'zb1 englisch';
        insert new List<SomDig_Zahlungsbedingung__c>{zahlungsbedingung0, zahlungsbedingung1};

        ADvendio__MediaCampaign__c mediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(false);
        mediaCampaign.SomDig_Zahlungsbedingung__c = zahlungsbedingung1.Id;
        mediaCampaign.ADvendio__Quote_Language__c = 'English';
        
        Test.StartTest();

        insert mediaCampaign;

        Test.stopTest();

        mediaCampaign = [SELECT ADvendio__PaymentTerms__c, ADvendio__Quote_Language__c, SomDig_Zahlungsbedingung__c FROM ADvendio__MediaCampaign__c WHERE Id = :mediaCampaign.Id];

        System.assertNotEquals(null, mediaCampaign.SomDig_Zahlungsbedingung__c);
        System.assertEquals(zahlungsbedingung1.Id, mediaCampaign.SomDig_Zahlungsbedingung__c);
        System.assertEquals(zahlungsbedingung1.SomDig_ZahlungsbedingungEnglisch__c, mediaCampaign.ADvendio__PaymentTerms__c);
    }

    private static testmethod void testAdv_MediaCampaign_PaymentTerms_UpdateTest_01() {
        SomDig_Zahlungsbedingung__c zahlungsbedingung0 = cls_P7S1_TestData.createTestZahlungsbedingung(false);
        SomDig_Zahlungsbedingung__c zahlungsbedingung1 = cls_P7S1_TestData.createTestZahlungsbedingung(false);
        zahlungsbedingung1.SomDig_SAPCode__c = '1234';
        zahlungsbedingung0.SomDig_ZahlungsbedingungEnglisch__c = 'zb0 englisch';
        insert new List<SomDig_Zahlungsbedingung__c>{zahlungsbedingung0, zahlungsbedingung1};

        ADvendio__MediaCampaign__c mediaCampaign = cls_P7S1_TestData.createTestMediaCampaign(false);
        mediaCampaign.SomDig_Zahlungsbedingung__c = zahlungsbedingung1.Id;
        insert mediaCampaign;

        mediaCampaign = [SELECT ADvendio__PaymentTerms__c, ADvendio__Quote_Language__c, SomDig_Zahlungsbedingung__c FROM ADvendio__MediaCampaign__c WHERE Id = :mediaCampaign.Id];

        System.assertNotEquals(null, mediaCampaign.SomDig_Zahlungsbedingung__c);
        System.assertEquals(zahlungsbedingung1.Id, mediaCampaign.SomDig_Zahlungsbedingung__c);
        System.assertEquals(zahlungsbedingung1.Name, mediaCampaign.ADvendio__PaymentTerms__c);

        Test.StartTest();

        mediaCampaign.SomDig_Zahlungsbedingung__c = null;
        mediaCampaign.ADvendio__Quote_Language__c = 'Englisch';
        update mediaCampaign;

        Test.stopTest();

        mediaCampaign = [SELECT ADvendio__PaymentTerms__c, ADvendio__Quote_Language__c, SomDig_Zahlungsbedingung__c FROM ADvendio__MediaCampaign__c WHERE Id = :mediaCampaign.Id];

        System.assertNotEquals(null, mediaCampaign.SomDig_Zahlungsbedingung__c);
        System.assertEquals(zahlungsbedingung0.Id, mediaCampaign.SomDig_Zahlungsbedingung__c);
		System.assertEquals(zahlungsbedingung0.SomDig_ZahlungsbedingungEnglisch__c, mediaCampaign.ADvendio__PaymentTerms__c);
    }
}