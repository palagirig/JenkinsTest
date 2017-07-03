@isTest
public class SomDig_SapDatei_Test {

	@isTest (seeAllData=false)
	private static void testSetUploadStatus() {

		SomDig_SapDatei__c sapDatei			= new SomDig_SapDatei__c();
		sapDatei.SomDig_Buchungskreis__c	= '0029';
		sapDatei.SomDig_Quellsystem__c 		= 'advendio';
		sapDatei.SomDig_Monat__c 			= '04';
		sapDatei.SomDig_Jahr__c				= '2016';
		sapDatei.SomDig_Status__c 			= 'erstellt';
		sapDatei.RecordTypeId 				= [SELECT Id, SobjectType, DeveloperName FROM RecordType WHERE SobjectType='SomDig_SapDatei__c' and DeveloperName='SomDig_Hochrechnung' and IsActive = true limit 1].Id;
		insert sapDatei;
		
		ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true);
		ADvendio__Invoice__c invoice		= cls_P7S1_TestData.createTestInvoice(true, mc);
		SomDig_Buchungssatz__c bs			= new SomDig_Buchungssatz__c();
		bs.Name								= mc.Id + '-' + invoice.Id + '-' + 'a1f-000001-000001';
		bs.SomDig_Buchungskreis__c			= sapDatei.SomDig_Buchungskreis__c;
		bs.SomDig_VerrechnungsmonatSAP__c	= '1604'; // faked sapDatei.SomDig_Verrechnungsmonat__c
		bs.RecordTypeId						= [SELECT Id, SobjectType, DeveloperName FROM RecordType WHERE SobjectType='SomDig_Buchungssatz__c' and DeveloperName='Hochrechnung' and IsActive = true limit 1].Id;
		insert bs;
		
		try {
			SomDig_SapDatei.setUploadStatus(sapDatei.Id);
		}
		catch (Exception e) {
			system.assert(e.getMessage().contains('Es existieren nicht-zugewiesene Buchungssätze. Bitte starte die Zuweisung erneut'));
		}

		bs.SomDig_SapDatei__c				= sapDatei.Id;
		update bs;
		
		SomDig_SapDatei.setUploadStatus(sapDatei.Id);
		
