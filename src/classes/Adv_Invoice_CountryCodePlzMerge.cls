public with sharing class Adv_Invoice_CountryCodePlzMerge extends TriggerController {

    // Constructor
    public Adv_Invoice_CountryCodePlzMerge(Boolean isAfter, Boolean isBefore, Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate, List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems) {
        super(isAfter, isBefore, isDelete, isInsert, isUndelete, isUpdate, lstNewItems, mapNewItems, lstOldItems, mapOldItems);
    }

    protected override void runBeforeInsert() {
        mergeCountryCodeAndPostalCode((List<ADvendio__Invoice__c>) lstNewItems, NULL);
    }
    protected override void runBeforeUpdate() {
        mergeCountryCodeAndPostalCode((List<ADvendio__Invoice__c>) lstNewItems, (Map<Id, ADvendio__Invoice__c>)mapOldItems);
    }

    private static final String SEPARATOR = ' - ';

    public static void mergeCountryCodeAndPostalCode(List<ADvendio__Invoice__c> newInvoiceList, Map<Id, ADvendio__Invoice__c> oldInvoiceMap) {

    	for(ADvendio__Invoice__c objInvoice : newInvoiceList) {
    		if(Trigger.isInsert) { 
    			objInvoice.ADvendio__RecipientBillingPostalCode__c = getMergedCountryCodePostalCodeString(objInvoice);
    			objInvoice.ADvendio__RecipientBillingCountry__c = '';
    		} else {
    			ADvendio__Invoice__c objOldInvoice = oldInvoiceMap.get(objInvoice.Id);
	    		if(hasPostalCodeChanged(objInvoice, objOldInvoice) && hasBillingCountryChanged(objInvoice, objOldInvoice)) {
	    			objInvoice.ADvendio__RecipientBillingPostalCode__c = getMergedCountryCodePostalCodeString(objInvoice);
	    			objInvoice.ADvendio__RecipientBillingCountry__c = '';
	    		} else if(hasPostalCodeChanged(objInvoice, objOldInvoice)) {
    				objInvoice.ADvendio__RecipientBillingPostalCode__c = getMergedCountryCodePostalCodeString(objInvoice, objOldInvoice);
    				objInvoice.ADvendio__RecipientBillingCountry__c = '';
	    		} else if(hasBillingCountryChanged(objInvoice, objOldInvoice)) {
	    			objInvoice.ADvendio__RecipientBillingPostalCode__c = getMergedCountryCodePostalCodeString(objInvoice);
	    			objInvoice.ADvendio__RecipientBillingCountry__c = '';
	    		}
    		}
    	}

    }

    //Util method for strings.
    private static String replaceNull(String str) {
    	return str == null ? '' : str;
    }

    // Receives countrycode and postalcode as strings and merges them if both are set.
    // If any of them is blank, then the other value will be returned alone.
    private Static String mergeStrings(String countryCode, String postalCode) {
    	countryCode = replaceNull(countryCode);
    	postalCode = replaceNull(postalCode);
    	String mergedString;

    	if(countryCode == '' && postalCode == '') mergedString = '';
    	else if(countryCode == '') mergedString = postalCode;
    	else if(postalCode == '') mergedString = countryCode;
    	else mergedString = countryCode + SEPARATOR + postalCode;

		return mergedString;
    }

    // Merges countrycode and postal code from the same record.
    private static String getMergedCountryCodePostalCodeString(ADvendio__Invoice__c objInvoice) {
    	return mergeStrings(objInvoice.ADvendio__RecipientBillingCountry__c, objInvoice.ADvendio__RecipientBillingPostalCode__c);
    }

    // In case the already merged postalcode gets overwritten by only the postalcode, the countrycode is retrieved from trigger.old.
    private static String getMergedCountryCodePostalCodeString(ADvendio__Invoice__c objInvoice, ADvendio__Invoice__c objOldInvoice) {
    	return mergeStrings(extractCountryCode(objOldInvoice.ADvendio__RecipientBillingPostalCode__c), objInvoice.ADvendio__RecipientBillingPostalCode__c);
    }

    //Extracts the country code from an already merged PLZ & Country code string. Example: "D - 81667".
    private static String extractCountryCode(String mergedString) {
    	List<String> splittedString = mergedString.split(SEPARATOR);
        String countryCode = replaceNull(splittedString[0]);
        Pattern onePattern = Pattern.compile('[a-zA-Z]+');
        Matcher oneMatcher = onePattern.matcher(countryCode);
    	return oneMatcher.matches() ? countryCode : '';
    }

    //Checks if postalcode field has changed.
    private static Boolean hasPostalCodeChanged(ADvendio__Invoice__c objNewInvoice, ADvendio__Invoice__c objOldInvoice) {
    	return objNewInvoice.ADvendio__RecipientBillingPostalCode__c != objOldInvoice.ADvendio__RecipientBillingPostalCode__c;
    }

    //Checks if countrycode has changed.
    private static Boolean hasBillingCountryChanged(ADvendio__Invoice__c objNewInvoice, ADvendio__Invoice__c objOldInvoice) {
    	return objNewInvoice.ADvendio__RecipientBillingCountry__c != objOldInvoice.ADvendio__RecipientBillingCountry__c;
    }

}