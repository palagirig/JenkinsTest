/**
 * 	@author	Patrick Kaiser
 * 	@version 0.5
 */
public with sharing class Adv_MediaCampaign_Clone{
    private final Integer intBatchSize = 20;
    private ADvendio__MediaCampaign__c objNewMK;

    public Id idNewMK { get; set;}
    public Id jobId { get; set; }
    public Boolean keepPolling { get; set; }
    public Boolean doUrlReplace { get; set; }


    /**
     * Depending on the URL Parameters, this method can
     * 1. start the batch job, set flag to start the polling and set flag to do a url replace.(replace is done by javascript on the VF. this is to avoid the batch from restarting when refreshing page or navigating back to it.)
     * 2. start only the polling. (if jobId and newId url parameters are set, it means that the batch has already been started and we only need to poll for the status).
     */ 
    public void startCloneAndPolling() {
        try {
            if(ApexPages.currentPage().getParameters().containsKey('id')){
                cloneWithPositions();
                doUrlReplace = true;
                keepPolling = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'The Clone Batch job was started.'));
            } else if(ApexPages.currentPage().getParameters().containsKey('jobId') && ApexPages.currentPage().getParameters().containsKey('newId')) {
                jobId = (ID)ApexPages.currentPage().getParameters().get('jobId');
                idNewMK = (ID)ApexPages.currentPage().getParameters().get('newId');
                objNewMK = [SELECT ID, Name FROM ADvendio__MediaCampaign__c WHERE ID = :idNewMK];
                pollJobStatus();
                doUrlReplace = false;
                keepPolling = true;
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Mediacampaign ID specified.'));
                keepPolling = false;
            }
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Fehler: ' + e.getMessage()));
        }
    }

    /**
     * Queries for the status of the batch job. Adds an apexpage message depending on the status.
     * Also queries for Batchlog records, which are used to notify the user about things happening in the cloning process e.g reasons of skipped positions.
     */
    public void pollJobStatus() {
        AsyncApexJob job = [SELECT JobItemsProcessed, TotalJobItems, Status, ExtendedStatus, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobId];
        if(job.Status == 'Queued' || job.Status == 'Holding' || job.Status == 'Preparing') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'The Clone Batch job is in status: '+job.Status.toLowerCase()+'.'));
        } else if(job.Status == 'Processing') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'The Clone Batch job is processing: '+Math.floor(100.0*job.JobItemsProcessed/job.TotalJobItems)+'%...'));
        } else if(job.Status == 'Aborted') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Clone Batch job was aborted.'));
            keepPolling = false;
        } else if(job.Status == 'Failed') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Clone Batch job failed. <br/> '+job.ExtendedStatus));
            keepPolling = false;
        }  else if(job.Status == 'Completed' && job.ExtendedStatus != null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Clone Batch job completed with errors in  '+job.NumberOfErrors+'/'+job.TotalJobItems+' jobs. <br/> Link to new Mediacampaign: <a href=/'+objNewMK.Id+'>'+objNewMK.Name+'</a> <br/> Errors:<br/> '+job.ExtendedStatus));
            keepPolling = false;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'The job is now '+job.Status.toLowerCase()+'. Link to new Mediacampaign: <a href=/'+objNewMK.Id+'>'+objNewMK.Name+'</a>'));
            keepPolling = false;
        }

        List<Lcm_BatchLog__c> listBatchLogs = new List<Lcm_BatchLog__c>([SELECT Lcm_Message__c FROM Lcm_BatchLog__c WHERE Lcm_AsyncApexJobId__c = :jobId]);
        for(Lcm_BatchLog__c objBatchLog : listBatchLogs) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, objBatchLog.Lcm_Message__c));
        }

    }

    /**
     * 	Clones an ADvendio__MediaCampaign__c from the current ApexPage, with all valid ADvendio__Campaign_Item__c
     */
    public void cloneWithPositions(){       
        Id idOldMK = ApexPages.currentPage().getParameters().get('id');
        objNewMK = cloneMediaCampaignById(IDOldMK);
        idNewMK = objNewMK.Id;

        // Call Batch
        Adv_MediaCampaign_Clone_Batch job = new Adv_MediaCampaign_Clone_Batch(idOldMK, objNewMK);
        jobId = Database.executeBatch(job, intBatchSize);

        
    }    
    
    /**
     * 	Clones an ADvendio__MediaCampaign__c with all valid ADvendio__Campaign_Item__c.
     * 		Only ADvendio__Campaign_Item__c with ADvendio__Rate_Discount_4_Name__c equals 'InPage', 'InStream' 
     * 		or 'Positionsrabatt Natural' are inserted, if the have an activ ADvendio__Ad_Price__c
     * 
     * 	@param idMediaCamp The id of the ADvendio__MediaCampaign__c which should be cloned
     * 	@return returns the inserted ADvendio__MediaCampaign__c with all its valid ADvendio__Campaign_Item__c. 
     */
    public static ADvendio__MediaCampaign__c cloneMediaCampaignById(Id idMediaCamp){
        ADvendio__MediaCampaign__c objSourceMK = [SELECT ID, SomDig_BetreuerTeam__c, CurrencyIsoCode, ADvendio__Quote_Locale__c, ADvendio__Quote_Language__c, 
                                              		ADvendio__BillMe__c, ADvendio__TermsOfPayment__c, ADvendio__PaymentDueDate__c, ADvendio__PaymentStart__c, 
                                                    ADvendio__PaymentInterval__c, SomDig_RabatteMKgenehmigt__c, SomDig_Commitment__c, SomDig_Agenturrabatt__c, 
                                                    ADvendio__Rate_Discount_2__c, SomDig_Naturalrabatt_Inpage__c, SomDig_Sonderrabatt_InPage__c,
                                                    SomDig_Kundenrabatt_InStream__c, SomDig_Kundenrabatt_InPage__c, ADvendio__Document_type__c, ADvendio__Stage__c, 
                                                    ADvendio__Pricelist__c, ADvendio__invoice_recipient__c, SomDig_WtAgBeziehung__c, SomDig_AdManager__c, 
                                                    SomDig_BetreuerPam__c, Name, SomDig_BetreuerSales__c, SomDig_Sonderrabatt_InStream__c, SomDig_SACConceptionManager__c,
                                                    ADvendio__external_Media_Campaign_Name__c, ADvendio__Tax__c, ADvendio__PostalRecipient__c, SomDig_Zahlungsbedingung__c,
                                                    SomDig_ProgrammaticGuaranteed__c, SomDig_Restwerbezeit__c
                                                    	FROM ADvendio__MediaCampaign__c 
                                                        WHERE ID = :idMediaCamp 
                                                        LIMIT 1];      
                        
        ADvendio__MediaCampaign__c objNewMK = cloneMediaCampaign(objSourceMK);
        insert objNewMK;
                
        cloneMediaCampaignContacts(objNewMK, idMediaCamp);

        return objNewMK;
    }
    
    /**
     *  Creates a flat copy for the given ADvendio__MediaCampaign__c.
     * 		The flat copy has the stage 'Potential' and the documentyp 'Angebot'.
     * 		The ADvendio__MediaCampaign__c will not be inserted in the methode.
     *  
     *  @param objSourceMK ADvendio__MediaCampaign__c which should be cloned
     *  @return The flat copy for the given ADvendio__MediaCampaign__c
     */
    public static ADvendio__MediaCampaign__c cloneMediaCampaign(ADvendio__MediaCampaign__c objSourceMK){
        ADvendio__MediaCampaign__c objNewMK = new ADvendio__MediaCampaign__c();    
        objNewMK.Name = 'CLONE_'+objSourceMK.Name;
        objNewMK.ADvendio__Stage__c = 'First Contact';
        objNewMK.ADvendio__Document_type__c = 'Angebot';
        objNewMK.ADvendio__external_Media_Campaign_Name__c = objSourceMK.ADvendio__external_Media_Campaign_Name__c != null ? 'CLONE_'+objSourceMK.ADvendio__external_Media_Campaign_Name__c : null;
        objNewMK.SomDig_RabatteMKgenehmigt__c = true;
        
        objNewMK.SomDig_BetreuerSales__c = objSourceMK.SomDig_BetreuerSales__c;
        objNewMK.SomDig_BetreuerPam__c = objSourceMK.SomDig_BetreuerPam__c;
        objNewMK.SomDig_AdManager__c = objSourceMK.SomDig_AdManager__c;
        objNewMK.SomDig_BetreuerTeam__c = objSourceMK.SomDig_BetreuerTeam__c;
        objNewMK.SomDig_WtAgBeziehung__c = objSourceMK.SomDig_WtAgBeziehung__c;
        objNewMK.ADvendio__invoice_recipient__c = objSourceMK.ADvendio__invoice_recipient__c;
        objNewMK.ADvendio__Pricelist__c = objSourceMK.ADvendio__Pricelist__c;
        objNewMK.SomDig_Kundenrabatt_InPage__c = objSourceMK.SomDig_Kundenrabatt_InPage__c;
        objNewMK.SomDig_Kundenrabatt_InStream__c = objSourceMK.SomDig_Kundenrabatt_InStream__c;
        objNewMK.SomDig_Sonderrabatt_InPage__c = objSourceMK.SomDig_Sonderrabatt_InPage__c;
        objNewMK.SomDig_Sonderrabatt_InStream__c = objSourceMK.SomDig_Sonderrabatt_InStream__c;
        objNewMK.SomDig_Naturalrabatt_Inpage__c = objSourceMK.SomDig_Naturalrabatt_Inpage__c;
        objNewMK.ADvendio__Rate_Discount_2__c = objSourceMK.ADvendio__Rate_Discount_2__c;
        objNewMK.SomDig_Agenturrabatt__c = objSourceMK.SomDig_Agenturrabatt__c;
        objNewMK.SomDig_Commitment__c = objSourceMK.SomDig_Commitment__c;
        objNewMK.ADvendio__PaymentInterval__c = objSourceMK.ADvendio__PaymentInterval__c;
        objNewMK.ADvendio__PaymentStart__c = objSourceMK.ADvendio__PaymentStart__c;
        objNewMK.ADvendio__PaymentDueDate__c = objSourceMK.ADvendio__PaymentDueDate__c;
        objNewMK.ADvendio__TermsOfPayment__c = objSourceMK.ADvendio__TermsOfPayment__c;
        objNewMK.ADvendio__Quote_Language__c = objSourceMK.ADvendio__Quote_Language__c;
        objNewMK.ADvendio__Quote_Locale__c = objSourceMK.ADvendio__Quote_Locale__c;
        objNewMK.CurrencyIsoCode = objSourceMK.CurrencyIsoCode;  
        objNewMK.ADvendio__Tax__c = objSourceMK.ADvendio__Tax__c;
        objNewMK.ADvendio__PostalRecipient__c = objSourceMK.ADvendio__PostalRecipient__c;
        objNewMK.SomDig_SACConceptionManager__c = objSourceMK.SomDig_SACConceptionManager__c;
        objNewMK.SomDig_Zahlungsbedingung__c = objSourceMK.SomDig_Zahlungsbedingung__c;
        objNewMK.SomDig_ProgrammaticGuaranteed__c = objSourceMK.SomDig_ProgrammaticGuaranteed__c;
        objNewMK.SomDig_Restwerbezeit__c = objSourceMK.SomDig_Restwerbezeit__c;

        return objNewMK;
    }

    public static void cloneMediaCampaignContacts(ADvendio__MediaCampaign__c objNewMK, ID idOldMK) {
        List<ADvendio__Campaign_Contact__c> listCampaignContacts = new List<ADvendio__Campaign_Contact__c>();
        for(ADvendio__Campaign_Contact__c objSourceCampaignContact : [SELECT ADvendio__Campaign_Contact_Role__c, ADvendio__Contact__c, ADvendio__InvoiceContact__c, ADvendio__Primary_Contact__c, ADvendio__QuoteContact__c FROM ADvendio__Campaign_Contact__c WHERE ADvendio__Media_Campaign__c = :idOldMK]) {
            ADvendio__Campaign_Contact__c objNewCampaignContact = objSourceCampaignContact.clone(false);
            objNewCampaignContact.ADvendio__Media_Campaign__c = objNewMK.Id;
            listCampaignContacts.add(objNewCampaignContact);
        }
        insert listCampaignContacts;
    }
}