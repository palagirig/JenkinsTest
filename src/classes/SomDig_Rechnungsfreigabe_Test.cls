/**
 * Unit Tests for class SomDig_Rechnungsfreigabe
 */
@isTest
private class SomDig_Rechnungsfreigabe_Test {

	static Date today									= Date.newInstance(System.today().year(), System.today().month(), 15);
	static ADvendio__Site__c site						= null;
	static ADvendio__Site__c siteFM						= null;
	static ADvendio__Site__c siteNoIA					= null;
	static SomDig_Werbetraegergruppierung__c wtGruppe	= null;
	static SomDig_Werbetraegergruppierung__c wtGruppeFM	= null;
	static SomDig_Werbetraegergruppierung__c wtGruppeNoIA	= null;
	static SomDig_Mediagattung__c mg					= null;
	static SomDig_Mediagattungssegment__c mgs			= null;
	static SomDig_Mediagattungssegment__c mgsNM			= null;
	static SomDig_MediagattungsDifferenzierung__c mgd	= null;

	static SomDig_IaNummer__c iaNummer					= null;
	static SomDig_IaNummer__c iaNummerFM				= null;
	static SomDig_IaNummer__c iaNummer_CSP				= null;
	static SomDig_IaNummer__c iaNummerFM_CSP			= null;

	static ADvendio__Pricelist__c priceList				= null;
	static ADvendio__Ad_price__c adPrice				= null;
	static ADvendio__Ad_price__c adPriceFM				= null;
	static ADvendio__Ad_price__c adPriceNoIA			= null;

	static ADvendio__AdServer_ID__c aid					= null;
	static ADvendio__AdServer_ID__c aidFM				= null;
	static ADvendio__AdServer_ID__c aidNoIA				= null;

	static Map<String, SomDig_Sachkonto__c> sachkonten	= new Map<String, SomDig_Sachkonto__c>();
	static Set<String> skNamen	= new Set<String> {
													SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET,
													SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_DURCHLAUFKONTO_FREMDMARKE,
													SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_BARTER,
													SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_DIENSTLEISTUNGEN,
													SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_IC,
													SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_FORDERUNG_HOCHRECHNUNG,
													SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_KORREKTUR_WERBEERLOES,
													SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP
													};

	private static void createSachkonten() {
		Integer i = 1;
		for (String skName : skNamen) {
			SomDig_Sachkonto__c sk		= new SomDig_Sachkonto__c();
			sk.Name						='123'+i;
			sk.SomDig_SammelIA__c		='Sammel-'+i;
			sk.SomDig_FehlerIA__c		='Fehler-'+i;
			sk.SomDig_SachkontoTyp__c	= skName;
			sachkonten.put(skName, sk);
			i++;
		}
		insert sachkonten.values();
	}

	private static void createAdConfig() {

		wtGruppe		= new SomDig_Werbetraegergruppierung__c (Name='Mandant', SomDig_DEWerbetraegertyp__c ='TV');
		wtGruppeFM		= new SomDig_Werbetraegergruppierung__c (Name='Fremdmarke', SomDig_DEWerbetraegertyp__c ='Portal');
		wtGruppeNoIA	= new SomDig_Werbetraegergruppierung__c (Name='No IA', SomDig_DEWerbetraegertyp__c ='Portal');
		insert new List<SObject>{wtGruppe, wtGruppeFM, wtGruppeNoIA};

		mgs			= cls_P7S1_TestData.createTestMediagattungsSegment(true);
		mgd			= cls_P7S1_TestData.createTestMediagattungsDifferenzierung(true);
		mg			= cls_P7S1_TestData.createTestMediagattung(true);
		mgsNM		= cls_P7S1_TestData.createTestMediagattungsSegment(false);
		mgsNM.Name	= 'NonMedia';
		insert mgsNM;

		createSachkonten();

		iaNummer												= new SomDig_IaNummer__c();
		ianummer.Name											= 'IA';
//		iaNummer.Som_SachkontokonzernintereneVerrechnung__c		= Decimal.valueOf(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name);
		iaNummer.SomDig_Mediagattung__c							= mg.Id;
		iaNummer.SomDig_Mediagattungssegment__c					= mgs.Id;
		iaNummer.SomDig_MediagattungsDifferenzierung__c			= mgd.Id;
		iaNummer.SomDig_Werbetraergergruppierung__c				= wtGruppe.Id;
		iaNummer.SomDig_BeschreibungCO__c						= 'Test';

		iaNummerFM	= new SomDig_IaNummer__c();
		iaNummerFM.Name											= 'IA FM';
		iaNummerFM.Som_SachkontokonzernintereneVerrechnung__c	= Decimal.valueOf(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_DURCHLAUFKONTO_FREMDMARKE).Name);
		iaNummerFM.SomDig_Mediagattung__c						= mg.Id;
		iaNummerFM.SomDig_Mediagattungssegment__c				= mgs.Id;
		iaNummerFM.SomDig_MediagattungsDifferenzierung__c		= mgd.Id;
		iaNummerFM.SomDig_Werbetraergergruppierung__c			= wtGruppeFM.Id;
		iaNummerFM.SomDig_BeschreibungCO__c						= 'Test';

