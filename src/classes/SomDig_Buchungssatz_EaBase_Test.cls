/**
 * Test class for SomDig_Buchungssatz_EaBase.
 */
@IsTest
public class SomDig_Buchungssatz_EaBase_Test {

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
//        iaNummer.Som_SachkontokonzernintereneVerrechnung__c		= Decimal.valueOf(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name);
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
        SomDig_Verteilungsschluessel__c vs2	= new SomDig_Verteilungsschluessel__c(SomDig_AntizipationsVS__c=avs.Id, SomDig_AdServerId__c=aidNoIA.Id, SomDig_Prozentsatz__c=30);
        SomDig_Verteilungsschluessel__c vs3	= new SomDig_Verteilungsschluessel__c(SomDig_AntizipationsVS__c=avs.Id, SomDig_AdServerId__c=aidFM.Id, SomDig_Prozentsatz__c=20);
        insert new List<SomDig_Verteilungsschluessel__c>{vs, vs2, vs3};

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

    @IsTest // U-5
    public static void testEaBaseHR_Total() {

        createAdConfig();
        createAds();

        ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true, null, priceList);
           ADvendio__Campaign_Item__c ci		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
           ADvendio__Campaign_Item__c ci2		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
           ADvendio__Campaign_Item__c ci3		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);

        ci3.ADvendio__From_Date__c			= today.addDays(-1);
        ci3.ADvendio__Until_Date__c			= today.addDays(2);

        insert new List<ADvendio__Campaign_Item__c>{ci,ci2,ci3};

        ADvendio__DeliveryData__c dd			= new ADvendio__DeliveryData__c();
        dd.ADvendio__AdServerID__c				= aid.Id;
        dd.ADvendio__DeliveredImpressions__c	= 300;
        dd.ADvendio__Day__c						= today.addDays(-1);
        dd.ADvendio__CampaignItem__c			= ci3.Id;
        dd.ADvendio__Type__c					= 'Monthly';
        insert dd;

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

        ADvendio__InvoiceItem__c iiAntiVS					= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci2);
        iiAntiVS.Name										= 'iiAntiVS';
        iiAntiVS.ADvendio__Salesprice__c					= 10;
        iiAntiVS.ADvendio__BookedQuantity__c				= 1000;
        iiAntiVS.ADvendio__BillingCategory__c				= 'CPM';
        iiAntiVS.ADvendio__QuantityDelivered__c				= 1000;
        iiAntiVS.ADvendio__LinearDistribution__c			= true;
        iiAntiVS.ADvendio__FromDate__c						= today.addDays(5);
        iiAntiVS.ADvendio__UntilDate__c						= today.addDays(5);
        iiAntiVS.SomDig_Adservertyp__c						= 'DFP';
        iiAntiVS.SomDig_Mediagattung__c						= mg.Id;
        iiAntiVS.SomDig_Mediagattungs_Segment__c			= mgs.Id;
        iiAntiVS.SomDig_Mediagattungs_Differenzierung__c	= mgd.Id;
        iiAntiVS.SomDig_Werbetraeger__c						= site.Id;

        Set<String> iiAntiVSBS	= new Set<String>();
        iiAntiVSBS.add('1231 / Sammel-1'); // Std. - Sammel IA (Ausbuchung)
        iiAntiVSBS.add('1232 / IA FM'); // Durchlauf - FM IA
        iiAntiVSBS.add('1237 / IA FM'); // Korrektur - FM IA
        iiAntiVSBS.add('1231 / IA FM'); // Std. - FM IA
        iiAntiVSBS.add('1231 / Fehler-1'); // Std. - Fehler IA
        iiAntiVSBS.add('1231 / IA'); // Std. - IA

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

        insert new List<ADvendio__InvoiceItem__c>{iiDL, iiAntiVS, iiMediaExtra};

        Test.StartTest();
        SomDig_Buchungssatz_EaBase base	= new SomDig_Buchungssatz_EaBase(new List<ADvendio__InvoiceItem__c>{iiDL, iiAntiVS, iiMediaExtra}, SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_MINUS_5, today, true);
        base.runProcess();

        system.assertEquals(3, base.RevenueDistributionResults.size());
        // Item Results

        for (SomDig_Buchungssatz_EaBase.RevenueDistributionResult rdr : base.RevenueDistributionResults) {
            if (iiDL.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('DL Anteil'));
                system.assertEquals(2, rdr.accountingRecordsGroups.size());
            }
            else if (iiAntiVS.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('Antizipation') && rdr.matchedLogics.contains('EA Werbung'));
                system.assertEquals(1, rdr.accountingRecordsGroups.size());
            }
            else if (iiMediaExtra.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('EA Werbung'));
                system.assertEquals(2, rdr.accountingRecordsGroups.size());
            }

            // AR Groups
            Integer groupIndex	= 0;
            for (SomDig_Buchungssatz_EaBase.AccountingRecordsGroup arg : rdr.accountingRecordsGroups) {
                if (iiAntiVS.Id.equals(rdr.invoiceItem.Id)) {
                    if (groupIndex==0) { // PI
                        system.assertEquals(6, arg.accountingRecords.size());
                    }
                }
                else if (iiDL.Id.equals(rdr.invoiceItem.Id)) {
                    system.assertEquals(2, arg.accountingRecords.size()); // PI + DL
                }
                else if (iiMediaExtra.Id.equals(rdr.invoiceItem.Id)) {
                    if (groupIndex==0) { // PI + PI HR
                        system.assertEquals(2, arg.accountingRecords.size());
                    }
                    else if (groupIndex==1) { // EA + HR EA
                        system.assertEquals(2, arg.accountingRecords.size());
                    }
                }

                // AR
                   Integer arIndex	= 0;
                for (SomDig_Buchungssatz_EaBase.AccountingRecord ar : arg.accountingRecords) {
                    if (iiDL.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            if (arIndex == 0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_FORDERUNG_HOCHRECHNUNG).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                        if (groupIndex==1) {
                            if (arIndex == 0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_DIENSTLEISTUNGEN).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_DIENSTLEISTUNGEN).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
                    if (iiMediaExtra.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            if (arIndex == 0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_FORDERUNG_HOCHRECHNUNG).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                        if (groupIndex==1) {
                            if (arIndex == 0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummer.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
                    if (iiAntiVS.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            system.assert(iiAntiVSBS.contains(ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c + ' / ' + ar.accountingRecord.SomDig_Innenauftragsnummer__c));
                            iiAntiVSBS.remove(ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c + ' / ' + ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                        }
                    }

                    arIndex++;
                }
                groupIndex++;
            }
        }
    }

    @IsTest // U-5
    public static void testEaBaseHR() {

        createAdConfig();
        createAds();

        ADvendio__MediaCampaign__c mc			= cls_P7S1_TestData.createTestMediaCampaign(true, null, priceList);
           ADvendio__Campaign_Item__c ci			= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
           ADvendio__Campaign_Item__c ci2			= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
           ADvendio__Campaign_Item__c ci3			= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
           ADvendio__Campaign_Item__c ciFM1		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPriceFM);
           ADvendio__Campaign_Item__c ciFM2		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPriceFM);
           ADvendio__Campaign_Item__c ciFM3		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPriceFM);
           ADvendio__Campaign_Item__c ci4			= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
           ADvendio__Campaign_Item__c ci5			= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
           ADvendio__Campaign_Item__c ciNoIA		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPriceNoIA);
        ci3.ADvendio__Ad_Id__c					= '1234';
        ci3.ADvendio__Adserver_ID_Order_ID__c	= '2345';

        ci5.ADvendio__Ad_Id__c					= '1111';
        ci5.ADvendio__Adserver_ID_Order_ID__c	= '5555';
        ci5.ADvendio__Additional_Ad_Ids__c		= '1112;1113';
        insert new List<ADvendio__Campaign_Item__c>{ci,ci2,ci3, ciFM1,ciFM2,ciFM3,ci4,ciNoIA, ci5};

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

        ADvendio__DeliveryData__c ddNoIA			= new ADvendio__DeliveryData__c();
        ddNoIA.ADvendio__AdServerID__c				= aidNoIA.Id;
        ddNoIA.ADvendio__DeliveredImpressions__c	= 100;
        ddNoIA.ADvendio__Day__c						= today.addDays(-1);
        ddNoIA.ADvendio__CampaignItem__c			= ci3.Id;
        ddNoIA.ADvendio__Type__c					= 'Monthly';

        ADvendio__DeliveryData__c ddFM2			= new ADvendio__DeliveryData__c();
        ddFM2.ADvendio__AdServerID__c			= aidFM.Id;
        ddFM2.ADvendio__DeliveredImpressions__c	= 200;
        ddFM2.ADvendio__Day__c					= today.addDays(-1);
        ddFM2.ADvendio__CampaignItem__c			= ciFM2.Id;
        ddFM2.ADvendio__Type__c					= 'Monthly';

        ADvendio__DeliveryData__c ddFM3			= new ADvendio__DeliveryData__c();
        ddFM3.ADvendio__AdServerID__c			= aidFM.Id;
        ddFM3.ADvendio__DeliveredImpressions__c	= 100;
        ddFM3.ADvendio__Day__c					= today.addDays(-1);
        ddFM3.ADvendio__CampaignItem__c			= ci5.Id;
        ddFM3.ADvendio__Type__c					= 'Monthly';

        ADvendio__DeliveryData__c dd2			= new ADvendio__DeliveryData__c();
        dd2.ADvendio__AdServerID__c				= aid.Id;
        dd2.ADvendio__DeliveredImpressions__c	= 100;
        dd2.ADvendio__Day__c					= today.addDays(-1);
        dd2.ADvendio__CampaignItem__c			= ci5.Id;
        dd2.ADvendio__Type__c					= 'Monthly';

        insert new List<ADvendio__DeliveryData__c>{dd, ddFM, ddNoIA, ddFM2, ddFM3, dd2};

        SomDig_Contentsyndicationpartner__c csp	= new SomDig_Contentsyndicationpartner__c();
        csp.SomDig_Count__c						= 199;
        csp.SomDig_AdUnitId__c					= aidFM.ADvendio__AdServer_ID__c;
        csp.SomDig_CustomTargeting__c			= 114;
        csp.SomDig_Time__c						= today;
        csp.SomDig_OrderId__c					= Integer.valueOf(ci3.ADvendio__Adserver_ID_Order_ID__c);
        csp.SomDig_LineItemId__c				= Integer.valueOf(ci3.ADvendio__Ad_Id__c);
        csp.SomDig_Type__c						= 'impression';

        SomDig_Contentsyndicationpartner__c csp2	= new SomDig_Contentsyndicationpartner__c();
        csp2.SomDig_Count__c						= 100;
        csp2.SomDig_AdUnitId__c						= aidFM.ADvendio__AdServer_ID__c;
        csp2.SomDig_CustomTargeting__c				= 114;
        csp2.SomDig_Time__c							= today;
        csp2.SomDig_OrderId__c						= Integer.valueOf(ci5.ADvendio__Adserver_ID_Order_ID__c);
        csp2.SomDig_LineItemId__c					= Integer.valueOf('1112');
        csp2.SomDig_Type__c							= 'impression';

        SomDig_Contentsyndicationpartner__c csp3	= new SomDig_Contentsyndicationpartner__c();
        csp3.SomDig_Count__c						= 100;
        csp3.SomDig_AdUnitId__c						= aid.ADvendio__AdServer_ID__c;
        csp3.SomDig_CustomTargeting__c				= 114;
        csp3.SomDig_Time__c							= today;
        csp3.SomDig_OrderId__c						= Integer.valueOf(ci5.ADvendio__Adserver_ID_Order_ID__c);
        csp3.SomDig_LineItemId__c					= Integer.valueOf('1113');
        csp3.SomDig_Type__c							= 'impression';

        insert new List<SomDig_Contentsyndicationpartner__c>{csp, csp2, csp3};

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
        insert ii;

        SomDig_Buchungssatz_EaBase baseDummy	= new SomDig_Buchungssatz_EaBase(new ApexPages.StandardController(ii));
        SomDig_Buchungssatz_EaBase base			= new SomDig_Buchungssatz_EaBase(new List<ADvendio__InvoiceItem__c>{ii}, SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_MINUS_5, today, true);
        base.runProcess();

        for (SomDig_Buchungssatz_EaBase.RevenueDistributionResult rdr : base.RevenueDistributionResults) {
            if (ii.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('Non-InterCompany Service'));
                system.assertEquals(1, rdr.accountingRecordsGroups.size());
                system.assertEquals(ApexPages.Severity.INFO, rdr.messages.get(0).severity);
            }
        }

        ADvendio__InvoiceItem__c iiNoIA					= cls_P7S1_TestData.createTestInvoiceItem(false, i , ciNoIA);
        iiNoIA.Name										= 'iiNoIA';
        iiNoIA.ADvendio__Salesprice__c					= 10;
        iiNoIA.ADvendio__BookedQuantity__c				= 1000;
        iiNoIA.ADvendio__BillingCategory__c				= 'CPM';
        iiNoIA.ADvendio__QuantityDelivered__c			= 1000;
        iiNoIA.ADvendio__LinearDistribution__c			= true;
        iiNoIA.ADvendio__FromDate__c					= today;
        iiNoIA.ADvendio__UntilDate__c					= today;
        iiNoIA.SomDig_Adservertyp__c					= 'Standard';
        iiNoIA.SomDig_Mediagattungs_Segment__c			= mgs.Id;
        iiNoIA.SomDig_Mediagattungs_Segement_Name__c	= mgs.Name;
        iiNoIA.SomDig_Mediagattung__c					= mg.Id;
        iiNoIA.SomDig_Mediagattungs_Differenzierung__c	= mgd.Id;
        iiNoIA.SomDig_Werbetraeger__c					= site.Id;

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
        iiMediaExtra.ADvendio__FromDate__c				= today.addDays(-1);
        iiMediaExtra.ADvendio__UntilDate__c				= today.addDays(2);
        iiMediaExtra.ADvendio__InvoiceItemEndDate__c	= today.addDays(2);
        iiMediaExtra.SomDig_Adservertyp__c				= 'DFP';
        iiMediaExtra.SomDig_Mediagattungs_Segement_Name__c = mgs.Name;
        iiMediaExtra.SomDig_Mediagattung__c				= mg.Id;
        iiMediaExtra.SomDig_Mediagattungs_Segment__c	= mgs.Id;
        iiMediaExtra.SomDig_Mediagattungs_Differenzierung__c	= mgd.Id;
        iiMediaExtra.SomDig_Werbetraeger__c				= site.Id;

        Set<String> iiMediaExtraBS						= new Set<String>();
        iiMediaExtraBS.add('1231 / Sammel-1'); // Std. - Sammel IA (Ausbuchung)
        iiMediaExtraBS.add('1232 / IA FM'); // Durchlauf - FM IA
        iiMediaExtraBS.add('1237 / IA FM'); // Korrektur - FM IA
        iiMediaExtraBS.add('1231 / IA FM'); // Std. - FM IA
        iiMediaExtraBS.add('1232 / IA FM CSP'); // Durchlauf - FM IA
        iiMediaExtraBS.add('1237 / IA FM CSP'); // Korrektur - FM IA
        iiMediaExtraBS.add('1231 / IA FM CSP'); // Std. - FM IA
        iiMediaExtraBS.add('1231 / Fehler-1'); // Std. - Fehler IA
        iiMediaExtraBS.add('1231 / IA'); // Std. - IA

        ADvendio__InvoiceItem__c iiMediaExtra2					= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci5);
        iiMediaExtra2.Name										= 'iiMediaExtra2';
        iiMediaExtra2.ADvendio__Salesprice__c					= 10;
        iiMediaExtra2.ADvendio__BookedQuantity__c				= 1000;
        iiMediaExtra2.ADvendio__QuantityDelivered__c			= 900;
        iiMediaExtra2.ADvendio__InvoicedQuantity__c				= 900;
        iiMediaExtra2.ADvendio__BillingCategory__c				= 'CPM';
        iiMediaExtra2.ADvendio__LinearDistribution__c			= false;
        iiMediaExtra2.ADvendio__FromDate__c						= today.addDays(-1);
        iiMediaExtra2.ADvendio__UntilDate__c					= today.addDays(2);
        iiMediaExtra2.ADvendio__InvoiceItemEndDate__c			= today.addDays(2);
        iiMediaExtra2.SomDig_Adservertyp__c						= 'DFP';
        iiMediaExtra2.SomDig_Mediagattungs_Segement_Name__c 	= mgs.Name;
        iiMediaExtra2.SomDig_Mediagattung__c					= mg.Id;
        iiMediaExtra2.SomDig_Mediagattungs_Segment__c			= mgs.Id;
        iiMediaExtra2.SomDig_Mediagattungs_Differenzierung__c	= mgd.Id;
        iiMediaExtra2.SomDig_Werbetraeger__c					= site.Id;

        Set<String> iiMediaExtraBS2						= new Set<String>();
        iiMediaExtraBS2.add('1231 / Sammel-1'); // Std. - Sammel IA (Ausbuchung)
        iiMediaExtraBS2.add('1232 / IA FM CSP'); // Durchlauf - FM IA
        iiMediaExtraBS2.add('1237 / IA FM CSP'); // Korrektur - FM IA
        iiMediaExtraBS2.add('1231 / IA FM CSP'); // Std. - FM IA
        iiMediaExtraBS2.add('1231 / IA CSP'); // Std. - IA

        ADvendio__InvoiceItem__c iiAnti					= cls_P7S1_TestData.createTestInvoiceItem(false, i , ciFM3);
        iiAnti.Name										= 'iiAnti';
        iiAnti.ADvendio__Salesprice__c					= 10;
        iiAnti.ADvendio__BookedQuantity__c				= 1000;
        iiAnti.ADvendio__BillingCategory__c				= 'CPM';
        iiAnti.ADvendio__QuantityDelivered__c			= 1000;
        iiAnti.ADvendio__FromDate__c					= today.addDays(1);
        iiAnti.ADvendio__UntilDate__c					= today.addDays(1);
        iiAnti.ADvendio__InvoiceItemStartDate__c 		= today.addDays(1);
        iiAnti.ADvendio__InvoiceItemEndDate__c			= today.addDays(1);
        iiAnti.SomDig_Adservertyp__c					= 'DFP';
        iiAnti.SomDig_Mediagattungs_Segement_Name__c	= mgs.Name;
        iiAnti.SomDig_Mediagattung__c					= mg.Id;
        iiAnti.SomDig_Mediagattungs_Segment__c			= mgs.Id;
        iiAnti.SomDig_Mediagattungs_Differenzierung__c	= mgd.Id;
        iiAnti.SomDig_Werbetraeger__c					= siteFM.Id;

        ADvendio__InvoiceItem__c iiAntiVS				= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci2);
        iiAntiVS.Name									= 'iiAntiVS';
        iiAntiVS.ADvendio__Salesprice__c				= 10;
        iiAntiVS.ADvendio__BookedQuantity__c			= 1000;
        iiAntiVS.ADvendio__BillingCategory__c			= 'CPM';
        iiAntiVS.ADvendio__QuantityDelivered__c			= 1000;
        iiAntiVS.ADvendio__FromDate__c					= today.addDays(1);
        iiAntiVS.ADvendio__UntilDate__c					= today.addDays(1);
        iiAntiVS.ADvendio__InvoiceItemStartDate__c 		= today.addDays(1);
        iiAntiVS.ADvendio__InvoiceItemEndDate__c		= today.addDays(1);
        iiAntiVS.SomDig_Adservertyp__c					= 'DFP';
        iiAntiVS.SomDig_Mediagattungs_Segement_Name__c	= mgs.Name;
        iiAntiVS.SomDig_Mediagattung__c					= mg.Id;
        iiAntiVS.SomDig_Mediagattungs_Segment__c			= mgs.Id;
        iiAntiVS.SomDig_Mediagattungs_Differenzierung__c	= mgd.Id;
        iiAntiVS.SomDig_Werbetraeger__c					= site.Id;

        Set<String> iiAntiVSBS	= new Set<String>();
        iiAntiVSBS.add('1231 / Sammel-1'); // Std. - Sammel IA (Ausbuchung)
        iiAntiVSBS.add('1232 / IA FM'); // Durchlauf - FM IA
        iiAntiVSBS.add('1237 / IA FM'); // Korrektur - FM IA
        iiAntiVSBS.add('1231 / IA FM'); // Std. - FM IA
        iiAntiVSBS.add('1231 / Fehler-1'); // Std. - Fehler IA
        iiAntiVSBS.add('1231 / IA'); // Std. - IA

        insert new List<ADvendio__InvoiceItem__c>{iiNas, iiMedia, iiMediaExtra, iiAnti, iiAntiVS, iiNoIA, iiDL, iiMediaExtra2};

        Test.StartTest();
        base			= new SomDig_Buchungssatz_EaBase(new List<ADvendio__InvoiceItem__c>{iiNas, iiDL, iiMedia, iiMediaExtra, iiAnti, iiAntiVS, iiNoIA, iiMediaExtra2}, SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_MINUS_5, today, true);
         //base			= new SomDig_Buchungssatz_EaBase(new List<ADvendio__InvoiceItem__c>{iiMediaExtra}, SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_MINUS_5, today, true);

        base.runProcess();

        system.assertEquals(8, base.RevenueDistributionResults.size());
        // Item Results
        for (SomDig_Buchungssatz_EaBase.RevenueDistributionResult rdr : base.RevenueDistributionResults) {
            if (iiNoIA.Id.equals(rdr.invoiceItem.Id)) {
                system.assertEquals(ApexPages.Severity.WARNING, rdr.messages.get(0).severity);
                system.assert(rdr.matchedLogics.contains('NonAdServer'));
                system.assertEquals(2, rdr.accountingRecordsGroups.size());
            }
            else if (iiNas.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('NonAdServer'));
                system.assertEquals(2, rdr.accountingRecordsGroups.size());
            }
            else if (iiDL.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('DL Anteil'));
                system.assertEquals(2, rdr.accountingRecordsGroups.size());
            }
            else if (iiMedia.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('EA Fremde Marken'));
                system.assertEquals(2, rdr.accountingRecordsGroups.size());
            }
            else if (iiMediaExtra.Id.equals(rdr.invoiceItem.Id)) {
                system.assertEquals(ApexPages.Severity.WARNING, rdr.messages.get(0).severity);
                system.assert(rdr.matchedLogics.contains('EA Werbung') && rdr.matchedLogics.contains('Extrapolation'));
                system.assertEquals(4, rdr.accountingRecordsGroups.size());
            }
            else if (iiMediaExtra2.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('EA Werbung') && rdr.matchedLogics.contains('Extrapolation'));
                system.assertEquals(4, rdr.accountingRecordsGroups.size());
            }
            else if (iiAnti.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('EA Fremde Marken') && rdr.matchedLogics.contains('Antizipation'));
                system.assertEquals(1, rdr.accountingRecordsGroups.size());
            }
            else if (iiAntiVS.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('EA Werbung') && rdr.matchedLogics.contains('Antizipation'));
                system.assertEquals(1, rdr.accountingRecordsGroups.size());
            }
            // AR Groups
            Integer groupIndex	= 0;
            for (SomDig_Buchungssatz_EaBase.AccountingRecordsGroup arg : rdr.accountingRecordsGroups) {

                if (iiNoIA.Id.equals(rdr.invoiceItem.Id)) {
                    system.assertEquals(2, arg.accountingRecords.size());
                }
                else if (iiNas.Id.equals(rdr.invoiceItem.Id)) {
                    if (groupIndex==0) { // PI
                        system.assertEquals(2, arg.accountingRecords.size());
                    }
                    else if (groupIndex==1) { // Umbuchung FM
                        system.assertEquals(4, arg.accountingRecords.size());
                    }
                }
                else if (iiMedia.Id.equals(rdr.invoiceItem.Id)) {
                    if (groupIndex==0) { // PI
                        system.assertEquals(2, arg.accountingRecords.size());
                    }
                    else if (groupIndex==1) { // Umbuchung FM
                        system.assertEquals(4, arg.accountingRecords.size());
                    }
                }
                else if (iiDL.Id.equals(rdr.invoiceItem.Id)) {
                    system.assertEquals(2, arg.accountingRecords.size()); // PI + DL
                }
                else if (iiMediaExtra.Id.equals(rdr.invoiceItem.Id)) {
                    if (groupIndex==0 || groupIndex==2) { // PI + PI HR
                        system.assertEquals(2, arg.accountingRecords.size());
                    }
                    else if (groupIndex==1 || groupIndex==3) { // EA + HR EA
                        system.assertEquals(9, arg.accountingRecords.size());
                    }
                }
                else if (iiMediaExtra2.Id.equals(rdr.invoiceItem.Id)) {
                    if (groupIndex==0 || groupIndex==2) { // PI + PI HR
                        system.assertEquals(2, arg.accountingRecords.size());
                    }
                    else if (groupIndex==1 || groupIndex==3) { // EA + HR EA
                        //system.assertEquals(5, arg.accountingRecords.size());
                    }
                }
                else if (iiAnti.Id.equals(rdr.invoiceItem.Id)) {
                    system.assertEquals(4, arg.accountingRecords.size());
                }
                else if (iiAntiVS.Id.equals(rdr.invoiceItem.Id)) {
                    system.assertEquals(6, arg.accountingRecords.size());
                }
                // AR
                Integer arIndex	= 0;
                for (SomDig_Buchungssatz_EaBase.AccountingRecord ar : arg.accountingRecords) {
                    if (iiNoIA.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            if (arIndex == 0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_FORDERUNG_HOCHRECHNUNG).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                        if (groupIndex==1) {
                            if (arIndex == 0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_FehlerIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }

                    if (iiNas.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            if (arIndex == 0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_FORDERUNG_HOCHRECHNUNG).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                        if (groupIndex==1) {
                            if (arIndex == 0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummerFM.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 2) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_KORREKTUR_WERBEERLOES).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummerFM.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 3) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_DURCHLAUFKONTO_FREMDMARKE).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummerFM.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }

                    if (iiDL.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            if (arIndex == 0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_FORDERUNG_HOCHRECHNUNG).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                        if (groupIndex==1) {
                            if (arIndex == 0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_DIENSTLEISTUNGEN).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_DIENSTLEISTUNGEN).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }

                    if (iiMedia.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            if (arIndex == 0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_FORDERUNG_HOCHRECHNUNG).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                        if (groupIndex==1) {
                            if (arIndex == 0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummerFM.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 2) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_KORREKTUR_WERBEERLOES).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummerFM.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 3) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_DURCHLAUFKONTO_FREMDMARKE).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummerFM.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }

                    if (iiAnti.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            if (arIndex == 0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummerFM.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 2) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_KORREKTUR_WERBEERLOES).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummerFM.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 3) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_DURCHLAUFKONTO_FREMDMARKE).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummerFM.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