		sapDatei	= [SELECT Id, SomDig_Status__c, SomDig_Nummer__c FROM SomDig_SapDatei__c WHERE Id = :sapDatei.Id];
		System.assertEquals('Übermittlung', sapDatei.SomDig_Status__c, 'Status der SAP-Datei ist nicht korrekt');
		System.assertEquals('0001', sapDatei.SomDig_Nummer__c, 'Nummer der SAP-Datei ist nicht korrekt');
	}

	@isTest (seeAllData=false)
	private static void testBuchungssaetzeZuweisenHR() {

		SomDig_SapDatei__c sapDatei			= new SomDig_SapDatei__c();
		sapDatei.SomDig_Buchungskreis__c	= '0029';
		sapDatei.SomDig_Quellsystem__c 		= 'advendio';
		sapDatei.SomDig_Monat__c 			= '04';
		sapDatei.SomDig_Jahr__c				= '2016';
		sapDatei.SomDig_Status__c 			= 'erstellt';
		sapDatei.RecordTypeId 				= [SELECT Id, SobjectType, DeveloperName FROM RecordType WHERE SobjectType='SomDig_SapDatei__c' and DeveloperName='SomDig_Hochrechnung' and IsActive = true limit 1].Id;
		insert sapDatei;
		
		ADvendio__MediaCampaign__c mc1	= cls_P7S1_TestData.createTestMediaCampaign(false);
		ADvendio__MediaCampaign__c mc2	= cls_P7S1_TestData.createTestMediaCampaign(false);
		ADvendio__MediaCampaign__c mc3	= cls_P7S1_TestData.createTestMediaCampaign(false);
		insert new List<ADvendio__MediaCampaign__c>{mc1, mc2, mc3};
		
		ADvendio__Invoice__c inv1		= cls_P7S1_TestData.createTestInvoice(false, mc1);
		ADvendio__Invoice__c inv2		= cls_P7S1_TestData.createTestInvoice(false, mc2);
		ADvendio__Invoice__c inv3		= cls_P7S1_TestData.createTestInvoice(false, mc3);

		List<ADvendio__Invoice__c> invoices	= new List<ADvendio__Invoice__c>{inv1, inv2, inv3};
		insert invoices;

		Id bsHrRtId							= [SELECT Id, SobjectType, DeveloperName FROM RecordType WHERE SobjectType='SomDig_Buchungssatz__c' and DeveloperName='Hochrechnung' and IsActive = true limit 1].Id;
		List<SomDig_Buchungssatz__c> bss	= new List<SomDig_Buchungssatz__c>();
		String groupString	= '000000';
		String itemString	= '000000';

		Integer groupNo	= 0;
		Integer itemNo	= 0;
		
		for (ADvendio__Invoice__c invoice : invoices) {
            Integer recordCount	= 10;
            if (invoice.Id == inv3.Id) {
                recordCount	= 20;
            }
            for (Integer i=1; i<=recordCount; i++) {
				if (Math.mod(i, 2) != 1) {
					groupNo++;//
					groupString	= (groupNo * 1.0).setScale(0).toPlainString().leftPad(6).replace(' ','0');
					itemNo	= 0;
				}
				itemNo++;
				itemString		= (itemNo * 1.0).setScale(0).toPlainString().leftPad(6).replace(' ','0');
				
				SomDig_Buchungssatz__c bs			= new SomDig_Buchungssatz__c();
				bs.SomDig_Rechnung__c				= invoice.Id;
				bs.Name 							= invoice.ADvendio__MediaCampaign__c + '-' + invoice.Id + '-' + 'a1f-'+groupString+'-'+itemString;
				bs.SomDig_VerrechnungsmonatSAP__c	= '1604'; // faked sapDatei.SomDig_Verrechnungsmonat__c
				bs.SomDig_Buchungskreis__c			= sapDatei.SomDig_Buchungskreis__c;
				bs.RecordTypeId						= bsHrRtId;
				bss.add(bs);
			}
		}
		
		insert bss;
		
		Test.startTest();
		SomDig_SapDatei.buchungssaetzeZuweisen(sapDatei.Id);
		Set<String> openJobStatus	= new Set<String>{'Holding','Queued','Preparing','Processing'};
		system.assertEquals(1, [SELECT Id, Status FROM AsyncApexJob WHERE (ApexClass.Name='SomDig_SapDatei' OR ApexClass.Name='SomDig_SapDateiZuweisung') AND Status IN :openJobStatus limit 1].size(), 'Die Zuweisung wurde nicht gestartet');
		Test.stopTest();
		
		bss	= [SELECT Id, Name, SomDig_SapDatei__c, SomDig_Belegnummer__c, SomDig_Rechnung__c FROM SomDig_Buchungssatz__c where Id IN :bss ORDER BY Name];
		system.assertEquals(2*10 + 20, bss.size());

		SomDig_SapDateiZuweisung sapZuweisung	= new SomDig_SapDateiZuweisung();
		sapZuweisung.sapDateiId					= sapDatei.Id;
        sapZuweisung.recordTypeName				= 'Hochrechnung';

        for (SomDig_Buchungssatz__c bs : bss) {
            if (bs.SomDig_Rechnung__c == inv3.Id) { // over-size invoice - no assignments done
                system.assertEquals(null, bs.SomDig_Belegnummer__c);
                system.assertEquals(null, bs.SomDig_SapDatei__c);
            }
            else {
                SomDig_Buchungssatz__c bsReference	= sapZuweisung.setUpBuchungssatz(bs);
                
                system.assertEquals(bsReference.Id, bs.Id);
                system.assertEquals(bsReference.SomDig_Belegnummer__c, bs.SomDig_Belegnummer__c);
                system.assertEquals(bsReference.SomDig_SapDatei__c, bs.SomDig_SapDatei__c);
            }
		}
	}

	@isTest (seeAllData=false)
	private static void testBuchungssaetzeZuweisenFakturaFail() {
		SomDig_SapDatei__c sapDateiHR		= new SomDig_SapDatei__c();
		sapDateiHR.SomDig_Buchungskreis__c	= '0029';
		sapDateiHR.SomDig_Quellsystem__c 	= 'advendio';
		sapDateiHR.SomDig_Monat__c 			= '04';
		sapDateiHR.SomDig_Jahr__c			= '2016';
		sapDateiHR.SomDig_Status__c			= 'erstellt';
		sapDateiHR.RecordTypeId				= [SELECT Id, SobjectType, DeveloperName FROM RecordType WHERE SobjectType='SomDig_SapDatei__c' and DeveloperName='SomDig_Hochrechnung' and IsActive = true limit 1].Id;
		insert sapDateiHR;
		
		SomDig_SapDatei__c sapDatei			= new SomDig_SapDatei__c();
		sapDatei.SomDig_Buchungskreis__c	= '0029';
		sapDatei.SomDig_Quellsystem__c		= 'advendio';
		sapDatei.SomDig_Monat__c 			= '04';
		sapDatei.SomDig_Jahr__c				= '2016';
		sapDatei.SomDig_Status__c			= 'erstellt';
		sapDatei.RecordTypeId				= [SELECT Id, SobjectType, DeveloperName FROM RecordType WHERE SobjectType='SomDig_SapDatei__c' and DeveloperName='SomDig_Faktura' and IsActive = true limit 1].Id;
		insert sapDatei;

		ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true);
		ADvendio__Invoice__c invoice		= cls_P7S1_TestData.createTestInvoice(true, mc);
		
		List<SomDig_Buchungssatz__c> bss	= new List<SomDig_Buchungssatz__c>();
		
		{
			SomDig_Buchungssatz__c bs			= new SomDig_Buchungssatz__c();
			bs.Name 							= invoice.Id;
			bs.SomDig_VerrechnungsmonatSAP__c	= '1604'; // faked sapDatei.SomDig_Verrechnungsmonat__c
			bs.SomDig_Buchungskreis__c			= sapDatei.SomDig_Buchungskreis__c;
			bs.SomDig_SapDatei__c				= sapDatei.Id;
			bs.RecordTypeId						= [SELECT Id, SobjectType, DeveloperName FROM RecordType WHERE SobjectType='SomDig_Buchungssatz__c' and DeveloperName='Faktura' and IsActive = true limit 1].Id;
			bss.add(bs);
		}
		insert bss;
		
		Test.startTest();
		SomDig_SapDatei.buchungssaetzeZuweisen(sapDatei.Id);
		Test.stopTest();
		
		List<FeedItem> errorPosts	= [SELECT Id, Body FROM FeedItem WHERE ParentId = :sapDatei.Id];
		system.assertEquals(1, errorPosts.size());
		system.assert(errorPosts.get(0).Body.contains('Der Upload der Faktura ist derzeit gesperrt! Bitte prüfe die SAP-Datei SAP-Datei-'));
		
		try {
			SomDig_SapDatei.setUploadStatus(sapDatei.Id);
		}
		catch (Exception e) {
			system.debug(e.getMessage());
			system.assert(e.getMessage().contains('Der Upload der Faktura ist derzeit gesperrt! Bitte prüfe die SAP-Datei SAP-Datei-'));
		}
	}

	@isTest (seeAllData=false)
	private static void testBuchungssaetzeZuweisenFaktura() {
		SomDig_SapDatei__c sapDatei			= new SomDig_SapDatei__c();
		sapDatei.SomDig_Buchungskreis__c	= '0029';
		sapDatei.SomDig_Quellsystem__c		= 'advendio';
		sapDatei.SomDig_Monat__c			= '04';
		sapDatei.SomDig_Jahr__c				= '2016';
		sapDatei.SomDig_Status__c			= 'erstellt';
		sapDatei.RecordTypeId				= [SELECT Id, SobjectType, DeveloperName FROM RecordType WHERE SobjectType='SomDig_SapDatei__c' and DeveloperName='SomDig_Faktura' and IsActive = true limit 1].Id;
		insert sapDatei;

		ADvendio__MediaCampaign__c mc		= cls_P7S1_TestData.createTestMediaCampaign(true);
		ADvendio__Invoice__c invoice		= cls_P7S1_TestData.createTestInvoice(true, mc);
		
		List<SomDig_Buchungssatz__c> bss	= new List<SomDig_Buchungssatz__c>();
		
		{
			SomDig_Buchungssatz__c bs			= new SomDig_Buchungssatz__c();
			bs.Name 							= invoice.Id;
			bs.SomDig_VerrechnungsmonatSAP__c	= '1604'; // faked sapDatei.SomDig_Verrechnungsmonat__c
			bs.SomDig_Buchungskreis__c			= sapDatei.SomDig_Buchungskreis__c;
			bs.SomDig_SapDatei__c				= sapDatei.Id;
			bs.RecordTypeId						= [SELECT Id, SobjectType, DeveloperName FROM RecordType WHERE SobjectType='SomDig_Buchungssatz__c' and DeveloperName='Faktura' and IsActive = true limit 1].Id;
			bss.add(bs);
		}
		insert bss;
		
		Test.startTest();
		SomDig_SapDatei.buchungssaetzeZuweisen(sapDatei.Id);
		Test.stopTest();

		bss	= [SELECT Id, SomDig_SapDatei__c, SomDig_Belegnummer__c FROM SomDig_Buchungssatz__c WHERE Id IN :bss ORDER BY Name];
		system.assertEquals(1, bss.size());

		for (SomDig_Buchungssatz__c bs : bss) {
			system.assertEquals(sapDatei.Id, bs.SomDig_SapDatei__c);
		}
	}
}