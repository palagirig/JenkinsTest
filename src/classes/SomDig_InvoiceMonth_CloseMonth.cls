global class SomDig_InvoiceMonth_CloseMonth {
    
    public class closeMonthException extends Exception {}
    
    webservice static void closeMonthValidation(ID invoiceMonth) {
        Profile currentProfile = [SELECT Name FROM Profile WHERE ID = :UserInfo.getProfileId()];
        SomDig_InvoiceMonth__c objInvoiceMonth =  [SELECT SomDig_Month__c, SomDig_Year__c, SomDig_ClosureDateTime__c, SomDig_IsCurrentMonth__c, SomDig_To__c FROM SomDig_InvoiceMonth__c WHERE ID = :invoiceMonth];
        SomDig_InvoiceMonth__c nextInvoiceMonth = getNextInvoiceMonth(objInvoiceMonth.SomDig_Month__c, objInvoiceMonth.SomDig_Year__c);
        
        if(!objInvoiceMonth.SomDig_IsCurrentMonth__c)
            throw new closeMonthException(Label.SomDig_InvoiceMonth_CloseMonth_NotCurrentInvoiceMonth);

        if(!(currentProfile.Name == 'SomDig_Billing'))
            throw new closeMonthException(Label.SomDig_InvoiceMonth_CloseMonth_NotBillingUser);
        
        if(nextInvoiceMonth == null)
            throw new closeMonthException(Label.SomDig_InvoiceMonth_CloseMonth_NoNextMonth);
        
    }
    
    webservice static void closeMonth(ID invoiceMonth) {
		
        SomDig_InvoiceMonth__c objInvoiceMonth =  [SELECT SomDig_Month__c, SomDig_Year__c, SomDig_ClosureDateTime__c, SomDig_IsCurrentMonth__c, SomDig_To__c FROM SomDig_InvoiceMonth__c WHERE ID = :invoiceMonth];
        SomDig_InvoiceMonth__c nextInvoiceMonth = getNextInvoiceMonth(objInvoiceMonth.SomDig_Month__c, objInvoiceMonth.SomDig_Year__c);
        
        objInvoiceMonth.SomDig_IsCurrentMonth__c = false;
        objInvoiceMonth.SomDig_ClosureDateTime__c = DateTime.now();
        objInvoiceMonth.SomDig_To__c = Date.today();
        update objInvoiceMonth;
        
        nextInvoiceMonth.SomDig_IsCurrentMonth__c = true;
        update nextInvoiceMonth;
        
    }
    
    @testVisible
    private static SomDig_InvoiceMonth__c getNextInvoiceMonth(Decimal month, Decimal year) {
        
        month = month + 1;
        if(month > 12) {
            month = 1;
            year = year + 1;
        }
        
        List<SomDig_InvoiceMonth__c> nextInvoiceMonths = new List<SomDig_InvoiceMonth__c>([SELECT Id, SomDig_IsCurrentMonth__c FROM SomDig_InvoiceMonth__c WHERE SomDig_Month__c = :month AND SomDig_Year__c = :year]);
        if(nextInvoiceMonths.isEmpty()) {
            return null;
        }
        
        return nextInvoiceMonths[0];
        
    }
    
}