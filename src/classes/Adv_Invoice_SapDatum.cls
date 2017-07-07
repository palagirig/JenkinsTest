public with sharing class Adv_Invoice_SapDatum extends TriggerController {

    // Constructor
    public Adv_Invoice_SapDatum(Boolean isAfter, Boolean isBefore, Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate, List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems) {
        super(isAfter, isBefore, isDelete, isInsert, isUndelete, isUpdate, lstNewItems, mapNewItems, lstOldItems, mapOldItems);
    }

    protected override void runBeforeInsert() {
        assignSapDate((List<ADvendio__Invoice__c>) lstNewItems, NULL);
    }
    protected override void runBeforeUpdate() {
        assignSapDate((List<ADvendio__Invoice__c>) lstNewItems, (Map<Id, ADvendio__Invoice__c>)mapOldItems);
    }

    @testvisible private static List<SomDig_InvoiceMonth__c> cachedInvoiceMonths {
        get {
            if (cachedInvoiceMonths == null) {
                cachedInvoiceMonths = [
                    SELECT SomDig_To__c, SomDig_Month__c, SomDig_Year__c 
                    FROM SomDig_InvoiceMonth__c
                    WHERE SomDig_ClosureDateTime__c = null
                    ORDER BY SomDig_To__c ASC
                ];
            }
            return cachedInvoiceMonths;
        }
        set;
    }

    public static void assignSapDate(List<ADvendio__Invoice__c> newInvoiceList, Map<Id, ADvendio__Invoice__c> oldInvoiceMap) {

        for(ADvendio__Invoice__c invoice : newInvoiceList) {
            if(oldInvoiceMap == null || invoice.ADvendio__InvoiceDate__c != oldInvoiceMap.get(invoice.Id).ADvendio__InvoiceDate__c  || (invoice.ADvendio__Status__c != oldInvoiceMap.get(invoice.Id).ADvendio__Status__c && invoice.ADvendio__Status__c == 'Invoiced')) {
                SomDig_InvoiceMonth__c correctInvoiceMonth = findCorrectInvoiceMonth(invoice.ADvendio__InvoiceDate__c);
                invoice.SomDig_SapBuchungsdatumAuto__c = correctInvoiceMonth != null ? formatInvoiceDate(correctInvoiceMonth.SomDig_Year__c, correctInvoiceMonth.SomDig_Month__c) : formatInvoiceDate(invoice.ADvendio__InvoiceDate__c.year(), invoice.ADvendio__InvoiceDate__c.month());
            }
        }

    }

    private static SomDig_InvoiceMonth__c findCorrectInvoiceMonth(Date invoiceDate) {

        SomDig_InvoiceMonth__c correctInvoiceMonth = null;
        
        for(SomDig_InvoiceMonth__c invoiceMonth : cachedInvoiceMonths) {
            if(invoiceMonth.SomDig_To__c >= invoiceDate) {
                correctInvoiceMonth = invoiceMonth;
                break;
            }
        }

        return correctInvoiceMonth;

    }
 
    private static String formatInvoiceDate(Decimal year, Decimal month) {
        String sMonth = String.valueOf(month);
        if(sMonth.length() == 1) sMonth = '0' + sMonth;
        String sYear = String.valueOf(year);
        return sMonth + '.' + sYear;
    }

}