// TODO
                    if (iiAntiVS.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            system.assert(iiAntiVSBS.contains(ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c + ' / ' + ar.accountingRecord.SomDig_Innenauftragsnummer__c));
                            // fix
                            iiAntiVSBS.remove(ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c + ' / ' + ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            iiAntiVSBS.add('1237 / IA FM');
                            iiAntiVSBS.add('1231 / 6661');
                        }

                        /*
                        if (groupIndex==0) {
                            if (arIndex == 0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummer.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 2) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummerFM.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 3) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_KORREKTUR_WERBEERLOES).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummerFM.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 4) {
// check!                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_DURCHLAUFKONTO_FREMDMARKE).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummerFM.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }*/
                    }

                    if (iiMediaExtra.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0 || groupIndex==2) {
                            if (arIndex == 0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_FORDERUNG_HOCHRECHNUNG).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                        if (groupIndex==1 || groupIndex==3) {
                            system.assert(iiMediaExtraBS.contains(ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c + ' / ' + ar.accountingRecord.SomDig_Innenauftragsnummer__c));
                        }
                    }

                    if (iiMediaExtra2.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0 || groupIndex==2) {
                            if (arIndex == 0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_FORDERUNG_HOCHRECHNUNG).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            else if (arIndex == 1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                        if (groupIndex==1 || groupIndex==3) {
                              system.assert(iiMediaExtraBS2.contains(ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c + ' / ' + ar.accountingRecord.SomDig_Innenauftragsnummer__c));
                        }
                    }

                    arIndex++;
                }
                groupIndex++;
            }
        }

        Test.StopTest();
    }

    @IsTest // U+4
    public static void testEaBaseEA() {

        createAdConfig();
        createAds();

        ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true, null, priceList);
           ADvendio__Campaign_Item__c ci		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
           ADvendio__Campaign_Item__c ci2		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
        insert new List<ADvendio__Campaign_Item__c>{ci, ci2};

        ADvendio__DeliveryData__c dd			= new ADvendio__DeliveryData__c();
        dd.ADvendio__AdServerID__c				= aid.Id;
        dd.ADvendio__DeliveredImpressions__c	= 500;
        dd.ADvendio__Day__c						= today.addDays(2);
        dd.ADvendio__CampaignItem__c			= ci.Id;
        dd.ADvendio__Type__c					= 'Monthly';
        insert dd;

        ADvendio__Invoice__c i				= cls_P7S1_TestData.createTestInvoice(false, mc);
        i.ADvendio__Status__c				= 'Invoiced';
        i.ADvendio__PaymentInterval__c		= 'total account (one Invoice)';
        i.ADvendio__PaymentStart__c			= 'before / during Billingperiod';
        i.ADvendio__AccountingDate__c		= today.toStartOfMonth();
        i.ADvendio__InvoiceDate__c			= today.toStartOfMonth();
        i.ADvendio__InvoiceDateManual__c	= today.toStartOfMonth();
        i.ADvendio__AccountingEndDate__c	= today.addDays(90).toStartOfMonth().addMonths(1).addDays(-1);
        i.ADvendio__BillingPeriodEndDate__c	= today.addDays(90);
        insert i;

        ADvendio__InvoiceItem__c ii			= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci);
        ii.ADvendio__Salesprice__c			= 300;
        ii.ADvendio__BookedQuantity__c		= 1000;
        ii.ADvendio__BillingCategory__c		= 'CPM';
        ii.ADvendio__LinearDistribution__c	= true;
        ii.ADvendio__FromDate__c			= today;
        ii.ADvendio__UntilDate__c			= today.addDays(90);
        ii.ADvendio__InvoiceItemStartDate__c = today;
        ii.ADvendio__InvoiceItemEndDate__c	= today.addDays(90);
        ii.SomDig_Adservertyp__c			= 'DFP';
        ii.SomDig_Mediagattungs_Segement_Name__c = mgs.Name;

        ADvendio__InvoiceItem__c iiNM				= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci2);
        iiNM.ADvendio__Salesprice__c				= 300;
        iiNM.ADvendio__BookedQuantity__c			= 1000;
        iiNM.ADvendio__BillingCategory__c			= 'CPM';
        iiNM.ADvendio__QuantityDelivered__c			= 1000;
        iiNM.ADvendio__LinearDistribution__c		= true;
        iiNM.ADvendio__FromDate__c					= today;
        iiNM.ADvendio__UntilDate__c					= today.addDays(90);
        iiNM.ADvendio__InvoiceItemStartDate__c		= today;
        iiNM.ADvendio__InvoiceItemEndDate__c		= today.addDays(90);
        iiNM.SomDig_Adservertyp__c					= 'Standard';
        iiNM.SomDig_Mediagattungs_Segement_Name__c	= mgsNM.Name;
        iiNM.SomDig_Werbetraeger__c					= site.Id;
        insert new List<ADvendio__InvoiceItem__c>{ii, iiNM};

        Test.StartTest();

        // Start EA with SAP month before item start
        SomDig_Buchungssatz_EaBase base	= new SomDig_Buchungssatz_EaBase(new List<ADvendio__InvoiceItem__c>{ii, iiNM}, SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_PLUS_4, ii.ADvendio__InvoiceItemStartDate__c.toStartOfMonth(), true);
        base.runProcess();
        base.savePRAP();

        system.assert(base.hasPRAPs, '1 PRAP Record is expected');
        system.assert(base.hasData, 'Results are expected');
        system.assert(base.hasResults, 'Results are expected');

        List<SomDig_Buchungssatz__c> bsList	= new List<SomDig_Buchungssatz__c>();

        // Buchungssätze speichern
        // Integer arIndex	= 0;
        for (SomDig_Buchungssatz_EaBase.RevenueDistributionResult rdr : base.RevenueDistributionResults) {
            if (ii.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('EA Werbung'));
                system.assert(rdr.matchedLogics.contains('PRAP Creation'));
                system.assertEquals(1, rdr.accountingRecordsGroups.size());
            }
            if (iiNM.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('NonAdServer'));
                system.assertEquals(1, rdr.accountingRecordsGroups.size());
            }

            Integer groupIndex	= 0;
            for (SomDig_Buchungssatz_EaBase.AccountingRecordsGroup arg : rdr.accountingRecordsGroups) {
                Integer arIndex	= 0;
                for (SomDig_Buchungssatz_EaBase.AccountingRecord ar : arg.accountingRecords) {
                    if (ii.Id.equals(rdr.invoiceItem.Id)) {
                        system.assertEquals(2, arg.accountingRecords.size());
                        if (groupIndex==0) {
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                   system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
                    if (iiNM.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            system.assertEquals(2, arg.accountingRecords.size());
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                   system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
                    bsList.add(ar.accountingRecord);
                    arIndex++;
                    ar.accountingRecord.Name = '1-2-3-' + String.valueOf(groupIndex);
                }
                groupIndex++;
            }
        }


        // Start EA with SAP month in item start-month
        base	= new SomDig_Buchungssatz_EaBase(new List<ADvendio__InvoiceItem__c>{ii, iiNM}, SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_PLUS_4, ii.ADvendio__InvoiceItemStartDate__c.toStartOfMonth().addMonths(1), true);
        base.runProcess();
        system.assertEquals(SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_PLUS_4, base.selectedProcessType);
        base.savePRAP();

        // Buchungssätze speichern
        // Integer arIndex	= 0;
        for (SomDig_Buchungssatz_EaBase.RevenueDistributionResult rdr : base.RevenueDistributionResults) {
            if (ii.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('EA Werbung'));
                system.assert(rdr.matchedLogics.contains('PRAP Creation'));
                system.assertEquals(1, rdr.accountingRecordsGroups.size());
            }
            if (iiNM.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('NonAdServer'));
                system.assertEquals(1, rdr.accountingRecordsGroups.size());
            }

            Integer groupIndex	= 0;
            for (SomDig_Buchungssatz_EaBase.AccountingRecordsGroup arg : rdr.accountingRecordsGroups) {
                Integer arIndex	= 0;
                for (SomDig_Buchungssatz_EaBase.AccountingRecord ar : arg.accountingRecords) {
                    if (ii.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            system.assertEquals(2, arg.accountingRecords.size());
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                   system.assertEquals(iaNummer.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
                    if (iiNM.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            system.assertEquals(2, arg.accountingRecords.size());
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                   system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummer.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
                    bsList.add(ar.accountingRecord);
                    arIndex++;
                    ar.accountingRecord.Name = '2-2-3-' + String.valueOf(groupIndex);
                }
                groupIndex++;
            }
        }


        // Start EA with SAP month in item end-month
        base	= new SomDig_Buchungssatz_EaBase(new List<ADvendio__InvoiceItem__c>{ii, iiNM}, SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_PLUS_4, ii.ADvendio__InvoiceItemEndDate__c.toStartOfMonth().addMonths(1), true);
        base.runProcess();
        system.assertEquals(SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_PLUS_4, base.selectedProcessType);
        base.savePRAP();

        List<SomDig_Prap__c> praps	= [SELECT Id,SomDig_Abrechnungsmonat__c,SomDig_Abrechnungsmonatsende__c,SomDig_AbzugrenzendeErloese__c,
                                              SomDig_AbgerechneteErloese__c,SomDig_Status__c,SomDig_NochAbzugrenzendeErloese__c,SomDig_Rechnungsposition__c
                                         FROM SomDig_Prap__c order by SomDig_Rechnungsposition__c, SomDig_Abrechnungsmonat__c asc];

        // Buchungssätze speichern
        // Integer arIndex	= 0;
        for (SomDig_Buchungssatz_EaBase.RevenueDistributionResult rdr : base.RevenueDistributionResults) {
            if (ii.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('EA Werbung'));
                system.assert(rdr.matchedLogics.contains('PRAP Creation'));

                Decimal amoutToPrap	= rdr.invoiceItem.ADvendio__InvoicedAmountNet2__c;
                for (SomDig_Prap__c prap : praps) {
                    if (prap.SomDig_Rechnungsposition__c == rdr.invoiceItem.Id) {
                        if (prap.SomDig_Abrechnungsmonat__c == rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth().addMonths(-1)) {
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth().addMonths(-1),	prap.SomDig_Abrechnungsmonat__c);
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth().addDays(-1),		prap.SomDig_Abrechnungsmonatsende__c);
                            system.assertEquals(amoutToPrap,																		prap.SomDig_AbzugrenzendeErloese__c);
                            system.assertEquals(0.0,																				prap.SomDig_AbgerechneteErloese__c);
                            system.assertEquals(amoutToPrap,																		prap.SomDig_NochAbzugrenzendeErloese__c);
                        }
                        else if (prap.SomDig_Abrechnungsmonat__c == rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth()) {
                            Decimal deliveryAmount	= (amoutToPrap / 2).setScale(2, System.RoundingMode.HALF_DOWN);
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth(),									prap.SomDig_Abrechnungsmonat__c);
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth().addMonths(1).addDays(-1),		prap.SomDig_Abrechnungsmonatsende__c);
                            system.assertEquals(amoutToPrap,																						prap.SomDig_AbzugrenzendeErloese__c);
                            system.assertEquals(deliveryAmount,																						prap.SomDig_AbgerechneteErloese__c);
                            system.assertEquals(amoutToPrap - deliveryAmount,																		prap.SomDig_NochAbzugrenzendeErloese__c);
                            amoutToPrap	= prap.SomDig_NochAbzugrenzendeErloese__c;
                        }
                        else if (prap.SomDig_Abrechnungsmonat__c == rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth().addMonths(1)) {
                            system.assertEquals(ApexPages.Severity.INFO, rdr.messages.get(0).severity);
                            system.assert(rdr.messages.get(0).message.contains('Der Betrag ist 0.'));
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth().addMonths(1),					prap.SomDig_Abrechnungsmonat__c);
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoiceItemEndDate__c.toStartOfMonth().addMonths(1).addDays(-1),			prap.SomDig_Abrechnungsmonatsende__c);
                            system.assertEquals(amoutToPrap,																						prap.SomDig_AbzugrenzendeErloese__c);
                            system.assertEquals(0.0,																								prap.SomDig_AbgerechneteErloese__c);
                            system.assertEquals(amoutToPrap,																						prap.SomDig_NochAbzugrenzendeErloese__c);
                        }
                        else {
                            system.assert(false, 'this PRAP is not expected. Start: ' + prap.SomDig_Abrechnungsmonat__c);
                        }
                    }
                }

            }
            if (iiNM.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('NonAdServer'));
                system.assertEquals(1, rdr.accountingRecordsGroups.size());

                Decimal runTimeTotal		= rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.daysBetween(rdr.invoiceItem.ADvendio__InvoiceItemEndDate__c)+1;
                Decimal runTimeThisMonth	= 0;
                Decimal amountThisMonth		= 0.0;
                Decimal amoutToPrap	= rdr.invoiceItem.ADvendio__InvoicedAmountNet2__c;

                for (SomDig_Prap__c prap : praps) {
                    if (prap.SomDig_Rechnungsposition__c == rdr.invoiceItem.Id) {
                        Date startDate		= rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.daysBetween(prap.SomDig_Abrechnungsmonat__c) >= 0 ? prap.SomDig_Abrechnungsmonat__c : rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c;
                        Date endDate		= rdr.invoiceItem.ADvendio__InvoiceItemEndDate__c.daysBetween(prap.SomDig_Abrechnungsmonatsende__c) >= 0 ? rdr.invoiceItem.ADvendio__InvoiceItemEndDate__c : prap.SomDig_Abrechnungsmonatsende__c;

                        runTimeThisMonth	= startDate.daysBetween(endDate)+1;
                        amountThisMonth		= rdr.invoiceItem.ADvendio__InvoicedAmountNet2__c / runTimeTotal *  runTimeThisMonth;
                        amountThisMonth		= amountThisMonth.setScale(2, System.RoundingMode.HALF_DOWN);

                        if (prap.SomDig_Abrechnungsmonat__c == rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth().addMonths(-1)) {
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth().addMonths(-1),	prap.SomDig_Abrechnungsmonat__c);
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth().addDays(-1),		prap.SomDig_Abrechnungsmonatsende__c);
                            system.assertEquals(amoutToPrap,																		prap.SomDig_AbzugrenzendeErloese__c);
                            system.assertEquals(0.0,																				prap.SomDig_AbgerechneteErloese__c);
                            system.assertEquals(amoutToPrap,																		prap.SomDig_NochAbzugrenzendeErloese__c);
                        }
                        else if (prap.SomDig_Abrechnungsmonat__c == rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth()) {
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth(),								prap.SomDig_Abrechnungsmonat__c);
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth().addMonths(1).addDays(-1),	prap.SomDig_Abrechnungsmonatsende__c);
                            system.assertEquals(amoutToPrap,																					prap.SomDig_AbzugrenzendeErloese__c);
                            system.assertEquals(amountThisMonth,																				prap.SomDig_AbgerechneteErloese__c);
                            system.assertEquals(prap.SomDig_AbzugrenzendeErloese__c - amountThisMonth,											prap.SomDig_NochAbzugrenzendeErloese__c);
                            amoutToPrap	= prap.SomDig_NochAbzugrenzendeErloese__c;
                        }
                        else if (prap.SomDig_Abrechnungsmonat__c == rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth().addMonths(1)) {
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth().addMonths(1),					prap.SomDig_Abrechnungsmonat__c);
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoiceItemEndDate__c.toStartOfMonth().addMonths(1).addDays(-1),			prap.SomDig_Abrechnungsmonatsende__c);
                            system.assertEquals(amoutToPrap,																						prap.SomDig_AbzugrenzendeErloese__c);
                            system.assertEquals(amountThisMonth,																					prap.SomDig_AbgerechneteErloese__c);
                            system.assertEquals(prap.SomDig_AbzugrenzendeErloese__c - amountThisMonth,												prap.SomDig_NochAbzugrenzendeErloese__c);
                        }
                        else {
                            system.assert(false, 'this PRAP is not expected. Start: ' + prap.SomDig_Abrechnungsmonat__c);
                        }
                    }
                }
            }

            Integer groupIndex	= 0;
            for (SomDig_Buchungssatz_EaBase.AccountingRecordsGroup arg : rdr.accountingRecordsGroups) {
                Integer arIndex	= 0;
                for (SomDig_Buchungssatz_EaBase.AccountingRecord ar : arg.accountingRecords) {
                    if (ii.Id.equals(rdr.invoiceItem.Id)) {
                       system.assert(false, 'No Buchungssatz expected for 0 Amount');
                    }
                    if (iiNM.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                   system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummer.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
                    bsList.add(ar.accountingRecord);
                    arIndex++;
                    ar.accountingRecord.Name = '3-2-3-' + String.valueOf(groupIndex);
                }
                groupIndex++;
            }
        }

        insert bsList;

        // Storno
        ADvendio__Invoice__c iNeg	= i.clone();
        iNeg.ADvendio__Invoice__c	= i.Id;
        iNeg.ADvendio__Status__c	= 'Reviewed';
        insert iNeg;

        ADvendio__InvoiceItem__c iiNeg					= ii.clone();
        iiNeg.ADvendio__InvoicedQuantityMultiplier__c	= -1;
        iiNeg.ADvendio__Invoice__c						= iNeg.Id;
        iiNeg.ADvendio__InvoicedAmountNet2__c			= -300;
        iiNeg.ADvendio__ConnectedItem__c				= ii.Id;

        ADvendio__InvoiceItem__c iiNMNeg				= iiNM.clone();
        iiNMNeg.ADvendio__InvoicedQuantityMultiplier__c	= -1;
        iiNMNeg.ADvendio__Invoice__c					= iNeg.Id;
        iiNMNeg.ADvendio__InvoicedAmountNet2__c			= -300;
        iiNMNeg.ADvendio__ConnectedItem__c				= iiNM.Id;
        insert new List<ADvendio__InvoiceItem__c>{iiNeg, iiNMNeg};

        base	= new SomDig_Buchungssatz_EaBase(new List<ADvendio__InvoiceItem__c>{iiNeg, iiNMNeg}, SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_MINUS_5, today, true);
        base.runProcess();

        system.assertEquals(2, base.RevenueDistributionResults.size());

        for (SomDig_Buchungssatz_EaBase.RevenueDistributionResult rdr : base.RevenueDistributionResults) {
            Integer groupIndex	= 0;
            for (SomDig_Buchungssatz_EaBase.AccountingRecordsGroup arg : rdr.accountingRecordsGroups) {
                if (iiNeg.Id.equals(rdr.invoiceItem.Id)) {
                    system.assert(rdr.matchedLogics.contains('PRAP Cancellation'));
                    system.assertEquals(1, rdr.accountingRecordsGroups.size());
                }
                else if (iiNMNeg.Id.equals(rdr.invoiceItem.Id)) {
                    system.assert(rdr.matchedLogics.contains('PRAP Cancellation'));
                    system.assertEquals(2, rdr.accountingRecordsGroups.size());
                }

                Integer arIndex	= 0;
                for (SomDig_Buchungssatz_EaBase.AccountingRecord ar : arg.accountingRecords) {
                    if (iiNeg.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            system.assertEquals(4, arg.accountingRecords.size());
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                   system.assertEquals(iaNummer.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==2) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==3) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
                    else if (iiNMNeg.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            system.assertEquals(6, arg.accountingRecords.size());
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                   system.assertEquals(iaNummer.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==2) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==3) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                   system.assertEquals(iaNummer.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==4) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==5) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                        if (groupIndex==1) {
                            system.assertEquals(2, arg.accountingRecords.size());
                            if (arIndex==2) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==3) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_FORDERUNG_HOCHRECHNUNG).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
                    else {
                        system.debug(arIndex + ' - '+ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c + ' / ' + ar.accountingRecord.SomDig_Innenauftragsnummer__c + ' =/= ' + ar.accountingRecord);
                    }

                    arIndex++;
                }
                groupIndex++;
            }
        }

        base	= new SomDig_Buchungssatz_EaBase(new List<ADvendio__InvoiceItem__c>{iiNeg, iiNMNeg}, SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_PLUS_4, today, true);
        base.runProcess();

        for (SomDig_Buchungssatz_EaBase.RevenueDistributionResult rdr : base.RevenueDistributionResults) {
            system.assertEquals(ApexPages.Severity.INFO, rdr.messages.get(0).severity);

            if (iiNeg.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('PRAP Cancellation'));
                system.assertEquals(1, rdr.accountingRecordsGroups.size());
            }
            else if (iiNMNeg.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('PRAP Cancellation'));
                system.assertEquals(1, rdr.accountingRecordsGroups.size());
            }
            else {
                system.assert(false, 'No non-Item records expected');
            }

            Integer groupIndex	= 0;
            for (SomDig_Buchungssatz_EaBase.AccountingRecordsGroup arg : rdr.accountingRecordsGroups) {
                Integer arIndex	= 0;
                for (SomDig_Buchungssatz_EaBase.AccountingRecord ar : arg.accountingRecords) {
                    if (iiNeg.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            system.assertEquals(4, arg.accountingRecords.size());
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                   system.assertEquals(iaNummer.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==2) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==3) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
                    else if (iiNMNeg.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            system.assertEquals(6, arg.accountingRecords.size());
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                   system.assertEquals(iaNummer.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==2) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==3) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                   system.assertEquals(iaNummer.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==4) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==5) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
                    arIndex++;
                }
                groupIndex++;
            }
        }

        Test.stopTest();
    }

    @IsTest // U+4
    public static void testEaBaseEA2() {

        createAdConfig();
        createAds();

        ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true, null, priceList);
           ADvendio__Campaign_Item__c ci		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
           ADvendio__Campaign_Item__c ci2		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
        insert new List<ADvendio__Campaign_Item__c>{ci, ci2};

        ADvendio__DeliveryData__c dd			= new ADvendio__DeliveryData__c();
        dd.ADvendio__AdServerID__c				= aid.Id;
        dd.ADvendio__DeliveredImpressions__c	= 500;
        dd.ADvendio__Day__c						= today.addDays(2);
        dd.ADvendio__CampaignItem__c			= ci.Id;
        dd.ADvendio__Type__c					= 'Monthly';
        insert dd;

        ADvendio__Invoice__c i				= cls_P7S1_TestData.createTestInvoice(false, mc);
        i.ADvendio__Status__c				= 'Invoiced';
        i.ADvendio__PaymentInterval__c		= 'total account (one Invoice)';
        i.ADvendio__PaymentStart__c			= 'before / during Billingperiod';
        i.ADvendio__AccountingDate__c		= today.toStartOfMonth();
        i.ADvendio__BillingPeriodEndDate__c	= today.addDays(90);
        insert i;

        ADvendio__InvoiceItem__c ii			= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci);
        ii.ADvendio__Salesprice__c			= 300;
        ii.ADvendio__BookedQuantity__c		= 1000;
        ii.ADvendio__BillingCategory__c		= 'CPM';
        ii.ADvendio__LinearDistribution__c	= true;
        ii.ADvendio__FromDate__c			= today;
        ii.ADvendio__UntilDate__c			= today.addDays(90);
        ii.ADvendio__InvoiceItemStartDate__c = today;
        ii.ADvendio__InvoiceItemEndDate__c	= today.addDays(90);
        ii.SomDig_Adservertyp__c			= 'DFP';
        ii.SomDig_Mediagattungs_Segement_Name__c = mgs.Name;

        ADvendio__InvoiceItem__c iiNM				= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci2);
        iiNM.ADvendio__Salesprice__c				= 300;
        iiNM.ADvendio__BookedQuantity__c			= 1000;
        iiNM.ADvendio__BillingCategory__c			= 'CPM';
        iiNM.ADvendio__QuantityDelivered__c			= 1000;
        iiNM.ADvendio__LinearDistribution__c		= true;
        iiNM.ADvendio__FromDate__c					= today;
        iiNM.ADvendio__UntilDate__c					= today.addDays(90);
        iiNM.ADvendio__InvoiceItemStartDate__c		= today;
        iiNM.ADvendio__InvoiceItemEndDate__c		= today.addDays(90);
        iiNM.SomDig_Adservertyp__c					= 'Standard';
        iiNM.SomDig_Mediagattungs_Segement_Name__c	= mgsNM.Name;
        iiNM.SomDig_Werbetraeger__c					= site.Id;
        insert new List<ADvendio__InvoiceItem__c>{ii, iiNM};

        Test.StartTest();

        SomDig_Buchungssatz_EaBase base	= new SomDig_Buchungssatz_EaBase(new List<ADvendio__InvoiceItem__c>{ii, iiNM}, SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_PLUS_4, today.addMonths(3), true);
        base.runProcess();
        base.savePRAP();
        system.assert(base.hasPRAPs, '1 PRAP Record is expected');
        system.assert(base.hasData, 'Results are expected');
        system.assert(base.hasResults, 'Results are expected');

        List<SomDig_Buchungssatz__c> bsList	= new List<SomDig_Buchungssatz__c>();

        List<SomDig_Prap__c> praps	= [SELECT Id,SomDig_Abrechnungsmonat__c,SomDig_Abrechnungsmonatsende__c,SomDig_AbzugrenzendeErloese__c,
                                              SomDig_AbgerechneteErloese__c,SomDig_Status__c,SomDig_NochAbzugrenzendeErloese__c,SomDig_Rechnungsposition__c
                                         FROM SomDig_Prap__c order by SomDig_Rechnungsposition__c, SomDig_Abrechnungsmonat__c asc];

        // Buchungssätze speichern
        // Integer arIndex	= 0;
        for (SomDig_Buchungssatz_EaBase.RevenueDistributionResult rdr : base.RevenueDistributionResults) {
            if (ii.Id.equals(rdr.invoiceItem.Id)) {
                Decimal amoutToPrap	= (rdr.invoiceItem.ADvendio__InvoicedAmountNet2__c / 2).setScale(2, System.RoundingMode.HALF_DOWN);

                system.assert(rdr.matchedLogics.contains('EA Werbung'));
                system.assert(rdr.matchedLogics.contains('PRAP Creation'));
                system.assertEquals(2, rdr.accountingRecordsGroups.size());

                for (SomDig_Prap__c prap : praps) {
                    if (prap.SomDig_Rechnungsposition__c == rdr.invoiceItem.Id) {
                        if (prap.SomDig_Abrechnungsmonat__c == rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth()) {
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth(),								prap.SomDig_Abrechnungsmonat__c);
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth().addMonths(3).addDays(-1),	prap.SomDig_Abrechnungsmonatsende__c);
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoicedAmountNet2__c,												prap.SomDig_AbzugrenzendeErloese__c);
                            system.assertEquals(amoutToPrap,																					prap.SomDig_AbgerechneteErloese__c);
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoicedAmountNet2__c - amoutToPrap,									prap.SomDig_NochAbzugrenzendeErloese__c);
                        }
                        else {
                            system.assert(false, 'this PRAP is not expected. Start: ' + prap.SomDig_Abrechnungsmonat__c);
                        }
                    }
                }
            }
            if (iiNM.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('NonAdServer'));
                system.assertEquals(2, rdr.accountingRecordsGroups.size());

                Decimal runTimeTotal		= rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.daysBetween(rdr.invoiceItem.ADvendio__InvoiceItemEndDate__c)+1;
                Decimal runTimeThisPeriod	= 0;
                Decimal amountThisPeriod	= 0.0;

                for (SomDig_Prap__c prap : praps) {
                    if (prap.SomDig_Rechnungsposition__c == rdr.invoiceItem.Id) {

                        Date startDate		= rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.daysBetween(prap.SomDig_Abrechnungsmonat__c) >= 0 ? prap.SomDig_Abrechnungsmonat__c : rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c;
                        Date endDate		= rdr.invoiceItem.ADvendio__InvoiceItemEndDate__c.daysBetween(prap.SomDig_Abrechnungsmonatsende__c) >= 0 ? rdr.invoiceItem.ADvendio__InvoiceItemEndDate__c : prap.SomDig_Abrechnungsmonatsende__c;

                        runTimeThisPeriod	= startDate.daysBetween(endDate)+1;
						amountThisPeriod	= new SomDig_Buchungssatz_EaBase.RevenueDistributionResult(rdr.invoiceItem).getPlanedRevenueOfMonth(rdr.accountingPeriodStartDate, rdr.accountingPeriodEndDate).setScale(2);

                        if (prap.SomDig_Abrechnungsmonat__c == rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth()) {
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth(),								prap.SomDig_Abrechnungsmonat__c);
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoiceItemStartDate__c.toStartOfMonth().addMonths(3).addDays(-1),	prap.SomDig_Abrechnungsmonatsende__c);
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoicedAmountNet2__c,												prap.SomDig_AbzugrenzendeErloese__c);
                            system.assertEquals(amountThisPeriod,																				prap.SomDig_AbgerechneteErloese__c);
                            system.assertEquals(rdr.invoiceItem.ADvendio__InvoicedAmountNet2__c - amountThisPeriod,								prap.SomDig_NochAbzugrenzendeErloese__c);
                        }
                        else {
                            system.assert(false, 'this PRAP is not expected. Start: ' + prap.SomDig_Abrechnungsmonat__c);
                        }
                    }
                }
            }

            Integer groupIndex	= 0;
            for (SomDig_Buchungssatz_EaBase.AccountingRecordsGroup arg : rdr.accountingRecordsGroups) {
                Integer arIndex	= 0;
                for (SomDig_Buchungssatz_EaBase.AccountingRecord ar : arg.accountingRecords) {
                    if (ii.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummer.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                        if (groupIndex==1) {
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                   system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
                    if (iiNM.Id.equals(rdr.invoiceItem.Id)) {
                       if (groupIndex==0) {
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummer.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                        if (groupIndex==1) {
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                   system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
                    bsList.add(ar.accountingRecord);
                    arIndex++;
                    ar.accountingRecord.Name = '1-2-3-' + String.valueOf(groupIndex);
                }
                groupIndex++;
            }
        }
        insert bsList;

        // Item Storno
        ADvendio__Invoice__c iNeg	= i.clone();
        iNeg.ADvendio__Invoice__c	= i.Id;
        iNeg.ADvendio__Status__c	= 'Reviewed';
        insert iNeg;

        ADvendio__InvoiceItem__c iiNeg					= ii.clone();
        iiNeg.ADvendio__InvoicedQuantityMultiplier__c	= -1;
        iiNeg.ADvendio__Invoice__c						= iNeg.Id;
        iiNeg.ADvendio__InvoicedAmountNet2__c			= 10;
        iiNeg.ADvendio__ConnectedItem__c				= ii.Id;
        iiNeg.ADvendio__UniqueKey__c					= 'rtz';//ii.ADvendio__UniqueKey__c + '|tmp|';

        ADvendio__InvoiceItem__c iiNMNeg				= iiNM.clone();
        iiNMNeg.ADvendio__InvoicedQuantityMultiplier__c	= -1;
        iiNMNeg.ADvendio__Invoice__c					= iNeg.Id;
        iiNMNeg.ADvendio__InvoicedAmountNet2__c			= 10;
        iiNMNeg.ADvendio__ConnectedItem__c				= iiNM.Id;
        iiNMNeg.ADvendio__UniqueKey__c					= 'tfz er';//iiNM.ADvendio__UniqueKey__c + '|tmp|';
        insert new List<ADvendio__InvoiceItem__c>{iiNeg, iiNMNeg};

        base	= new SomDig_Buchungssatz_EaBase(new List<ADvendio__InvoiceItem__c>{iiNeg, iiNMNeg}, SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_MINUS_5, today, true);
        base.runProcess();

        system.assertEquals(2, base.RevenueDistributionResults.size());

        for (SomDig_Buchungssatz_EaBase.RevenueDistributionResult rdr : base.RevenueDistributionResults) {
            system.assertEquals(ApexPages.Severity.INFO, rdr.messages.get(0).severity);

            Integer groupIndex	= 0;
            for (SomDig_Buchungssatz_EaBase.AccountingRecordsGroup arg : rdr.accountingRecordsGroups) {
                if (iiNeg.Id.equals(rdr.invoiceItem.Id)) {
                    system.assert(rdr.matchedLogics.contains('PRAP Cancellation'));
                    system.assertEquals(2, rdr.accountingRecordsGroups.size());
                }
                else if (iiNMNeg.Id.equals(rdr.invoiceItem.Id)) {
                    system.assert(rdr.matchedLogics.contains('PRAP Cancellation'));
                    system.assertEquals(3, rdr.accountingRecordsGroups.size());
                }

                Integer arIndex	= 0;
                for (SomDig_Buchungssatz_EaBase.AccountingRecord ar : arg.accountingRecords) {
                    if (iiNeg.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                   system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                        if (groupIndex==1) {
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummer.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
                    else if (iiNMNeg.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                   system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                        if (groupIndex==1) {
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummer.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                        if (groupIndex==2) {
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_FORDERUNG_HOCHRECHNUNG).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
                    else {
                        system.debug(arIndex + ' - '+ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c + ' / ' + ar.accountingRecord.SomDig_Innenauftragsnummer__c + ' =/= ' + ar.accountingRecord);
                    }

                    arIndex++;
                }
                groupIndex++;
            }
        }

        base	= new SomDig_Buchungssatz_EaBase(new List<ADvendio__InvoiceItem__c>{iiNeg, iiNMNeg}, SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_PLUS_4, ii.ADvendio__InvoiceItemStartDate__c.toStartOfMonth(), true);
        base.runProcess();

        for (SomDig_Buchungssatz_EaBase.RevenueDistributionResult rdr : base.RevenueDistributionResults) {
            system.assertEquals(ApexPages.Severity.INFO, rdr.messages.get(0).severity);

            if (iiNeg.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('PRAP Cancellation'));
                system.assertEquals(2, rdr.accountingRecordsGroups.size());
            }
            else if (iiNMNeg.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('PRAP Cancellation'));
                system.assertEquals(2, rdr.accountingRecordsGroups.size());
            }
            else {
                system.assert(false, 'No non-Item records expected');
            }

            Integer groupIndex	= 0;
            for (SomDig_Buchungssatz_EaBase.AccountingRecordsGroup arg : rdr.accountingRecordsGroups) {
                Integer arIndex	= 0;
                for (SomDig_Buchungssatz_EaBase.AccountingRecord ar : arg.accountingRecords) {
                    if (iiNeg.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                   system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                        if (groupIndex==1) {
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummer.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
                    if (iiNMNeg.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_PRAP).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                   system.assertEquals(null, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                        if (groupIndex==1) {
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummer.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
                    arIndex++;
                }
                groupIndex++;
            }
        }

        Test.stopTest();
    }

    @IsTest // U+4, Intercompany
    public static void testEaBaseEA_IC() {

        createAdConfig();
        createAds();

        ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true, null, priceList);
           ADvendio__Campaign_Item__c ci		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
           ADvendio__Campaign_Item__c ci2		= cls_P7S1_TestData.createTestCampaignItem(false, mc, adPrice);
        insert new List<ADvendio__Campaign_Item__c>{ci, ci2};

        ADvendio__DeliveryData__c dd			= new ADvendio__DeliveryData__c();
        dd.ADvendio__AdServerID__c				= aid.Id;
        dd.ADvendio__DeliveredImpressions__c	= 500;
        dd.ADvendio__Day__c						= today.addDays(-20);
        dd.ADvendio__CampaignItem__c			= ci.Id;
        dd.ADvendio__Type__c					= 'Monthly';
        insert dd;

        ADvendio__Invoice__c i						= cls_P7S1_TestData.createTestInvoice(false, mc);
        i.ADvendio__Status__c						= 'Invoiced';
        i.ADvendio__PaymentInterval__c				= 'monthly (1 month)';
        i.ADvendio__PaymentStart__c					= 'after Billingperiod';
        i.ADvendio__AccountingDate__c				= today.toStartOfMonth().addMonths(-1);
        i.ADvendio__BillingPeriodEndDate__c			= today.addDays(-20);
        i.ADvendio__InvoiceDateManual__c			= today.toStartOfMonth();
        i.ADvendio__InvoiceDate__c					= today.toStartOfMonth();
        i.SomDig_RG_Empfaenger_P7S1_Konzernmitgl__c	= true;
        i.SomDig_PartnerId__c						= '12345';
        insert i;

        ADvendio__InvoiceItem__c ii			= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci);
        ii.ADvendio__Salesprice__c			= 10;
        ii.ADvendio__BookedQuantity__c		= 1000;
        ii.ADvendio__BillingCategory__c		= 'CPM';
        ii.ADvendio__LinearDistribution__c	= true;
        ii.ADvendio__FromDate__c			= today.addDays(-25);
        ii.ADvendio__UntilDate__c			= today.addDays(-19);
        ii.ADvendio__InvoiceItemStartDate__c = today.addDays(-25);
        ii.ADvendio__InvoiceItemEndDate__c	= today.addDays(-19);
        ii.SomDig_Adservertyp__c			= 'DFP';
        ii.SomDig_Mediagattungs_Segement_Name__c = mgs.Name;

        ADvendio__InvoiceItem__c iiNM				= cls_P7S1_TestData.createTestInvoiceItem(false, i , ci2);
        iiNM.ADvendio__Salesprice__c				= 10;
        iiNM.ADvendio__BookedQuantity__c			= 1000;
        iiNM.ADvendio__BillingCategory__c			= 'CPM';
        iiNM.ADvendio__QuantityDelivered__c			= 1000;
        iiNM.ADvendio__LinearDistribution__c		= true;
        iiNM.ADvendio__FromDate__c					= today.addDays(-18);
        iiNM.ADvendio__UntilDate__c					= today.addDays(-18);
        iiNM.ADvendio__InvoiceItemStartDate__c		= today.addDays(-18);
        iiNM.ADvendio__InvoiceItemEndDate__c		= today.addDays(-18);
        iiNM.SomDig_Adservertyp__c					= 'Standard';
        iiNM.SomDig_Mediagattungs_Segement_Name__c	= mgsNM.Name;
        iiNM.SomDig_Werbetraeger__c					= site.Id;
        insert new List<ADvendio__InvoiceItem__c>{ii, iiNM};

        Test.StartTest();

        SomDig_Buchungssatz_EaBase base	= new SomDig_Buchungssatz_EaBase(new List<ADvendio__InvoiceItem__c>{ii, iiNM}, SomDig_Buchungssatz_EaBatch.PROCESS_ULTIMO_PLUS_4, today, true);
        base.runProcess();

        for (SomDig_Buchungssatz_EaBase.RevenueDistributionResult rdr : base.RevenueDistributionResults) {

            if (ii.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('EA Werbung'));
                system.assertEquals(1, rdr.accountingRecordsGroups.size());
            }
            if (iiNM.Id.equals(rdr.invoiceItem.Id)) {
                system.assert(rdr.matchedLogics.contains('NonAdServer'));
                system.assertEquals(1, rdr.accountingRecordsGroups.size());
            }

            Integer groupIndex	= 0;
            for (SomDig_Buchungssatz_EaBase.AccountingRecordsGroup arg : rdr.accountingRecordsGroups) {
                Integer arIndex	= 0;
                for (SomDig_Buchungssatz_EaBase.AccountingRecord ar : arg.accountingRecords) {

                    system.assertEquals(rdr.invoiceItem.ADvendio__Invoice__r.SomDig_PartnerId__c, ar.accountingRecord.SomDig_PartnerId__c);

                    if (ii.Id.equals(rdr.invoiceItem.Id)) {
                        if (groupIndex==0) {
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_IC).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_IC).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_IC).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummer.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
                    if (iiNM.Id.equals(rdr.invoiceItem.Id)) {

                        if (groupIndex==0) {
                            if (arIndex==0) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_IC).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                   system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_IC).SomDig_SammelIA__c, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                            if (arIndex==1) {
                                system.assertEquals(sachkonten.get(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_IC).Name, ar.accountingRecord.SomDig_Erloeskonto_Sachkonto__c);
                                system.assertEquals(iaNummer.Name, ar.accountingRecord.SomDig_Innenauftragsnummer__c);
                            }
                        }
                    }
                    arIndex++;
                }
                groupIndex++;
            }
        }

        Test.stopTest();
    }
}