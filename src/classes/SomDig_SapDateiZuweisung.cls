global with sharing class SomDig_SapDateiZuweisung implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
	
	public Map<String, SomDig_Buchungssatz__c> bsByName	= null;
	/** A count for counting number of batches processed. */
	private	Integer totalBatchs							= 0;

	/** A count for counting number of records (SomDig_Buchungssatz__c) processed. */
	private	Integer totalRecords						= 0;
	
	/** The current instance name. */
	private String instanceName							= null;
	
	/** The record type name of the current SomDig_SapDatei__c record. */
	public String recordTypeName						= null;
	
	/** The current max. group number. */
	public Integer currentMaxGroupNumber				= 0;
	
	/** The current gropu name. */
	private String currentGroupName						= null;

	/** ID of SomDig_SapDatei__c record, to which the SomDig_Buchungssatz__c records are to assign. */
	public Id sapDateiId { get; set; }
	
	/** calling SomDig_SapDatei class instance - for recalling*/
	public SomDig_SapDatei sapDatei { get;set; }

	/**
	 * Constructor.
	 */
	public SomDig_SapDateiZuweisung() {
		bsByName	= new Map<String, SomDig_Buchungssatz__c>();
		for (Organization o : [SELECT InstanceName FROM Organization LIMIT 1]) {
			this.instanceName = o.InstanceName;
		}
	}

	@TestVisible
	private SomDig_Buchungssatz__c setUpBuchungssatz(SomDig_Buchungssatz__c buchungssatz) {
		buchungssatz.SomDig_SapDatei__c	= sapDateiId;
		if ('Hochrechnung'.equals(recordTypeName) || 'Erloesaufteilung'.equals(recordTypeName)) {
			// The name consists of: MediaCampaignId + '-' + InvoiceId + '-' + InvoiceItemId + '-' + GroupId + '-' MemberId
			// Refer SomDig_Buchungssatz_EaBatch for details!
			String[] token	= buchungssatz.Name.split('-');
			String grpName	= token[0] + '-' + token[1] + '-' + token[2] + '-' + token[3];

            if (currentGroupName == null || currentGroupName.equals(grpName) == false) {
				currentGroupName	= grpName;
				currentMaxGroupNumber++;
			}
			buchungssatz.SomDig_Belegnummer__c	= String.valueOf(currentMaxGroupNumber).leftPad(10).replace(' ','0');
			
			return new SomDig_Buchungssatz__c(Id=buchungssatz.Id, SomDig_SapDatei__c=buchungssatz.SomDig_SapDatei__c, SomDig_Belegnummer__c=buchungssatz.SomDig_Belegnummer__c);
		}
		else { // only for FAKTURA - don't calc Ba Belegnummer
			return new SomDig_Buchungssatz__c(Id=buchungssatz.Id, SomDig_SapDatei__c=buchungssatz.SomDig_SapDatei__c);
		}
	}

	/**
	 * Batch job start routine.
	 *
	 * @param	bc	Context of the batchable job.
	 */
	global List<SomDig_Buchungssatz__c> start(Database.BatchableContext bc) {
		List<SomDig_Buchungssatz__c> bsList	= new List<SomDig_Buchungssatz__c>();
		List<String> bsNames				= new List<String>();
		if (bsByName != null) {
			for (String bsName : bsByName.keySet()) {
				bsNames.add(bsName);
			}
			
			bsNames.sort();
			
			for (String bsName : bsNames) {
				bsList.add(bsByName.get(bsName));
			}
			
		}
		return bsList;
	}

	/**
	 * Batch job execution routine.
	 *
	 * It sums revenues of opportunities of accounts.
	 *
	 * @param	bc		Context of the batchable job.
	 * @param	scope	List of sObject to process.
	 */
	global void execute(Database.BatchableContext bc, List<sObject> scope){
		totalBatchs++;
		totalRecords += scope.size();
		List<SomDig_Buchungssatz__c> bsListToUpdate	= new List<SomDig_Buchungssatz__c>();

		for (SomDig_Buchungssatz__c buchungssatz : (List<SomDig_Buchungssatz__c>)scope) {
			bsListToUpdate.add(setUpBuchungssatz(buchungssatz));
		}
		
		update bsListToUpdate;
	}

	/**
	 * Batch job completion routine.
	 *
	 * @param	bc	Context of the batchable job.
	 */
	global void finish(Database.BatchableContext bc){
		
		if (!sapDatei.invoiceBsRecordCount.isEmpty()) { // assignment not jet done
			Database.executeBatch(sapDatei);
		}
		else { // assignment done completely
			AsyncApexJob job = (bc == null ? null : [SELECT Id, CreatedBy.Email, CreatedBy.FirstName FROM AsyncApexJob WHERE Id = :bc.getJobId()]);
	
			String uploadMessage	= '';
			Boolean sapUpload		= false;
			if ('Faktura'.equals(recordTypeName)) {
				sapUpload		= true;
				try {
					String user			= '';
					String pass			= '';
					String token		= '';
					String reportId		= '00O57000006opug';
					
					String fileNumber	= SomDig_SapDatei.setUploadStatus(sapDateiId, false);
					
					for (ADvendio__Delivery_Report_Setting__c loginData	: [SELECT Id, ADvendio__Username__c, ADvendio__Token__c, ADvendio__Password__c FROM ADvendio__Delivery_Report_Setting__c LIMIT 1]) {
						user	= loginData.ADvendio__Username__c;
						pass	= loginData.ADvendio__Password__c;
						token	= loginData.ADvendio__Token__c;
					}
					
					SomDig_PartnerWSDL.Soap soap				= new SomDig_PartnerWSDL.Soap();
					SomDig_PartnerWSDL.LoginResult loginResult	= soap.login(user, pass+''+token);
					
					String sessionId	= EncodingUtil.urlEncode(loginResult.sessionId, 'UTF-8');
					String serverURL	= EncodingUtil.urlEncode(loginResult.serverUrl, 'UTF-8');
	
					String serviceUrl	= System.Label.SAP_Upload_URL +'?sessionid='+sessionId+'&endpoint='+serverURL+'&reportid=' + reportId + '&sapdateirecordid='+sapDateiId+'&filenumber='+fileNumber;
	
					Http http			= new Http();
					HttpRequest request	= new HttpRequest();
					request.setMethod('GET');
					request.setEndpoint(serviceUrl);
					request.setTimeout(30000);
					http.send(request);
				}
				catch (Exception e) {
					uploadMessage	= e.getMessage();
				}
			}
			
			// Send mail
			if (job != null || System.Test.isRunningTest()) {
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		
				String emailAddress	= System.Test.isRunningTest() ? 'support@advendio.com' : job.CreatedBy.Email;
				String firstName	= System.Test.isRunningTest() ? 'ADvendio' : job.CreatedBy.FirstName;
		
				String[] toAddresses = new String[] { emailAddress };
				mail.setToAddresses(toAddresses);
	
				if (!sapUpload) {
					mail.setSubject('Prozess "Buchungssätze Zuweisung" ist beendet');
				}
				else {
					mail.setSubject('Prozess "Buchungssätze Zuweisung" und "SAP-Upload" ist beendet'); 
				}
				
				String htmlbody = '<html>\n'
								+ '<head>\n'
								+ '<style type="text/css">\n'
								+ '<!--\n'
								+ '  body	{ font-family:Verdana; font-size:12px; }\n'
								+ '  table   { font-size:12px; border-width:1px; border-spacing:2px; border-style:solid; border-color:gray; border-collapse:collapse; }\n'
								+ '  caption { font-size:14px; font-weight:bold; white-space:nowrap; }\n'
								+ '  th	  { font-size:12px; font-weight:bold; border-width:1px; border-style:solid; border-color:gray; padding:4px; white-space:nowrap; }\n'
								+ '  td	  { font-size:12px; border-width:1px; border-style:solid; border-color:gray; padding:4px; white-space:nowrap; }\n'
								+ '-->\n'
								+ '</style>\n'
								+ '</head>\n'
								+ '<body>\n';
				
				htmlbody += 'Hallo ' + firstName + ',\n<br/><br/>';
				htmlbody += 'der von Dir gestartete Prozess "Buchungssätze Zuweisung" ist jetzt beendet. Im Folgenden findest Du die Informationen zum Prozessergebnis und das weitere Vorgehen.\n';
				
				htmlbody += '<p>\n<b>Statistiken</b>\n<table style=\'border-width:0px;\'>';
				htmlbody += '<tr><td style=\'text-align:left; border-width:0px;\'>Anzahl der bearbeiteten Buchnungssätzen:</td><td style=\'border-width:0px;\'>' + totalRecords + '</td></tr>';
				htmlbody += '</table>\n</p>\n';
				
				if (totalRecords > 0 && sapDateiId != null) {	
					htmlbody += '<p>\n<b>Weiteres Vorgehen</b>\n<ul>\n';
					if (!sapUpload) {
						htmlbody += '<li>Gehe zu <a href="https://' + instanceName + '.salesforce.com/' + sapDateiId + '">' + 'SAP-Datei</a>, starte den Uploadprozess durch Klicken den Button "SAP Datei Upload".</li>';
					}
					else {
						if (uploadMessage == '') {
							htmlbody += '<li>Gehe zu <a href="https://' + instanceName + '.salesforce.com/' + sapDateiId + '">' + 'SAP-Datei</a>, und prüfe den Status und ggf. vorhandene Fehlermeldungen.</li>';
						}
						else {
							htmlbody += '<li>Die SAP Datei konnte nicht an SAP übergeben werden: ' + uploadMessage + '</li>';
		
						}
					}
					htmlbody += '</ul>\n</p>\n';
				}
	
				htmlbody += '<p>\nViel Grüße\n<br/>Dein SF-Admin</p>';
				
				mail.setHtmlBody(htmlbody);
				if (!System.Test.isRunningTest()) {
					Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
				}
			}
		}
	}
}