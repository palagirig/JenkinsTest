/**
 * Test class for SomDig_Buchungssatz_EaBatch.
 */
@IsTest
public with sharing class SomDig_Buchungssatz_EaBatch_Test {

    static Date today									= Date.newInstance(System.today().year(), System.today().month(), 15);
    static ADvendio__Site__c site						= null;
    static ADvendio__Site__c siteFM						= null;
    static SomDig_Werbetraegergruppierung__c wtGruppe	= null;
    static SomDig_Werbetraegergruppierung__c wtGruppeFM	= null;
    static SomDig_Mediagattung__c mg					= null;
    static SomDig_Mediagattungssegment__c mgs			= null;
    static SomDig_Mediagattungssegment__c mgsNM			= null;
    static SomDig_MediagattungsDifferenzierung__c mgd	= null;

    static SomDig_IaNummer__c iaNummer					= null;
    static SomDig_IaNummer__c iaNummerFM				= null;

    static ADvendio__Pricelist__c priceList				= null;
    static ADvendio__Ad_price__c adPrice				= null;
    static ADvendio__Ad_price__c adPriceFM				= null;

    static ADvendio__AdServer_ID__c aid					= null;
    static ADvendio__AdServer_ID__c aidFM				= null;

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
            sk.Name						='12345'+i;
            sk.SomDig_SammelIA__c		='23456'+i;
            sk.SomDig_FehlerIA__c		='34567'+i;
            sk.SomDig_SachkontoTyp__c	= skName;
            sachkonten.put(skName, sk);
        }
        //insert sachkonten.values();
    }

    private static void createAdConfig() {

        wtGruppe	= new SomDig_Werbetraegergruppierung__c (Name='Mandant', SomDig_DEWerbetraegertyp__c ='TV');
        wtGruppeFM	= new SomDig_Werbetraegergruppierung__c (Name='Fremdmarke', SomDig_DEWerbetraegertyp__c ='Portal');

        insert new List<SObject>{wtGruppe, wtGruppeFM};

        mgs			= cls_P7S1_TestData.createTestMediagattungsSegment(true);
        mgd			= cls_P7S1_TestData.createTestMediagattungsDifferenzierung(true);
        mg			= cls_P7S1_TestData.createTestMediagattung(true);
        mgsNM		= cls_P7S1_TestData.createTestMediagattungsSegment(false);
        mgsNM.Name	= 'NonMedia';
        insert mgsNM;

        createSachkonten();

        iaNummer											= new SomDig_IaNummer__c();
        ianummer.Name										= '1111111';
        iaNummer.SomDig_Mediagattung__c						= mg.Id;
        iaNummer.SomDig_Mediagattungssegment__c				= mgs.Id;
        iaNummer.SomDig_MediagattungsDifferenzierung__c		= mgd.Id;
        iaNummer.SomDig_Werbetraergergruppierung__c			= wtGruppe.Id;
        iaNummer.SomDig_BeschreibungCO__c					= 'Test';

        iaNummerFM	= new SomDig_IaNummer__c();
        iaNummerFM.Name											= '22222222';
        iaNummerFM.Som_SachkontokonzernintereneVerrechnung__c	= Decimal.valueOf(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_KORREKTUR_WERBEERLOES).Name);
        iaNummerFM.SomDig_Mediagattung__c						= mg.Id;
        iaNummerFM.SomDig_Mediagattungssegment__c				= mgs.Id;
        iaNummerFM.SomDig_MediagattungsDifferenzierung__c		= mgd.Id;
        iaNummerFM.SomDig_Werbetraergergruppierung__c			= wtGruppeFM.Id;
        iaNummerFM.SomDig_BeschreibungCO__c						= 'Test';

        insert new List<SObject>{iaNummerFM, iaNummer};

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
        insert new List<SObject>{site, siteFM};

        // Adserver-Ids
        aid									= cls_P7S1_TestData.createTestAdServerID(false);
        aid.ADvendio__Site__c				= site.Id;
        aid.SomDig_MediagattungsSegment__c	= mgs.Id;

        aidFM									= cls_P7S1_TestData.createTestAdServerID(false);
        aidFM.ADvendio__Site__c					= siteFM.Id;
        aidFM.SomDig_MediagattungsSegment__c	= mgs.Id;
        insert new List<ADvendio__AdServer_ID__c>{aid, aidFM};

        // Antizipation-Verteilung
        SomDig_AntizipationsVS__c avs		= new SomDig_AntizipationsVS__c(Name='VS-1');
        insert avs;
        SomDig_Verteilungsschluessel__c vs	= new SomDig_Verteilungsschluessel__c(SomDig_AntizipationsVS__c=avs.Id, SomDig_AdServerId__c=aid.Id, SomDig_Prozentsatz__c=100);
        insert vs;

        // Placement
        ADvendio__Placement__c pl			= cls_P7S1_TestData.createTestPlacement(false, site);
        pl.SomDig_Mediagattungssegment__c	= mgs.Id;
        pl.SomDig_AntizipationsVS__c		= avs.Id;

        ADvendio__Placement__c plFM			= cls_P7S1_TestData.createTestPlacement(false, siteFM);
        plFM.SomDig_Mediagattungssegment__c	= mgs.Id;
        insert new List<SObject>{pl, plFM};

        // Ad-Type
           ADvendio__Ad_Type__c adType			= cls_P7S1_Testdata.createTestAdType(false);
        adType.SomDig_MediagattungsDifferenzierung__c	= mgd.Id;
        insert adType;

        // Ad-Specs
        ADvendio__Ad_Specs__c adSpec	= cls_P7S1_TestData.createTestAdSpec(true, pl, adType);
        ADvendio__Ad_Specs__c adSpecFM	= cls_P7S1_TestData.createTestAdSpec(true, plFM, adType);

        // Ad-Spec-Adserver-Id
        ADvendio__AdServer_ID_AdSpec_Assigment__c asiasp	= new ADvendio__AdServer_ID_AdSpec_Assigment__c(ADvendio__Ad_Spec__c=adSpec.Id, ADvendio__AdServer_ID__c=aid.Id);
        ADvendio__AdServer_ID_AdSpec_Assigment__c asiaspFM	= new ADvendio__AdServer_ID_AdSpec_Assigment__c(ADvendio__Ad_Spec__c=adSpecFM.Id, ADvendio__AdServer_ID__c=aidFM.Id);
        insert new List<ADvendio__AdServer_ID_AdSpec_Assigment__c>{asiasp, asiaspFM};

        // Ad-Price
           adPrice		= cls_P7S1_TestData.createTestAdPrice(true, adSpec, pricelist);
        adPriceFM	= cls_P7S1_TestData.createTestAdPrice(true, adSpecFM, pricelist);
    }

    @IsTest // DL
    public static void testEaBatchHR1()  {

        createAdConfig();
        createAds();

        ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true, null, priceList);
           ADvendio__Campaign_Item__c ci		= cls_P7S1_TestData.createTestCampaignItem(true, mc, adPrice);
           ADvendio__Campaign_Item__c ciFM		= cls_P7S1_TestData.createTestCampaignItem(true, mc, adPriceFM);

        ADvendio__Invoice__c i				= cls_P7S1_TestData.createTestInvoice(false, mc);
        i.ADvendio__Status__c				= 'Draft';
        insert i;

        ADvendio__InvoiceItem__c ii			= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci);
        ii.ADvendio__Salesprice__c			= 10;
        ii.ADvendio__BookedQuantity__c		= 1000;
        ii.ADvendio__BillingCategory__c		= 'CPM';
        ii.ADvendio__QuantityDelivered__c	= 1000;
        ii.ADvendio__LinearDistribution__c	= true;
        ii.ADvendio__FromDate__c			= today;
        ii.ADvendio__UntilDate__c			= today;
        ii.SomDig_Adservertyp__c			= 'Standard';
        ii.SomDig_Mediagattungs_Segment__c	= mgsNM.Id;
        ii.SomDig_Mediagattungs_Segement_Name__c = mgsNM.Name;

        ADvendio__InvoiceItem__c iiDummy		= cls_P7S1_TestData.createTestInvoiceItem(false, i , ciFM);
        iiDummy.ADvendio__Salesprice__c			= 10;
        iiDummy.ADvendio__BookedQuantity__c		= 1000;
        iiDummy.ADvendio__BillingCategory__c	= 'CPM';
        iiDummy.ADvendio__QuantityDelivered__c	= 1000;
        iiDummy.ADvendio__LinearDistribution__c	= true;
        iiDummy.ADvendio__FromDate__c			= today;
        iiDummy.ADvendio__UntilDate__c			= today;
        iiDummy.SomDig_Adservertyp__c			= 'DFP';
        iiDummy.SomDig_Mediagattungs_Segment__c	= mgs.Id;
        insert new List<ADvendio__InvoiceItem__c>{ii, iiDummy};

        Test.StartTest();

        SomDig_Buchungssatz_EaBatch	c = new SomDig_Buchungssatz_EaBatch(SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_MINUS_5, today.addDays(+1));
        c.setInvoiceItemIds(new Set<Id> {ii.Id});
        Database.executeBatch(c, 1);
        System.assertNotEquals(null, c.getQueryString());

        Test.StopTest();
    }

    @IsTest // NonMedia
    public static void testEaBatchHR2()  {

        createAdConfig();
        insert sachkonten.values();
        createAds();

        ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true, null, priceList);
           ADvendio__Campaign_Item__c ciFM		= cls_P7S1_TestData.createTestCampaignItem(true, mc, adPriceFM);

        ADvendio__Invoice__c i				= cls_P7S1_TestData.createTestInvoice(false, mc);
        i.ADvendio__Status__c				= 'Draft';
        insert i;

        ADvendio__InvoiceItem__c ii			= cls_P7S1_TestData.createTestInvoiceItem(false, i , ciFM);
        ii.ADvendio__Salesprice__c			= 10;
        ii.ADvendio__BookedQuantity__c		= 1000;
        ii.ADvendio__BillingCategory__c		= 'CPM';
        ii.ADvendio__QuantityDelivered__c	= 1000;
        ii.ADvendio__LinearDistribution__c	= true;
        ii.ADvendio__FromDate__c			= today;
        ii.ADvendio__UntilDate__c			= today;
        ii.SomDig_Adservertyp__c			= 'Standard';
        ii.SomDig_Mediagattungs_Segement_Name__c = mgsNM.Name;
        ii.SomDig_Werbetraeger__c			= siteFM.Id;
        insert ii;

        Test.StartTest();

        SomDig_Buchungssatz_EaBatch	c = new SomDig_Buchungssatz_EaBatch(SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_MINUS_5, today.addDays(+1));
        c.setInvoiceItemIds(new Set<Id> {ii.Id});

        System.assertNotEquals(null, c.getQueryString());
        Database.executeBatch(c, 1);

        Test.StopTest();
    }

    @IsTest // Query
    public static void testBatchQueryDL()  {
        createAdConfig();
        
     	ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true, null, priceList);
        ADvendio__Campaign_Item__c ci		= cls_P7S1_TestData.createTestCampaignItem(true, mc, adPrice);

		ADvendio__Invoice__c iNM				= cls_P7S1_TestData.createTestInvoice(false, mc);
        iNM.ADvendio__Status__c					= 'Draft';
        iNM.ADvendio__PaymentInterval__c		= 'monthly (1 month)';
        iNM.ADvendio__PaymentStart__c			= 'before / during Billingperiod';
        iNM.ADvendio__PaymentDueDate__c			= 'due to the end of interval';
        iNM.ADvendio__AccountingDate__c			= today.addMonths(-1).toStartOfMonth();
        insert iNM;

        ADvendio__InvoiceItem__c iiNM				= cls_P7S1_TestData.createTestInvoiceItem(false, iNM , ci);
        iiNM.Name									= 'iiNM';
        iiNM.ADvendio__Salesprice__c				= 10;
        iiNM.ADvendio__BookedQuantity__c			= 1000;
        iiNM.ADvendio__QuantityDelivered__c			= 900;
        iiNM.ADvendio__InvoicedQuantity__c			= 900;
        iiNM.ADvendio__BillingCategory__c			= 'CPM';
        iiNM.ADvendio__LinearDistribution__c		= false;
        iiNM.ADvendio__FromDate__c					= today.addMonths(-1);
        iiNM.ADvendio__UntilDate__c					= today.addMonths(-1);
        iiNM.ADvendio__InvoiceItemEndDate__c		= today.addMonths(-1);
        iiNM.SomDig_Adservertyp__c					= 'DFP';
        iiNM.SomDig_Mediagattungs_Segment__c		= mgsNM.Id;
        insert iiNM;
        
        Test.startTest();

        SomDig_Buchungssatz_EaBatch	c	= null;
        String queryStr					= '';

        c	= new SomDig_Buchungssatz_EaBatch(SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_MINUS_5, today.addDays(+1));
        queryStr = c.getQueryString();
        system.assertEquals(0, Database.Query(queryStr).size());

        c	= new SomDig_Buchungssatz_EaBatch(SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_MINUS_5, today.addMonths(1));
        queryStr = c.getQueryString();
        system.assertEquals(0, Database.Query(queryStr).size());

        Test.stopTest();
    }
    
    @IsTest // Query
    public static void testEaBatchQuery()  {
        createAdConfig();
        
        ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(false, null, priceList);
        ADvendio__MediaCampaign__c mc2		= cls_P7S1_TestData.createTestMediaCampaign(false, null, priceList);
        insert new List<ADvendio__MediaCampaign__c>{mc, mc2};

        ADvendio__Campaign_Item__c ci		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
        ADvendio__Campaign_Item__c ci2		= cls_P7S1_TestData.createTestCampaignItem(false, mc2, adPrice);
        insert new List<ADvendio__Campaign_Item__c>{ci, ci2};

        ADvendio__Invoice__c iTotalNext			= cls_P7S1_TestData.createTestInvoice(false, mc2);
        iTotalNext.ADvendio__Status__c			= 'Draft';
        iTotalNext.ADvendio__PaymentInterval__c	= 'total account (one Invoice)';
        iTotalNext.ADvendio__PaymentStart__c	= 'before / during Billingperiod';
        iTotalNext.ADvendio__PaymentDueDate__c	= 'due to beginning of interval';
        iTotalNext.ADvendio__AccountingDate__c	= today.addMonths(1).toStartOfMonth();

        ADvendio__Invoice__c iTotal				= cls_P7S1_TestData.createTestInvoice(false, mc2);
        iTotal.ADvendio__Status__c				= 'Draft';
        iTotal.ADvendio__PaymentInterval__c		= 'total account (one Invoice)';
        iTotal.ADvendio__PaymentStart__c		= 'before / during Billingperiod';
        iTotal.ADvendio__PaymentDueDate__c		= 'due to beginning of interval';
        iTotal.ADvendio__AccountingDate__c		= today.toStartOfMonth();

        ADvendio__Invoice__c i					= cls_P7S1_TestData.createTestInvoice(false, mc);
        i.ADvendio__Status__c					= 'Draft';
        i.ADvendio__PaymentInterval__c			= 'monthly (1 month)';
        i.ADvendio__PaymentStart__c				= 'before / during Billingperiod';
        i.ADvendio__PaymentDueDate__c			= 'due to the end of interval';
        i.ADvendio__AccountingDate__c			= today.addMonths(-1).toStartOfMonth();

        ADvendio__Invoice__c iNext				= cls_P7S1_TestData.createTestInvoice(false, mc);
        iNext.ADvendio__Status__c				= 'Draft';
        iNext.ADvendio__AccountingDate__c		= today.toStartOfMonth();

        ADvendio__Invoice__c iNextNext			= cls_P7S1_TestData.createTestInvoice(false, mc);
        iNextNext.ADvendio__Status__c			= 'Draft';
        iNextNext.ADvendio__AccountingDate__c	= today.addMonths(1).toStartOfMonth();
        insert new List<ADvendio__Invoice__c>{iTotalNext, iTotal, i, iNext, iNextNext};

        ADvendio__InvoiceItem__c iiTotalNext				= cls_P7S1_TestData.createTestInvoiceItem(false, iTotalNext , ci2);
        iiTotalNext.Name									= 'iiTotalNext';
        iiTotalNext.ADvendio__Salesprice__c					= 1000;
        iiTotalNext.ADvendio__BookedQuantity__c				= 1;
        iiTotalNext.ADvendio__BillingCategory__c			= 'Fixed Price';
        iiTotalNext.ADvendio__QuantityDelivered__c			= 1;
        iiTotalNext.ADvendio__LinearDistribution__c			= false;
        iiTotalNext.ADvendio__FromDate__c					= today.addMonths(1).addDays(5);
        iiTotalNext.ADvendio__UntilDate__c					= today.addMonths(1).addDays(5);
        iiTotalNext.SomDig_Adservertyp__c					= 'Standard';

        ADvendio__InvoiceItem__c iiTotal					= cls_P7S1_TestData.createTestInvoiceItem(false, iTotal , ci2);
        iiTotal.Name										= 'iiTotal';
        iiTotal.ADvendio__Salesprice__c						= 10;
        iiTotal.ADvendio__BookedQuantity__c					= 1000;
        iiTotal.ADvendio__BillingCategory__c				= 'CPM';
        iiTotal.ADvendio__QuantityDelivered__c				= 1000;
        iiTotal.ADvendio__LinearDistribution__c				= false;
        iiTotal.ADvendio__FromDate__c						= today;
        iiTotal.ADvendio__UntilDate__c						= today;
        iiTotal.SomDig_Adservertyp__c						= 'DFP';
        
        ADvendio__InvoiceItem__c ii					= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci);
        ii.Name										= 'ii';
        ii.ADvendio__Salesprice__c					= 10;
        ii.ADvendio__BookedQuantity__c				= 1000;
        ii.ADvendio__QuantityDelivered__c			= 900;
        ii.ADvendio__InvoicedQuantity__c			= 900;
        ii.ADvendio__BillingCategory__c				= 'CPM';
        ii.ADvendio__LinearDistribution__c			= false;
        ii.ADvendio__FromDate__c					= today.addMonths(-1);
        ii.ADvendio__UntilDate__c					= today.addMonths(-1);
        ii.ADvendio__InvoiceItemEndDate__c			= today.addMonths(-1);
        ii.SomDig_Adservertyp__c					= 'DFP';

        ADvendio__InvoiceItem__c iiNext					= cls_P7S1_TestData.createTestInvoiceItem(false, iNext , ci);
        iiNext.Name										= 'iiNext';
        iiNext.ADvendio__Salesprice__c					= 10;
        iiNext.ADvendio__BookedQuantity__c				= 1000;
        iiNext.ADvendio__QuantityDelivered__c			= 900;
        iiNext.ADvendio__InvoicedQuantity__c			= 900;
        iiNext.ADvendio__BillingCategory__c				= 'CPM';
        iiNext.ADvendio__LinearDistribution__c			= false;
        iiNext.ADvendio__FromDate__c					= today;
        iiNext.ADvendio__UntilDate__c					= today;
        iiNext.ADvendio__InvoiceItemEndDate__c			= today;
        iiNext.SomDig_Adservertyp__c					= 'DFP';

        ADvendio__InvoiceItem__c iiNextNext					= cls_P7S1_TestData.createTestInvoiceItem(false, iNextNext , ci);
        iiNextNext.Name										= 'iiNextNext';
        iiNextNext.ADvendio__Salesprice__c					= 10;
        iiNextNext.ADvendio__BookedQuantity__c				= 1000;
        iiNextNext.ADvendio__QuantityDelivered__c			= 900;
        iiNextNext.ADvendio__InvoicedQuantity__c			= 900;
        iiNextNext.ADvendio__BillingCategory__c				= 'CPM';
        iiNextNext.ADvendio__LinearDistribution__c			= false;
        iiNextNext.ADvendio__FromDate__c					= today.addMonths(1);
        iiNextNext.ADvendio__UntilDate__c					= today.addMonths(1);
        iiNextNext.ADvendio__InvoiceItemEndDate__c			= today.addMonths(1);
        iiNextNext.SomDig_Adservertyp__c					= 'DFP';

        insert new List<ADvendio__InvoiceItem__c>{iiTotalNext, iiTotal, ii, iiNext, iiNextNext};

        Test.startTest();

        SomDig_Buchungssatz_EaBatch	c	= null;
        String queryStr					= '';

        c	= new SomDig_Buchungssatz_EaBatch(SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_MINUS_5, today.addDays(+1));
        queryStr = c.getQueryString();
        system.assertEquals(4, Database.Query(queryStr).size());

        c	= new SomDig_Buchungssatz_EaBatch(SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_MINUS_5, today.addMonths(1));
        queryStr = c.getQueryString();
        system.assertEquals(5, Database.Query(queryStr).size());

        Test.stopTest();
    }

    @IsTest // Total Invoice
    public static void testEaBatchHR2_1()  {

        createAdConfig();
        insert sachkonten.values();
        createAds();

        ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true, null, priceList);
        ADvendio__Campaign_Item__c ci		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
        ADvendio__Campaign_Item__c ci2		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
        ADvendio__Campaign_Item__c ci3		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
        insert new List<ADvendio__Campaign_Item__c>{ci,ci2,ci3};

        ADvendio__Invoice__c i				= cls_P7S1_TestData.createTestInvoice(false, mc);
        i.ADvendio__Status__c				= 'Draft';
        i.ADvendio__PaymentInterval__c		= 'total account (one Invoice)';
        i.ADvendio__PaymentStart__c			= 'before / during Billingperiod';
        i.ADvendio__PaymentDueDate__c		= 'due to beginning of interval';
        insert i;

        ADvendio__InvoiceItem__c iiDL				= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci);
        iiDL.Name									= 'iiDL';
        iiDL.ADvendio__Salesprice__c				= 1000;
        iiDL.ADvendio__BookedQuantity__c			= 1;
        iiDL.ADvendio__BillingCategory__c			= 'Fixed Price';
        iiDL.ADvendio__QuantityDelivered__c			= 1;
        iiDL.ADvendio__LinearDistribution__c		= true;
        iiDL.ADvendio__FromDate__c					= today.addDays(5);
        iiDL.ADvendio__UntilDate__c					= today.addDays(5);
        iiDL.SomDig_Adservertyp__c					= 'Standard';
        iiDL.SomDig_Mediagattungs_Segement_Name__c	= mgsNM.Name;
        iiDL.SomDig_Mediagattungs_Segment__c		= mgsNM.Id;
        iiDL.SomDig_Werbetraeger__c					= site.Id;
        iiDL.SomDig_Mediagattung__c					= mg.Id;
        iiDL.SomDig_Mediagattungs_Differenzierung__c= mgd.Id;

        ADvendio__InvoiceItem__c iiMedia					= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci2);
        iiMedia.Name										= 'iiMedia';
        iiMedia.ADvendio__Salesprice__c						= 10;
        iiMedia.ADvendio__BookedQuantity__c					= 1000;
        iiMedia.ADvendio__BillingCategory__c				= 'CPM';
        iiMedia.ADvendio__QuantityDelivered__c				= 1000;
        iiMedia.ADvendio__LinearDistribution__c				= true;
        iiMedia.ADvendio__FromDate__c						= today.addDays(5);
        iiMedia.ADvendio__UntilDate__c						= today.addDays(5);
        iiMedia.SomDig_Adservertyp__c						= 'DFP';
        iiMedia.SomDig_Mediagattung__c						= mg.Id;
        iiMedia.SomDig_Mediagattungs_Segment__c				= mgs.Id;
        iiMedia.SomDig_Mediagattungs_Differenzierung__c		= mgd.Id;
        iiMedia.SomDig_Werbetraeger__c						= siteFM.Id;

        ADvendio__InvoiceItem__c iiMediaExtra					= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci3);
        iiMediaExtra.Name										= 'iiMediaExtra';
        iiMediaExtra.ADvendio__Salesprice__c					= 10;
        iiMediaExtra.ADvendio__BookedQuantity__c				= 1000;
        iiMediaExtra.ADvendio__QuantityDelivered__c				= 900;
        iiMediaExtra.ADvendio__InvoicedQuantity__c				= 900;
        iiMediaExtra.ADvendio__BillingCategory__c				= 'CPM';
        iiMediaExtra.ADvendio__LinearDistribution__c			= true;
        iiMediaExtra.ADvendio__FromDate__c						= today.addDays(-1);
        iiMediaExtra.ADvendio__UntilDate__c						= today.addDays(2);
        iiMediaExtra.ADvendio__InvoiceItemEndDate__c			= today.addDays(2);
        iiMediaExtra.SomDig_Adservertyp__c						= 'DFP';
        iiMediaExtra.SomDig_Mediagattungs_Segement_Name__c		= mgs.Name;
        iiMediaExtra.SomDig_Mediagattung__c						= mg.Id;
        iiMediaExtra.SomDig_Mediagattungs_Segment__c			= mgs.Id;
        iiMediaExtra.SomDig_Mediagattungs_Differenzierung__c	= mgd.Id;
        iiMediaExtra.SomDig_Werbetraeger__c						= site.Id;

        insert new List<ADvendio__InvoiceItem__c>{iiDL, iiMedia, iiMediaExtra};

        Test.startTest();
        SomDig_Buchungssatz_EaBatch	c = new SomDig_Buchungssatz_EaBatch(SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_MINUS_5, today.addDays(+1));

        Set<Id> invoiceItemIds	= new Set<Id> {iiDL.Id, iiMedia.Id, iiMediaExtra.Id};

        String queryStr = c.getQueryString();
        queryStr += ' AND (Id IN :invoiceItemIds) ';
        queryStr += 'ORDER BY ADvendio__Invoice__c';

        c.execute(null, Database.Query(queryStr));
        c.finish(null);

        SomDig_Buchungssatz_EaBase base			= new SomDig_Buchungssatz_EaBase(new List<ADvendio__InvoiceItem__c>{iiDL, iiMedia}, SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_MINUS_5, today, true);
        base.runProcess();

        for (SomDig_Buchungssatz_EaBase.RevenueDistributionResult rdr : base.RevenueDistributionResults) {
            for (SomDig_Buchungssatz_EaBase.AccountingRecordsGroup arg : rdr.accountingRecordsGroups) {
                for (SomDig_Buchungssatz_EaBase.AccountingRecord ar : arg.accountingRecords) {
                    system.assertNotEquals('EA HR Antizipation: Hochrechnung PIs', ar.accountingRecord.SomDig_Buchungstext__c);
                }
            }
        }

        Test.stopTest();
    }

    @IsTest
    public static void testEaBatchHR3()  {

        createAdConfig();
        createAds();

        ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true, null, priceList);
        ADvendio__Campaign_Item__c ciFM		= cls_P7S1_TestData.createTestCampaignItem(true, mc, adPriceFM);

        ADvendio__DeliveryData__c dd		= new ADvendio__DeliveryData__c();
        dd.ADvendio__AdServerID__c			= aid.Id;
        dd.ADvendio__DeliveredImpressions__c= 500;
        dd.ADvendio__Day__c					= today.addDays(2);
        dd.ADvendio__CampaignItem__c		= ciFM.Id;
        dd.ADvendio__Type__c				= 'Monthly';

        ADvendio__DeliveryData__c ddFM			= new ADvendio__DeliveryData__c();
        ddFM.ADvendio__AdServerID__c			= aidFM.Id;
        ddFM.ADvendio__DeliveredImpressions__c	= 300;
        ddFM.ADvendio__Day__c					= today.addDays(2);
        ddFM.ADvendio__CampaignItem__c			= ciFM.Id;
        ddFM.ADvendio__Type__c					= 'Monthly';

        insert new List<ADvendio__DeliveryData__c>{dd, ddFM};

        ADvendio__Invoice__c i				= cls_P7S1_TestData.createTestInvoice(false, mc);
        i.ADvendio__Status__c				= 'Draft';
        i.SomDig_Rechnungsfreigabe__c		= true;
        insert i;

        ADvendio__InvoiceItem__c ii		= cls_P7S1_TestData.createTestInvoiceItem(false, i , ciFM);
        ii.ADvendio__Salesprice__c			= 10;
        ii.ADvendio__BookedQuantity__c		= 1000;
        ii.ADvendio__QuantityDelivered__c	= 800;
        ii.ADvendio__InvoicedQuantity__c	= 800;
        ii.ADvendio__BillingCategory__c		= 'CPM';
        ii.ADvendio__LinearDistribution__c	= false;
        ii.ADvendio__FromDate__c			= today;
        ii.ADvendio__UntilDate__c			= today.addDays(2);
        ii.ADvendio__InvoiceItemEndDate__c = today.addDays(2);
        ii.SomDig_Adservertyp__c			= 'DFP';
        ii.SomDig_Mediagattungs_Segement_Name__c = mgs.Name;
        ii.SomDig_Werbetraeger__c			= siteFM.Id;
        insert ii;

        Test.StartTest();

        SomDig_Buchungssatz_EaBatch	c = new SomDig_Buchungssatz_EaBatch(SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_MINUS_5, today.addDays(+1));
        c.setInvoiceItemIds(new Set<Id> {ii.Id});
        Database.executeBatch(c, 1);
        System.assertNotEquals(null, c.getQueryString());

        // Storno
        i	= [SELECT Id, ADvendio__InvoiceType__c, SomDig_Rechnungsfreigabe__c, ADvendio__InvoicedAmountNet2__c, ADvendio__Status__c, ADvendio__MediaCampaign__c, ADvendio__AccountingDate__c, Name FROM ADvendio__Invoice__c WHERE Id = :i.Id];
        ADvendio__Invoice__c iNeg	= i.clone();
        iNeg.ADvendio__Invoice__c	= i.Id;
        insert iNeg;

        ADvendio__InvoiceItem__c iiNeg					= ii.clone();
        iiNeg.ADvendio__InvoicedQuantityMultiplier__c	= -1;
        iiNeg.ADvendio__Invoice__c						= iNeg.Id;
        iiNeg.ADvendio__InvoicedAmountNet2__c			= 10;
        insert new List<ADvendio__InvoiceItem__c>{iiNeg};

        c = new SomDig_Buchungssatz_EaBatch(SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_MINUS_5, today.addDays(+1));
        c.setInvoiceItemIds(new Set<Id> {iiNeg.Id});
        Database.executeBatch(c, 1);

        Test.StopTest();
    }

    @IsTest // Antizipation, FM, keine Verteilung
    public static void testEaBatchHR4()  {

        createAdConfig();
        insert sachkonten.values();
        createAds();

        ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true, null, priceList);
        ADvendio__Campaign_Item__c ciFM		= cls_P7S1_TestData.createTestCampaignItem(true, mc, adPriceFM);

        ADvendio__Invoice__c i				= cls_P7S1_TestData.createTestInvoice(false, mc);
        i.ADvendio__Status__c				= 'Draft';
        i.ADvendio__PaymentInterval__c		= 'monthly (1 month)';
        insert i;

        ADvendio__InvoiceItem__c ii			= cls_P7S1_TestData.createTestInvoiceItem(false, i , ciFM);
        ii.ADvendio__Salesprice__c			= 10;
        ii.ADvendio__BookedQuantity__c		= 1000;
        ii.ADvendio__BillingCategory__c		= 'CPM';
        ii.ADvendio__QuantityDelivered__c	= 1000;
        ii.ADvendio__FromDate__c			= today.addDays(1);
        ii.ADvendio__UntilDate__c			= today.addDays(1);
        ii.ADvendio__InvoiceItemStartDate__c= today.addDays(1);
        ii.ADvendio__InvoiceItemEndDate__c	= today.addDays(1);
        ii.SomDig_Adservertyp__c			= 'DFP';
        ii.SomDig_Mediagattungs_Segement_Name__c = mgs.Name;
        insert ii;

        Test.StartTest();

        SomDig_Buchungssatz_EaBatch	c = new SomDig_Buchungssatz_EaBatch(SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_MINUS_5, today.addDays(+1));
        c.setInvoiceItemIds(new Set<Id> {ii.Id});
        Database.executeBatch(c, 1);
        System.assertNotEquals(null, c.getQueryString());

        Test.StopTest();
    }

    @IsTest // Antizipation, Verteilung
    public static void testEaBatchHR5()  {

        createAdConfig();
        insert sachkonten.values();
        createAds();

        ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true, null, priceList);
        ADvendio__Campaign_Item__c ci		= cls_P7S1_TestData.createTestCampaignItem(true, mc, adPrice);

        ADvendio__Invoice__c i				= cls_P7S1_TestData.createTestInvoice(false, mc);
        i.ADvendio__Status__c				= 'Draft';
        i.ADvendio__PaymentInterval__c		= 'monthly (1 month)';
        insert i;

        ADvendio__InvoiceItem__c ii			= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci);
        ii.ADvendio__Salesprice__c			= 10;
        ii.ADvendio__BookedQuantity__c		= 1000;
        ii.ADvendio__BillingCategory__c		= 'CPM';
        ii.ADvendio__QuantityDelivered__c	= 1000;
        ii.ADvendio__FromDate__c			= today.addDays(1);
        ii.ADvendio__UntilDate__c			= today.addDays(1);
        ii.ADvendio__InvoiceItemStartDate__c= today.addDays(1);
        ii.ADvendio__InvoiceItemEndDate__c	= today.addDays(1);
        ii.SomDig_Adservertyp__c			= 'DFP';
        ii.SomDig_Mediagattungs_Segement_Name__c = mgs.Name;
        insert ii;

        Test.StartTest();

        SomDig_Buchungssatz_EaBatch	c = new SomDig_Buchungssatz_EaBatch(SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_MINUS_5, today.addDays(+1));
        c.setInvoiceItemIds(new Set<Id> {ii.Id});
        Database.executeBatch(c, 1);
        System.assertNotEquals(null, c.getQueryString());

        Test.StopTest();
    }

    @IsTest // Total-Inoice, PRAP
    public static void testEaBatchHR6()  {

        createAdConfig();
        insert sachkonten.values();
        createAds();

        ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true, null, priceList);
        ADvendio__Campaign_Item__c ci		= cls_P7S1_TestData.createTestCampaignItem(true, mc, adPrice);

        ADvendio__Invoice__c i				= cls_P7S1_TestData.createTestInvoice(false, mc);
        i.ADvendio__Status__c				= 'Invoiced';
        i.ADvendio__PaymentInterval__c		= 'total account (one Invoice)';
        i.ADvendio__PaymentStart__c			= 'before / during Billingperiod';
        i.ADvendio__AccountingDate__c		= today.toStartOfMonth();
        i.ADvendio__BillingPeriodEndDate__c	= today.addDays(70);
        insert i;

        ADvendio__InvoiceItem__c ii			= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci);
        ii.ADvendio__Salesprice__c			= 10;
        ii.ADvendio__BookedQuantity__c		= 1000;
        ii.ADvendio__BillingCategory__c		= 'CPM';
        ii.ADvendio__LinearDistribution__c	= true;
        ii.ADvendio__FromDate__c			= today;
        ii.ADvendio__UntilDate__c			= today.addDays(70);
        ii.ADvendio__InvoiceItemStartDate__c= today;
        ii.ADvendio__InvoiceItemEndDate__c	= today.addDays(70);
        ii.SomDig_Adservertyp__c			= 'DFP';
        ii.SomDig_Mediagattungs_Segement_Name__c = mgs.Name;
        insert ii;

        Test.StartTest();

        SomDig_Buchungssatz_EaBatch	c = new SomDig_Buchungssatz_EaBatch(SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_PLUS_4, ii.ADvendio__InvoiceItemStartDate__c.toStartOfMonth());
        c.setInvoiceItemIds(new Set<Id> {ii.Id});
        Database.executeBatch(c, 1);

        c = new SomDig_Buchungssatz_EaBatch(SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_PLUS_4, ii.ADvendio__InvoiceItemStartDate__c.toStartOfMonth().addMonths(1));
        c.setInvoiceItemIds(new Set<Id> {ii.Id});
        Database.executeBatch(c, 1);

        System.assertNotEquals(null, c.getQueryString());

        Test.StopTest();
    }

    @IsTest (seeAllData=false)
    public static void testEaBatchEA()  {
        createAdConfig();
        createAds();
        createSachkonten();

        ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true, null, priceList);

        ADvendio__Placement__c pl			= cls_P7S1_TestData.createTestPlacement(false, site);
        pl.SomDig_Mediagattungssegment__c	= cls_P7S1_TestData.createTestMediagattungsSegment(true).Id;
        insert pl;

           ADvendio__Ad_Type__c adType			= cls_P7S1_Testdata.createTestAdType(false);
        adType.SomDig_MediagattungsDifferenzierung__c	= cls_P7S1_TestData.createTestMediagattungsDifferenzierung(true).Id;
        insert adType;

        ADvendio__Campaign_Item__c ci		= cls_P7S1_TestData.createTestCampaignItem(true, mc, cls_P7S1_TestData.createTestAdPrice(true, cls_P7S1_TestData.createTestAdSpec(true, pl, adType), pricelist));
        ADvendio__Invoice__c i				= cls_P7S1_TestData.createTestInvoice(false, mc);
        i.ADvendio__Status__c				= 'Invoiced';
        i.ADvendio__InvoiceDateManual__c	= today.addDays(-1);
        insert i;

        ADvendio__InvoiceItem__c ii			= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci);
        ii.ADvendio__Salesprice__c			= 10;
        ii.ADvendio__BookedQuantity__c		= 1000;
        ii.ADvendio__BillingCategory__c		= 'CPM';
        ii.ADvendio__QuantityDelivered__c	= 1000;
        ii.ADvendio__FromDate__c			= today;
        ii.ADvendio__UntilDate__c			= today;
        ii.SomDig_Adservertyp__c			= 'Standard';
        insert ii;

        ii = [select id, ADvendio__Invoice__r.ADvendio__Status__c, ADvendio__Invoice__r.ADvendio__InvoiceDate__c, ADvendio__InvoicedAmountNet2__c from advendio__invoiceitem__c where id = :ii.Id];

        Test.StartTest();

        SomDig_Buchungssatz_EaBatch	c = new SomDig_Buchungssatz_EaBatch(SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_PLUS_4, null);

        System.assertNotEquals(null, c.getQueryString());
        c.setInvoiceItemIds(new Set<Id>{ii.Id});
        Id iiId = ii.Id;
        List<sObject> iis = database.query(c.getQueryString() + ' AND (Id = :iiId) ');
        Database.BatchableContext bc = null;
        c.execute(bc, iis);
        c.finish(bc);

        Test.StopTest();
    }
}