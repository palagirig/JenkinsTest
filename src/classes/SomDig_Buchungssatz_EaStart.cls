/**
 * The control class for selecting MediaCampaign / Invoice / InvoicesItem for Revenue Distribution & Projection.
 */
public with sharing class SomDig_Buchungssatz_EaStart {
	/** Process type: Ultimo-5 */
	public static final String PROCESS_ULTIMO_MINUS_5 = SomDig_Buchungssatz_EaBase.PROCESS_ULTIMO_MINUS_5;
	
	/** Process type: Ultimo+4 */
	public static final String PROCESS_ULTIMO_PLUS_4 = SomDig_Buchungssatz_EaBase.PROCESS_ULTIMO_PLUS_4;
	
	/** Number of MediaCampaigns to show in a results-page. */
	public static final Integer MAX_NUMBER_MCS_PER_PAGE = 20;
	
	/** Options for process types used in the VF page. */
	public List<SelectOption> allProcessTypes { public get; private set; }
	
	/** Selected process type used in the VF page. */
	public String selectedProcessType { public get; public set; }

	/** Search performed flag used in the VF page. */
	public Boolean performedSearch { public get; public set; }

	/** Selection-Checkbox of the current results page in the VF page. */
	public Boolean pageSelected { public get; public set; }

	/** A dummy ADvendio__MediaCampaign__c, some fields are used for filter/settings in the VF page.
	 *	ADvendio__Close_Date__c: used as process running date which will be passed to the batch job.
	 *	ADvendio__Closed_Lost__c: used in VF page to enable / disable manuell changing process running date.
	 *	ADvendio__IsApproved__c: used in VF page to select / de-select the MediaCampaign for further processing.
	 *	ADvendio__Account__c: used as filter for searching the MediaCampaign
	 *	ADvendio__Agency__c: used as filter for searching the MediaCampaign
	 *	ADvendio__Campaign_Start_Date__c: used as filter for searching the MediaCampaign
	 *	ADvendio__Campaign_End_Date__c: used as filter for searching the MediaCampaign
	 */
	public ADvendio__MediaCampaign__c filterMediaCampaign { public get; private set; }
	
	/** Current MediaCampaigns used in the VF page. */
	public List<ADvendio__MediaCampaign__c> currentMediaCampaigns { public get; public set; }

	/** The results of found ADvendio__MediaCampaign__c with its ADvendio__InvoiceItem__c to process. */
	@TestVisible private Map<Id, Set<Id>> allMediaCampaignWithInvoiceItem = new Map<Id, Set<Id>>();
	
	/** The results of found ADvendio__MediaCampaign__c. */
	@TestVisible private List<ADvendio__MediaCampaign__c> allMediaCampaigns = new List<ADvendio__MediaCampaign__c>();
	
	/** The current page number. */
	private Integer totalPageNumber = 0;
	
	/** The current page number. */
	private Integer currentPageNumber = 0;
	
	/** The Selection-Checkbox status of all results pages. */
	private List<Boolean> allPagesSelection = new List<Boolean>();
	
	/** Testing mode */
	private Boolean isTest = false;
	
	/**
	 * Construnctor
	 */
	public SomDig_Buchungssatz_EaStart() {
		
		String isTestString	= ApexPages.currentPage().getParameters().get('isTest');
		isTest	= isTestString != 'true' && isTestString != 'false'  ? false : Boolean.valueOf(isTestString);
		
		allProcessTypes = new List<SelectOption>();
		
		allProcessTypes.add(new SelectOption(PROCESS_ULTIMO_MINUS_5, PROCESS_ULTIMO_MINUS_5));
		allProcessTypes.add(new SelectOption(PROCESS_ULTIMO_PLUS_4, PROCESS_ULTIMO_PLUS_4));
		
		selectedProcessType = allProcessTypes.get(0).getValue();
		
		performedSearch = false;
		
		pageSelected = false;

		filterMediaCampaign = new ADvendio__MediaCampaign__c(ADvendio__Close_Date__c=System.today(), ADvendio__Closed_Lost__c=false, ADvendio__IsApproved__c=true);
		
		currentMediaCampaigns = new List<ADvendio__MediaCampaign__c>();
	}

	/**
	 * Reset.
	 *
	 * @return	A PageReference object. The value will always be null.
	 */	
	public PageReference reset() {
		currentMediaCampaigns.clear();
		allMediaCampaignWithInvoiceItem.clear();
		allMediaCampaigns.clear();
		totalPageNumber = 0;
		currentPageNumber = 0;
		allPagesSelection.clear();
		
		performedSearch = false;
		pageSelected = false;
			
		return null;
	}

	/**
	 * Change the process running date.
	 *
	 * @return	A PageReference object. The value will always be null.
	 */	
	public PageReference changeProcessRunningDate() {
		if (!filterMediaCampaign.ADvendio__Closed_Lost__c) {
			filterMediaCampaign.ADvendio__Close_Date__c = System.today();
		}
		
		reset();
		
		return null;
	}

	/**
	 * Toggle the selection of MediaCampaigns in current page.
	 *
	 * @return	A PageReference object. The value will always be null.
	 */	
	public PageReference toggleSelection() {
		/*
		if (currentPageNumber > 0 && currentPageNumber <= totalPageNumber && currentPageNumber <= allPagesSelection.size()) {
			allPagesSelection[currentPageNumber - 1] = pageSelected;
		}
		for (ADvendio__MediaCampaign__c mc : currentMediaCampaigns) {
			mc.ADvendio__IsApproved__c = pageSelected;
		}
		*/

		allPagesSelection.clear();
		for (Integer i = 0; i< totalPageNumber; i++) {
			allPagesSelection.add(pageSelected);
		}
		for (ADvendio__MediaCampaign__c mc : allMediaCampaigns) {
			mc.ADvendio__IsApproved__c = pageSelected;
		}

		return null;
	}

	/**
	 * Search the MediaCampaigns being processed.
	 *
	 * @return	A PageReference object. The value will always be null.
	 */
	public PageReference doSearch() {
		reset();
		
		try {
			Map<Id, ADvendio__MediaCampaign__c> mMediaCampaigns = new Map<Id, ADvendio__MediaCampaign__c>();

			SomDig_Buchungssatz_EaBatch	batchClass = new SomDig_Buchungssatz_EaBatch(selectedProcessType, filterMediaCampaign.ADvendio__Close_Date__c, isTest);
			
			String queryStr = batchClass.getQueryString();

			Id accountId = filterMediaCampaign.ADvendio__Account__c;
			Id agencyId = filterMediaCampaign.ADvendio__Agency__c;
			Date startDate = filterMediaCampaign.ADvendio__Campaign_Start_Date__c;
			Date endDate = filterMediaCampaign.ADvendio__Campaign_End_Date__c;
			if (accountId != null) {
				queryStr += ' AND ADvendio__Invoice__r.ADvendio__MediaCampaign__r.ADvendio__Account__c = :accountId ';
			}
			if (agencyId != null) {
				queryStr += ' AND ADvendio__Invoice__r.ADvendio__MediaCampaign__r.ADvendio__Agency__c = :agencyId ';
			}
			if (startDate != null) {
				queryStr += ' AND ADvendio__Invoice__r.ADvendio__MediaCampaign__r.ADvendio__Campaign_Start_Date__c >= :startDate ';
			}
			if (endDate != null) {
				queryStr += ' AND ADvendio__Invoice__r.ADvendio__MediaCampaign__r.ADvendio__Campaign_End_Date__c <= :endDate ';
			}

			queryStr += 'ORDER BY ADvendio__Invoice__c';
						
			system.debug(queryStr);
			List<ADvendio__InvoiceItem__c> invoiceItems = Database.query(queryStr);

			// Using the query, some cases are not covered:
			//1: Once an invoice is "Canceled", a cancellation invoice will be created for it.
			//	  For the case if there is no SomDig_Buchungssatz__c was created for the cancelled invoice,
			//	  the cancellation invoice should be ignored.
			//2: The PRAP invoice items need to be checked. 

			// Following code will prepare data for checking such cases.
			
			// Get all original invoices and campaign items of cancellation items
			// Get all PRAP items			
			Set<Id> orgCiIds							= new Set<Id>();
			Set<Id> orgInvoiceIds						= new Set<Id>();
			Map<String, Id> orgInvoiceItemByKey			= new Map<String, Id>();
			Map<Id, SomDig_PRAP__c> prapByInvoiceItem	= new Map<Id, SomDig_PRAP__c>();
			Set<Id> prapOfInvoiceItemValidated 			= new Set<Id>();
			
			Id recordTypeIdEA			= SomDig_Buchungssatz_EaBase.getRecordTypeIdByName('SomDig_Buchungssatz__c', 'Erloesaufteilung');
			Id recordTypeIdHR			= SomDig_Buchungssatz_EaBase.getRecordTypeIdByName('SomDig_Buchungssatz__c', 'Hochrechnung');
			String accountingMonthSAP	= batchClass.getAccountingMonthSAP();
			
			// find cancellation and prap item ... to be treated seperately
			for (ADvendio__InvoiceItem__c invoiceItem : invoiceItems) {
				if (isCancellationInvoiceItem(invoiceItem)) { // Cancellation
					
					if (invoiceItem.ADvendio__ConnectedItem__c != null) {
						orgInvoiceItemByKey.put(invoiceItem.Id, invoiceItem.ADvendio__ConnectedItem__c);
					}
					else {
					
						Id orgCiId	= getCampaignItem(invoiceItem).Id;
						Id orgInvId	= invoiceItem.ADvendio__Invoice__r.ADvendio__Invoice__c;
						
						orgCiIds.add(orgCiId);
						orgInvoiceIds.add(orgInvId);
					}
					if (isPrapInvoiceItem(invoiceItem)) { // always allow cancelled prap item - checks for existing Buchungssätze happen later on
						prapOfInvoiceItemValidated.add(invoiceItem.Id);
					}
				}
				else if (isPrapInvoiceItem(invoiceItem)) {
					prapByInvoiceItem.put(invoiceItem.Id, null);
					System.debug('\n\nPRAP-InvoiceItemId: ' + invoiceItem.Id + '\n');
				}
			}
			
			// Find now original invoice items of cancellation items
			if (!orgCiIds.isEmpty() && !orgInvoiceIds.isEmpty()) {
				for (ADvendio__InvoiceItem__c invoiceItem : [SELECT Id, ADvendio__Invoice__c, ADvendio__CampaignItem__c FROM ADvendio__InvoiceItem__c
															 WHERE ADvendio__Invoice__c IN :orgInvoiceIds AND ADvendio__CampaignItem__c IN :orgCiIds])
				{
					orgInvoiceItemByKey.put(invoiceItem.ADvendio__Invoice__c+'|'+invoiceItem.ADvendio__CampaignItem__c, invoiceItem.Id);
				}
			}
			
			
			// Find now original invoice items with SomDig_Buchungssatz__c
			Set<Id> orgInvoiceItemWithBS = new Set<Id>();
			if (!orgInvoiceItemByKey.isEmpty()) {
				List<Id> orgInvoiceItemIds	= orgInvoiceItemByKey.values();
				
				String qs = 'SELECT SomDig_Rechnungsposition__c invoiceItemId ' +
							'FROM SomDig_Buchungssatz__c ' +
							'WHERE SomDig_Rechnungsposition__c IN :orgInvoiceItemIds AND ' +
							'RecordTypeId = :recordTypeIdEA ' +
							'GROUP BY SomDig_Rechnungsposition__c ';
				
				for (AggregateResult ar : Database.query(qs)) {
					orgInvoiceItemWithBS.add(((Id)(ar.get('invoiceItemId'))));
					System.debug('\n\nFound Buchungssatz of Original-InvoiceItemId: ' + ar.get('invoiceItemId') + '\n');
				}
			}
			
			// find HR Buchungssätze for (prap) invoice-items for the given SAP period - skip invoice-items when found records
			if (!prapByInvoiceItem.isEmpty() && PROCESS_ULTIMO_MINUS_5.equals(selectedProcessType)) {
				 for (ADvendio__InvoiceItem__c invItem : [SELECT Id FROM ADvendio__InvoiceItem__c
					 										WHERE Id IN :prapByInvoiceItem.keySet()
					 										AND ADvendio__Invoice__c IN (
					 											SELECT SomDig_Rechnung__c FROM SomDig_Buchungssatz__c
					 											WHERE RecordTypeId = :recordTypeIdEA 
																OR (RecordTypeId = :recordTypeIdHR AND SomDig_VerrechnungsmonatSAP__c = :accountingMonthSAP)
					 											)
					 										]) {
				 	prapByInvoiceItem.remove(invItem.Id);
				 }
				 	
			}
			
			// Find the PRAPs, validate them
			if (!prapByInvoiceItem.isEmpty()) {
				Map<Id, SomDig_PRAP__c> prapOfInvoiceItems = new Map<Id, SomDig_PRAP__c>();
				for (SomDig_PRAP__c aPrap : [SELECT Id, SomDig_Rechnungsposition__c, SomDig_Abrechnungsmonat__c, SomDig_Abrechnungsmonatsende__c, SomDig_NochAbzugrenzendeErloese__c
											 FROM SomDig_PRAP__c
											 WHERE SomDig_Rechnungsposition__c IN :prapByInvoiceItem.keySet() AND SomDig_Status__c = 'Aufgelöst'
											 ORDER BY SomDig_Rechnungsposition__c, SomDig_Abrechnungsmonat__c DESC])
				{
					// only remember the most recent PRAP for each invoice item
					if (prapByInvoiceItem.get(aPrap.SomDig_Rechnungsposition__c) == null) {
						prapByInvoiceItem.put(aPrap.SomDig_Rechnungsposition__c, aPrap);
					}
				}

				for (Id invoiceItemId : prapByInvoiceItem.keySet()) {
					SomDig_PRAP__c prap	= prapByInvoiceItem.get(invoiceItemId);
					if (prap == null) {
						// OK
						prapOfInvoiceItemValidated.add(invoiceItemId);
						system.debug('kein PRAP zur Position - OK ( ' + invoiceItemId +')');
					} else {
						// check PRAP for distributable amount
						if (prap.SomDig_NochAbzugrenzendeErloese__c != 0) {
							// OK
							system.debug('PRAP vorhanden, aber OK ( ' + invoiceItemId +')');
							prapOfInvoiceItemValidated.add(invoiceItemId);
						}
					}
				}
			}
			// Now go through all found invoice items, and filter those if not expected.

			Schema.SObjectField invoiceField = ADvendio__InvoiceItem__c.ADvendio__Invoice__c.getDescribe().getSobjectField();
			Schema.SObjectField mcField = ADvendio__Invoice__c.ADvendio__MediaCampaign__c.getDescribe().getSobjectField();
			
			// validate each invoice
			for (ADvendio__InvoiceItem__c invoiceItem : invoiceItems) {
				Id mcId = invoiceItem.ADvendio__Invoice__r.ADvendio__MediaCampaign__c;
				
				if (mcId == null) {
					continue;
				}
				
				// Check cancelation invoiceItem 
				if (isCancellationInvoiceItem(invoiceItem)) {
					Id orgCiId		= getCampaignItem(invoiceItem).Id;
					Id orgInvoiceId	= invoiceItem.ADvendio__Invoice__r.ADvendio__Invoice__c;
					String key		= '';
					
					if (orgInvoiceItemByKey.containsKey(invoiceItem.Id)) {
						key	= invoiceItem.Id;
					}
					else if (orgInvoiceItemByKey.containsKey(orgInvoiceId+'|'+orgCiId)) {
						key	= orgInvoiceId+'|'+orgCiId;
					}
					
					// cancellation to item without buchungssätze? 
					if (orgInvoiceItemWithBS.isEmpty() || !orgInvoiceItemWithBS.contains(orgInvoiceItemByKey.get(key))) {
						// No BS for original invoiceItem, so this invoiceItem is to ignore.
						System.debug('\n\nNo Buchungssatz found for Original-InvoiceItem, thus ignored the Cancellation-InvoiceItemId ' + invoiceItem.Id + '\n');
						continue;
					}
				}

				system.debug(isPrapInvoiceItem(invoiceItem));

				// Check PRAP invoiceItem 
				if (isPrapInvoiceItem(invoiceItem)) {
					
					system.debug(invoiceItem.Id + ': ' + isPrapInvoiceItem(invoiceItem) + ' | ' +  prapOfInvoiceItemValidated.contains(invoiceItem.Id));
					// is the an already resolved PRAP for the invoice item
					if (!prapOfInvoiceItemValidated.contains(invoiceItem.Id)) {
						continue;
					}
				}

				// Save the invoiceItem.
				Set<Id> invoiceItemIds = allMediaCampaignWithInvoiceItem.get(mcId);
				if (invoiceItemIds == null) {
					invoiceItemIds = new Set<Id>();
					allMediaCampaignWithInvoiceItem.put(mcId, invoiceItemIds);
				}
				invoiceItemIds.add(invoiceItem.Id);

				// Save the MediaCampaign
				if (!mMediaCampaigns.containsKey(mcId)) {
					//ADvendio__MediaCampaign__c mc = (ADvendio__MediaCampaign__c)invoiceItem.getSObject(invoiceField).getSObject(mcField);
					ADvendio__MediaCampaign__c mc = invoiceItem.ADvendio__Invoice__r.ADvendio__MediaCampaign__r;
					if (mc != null) {
						// We use / abuse the field ADvendio__IsApproved__c for select / de-select the MC for processing.
						mc.ADvendio__IsApproved__c = filterMediaCampaign.ADvendio__IsApproved__c;
						mMediaCampaigns.put(mcId, mc);
					}
				}				
			}
			
			performedSearch = true;
			
			if (!mMediaCampaigns.isEmpty()) {
				allMediaCampaigns = mMediaCampaigns.values();
				allMediaCampaigns.sort();

				initPagination();
			}
	} catch (Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
	}
		
		return null;
	}
	
	/**
	 * Start the batch job.
	 *
	 * @return	A PageReference object. The value will always be null.
	 */	
	public PageReference runProcess() {
		if (allMediaCampaigns.isEmpty()) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Keine Mediakampagne gefunden.'));
			return null;
		}

		for (AsyncApexJob job: [SELECT Id, Status FROM AsyncApexJob
								WHERE ApexClass.Name = 'SomDig_Buchungssatz_EaBatch' AND
									  (Status = 'Queued' OR Status = 'Preparing' OR Status = 'Processing')])
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ein ' + PROCESS_ULTIMO_MINUS_5 + ' oder ' + PROCESS_ULTIMO_PLUS_4 + ' Prozess läuft gerade!'));
			return null;
		}
		
		Set<Id> mcIds = new Set<Id>();
		for (ADvendio__MediaCampaign__c mc : allMediaCampaigns) {
			if (mc.ADvendio__IsApproved__c) {
				mcIds.add(mc.Id);
			}
		}
		
		Set<Id> invoiceItemIds = new Set<Id>();
		for (Id mcId : mcIds) {
			if (allMediaCampaignWithInvoiceItem.containsKey(mcId)) {
				invoiceItemIds.addAll(allMediaCampaignWithInvoiceItem.get(mcId));
			}
		}
		
		if (!invoiceItemIds.isEmpty()) {
			SomDig_Buchungssatz_EaBatch	batchClass = new SomDig_Buchungssatz_EaBatch(selectedProcessType, filterMediaCampaign.ADvendio__Close_Date__c, isTest);
			batchClass.setInvoiceItemIds(invoiceItemIds);
			
			Id jobId = Database.executeBatch(batchClass, 1);
			
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
														'Ein Prozess mit der ID ' + jobId + 
														' ist im Hintergrund gestartet. Sie werden per Email benachrichtigt wenn der Prozess beendet ist.'));
			
			filterMediaCampaign = new ADvendio__MediaCampaign__c(ADvendio__Close_Date__c=System.today(), ADvendio__Closed_Lost__c=false, ADvendio__IsApproved__c=true);		
	
			reset();
		} else {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Keine Mediakampagne ausgewählt.'));
		}

		return null;
	}
	
	/**
	 * Indicates whether there is any record found.
	 *
	 * @return	True if there is record found, false otherwise.
	 */
	public Boolean getHasResult() {
		return totalPageNumber > 0;
	}

	/**
	 * Indicates whether there are more records after the current page set.
	 *
	 * @return	True if there is record, false otherwise.
	 */
	public Boolean getHasNext() {
		return currentPageNumber < totalPageNumber;
	}

	/**
	 * Indicates whether there are more records before the current page set.
	 *
	 * @return	True if there is record, false otherwise.
	 */
	public Boolean getHasPrevious() {
		return currentPageNumber > 1;
	}

	/**
	 * Returns the page number of the current page set
	 *
	 * @return	Current page number, starting with 1.
	 */
	public Integer getPageNumber() {
		return currentPageNumber;
	}

	/**
	 * Returns the total page numbers of set
	 *
	 * @return	Total page numbers.
	 */
	public Integer getTotalPages() {
		return totalPageNumber;
	}

	/**
	 * Goes to the first page of records
	 */
	public void first() {
		if (currentPageNumber != 1) {
			currentPageNumber = 1;
			createPageRecords();
		}
	}

	/**
	 * Goes to the last page of records
	 */
	public void last() {
		if (currentPageNumber != totalPageNumber) {
			currentPageNumber = totalPageNumber;
			createPageRecords();
		}
	}

	/**
	 * Goes to the previous page of records
	 */
	public void previous() {
		if (currentPageNumber > 1) {
			currentPageNumber--;
			createPageRecords();
		}
	}

	/**
	 * Goes to the next page of records
	 */
	public void next() {
		if (currentPageNumber < totalPageNumber) {
			currentPageNumber++;
			createPageRecords();
		}
	}
	

	/**
	 * Check whether an invoice item is a cancelllation item.
	 *
	 * @param invoiceItem The invoice item to check.
	 * @return True if invoice item is a cancellation item, false otherwise
	 */
	private Boolean isCancellationInvoiceItem(ADvendio__InvoiceItem__c invoiceItem) {
		if (invoiceItem.ADvendio__InvoicedQuantityMultiplier__c < 0) {
			return true;
		}
		return false;
	}

	/**
	 * Get the CampaignItem used for revenue distribution, considered the possible cancellation
	 *
	 * @param invoiceItem The invoice item to use.
	 * @return The campaign item found, or null if error.
	 */
	private ADvendio__Campaign_Item__c getCampaignItem(ADvendio__InvoiceItem__c invoiceItem) {
		ADvendio__Campaign_Item__c ci	= null;
		if (invoiceItem.ADvendio__Invoice__r.ADvendio__Invoice__c != null) { // is cancellation invoice?
			if (invoiceItem.ADvendio__CampaignItem__r.ADvendio__ConnectedItem__c != null && // is campaign-item cancelled?
				invoiceItem.ADvendio__CampaignItem__r.ADvendio__ConnectedItem__r.CreatedDate < invoiceItem.CreatedDate) { // check if campaign-item-cancellation triggered invoice-cancellation (Ticket 04429: invoice-canncellation, then campaign-item-cancellation)
				ci = invoiceItem.ADvendio__CampaignItem__r.ADvendio__ConnectedItem__r;
			}
			else {
				ci = invoiceItem.ADvendio__CampaignItem__r;
			}
		}
		else {
			ci = invoiceItem.ADvendio__CampaignItem__r;
		}
		
		return ci;
	}

	/**
	 * Check whether an invoice item requires PRAP.
	 *
	 * @param invoiceItem The invoice item to check.
	 * @return True if invoice item requires PRAP, false otherwise
	 */
	private Boolean isPrapInvoiceItem(ADvendio__InvoiceItem__c invoiceItem) {
		if ('total account (one Invoice)'.equals(invoiceItem.ADvendio__Invoice__r.ADvendio__PaymentInterval__c) &&
			'before / during Billingperiod'.equals(invoiceItem.ADvendio__Invoice__r.ADvendio__PaymentStart__c) &&
			(invoiceItem.ADvendio__Invoice__r.ADvendio__AccountingDate__c.year() != invoiceItem.ADvendio__Invoice__r.ADvendio__AccountingEndDate__c.year() ||
			 invoiceItem.ADvendio__Invoice__r.ADvendio__AccountingDate__c.month() != invoiceItem.ADvendio__Invoice__r.ADvendio__AccountingEndDate__c.month()))
		{
			return true;
		}
	
		return false;		
	}

	/**
	 * Init pagination
	 */
	@TestVisible private void initPagination() {
		Integer totalPages = allMediaCampaigns.size() / MAX_NUMBER_MCS_PER_PAGE;
		Integer remainder = Math.mod(allMediaCampaigns.size(), MAX_NUMBER_MCS_PER_PAGE);

		totalPageNumber = remainder == 0 ? totalPages : (totalPages+1);
		currentPageNumber = 1;
		
		allPagesSelection.clear();
		for (Integer i = 0; i< totalPageNumber; i++) {
			allPagesSelection.add(true);
		}
				
		createPageRecords();
	}
	
	/**
	 * Create pagination records
	 */
	private void createPageRecords() {
		currentMediaCampaigns.clear();
		
		Integer fromPosition = currentPageNumber > 1 ? (currentPageNumber - 1) * MAX_NUMBER_MCS_PER_PAGE : 0;
		Integer toPosition = Math.min(fromPosition + MAX_NUMBER_MCS_PER_PAGE, allMediaCampaigns.size());
		
		for (Integer i = fromPosition; i < toPosition; i++) {
			currentMediaCampaigns.add(allMediaCampaigns.get(i));
		}
		
		if (currentPageNumber > 0 && currentPageNumber <= totalPageNumber && currentPageNumber <= allPagesSelection.size()) {
			pageSelected = allPagesSelection[currentPageNumber - 1];
		}
	}
}