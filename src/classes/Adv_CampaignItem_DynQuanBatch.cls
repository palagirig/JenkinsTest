global class Adv_CampaignItem_DynQuanBatch implements Database.Batchable<sObject>, Schedulable {

    private String query;
    
    private Date lastDate	= System.today().addDays(-3);

    public final static String DEFAULT_QUERY = 'SELECT Id,ADvendio__Prorated__c, ADvendio__Quantity__c, ADvendio__until_Date__c, (SELECT ID, SomDig_SumDeliveredImpressions__c, SomDig_BelegungseinheitTyp__c FROM ADvendio__PacketComponents__r) FROM ADvendio__Campaign_Item__c WHERE ADvendio__from_Date__c < TODAY AND ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__Distribution__c = \'Prorated\'';

	webservice static String startDynamicQuantityBatch(String campaignId) {
		if (campaignId != null && campaignId != '') {
			Adv_CampaignItem_DynQuanBatch qb	= new Adv_CampaignItem_DynQuanBatch();
			String query	= '';
			query	= Adv_CampaignItem_DynQuanBatch.DEFAULT_QUERY;
			query	+= ' AND Id = :campaignId';
			
			qb.execute(null, Database.query(query));
			
			return 'Die Mengen-Verteilung für die Position ist abgeschlossen';
		}
		return 'Bitte wähle eine Kampagnen-Position aus';
	}

    public Adv_CampaignItem_DynQuanBatch(){
        query = DEFAULT_QUERY;
        query += ' AND ADvendio__until_Date__c > :lastDate';
    }

    public Adv_CampaignItem_DynQuanBatch(String sQuery){
        query = sQuery;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<ADvendio__Campaign_Item__c> scope){
        List<ADvendio__Campaign_Item__c> listUpdateCIs = new List<ADvendio__Campaign_Item__c>();
        for (ADvendio__Campaign_Item__c objPaket : scope){
            
            if(objPaket.ADvendio__PacketComponents__r.size() < 2) continue;

            ADvendio__Campaign_Item__c ci1 = objPaket.ADvendio__PacketComponents__r[0];
            ADvendio__Campaign_Item__c ci2 = objPaket.ADvendio__PacketComponents__r[1];

            if(ci1.SomDig_BelegungseinheitTyp__c  != 'YouTube' && ci2.SomDig_BelegungseinheitTyp__c  != 'YouTube')
                continue;

            // If nothin was delivered, take 10 AI
            Decimal iDelivered1 = ci1.SomDig_SumDeliveredImpressions__c == 0 ? 10 : ci1.SomDig_SumDeliveredImpressions__c;
            Decimal iDelivered2 = ci2.SomDig_SumDeliveredImpressions__c == 0 ? 10 : ci2.SomDig_SumDeliveredImpressions__c;

            Decimal dQuan1 = objPaket.ADvendio__Quantity__c * (iDelivered1 / (iDelivered1 + iDelivered2));
            ci1.ADvendio__Quantity__c = iDelivered1 < iDelivered2 ? dQuan1.round(System.RoundingMode.UP) : dQuan1.round(System.RoundingMode.DOWN);
            ci2.ADvendio__Quantity__c = objPaket.ADvendio__Quantity__c - ci1.ADvendio__Quantity__c;

            ci1.ADvendio__Prorated__c = (ci1.ADvendio__Quantity__c/objPaket.ADvendio__Quantity__c)*100;
            ci2.ADvendio__Prorated__c = (ci2.ADvendio__Quantity__c/objPaket.ADvendio__Quantity__c)*100;

            listUpdateCIs.add(ci1);
            listUpdateCIs.add(ci2);
            
            objPaket.ADvendio__Prorated__c = objPaket.ADvendio__Prorated__c == null ? 100 : null;  
            listUpdateCIs.add(objPaket);
        }
        update listUpdateCIs;
    }

    global void finish(Database.BatchableContext BC){
    }

    global void execute(SchedulableContext sc) {
        Database.executebatch(new Adv_CampaignItem_DynQuanBatch());
    }
}