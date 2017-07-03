/**
 * Klasse um Buchungssätze einer SAP-Datei zuzuordnen. (Als Batch-Job)
 */
global with sharing class SomDig_SapDatei implements Database.Batchable<sObject>, Database.Stateful, Schedulable{
	/** An exception class. */
	public class sapDateiUploadException extends Exception {}
	
	/** The record type name of the current SomDig_SapDatei__c record. */
	private String recordTypeName					= null;

	/** all invoice-ids of found SomDig_Buchungssatz__c records (counted/invoice as value)  */
	public Map<Id, Integer> invoiceBsRecordCount	= null;

	/** oversize-invoice (too many SomDig_Buchungssatz__c records), these never get assigned*/
	private Set<Id> skippedInvoices					= null;

	/** ID of SomDig_SapDatei__c record, to which the SomDig_Buchungssatz__c records are to assign. */
	public Id sapDateiId { public get; public set; }
	
	/** job doing the sorting and assignmet of SomDig_Buchungssatz__c records **/
	private SomDig_SapDateiZuweisung zuweisungJob	= null;
	
	/** no more the this SomDig_Buchungssatz__c records cann be assigned at once **/
	private static Integer MAX_COUNT_BS				= 40000;
	
	/** batch process controller - started first time in this context **/
	private Boolean contextFirstRun						= true;
	
	/** batch process controller - no more records to process in this context **/
	private Boolean contextNoRecords					= false;
	
	/** batch process controller - this context's process ended with an error**/
	private Boolean contextIsError						= false;
	
	
	private String nullQuery	= '';
	private String queryStr		= '';
	
	
	public SomDig_SapDatei () {
		skippedInvoices	= new Set<Id>();
	}
	
	/**
	 * A webservice to start the batch job for assigning SomDig_Buchungssatz__c records to a SomDig_SapDatei__c.
	 *
	 * @param sapDateiId Id of the SomDig_SapDatei__c being assigned.
	 */
	webservice static void buchungssaetzeZuweisen(Id sapDateiId) {
		Set<String> openJobStatus	= new Set<String>{'Holding','Queued','Preparing','Processing'};
		List<AsyncApexJob> jobs = [SELECT Id, Status FROM AsyncApexJob WHERE (ApexClass.Name='SomDig_SapDatei' OR ApexClass.Name='SomDig_SapDateiZuweisung') AND Status IN :openJobStatus limit 1];
		if (jobs==null || jobs.size() == 0) {
			SomDig_SapDatei sapDateiClass = new SomDig_SapDatei();
			sapDateiClass.sapDateiId = sapDateiId;
			Database.executeBatch(sapDateiClass);
		}
		else {
			throw new sapDateiUploadException('Start der Zuweisung nicht möglich! Eine Zuweisung von Buchungssätzen ist bereits in Gange.');
		}
	}

	/**
	 * A webservice to set the status of given SomDig_SapDatei__c to 'Übermittlung'.
	 *
	 * @param sapDateiId Id of the SomDig_SapDatei__c to use.
	 */
	webservice static void setUploadStatus(Id sapDateiId) {
		setUploadStatus(sapDateiId, true);
	}
	
	/**
	 * set the status of given SomDig_SapDatei__c to 'Übermittlung'.
	 * @param Id		Id of the SomDig_SapDatei__c to use.
	 * @param Boolean	update the SomDig_SapDatei__c record? (or just pass the the correct SomDig_Nummer__c)
	 * @return String	first usable (unused so far) file number
	 */
	public static String setUploadStatus(Id sapDateiId, Boolean doUpdate) {
		SomDig_SapDatei__c datei	= null;

		for (SomDig_SapDatei__c rec : [SELECT Id, SomDig_Verrechnungsmonat__c, SomDig_Status__c, SomDig_Jahr__c, SomDig_Buchungskreis__c, RecordType.DeveloperName FROM SomDig_SapDatei__c WHERE id = :sapDateiId]) {
			datei	= rec;
		}
		
		if (datei == null) {
			throw new sapDateiUploadException('Keine SAP-Datei mit der ID ' + sapDateiId + ' gefunden.');
		}
		if ('Übermittlung'.equalsIgnoreCase(datei.SomDig_Status__c)) {
			throw new sapDateiUploadException('Die SAP-Datei wird bereits übertragen!');
		}
		if ('übermittelt'.equalsIgnoreCase(datei.SomDig_Status__c)) {
			throw new sapDateiUploadException('Die SAP-Datei wurde bereits übertragen und kann nicht erneut übertragen werden!');
		}
		
		String recordTypeName	= '';
		if ('SomDig_Faktura'.equals(datei.RecordType.DeveloperName)) {
			handleFakturaSperre(sapDateiId, true);
			recordTypeName			= 'Faktura';
		}
		else if ('SomDig_Hochrechnung'.equals(datei.RecordType.DeveloperName)) {
			recordTypeName			= 'Hochrechnung';
		} else if ('SomDig_Erloesaufteilung'.equals(datei.RecordType.DeveloperName)) {
			recordTypeName			= 'Erloesaufteilung';
		}
		
		String verrechnungsmonat	= datei.SomDig_Verrechnungsmonat__c;
		String buchungskreis		= datei.SomDig_Buchungskreis__c;
		
		try {
			SomDig_Buchungssatz__c dummy	= [SELECT Id FROM SomDig_Buchungssatz__c WHERE SomDig_SapDatei__c = NULL
																						AND SomDig_VerrechnungsmonatSAP__c = :verrechnungsmonat
																						AND SomDig_Buchungskreis__c = :buchungskreis
																						AND RecordType.DeveloperName = :recordTypeName
																						LIMIT 1];
			if (dummy != null) {
				throw new sapDateiUploadException('Es existieren nicht-zugewiesene Buchungssätze. Bitte starte die Zuweisung erneut');
			}
		}
		catch (QueryException e){
			// keine nicht-zugewiesenen Buchungssätze gefunden
		}

		Integer maxNummer	= 0;
		for (SomDig_SapDatei__c maxNummerDatei : [SELECT Id, SomDig_Nummer__c FROM SomDig_SapDatei__c
												  WHERE SomDig_Nummer__c != NULL
														AND SomDig_Buchungskreis__c = :datei.SomDig_Buchungskreis__c
														AND SomDig_Jahr__c = :datei.SomDig_Jahr__c
												  ORDER BY SomDig_Nummer__c DESC
												  LIMIT 1])
		{
			maxNummer		= Integer.valueOf(maxNummerDatei.SomDig_Nummer__c);
		}
		maxNummer++;

		
		datei.SomDig_Status__c	= 'Übermittlung';
		datei.SomDig_Nummer__c	= String.valueOf(maxNummer).leftPad(4).replace(' ','0');
		
		if (doUpdate) {
			update datei;
		}
		
		return datei.SomDig_Nummer__c;
	}

	/**
	* create a chatter message
	* @param	Id		SomDig_SapDatei__c records ID to check
	* @param	Boolean	throw an error? (or just put a chatter message)
	* @return	Boolean	is blocking existing?
	**/
	private static Boolean handleFakturaSperre(Id sapDateiId, Boolean throwError) {
		SomDig_SapDatei__c hrSapDatei	= getExistingHochrechnung();
		if (hrSapDatei != null) { // Abbruch der Zuweisung wenn eine Fakturasperre existiert
			createChatterMessage(sapDateiId, hrSapDatei, 'Der Upload der Faktura ist derzeit gesperrt! Bitte prüfe die SAP-Datei ' + hrSapDatei.Name);
			if (throwError) {
				throw new sapDateiUploadException('Der Upload der Faktura ist derzeit gesperrt! Bitte prüfe die SAP-Datei ' + hrSapDatei.Name);
			}
			return false;
		}
		return true;
	}

	/**
	* create a chatter message
	* @param	Id					SomDig_SapDatei__c records ID to put the post in
	* @param	SomDig_SapDatei__c	SomDig_SapDatei__c record blocking the current upload
	* @param	String				message for the post
	**/
	private static void createChatterMessage(Id parentId, SomDig_SapDatei__c sapDatei, String message) {
		FeedItem post		= new FeedItem();
		post.ParentId		= parentId;
		post.Body			= message;
		post.LinkURL		= '/' + sapDatei.Id;
		post.Title			= sapDatei.Name;
		insert post;
	}
	
	/**
	* find SomDig_SapDatei__c records blocking Accounting upload (Faktura-Sperre)
	* @return	blocking SomDig_SapDatei__c record or null if none exist
	**/
	private static SomDig_SapDatei__c getExistingHochrechnung() {
		for (SomDig_SapDatei__c hrSapDatei	: [SELECT Id, Name, Somdig_Fakturasperre__c FROM SomDig_SapDatei__c WHERE Somdig_Fakturasperre__c = true]) {
			return hrSapDatei;
		}
		return null;
	}

	/**
	 * Batch job start routine.
	 *
	 * @param	bc	Context of the batchable job.
	 */
	global Database.querylocator start(Database.BatchableContext bc) {

		
		queryStr	= 'SELECT Id, Name, SomDig_Rechnung__c FROM SomDig_Buchungssatz__c WHERE SomDig_SapDatei__c = NULL ';
		nullQuery	= 'SELECT Id, Name, SomDig_Rechnung__c FROM SomDig_Buchungssatz__c WHERE NAME = NULL ';

		if (sapDateiId != null) {
			
			SomDig_SapDatei__c sapDatei	= null;
			
			for (SomDig_SapDatei__c rec :  [SELECT Id, SomDig_Verrechnungsmonat__c, SomDig_Buchungskreis__c, RecordType.DeveloperName
											FROM SomDig_SapDatei__c
											WHERE Id = :sapDateiId]) {
				sapDatei	= rec;
			}
			
			if (sapDatei == null) {
				contextIsError	= true;
				return Database.getQueryLocator(nullQuery);
			}
			
			// set up query filter
			String verrechnungsmonat	= sapDatei.SomDig_Verrechnungsmonat__c;
			String buchungskreis		= sapDatei.SomDig_Buchungskreis__c;
			if ('SomDig_Faktura'.equals(sapDatei.RecordType.DeveloperName)) {
				if (!handleFakturaSperre(sapDatei.Id, false)) {
					contextIsError	= true;
					return Database.getQueryLocator(nullQuery);
				}
				
				recordTypeName			= 'Faktura';
			} else if ('SomDig_Hochrechnung'.equals(sapDatei.RecordType.DeveloperName)) {
				recordTypeName			= 'Hochrechnung';
			} else if ('SomDig_Erloesaufteilung'.equals(sapDatei.RecordType.DeveloperName)) {
				recordTypeName			= 'Erloesaufteilung';
			}

			zuweisungJob				= new SomDig_SapDateiZuweisung();
			zuweisungJob.sapDateiId		= sapDateiId;
			zuweisungJob.recordTypeName	= recordTypeName;
			
			// Get the current max. group number
			if ('Hochrechnung'.equals(recordTypeName) || 'Erloesaufteilung'.equals(recordTypeName)) {
				for (SomDig_Buchungssatz__c rec :  [SELECT Id, SomDig_Belegnummer__c
													FROM SomDig_Buchungssatz__c
													WHERE SomDig_SapDatei__c = :sapDateiId AND
														  SomDig_Belegnummer__c != null AND
														  SomDig_VerrechnungsmonatSAP__c = :verrechnungsmonat AND
														  SomDig_Buchungskreis__c = :buchungskreis AND
														  RecordType.DeveloperName = :recordTypeName
													ORDER BY SomDig_Belegnummer__c DESC
													LIMIT 1])
				{
					zuweisungJob.currentMaxGroupNumber	= Integer.valueOf(rec.SomDig_Belegnummer__c);
				}				
			}

			// basic query
			queryStr	+=	' AND SomDig_VerrechnungsmonatSAP__c = :verrechnungsmonat'
						+ 	' AND SomDig_Buchungskreis__c = :buchungskreis'
						+ 	' AND RecordType.DeveloperName = :recordTypeName';
							
			if (invoiceBsRecordCount != null) {
				Set<Id> invoiceIds	= new Set<Id>(); // find SomDig_Buchungssatz__c records for these invoices
				Integer bsCount		= 0;

				Integer bsMaxCount	= MAX_COUNT_BS; 
				if (Test.isRunningTest()) {
					bsMaxCount	= 15; 
				}
				
				for (Id invoiceId : invoiceBsRecordCount.keySet()) {
					if (bsCount + invoiceBsRecordCount.get(invoiceId) > bsMaxCount) { // check if the working set get too large (count SomDig_Buchungssatz__c records)
						if (invoiceBsRecordCount.get(invoiceId) > bsMaxCount) { // identify oversize-invoices
							skippedInvoices.add(invoiceId);
						}
					}
					else {
						bsCount	+= invoiceBsRecordCount.get(invoiceId); // update record-count
						invoiceIds.add(invoiceId);
					}
				}
				
				for (Id invoiceId : invoiceIds) { // remove done invoices
					invoiceBsRecordCount.remove(invoiceId);
				}
				
				for (Id invoiceId : skippedInvoices) { // do not handle oversize-invoices
					invoiceBsRecordCount.remove(invoiceId);
				}
				
				if (!invoiceIds.isEmpty()) {
					queryStr	+= ' AND SomDig_Rechnung__c IN :invoiceIds'; // invoice filter
				}
				else { // no (usable) records left
					contextNoRecords	= true;
					queryStr			= nullQuery;
				}
			}
			else { // when called first time, don't sort and assign, list invoices instead
				zuweisungJob	= null;
			}

			queryStr	+= ' ORDER BY Name';
		} else {
			
			contextIsError	= true;
			queryStr		= nullQuery; // somethings wrong, find a way out
		}
		
		return Database.getQueryLocator(queryStr);
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
		
		if (contextFirstRun) {
			if (invoiceBsRecordCount == null) { // set up invoice list
				invoiceBsRecordCount	= new Map<Id, Integer>();
			}
			for (SomDig_Buchungssatz__c buchungssatz : (List<SomDig_Buchungssatz__c>)scope) {
				if (!invoiceBsRecordCount.containsKey(buchungssatz.SomDig_Rechnung__c)) {
					invoiceBsRecordCount.put(buchungssatz.SomDig_Rechnung__c, 0);
				}
				invoiceBsRecordCount.put(buchungssatz.SomDig_Rechnung__c, invoiceBsRecordCount.get(buchungssatz.SomDig_Rechnung__c) +1);
			}
		}
		else { // set up Buchungssatz list to be sortet and assigned (see SomDig_SapDateiZuweisung)
			for (SomDig_Buchungssatz__c buchungssatz : (List<SomDig_Buchungssatz__c>)scope) {
				zuweisungJob.bsByName.put(buchungssatz.Name, buchungssatz);
			}
			
			zuweisungJob.sapDatei	= this;
		}
	}

	/**
	 * Batch job completion routine.
	 *
	 * @param	bc	Context of the batchable job.
	 */
	global void finish(Database.BatchableContext bc){
		
		if (!contextNoRecords && !contextIsError) {
			if (contextFirstRun && zuweisungJob == null) { // first start, just set up invoice list
				contextFirstRun	= false; // make sure you never start an infinite (hard to kill) loop
				Database.executeBatch(this);
			}
			else if (!contextFirstRun && zuweisungJob != null){ // second start, assign records - after that, recall this class again
				system.debug(zuweisungJob);
				Database.executeBatch(zuweisungJob);
			}
		}
	}

	/**
	 * Schedule job execution routine.
	 *
	 * @param	sc		Context of the Scheduleable job.
	 */
	public void execute(SchedulableContext sc) {
		Database.executeBatch(this);
	}
}