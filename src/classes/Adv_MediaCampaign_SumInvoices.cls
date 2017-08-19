global class Adv_MediaCampaign_SumInvoices implements Database.Batchable<sObject>, Schedulable {

	private static final String DEFAULT_SOQL = 'SELECT ADvendio__MediaCampaign__c FROM ADvendio__Invoice__c WHERE LastModifiedDate = LAST_N_DAYS:3 AND ADvendio__AccountingDate__c >= LAST_YEAR';
	private String soql;

	public Adv_MediaCampaign_SumInvoices() {
		soql = DEFAULT_SOQL;
	}

	public Adv_MediaCampaign_SumInvoices(String query) {
		soql = query;
	}

	global void execute(SchedulableContext SC) {	
		Database.executeBatch(this);
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		Set<ID> setMediaCampaignIDs = new Set<ID>();
		for(ADvendio__Invoice__c objInvoice : Database.query(soql)) {
			setMediaCampaignIDs.add(objInvoice.ADvendio__MediaCampaign__c);
		}
		return Database.getQueryLocator('SELECT Id, (SELECT ADvendio__InvoicedAmountNet2__c, ADvendio__InvoiceType__c, ADvendio__Status__c FROM ADvendio__Invoices__r WHERE ADvendio__Status__c IN (\'Invoiced\', \'Canceled\') OR (ADvendio__Status__c = \'Reviewed\' AND ADvendio__Invoice__c != NULL)) FROM ADvendio__MediaCampaign__c WHERE Id IN :setMediaCampaignIDs');	
	}

   	global void execute(Database.BatchableContext BC, List<ADvendio__MediaCampaign__c> scope) {
		for(ADvendio__MediaCampaign__c objMC : scope) {
			Decimal sumAmountNet2 = 0;
			for(ADvendio__Invoice__c objInvoice : objMC.ADvendio__Invoices__r) {
				sumAmountNet2 = sumAmountNet2 + objInvoice.ADvendio__InvoicedAmountNet2__c;
			}
			objMC.SomDig_AbgerechneterMN2__c = sumAmountNet2;
		}
		update scope;
	}	
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}