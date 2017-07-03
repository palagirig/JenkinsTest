/**
 * @Description this class will be a container for createTest methods as lpong as the Original data generator class is not changable (cls_P7S1_TestData)
**/


public without sharing class cls_P7S1_Temp_TestData
{
	
	public static final String nameOfAWonStage = [SELECT Masterlabel FROM OpportunityStage WHERE isWon=true].get(0).MasterLabel;

	public static Opportunity createTestOpportunity(Boolean insertObject, Account account, RecordType recordtype)
	{
		Opportunity result = cls_P7S1_TestData.createTestOpportunity(false, account, recordtype);
		result.SomTv_Jahr__c=String.valueOf(Date.today().year());
        result.CloseDate=System.today();
        result.Amount = 1000;
        result.Name='Test Opportunity';
		return result;

	}

      public static P7S1_EmailRecipients__c createTestRecipient(Boolean insertObject, String location, String recipients)
    {
        P7S1_EmailRecipients__c result = new P7S1_EmailRecipients__c();
        result.Name = location;
        result.P7S1_Location__c = location;
        result.P7S1_Recipients__c = recipients;
        if(insertObject)
            insert result;
        return result;
    }

    public static SomDig_Werbetraegergruppierung__c createTestWerbetraegerGruppierung(Boolean insertObject)
    {
        SomDig_Werbetraegergruppierung__c result = new SomDig_Werbetraegergruppierung__c();
        if(insertObject)
            insert result;
        return result;
    }

    public static SomDig_IaNummer__c createTestIaNummer(Boolean insertObject, SomDig_Werbetraegergruppierung__c werbetraegergruppierung, SomDig_Mediagattung__c medienGattung, SomDig_MediagattungsSegment__c mediaGattungsSegment, SomDig_MediagattungsDifferenzierung__c mediaGattungsDifferenzierung)
    {
        SomDig_IaNummer__c result = new SomDig_IaNummer__c();
        result.SomDig_Werbetraergergruppierung__c = werbetraegergruppierung.id;
        result.SomDig_Mediagattung__c = medienGattung.Id;
        result.SomDig_MediagattungsSegment__c = mediaGattungsSegment.Id;
        result.SomDig_MediagattungsDifferenzierung__c = mediaGattungsDifferenzierung.Id;

        result.SomDig_BeschreibungCO__c = 'Test IA Nummer 1';

        if(insertObject)
            insert result;
        return result;
    }

    
}