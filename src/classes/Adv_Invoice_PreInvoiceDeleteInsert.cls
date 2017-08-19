/**
 * A schedulable job to create pre-invoices for ADvendio__MediaCampaign__c.
 */
global with sharing class Adv_Invoice_PreInvoiceDeleteInsert implements Schedulable {

    /** The default QUERY. */
    private final static String DEFAULT_QUERY = 'SELECT Id FROM ADvendio__MediaCampaign__c WHERE isDeleted = false '
        + 'AND ADvendio__BillMe__c = true AND ADvendio__Propability__c = 100 '
        + 'AND ADvendio__Campaign_End_Date__c != null '
        + 'AND ADvendio__Campaign_Start_Date__c != null '
        + 'AND(ADvendio__Campaign_End_Date__c = LAST_N_DAYS:60 OR ADvendio__Campaign_End_Date__c = NEXT_YEAR '
        + 'OR (ADvendio__Campaign_End_Date__c = THIS_YEAR AND ADvendio__Campaign_End_Date__c >= TODAY) )';

    /** Ids of ADvendio__MediaCampaign__c to force to check. Mainly used for testing. */
    @TestVisible
    private Set<Id> recIds  = null;

    /** 
     * Constructor
     */
    public Adv_Invoice_PreInvoiceDeleteInsert() {
    }

    /**
     * Set the RecordIds to check. Mainly used for testing.
     * @param   recIds  Record-Ids to set.
     */
    public void setRecordIds(Set<Id> recIds) {
        this.recIds = recIds;
    }

    /**
     * Add a RecordId to check. Mainly used for testing.
     * @param   recId   Record-Id to add.
     */
    public void addRecordId(Id recId) {
        if (this.recIds == null) {
            this.recIds = new Set<Id>();
        }
        this.recIds.add(recId);
    }

    /**
     * Start the creating pre-invoice prozess.
     */
    public void createPreInvoice() {
        String query = DEFAULT_QUERY;

        if (recIds != null) {
            recIds.remove(null);
            if (!recIds.isEmpty()) {
                query += ' AND Id IN (';

                for (Id s : recIds) {
                    query += '\'' + s + '\'' + ',';
                }

                query = query.substring(0, query.length()-1);
                query += ')';
            }
        }

        ADvendio.GenerateInvoiceBatch job = new ADvendio.GenerateInvoiceBatch();

        job.query = query;
        job.batchsize = 1;

        Database.executeBatch(job, 1);
    }

    public void deletePreInvoice() {
        Map<Id, ADvendio__Invoice__c> invoicesToDelete;

        // Query the invoices that are qualified to be deleted. Store it in a map to have the IDs easily accesible.
        if(recIds== null || recIds.isEmpty()){
        	invoicesToDelete = new Map<Id, ADvendio__Invoice__c>([SELECT Id FROM ADvendio__Invoice__c 
                                                                            WHERE ADvendio__Status__c = 'Draft' 
                                                                            AND (SomDig_MediacampaignLost__c = TRUE 
                                                                                OR ADvendio__MediaCampaign__r.ADvendio__BillMe__c = FALSE)]);
        }else{
            invoicesToDelete = new Map<Id, ADvendio__Invoice__c>([SELECT Id FROM ADvendio__Invoice__c 
                                                                            WHERE ADvendio__Status__c = 'Draft' 
                                                                            AND (SomDig_MediacampaignLost__c = TRUE 
                                                                                OR ADvendio__MediaCampaign__r.ADvendio__BillMe__c = FALSE)
                                                                            AND ADvendio__MediaCampaign__c IN :recIds]);
        }
        
        // Query the buchungsatz
        List<SomDig_Buchungssatz__c> buchungsatzToDelete = new List<SomDig_Buchungssatz__c>([SELECT Id FROM SomDig_Buchungssatz__c WHERE SomDig_Rechnung__c IN :invoicesToDelete.keySet()]);

    	delete buchungsatzToDelete;
    	delete invoicesToDelete.values();

    }

    /**
     * Schedule excution routine.
     *
     * @param   sc  Context of the schedule job.
     */
    global void execute(SchedulableContext sc) {
    	deletePreInvoice();
        ADvendio.GenerateInvoiceBatch job = new ADvendio.GenerateInvoiceBatch();

        job.query = DEFAULT_QUERY;
        job.batchsize = 1;

        Database.executeBatch(job, 1);
    }
}