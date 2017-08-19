/**
 * A batchable class to create Buchungssätze (SomDig_Buchungssatz__c) for Revenue Distribution & Projection.
 *
 * ATTENTION:
 * Never start this batch job manuelly!!!
 * It should be started only from SomDig_Buchungssatz_EaStart due to additional checks done / required there!!!
 */
global with sharing class SomDig_Buchungssatz_EaBatch implements Database.Batchable<SObject>, Database.Stateful {
	/** Process type: Ultimo-5 */
	public static final String PROCESS_ULTIMO_MINUS_5 = SomDig_Buchungssatz_EaBase.PROCESS_ULTIMO_MINUS_5;
	
	/** Process type: Ultimo+4 */
	public static final String PROCESS_ULTIMO_PLUS_4 = SomDig_Buchungssatz_EaBase.PROCESS_ULTIMO_PLUS_4;
	
	/** Fields of ADvendio__InvoiceItem__c used for query. */
	public static final String QUERY_INVOICEITEM_FIELDS = 
		'Id, ' +
		'Name, ' +
		'ADvendio__InvoicedAmountNet2__c, ' +
		'ADvendio__InvoiceItemStartDate__c, ' +
		'ADvendio__InvoiceItemEndDate__c, ' +
		'ADvendio__FromDate__c, ' +
		'ADvendio__UntilDate__c, ' +
		'CreatedDate, ' +
		'ADvendio__InvoicedQuantityMultiplier__c, ' +
		'ADvendio__ConnectedItem__c, ' +
		'ADvendio__CampaignItem__c, ' +
		'ADvendio__CampaignItem__r.Id, ' +
		'ADvendio__CampaignItem__r.ADvendio__ConnectedItem__c, ' +
		'ADvendio__CampaignItem__r.ADvendio__ConnectedItem__r.Id, ' +
		'ADvendio__CampaignItem__r.ADvendio__ConnectedItem__r.CreatedDate, ' +
		'ADvendio__Invoice__c, ' +
		'ADvendio__Invoice__r.Name, ' +
		'ADvendio__Invoice__r.CurrencyIsoCode, ' +
		'ADvendio__Invoice__r.SomDig_RG_Empfaenger_P7S1_Konzernmitgl__c, ' +
		'ADvendio__Invoice__r.ADvendio__OrderNumber__c, ' +
		'ADvendio__Invoice__r.ADvendio__Status__c, ' +
		'ADvendio__Invoice__r.ADvendio__AccountingDate__c, ' +
		'ADvendio__Invoice__r.ADvendio__AccountingEndDate__c, ' +
		'ADvendio__Invoice__r.ADvendio__InvoiceDate__c, ' +
		'ADvendio__Invoice__r.ADvendio__InvoicedAmountGrossN2__c, ' +
		'ADvendio__Invoice__r.ADvendio__PaymentInterval__c, ' +
		'ADvendio__Invoice__r.ADvendio__PaymentStart__c, ' +
		'ADvendio__Invoice__r.SomDig_Auftragstyp__c, ' +
		'ADvendio__Invoice__r.SomDig_Anzahl_Media_Positionen__c, '+
		'ADvendio__Invoice__r.SomDig_Anzahl_Nonmedia_Positionen__c, ' +
		'ADvendio__Invoice__r.SomDig_Steuerkennzeichen__c, ' +
		'ADvendio__Invoice__r.SomDig_PartnerId__c, ' +
		'ADvendio__Invoice__r.ADvendio__Invoice__c, ' +
		'ADvendio__Invoice__r.ADvendio__MediaCampaign__c, ' +
		'ADvendio__Invoice__r.ADvendio__MediaCampaign__r.Name, ' +
		'ADvendio__Invoice__r.ADvendio__MediaCampaign__r.ADvendio__Account__c, ' +
		'ADvendio__Invoice__r.ADvendio__MediaCampaign__r.ADvendio__Account__r.Name, ' +
		'ADvendio__Invoice__r.ADvendio__MediaCampaign__r.ADvendio__Agency__c, ' +
		'ADvendio__Invoice__r.ADvendio__MediaCampaign__r.ADvendio__Agency__r.Name, ' +
		'ADvendio__Invoice__r.ADvendio__MediaCampaign__r.ADvendio__Campaign_Start_Date__c, ' +
		'ADvendio__Invoice__r.ADvendio__MediaCampaign__r.ADvendio__Campaign_End_Date__c ';
		
	/** Batch size. */
	private Integer	batchSize 		= 1;
	
	/** Ids of ADvendio__InvoiceItem__c to force to check. */
	private Set<Id>	invoiceItemIds 	= null;

	/** A count for counting number of batches processed. */
	private	Integer totalBatchs		= 0;

	/** A count for counting number of records (ADvendio__InvoiceItem__c) processed. */
	private	Integer totalRecords	= 0;
	
	/** A count for counting number of ADvendio__Invoice__c processed. */
	private	Integer totalNumberOfInvoices	= 0;
	
	/** A count for counting number of ADvendio__Invoice__c successfully processed. */
	private	Integer successNumberOfInvoices	= 0;
	
	/** A count for counting number of SomDig_Buchungssatz__c created. */
	private	Integer totalNumberOfAccountingRecords	= 0;
	
	/** The current instance name. */
	private String instanceName = null;
	  
    /** Process running type. */
    private String processRunningType	= null;
    
    /** Process running date. */
    private Date processRunningDate		= null;

	/** Current / last processed ADvendio__MediaCampaign__c. */
	private ADvendio__MediaCampaign__c currentMediaCampaign = null;
	
	/** Current / last processed ADvendio__Invoice__c. */
	private ADvendio__Invoice__c currentInvoice = null;
	
	/** Processing current / last ADvendio__Invoice__c interrupted? */
	private Boolean currentInvoiceInterrupted = false;
	
	/** Youngest accounting start date of all ADvendio__InvoiceItem__c of current processed ADvendio__Invoice__c. */
	private Date currentYongestInvoiceItemAccountingDate = null;
	
	/** Accounting records being inserted for current / last processed ADvendio__Invoice__c */
	private List<SomDig_Buchungssatz__c> currentAccountingRecords = new List<SomDig_Buchungssatz__c>();
	
	/** PRAP records being upserted for current / last processed ADvendio__Invoice__c */
	private List<SomDig_PRAP__c> currentPRAPRecords = new List<SomDig_PRAP__c>();
	
	/** Errors */
	//private List<String> errorMessages = new List<String>();
	//private List<String> errorMessagesIA = new List<String>();
	private Boolean errorsContained			= false;
	private Boolean iaWarningsContained		= false;
	private Map<Id, CampaignResult> campaignResults	= new Map<Id, CampaignResult>();

	/** Create projection accounting records at invoice item level? */
	private Boolean useProjectionRecordsByInvoiceItem = true;
	
	/** do not create projection accounting records at invoice item leve? */
	private Map<Id, Boolean> isInvoiceUsingProjection = new Map<Id, Boolean>();
			
	/** Accounting end date(time), used for setting accountingMonth, accountingMonthSAP etc. */
	private Datetime accountingEndTime = null;

	/** accountingMonth, used for setting SomDig_Verrechnungsmonat__c of record of SomDig_Buchungssatz__c. */
	private String accountingMonth = null;
	
	/** accountingMonthSAP, used for for setting SomDig_VerrechnungsmonatSAP__c of record of SomDig_Buchungssatz__c. */
	private String accountingMonthSAP = null;

	/**
	 * Constructor.
	 *
	 * @param	processType		The type of process to run, possible is either <code>PROCESS_ULTIMO_MINUS_5</code> or <code>PROCESS_ULTIMO_PLUS_4</code>.
	 *							Set to <code>null</code> to use the default which is <code>PROCESS_ULTIMO_MINUS_5</code>.
	 * @param	runningDate		The date at which the process is running. It is used to verify the invoice items being considered.
	 *							Furthermore, for <code>PROCESS_ULTIMO_MINUS_5</code>, it is used for posibble Extrapolation and Anticipation.
	 *							Set to <code>null</code> to use the default which is today.
	 */
	public SomDig_Buchungssatz_EaBatch(String processType, Date runningDate) {
		this.processRunningType = PROCESS_ULTIMO_MINUS_5.equals(processType)
								? PROCESS_ULTIMO_MINUS_5
								: (PROCESS_ULTIMO_PLUS_4.equals(processType) ? PROCESS_ULTIMO_PLUS_4 : null);

		this.processRunningDate = runningDate != null ? runningDate : System.today();
		
		Date accountingEndDate = system.today().toStartOfMonth().addMonths(1).addDays(-1);	// End of the current month.
    	this.accountingEndTime = Datetime.newInstance(accountingEndDate.year(), accountingEndDate.month(), accountingEndDate.day());

		this.accountingMonth = this.accountingEndTime.format('ddMMyyyy');
		this.accountingMonthSAP = this.accountingEndTime.format('yyMM');

    	if (PROCESS_ULTIMO_MINUS_5.equals(this.processRunningType)) {
			// Create invoice level projection accounting records.
			this.useProjectionRecordsByInvoiceItem = false;
    	} 

		for (Organization o : [SELECT InstanceName FROM Organization LIMIT 1]) {
			this.instanceName = o.InstanceName;
		}
	}
	
	public SomDig_Buchungssatz_EaBatch(String processType, Date runningDate, Boolean isTest) {
		this.processRunningType = PROCESS_ULTIMO_MINUS_5.equals(processType)
								? PROCESS_ULTIMO_MINUS_5
								: (PROCESS_ULTIMO_PLUS_4.equals(processType) ? PROCESS_ULTIMO_PLUS_4 : null);

		this.processRunningDate = runningDate != null ? runningDate : System.today();
		
		Date startingDate	= system.today();
		if (isTest) {
			startingDate	= this.processRunningDate;
		}
		Date accountingEndDate = startingDate.toStartOfMonth().addMonths(1).addDays(-1);	// End of the current month.
    	this.accountingEndTime = Datetime.newInstance(accountingEndDate.year(), accountingEndDate.month(), accountingEndDate.day());

		this.accountingMonth = this.accountingEndTime.format('ddMMyyyy');
		this.accountingMonthSAP = this.accountingEndTime.format('yyMM');

    	if (PROCESS_ULTIMO_MINUS_5.equals(this.processRunningType)) {
			// Create invoice level projection accounting records.
			this.useProjectionRecordsByInvoiceItem = false;
    	} 

		for (Organization o : [SELECT InstanceName FROM Organization LIMIT 1]) {
			this.instanceName = o.InstanceName;
		}
	}

	/**
	 * Get the accounting month for SAP information.
	 *
	 * @return The accounting month for SAP in format 'yyMM'.
	 */
	public String getAccountingMonthSAP() {
		return this.accountingMonthSAP;
	}

	/**
	 * Set the Id of records of ADvendio__InvoiceItem__c to check.
	 * @param	invoiceIds	Ids to set.
	 */
	public void setInvoiceItemIds(Set<Id> invoiceItemIds) {
		this.invoiceItemIds = invoiceItemIds;
	}
	
	/**
	 * Get the query string used for retrieve ADvendio__InvoiceItem__c being processed.
	 *
	 * The query tries to find invoice items:
	 * <ol>
	 *   <li>in expected accounting period.</li>
	 *   <li>By PROCESS_ULTIMO_PLUS_4
	 *     <ol>
	 *       <li>status of invoice is 'Invoiced'.</li>							  
	 *       <li>no SomDig_Buchungssatz__c with recordType 'Erloesaufteilung' is created for it yet if the payment interval is 'monthly (1 month)'.</li>
	 *     </ol>
	 *   </li>
	 *   <li>By PROCESS_ULTIMO_MINUS_5
	 *     <ol>
	 *       <li>status of invoice is 'Created', 'Draft', 'Reviewed' or 'Invoiced'.</li>								  
	 *       <li>no SomDig_Buchungssatz__c with recordType 'Erloesaufteilung' is created for it yet if the payment interval is 'monthly (1 month)'.</li>
	 *       <li>no SomDig_Buchungssatz__c with recordType 'Hochrechnung' and with SomDig_VerrechnungsmonatSAP__c same as process running month,
	 *           is created for it yet if the payment interval is 'monthly (1 month)'.</li>
	 *     </ol>
	 *   </li>
	 * </ol>
	 *
	 * Thus, PRAP invoice items will always found using the query. They must be filtered addtionally. 
	 *
	 * @return	The query string, or <code>null</code> if error.
	 */
	public String getQueryString() {
 		// It is assumed that this process will be run regually (monthly), thus date range will be used to limit the query size.
 		// Furthermore, currently, no MediaCampaign with a date range more than one year is allowed.
 		// Considering this, only invoices in the last 18 months will be checked.
 		
 		// Process Running Time
 		DateTime processRunningTime	= Datetime.newInstance(processRunningDate.year(), processRunningDate.month(), processRunningDate.day());

 		// First (Pre-)Invoice
 		Date     aDate = processRunningDate.toStartOfMonth().addMonths(-18);	// first day of last 18 months of the processRunningDate
 		DateTime firstInvoiceDate = Datetime.newInstance(aDate.year(), aDate.month(), aDate.day());

 		// Last Invoice
	 	aDate = processRunningDate.toStartOfMonth().addDays(-1);	// last day of previous month
 		DateTime lastInvoiceDate = processRunningTime; //Datetime.newInstance(aDate.year(), aDate.month(), aDate.day());
 		
 		// Last Pre-Invoice (monthly)
	 	aDate = processRunningDate.toStartOfMonth().addMonths(2).addDays(-1);	// last day of next month
 		DateTime lastPreInvoiceDate = Datetime.newInstance(aDate.year(), aDate.month(), aDate.day());

        // Last Pre-Invoice (total)
	 	aDate = processRunningDate.toStartOfMonth().addMonths(2).addDays(-1);	// last day of next month
 		DateTime lastTotalPreInvoiceDate = Datetime.newInstance(aDate.year(), aDate.month(), aDate.day());
    		
 		// PRAP InvoiceItem
    	if (PROCESS_ULTIMO_MINUS_5.equals(processRunningType)) {
			aDate = processRunningDate.toStartOfMonth();
    	} else if (PROCESS_ULTIMO_PLUS_4.equals(processRunningType)) {
			aDate = processRunningDate.addMonths(-1).toStartOfMonth();
    	}		
 		DateTime prapInvoiceItemDate = Datetime.newInstance(aDate.year(), aDate.month(), aDate.day());

		// Record Type
		Id eaRecordTypeId = SomDig_Buchungssatz_EaBase.getRecordTypeIdByName('SomDig_Buchungssatz__c', 'Erloesaufteilung');
    	Id hrRecordTypeId = SomDig_Buchungssatz_EaBase.getRecordTypeIdByName('SomDig_Buchungssatz__c', 'Hochrechnung');

  		String queryStr = 'SELECT ' + QUERY_INVOICEITEM_FIELDS + ' FROM ADvendio__InvoiceItem__c ';

    	if (PROCESS_ULTIMO_MINUS_5.equals(processRunningType)) {
			queryStr += 'WHERE ADvendio__Invoice__r.ADvendio__InvoiceDate__c >= ' + firstInvoiceDate.format('yyyy-MM-dd') +
						 ' AND ADvendio__Invoice__r.SomDig_Anzahl_Media_Positionen__c > 0 ' +
						 ' AND (' +
                		 '     ADvendio__Invoice__r.SomDig_RG_Empfaenger_P7S1_Konzernmitgl__c = false OR' +
                		 '     ADvendio__Invoice__r.ADvendio__Status__c = \'Invoiced\'' +
                		 ' )' +
						 ' AND (' +
                         '         (' +
                		 '             ADvendio__InvoicedAmountNet2__c = 0 AND' +
                		 '             ADvendio__FromDate__c >= ' + processRunningTime.format('yyyy-MM-dd') + ' AND ' +
                		 '             ADvendio__LinearDistribution__c = false' +
                		 '         )' +
                		 '         OR' +
                		 '         ADvendio__InvoicedAmountNet2__c != 0' +
                		 ' )' +
                		 ' AND ADvendio__CampaignItem__r.RecordType.DeveloperName != \'Packet\'' +
  						 ' AND (' +
                		 '         (' +
                		 '             ADvendio__Invoice__r.ADvendio__Status__c = \'Invoiced\' AND' +
                		 '             ADvendio__Invoice__r.ADvendio__InvoiceDate__c <= ' + lastInvoiceDate.format('yyyy-MM-dd') +
                		 '         )' +
                
						 '         OR (' +
                		 '             ADvendio__Invoice__r.ADvendio__Status__c IN (\'Created\', \'Draft\', \'Reviewed\')' +
                		 '             AND (' +
                		 '                     (' +
                		 '                         ADvendio__Invoice__r.ADvendio__PaymentInterval__c = \'monthly (1 month)\' AND' +
                		 '                         ADvendio__Invoice__r.ADvendio__InvoiceDate__c < ' + lastPreInvoiceDate.format('yyyy-MM-dd') + 
                		 '                     ) OR' +
                         '                     (' +
                		 '                         ADvendio__Invoice__r.ADvendio__PaymentInterval__c != \'monthly (1 month)\' AND' +
                		 '                         ADvendio__Invoice__r.ADvendio__InvoiceDate__c < ' + lastTotalPreInvoiceDate.format('yyyy-MM-dd') + 
                		 '                     )' +
                		 '             )' +
                		 '         )' +
						 ' )' +
   						 ' AND (' +
                		 '     ADvendio__Invoice__c NOT IN (' +
                		 '         SELECT SomDig_Rechnung__c FROM SomDig_Buchungssatz__c ' +
                		 '         WHERE' +
                		 '         (' +
                		 '             SomDig_Rechnung__r.ADvendio__PaymentInterval__c = \'monthly (1 month)\' OR' +
                		 '             SomDig_RechnungsPosition__r.ADvendio__InvoicedQuantityMultiplier__c = -1' +
                		 '         )' +
                		 '         AND (' +
                		 '             RecordTypeId = \'' + eaRecordTypeId + '\'' +
                		 '             OR (' +
                 		 '                 RecordTypeId = \'' + hrRecordTypeId + '\' AND' +
                		 '                 SomDig_VerrechnungsmonatSAP__c = \'' + accountingMonthSAP + '\'' +
                		 '             )' +
                		 '         )' +
                		 '     )' +
                		 ' )';
    	} else if (PROCESS_ULTIMO_PLUS_4.equals(processRunningType)) {
			queryStr += 'WHERE ADvendio__Invoice__r.ADvendio__Status__c = \'Invoiced\'' +
						 ' AND ADvendio__Invoice__r.SomDig_Anzahl_Media_Positionen__c > 0 ' +
						 ' AND ADvendio__InvoicedAmountNet2__c != 0' +		 
                		 ' AND ADvendio__CampaignItem__r.RecordType.DeveloperName != \'Packet\'' +
						 ' AND ADvendio__Invoice__r.ADvendio__InvoiceDate__c >= ' + firstInvoiceDate.format('yyyy-MM-dd') +
  						 ' AND ADvendio__Invoice__r.ADvendio__InvoiceDate__c <= ' + lastInvoiceDate.format('yyyy-MM-dd') +
   						 ' AND (' +
   						 '     Id NOT IN (' +
   						 '         SELECT SomDig_Rechnungsposition__c FROM SomDig_Buchungssatz__c ' +
   						 '         WHERE' +
   						 '         RecordTypeId = \'' + eaRecordTypeId + '\' AND' +
                		 '         (' +
   						 '             SomDig_Rechnung__r.ADvendio__PaymentInterval__c = \'monthly (1 month)\' OR' +
   						 '             SomDig_RechnungsPosition__r.ADvendio__InvoicedQuantityMultiplier__c = -1' +
                		 '         )' +
   						 '     )' +
   						 ' )';
   		}
   		system.debug(queryStr);
 		return queryStr;
	}
	
	/**
	 * Batch job start routine.
	 *
	 * @param	bc	Context of the batchable job.
	 */
	global Database.QueryLocator start(Database.BatchableContext bc) {
		String queryStr = getQueryString();

		// Force to find the invoice items with given IDs, even it could be empty, to avoid batch job started manually. 
		if (invoiceItemIds == null) {			 
			invoiceItemIds = new Set<Id>();
		}
		invoiceItemIds.remove(null);
		
		queryStr += ' AND (Id IN :invoiceItemIds) ';
		
		// IMPORTANT!!! Because we'll create Buchungssätze (SomDig_Buchungssatz__c) Invoice-based.
		// If there is any error by one InvoiceItem of an Invoice, the whole Invoice will be "rejected".
		queryStr += 'ORDER BY ADvendio__Invoice__c';

		return Database.getQueryLocator(queryStr);
	}
	
	/**
	 * Batch job execution routine.
	 *
	 * @param	bc		Context of the batchable job.
	 * @param	records	List of sObject to process.
	 */
	global void execute(Database.BatchableContext bc, List<sObject> records) {
		totalBatchs++;
		totalRecords += records.size();

    	System.debug('\n\nSomDig_Buchungssatz_EaBatch: Execute: TotalBatchs = ' + totalBatchs + ', TotalRecords = ' + totalRecords + ', SizeOfBatchRecords = ' + records.size() + ', BatchJobId = ' + (bc == null ? '' : bc.getJobId())); 
    	
    	// It is assumed that all records are sorted by their parent -- ADvendio__Invoice__c !!!
    	for (ADvendio__InvoiceItem__c invoiceItem : (List<ADvendio__InvoiceItem__c>)records) {
    		if (currentInvoice != null && currentInvoice.Id == invoiceItem.ADvendio__Invoice__c) {
    			// Same ADvendio__Invoice__c
    			/*if (currentInvoiceInterrupted) {
    				continue;
    			}*/
    		} else {
    			// Changing ADvendio__Invoice__c
    			totalNumberOfInvoices++;
    			
		    	
		    	createRecords();
		    	currentMediaCampaign = invoiceItem.ADvendio__Invoice__r.ADvendio__MediaCampaign__r;
		    	currentInvoice = invoiceItem.ADvendio__Invoice__r;
		    	
		    	if (!campaignResults.containsKey(currentMediaCampaign.Id)) {
		    		campaignResults.put(currentMediaCampaign.Id, new CampaignResult(currentMediaCampaign.Id, currentMediaCampaign.Name, instanceName));
		    	}
		    	
    			isInvoiceUsingProjection.put(currentInvoice.Id, false);	
	    		currentInvoiceInterrupted = false;
	    		currentYongestInvoiceItemAccountingDate = null;
	    		currentAccountingRecords.clear();
	    		currentPRAPRecords.clear();
    		}
    		
    		try {
    			SomDig_Buchungssatz_EaBase eaBase = new SomDig_Buchungssatz_EaBase(new List<ADvendio__InvoiceItem__c>{invoiceItem},
    																				processRunningType,
    																				processRunningDate,
    																				useProjectionRecordsByInvoiceItem);
    			
    			eaBase.runProcess();
    			
    			if (eaBase.isInvoiceUsingProjection.containsKey(currentInvoice.Id) && eaBase.isInvoiceUsingProjection.get(currentInvoice.Id)) {
    				isInvoiceUsingProjection.put(currentInvoice.Id, true);
    			} 
    			
    			for (SomDig_Buchungssatz_EaBase.RevenueDistributionResult rdr : eaBase.RevenueDistributionResults) {
	    			if (currentYongestInvoiceItemAccountingDate == null || rdr.accountingPeriodStartDate < currentYongestInvoiceItemAccountingDate) {
	    				currentYongestInvoiceItemAccountingDate = invoiceItem.ADvendio__InvoiceItemStartDate__c;
	    			}
    				
    				if (rdr.messages.isEmpty()) {
						campaignResults.get(currentMediaCampaign.Id).addOK(invoiceItem.Id, invoiceItem.Name, invoiceItem.ADvendio__Invoice__r.Name);
    				}
    				
    				for (SomDig_Buchungssatz_EaBase.ProcessMessage msg : rdr.messages) {
    					
						if (msg.severity == ApexPages.Severity.INFO) {
							campaignResults.get(currentMediaCampaign.Id).addWarning(invoiceItem.Id, invoiceItem.Name, invoiceItem.ADvendio__Invoice__r.Name, msg.message.escapeHtml4());
						}
    					
						if (msg.severity == ApexPages.Severity.FATAL || msg.severity == ApexPages.Severity.ERROR || msg.severity == ApexPages.Severity.WARNING) {
							currentInvoiceInterrupted = true;
							if ('IA'.equals(msg.messageType)) {
								currentInvoiceInterrupted = false;
								iaWarningsContained	= true;
								campaignResults.get(currentMediaCampaign.Id).addIAWarning(invoiceItem.Id, invoiceItem.Name, invoiceItem.ADvendio__Invoice__r.Name, msg.message.escapeHtml4());
							}
							else if (msg.severity == ApexPages.Severity.FATAL || msg.severity == ApexPages.Severity.ERROR || msg.severity == ApexPages.Severity.WARNING) {
								errorsContained	= true;
								campaignResults.get(currentMediaCampaign.Id).addError(invoiceItem.Id, invoiceItem.Name, invoiceItem.ADvendio__Invoice__r.Name, msg.message.escapeHtml4());
							}
						}
    				}
    				
    				if (!currentInvoiceInterrupted) {
    					String namePrefix = currentMediaCampaign.Id + '-' + currentInvoice.Id + '-' + invoiceItem.Id + '-';
    					Integer groupIdx = 0;
    					for (SomDig_Buchungssatz_EaBase.AccountingRecordsGroup arg : rdr.accountingRecordsGroups) {
    						groupIdx++;
    						Integer recIdx = 0;
    						for (SomDig_Buchungssatz_EaBase.AccountingRecord ar : arg.accountingRecords) {
    							recIdx++;
    							// Set the name, it will be used later as sort order while generating records for SAP file.
    							ar.accountingRecord.Name = namePrefix 
    													 + (groupIdx * 1.0).setScale(0).toPlainString().leftPad(6).replace(' ','0')
    													 + '-'
    													 + (recIdx * 1.0).setScale(0).toPlainString().leftPad(6).replace(' ','0');
								// Set the Verrechnungsmonat.
								ar.accountingRecord.SomDig_Verrechnungsmonat__c = accountingMonth;
								ar.accountingRecord.SomDig_VerrechnungsmonatSAP__c = accountingMonthSAP;

    							currentAccountingRecords.add(ar.accountingRecord);
    						}
    					}
    					
    					for (SomDig_Buchungssatz_EaBase.PRAP prap : rdr.prapRecords) {
    						if (prap.toUpsert) {
    							prap.prapRecord.SomDig_VerrechnungsmonatSAP__c = accountingMonthSAP;
    							currentPRAPRecords.add(prap.prapRecord);
    						}
    					}
    				} else {
    					currentYongestInvoiceItemAccountingDate = null;
			    		currentAccountingRecords.clear();
			    		currentPRAPRecords.clear();
    					break;
    				}
    			}
    		} catch (Exception e) {
	    		currentInvoiceInterrupted = true;
	    		currentYongestInvoiceItemAccountingDate = null;
	    		currentAccountingRecords.clear();
	    		currentPRAPRecords.clear();
	    		errorsContained	= true;
	    		campaignResults.get(currentMediaCampaign.Id).addError(invoiceItem.Id, invoiceItem.Name, invoiceItem.ADvendio__Invoice__r.Name, (e.getMessage() != null ? e.getMessage().escapeHtml4() : 'unbekannter Fehler'));
    		}
    	}
	}
	
	/**
	 * Batch job completion routine.
	 *
	 * @param	bc	Context of the batchable job.
	 */
	global void finish(Database.BatchableContext bc){
    	AsyncApexJob job = (bc == null ? null : [SELECT Id, CreatedBy.Email, CreatedBy.FirstName FROM AsyncApexJob WHERE Id = :bc.getJobId()]);

    	System.debug('\n\nSomDig_Buchungssatz_EaBatch: Finish: TotalBatchs = ' + totalBatchs + ', TotalRecords = ' + totalRecords + ', ' + job);
    	
    	// Just save records if there are
    	createRecords();
    	
    	// Get the SomDig_SapDatei__c
    	SomDig_SapDatei__c sapDatei = null;
	    if (successNumberOfInvoices > 0) {
	    	String buchungskreis = SomDig_Buchungssatz_EaBase.BUCHUNGSKREIS;
	    	String jahr = accountingEndTime.format('yyyy');
	    	String monat = accountingEndTime.format('MM');
	    	String tag = accountingEndTime.format('dd');
	    	Id recordTypeId = null;
	
	    	if (PROCESS_ULTIMO_MINUS_5.equals(processRunningType)) {
				recordTypeId = SomDig_Buchungssatz_EaBase.getRecordTypeIdByName('SomDig_SapDatei__c', 'SomDig_Hochrechnung');
	    	} else if (PROCESS_ULTIMO_PLUS_4.equals(processRunningType)) {
				recordTypeId = SomDig_Buchungssatz_EaBase.getRecordTypeIdByName('SomDig_SapDatei__c', 'SomDig_Erloesaufteilung');
	    	}
    	
	    	for (SomDig_SapDatei__c rec :  [SELECT Id FROM SomDig_SapDatei__c
	    									WHERE RecordTypeId = :recordTypeId AND
	    										  SomDig_Buchungskreis__c = :buchungskreis AND
	    										  SomDig_Jahr__c = :jahr AND
	    										  SomDig_Monat__c = :monat AND
	    										  SomDig_Nummer__c = null AND
	    										  SomDig_Status__c = 'erstellt'
	    									ORDER BY Name ASC
	    									LIMIT 1])
	    	{
	    		sapDatei = rec;
		    	System.debug('\n\nSomDig_Buchungssatz_EaBatch: found existed SomDig_SapDatei__c: ' + sapDatei);    	
	    	}
	    	
	    	if (sapDatei == null) {
	    		sapDatei = new SomDig_SapDatei__c(SomDig_Buchungskreis__c=buchungskreis, SomDig_Jahr__c=jahr, SomDig_Monat__c=monat, SomDig_Tag__c=tag,
	    											SomDig_Quellsystem__c='advendio', SomDig_Status__c='erstellt',RecordTypeId=recordTypeId);
	    		insert sapDatei;
		    	System.debug('\n\nSomDig_Buchungssatz_EaBatch: created new SomDig_SapDatei__c: ' + sapDatei);    	
	    	}
    	}
	    	
    	// Send mail
    	if (job != null || System.Test.isRunningTest()) {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	
            String emailAddress	= System.Test.isRunningTest() ? 'support@advendio.com' : job.CreatedBy.Email;
            String firstName	= System.Test.isRunningTest() ? 'ADvendio' : job.CreatedBy.FirstName;
	
			String[] toAddresses = new String[] { emailAddress };
			mail.setToAddresses(toAddresses);
			mail.setSubject('Prozess ' + processRunningType + ' ist beendet');
			
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
			htmlbody += 'der von Dir gestartete Prozess ' + processRunningType + ' ist jetzt beendet. Im Folgenden findest Du die Informationen zum Prozessergebnis und das weitere Vorgehen.\n';
			
			htmlbody += '<p>\n<b>Statistiken</b>\n<table style=\'border-width:0px;\'>';
			htmlbody += '<tr><td style=\'text-align:left; border-width:0px;\'>Anzahl der bearbeiteten Rechnungen:</td><td style=\'border-width:0px;\'>' + totalNumberOfInvoices + '</td></tr>';
			htmlbody += '<tr><td style=\'text-align:left; border-width:0px;\'>Anzahl der erfolgreich bearbeiteten Rechnungen:</td><td style=\'border-width:0px;\'>' + successNumberOfInvoices + '</td></tr>';
			htmlbody += '<tr><td style=\'text-align:left; border-width:0px;\'>Anzahl der erfolgreich erstellten Buchnungssätze:</td><td style=\'border-width:0px;\'>' + totalNumberOfAccountingRecords + '</td></tr>';
			htmlbody += '</table>\n</p>\n';
			
			Messaging.EmailFileAttachment att	= new Messaging.EmailFileAttachment();
			att.setBody(Blob.valueOf(createHtmlResult(campaignResults)));
			att.setContentType('text/html');
			att.setFileName('result.html');
			mail.setFileAttachments(new List<Messaging.EmailFileAttachment>{att});
			
			if (totalNumberOfInvoices > 0 && (successNumberOfInvoices > 0 || errorsContained || iaWarningsContained)) {
				htmlbody += '<p>\n<b>Weiteres Vorgehen</b>\n<ul>\n';
				if (errorsContained) {
					htmlbody += '<li>Behebe die Fehler, starte dann den Prozess erneut.</li>\n</ul>';
				}
				
				if (sapDatei != null) {
					htmlbody += '<li>Gehe zu <a href="https://' + instanceName + '.salesforce.com/' + sapDatei.Id + '">' + 'SAP-Datei</a>, starte den Buchnungssätze-Zuweisensprozess durch Klicken den Button "Buchungssätze zuweisen".</li>';
					htmlbody += '<li>Nachdem die Buchungssätze zugewiesen sind, gehe zu <a href="https://' + instanceName + '.salesforce.com/' + sapDatei.Id + '">' + 'SAP-Datei</a>, starte den Uploadprozess durch Klicken den Button "SAP Datei Upload".</li>';
					//htmlbody += '<li>Ein Prozess wird gestartet, um die erstellte Buchungssätze zu SAP Datei zuzuweisen. Eine weitere Mail wird an Dich geschickt wenn der Prozess beendet ist.</li>';
				}
				htmlbody += '</ul>\n</p>\n';
			}
			
			if (iaWarningsContained) {
				if (PROCESS_ULTIMO_MINUS_5.equalsIgnoreCase(this.processRunningType)) {
					htmlbody += '<p>\n<b>Hinweis</b>\n';
					htmlbody += 'Einige Rechnungen konnten, Aufgrund fehlerhafter oder nicht vollständiger Daten im System, nicht auf ihre eigentlichen IA-Nummern und Sachkonten verteilt werden!\n';
					htmlbody += 'VOR dem Monatsabschluss (Ultimo+4) ist unbedingt sicherzustellen, dass die Daten gepflegt werden. Zum Monatsabschluss erfolgt KEINE Verteilung auf den Dummy Innenauftrag als Sammelposten!\n';
				}
			}

			htmlbody += '<p>\nViele Grüße\n<br/>Dein SF-Admin</p>';
			
			mail.setHtmlBody(htmlbody);
	
            if (!System.Test.isRunningTest()) {
				Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    		}
    	}

/*	Currently don't start Buchungssätze Zuweisung process.
 *
    	if (sapDatei != null) {
    		// Start the Buchungssätze Zuweisung now.
    		SomDig_SapDatei sapDateiClass = new SomDig_SapDatei();
			sapDateiClass.sapDateiId = sapDatei.Id;
			
			Integer numJobs = [SELECT count() FROM AsyncApexJob WHERE JobType = 'BatchApex' AND ( Status = 'Queued' OR Status = 'Processing' OR Status = 'Preparing' )];
			if (numJobs > 4) {
				// try again in a minute
				Datetime sysTime = System.now().addSeconds(60);
				String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
	
		    	System.debug('\n\nSomDig_Buchungssatz_EaBatch: scheduled a batch job to assign Buchungssatz to SAP-Datei with Id ' + sapDatei.Id);    	
				System.schedule('SomDig_SapDatei_' + sysTime, chronExpression, sapDateiClass);                
	        } else {
		    	System.debug('\n\nSomDig_Buchungssatz_EaBatch: started a batch job to assign Buchungssatz to SAP-Datei with Id ' + sapDatei.Id);    	
				Database.executeBatch(sapDateiClass);
	        }
    	}
*/	
	}
	
	/**
	 * Create accounting / RPAP records if required.
	 */
	private void createRecords() {
		if (!currentInvoiceInterrupted) {
			Savepoint sp = Database.setSavepoint();

			try {
				List<SomDig_Buchungssatz__c> projectionAccountingRecords = createProjectedAccountingRecordsForInvoice();
				
				
				if (currentInvoice != null && currentInvoice.ADvendio__Invoice__c == null && !projectionAccountingRecords.isEmpty()) { // no cancelation
					insert projectionAccountingRecords;
				}
	    		if (!currentAccountingRecords.isEmpty()) {					
	    			insert currentAccountingRecords;
	    		}
	    		if (currentInvoice != null && currentInvoice.ADvendio__Invoice__c != null && !projectionAccountingRecords.isEmpty()) { // is cancelation
					insert projectionAccountingRecords;
				}
	    		if (!currentPRAPRecords.isEmpty()) {
	    			upsert currentPRAPRecords SomDig_UniqueKey__c;
	    		}
	    		if (!projectionAccountingRecords.isEmpty() || !currentAccountingRecords.isEmpty() || !currentPRAPRecords.isEmpty()) {
	    			successNumberOfInvoices++;
	    		}
	    		totalNumberOfAccountingRecords += projectionAccountingRecords.size();
	    		totalNumberOfAccountingRecords += currentAccountingRecords.size();
	    		currentAccountingRecords.clear();
	    		currentPRAPRecords.clear();
			} catch (Exception e) {
				Database.rollback(sp);
				campaignResults.get(currentMediaCampaign.Id).addError(currentInvoice.Id, null, currentInvoice.Name, (e.getMessage() != null ? e.getMessage().escapeHtml4() : 'unbekannter Fehler'));
			}
		}
	}
	
	/**
	 * Create accounting records for projected revenue (Hochrechnung) for current invoice.
	 *
	 * @return A list of object of type <code>SomDig_Buchungssatz__c</code>.
	 */
	private List<SomDig_Buchungssatz__c> createProjectedAccountingRecordsForInvoice() {
		List<SomDig_Buchungssatz__c> projectionAccountingRecords = new List<SomDig_Buchungssatz__c>();

		if (currentInvoice != null) {
			system.debug('useProjectionRecordsByInvoiceItem: ' + useProjectionRecordsByInvoiceItem);
			system.debug('isInvoiceUsingProjection: ' + isInvoiceUsingProjection);
			system.debug('processRunningType: ' + processRunningType);
			system.debug('currentInvoice: ' + currentInvoice);
			system.debug('currentInvoice.SomDig_Auftragstyp__c: ' + currentInvoice.SomDig_Auftragstyp__c);
			system.debug('currentInvoice.ADvendio__PaymentInterval__c: ' + currentInvoice.ADvendio__PaymentInterval__c);
			system.debug('currentYongestInvoiceItemAccountingDate: ' + currentYongestInvoiceItemAccountingDate);
			system.debug('currentInvoice.ADvendio__AccountingDate__c: ' + currentInvoice.ADvendio__AccountingDate__c);
		}
		
		
		if (!useProjectionRecordsByInvoiceItem
			&&
			currentInvoice != null
			&&
			(!isInvoiceUsingProjection.containsKey(currentInvoice.Id) || isInvoiceUsingProjection.get(currentInvoice.Id))
			&&
		    PROCESS_ULTIMO_MINUS_5.equals(processRunningType) // Ultimo-5
			&&
		    !'Barter'.equals(currentInvoice.SomDig_Auftragstyp__c)	// No Barter.
		    &&
			!'Invoiced'.equals(currentInvoice.ADvendio__Status__c) // Invoice should not be invoiced
			&&
			(
			 'monthly (1 month)'.equals(currentInvoice.ADvendio__PaymentInterval__c) // Monthly invoice
			 ||
			 (
			  'total account (one Invoice)'.equals(currentInvoice.ADvendio__PaymentInterval__c)	// One invoice (PRAP)
			  &&
			  currentYongestInvoiceItemAccountingDate.year() == currentInvoice.ADvendio__AccountingDate__c.year()	// One invoice but should be first year (first PRAP)
			  &&
			  currentYongestInvoiceItemAccountingDate.month() == currentInvoice.ADvendio__AccountingDate__c.month() 	// One invoice but should be first month (first PRAP)
			 )
			)
		   )
		{	
			
			
			system.debug('sfghDFGh');
						
			// Need to create projected accounting records
			Decimal amount = currentInvoice.ADvendio__InvoicedAmountGrossN2__c;
			String standardAccount	= currentInvoice.SomDig_RG_Empfaenger_P7S1_Konzernmitgl__c ? SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_IC : SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_INTERNET;

			if (amount != null && amount != 0) {
				Boolean isPureDL = currentInvoice.SomDig_Anzahl_Nonmedia_Positionen__c > 0 && currentInvoice.SomDig_Anzahl_Media_Positionen__c == 0;
				String creditAccountType = isPureDL
										 ? SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_ERLOESE_DIENSTLEISTUNGEN
										 : standardAccount;
						
				Datetime dt = Datetime.newInstance(currentInvoice.ADvendio__InvoiceDate__c.year(),
													currentInvoice.ADvendio__InvoiceDate__c.month(),
													currentInvoice.ADvendio__InvoiceDate__c.day());

				SomDig_Buchungssatz__c bs = new SomDig_Buchungssatz__c();
																	
				bs.RecordTypeId = SomDig_Buchungssatz_EaBase.getRecordTypeIdByName('SomDig_Buchungssatz__c', 'Hochrechnung');	
				bs.CurrencyIsoCode = currentInvoice.CurrencyIsoCode;
				bs.SomDig_Belegdatum__c = dt.format('ddMMyyyy');
				bs.SomDig_Belegkopftext__c = String.isNotEmpty(currentInvoice.ADvendio__OrderNumber__c)
											? currentInvoice.ADvendio__OrderNumber__c.subString(0, Math.min(currentInvoice.ADvendio__OrderNumber__c.length(), 25))
											: null;
				bs.SomDig_Buchungskreis__c = SomDig_Buchungssatz_EaBase.BUCHUNGSKREIS;
				bs.SomDig_Kostenstelle__c = null;
				bs.SomDig_Rechnung__c = currentInvoice.Id;
				bs.SomDig_Rechnungsposition__c = null;			
				bs.SomDig_Referenz__c = String.isNotEmpty(currentInvoice.ADvendio__OrderNumber__c)
										? currentInvoice.ADvendio__OrderNumber__c.subString(0, Math.min(currentInvoice.ADvendio__OrderNumber__c.length(), 16))
										: null;
				bs.SomDig_Steuerrelevanz__c = '0';
				bs.SomDig_Zuordnung__c = null;

				bs.SomDig_Verrechnungsmonat__c = accountingMonth;
				bs.SomDig_VerrechnungsmonatSAP__c = accountingMonthSAP;
				
				bs.SomDig_Betrag__c = Math.abs(amount).setScale(2).toPlainString().leftPad(14).replace(' ','0');
				bs.SomDig_Buchungstext__c = 'Hochrechnung PIs';
				bs.SomDig_Steuerkennzeichen__c = currentInvoice.SomDig_Steuerkennzeichen__c;
				bs.SomDig_Steuerrelevanz__c = 'AS'.equals(currentInvoice.SomDig_Steuerkennzeichen__c) ? '1' : '0';
					
	    		Integer groupIdx = 1;
				for (Integer i = 0; i < 2; i++) {
					SomDig_Buchungssatz__c tmpBS = bs.clone(false, true, false, false);

					tmpBS.Name  = currentMediaCampaign.Id + '-' + currentInvoice.Id + '-' + ADvendio__InvoiceItem__c.sObjectType.getDescribe().getKeyPrefix() + '-'
	    						+ (groupIdx * 1.0).setScale(0).toPlainString().leftPad(6).replace(' ','0') + '-'
	    						+ ((i+1) * 1.0).setScale(0).toPlainString().leftPad(6).replace(' ','0');
							
					if (i == 0) {
						if (amount > 0) {
							tmpBS.SomDig_Erloeskonto_Sachkonto__c = SomDig_Buchungssatz_EaBase.getSachkontoNummerByType(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_FORDERUNG_HOCHRECHNUNG);
							tmpBS.SomDig_Soll_Haben_Kennzeichen__c = 'S';
							tmpBS.SomDig_Steuerkennzeichen__c = 'A0';
						} else {
							tmpBS.SomDig_Erloeskonto_Sachkonto__c = SomDig_Buchungssatz_EaBase.getSachkontoNummerByType(creditAccountType);
							tmpBS.SomDig_Innenauftragsnummer__c = SomDig_Buchungssatz_EaBase.getIaNummerByType(creditAccountType);
							tmpBS.SomDig_Soll_Haben_Kennzeichen__c = 'S';
						}
					} else if (i == 1) {
						if (amount > 0) {
							tmpBS.SomDig_Erloeskonto_Sachkonto__c = SomDig_Buchungssatz_EaBase.getSachkontoNummerByType(creditAccountType);
							tmpBS.SomDig_Innenauftragsnummer__c = SomDig_Buchungssatz_EaBase.getIaNummerByType(creditAccountType);
							tmpBS.SomDig_Soll_Haben_Kennzeichen__c = 'H';
						} else {
							tmpBS.SomDig_Erloeskonto_Sachkonto__c = SomDig_Buchungssatz_EaBase.getSachkontoNummerByType(SomDig_Buchungssatz_EaBase.SACHKONTO_TYP_FORDERUNG_HOCHRECHNUNG);
							tmpBS.SomDig_Soll_Haben_Kennzeichen__c = 'H';
							tmpBS.SomDig_Steuerkennzeichen__c = 'A0';
						}
					}
									
					projectionAccountingRecords.add(tmpBS);
				}							
			}							
		}
		return projectionAccountingRecords;
	}

	/**
	* create the complete (css+js+data) html to be displayed in the UI
	* @param	a list of CampaignResults with campaign-ids as key
	* @return	complete result as html/string 
	**/
	public static String createHtmlResult(Map<Id, CampaignResult> campaignResults) {
		return createHtmlResult(campaignResults, 'Kampagne');
	}
	
	/**
	* create the complete (css+js+data) html to be displayed in the UI
	* @param	a list of CampaignResults with campaign-ids as key
	* @param	header (column) Name
	* @return	complete result as html/string 
	**/
	public static String createHtmlResult(Map<Id, CampaignResult> campaignResults, String columnName) {

        String html = '<html>\n'
                + '<head>\n'
                + '<meta charset="utf-8"/>\n'
                + '<style type="text/css">\n'
                + '<!--\n'
                + '  body    { font-family:Verdana; font-size:12px; }\n'
                + '  table   { font-size:12px; border-width:1px; border-spacing:2px; border-style:solid; border-color:gray; border-collapse:collapse; }\n'
                + '  caption { font-size:14px; font-weight:bold; white-space:nowrap; }\n'
                + '  th      { font-size:12px; font-weight:bold; border-width:1px; border-style:solid; border-color:gray; padding:4px; white-space:nowrap; }\n'
                + '  td      { font-size:12px; border-width:1px; border-style:solid; border-color:gray; white-space:nowrap;text-align:left;vertical-align:top;padding:10px; }\n'
                + '  .ok     {color:green;}\n'
                + '  .warning {color:orange;}\n'
                + '  .error {color:red;}\n'
                + '  .ia {color:magenta;}\n'
                + '  dd {display:none;}\n'
                + '  .controll {border-width:0px;}'
                + '-->\n'
                + '</style>\n'
                + '<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.3/jquery.min.js"></script>\n'
                + '<script type="text/javascript">\n'
				+ 'function checkHideRow () {\n'
				+ '  var lastTrId	= null;\n'
				+ '  var hide = true;\n'
				+ '  $(".msg").children().each(function() {\n'
				+ '    if ($(this).hasClass("error") || $(this).hasClass("ia") || $(this).hasClass("warning") || $(this).hasClass("ok")) {\n'
				+ '    	 var trId		 = $(this).parents("tr").prop("id");\n'
				+ '      if (lastTrId == null || trId != lastTrId) {\n'
				+ '        hide = true;\n'
				+ '        lastTrId = trId;\n'
				+ '      }\n'
				+ '      else if (trId == lastTrId && !hide) {\n'
				+ '        return true;\n'
				+ '      }\n'
				+ '      if ($(this).hasClass("ok") && $("#toggleOk:checked").val() && $(this).text() != "") {\n'
				+ '        hide	= false;\n'
				+ '      }\n'
				+ '      if ($(this).hasClass("warning") && $("#toggleWarnings:checked").val() && $(this).text() != "") {\n'
				+ '        hide	= false;\n'
				+ '      }\n'
				+ '      if ($(this).hasClass("ia") && $("#toggleIa:checked").val() && $(this).text() != "") {\n'
				+ '        hide	= false;\n'
				+ '      }\n'
				+ '      if ($(this).hasClass("error") && $("#toggleErrors:checked").val() && $(this).text() != "") {\n'
				+ '        hide	= false;\n'
				+ '      }\n'
				+ '      if (hide && !$(this).parents("tr").is(":hidden")) {\n'
				+ '        $(this).parents("tr").hide();\n'
				+ '      }\n'
				+ '      if (!hide && $(this).parents("tr").is(":hidden")){\n'
				+ '        $(this).parents("tr").show();\n'
				+ '      }\n'
				+ '    }\n'
				+ '  });\n'
				+ '}\n'
				+ 'function doReady() {\n'
				+ '  $("dt").click(function(){\n'
				+ '    $(this).next("dd").slideToggle("fast");\n'
				+ '  });\n'
				+ '  $("#toggleWarnings").click(function(){\n'
				+ '    checkHideRow();\n'
				+ '    $(".warning").slideToggle("fast");\n'
				+ '    $(".warning").next().hide();\n'
				+ '  });\n'
				+ '  $("#toggleWarningMessages").click(function(){\n'
				+ '    if($("#toggleWarnings:checked").val()){\n'
				+ '      $(".warningMsg").slideToggle("fast");\n'
				+ '    }\n'
				+ '  });\n'
				+ '  $("#toggleErrors").click(function(){\n'
				+ '    checkHideRow();\n'
				+ '     $(".error").slideToggle("fast");\n'
				+ '     $(".error").next().hide();\n'
				+ '  });\n'
				+ '  $("#toggleErrorMessages").click(function(){\n'
				+ '    if($("#toggleErrors:checked").val()){\n'
				+ '      $(".errorMsg").slideToggle("fast");\n'
				+ '    }\n'
				+ '  });\n'
				+ '  $("#toggleOk").click(function(){\n'
				+ '    checkHideRow();\n'
				+ '    $(".ok").slideToggle("fast");\n'
				+ '    $(".ok").next().hide();\n'
				+ '  });\n'
				+ '  $("#toggleOkMessages").click(function(){\n'
				+ '    if($("#toggleOK:checked").val()){\n'
				+ '      $(".okMsg").slideToggle("fast");\n'
				+ '    }\n'
				+ '  });\n'
				+ '  $("#toggleIa").click(function(){\n'
				+ '    checkHideRow();\n'
				+ '    $(".ia").slideToggle("fast");\n'
				+ '    $(".ia").next().hide();\n'
				+ '  });\n'
				+ '  $("#toggleIaMessages").click(function(){\n'
				+ '    if($("#toggleIa:checked").val()){\n'
				+ '      $(".iaMsg").slideToggle("fast");\n'
				+ '    }\n'
				+ '  });\n'
				+ '}\n'
				+ '$(document).ready(function(){\n'
				+ '  doReady();\n'
				+ '});'
                + '</script>\n'
                
                + '</head>\n'
                + '<body>\n'
		
				+ '  <table>\n'
                + '    <tr>\n'
                + '      <td class="controll">OK</td>\n'
                + '      <td class="controll"><input type="checkbox" id="toggleOk" checked></td>\n'
                + '      <td class="controll"><button id="toggleOkMessages">+ / -</button></td>\n'
                + '    </tr>\n'
                + '    <tr>\n'
                + '      <td class="controll">Warnungen</td>\n'
                + '      <td class="controll"><input type="checkbox" id="toggleWarnings" checked></td>\n'
                + '      <td class="controll"><button id="toggleWarningMessages">+ / -</button></td>\n'
                + '    </tr>\n'
                + '    <tr>\n'
                + '      <td class="controll">Fehler</td>\n'
                + '      <td class="controll"><input type="checkbox" id="toggleErrors" checked></td>\n'
                + '      <td class="controll"><button id="toggleErrorMessages">+ / -</button></td>\n'
                + '    </tr>\n'
                + '    <tr>\n'
                + '      <td class="controll">fehlende</br>Innenaufträge</td>\n'
                + '      <td class="controll"><input type="checkbox" id="toggleIa" checked></td>\n'
                + '      <td class="controll"><button id="toggleIaMessages">+ / -</button></td>\n'
                + '    </tr>\n'
                + '  </table>\n'
                + '  <table>\n'
                + '    <tr>\n'
                + '      <td>'+columnName+'</td>\n'
                + '      <td>Meldungen</td>\n'
                + '    </tr>\n';
		
		for (CampaignResult row : campaignResults.values()) {
			html	+= row.getHtmlRow() +'\n';
		}
		html	+= '</body></html>';
		return html;
	}
	
	/**
	* Dataholder for results to one campaign
	**/
	public class CampaignResult {
		public List<ItemResult> messagesOK {public get; private set;}
		public List<ItemResult> messagesWarning {public get; private set;}
		public List<ItemResult> messagesError {public get; private set;}
		public List<ItemResult> messagesErrorNoSub {public get; private set;}
		public List<ItemResult> messagesIA {public get; private set;}
		public String campaignId	{public get; private set;}
		public String campaignName	{public get; private set;}
		public String instanceName	{public get; private set;}
		
		private final String MSG_TYPE_OK		= 'OK';
		private final String MSG_TYPE_IA		= 'IA';
		private final String MSG_TYPE_ERROR		= 'ERROR';
		private final String MSG_TYPE_ERROR_NO_SUB		= 'ERROR_NO_SUB';
		private final String MSG_TYPE_WARNING	= 'WARNING';
		
		public CampaignResult(Id campaignId, String campaignName, String instanceName) {
			this.campaignName	= campaignName!=null ? campaignName : '';
			this.campaignId		= EncodingUtil.urlEncode(campaignId!=null ? String.valueOf(campaignId) : '', 'UTF-8');
			this.instanceName	= EncodingUtil.urlEncode(instanceName!=null ? instanceName : '', 'UTF-8');
			messagesOK		= new List<ItemResult>();
			messagesWarning	= new List<ItemResult>();
			messagesError	= new List<ItemResult>();
			messagesIA		= new List<ItemResult>();
			messagesErrorNoSub	= new List<ItemResult>();
		}
		
		/**
		* get html code for the row
		* @return html as string
		**/
		public String getHtmlRow() {
			system.debug(messagesErrorNoSub);
			String html	= '    <tr id="'+campaignId+'">\n'
			            + '      <td><a href="https://' + instanceName + '.salesforce.com/'+campaignId+'" target="blank">'+campaignName+'</a></td>\n'
			            + '      <td class="msg">\n';
			if (!messagesOK.isEmpty()) {
				html	+= '       <dt class="ok">'+messagesOK.size()+' Rechnungsposition'+(messagesOK.size() > 1 ? 'en' : '' )+'</dt>\n'
				        +  '       <dd class="okMsg">\n';
				for (ItemResult msg : messagesOK) {
					html	+= '         ' +msg.getHtmlRow() + '</br>\n';
				}
				html	+= '       </dd>\n';
			}
			if (!messagesWarning.isEmpty()) {
				html	+= '       <dt class="warning">'+messagesWarning.size()+' Rechnungsposition'+(messagesWarning.size() > 1 ? 'en' : '' )+'</dt>\n'
				        +  '       <dd class="warningMsg">\n';
				for (ItemResult msg : messagesWarning) {
					html	+= '         ' +msg.getHtmlRow() + '</br>\n';
				}
				html	+= '       </dd>\n';
			}
			if (!messagesError.isEmpty()) {
				html	+= '       <dt class="error">'+messagesError.size()+' Rechnungsposition'+(messagesError.size() > 1 ? 'en' : '' )+'</dt>\n'
				        +  '       <dd class="errorMsg">\n';
				for (ItemResult msg : messagesError) {
					html	+= '         ' +msg.getHtmlRow() + '</br>\n';
				}
				html	+= '       </dd>\n';
			}
			if (!messagesErrorNoSub.isEmpty()) {
				html	+= '       <dt class="error">'+messagesErrorNoSub.size()+' Meldung'+(messagesErrorNoSub.size() > 1 ? 'en' : '' )+'</dt>\n'
				        +  '       <dd class="errorMsg">\n';
				for (ItemResult msg : messagesErrorNoSub) {
					html	+= '         ' +msg.getHtmlRow() + '</br>\n';
				}
				html	+= '       </dd>\n';
			}
			if (!messagesIA.isEmpty()) {
				html	+= '       <dt class="ia">'+messagesIA.size()+' Rechnungsposition'+(messagesIA.size() > 1 ? 'en' : '' )+'</dt>\n'
				        +  '       <dd class="iaMsg">\n';
				for (ItemResult msg : messagesIA) {
					html	+= '         ' +msg.getHtmlRow() + '</br>\n';
				}
				html	+= '       </dd>\n';
			}
			
			html += '</td>\n</tr>';
			return html;
		}
		
		/** add an OK message / item to the campaign result **/
		public void addOK(Id itemid, String itemName, String invoiceName) {
			addMessage(itemid, itemName, invoiceName, null, MSG_TYPE_OK);
		}
		/** add an ERROR message / item to the campaign result **/
		public void addError(Id itemid, String itemName, String invoiceName, String message) {
			addMessage(itemid, itemName, invoiceName, message, MSG_TYPE_ERROR);
		}
		/** add an INFO message / item to the campaign result **/
		public void addWarning(Id itemid, String itemName, String invoiceName, String message) {
			addMessage(itemid, itemName, invoiceName, message, MSG_TYPE_WARNING);
		}
		/** add an ERROR message / item to the campaign result **/
		public void addErrorNoSub(String message) {
			addMessage(null, '', '', message, MSG_TYPE_ERROR_NO_SUB);
		}
		
		/** add a missing Innen-Auftrag message / item to the campaign result - will happen in HR(U-5) only **/
		public void addIAWarning(Id itemid, String itemName, String invoiceName, String message) {
			addMessage(itemid, itemName, invoiceName, message, MSG_TYPE_IA);
		}
		
		/** add a message / item with a certain type to the campaign result **/
		private void addMessage(Id itemid, String itemName, String invoiceName, String message, String msgType) {
			if (MSG_TYPE_OK.equals(msgType)) {
				messagesOK.add(new ItemResult(itemid, itemName, invoiceName, message, instanceName));
			}
			else if (MSG_TYPE_WARNING.equals(msgType)) {
				messagesWarning.add(new ItemResult(itemid, itemName, invoiceName, message, instanceName));
			}
			else if (MSG_TYPE_ERROR.equals(msgType)) {
				messagesError.add(new ItemResult(itemid, itemName, invoiceName, message, instanceName));
			}
			else if (MSG_TYPE_ERROR_NO_SUB.equals(msgType)) {
				messagesErrorNoSub.add(new ItemResult(itemid, itemName, invoiceName, message, instanceName));
			}
			else if (MSG_TYPE_IA.equals(msgType)) {
				messagesIA.add(new ItemResult(itemid, itemName, invoiceName, message, instanceName));
			}
		}
	}
	
	/**
	* Dataholder for results to one item
	**/
	private class ItemResult {
		public String itemid {public get; private set;}
		public String itemName {public get; private set;}
		public String message {public get; private set;}
		public String invoiceName {public get; private set;}
		public String instanceName	{public get; private set;}
		
		public ItemResult(Id itemid, String itemName, String invoiceName, String message, String instanceName) {
			this.itemid			= EncodingUtil.urlEncode(itemid!=null ? String.valueOf(itemid) : '', 'UTF-8');
			this.itemName		= itemName!=null ? itemName : '';
			this.invoiceName	= invoiceName!=null ? invoiceName : '';
			this.message		= message!=null ? message : '';
			this.instanceName	= EncodingUtil.urlEncode(instanceName!=null ? instanceName : '', 'UTF-8');
		}
				
		/**
		* get html code for the item
		* @return html as string
		**/
		public String getHtmlRow() {
			String url	= '';
			if (this.itemid == '') {
				url	= this.message;
			}
			else {
				String linkLabel	= '';
				if (this.itemName == '') {
					if (this.invoiceName != '') {
						linkLabel = '('+this.invoiceName+')';
					}
					else {
						linkLabel = '(_)';
					}
				}
				else {
					if (this.invoiceName != '') {
						linkLabel = '('+this.invoiceName+' | '+this.itemName+')';
					}
					else {
						linkLabel = '('+this.itemName+')';
					}
				}
				
				url	= (this.message != '' ? this.message + ' - ' : '') + '<a href="https://' + instanceName + '.salesforce.com/'+this.itemid +'" target="blank">'+linkLabel+'</a>';
			}
			return url;
		}
	}
}