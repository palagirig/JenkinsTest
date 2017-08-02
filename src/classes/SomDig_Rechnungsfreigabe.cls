global class SomDig_Rechnungsfreigabe implements Database.Batchable<SObject>, Database.Stateful {

	/** sf (url)instance-name used for url in result mails **/
	private String instanceName = null;
	
	/** initial id-set when validation is started **/
	Set<Id> allValidationInvoiceIds {get;set;}
	/** ids of successful validated invoices **/
	Set<Id> successValidationInvoiceIds {get;set;}
	/** ids of not succesful validarted invoices**/
	Set<Id> errorValidationInvoiceIds {get;set;}
	
	/** initial id-set when review is started, most likely contains only successful validated invoices  **/
	Set<Id> allReviewInvoiceIds {get;set;}
	/** ids of successful reviewd invoices **/
	Set<Id> successReviewInvoiceIds {get;set;}
	/** ids of not successful reviewd invoices **/
	Set<Id> errorReviewInvoiceIds {get;set;}
	
	/** batch starting mode - Step 1: invoice-item validation **/
	private Boolean isValidationMode {get;set;}
	/** batch starting mode - Step 2: invoice review **/
	private Boolean isReviewMode {get;set;}

	/** Current / last processed ADvendio__MediaCampaign__c. */
	private ADvendio__MediaCampaign__c currentMediaCampaign = null;
	
	/** Current / last processed ADvendio__Invoice__c. */
	private ADvendio__Invoice__c currentInvoice = null;	
	
	/** result object für html attachment / report **/
	private Map<Id, SomDig_Buchungssatz_EaBatch.CampaignResult> campaignResults	= new Map<Id, SomDig_Buchungssatz_EaBatch.CampaignResult>();
	
	/** button action to start the job 
	*	@param	a list of invoiceIds (as String)
	*	@return	a result message (error or nothing)
	**/
	webservice static String starteRechungsfreigabe(List<String> invoiceIds) {
		if (invoiceIds != null && !invoiceIds.isEmpty()) {
			SomDig_Rechnungsfreigabe b = new SomDig_Rechnungsfreigabe(new Set<Id>((List<Id>)invoiceIds));
			Database.executeBatch(b, 1);
			return '';
		}
		return 'Bitte wähle eine Rechnung aus';
	}
	
	/** constructor
	*	@param	a set of invoice ids to be validated and reviewd
	**/
    public SomDig_Rechnungsfreigabe(Set<Id> invoiceIds) {
		isValidationMode		= true;
		isReviewMode			= !isValidationMode;
		
		this.allValidationInvoiceIds		= invoiceIds;
    	this.successValidationInvoiceIds	= new Set<Id>();
    	this.errorValidationInvoiceIds		= new Set<Id>();
    	this.allReviewInvoiceIds			= new Set<Id>();
    	this.successReviewInvoiceIds		= new Set<Id>();
    	this.errorReviewInvoiceIds			= new Set<Id>();
		
		for (Organization o : [SELECT InstanceName FROM Organization LIMIT 1]) {
			this.instanceName = o.InstanceName;
		}
    }
    
    /**
	 * Batch job start routine.
	 *
	 * @param	bc	Context of the batchable job.
	 */
	global Database.QueryLocator start(Database.BatchableContext bc) {
		String queryStr = '';
		if (isValidationMode) { // do validation
			queryStr = 'SELECT ' + SomDig_Buchungssatz_EaBatch.QUERY_INVOICEITEM_FIELDS + ' FROM ADvendio__InvoiceItem__c';
			queryStr += ' WHERE ADvendio__Invoice__c IN :allValidationInvoiceIds ';
			queryStr += 'ORDER BY ADvendio__Invoice__c';
		}
		else { // set invoice status to "reviewed"
			isReviewMode		= true;
			isValidationMode	= !isReviewMode;
			queryStr = 'SELECT Id, Name, ADvendio__MediaCampaign__c FROM ADvendio__Invoice__c';
			queryStr += ' WHERE Id IN :allReviewInvoiceIds ';
		}

		return Database.getQueryLocator(queryStr);
	}
	
	/**
	 * Batch job execution routine.
	 *
	 * @param	bc		Context of the batchable job.
	 * @param	records	List of sObject to process.
	 */
	global void execute(Database.BatchableContext bc, List<sObject> records) {
		if (isValidationMode) { // do validation
			for (ADvendio__InvoiceItem__c invoiceItem : (List<ADvendio__InvoiceItem__c>)records) {				
				if (currentInvoice != null && currentInvoice.Id == invoiceItem.ADvendio__Invoice__c) {
					// Same ADvendio__Invoice__c
	    		} else {
	    			// Changing ADvendio__Invoice__c
			    	//currentMediaCampaign	= invoiceItem.ADvendio__Invoice__r.ADvendio__MediaCampaign__r;
			    	currentInvoice			= invoiceItem.ADvendio__Invoice__r;
			    	
			    	if (!campaignResults.containsKey(currentInvoice.Id)) {
			    		campaignResults.put(currentInvoice.Id, new SomDig_Buchungssatz_EaBatch.CampaignResult(currentInvoice.Id, currentInvoice.Name, instanceName));
			    		if (currentInvoice.ADvendio__Status__c != 'Draft') { // do not handle already reviewed invoices
			    			campaignResults.get(currentInvoice.Id).addErrorNoSub('Die Rechnung ist bereits freigegeben'.escapeHtml4());
			    			errorValidationInvoiceIds.add(currentInvoice.Id);
			    		}
			    	}
	    		}
	    		
    			if (currentInvoice.ADvendio__Status__c != 'Draft') { // do not handle already reviewed invoices
					continue;
				}
	    		// starting date for unit testing
	    		Date today									= Date.newInstance(System.today().year(), System.today().month(), 15);
				// setup and start validation
				SomDig_Buchungssatz_EaBase eaBase = new SomDig_Buchungssatz_EaBase(new List<ADvendio__InvoiceItem__c>{invoiceItem},
																					SomDig_Buchungssatz_EaBase.PROCESS_ULTIMO_MINUS_5,
																					(system.Test.isRunningTest() ? today : system.today()),
																					true);
				
	
				eaBase.runProcess();
	
				// eveluate validation
				for (SomDig_Buchungssatz_EaBase.RevenueDistributionResult rdr : eaBase.RevenueDistributionResults) {
					
					if (rdr.messages.isEmpty()) {
						campaignResults.get(currentInvoice.Id).addOK(invoiceItem.Id, invoiceItem.Name, '');
					}
					
					for (SomDig_Buchungssatz_EaBase.ProcessMessage msg : rdr.messages) {
						
						// ok marker
						if (msg.severity == ApexPages.Severity.INFO) {
							campaignResults.get(currentInvoice.Id).addWarning(invoiceItem.Id, invoiceItem.Name, '', msg.message.escapeHtml4());
						}
						
						// error marker
						if (msg.severity == ApexPages.Severity.FATAL || msg.severity == ApexPages.Severity.ERROR || msg.severity == ApexPages.Severity.WARNING) {
							errorValidationInvoiceIds.add(currentInvoice.Id); // don't accept faulty invoices
	
							if ('IA'.equals(msg.messageType)) {
								campaignResults.get(currentInvoice.Id).addIAWarning(invoiceItem.Id, invoiceItem.Name, '', msg.message.escapeHtml4());
							}
							else if (msg.severity == ApexPages.Severity.FATAL || msg.severity == ApexPages.Severity.ERROR || msg.severity == ApexPages.Severity.WARNING) {
								campaignResults.get(currentInvoice.Id).addError(invoiceItem.Id, invoiceItem.Name, '', msg.message.escapeHtml4());
							}
						}
					}
				}
		   	}
		}
		else { // set invoice status to "reviewed"
			Map<Id, ADvendio__Invoice__c> invoiceById	= new Map<Id, ADvendio__Invoice__c>();
			for (ADvendio__Invoice__c invoice : (List<ADvendio__Invoice__c>)records) {
				invoice.SomDig_Rechnungsfreigabe__c	= true;
			}
			
			List<Database.SaveResult> results	= Database.update(records, false);
			for (Integer i=0; i<results.size(); i++) {
				
				ADvendio__Invoice__c tmpInvoice	= (ADvendio__Invoice__c) records.get(i);
				
				if (results.get(i).isSuccess()) {
					successReviewInvoiceIds.add(tmpInvoice.Id);
				}
				else {
					String message	= '';
					for (Database.Error error : results.get(i).getErrors()) {
						message += error.getMessage();
						break;
					}

					errorReviewInvoiceIds.add(tmpInvoice.Id);
					campaignResults.get(tmpInvoice.Id).addErrorNoSub(message.escapeHtml4());
				}
			}
		}
    }
    
	/**
	 * Batch job completion routine.
	 *
	 * @param	bc	Context of the batchable job.
	 */
	global void finish(Database.BatchableContext bc){
		
		if (isValidationMode) { // prepare 2nd run
			successValidationInvoiceIds	= allValidationInvoiceIds.clone();
			successValidationInvoiceIds.removeAll(errorValidationInvoiceIds);
			
			if (successValidationInvoiceIds.size() > 0) {
				isValidationMode	= false;
				allReviewInvoiceIds	= successValidationInvoiceIds.clone();
				Database.executeBatch(this, 10);
			}
		}
		
		if ((isValidationMode && successValidationInvoiceIds.size() == 0) || 
			(isReviewMode)
		) {		
			if (isValidationMode) {
				successReviewInvoiceIds	= successValidationInvoiceIds;
				errorReviewInvoiceIds	= errorValidationInvoiceIds;
			}
			else {
				if (errorReviewInvoiceIds.size() > 0) {
					errorReviewInvoiceIds.addAll(errorValidationInvoiceIds);
				}
			}

    		AsyncApexJob job = (bc == null ? null : [SELECT Id, CreatedBy.Email, CreatedBy.FirstName FROM AsyncApexJob WHERE Id = :bc.getJobId()]);

	    	// Send mail
	    	if (job != null || System.Test.isRunningTest()) {
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		
	            String emailAddress	= System.Test.isRunningTest() ? 'support@advendio.com' : job.CreatedBy.Email;
	            String firstName	= System.Test.isRunningTest() ? 'ADvendio' : job.CreatedBy.FirstName;
		
				String[] toAddresses = new String[] { emailAddress };
				mail.setToAddresses(toAddresses);
				mail.setSubject('Rechnungsfreigabe beendet');
				
		        String htmlbody = '<html>\n'
		                        + '<head>\n'
		                        + '<style type="text/css">\n'
		                        + '<!--\n'
		                        + '  body    { font-family:Verdana; font-size:12px; }\n'
		                        + '  table   { font-size:12px; border-width:1px; border-spacing:2px; border-style:solid; border-color:gray; border-collapse:collapse; }\n'
		                        + '  caption { font-size:14px; font-weight:bold; white-space:nowrap; }\n'
		                        + '  th      { font-size:12px; font-weight:bold; border-width:1px; border-style:solid; border-color:gray; padding:4px; white-space:nowrap; }\n'
		                        + '  td      { font-size:12px; border-width:1px; border-style:solid; border-color:gray; padding:4px; white-space:nowrap; }\n'
		                        + '-->\n'
		                        + '</style>\n'
		                        + '</head>\n'
		                        + '<body>\n';
				
				htmlbody += 'Hallo ' + firstName + ',\n<br/><br/>';
				htmlbody += 'die von dir gestartete Rechnungsfreigabe ist jetzt beendet. Im Folgenden findest Du die Informationen zum Ergebnis.\n';
				
				htmlbody += '<p>\n<b>Statistiken</b>\n<table style=\'border-width:0px;\'>';
				htmlbody += '<tr><td style=\'text-align:left; border-width:0px;\'>Anzahl der geprüften Rechnungen :</td><td style=\'border-width:0px;\'>' + allValidationInvoiceIds.size() + '</td></tr>';
				htmlbody += '<tr><td style=\'text-align:left; border-width:0px;\'>Anzahl der freigegebenen Rechnungen:</td><td style=\'border-width:0px;\'>' + successReviewInvoiceIds.size() + '</td></tr>';
				htmlbody += '<tr><td style=\'text-align:left; border-width:0px;\'>Anzahl der nicht freigegebenen Rechnungen:</td><td style=\'border-width:0px;\'>' + errorReviewInvoiceIds.size() + '</td></tr>';
				htmlbody += '</table>\n</p>\n';
				
				Messaging.EmailFileAttachment att	= new Messaging.EmailFileAttachment();
				att.setBody(Blob.valueOf(SomDig_Buchungssatz_EaBatch.createHtmlResult(campaignResults, 'Rechnungen')));
				att.setContentType('text/html');
				att.setFileName('result.html');
				mail.setFileAttachments(new List<Messaging.EmailFileAttachment>{att});
				
				if (errorReviewInvoiceIds.size() > 0) {
					htmlbody += '<br/>Prüfe und behebe die Fehler, starte dann die Freigabe erneut.';
				}
				
				htmlbody += '<p>\nViele Grüße\n<br/>Dein SF-Admin</p>';
				
				mail.setHtmlBody(htmlbody);
		
	            if (!System.Test.isRunningTest()) {
					Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	    		}
	    	}
		}
	}
}