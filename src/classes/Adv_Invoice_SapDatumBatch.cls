global class Adv_Invoice_SapDatumBatch implements Database.Batchable<sObject>, Schedulable {
    
    String query = 'SELECT SomDig_SapBuchungsdatumAuto__c, ADvendio__InvoiceDate__c FROM ADvendio__Invoice__c WHERE ADvendio__InvoiceDate__c > N_DAYS_AGO:200';

    @testvisible private static List<SomDig_InvoiceMonth__c> cachedInvoiceMonths {
        get {
            if (cachedInvoiceMonths == null) {
                cachedInvoiceMonths = [
                    SELECT SomDig_To__c, SomDig_Month__c, SomDig_Year__c 
                    FROM SomDig_InvoiceMonth__c 
                    ORDER BY SomDig_To__c ASC
                ];
            }
            return cachedInvoiceMonths;
        }
        set;
    }

    global Adv_Invoice_SapDatumBatch() {
    }

    global void execute(SchedulableContext SC) {    
        Adv_Invoice_SapDatumBatch b = new Adv_Invoice_SapDatumBatch();
        Database.executeBatch(b);               
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {

        List<ADvendio__Invoice__c> invoices = (List<ADvendio__Invoice__c>) scope;
        List<ADvendio__Invoice__c> invoicesToUpdate = new List<ADvendio__Invoice__c>();

        for(ADvendio__Invoice__c invoice : invoices) {

            SomDig_InvoiceMonth__c correctInvoiceMonth = findCorrectInvoiceMonth(invoice.ADvendio__InvoiceDate__c);

            if(correctInvoiceMonth != null && invoice.SomDig_SapBuchungsdatumAuto__c != formatInvoiceDate(correctInvoiceMonth.SomDig_Year__c, correctInvoiceMonth.SomDig_Month__c)) {
                invoice.SomDig_SapBuchungsdatumAuto__c = formatInvoiceDate(correctInvoiceMonth.SomDig_Year__c, correctInvoiceMonth.SomDig_Month__c);
                invoicesToUpdate.add(invoice);
            } else if (correctInvoiceMonth == null && invoice.SomDig_SapBuchungsdatumAuto__c != formatInvoiceDate(invoice.ADvendio__InvoiceDate__c.year(), invoice.ADvendio__InvoiceDate__c.month())) {
                invoice.SomDig_SapBuchungsdatumAuto__c = formatInvoiceDate(invoice.ADvendio__InvoiceDate__c.year(), invoice.ADvendio__InvoiceDate__c.month());
                invoicesToUpdate.add(invoice);
            }

        }

        update invoicesToUpdate;
        
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }

    private SomDig_InvoiceMonth__c findCorrectInvoiceMonth(Date invoiceDate) {

        SomDig_InvoiceMonth__c correctInvoiceMonth = null;
        for(SomDig_InvoiceMonth__c invoiceMonth : cachedInvoiceMonths) {

            if(invoiceMonth.SomDig_To__c >= invoiceDate) {
                correctInvoiceMonth = invoiceMonth;
                break;
            }

        }

        return correctInvoiceMonth;

    }
 
    private String formatInvoiceDate(Decimal year, Decimal month) {
        String sMonth = String.valueOf(month);
        if(sMonth.length() == 1) sMonth = '0' + sMonth;
        String sYear = String.valueOf(year);
        return sMonth + '.' + sYear;
    }
    
}