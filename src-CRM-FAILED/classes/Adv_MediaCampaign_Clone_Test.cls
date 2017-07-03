@isTest
public class Adv_MediaCampaign_Clone_Test {
    
    @isTest
    static void testPositionOnly(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);    
        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(true, objMK);             
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
		assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        //objCI = queryCampaignItemById(objCI.ID);  
        System.assertEquals(1, mapCampItemCopys.size());      
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true);                                                                                                  
    }

    @isTest
    static void testChangedSalesPrice() {
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);    
        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK);
        objCI.ADvendio__Sales_Price__c = 40;        
        insert objCI;

        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        System.assertEquals(1, mapCampItemCopys.size());      
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true);   
    }

    @isTest
    static void testPositionWithFC(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);
        SomDig_MediagattungsDifferenzierung__c objMGDiff = cls_P7S1_TestData.createTestMediagattungsDifferenzierung(false);
        objMGDiff.Name = 'InStream/Video';
        insert objMGDiff;

        ADvendio__Ad_Specs__c objAdSpec = cls_P7S1_TestData.createTestAdSpec(true, cls_P7S1_TestData.createTestAdType(true, objMGDiff));
        objAdSpec.SomDig_FcAufschlag__c = 5;
        objAdSpec.SomDig_FC__c = true;
        update objAdSpec;

        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK, cls_P7S1_TestData.createTestAdPrice(true, objAdSpec));
        objCI.ADvendio__FC_Quantity__c = 2;
        objCI.ADvendio__FC_Ad_served_every__c = 12;
        objCI.ADvendio__FC_Period__c = 'week';
        objCi.ADvendio__SurchargeSalesPrice__c = 5;
        objCI.SomDig_OtpAufschlag__c = false;
        insert objCI;

        System.assert([SELECT SomDig_FC__C FROM ADvendio__Ad_Specs__c WHERE ID = :objAdSpec.Id].SomDig_FC__c);

        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        //objCI = queryCampaignItemById(objCI.ID);  
        System.assertEquals(1, mapCampItemCopys.size());      
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true); 
        System.assertEquals(5, mapCampItemCopys.get(objCI.Id).ADvendio__SurchargeSalesPrice__c);
        System.assertEquals('week', mapCampItemCopys.get(objCI.Id).ADvendio__FC_Period__c);                                                                                             
    }

    @isTest
    static void testPositionWithOTP(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);
        SomDig_MediagattungsDifferenzierung__c objMGDiff = cls_P7S1_TestData.createTestMediagattungsDifferenzierung(false);
        objMGDiff.Name = 'InStream/Video';
        insert objMGDiff;

        ADvendio__Ad_Specs__c objAdSpec = cls_P7S1_TestData.createTestAdSpec(true, cls_P7S1_TestData.createTestAdType(true, objMGDiff));
        objAdSpec.SomDig_OTPAufschlag__c = 4;
        update objAdSpec;

        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK, cls_P7S1_TestData.createTestAdPrice(true, objAdSpec));
        objCI.SomDig_OTPAufschlag__c = true;
        insert objCI;

        System.assertEquals(4, [SELECT SomDig_OTPAufschlag__c FROM ADvendio__Ad_Specs__c WHERE ID = :objAdSpec.Id].SomDig_OTPAufschlag__c);

        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        //objCI = queryCampaignItemById(objCI.ID);  
        System.assertEquals(1, mapCampItemCopys.size());      
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true); 
        System.assertEquals(4, mapCampItemCopys.get(objCI.Id).ADvendio__SurchargeSalesPrice__c);                                                                                            
    }

    @isTest
    static void testPositionWithTimeTargeting(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);    
        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK);
        objCI.ADvendio__AdHourOfDay__c = '9:00 - 10:00';
        objCI.ADvendio__AdDayOfWeek__c = 'Sunday;Monday';
        objCI.ADvendio__Targetingabbrevation__c = 'AdDayOfWeek: Sunday,Monday; AdHourOfDay: 9:00 - 10:00';
        insert objCI;

        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        //objCI = queryCampaignItemById(objCI.ID);  
        System.assertEquals(1, mapCampItemCopys.size());      
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true); 
        System.assertEquals('9:00 - 10:00', mapCampItemCopys.get(objCI.Id).ADvendio__AdHourOfDay__c); 
        System.assertEquals('Sunday;Monday',mapCampItemCopys.get(objCI.Id).ADvendio__AdDayOfWeek__c);
        System.assertEquals('AdDayOfWeek: Sunday,Monday; AdHourOfDay: 9:00 - 10:00',mapCampItemCopys.get(objCI.Id).ADvendio__Targetingabbrevation__c);                                                                                            
    }
   
    @isTest
    static void testPositionWithTechTargeting(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);    
        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK);
        objCI.ADvendio__AdOperatingSystems__c = 'Apple iOS';
        objCI.ADvendio__AdWebBrowsers__c = 'Firefox;Mozilla';
        objCI.ADvendio__Targetingabbrevation__c = 'AdOperatingSystems: Apple iOS; AdWebBrowsers: Firefox,Mozilla';
        insert objCI;

        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        //objCI = queryCampaignItemById(objCI.ID);  
        System.assertEquals(1, mapCampItemCopys.size());      
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true); 
        System.assertEquals(objCI.ADvendio__AdOperatingSystems__c, mapCampItemCopys.get(objCI.Id).ADvendio__AdOperatingSystems__c); 
        System.assertEquals(objCI.ADvendio__AdWebBrowsers__c,mapCampItemCopys.get(objCI.Id).ADvendio__AdWebBrowsers__c);
        System.assertEquals('AdOperatingSystems: Apple iOS; AdWebBrowsers: Firefox,Mozilla',mapCampItemCopys.get(objCI.Id).ADvendio__Targetingabbrevation__c);                                                                                            
    }

    @isTest
    static void testPositionWithGeoTargeting(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);    
        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK);
        insert objCI;

        ADvendio__Ad_Specs__c objAdSpec = [SELECT SomDig_GtFaehig__c FROM ADvendio__Ad_Specs__c WHERE Id IN (SELECT ADvendio__Ad_Spec__c FROM ADvendio__Ad_Price__c WHERE ID = :objCI.ADvendio__Ad_Price__c) ];
        objAdSpec.SomDig_GtFaehig__c = true;
        objAdSpec.SomDig_Targetingaufschlag__c = 10;
        update objAdSpec;

        ADvendio__City__c objCity = new ADvendio__City__c(ADvendio__Active__c = true, Name = 'Berlin');
        insert objCity;

        ADvendio__Selected_City__c objSelectedCity = new ADvendio__Selected_City__c(ADvendio__City__c = objCity.Id, ADvendio__Campaign_Item__c = objCI.Id);
        insert objSelectedCity;

        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        System.assertEquals(1, mapCampItemCopys.size());      
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true); 
        System.assertEquals(2,[SELECT Count() FROM ADvendio__Selected_City__c]);
        System.assertEquals('Selected City Information: Berlin',mapCampItemCopys.get(objCI.Id).ADvendio__Targetingabbrevation__c);                                                                                            
    }

    @isTest
    static void testPositionWithKeyValueTargeting(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);    
        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK);
        insert objCI;

        ADvendio__KeyLine__c objKeyLine = new Advendio__KeyLine__c(ADvendio__CampaignItem__c = objCI.Id);
        insert objKeyLine;
        ADvendio__AdServer_ID__c objAdServerId = cls_P7S1_TestData.createTestAdServerId(true);
        ADvendio__Key__c objKey = new ADvendio__Key__c(Name = 'Geschlecht', ADvendio__AdServerId__c = objAdServerId.Id, ADvendio__Active__c = true, SomDig_TargetingProvider__c = 'TP1');
        insert objKey;
        ADvendio__Value__c objValueManlich = new ADvendio__Value__c(Name = 'mänlich', ADvendio__Key__c = objKey.Id, ADvendio__Active__c = true);
        ADvendio__Value__c objValueWeiblich = new ADvendio__Value__c(Name = 'weiblich', ADvendio__Key__c = objKey.Id, ADvendio__Active__c = true);
        insert new List<ADvendio__Value__c>{objValueManlich, objValueWeiblich};
        ADvendio__KeyValue__c objKeyValueManlich = new ADvendio__KeyValue__c(ADvendio__KeyLine__c = objKeyLine.Id, ADvendio__Key__c = objKey.Id, ADvendio__Values__c = 'mänlich', ADvendio__Operator__c = 'not equal to');
        ADvendio__KeyValue__c objKeyValueWeiblich = new ADvendio__KeyValue__c(ADvendio__KeyLine__c = objKeyLine.Id, ADvendio__Key__c = objKey.Id, ADvendio__Values__c = 'weiblich', ADvendio__Operator__c = 'equal to');
        insert new List<ADvendio__KeyValue__c>{objKeyValueManlich, objKeyValueWeiblich};

        ADvendio__Ad_Specs__c objAdSpec = [SELECT SomDig_Targetingaufschlag__c FROM ADvendio__Ad_Specs__c WHERE ID IN (SELECT ADvendio__Ad_Spec__c FROM ADvendio__Ad_Price__c WHERE ID = :objCI.ADvendio__Ad_Price__c)];
        objAdSpec.SomDig_Targetingaufschlag__c = 10;
        objAdSpec.SomDig_Targeting_Provider__c = 'TP1;TP2';
        objAdSpec.SomDig_BT__c = true;
        update objAdSpec;

        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        System.assertEquals(1, mapCampItemCopys.size());      
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true);
        System.assert(mapCampItemCopys.get(objCI.Id).ADvendio__Targetingabbrevation__c.contains('(Geschlecht=weiblich)'));
        System.assert(mapCampItemCopys.get(objCI.Id).ADvendio__Targetingabbrevation__c.contains('(Geschlecht!=mänlich)'));                                                                                         
    }

    @isTest
    static void testPositionWithKeyValueTargetingWithExternalName(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);    
        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK);
        insert objCI;

        ADvendio__KeyLine__c objKeyLine = new Advendio__KeyLine__c(ADvendio__CampaignItem__c = objCI.Id);
        insert objKeyLine;
        ADvendio__AdServer_ID__c objAdServerId = cls_P7S1_TestData.createTestAdServerId(true);
        ADvendio__Key__c objKey = new ADvendio__Key__c(Name = 'Geschlecht', ADvendio__ExternalName__c = 'ExternalGeschlecht', ADvendio__AdServerId__c = objAdServerId.Id, ADvendio__Active__c = true, SomDig_TargetingProvider__c = 'TP1');
        insert objKey;
        ADvendio__Value__c objValueManlich = new ADvendio__Value__c(Name = 'mänlich', ADvendio__Key__c = objKey.Id, ADvendio__Active__c = true);
        ADvendio__Value__c objValueWeiblich = new ADvendio__Value__c(Name = 'weiblich', ADvendio__Key__c = objKey.Id, ADvendio__Active__c = true);
        insert new List<ADvendio__Value__c>{objValueManlich, objValueWeiblich};
        ADvendio__KeyValue__c objKeyValueManlich = new ADvendio__KeyValue__c(ADvendio__KeyLine__c = objKeyLine.Id, ADvendio__Key__c = objKey.Id, ADvendio__Values__c = 'mänlich', ADvendio__Operator__c = 'not equal to');
        ADvendio__KeyValue__c objKeyValueWeiblich = new ADvendio__KeyValue__c(ADvendio__KeyLine__c = objKeyLine.Id, ADvendio__Key__c = objKey.Id, ADvendio__Values__c = 'weiblich', ADvendio__Operator__c = 'equal to');
        insert new List<ADvendio__KeyValue__c>{objKeyValueManlich, objKeyValueWeiblich};

        ADvendio__Ad_Specs__c objAdSpec = [SELECT SomDig_Targetingaufschlag__c FROM ADvendio__Ad_Specs__c WHERE ID IN (SELECT ADvendio__Ad_Spec__c FROM ADvendio__Ad_Price__c WHERE ID = :objCI.ADvendio__Ad_Price__c)];
        objAdSpec.SomDig_Targetingaufschlag__c = 10;
        objAdSpec.SomDig_Targeting_Provider__c = 'TP1;TP2';
        objAdSpec.SomDig_BT__c = true;
        update objAdSpec;

        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        System.assertEquals(1, mapCampItemCopys.size());      
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true);
        System.assert(mapCampItemCopys.get(objCI.Id).ADvendio__Targetingabbrevation__c.contains('(ExternalGeschlecht=weiblich)'));
        System.assert(mapCampItemCopys.get(objCI.Id).ADvendio__Targetingabbrevation__c.contains('(ExternalGeschlecht!=mänlich)'));                                                                                         
    }

    @isTest
    static void testPositionWithKeyValueTargetingWithoutBehavioralTargeting(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);    
        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK);
        insert objCI;

        ADvendio__KeyLine__c objKeyLine = new Advendio__KeyLine__c(ADvendio__CampaignItem__c = objCI.Id);
        insert objKeyLine;
        ADvendio__AdServer_ID__c objAdServerId = cls_P7S1_TestData.createTestAdServerId(true);
        ADvendio__Key__c objKey = new ADvendio__Key__c(Name = 'Geschlecht', ADvendio__AdServerId__c = objAdServerId.Id, ADvendio__Active__c = true, SomDig_TargetingProvider__c = 'TP1');
        insert objKey;
        ADvendio__Value__c objValueManlich = new ADvendio__Value__c(Name = 'mänlich', ADvendio__Key__c = objKey.Id, ADvendio__Active__c = true);
        ADvendio__Value__c objValueWeiblich = new ADvendio__Value__c(Name = 'weiblich', ADvendio__Key__c = objKey.Id, ADvendio__Active__c = true);
        insert new List<ADvendio__Value__c>{objValueManlich, objValueWeiblich};
        ADvendio__KeyValue__c objKeyValueManlich = new ADvendio__KeyValue__c(ADvendio__KeyLine__c = objKeyLine.Id, ADvendio__Key__c = objKey.Id, ADvendio__Values__c = 'mänlich', ADvendio__Operator__c = 'not equal to');
        ADvendio__KeyValue__c objKeyValueWeiblich = new ADvendio__KeyValue__c(ADvendio__KeyLine__c = objKeyLine.Id, ADvendio__Key__c = objKey.Id, ADvendio__Values__c = 'weiblich', ADvendio__Operator__c = 'equal to');
        insert new List<ADvendio__KeyValue__c>{objKeyValueManlich, objKeyValueWeiblich};

        ADvendio__Ad_Specs__c objAdSpec = [SELECT SomDig_Targetingaufschlag__c FROM ADvendio__Ad_Specs__c WHERE ID IN (SELECT ADvendio__Ad_Spec__c FROM ADvendio__Ad_Price__c WHERE ID = :objCI.ADvendio__Ad_Price__c)];
        objAdSpec.SomDig_Targetingaufschlag__c = 10;
        objAdSpec.SomDig_Targeting_Provider__c = 'TP1;TP2';
        objAdSpec.SomDig_BT__c = false;
        update objAdSpec;

        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        System.assertEquals(1, mapCampItemCopys.size());      
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true);
        System.assert(mapCampItemCopys.get(objCI.Id).ADvendio__Targetingabbrevation__c.contains('(Geschlecht=weiblich)'));
        System.assert(mapCampItemCopys.get(objCI.Id).ADvendio__Targetingabbrevation__c.contains('(Geschlecht!=mänlich)'));                                                                                      
    }

    @isTest
    static void testPositionAndPackage(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);    
		ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK);
		objCI.ADvendio__SortOrder__c = 4;   
        
        // Create Package
        List<ADvendio__Ad_Specs__c> lstAdS = new List<ADvendio__Ad_Specs__c>();
        for(Integer i=0;i<3;i++){
            lstAdS.add(cls_P7S1_TestData.createTestAdSpec(false));
        }
        insert lstAdS;        

        List<ADvendio__Ad_price__c> lstAdPrice = new List<ADvendio__Ad_price__c>();
        for (Integer i=0;i<3;i++){
            lstAdPrice.add(cls_P7S1_TestData.createTestAdPrice(false, lstAdS[i]));
        }
        insert lstAdPrice;  

        // Package Head
        ADvendio__Campaign_Item__c objCIHead = cls_P7S1_TestData.createTestCampaignItem(false, objMK, lstAdPrice[0]);
        ID packetRCID = [SELECT Id FROM RecordType WHERE SobjectType='ADvendio__Campaign_Item__c' AND Name = 'Packet' LIMIT 1].ID;
        objCIHead.RecordTypeID = packetRCID;
        objCIHead.ADvendio__SortOrder__c = 1;
        insert objCIHead;

        // Package item
        ADvendio__Campaign_Item__c ci01 = cls_P7S1_TestData.createTestCampaignItem(false, objMK, lstAdPrice[1]);
        ci01.ADvendio__PacketItem__c = objCIHead.Id;
        ci01.ADvendio__SortOrder__c = 2;
        ADvendio__Campaign_Item__c ci02 = cls_P7S1_TestData.createTestCampaignItem(false, objMK, lstAdPrice[2]);
        ci02.ADvendio__PacketItem__c = objCIHead.Id;
        ci02.ADvendio__SortOrder__c = 3;
        insert new List<ADvendio__Campaign_Item__c>{ci01,ci02,objCI}; 
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
		assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        setCampIds.add(objCIHead.ID);
        setCampIds.add(ci01.ID);
        setCampIds.add(ci02.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        System.assertEquals(4, mapCampItemCopys.size());     
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true);
        assertCI(mapCampItem.get(objCIHead.Id), mapCampItemCopys.get(objCIHead.Id), true);        
        assertCI(mapCampItem.get(ci01.Id), mapCampItemCopys.get(ci01.Id), true);         
        assertCI(mapCampItem.get(ci02.Id), mapCampItemCopys.get(ci02.Id), true);  
    }

    @isTest
    static void testPackageWithFC(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);       
        
        // Create Package
        List<ADvendio__Ad_Specs__c> lstAdS = new List<ADvendio__Ad_Specs__c>();
        for(Integer i=0;i<3;i++){
            lstAdS.add(cls_P7S1_TestData.createTestAdSpec(false));
        }
        insert lstAdS;        

        List<ADvendio__Ad_price__c> lstAdPrice = new List<ADvendio__Ad_price__c>();
        for (Integer i=0;i<3;i++){
            lstAdPrice.add(cls_P7S1_TestData.createTestAdPrice(false, lstAdS[i]));
        }
        insert lstAdPrice;  

        // Package Head
        ADvendio__Campaign_Item__c objCIHead = cls_P7S1_TestData.createTestCampaignItem(false, objMK, lstAdPrice[0]);
        ID packetRCID = [SELECT Id FROM RecordType WHERE SobjectType='ADvendio__Campaign_Item__c' AND Name = 'Packet' LIMIT 1].ID;
        objCIHead.RecordTypeID = packetRCID;
        objCIHead.ADvendio__SortOrder__c = 1;
        objCIHead.ADvendio__FC_Quantity__c = 2;
        objCIHead.ADvendio__FC_Ad_served_every__c = 1;
        objCIHead.ADvendio__FC_Period__c = 'week';
        insert objCIHead;

        // Package item
        ADvendio__Campaign_Item__c ci01 = cls_P7S1_TestData.createTestCampaignItem(false, objMK, lstAdPrice[1]);
        ci01.ADvendio__PacketItem__c = objCIHead.Id;
        ci01.ADvendio__FC_Quantity__c = 2;
        ci01.ADvendio__FC_Ad_served_every__c = 1;
        ci01.ADvendio__FC_Period__c = 'week';
        ci01.ADvendio__SortOrder__c = 2;

        ADvendio__Campaign_Item__c ci02 = cls_P7S1_TestData.createTestCampaignItem(false, objMK, lstAdPrice[2]);
        ci02.ADvendio__PacketItem__c = objCIHead.Id;
        ci02.ADvendio__FC_Quantity__c = 2;
        ci02.ADvendio__FC_Ad_served_every__c = 1;
        ci02.ADvendio__FC_Period__c = 'week';
        ci02.ADvendio__SortOrder__c = 3;

        insert new List<ADvendio__Campaign_Item__c>{ci01,ci02};       
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCIHead.ID);
        setCampIds.add(ci01.ID);
        setCampIds.add(ci02.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        System.assertEquals(3, mapCampItemCopys.size());     
        assertCI(mapCampItem.get(objCIHead.Id), mapCampItemCopys.get(objCIHead.Id), true);        
        assertCI(mapCampItem.get(ci01.Id), mapCampItemCopys.get(ci01.Id), true);         
        assertCI(mapCampItem.get(ci02.Id), mapCampItemCopys.get(ci02.Id), true);
    }

    @isTest
    static void testPackageWithGeoTargeting(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);       
        
        // Create Package
        List<ADvendio__Ad_Specs__c> lstAdS = new List<ADvendio__Ad_Specs__c>();
        for(Integer i=0;i<3;i++){
            lstAdS.add(cls_P7S1_TestData.createTestAdSpec(false));
        }
        insert lstAdS;
        for(ADvendio__Ad_Specs__c objAdSpec : lstAdS) { 
            objAdSpec.SomDig_GtFaehig__c = true;
            objAdSpec.SomDig_Targetingaufschlag__c = 10;
        }
        update lstAdS;   

        List<ADvendio__Ad_price__c> lstAdPrice = new List<ADvendio__Ad_price__c>();
        for (Integer i=0;i<3;i++){
            lstAdPrice.add(cls_P7S1_TestData.createTestAdPrice(false, lstAdS[i]));
        }
        insert lstAdPrice;  

        // Package Head
        ADvendio__Campaign_Item__c objCIHead = cls_P7S1_TestData.createTestCampaignItem(false, objMK, lstAdPrice[0]);
        ID packetRCID = [SELECT Id FROM RecordType WHERE SobjectType='ADvendio__Campaign_Item__c' AND Name = 'Packet' LIMIT 1].ID;
        objCIHead.RecordTypeID = packetRCID;
        objCIHead.ADvendio__SortOrder__c = 1;
        insert objCIHead;

        // Package item
        ADvendio__Campaign_Item__c ci01 = cls_P7S1_TestData.createTestCampaignItem(false, objMK, lstAdPrice[1]);
        ci01.ADvendio__PacketItem__c = objCIHead.Id;
        ci01.ADvendio__SortOrder__c = 2;

        ADvendio__Campaign_Item__c ci02 = cls_P7S1_TestData.createTestCampaignItem(false, objMK, lstAdPrice[2]);
        ci02.ADvendio__PacketItem__c = objCIHead.Id;
        ci02.ADvendio__SortOrder__c = 3;

        insert new List<ADvendio__Campaign_Item__c>{ci01,ci02};    

        //add geo-targetomg
        ADvendio__City__c objCity = new ADvendio__City__c(ADvendio__Active__c = true, Name = 'Berlin');
        insert objCity;

        ADvendio__Selected_City__c objSelectedCityCIHead = new ADvendio__Selected_City__c(ADvendio__City__c = objCity.Id, ADvendio__Campaign_Item__c = objCIHead.Id);
        ADvendio__Selected_City__c objSelectedCityCi01 = new ADvendio__Selected_City__c(ADvendio__City__c = objCity.Id, ADvendio__Campaign_Item__c = ci01.Id);
        ADvendio__Selected_City__c objSelectedCityCi02 = new ADvendio__Selected_City__c(ADvendio__City__c = objCity.Id, ADvendio__Campaign_Item__c = ci02.Id);
        insert new List<ADvendio__Selected_City__c>{objSelectedCityCIHead, objSelectedCityCi01, objSelectedCityCi02};      
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCIHead.ID);
        setCampIds.add(ci01.ID);
        setCampIds.add(ci02.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        System.assertEquals(3, mapCampItemCopys.size());     
        assertCI(mapCampItem.get(objCIHead.Id), mapCampItemCopys.get(objCIHead.Id), true);        
        assertCI(mapCampItem.get(ci01.Id), mapCampItemCopys.get(ci01.Id), true);         
        assertCI(mapCampItem.get(ci02.Id), mapCampItemCopys.get(ci02.Id), true);

        System.assert([SELECT ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_GtFaehig__c FROM ADvendio__Campaign_Item__c WHERE ID = :objCIHead.Id].ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_GtFaehig__c);

        System.assertEquals('Selected City Information: Berlin', mapCampItemCopys.get(objCIHead.Id).ADvendio__Targetingabbrevation__c); 
        System.assertEquals('Selected City Information: Berlin', mapCampItemCopys.get(ci01.Id).ADvendio__Targetingabbrevation__c); 
        System.assertEquals('Selected City Information: Berlin', mapCampItemCopys.get(ci02.Id).ADvendio__Targetingabbrevation__c);   
    }

    @isTest
    static void testPackageWithProratedDistribution(){
        ID adspecPacketRCID = [SELECT Id FROM RecordType WHERE SobjectType='ADvendio__Ad_Specs__c' AND Name = 'Packet' LIMIT 1].ID;
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);       
        
        // Create Package
        List<ADvendio__Ad_Specs__c> lstAdS = new List<ADvendio__Ad_Specs__c>();
        for(Integer i=0;i<3;i++){
            ADvendio__Ad_Specs__c objAdSpec = cls_P7S1_TestData.createTestAdSpec(false);
            if(i==0) {
                objAdSpec.RecordTypeID = adspecPacketRCID;
                objAdSpec.ADvendio__Distribution__c = 'Prorated';
            }
            lstAdS.add(objAdSpec);
        }
        insert lstAdS;        

        ADvendio__Pricelist__c objPriceList = cls_P7S1_TestData.createTestPricelist(true);

        List<ADvendio__Ad_price__c> lstAdPrice = new List<ADvendio__Ad_price__c>();
        for (Integer i=0;i<3;i++){
            lstAdPrice.add(cls_P7S1_TestData.createTestAdPrice(false, lstAdS[i], objPriceList));
        }
        insert lstAdPrice;

        List<ADvendio__PacketComponent__c> lstPacketComponents = new List<ADvendio__PacketComponent__c>();
        for(Integer i=1;i<3;i++){
            ADvendio__PacketComponent__c objPacketComponent = new ADvendio__PacketComponent__c();
            objPacketComponent.ADvendio__PacketAdSpec__c = lstAdS[0].Id;
            objPacketComponent.ADvendio__PacketItemAdPrice__c = lstAdPrice[0].Id;
            objPacketComponent.ADvendio__ComponentAdSpec__c = lstAdS[i].Id;
            objPacketComponent.ADvendio__ComponentAdPrice__c = lstAdPrice[i].Id;
            objPacketComponent.ADvendio__Prorated__c = 50;
            lstPacketComponents.add(objPacketComponent);
        }
        insert lstPacketComponents;

        // Package Head
        ADvendio__Campaign_Item__c objCIHead = cls_P7S1_TestData.createTestCampaignItem(false, objMK, lstAdPrice[0]);
        ID packetRCID = [SELECT Id FROM RecordType WHERE SobjectType='ADvendio__Campaign_Item__c' AND Name = 'Packet' LIMIT 1].ID;
        objCIHead.RecordTypeID = packetRCID;
        objCIHead.ADvendio__SortOrder__c = 1;
        objCIHead.ADvendio__Quantity__c = 1000;
        insert objCIHead;

        // Package item
        ADvendio__Campaign_Item__c ci01 = cls_P7S1_TestData.createTestCampaignItem(false, objMK, lstAdPrice[1]);
        ci01.ADvendio__PacketItem__c = objCIHead.Id;
        ci01.ADvendio__Prorated__c = 40;
        ci01.ADvendio__SortOrder__c = 2;

        ADvendio__Campaign_Item__c ci02 = cls_P7S1_TestData.createTestCampaignItem(false, objMK, lstAdPrice[2]);
        ci02.ADvendio__PacketItem__c = objCIHead.Id;
        ci02.ADvendio__Prorated__c = 60;
        ci02.ADvendio__SortOrder__c = 3;
        
        insert new List<ADvendio__Campaign_Item__c>{ci01,ci02};

        System.assertEquals(400,[SELECT ADvendio__Quantity__c FROM ADvendio__Campaign_Item__c WHERE ID = :ci01.Id].ADvendio__Quantity__c);
        System.assertEquals(600,[SELECT ADvendio__Quantity__c FROM ADvendio__Campaign_Item__c WHERE ID = :ci02.Id].ADvendio__Quantity__c);
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCIHead.ID);
        setCampIds.add(ci01.ID);
        setCampIds.add(ci02.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        System.assertEquals(3, mapCampItemCopys.size());     
        assertCI(mapCampItem.get(objCIHead.Id), mapCampItemCopys.get(objCIHead.Id), true);        
        assertCI(mapCampItem.get(ci01.Id), mapCampItemCopys.get(ci01.Id), false);         
        assertCI(mapCampItem.get(ci02.Id), mapCampItemCopys.get(ci02.Id), false);
    }

    @isTest
    static void testPositionWithOutdatedAdPrice(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);
        ADvendio__Ad_Specs__c objAdSpec = cls_P7S1_TestData.createTestAdSpec(true);
        ADvendio__Pricelist__c objPricelist = cls_P7S1_TestData.createTestPricelist(true);

        ADvendio__Ad_Price__c objAdPrice1 = cls_P7S1_TestData.createTestAdPrice(false, objAdSpec, objPricelist);
        objAdPrice1.ADvendio__valid_from__c = Date.today().addDays(-1);
        objAdPrice1.ADvendio__valid_to__c = Date.today();
        insert objAdPrice1;

        ADvendio__Ad_Price__c objAdPrice2 = cls_P7S1_TestData.createTestAdPrice(false, objAdSpec, objPricelist);
        objAdPrice2.ADvendio__valid_from__c = Date.today().addDays(1);
        objAdPrice2.ADvendio__valid_to__c = Date.today().addDays(2);
        insert objAdPrice2;

        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(true, objMK, objAdPrice1);

        objAdPrice1.ADvendio__valid_to__c = Date.today().addDays(-1);
        objAdPrice2.ADvendio__valid_from__c = Date.today();
        update new List<Advendio__Ad_Price__c>{objAdPrice1, objAdPrice2};
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
         
        System.assertEquals(0, mapCampItemCopys.size());

        System.assert([SELECT Lcm_Message__c FROM Lcm_BatchLog__c WHERE Lcm_AsyncApexJobId__c = :objCon.jobId].Lcm_Message__c.contains(Label.Adv_MediaCampaign_AdPriceOutdated));

    }

    @isTest
    static void testCampaignWithContacts(){

        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);          
        Contact objContact = cls_P7S1_TestData.createTestContact(true, [SELECT ID FROM Account LIMIT 1]);
        ADvendio__Campaign_Contact__c objCampContact = new ADvendio__Campaign_Contact__c(ADvendio__Contact__c = objContact.Id, ADvendio__Media_Campaign__c = objMK.Id);
        insert objCampContact;

        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);
        System.assertEquals(1, [SELECT Count() FROM ADvendio__Campaign_Contact__c WHERE ADvendio__Media_Campaign__c = :objMK.Id AND ADvendio__Contact__c = :objContact.Id]);                                                                                                 
    }

    @isTest
    static void testPositionWithRetargeting() {
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);

        ADvendio__Ad_Specs__c objAdSpec = cls_P7S1_TestData.createTestAdSpec(true);
        objAdSpec.SomDig_RetargetingSurcharge__c = 4;
        update objAdSpec;

        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK, cls_P7S1_TestData.createTestAdPrice(true, objAdSpec));
        objCI.SomDig_Retargeting__c = true;
        insert objCI;

        System.assertEquals(4, [SELECT SomDig_RetargetingSurcharge__c FROM ADvendio__Ad_Specs__c WHERE ID = :objAdSpec.Id].SomDig_RetargetingSurcharge__c);

        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
    
        System.assertEquals(1, mapCampItemCopys.size());      
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true); 
        System.assertEquals(4, mapCampItemCopys.get(objCI.Id).ADvendio__SurchargeSalesPrice__c);
        System.assertEquals(mapCampItem.get(objCI.Id).SomDig_Retargeting__c, mapCampItemCopys.get(objCI.Id).SomDig_Retargeting__c);

    }

    @isTest
    static void testPositionWithPostalCodeTargeting() {
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);

        ADvendio__Ad_Specs__c objAdSpec = cls_P7S1_TestData.createTestAdSpec(true);
        objAdSpec.SomDig_Targetingaufschlag__c = 10;
        update objAdSpec;

        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(true, objMK, cls_P7S1_TestData.createTestAdPrice(true, objAdSpec));

        List<ADvendio__AdServer_ID__c> postalCodes = new List<ADvendio__AdServer_ID__c>();
        ADvendio__AdServer_ID__c objAdServerId = cls_P7S1_TestData.createTestAdServerId(false);
        objAdServerId.Name = '12345';
        objAdServerId.ADvendio__Category__c = 'Geography';
        objAdServerId.ADvendio__Type__c = 'Postal Code';
        objAdServerId.ADvendio__Active__c = true;
        postalCodes.add(objAdServerId);

        ADvendio__AdServer_ID__c objAdServerId2 = cls_P7S1_TestData.createTestAdServerId(false);
        objAdServerId2.Name = '12346';
        objAdServerId2.ADvendio__Category__c = 'Geography';
        objAdServerId2.ADvendio__Type__c = 'Postal Code';
        objAdServerId2.ADvendio__Active__c = true;
        postalCodes.add(objAdServerId2);
        insert postalCodes;

        List<ADvendio__SelectedAdServerId__c> selectedPostalCodes = new List<ADvendio__SelectedAdServerId__c>();
        ADvendio__SelectedAdServerId__c objSelectedAdServerId = new ADvendio__SelectedAdServerId__c(ADvendio__CampaignItem__c = objCI.Id, ADvendio__AdServerID__c = objAdServerId.Id);
        selectedPostalCodes.add(objSelectedAdServerId);

        ADvendio__SelectedAdServerId__c objSelectedAdServerId2 = new ADvendio__SelectedAdServerId__c(ADvendio__CampaignItem__c = objCI.Id, ADvendio__AdServerID__c = objAdServerId2.Id);
        selectedPostalCodes.add(objSelectedAdServerId2);
        insert selectedPostalCodes;

        System.assertEquals(2, [SELECT count() FROM ADvendio__SelectedAdServerId__c WHERE ADvendio__CampaignItem__c = :objCI.Id AND ADvendio__AdServerId__r.ADvendio__Type__c = 'Postal Code']);

        Test.startTest();

        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions();

        Test.stopTest();

        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);

        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        System.assertEquals(1, mapCampItemCopys.size());
        System.assertEquals(10, mapCampItemCopys.get(objCI.Id).ADvendio__SurchargeSalesPrice__c);
        System.assertEquals('Postal Code: 12345, 12346', mapCampItemCopys.get(objCI.Id).ADvendio__SelectedAdServerIdInformation__c);

    }
    
    /********** Negativ tests **********/
    
    @isTest
    static void testStornoPosition(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);    
        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK);
        objCI.ADvendio__from_Date__c = Date.today().addDays(1);
        objCI.ADvendio__Rate_Discount_4_Name__c = 'Storno ohne Leistungsfluss';
        insert objCI;

        // It's possible some positions where cancelled in a way that didn't set the Rate_Discount_4_Name field and detects them by the dot in Position appendix instead.
        ADvendio__Campaign_Item__c objCISpecialStorno = cls_P7S1_TestData.createTestCampaignItem(false, objMK);
        objCISpecialStorno.ADvendio__from_Date__c = Date.today().addDays(1);
        objCISpecialStorno.ADvendio__PositionNumberAppendix__c = '.1';
        insert objCISpecialStorno;


        // It's possible some positions where cancelled in a way that didn't set the Rate_Discount_4_Name nor Positions Appendix, but still are connected to the storno pos.
        ADvendio__Campaign_Item__c objCIEvenMoreSpecialStorno = cls_P7S1_TestData.createTestCampaignItem(false, objMK);
        objCIEvenMoreSpecialStorno.ADvendio__from_Date__c = Date.today().addDays(1);
        objCIEvenMoreSpecialStorno.ADvendio__ConnectedItem__c = objCI.Id;
        insert objCIEvenMoreSpecialStorno;
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
		assertMK(objMK, objNewMK);

        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        setCampIds.add(objCISpecialStorno.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        System.assertEquals(0, mapCampItemCopys.size());        
        
    }  
    
    @isTest
    static void testPositionWithInvalidFC(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);
        SomDig_MediagattungsDifferenzierung__c objMGDiff = cls_P7S1_TestData.createTestMediagattungsDifferenzierung(false);
        objMGDiff.Name = 'InStream/Video';
        insert objMGDiff;

        ADvendio__Ad_Specs__c objAdSpec = cls_P7S1_TestData.createTestAdSpec(true, cls_P7S1_TestData.createTestAdType(true, objMGDiff));
        objAdSpec.SomDig_FcAufschlag__c = 5;
        objAdSpec.SomDig_FC__c = false;
        update objAdSpec;

        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK, cls_P7S1_TestData.createTestAdPrice(true, objAdSpec));
        objCI.ADvendio__FC_Quantity__c = 2;
        objCI.ADvendio__FC_Ad_served_every__c = 12;
        objCI.ADvendio__FC_Period__c = 'week';
        objCi.ADvendio__SurchargeSalesPrice__c = 5;
        objCI.SomDig_OtpAufschlag__c = false;
        insert objCI;

        System.assert(![SELECT SomDig_FC__C FROM ADvendio__Ad_Specs__c WHERE ID = :objAdSpec.Id].SomDig_FC__c);


        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        //objCI = queryCampaignItemById(objCI.ID);  
        System.assertEquals(1, mapCampItemCopys.size());      
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true);
        System.assertEquals(null, mapCampItemCopys.get(objCI.Id).ADvendio__SurchargeSalesPrice__c);
        System.assertNotEquals(12, mapCampItemCopys.get(objCI.Id).ADvendio__FC_Ad_served_every__c);
        System.assertNotEquals('week', mapCampItemCopys.get(objCI.Id).ADvendio__FC_Period__c);                                                                                             
    }

    @isTest
    static void testPositionWithInvalidGeoTargetingNotBtFaehig(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);    
        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK);
        insert objCI;

        ADvendio__Ad_Specs__c objAdSpec = [SELECT SomDig_GtFaehig__c FROM ADvendio__Ad_Specs__c WHERE Id IN (SELECT ADvendio__Ad_Spec__c FROM ADvendio__Ad_Price__c WHERE ID = :objCI.ADvendio__Ad_Price__c) ];
        objAdSpec.SomDig_GtFaehig__c = false;
        objAdSpec.SomDig_Targetingaufschlag__c = 10;
        update objAdSpec;

        ADvendio__City__c objCity = new ADvendio__City__c(ADvendio__Active__c = true, Name = 'Berlin');
        insert objCity;

        ADvendio__Selected_City__c objSelectedCity = new ADvendio__Selected_City__c(ADvendio__City__c = objCity.Id, ADvendio__Campaign_Item__c = objCI.Id);
        insert objSelectedCity;

        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        System.assertEquals(1, mapCampItemCopys.size());      
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true); 
        System.assertEquals(1, [SELECT Count() FROM ADvendio__Selected_City__c]);
        System.assertEquals(null, mapCampItemCopys.get(objCI.Id).ADvendio__Targetingabbrevation__c);                                                                                            
    }

    @isTest
    static void testPositionWithInvalidGeoTargetingNoTargetingSurcharge(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);    
        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK);
        insert objCI;

        ADvendio__Ad_Specs__c objAdSpec = [SELECT SomDig_GtFaehig__c FROM ADvendio__Ad_Specs__c WHERE Id IN (SELECT ADvendio__Ad_Spec__c FROM ADvendio__Ad_Price__c WHERE ID = :objCI.ADvendio__Ad_Price__c) ];
        objAdSpec.SomDig_GtFaehig__c = true;
        objAdSpec.SomDig_Targetingaufschlag__c = null;
        update objAdSpec;

        ADvendio__City__c objCity = new ADvendio__City__c(ADvendio__Active__c = true, Name = 'Berlin');
        insert objCity;

        ADvendio__Selected_City__c objSelectedCity = new ADvendio__Selected_City__c(ADvendio__City__c = objCity.Id, ADvendio__Campaign_Item__c = objCI.Id);
        insert objSelectedCity;

        System.assertEquals(null, [SELECT SomDig_Targetingaufschlag__c FROM ADvendio__Ad_Specs__c WHERE Id IN (SELECT ADvendio__Ad_Spec__c FROM ADvendio__Ad_Price__c WHERE ID = :objCI.ADvendio__Ad_Price__c)].SomDig_Targetingaufschlag__c);
        System.assert([SELECT SomDig_GtFaehig__c FROM ADvendio__Ad_Specs__c WHERE Id IN (SELECT ADvendio__Ad_Spec__c FROM ADvendio__Ad_Price__c WHERE ID = :objCI.ADvendio__Ad_Price__c)].SomDig_GtFaehig__c);

        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions();
                
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        System.assertEquals(1, mapCampItemCopys.size());      
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true); 
        System.assertEquals(1,[SELECT Count() FROM ADvendio__Selected_City__c]);
        System.assertEquals(null ,mapCampItemCopys.get(objCI.Id).ADvendio__Targetingabbrevation__c);                                                                                            
    }

    @isTest
    static void testPositionWithInactivPrice(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);    
        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(true, objMK);        
        
       	ADvendio__Ad_Price__c objAdPrice = [SELECT Id, ADvendio__Active__c
                                            	FROM ADvendio__Ad_Price__c
                                            	WHERE ID = :objCI.ADvendio__Ad_Price__c];
        objAdPrice.ADvendio__Active__c = false;
        update objAdPrice;
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest();   
        
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
		assertMK(objMK, objNewMK);                                                                                        

        List<ADvendio__Campaign_Item__c> lstCampPos = [SELECT ID FROM ADvendio__Campaign_Item__c WHERE SomDig_SourceCampaignItem__c = :objCI.ID];
        System.assertEquals(0, lstCampPos.size()); 
    }
    
    @isTest
    static void testPackageHeaderWithInactivPrice(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);    
		ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK);        
        
        // Create Package
        List<ADvendio__Ad_Specs__c> lstAdS = new List<ADvendio__Ad_Specs__c>();
        for(Integer i=0;i<3;i++){
            lstAdS.add(cls_P7S1_TestData.createTestAdSpec(false));
        }
        insert lstAdS;        

        List<ADvendio__Ad_price__c> lstAdPrice = new List<ADvendio__Ad_price__c>();
        for (Integer i=0;i<3;i++){
            lstAdPrice.add(cls_P7S1_TestData.createTestAdPrice(false, lstAdS[i]));
        }
        insert lstAdPrice;  

        // Package Head
        ADvendio__Campaign_Item__c objCIHead = cls_P7S1_TestData.createTestCampaignItem(false, objMK, lstAdPrice[0]);
        ID packetRCID = [SELECT Id FROM RecordType WHERE SobjectType='ADvendio__Campaign_Item__c' AND Name = 'Packet' LIMIT 1].ID;
        objCIHead.RecordTypeID = packetRCID;
        insert objCIHead;
        
        lstAdPrice[0].ADvendio__Active__c = false;
        update lstAdPrice[0];

        // Package item
        ADvendio__Campaign_Item__c ci01 = cls_P7S1_TestData.createTestCampaignItem(false, objMK, lstAdPrice[1]);
        ci01.ADvendio__PacketItem__c = objCIHead.Id;
        ADvendio__Campaign_Item__c ci02 = cls_P7S1_TestData.createTestCampaignItem(false, objMK, lstAdPrice[2]);
        ci02.ADvendio__PacketItem__c = objCIHead.Id;
        insert new List<ADvendio__Campaign_Item__c>{ci01,ci02,objCI};
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
		assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        setCampIds.add(objCIHead.ID);
        setCampIds.add(ci01.ID);
        setCampIds.add(ci02.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
         
        //objCI = queryCampaignItemById(objCI.ID); 
        System.assertEquals(1, mapCampItemCopys.size()); 
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true);
           
        System.assert(!mapCampItemCopys.containsKey(objCIHead.Id), 'Expected Value : false, asserted Value: '+(mapCampItemCopys.containsKey(objCIHead.Id)));        
    }
    
    @isTest
    static void testPackageCompWithInactivPrice(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);    
		ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK);        
        
        // Create Package
        List<ADvendio__Ad_Specs__c> lstAdS = new List<ADvendio__Ad_Specs__c>();
        for(Integer i=0;i<3;i++){
            lstAdS.add(cls_P7S1_TestData.createTestAdSpec(false));
        }
        insert lstAdS;        

        List<ADvendio__Ad_price__c> lstAdPrice = new List<ADvendio__Ad_price__c>();
        for (Integer i=0;i<3;i++){
            lstAdPrice.add(cls_P7S1_TestData.createTestAdPrice(false, lstAdS[i]));
        }
        insert lstAdPrice;  

        // Package Head
        ADvendio__Campaign_Item__c objCIHead = cls_P7S1_TestData.createTestCampaignItem(false, objMK, lstAdPrice[0]);
        ID packetRCID = [SELECT Id FROM RecordType WHERE SobjectType='ADvendio__Campaign_Item__c' AND Name = 'Packet' LIMIT 1].ID;
        objCIHead.RecordTypeID = packetRCID;
        insert objCIHead;

        // Package item
        ADvendio__Campaign_Item__c ci01 = cls_P7S1_TestData.createTestCampaignItem(false, objMK, lstAdPrice[1]);
        ci01.ADvendio__PacketItem__c = objCIHead.Id;
        ADvendio__Campaign_Item__c ci02 = cls_P7S1_TestData.createTestCampaignItem(false, objMK, lstAdPrice[2]);
        ci02.ADvendio__PacketItem__c = objCIHead.Id;
        insert new List<ADvendio__Campaign_Item__c>{ci01,ci02,objCI};
        lstAdPrice[1].ADvendio__Active__c = false;
        update lstAdPrice[1];
        
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
		assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
         
        System.assertEquals(1, mapCampItemCopys.size()); 
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true); 
    }

    @isTest
    static void testPositionWithKeyValueTargetingWithoutTargetingSurcharge(){
        // Key values should not be cloned on a position whose AdSpec does not have any targeting surcharge.

        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);    
        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK);
        insert objCI;

        ADvendio__KeyLine__c objKeyLine = new Advendio__KeyLine__c(ADvendio__CampaignItem__c = objCI.Id);
        insert objKeyLine;
        ADvendio__AdServer_ID__c objAdServerId = cls_P7S1_TestData.createTestAdServerId(true);
        ADvendio__Key__c objKey = new ADvendio__Key__c(Name = 'Geschlecht', ADvendio__AdServerId__c = objAdServerId.Id, ADvendio__Active__c = true);
        insert objKey;
        ADvendio__Value__c objValueManlich = new ADvendio__Value__c(Name = 'mänlich', ADvendio__Key__c = objKey.Id, ADvendio__Active__c = true);
        ADvendio__Value__c objValueWeiblich = new ADvendio__Value__c(Name = 'weiblich', ADvendio__Key__c = objKey.Id, ADvendio__Active__c = true);
        insert new List<ADvendio__Value__c>{objValueManlich, objValueWeiblich};
        ADvendio__KeyValue__c objKeyValueManlich = new ADvendio__KeyValue__c(ADvendio__KeyLine__c = objKeyLine.Id, ADvendio__Key__c = objKey.Id, ADvendio__Values__c = 'mänlich', ADvendio__Operator__c = 'not equal to');
        ADvendio__KeyValue__c objKeyValueWeiblich = new ADvendio__KeyValue__c(ADvendio__KeyLine__c = objKeyLine.Id, ADvendio__Key__c = objKey.Id, ADvendio__Values__c = 'weiblich', ADvendio__Operator__c = 'equal to');
        insert new List<ADvendio__KeyValue__c>{objKeyValueManlich, objKeyValueWeiblich};

        ADvendio__Ad_Specs__c objAdSpec = [SELECT SomDig_Targetingaufschlag__c FROM ADvendio__Ad_Specs__c WHERE ID IN (SELECT ADvendio__Ad_Spec__c FROM ADvendio__Ad_Price__c WHERE ID = :objCI.ADvendio__Ad_Price__c)];
        objAdSpec.SomDig_Targetingaufschlag__c = null;
        update objAdSpec;


        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        System.assertEquals(1, mapCampItemCopys.size());
        System.assert(String.isBlank(mapCampItemCopys.get(objCI.Id).ADvendio__Targetingabbrevation__c));
        System.assertEquals(0, [SELECT Count() FROM ADvendio__KeyLine__c WHERE ADvendio__CampaignItem__c = :mapCampItemCopys.get(objCI.Id).Id]);
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true);                                                                                        
    }

    @isTest
    static void testPositionWithKeyValueTargetingWithoutTargetingProvider(){
        // Key values should not be cloned on a position whose AdSpec does not have any targeting surcharge.

        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);    
        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK);
        insert objCI;

        ADvendio__KeyLine__c objKeyLine = new Advendio__KeyLine__c(ADvendio__CampaignItem__c = objCI.Id);
        insert objKeyLine;
        ADvendio__AdServer_ID__c objAdServerId = cls_P7S1_TestData.createTestAdServerId(true);
        ADvendio__Key__c objKey = new ADvendio__Key__c(Name = 'Geschlecht', ADvendio__AdServerId__c = objAdServerId.Id, ADvendio__Active__c = true, SomDig_TargetingProvider__c = 'TP1');
        insert objKey;
        ADvendio__Value__c objValueManlich = new ADvendio__Value__c(Name = 'mänlich', ADvendio__Key__c = objKey.Id, ADvendio__Active__c = true);
        ADvendio__Value__c objValueWeiblich = new ADvendio__Value__c(Name = 'weiblich', ADvendio__Key__c = objKey.Id, ADvendio__Active__c = true);
        insert new List<ADvendio__Value__c>{objValueManlich, objValueWeiblich};
        ADvendio__KeyValue__c objKeyValueManlich = new ADvendio__KeyValue__c(ADvendio__KeyLine__c = objKeyLine.Id, ADvendio__Key__c = objKey.Id, ADvendio__Values__c = 'mänlich', ADvendio__Operator__c = 'not equal to');
        ADvendio__KeyValue__c objKeyValueWeiblich = new ADvendio__KeyValue__c(ADvendio__KeyLine__c = objKeyLine.Id, ADvendio__Key__c = objKey.Id, ADvendio__Values__c = 'weiblich', ADvendio__Operator__c = 'equal to');
        insert new List<ADvendio__KeyValue__c>{objKeyValueManlich, objKeyValueWeiblich};

        ADvendio__Ad_Specs__c objAdSpec = [SELECT SomDig_Targetingaufschlag__c FROM ADvendio__Ad_Specs__c WHERE ID IN (SELECT ADvendio__Ad_Spec__c FROM ADvendio__Ad_Price__c WHERE ID = :objCI.ADvendio__Ad_Price__c)];
        objAdSpec.SomDig_Targetingaufschlag__c = 10;
        objAdSpec.SomDig_Targeting_Provider__c = 'TP2';
        update objAdSpec;


        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        System.assertEquals(1, mapCampItemCopys.size());
        System.assert(String.isBlank(mapCampItemCopys.get(objCI.Id).ADvendio__Targetingabbrevation__c), 'Actual value: '+mapCampItemCopys.get(objCI.Id).ADvendio__Targetingabbrevation__c);
        System.assertEquals(0, [SELECT Count() FROM ADvendio__KeyLine__c WHERE ADvendio__CampaignItem__c = :mapCampItemCopys.get(objCI.Id).Id]);
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true);                                                                                        
    }

    @isTest
    static void testPositionWithDisabledRetargeting() {
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);

        ADvendio__Ad_Specs__c objAdSpec = cls_P7S1_TestData.createTestAdSpec(true);
        objAdSpec.SomDig_RetargetingSurcharge__c = 4;
        update objAdSpec;

        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK, cls_P7S1_TestData.createTestAdPrice(true, objAdSpec));
        objCI.SomDig_Retargeting__c = true;
        objCI.ADvendio__SurchargeSalesPrice__c = 4;
        insert objCI;

        objCI.SomDig_Retargeting__c = false;
        update objCI;

        System.assertEquals(4, [SELECT SomDig_RetargetingSurcharge__c FROM ADvendio__Ad_Specs__c WHERE ID = :objAdSpec.Id].SomDig_RetargetingSurcharge__c);

        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
    
        System.assertEquals(1, mapCampItemCopys.size());      
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true); 
        System.assertEquals(null, mapCampItemCopys.get(objCI.Id).ADvendio__SurchargeSalesPrice__c);
        System.assertEquals(mapCampItem.get(objCI.Id).SomDig_Retargeting__c, mapCampItemCopys.get(objCI.Id).SomDig_Retargeting__c);

    }

    @isTest
    static void testPositionWithRetargetingWithoutSurcharge() {
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);

        ADvendio__Ad_Specs__c objAdSpec = cls_P7S1_TestData.createTestAdSpec(true);
        objAdSpec.SomDig_RetargetingSurcharge__c = 4;
        update objAdSpec;

        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK, cls_P7S1_TestData.createTestAdPrice(true, objAdSpec));
        objCI.SomDig_Retargeting__c = true;
        objCI.ADvendio__SurchargeSalesPrice__c = 4;
        insert objCI;

        objAdSpec.SomDig_RetargetingSurcharge__c = null;
        update objAdSpec;

        System.assertEquals(null, [SELECT SomDig_RetargetingSurcharge__c FROM ADvendio__Ad_Specs__c WHERE ID = :objAdSpec.Id].SomDig_RetargetingSurcharge__c);

        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
    
        System.assertEquals(1, mapCampItemCopys.size());      
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true); 
        System.assertEquals(null, mapCampItemCopys.get(objCI.Id).ADvendio__SurchargeSalesPrice__c);
        System.assertEquals(false, mapCampItemCopys.get(objCI.Id).SomDig_Retargeting__c);

    }

    @isTest
    static void testPositionWithDisabledOTP(){
        ADvendio__MediaCampaign__c objMK = cls_P7S1_TestData.createTestMediaCampaign(true);
        SomDig_MediagattungsDifferenzierung__c objMGDiff = cls_P7S1_TestData.createTestMediagattungsDifferenzierung(false);
        objMGDiff.Name = 'InStream/Video';
        insert objMGDiff;

        ADvendio__Ad_Specs__c objAdSpec = cls_P7S1_TestData.createTestAdSpec(true, cls_P7S1_TestData.createTestAdType(true, objMGDiff));
        objAdSpec.SomDig_OTPAufschlag__c = 4;
        update objAdSpec;

        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(false, objMK, cls_P7S1_TestData.createTestAdPrice(true, objAdSpec));
        objCI.SomDig_OTPAufschlag__c = true;
        objCI.ADvendio__SurchargeSalesPrice__c = 4;
        insert objCI;

        objCI.SomDig_OtpAufschlag__c = false;
        update objCI;

        System.assertEquals(4, [SELECT SomDig_OTPAufschlag__c FROM ADvendio__Ad_Specs__c WHERE ID = :objAdSpec.Id].SomDig_OTPAufschlag__c);
        System.assertEquals(false, [SELECT SomDig_OTPAufschlag__c FROM ADvendio__Campaign_Item__c WHERE ID = :objCI.Id].SomDig_OTPAufschlag__c);

        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('/apex/Adv_MediaCampaign_Clone?id=' + objMK.ID)); 
        Adv_MediaCampaign_Clone objCon = new Adv_MediaCampaign_Clone();
        objCon.cloneWithPositions(); 
        
        Test.stopTest(); 
        
        // Check MK
        objMK = queryMediaCampaign(objMK);
        ADvendio__MediaCampaign__c objNewMK = queryClonedMediaCampaign(objMK);
        assertMK(objMK, objNewMK);      
        
        // Check Position
        Set<Id> setCampIds = new Set<Id>();
        setCampIds.add(objCI.ID);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItemCopys = queryCampaignItemCopyById(setCampIds);
        Map<Id, ADvendio__Campaign_Item__c> mapCampItem = queryCampaignItemById(setCampIds);
        
        //objCI = queryCampaignItemById(objCI.ID);  
        System.assertEquals(1, mapCampItemCopys.size());      
        assertCI(mapCampItem.get(objCI.Id), mapCampItemCopys.get(objCI.Id), true); 
        System.assertEquals(null, mapCampItemCopys.get(objCI.Id).ADvendio__SurchargeSalesPrice__c);                                                                                            
    }
    
    /**********  Helper Methods  **********/

    private static void assertMK(ADvendio__MediaCampaign__c objMK, ADvendio__MediaCampaign__c objNewMK){
        System.assert(objNewMK.ID != objMK.ID);        
        System.assert(objNewMK.Name == 'CLONE_'+objMK.Name);
        System.assert(objNewMK.ADvendio__Stage__c == 'First Contact');                                                        
        System.assert(objNewMK.ADvendio__Document_type__c == 'Offer' || objNewMK.ADvendio__Document_type__c == 'Angebot');  
        
        System.assert(objNewMK.SomDig_BetreuerSales__c == objMK.SomDig_BetreuerSales__c);
        System.assert(objNewMK.SomDig_BetreuerPam__c == objMK.SomDig_BetreuerPam__c);
        System.assert(objNewMK.SomDig_AdManager__c == objMK.SomDig_AdManager__c);
        System.assert(objNewMK.SomDig_BetreuerTeam__c == objMK.SomDig_BetreuerTeam__c);
        System.assert(objNewMK.SomDig_WtAgBeziehung__c == objMK.SomDig_WtAgBeziehung__c);
        System.assert(objNewMK.ADvendio__invoice_recipient__c == objMK.ADvendio__invoice_recipient__c);
        System.assert(objNewMK.ADvendio__Pricelist__c == objMK.ADvendio__Pricelist__c);                                                       
        System.assert(objNewMK.SomDig_Kundenrabatt_InPage__c == objMK.SomDig_Kundenrabatt_InPage__c);        
        System.assert(objNewMK.SomDig_Kundenrabatt_InStream__c == objMK.SomDig_Kundenrabatt_InStream__c);        
        System.assert(objNewMK.SomDig_Sonderrabatt_InPage__c == objMK.SomDig_Sonderrabatt_InPage__c);  
        System.assert(objNewMK.SomDig_Sonderrabatt_InStream__c == objMK.SomDig_Sonderrabatt_InStream__c);   
        System.assert(objNewMK.SomDig_Naturalrabatt_Inpage__c == objMK.SomDig_Naturalrabatt_Inpage__c);        
        System.assert(objNewMK.ADvendio__Rate_Discount_2__c == objMK.ADvendio__Rate_Discount_2__c);        
        System.assert(objNewMK.SomDig_Commitment__c == objMK.SomDig_Commitment__c);                        
        System.assert(objNewMK.SomDig_RabatteMKgenehmigt__c == true);                        
        System.assert(objNewMK.SomDig_Agenturrabatt__c == objMK.SomDig_Agenturrabatt__c);                                
        System.assert(objNewMK.ADvendio__PaymentInterval__c == objMK.ADvendio__PaymentInterval__c);                                
        System.assert(objNewMK.ADvendio__PaymentStart__c == objMK.ADvendio__PaymentStart__c);                                
        System.assert(objNewMK.ADvendio__PaymentDueDate__c == objMK.ADvendio__PaymentDueDate__c);                                
        System.assert(objNewMK.ADvendio__TermsOfPayment__c == objMK.ADvendio__TermsOfPayment__c);                                
        System.assert(objNewMK.ADvendio__BillMe__c == objMK.ADvendio__BillMe__c);                                
        System.assert(objNewMK.ADvendio__Quote_Language__c == objMK.ADvendio__Quote_Language__c);                                
        System.assert(objNewMK.ADvendio__Quote_Locale__c == objMK.ADvendio__Quote_Locale__c);                                                                                
        System.assertEquals(objMK.CurrencyIsoCode, objNewMK.CurrencyIsoCode);
        System.assertEquals(objMK.SomDig_SACConceptionManager__c, objNewMK.SomDig_SACConceptionManager__c);
        System.assertEquals(objMK.SomDig_Zahlungsbedingung__c, objNewMK.SomDig_Zahlungsbedingung__c);
        System.assertEquals(objMK.SomDig_Restwerbezeit__c, objNewMK.SomDig_Restwerbezeit__c);
    }
    
    private static void assertCI(ADvendio__Campaign_Item__c objCI, ADvendio__Campaign_Item__c objNewCI, Boolean checkQuantity){
        System.assert(objCI.RecordTypeID == objNewCI.RecordTypeID);                                                                                        
        System.assert(objCI.Name == objNewCI.Name);                                                                                        
        System.assert(objCI.ADvendio__Agency_Commission__c == objNewCI.ADvendio__Agency_Commission__c);                                                                                        
        System.assert(objCI.ADvendio__Ad_Price__c == objNewCI.ADvendio__Ad_Price__c);                                                                                        
        System.assert(objCI.ADvendio__from_Date__c == objNewCI.ADvendio__from_Date__c);                                                                                        
        System.assert(objCI.ADvendio__until_Date__c == objNewCI.ADvendio__until_Date__c);                                                                                        
        if(checkQuantity) System.assert(objCI.ADvendio__Quantity__c == objNewCI.ADvendio__Quantity__c);                                                                                        
        System.assert(objCI.ADvendio__list_price__c == objNewCI.ADvendio__Sales_Price__c);                                                                                        
        System.assert(objCI.ADvendio__Billing_category__c == objNewCI.ADvendio__Billing_category__c);                                                                                        
        System.assert(objCI.ADvendio__AC__c == objNewCI.ADvendio__AC__c);                                                                                        
        System.assert(objCI.ADvendio__Rate_Discount_2_custom__c == objNewCI.ADvendio__Rate_Discount_2_custom__c);                                                                                        
        System.assert(objCI.ADvendio__Rate_Discount_3_custom__c == objNewCI.ADvendio__Rate_Discount_3_custom__c);                                                                                        
        System.assert(objCI.ADvendio__Rate_Discount_4__c == objNewCI.ADvendio__Rate_Discount_4__c);                                                                                        
        System.assert(objCI.ADvendio__Rate_Discount_4_Name__c == objNewCI.ADvendio__Rate_Discount_4_Name__c);
        System.assert(objCI.ADvendio__SortOrder__c == objNewCI.ADvendio__SortOrder__c, 'Original: '+objCI.ADvendio__SortOrder__c+' / Copy: '+objNewCI.ADvendio__SortOrder__c);
        System.assertEquals(objCI.ADvendio__RateDiscount2Name__c, objNewCI.ADvendio__RateDiscount2Name__c);
        

         if(objCI.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_FC__c){
            System.assertEquals(objCI.ADvendio__FC_Quantity__c,objNewCI.ADvendio__FC_Quantity__c);
            System.assertEquals(objCI.ADvendio__FC_Ad_served_every__c,objNewCI.ADvendio__FC_Ad_served_every__c);
            System.assertEquals(objCI.ADvendio__FC_Period__c,objNewCI.ADvendio__FC_Period__c);
        }
    }
    
    private static Map<Id, ADvendio__Campaign_Item__c> queryCampaignItemById(Set<Id> setIdCampItem){
        List<ADvendio__Campaign_Item__c> lstCampItems = [SELECT ID, SomDig_SourceCampaignItem__c, ADvendio__PacketItem__c,RecordType.DeveloperName, RecordTypeID,  
                ADvendio__Rate_Discount_4__c, ADvendio__Rate_Discount_3_custom__c, ADvendio__Rate_Discount_2_custom__c, ADvendio__Agency_Commission__c, 
                ADvendio__Sales_Price__c, ADvendio__Billing_category__c, ADvendio__Media_Campaign__c, ADvendio__AC__c, ADvendio__Rate_Discount_4_Name__c,
                ADvendio__Quantity__c, ADvendio__until_Date__c, ADvendio__from_Date__c, SomDig_OtpAufschlag__c, ADvendio__Ad_Price__c, Name, ADvendio__SortOrder__c,
                ADvendio__FC_Quantity__c, ADvendio__FC_Ad_served_every__c, ADvendio__FC_Period__c, ADvendio__RateDiscount2Name__c, 
                ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_FC__c, ADvendio__AdHourOfDay__c, ADvendio__AdDayOfWeek__c, ADvendio__Targetingabbrevation__c,
                ADvendio__AdOperatingSystems__c, ADvendio__AdWebBrowsers__c, SomDig_ADGapID__c,
                ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_GtFaehig__c, ADvendio__list_price__c, ADvendio__SurchargeSalesPrice__c, SomDig_Retargeting__c,
                ADvendio__SelectedAdServerIdInformation__c
                	FROM ADvendio__Campaign_Item__c 
                	WHERE ID in :setIdCampItem];
        Map<Id, ADvendio__Campaign_Item__c> mapCampItems = new Map<Id, ADvendio__Campaign_Item__c>();
        for(ADvendio__Campaign_Item__c item :lstCampItems){
            mapCampItems.put(item.Id, item);
        }

        return mapCampItems;
    } 
    
    private static Map<Id, ADvendio__Campaign_Item__c> queryCampaignItemCopyById(Set<Id> setIdCampItem){
        List<ADvendio__Campaign_Item__c> lstCampItems = [SELECT ID, SomDig_SourceCampaignItem__c, ADvendio__PacketItem__c,RecordType.DeveloperName, RecordTypeID,  
                ADvendio__Rate_Discount_4__c, ADvendio__Rate_Discount_3_custom__c, ADvendio__Rate_Discount_2_custom__c, ADvendio__Agency_Commission__c, 
                ADvendio__Sales_Price__c, ADvendio__Billing_category__c, ADvendio__Media_Campaign__c, ADvendio__AC__c, ADvendio__Rate_Discount_4_Name__c,
                ADvendio__Quantity__c, ADvendio__until_Date__c, ADvendio__from_Date__c, SomDig_OtpAufschlag__c, ADvendio__Ad_Price__c, Name, ADvendio__SortOrder__c,
                ADvendio__FC_Quantity__c, ADvendio__FC_Ad_served_every__c, ADvendio__FC_Period__c, ADvendio__RateDiscount2Name__c,
                ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_FC__c, ADvendio__AdHourOfDay__c, ADvendio__AdDayOfWeek__c, ADvendio__Targetingabbrevation__c,
                ADvendio__AdOperatingSystems__c, ADvendio__AdWebBrowsers__c, SomDig_ADGapID__c,
                ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_GtFaehig__c, ADvendio__SurchargeSalesPrice__c, SomDig_Retargeting__c,
                ADvendio__SelectedAdServerIdInformation__c
                    FROM ADvendio__Campaign_Item__c 
                	WHERE SomDig_SourceCampaignItem__c in :setIdCampItem];

        Map<Id, ADvendio__Campaign_Item__c> mapCampItems = new Map<Id, ADvendio__Campaign_Item__c>();
        for(ADvendio__Campaign_Item__c item :lstCampItems){
            mapCampItems.put(item.SomDig_SourceCampaignItem__c, item);
        }

        return mapCampItems;
    } 
    
    private static ADvendio__MediaCampaign__c queryClonedMediaCampaign(ADvendio__MediaCampaign__c camp){
        String sNameCamp = 'CLONE_'+camp.Name;
		return [SELECT ID, SomDig_BetreuerTeam__c ,CurrencyIsoCode,ADvendio__Quote_Locale__c,ADvendio__Quote_Language__c,ADvendio__BillMe__c,ADvendio__TermsOfPayment__c,
                    ADvendio__PaymentDueDate__c,ADvendio__PaymentStart__c,ADvendio__PaymentInterval__c,SomDig_RabatteMKgenehmigt__c,SomDig_Commitment__c,
                    SomDig_Agenturrabatt__c,ADvendio__Rate_Discount_2__c,SomDig_Naturalrabatt_Inpage__c,SomDig_Sonderrabatt_InPage__c,SomDig_Kundenrabatt_InStream__c,
                    SomDig_Kundenrabatt_InPage__c,ADvendio__Document_type__c,ADvendio__Stage__c,ADvendio__Pricelist__c,ADvendio__invoice_recipient__c,SomDig_WtAgBeziehung__c,
                    SomDig_AdManager__c,SomDig_BetreuerPam__c,Name,SomDig_BetreuerSales__c, SomDig_Sonderrabatt_InStream__c, ADvendio__external_Media_Campaign_Name__c, 
                    ADvendio__Tax__c, ADvendio__PostalRecipient__c, SomDig_SACConceptionManager__c, SomDig_Zahlungsbedingung__c, SomDig_Restwerbezeit__c
                        FROM ADvendio__MediaCampaign__c 
                        WHERE Name = :sNameCamp 
                            AND ID != :camp.ID 
                        LIMIT 1];		        
    }

    private static ADvendio__MediaCampaign__c queryMediaCampaign(ADvendio__MediaCampaign__c camp){
        return [SELECT ID, SomDig_BetreuerTeam__c ,CurrencyIsoCode,ADvendio__Quote_Locale__c,ADvendio__Quote_Language__c,ADvendio__BillMe__c,ADvendio__TermsOfPayment__c,
                    ADvendio__PaymentDueDate__c,ADvendio__PaymentStart__c,ADvendio__PaymentInterval__c,SomDig_RabatteMKgenehmigt__c,SomDig_Commitment__c,
                    SomDig_Agenturrabatt__c, ADvendio__Rate_Discount_2__c,SomDig_Naturalrabatt_Inpage__c,SomDig_Sonderrabatt_InPage__c,SomDig_Kundenrabatt_InStream__c,
                    SomDig_Kundenrabatt_InPage__c,ADvendio__Document_type__c,ADvendio__Stage__c,ADvendio__Pricelist__c,ADvendio__invoice_recipient__c,SomDig_WtAgBeziehung__c,
                    SomDig_AdManager__c,SomDig_BetreuerPam__c,Name,SomDig_BetreuerSales__c, SomDig_Sonderrabatt_InStream__c, ADvendio__external_Media_Campaign_Name__c, 
                    ADvendio__Tax__c, ADvendio__PostalRecipient__c, SomDig_SACConceptionManager__c, SomDig_Zahlungsbedingung__c, SomDig_Restwerbezeit__c
                        FROM ADvendio__MediaCampaign__c 
                        WHERE ID = :camp.ID 
                        LIMIT 1];               
    }
}