		iaNummerFM_CSP	= new SomDig_IaNummer__c();
		iaNummerFM_CSP.Name											= 'IA FM CSP';
		iaNummerFM_CSP.Som_SachkontokonzernintereneVerrechnung__c	= Decimal.valueOf(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_DURCHLAUFKONTO_FREMDMARKE).Name);
		iaNummerFM_CSP.SomDig_CSPartnerID__c						= '114';
		iaNummerFM_CSP.SomDig_Mediagattung__c						= mg.Id;
		iaNummerFM_CSP.SomDig_Mediagattungssegment__c				= mgs.Id;
		iaNummerFM_CSP.SomDig_MediagattungsDifferenzierung__c		= mgd.Id;
		iaNummerFM_CSP.SomDig_Werbetraergergruppierung__c			= wtGruppeFM.Id;
		iaNummerFM_CSP.SomDig_BeschreibungCO__c						= 'Test';

		iaNummer_CSP	= new SomDig_IaNummer__c();
		iaNummer_CSP.Name										= 'IA CSP';
		iaNummer_CSP.SomDig_CSPartnerID__c						= '114';
		iaNummer_CSP.SomDig_Mediagattung__c						= mg.Id;
		iaNummer_CSP.SomDig_Mediagattungssegment__c				= mgs.Id;
		iaNummer_CSP.SomDig_MediagattungsDifferenzierung__c		= mgd.Id;
		iaNummer_CSP.SomDig_Werbetraergergruppierung__c			= wtGruppe.Id;
		iaNummer_CSP.SomDig_BeschreibungCO__c					= 'Test';

		insert new List<SObject>{iaNummerFM, iaNummer, iaNummerFM_CSP, iaNummer_CSP};

		priceList	= cls_P7S1_TestData.createTestPricelist(true);
	}

	private static void createAds() {
		// Sites
		site									= cls_P7S1_TestData.createTestSite(false);
		site.SomDig_Mediagattung__c				= mg.Id;
		site.SomDig_Werbetraergergruppierung__c	= wtGruppe.Id;

		siteFM										= cls_P7S1_TestData.createTestSite(false);
		siteFM.SomDig_Mediagattung__c				= mg.Id;
		siteFM.SomDig_Werbetraergergruppierung__c	= wtGruppeFM.Id;

		siteNoIA									= cls_P7S1_TestData.createTestSite(false);
		siteNoIA.SomDig_Mediagattung__c				= mg.Id;
		siteNoIA.SomDig_Werbetraergergruppierung__c	= wtGruppeNoIA.Id;
		insert new List<SObject>{site, siteFM, siteNoIA};

		// Adserver-Ids
		aid									= cls_P7S1_TestData.createTestAdServerID(false);
		aid.ADvendio__Site__c				= site.Id;
		aid.SomDig_MediagattungsSegment__c	= mgs.Id;
		aid.ADvendio__AdServer_ID__c 		= 1234;

		aidFM									= cls_P7S1_TestData.createTestAdServerID(false);
		aidFM.ADvendio__Site__c					= siteFM.Id;
		aidFM.SomDig_MediagattungsSegment__c	= mgs.Id;
		aidFM.ADvendio__AdServer_ID__c 			= 1235;

		aidNoIA									= cls_P7S1_TestData.createTestAdServerID(false);
		aidNoIA.ADvendio__Site__c				= siteNoIA.Id;
		aidNoIA.SomDig_MediagattungsSegment__c	= mgs.Id;
		insert new List<ADvendio__AdServer_ID__c>{aid, aidFM, aidNoIA};

		// Antizipation-Verteilung
		SomDig_AntizipationsVS__c avs		= new SomDig_AntizipationsVS__c(Name='VS-1');
		insert avs;
		SomDig_Verteilungsschluessel__c vs	= new SomDig_Verteilungsschluessel__c(SomDig_AntizipationsVS__c=avs.Id, SomDig_AdServerId__c=aid.Id, SomDig_Prozentsatz__c=50);
		SomDig_Verteilungsschluessel__c vs3	= new SomDig_Verteilungsschluessel__c(SomDig_AntizipationsVS__c=avs.Id, SomDig_AdServerId__c=aidFM.Id, SomDig_Prozentsatz__c=20);
		insert new List<SomDig_Verteilungsschluessel__c>{vs, vs3};

		// Placement
		ADvendio__Placement__c pl			= cls_P7S1_TestData.createTestPlacement(false, site);
		pl.SomDig_Mediagattungssegment__c	= mgs.Id;
		pl.SomDig_AntizipationsVS__c		= avs.Id;

		ADvendio__Placement__c plFM			= cls_P7S1_TestData.createTestPlacement(false, siteFM);
		plFM.SomDig_Mediagattungssegment__c	= mgs.Id;

		ADvendio__Placement__c plNoIA			= cls_P7S1_TestData.createTestPlacement(false, siteNoIA);
		plNoIA.SomDig_Mediagattungssegment__c	= mgs.Id;
		insert new List<SObject>{pl, plFM, plNoIA};

		// Ad-Type
		ADvendio__Ad_Type__c adType			= cls_P7S1_Testdata.createTestAdType(false);
		adType.SomDig_MediagattungsDifferenzierung__c	= mgd.Id;
		insert adType;

		// Ad-Specs
		ADvendio__Ad_Specs__c adSpec		= cls_P7S1_TestData.createTestAdSpec(false, pl, adType);
		ADvendio__Ad_Specs__c adSpecFM		= cls_P7S1_TestData.createTestAdSpec(false, plFM, adType);
		ADvendio__Ad_Specs__c adSpecNoIA	= cls_P7S1_TestData.createTestAdSpec(false, plNoIA, adType);
		insert new List<ADvendio__Ad_Specs__c>{adSpec, adSpecFM, adSpecNoIA};

		// Ad-Spec-Adserver-Id
		ADvendio__AdServer_ID_AdSpec_Assigment__c asiasp	= new ADvendio__AdServer_ID_AdSpec_Assigment__c(ADvendio__Ad_Spec__c=adSpec.Id, ADvendio__AdServer_ID__c=aid.Id);
		ADvendio__AdServer_ID_AdSpec_Assigment__c asiaspFM	= new ADvendio__AdServer_ID_AdSpec_Assigment__c(ADvendio__Ad_Spec__c=adSpecFM.Id, ADvendio__AdServer_ID__c=aidFM.Id);
		insert new List<ADvendio__AdServer_ID_AdSpec_Assigment__c>{asiasp, asiaspFM};

		// Ad-Price
		adPrice		= cls_P7S1_TestData.createTestAdPrice(false, adSpec, pricelist);
		adPriceFM	= cls_P7S1_TestData.createTestAdPrice(false, adSpecFM, pricelist);
		adPriceNoIA	= cls_P7S1_TestData.createTestAdPrice(false, adSpecNoIA, pricelist);
		insert new List<ADvendio__Ad_price__c>{adPrice, adPriceFM, adPriceNoIA};
	}

	@isTest
	static void testFreigabeOK() {
        createAdConfig();
        createAds();

        ADvendio__MediaCampaign__c mc			= cls_P7S1_TestData.createTestMediaCampaign(true, null, priceList);
        ADvendio__Campaign_Item__c ci			= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
        ADvendio__Campaign_Item__c ciFM1		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPriceFM);
        ADvendio__Campaign_Item__c ci4			= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
        ADvendio__Campaign_Item__c ciFM2		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPriceFM);
        ADvendio__Campaign_Item__c ci3			= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
        
        ci3.ADvendio__Ad_Id__c					= '1234';
        ci3.ADvendio__Adserver_ID_Order_ID__c	= '2345';
        insert new List<ADvendio__Campaign_Item__c>{ci, ciFM1, ci4, ciFM2, ci3};

        ADvendio__DeliveryData__c dd			= new ADvendio__DeliveryData__c();
        dd.ADvendio__AdServerID__c				= aid.Id;
        dd.ADvendio__DeliveredImpressions__c	= 300;
        dd.ADvendio__Day__c						= today.addDays(-1);
        dd.ADvendio__CampaignItem__c			= ci3.Id;
        dd.ADvendio__Type__c					= 'Monthly';

        ADvendio__DeliveryData__c ddFM			= new ADvendio__DeliveryData__c();
        ddFM.ADvendio__AdServerID__c			= aidFM.Id;
        ddFM.ADvendio__DeliveredImpressions__c	= 200;
        ddFM.ADvendio__Day__c					= today.addDays(-1);
        ddFM.ADvendio__CampaignItem__c			= ci3.Id;
        ddFM.ADvendio__Type__c					= 'Monthly';

        ADvendio__DeliveryData__c ddFM2			= new ADvendio__DeliveryData__c();
        ddFM2.ADvendio__AdServerID__c			= aidFM.Id;
        ddFM2.ADvendio__DeliveredImpressions__c	= 200;
        ddFM2.ADvendio__Day__c					= today.addDays(-1);
        ddFM2.ADvendio__CampaignItem__c			= ciFM2.Id;
        ddFM2.ADvendio__Type__c					= 'Monthly';
        
		insert new List<ADvendio__DeliveryData__c>{dd, ddFM, ddFM2};

        ADvendio__Invoice__c i				= cls_P7S1_TestData.createTestInvoice(false, mc);
        i.ADvendio__Status__c				= 'Draft';
        insert i;

        ADvendio__InvoiceItem__c ii					= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci);
        ii.ADvendio__Salesprice__c					= 10;
        ii.ADvendio__BookedQuantity__c				= 1000;
        ii.ADvendio__BillingCategory__c				= 'CPM';
        ii.ADvendio__QuantityDelivered__c			= 1000;
        ii.ADvendio__LinearDistribution__c			= true;
        ii.ADvendio__FromDate__c					= today;
        ii.ADvendio__UntilDate__c					= today;
        ii.SomDig_Adservertyp__c					= 'Standard';
        ii.SomDig_Mediagattungs_Segment__c			= mgsNM.Id;
        ii.SomDig_Mediagattungs_Segement_Name__c	= mgsNM.Name;
        ii.SomDig_Mediagattung__c					= mg.Id;
        ii.SomDig_Mediagattungs_Differenzierung__c	= mgd.Id;
        ii.SomDig_Werbetraeger__c					= site.Id;
        
        ADvendio__InvoiceItem__c iiNas				= cls_P7S1_TestData.createTestInvoiceItem(false, i , ciFM1);
        iiNas.Name									= 'iiNas';
        iiNas.ADvendio__Salesprice__c				= 10;
        iiNas.ADvendio__BookedQuantity__c			= 1000;
        iiNas.ADvendio__BillingCategory__c			= 'CPM';
        iiNas.ADvendio__QuantityDelivered__c		= 1000;
        iiNas.ADvendio__LinearDistribution__c		= true;
        iiNas.ADvendio__FromDate__c					= today;
        iiNas.ADvendio__UntilDate__c				= today;
        iiNas.SomDig_Adservertyp__c					= 'Standard';
        iiNas.SomDig_Mediagattungs_Segement_Name__c	= mgs.Name;
        iiNas.SomDig_Mediagattung__c				= mg.Id;
        iiNas.SomDig_Mediagattungs_Segment__c		= mgs.Id;
        iiNas.SomDig_Mediagattungs_Differenzierung__c	= mgd.Id;
        iiNas.SomDig_Werbetraeger__c				= siteFM.Id;

        ADvendio__InvoiceItem__c iiDL				= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci4);
        iiDL.Name									= 'iiDL';
        iiDL.ADvendio__Salesprice__c				= 1000;
        iiDL.ADvendio__BookedQuantity__c			= 1;
        iiDL.ADvendio__BillingCategory__c			= 'Fixed Price';
        iiDL.ADvendio__QuantityDelivered__c			= 1;
        iiDL.ADvendio__LinearDistribution__c		= true;
        iiDL.ADvendio__FromDate__c					= today;
        iiDL.ADvendio__UntilDate__c					= today;
        iiDL.SomDig_Adservertyp__c					= 'Standard';
        iiDL.SomDig_Mediagattungs_Segement_Name__c	= mgsNM.Name;
        iiDL.SomDig_Mediagattungs_Segment__c		= mgsNM.Id;
        iiDL.SomDig_Werbetraeger__c					= site.Id;
        iiDL.SomDig_Mediagattung__c					= mg.Id;
        iiDL.SomDig_Mediagattungs_Differenzierung__c= mgd.Id;

        ADvendio__InvoiceItem__c iiMedia		= cls_P7S1_TestData.createTestInvoiceItem(false, i , ciFM2);
        iiMedia.Name							= 'iiMedia';
        iiMedia.ADvendio__Salesprice__c			= 10;
        iiMedia.ADvendio__BookedQuantity__c		= 1000;
        iiMedia.ADvendio__BillingCategory__c	= 'CPM';
        iiMedia.ADvendio__QuantityDelivered__c	= 1000;
        iiMedia.ADvendio__LinearDistribution__c	= true;
        iiMedia.ADvendio__FromDate__c			= today.addDays(-1);
        iiMedia.ADvendio__UntilDate__c			= today.addDays(-1);
        iiMedia.SomDig_Adservertyp__c			= 'DFP';
        iiMedia.SomDig_Mediagattung__c				= mg.Id;
        iiMedia.SomDig_Mediagattungs_Segment__c		= mgs.Id;
        iiMedia.SomDig_Mediagattungs_Differenzierung__c	= mgd.Id;
        iiMedia.SomDig_Werbetraeger__c				= siteFM.Id;
        
        ADvendio__InvoiceItem__c iiMediaExtra			= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci3);
        iiMediaExtra.Name								= 'iiMediaExtra';
        iiMediaExtra.ADvendio__Salesprice__c			= 10;
        iiMediaExtra.ADvendio__BookedQuantity__c		= 1000;
        iiMediaExtra.ADvendio__QuantityDelivered__c		= 900;
        iiMediaExtra.ADvendio__InvoicedQuantity__c		= 900;
        iiMediaExtra.ADvendio__BillingCategory__c		= 'CPM';
        iiMediaExtra.ADvendio__LinearDistribution__c	= false;
        iiMediaExtra.ADvendio__FromDate__c				= today.addDays(-2);
        iiMediaExtra.ADvendio__UntilDate__c				= today.addDays(2);
        iiMediaExtra.ADvendio__InvoiceItemEndDate__c	= today.addDays(2);
        iiMediaExtra.SomDig_Adservertyp__c				= 'DFP';
        iiMediaExtra.SomDig_Mediagattungs_Segement_Name__c = mgs.Name;
        iiMediaExtra.SomDig_Mediagattung__c				= mg.Id;
        iiMediaExtra.SomDig_Mediagattungs_Segment__c	= mgs.Id;
        iiMediaExtra.SomDig_Mediagattungs_Differenzierung__c	= mgd.Id;
        iiMediaExtra.SomDig_Werbetraeger__c				= siteNoIa.Id;

        insert new List<ADvendio__InvoiceItem__c>{ii, iiNas, iiDL, iiMedia, iiMediaExtra};
        
        system.Test.startTest();
        SomDig_Rechnungsfreigabe b = new SomDig_Rechnungsfreigabe(new Set<Id>{i.Id});
		Database.executeBatch(b);
        system.Test.stopTest();
		
		for (ADvendio__Invoice__c invoice : [SELECT Id, ADvendio__Status__c FROM ADvendio__Invoice__c WHERE ID = :i.Id]) {
			system.assertEquals('Reviewed', invoice.ADvendio__Status__c); // no IA Error => no review possible
		}
	}
	
		@isTest
	static void testFreigabeFail() {
        createAdConfig();
        createAds();

        ADvendio__MediaCampaign__c mc			= cls_P7S1_TestData.createTestMediaCampaign(true, null, priceList);
        ADvendio__Campaign_Item__c ci			= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
        ADvendio__Campaign_Item__c ciFM1		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPriceFM);
        ADvendio__Campaign_Item__c ci4			= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
        ADvendio__Campaign_Item__c ciFM2		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPriceFM);
        ADvendio__Campaign_Item__c ci3			= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
        
        ci3.ADvendio__Ad_Id__c					= '1234';
        ci3.ADvendio__Adserver_ID_Order_ID__c	= '2345';
        insert new List<ADvendio__Campaign_Item__c>{ci, ciFM1, ci4, ciFM2, ci3};

        ADvendio__DeliveryData__c dd			= new ADvendio__DeliveryData__c();
        dd.ADvendio__AdServerID__c				= aid.Id;
        dd.ADvendio__DeliveredImpressions__c	= 300;
        dd.ADvendio__Day__c						= today.addDays(-1);
        dd.ADvendio__CampaignItem__c			= ci3.Id;
        dd.ADvendio__Type__c					= 'Monthly';

        ADvendio__DeliveryData__c ddFM			= new ADvendio__DeliveryData__c();
        ddFM.ADvendio__AdServerID__c			= aidFM.Id;
        ddFM.ADvendio__DeliveredImpressions__c	= 200;
        ddFM.ADvendio__Day__c					= today.addDays(-1);
        ddFM.ADvendio__CampaignItem__c			= ci3.Id;
        ddFM.ADvendio__Type__c					= 'Monthly';

        ADvendio__DeliveryData__c ddFM2			= new ADvendio__DeliveryData__c();
        ddFM2.ADvendio__AdServerID__c			= aidFM.Id;
        ddFM2.ADvendio__DeliveredImpressions__c	= 200;
        ddFM2.ADvendio__Day__c					= today.addDays(-1);
        ddFM2.ADvendio__CampaignItem__c			= ciFM2.Id;
        ddFM2.ADvendio__Type__c					= 'Monthly';
        
        ADvendio__DeliveryData__c ddNoIA			= new ADvendio__DeliveryData__c();
        ddNoIA.ADvendio__AdServerID__c				= aidNoIA.Id;
        ddNoIA.ADvendio__DeliveredImpressions__c	= 100;
        ddNoIA.ADvendio__Day__c						= today.addDays(-1);
        ddNoIA.ADvendio__CampaignItem__c			= ci3.Id;
        ddNoIA.ADvendio__Type__c					= 'Monthly';

		insert new List<ADvendio__DeliveryData__c>{dd, ddFM, ddNoIA, ddFM2};

        ADvendio__Invoice__c i				= cls_P7S1_TestData.createTestInvoice(false, mc);
        i.ADvendio__Status__c				= 'Draft';
        insert i;

        ADvendio__InvoiceItem__c ii					= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci);
        ii.ADvendio__Salesprice__c					= 10;
        ii.ADvendio__BookedQuantity__c				= 1000;
        ii.ADvendio__BillingCategory__c				= 'CPM';
        ii.ADvendio__QuantityDelivered__c			= 1000;
        ii.ADvendio__LinearDistribution__c			= true;
        ii.ADvendio__FromDate__c					= today;
        ii.ADvendio__UntilDate__c					= today;
        ii.SomDig_Adservertyp__c					= 'Standard';
        ii.SomDig_Mediagattungs_Segment__c			= mgsNM.Id;
        ii.SomDig_Mediagattungs_Segement_Name__c	= mgsNM.Name;
        ii.SomDig_Mediagattung__c					= mg.Id;
        ii.SomDig_Mediagattungs_Differenzierung__c	= mgd.Id;
        ii.SomDig_Werbetraeger__c					= site.Id;
        
        ADvendio__InvoiceItem__c iiNas				= cls_P7S1_TestData.createTestInvoiceItem(false, i , ciFM1);
        iiNas.Name									= 'iiNas';
        iiNas.ADvendio__Salesprice__c				= 10;
        iiNas.ADvendio__BookedQuantity__c			= 1000;
        iiNas.ADvendio__BillingCategory__c			= 'CPM';
        iiNas.ADvendio__QuantityDelivered__c		= 1000;
        iiNas.ADvendio__LinearDistribution__c		= true;
        iiNas.ADvendio__FromDate__c					= today;
        iiNas.ADvendio__UntilDate__c				= today;
        iiNas.SomDig_Adservertyp__c					= 'Standard';
        iiNas.SomDig_Mediagattungs_Segement_Name__c	= mgs.Name;
        iiNas.SomDig_Mediagattung__c				= mg.Id;
        iiNas.SomDig_Mediagattungs_Segment__c		= mgs.Id;
        iiNas.SomDig_Mediagattungs_Differenzierung__c	= mgd.Id;
        iiNas.SomDig_Werbetraeger__c				= siteFM.Id;

        ADvendio__InvoiceItem__c iiDL				= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci4);
        iiDL.Name									= 'iiDL';
        iiDL.ADvendio__Salesprice__c				= 1000;
        iiDL.ADvendio__BookedQuantity__c			= 1;
        iiDL.ADvendio__BillingCategory__c			= 'Fixed Price';
        iiDL.ADvendio__QuantityDelivered__c			= 1;
        iiDL.ADvendio__LinearDistribution__c		= true;
        iiDL.ADvendio__FromDate__c					= today;
        iiDL.ADvendio__UntilDate__c					= today;
        iiDL.SomDig_Adservertyp__c					= 'Standard';
        iiDL.SomDig_Mediagattungs_Segement_Name__c	= mgsNM.Name;
        iiDL.SomDig_Mediagattungs_Segment__c		= mgsNM.Id;
        iiDL.SomDig_Werbetraeger__c					= site.Id;
        iiDL.SomDig_Mediagattung__c					= mg.Id;
        iiDL.SomDig_Mediagattungs_Differenzierung__c= mgd.Id;

        ADvendio__InvoiceItem__c iiMedia		= cls_P7S1_TestData.createTestInvoiceItem(false, i , ciFM2);
        iiMedia.Name							= 'iiMedia';
        iiMedia.ADvendio__Salesprice__c			= 10;
        iiMedia.ADvendio__BookedQuantity__c		= 1000;
        iiMedia.ADvendio__BillingCategory__c	= 'CPM';
        iiMedia.ADvendio__QuantityDelivered__c	= 1000;
        iiMedia.ADvendio__LinearDistribution__c	= true;
        iiMedia.ADvendio__FromDate__c			= today.addDays(-1);
        iiMedia.ADvendio__UntilDate__c			= today.addDays(-1);
        iiMedia.SomDig_Adservertyp__c			= 'DFP';
        iiMedia.SomDig_Mediagattung__c				= mg.Id;
        iiMedia.SomDig_Mediagattungs_Segment__c		= mgs.Id;
        iiMedia.SomDig_Mediagattungs_Differenzierung__c	= mgd.Id;
        iiMedia.SomDig_Werbetraeger__c				= siteFM.Id;
        
        ADvendio__InvoiceItem__c iiMediaExtra			= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci3);
        iiMediaExtra.Name								= 'iiMediaExtra';
        iiMediaExtra.ADvendio__Salesprice__c			= 10;
        iiMediaExtra.ADvendio__BookedQuantity__c		= 1000;
        iiMediaExtra.ADvendio__QuantityDelivered__c		= 900;
        iiMediaExtra.ADvendio__InvoicedQuantity__c		= 900;
        iiMediaExtra.ADvendio__BillingCategory__c		= 'CPM';
        iiMediaExtra.ADvendio__LinearDistribution__c	= false;
        iiMediaExtra.ADvendio__FromDate__c				= today.addDays(-2);
        iiMediaExtra.ADvendio__UntilDate__c				= today.addDays(2);
        iiMediaExtra.ADvendio__InvoiceItemEndDate__c	= today.addDays(2);
        iiMediaExtra.SomDig_Adservertyp__c				= 'DFP';
        iiMediaExtra.SomDig_Mediagattungs_Segement_Name__c = mgs.Name;
        iiMediaExtra.SomDig_Mediagattung__c				= mg.Id;
        iiMediaExtra.SomDig_Mediagattungs_Segment__c	= mgs.Id;
        iiMediaExtra.SomDig_Mediagattungs_Differenzierung__c	= mgd.Id;
        iiMediaExtra.SomDig_Werbetraeger__c				= siteNoIa.Id;

        insert new List<ADvendio__InvoiceItem__c>{ii, iiNas, iiDL, iiMedia, iiMediaExtra};
        
        system.Test.startTest();
        SomDig_Rechnungsfreigabe b = new SomDig_Rechnungsfreigabe(new Set<Id>{i.Id});
		Database.executeBatch(b);
        system.Test.stopTest();
		
		for (ADvendio__Invoice__c invoice : [SELECT Id, ADvendio__Status__c FROM ADvendio__Invoice__c WHERE ID = :i.Id]) {
			system.assertEquals('Draft', invoice.ADvendio__Status__c); // no IA Error => no review possible
		}
	}
}