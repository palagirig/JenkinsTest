global with sharing class Adv_AntizipationBatch_Temp implements Database.Batchable<SObject>, Schedulable {

    private String strParameter;
    private Boolean bDeleteKeys;
    private Boolean bUseNewQuery;

    public Adv_AntizipationBatch_Temp(String strParam, Boolean deleteKeys, Boolean useNewQuery) {
        strParameter = strParam;
        bDeleteKeys = deleteKeys;
        bUseNewQuery = useNewQuery;
    }

    private static SomDig_AntizipationsVS__c genericAZDistKey {
        get {
            if (genericAZDistKey == null) genericAZDistKey = [SELECT Id FROM SomDig_AntizipationsVS__c WHERE Name = 'Generischer Verteilungsschlüssel Rotation' ORDER BY LastModifiedDate LIMIT 1];
            return genericAZDistKey;
        }
        set;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {

        if(bDeleteKeys) deleteExistingDistributionKeys();

        String query = 'SELECT ADvendio__Site__c, ADvendio__Site__r.Name, SomDig_AntizipationsVS__c FROM ADvendio__Placement__c '+strParameter;
        return Database.getQueryLocator(query);
    }

    private void deleteExistingDistributionKeys() {
        // deletes all existing distribution keys except the standard/generic key.
        List<SomDig_AntizipationsVS__c> AZDistributionKeysToDelete = new List<SomDig_AntizipationsVS__c>([SELECT ID FROM SomDig_AntizipationsVS__c WHERE Name != 'Generischer Verteilungsschlüssel Rotation']);
        delete AZDistributionKeysToDelete;
    }

    global void execute(Database.BatchableContext bc, List<sObject> records) {
        datetime startdt = system.now();

        List<ADvendio__Placement__c> placements = (List<ADvendio__Placement__c>)records;
                insert new Lcm_Log__c(Lcm_Info_1__c=placements[0].Id, Lcm_Info_2__c=startdt.format('yyyy-MM-dd kk:mm:ss.SSS'), Lcm_Info_3__c='', Lcm_Info_4__c='35',Lcm_Info_5__c='Start', Lcm_Source__c='Adv_AntizipationBatch');

        // Store set of placement IDs.
        Set<ID> placementIDs = new Set<ID>();
        for(ADvendio__Placement__c placement : placements)
            placementIDs.add(placement.Id);

        // Get a Map of all delivery data for every placement record.
        Map<Id, List<ADvendio__DeliveryData__c>> placementToDeliveryDataMap = getPlacementToDeliveryDataMap(placementIDs);

        // Initiate AZDistributionKey & DistributionKey maps for later bulk insert.
        Map<Id, SomDig_AntizipationsVS__c> placementToAZDistributionKey = new Map<Id, SomDig_AntizipationsVS__c>();
        Map<Id, List<SomDig_Verteilungsschluessel__c>> placementToDistributionKey = new Map<Id, List<SomDig_Verteilungsschluessel__c>>();
        Map<Id, List<SomDig_Verteilungsschluessel__c>> placementToDistributionKeyWithoutAdServerID = new Map<Id, List<SomDig_Verteilungsschluessel__c>>();

        for(ADvendio__Placement__c placement : placements) {

            // if Werbeträger is NOT SevenOne Network
            if(placement.ADvendio__Site__r.Name != 'SevenOne Network') {

                placementToAZDistributionKey.put(placement.Id, new SomDig_AntizipationsVS__c());
                // these Distribution Keys without AdServerIDs are added to different list, and will get an AdServerIDs later in bulk.
                placementToDistributionKeyWithoutAdServerID.put(placement.Id, new List<SomDig_Verteilungsschluessel__c>{new SomDig_Verteilungsschluessel__c(SomDig_Prozentsatz__c = 100)});


            } else if(placementToDeliveryDataMap.containsKey(placement.Id) && !placementToDeliveryDataMap.get(placement.Id).isEmpty()) {
                // if Werbeträger is SevenOne Network & has delivery data

                // Get all the delivery data(not aggregated) related to this Placement.
                List<ADvendio__DeliveryData__c> deliveryDataList = placementToDeliveryDataMap.get(placement.Id);

                // Aggregate the delivery data
                Map<Id, Decimal> aggregatedMap = aggregateDeliveryData(deliveryDataList);

                // remove <1% to top.
                aggregatedMap = removeLowerPercentage(aggregatedMap);

                // Create Distribution Keys.
                List<SomDig_Verteilungsschluessel__c> distKeysToInsert = new List<SomDig_Verteilungsschluessel__c>();
                Decimal totalAmount = getTotalAmount(aggregatedMap);
                for(ID adServerID : aggregatedMap.keySet()) {
                    Decimal percentage = aggregatedMap.get(adServerId)/totalAmount;
                    distKeysToInsert.add(new SomDig_Verteilungsschluessel__c(SomDig_Prozentsatz__c = percentage*100, SomDig_AdServerId__c = adServerID));
                }

                placementToAZDistributionKey.put(placement.Id, new SomDig_AntizipationsVS__c());
                placementToDistributionKey.put(placement.Id, distKeysToInsert);

            } else { // if it doesn't have delivery data.

                // assign generic az dist key.
                placement.SomDig_AntizipationsVS__c = genericAZDistKey.Id;

            }

        }

        // Insert AZ Dist keys so they get an Id.
        insert placementToAZDistributionKey.values();

        // Fill Distribution Keys with missing adServerId.
        placementToDistributionKey.putAll(fillAdServerIDs(placementToDistributionKeyWithoutAdServerID));

        // Assign AZ Dist Keys IDs to child records(Dist Keys)
        List<SomDig_Verteilungsschluessel__c> distKeysToInsert = new List<SomDig_Verteilungsschluessel__c>();
        for(Id placementId : placementToDistributionKey.keySet()) {
            SomDig_AntizipationsVS__c AZDistKey = placementToAZDistributionKey.get(placementId);
            for(SomDig_Verteilungsschluessel__c distKey : placementToDistributionKey.get(placementId)) {
                distKey.SomDig_AntizipationsVS__c = AZDistKey.Id;
                distKeysToInsert.add(distKey);
            }
        }

        //Insert Dist Keys
        insert distKeysToInsert;

        // Assign AZ Dist Keys to Placements.
        for(ADvendio__Placement__c placement : placements) {
            if(placementToAZDistributionKey.containsKey(placement.Id)) {
                placement.SomDig_AntizipationsVS__c = placementToAZDistributionKey.get(placement.Id).Id;
            }
        }

        update placements;

                insert new Lcm_Log__c(Lcm_Info_1__c=placements[0].Id, Lcm_Info_2__c=startdt.format('yyyy-MM-dd kk:mm:ss.SSS'), Lcm_Info_3__c=system.now().format('yyyy-MM-dd kk:mm:ss.SSS'), Lcm_Info_4__c='120',Lcm_Info_5__c='End', Lcm_Source__c='Adv_AntizipationBatch');
    }

    global void finish(Database.BatchableContext bc){
    }

    global void execute(SchedulableContext sc) {
        Database.executeBatch(this, 5);
    }

    /*
    * For placement who are not SevenOne Network, we need to find the 'most parenty' adServerId. Here we query up to 5 levels.
    */
    private Map<Id, List<SomDig_Verteilungsschluessel__c>> fillAdServerIDs(Map<Id, List<SomDig_Verteilungsschluessel__c>> placementToDistributionKeyWithoutAdServerID) {

        Map<Id, Id> SiteToPlacementMap = new Map<Id, Id>();
        for(ADvendio__Placement__c placement : [SELECT ADvendio__Site__c FROM ADvendio__Placement__c WHERE ID IN :placementToDistributionKeyWithoutAdServerID.keySet()])
            SiteToPlacementMap.put(placement.Id, placement.ADvendio__Site__c);

        Map<Id, ADvendio__Site__c> sitesWithValidAdServerID = new Map<Id, ADvendio__Site__c>([SELECT Id, (SELECT ID FROM Advendio__AdServer_IDs__r WHERE ADvendio__Type__c = 'Ad Unit' AND (ADvendio__Parent_AdServer_ID__c = NULL OR ADvendio__Parent_AdServer_ID__r.ADvendio__Site__c = NULL) LIMIT 1) FROM ADvendio__Site__c WHERE ID IN :SiteToPlacementMap.values()]);

        for(ID placementID : placementToDistributionKeyWithoutAdServerID.keySet()) {
            Id siteId = SiteToPlacementMap.get(placementID);
            ADvendio__Site__c site = sitesWithValidAdServerID.get(siteId);
            placementToDistributionKeyWithoutAdServerID.get(placementID)[0].SomDig_AdServerId__c = !site.Advendio__AdServer_IDs__r.isEmpty() ? site.Advendio__AdServer_IDs__r[0].Id : null;
        }

        return placementToDistributionKeyWithoutAdServerID;
    }

    private Map<Id, Decimal> aggregateDeliveryData(List<ADvendio__DeliveryData__c> deliveryDataList) {
        Map<Id, Decimal> aggregatedMap = new Map<Id, Decimal>();

        // fill map with aggregated values.
        for(ADvendio__DeliveryData__c deliveryData : deliveryDataList) {
            if(aggregatedMap.containsKey(deliveryData.ADvendio__AdServerID__c)) {
                aggregatedMap.put(deliveryData.ADvendio__AdServerID__c, aggregatedMap.get(deliveryData.ADvendio__AdServerID__c)+deliveryData.ADvendio__DeliveredImpressions__c);
            } else {
                aggregatedMap.put(deliveryData.ADvendio__AdServerID__c, deliveryData.ADvendio__DeliveredImpressions__c);
            }
        }

        return aggregatedMap;
    }

    private Map<Id, Decimal> removeLowerPercentage(Map<Id, Decimal> aggregatedMap) {
        // store the total amount of ai
        Decimal totalAmount = getTotalAmount(aggregatedMap);

        // Find the keys that hold less than 1%, and reassign them to the one that has most Delivery Data.
        Set<Id> keysToDelete = new Set<Id>();
        for(Id adServerId : aggregatedMap.keySet()) {
            Decimal amount = aggregatedMap.get(adServerId);
            if( (amount/totalAmount)*100 < 1 ) {
                keysToDelete.add(adServerId);
            }
        }

        // Delete keys that hold than 1%
        for(Id idToDelete : keysToDelete) aggregatedMap.remove(idToDelete);

        return aggregatedMap;
    }

    //gets the sum of values (Delivered Impressions)
    private Decimal getTotalAmount(Map<Id, Decimal> aggregatedMap) {
        Decimal totalAmount = 0;
        for(Decimal ai : aggregatedMap.values())
            totalAmount = totalAmount + ai;
        return totalAmount;
    }

    // returns a map of all delivery data for a set of Placements.
    private Map<Id, List<ADvendio__DeliveryData__c>> getPlacementToDeliveryDataMap(Set<Id> placementIdSet) {
        Map<Id, List<ADvendio__DeliveryData__c>> placementToDeliveryData = new Map<Id, List<ADvendio__DeliveryData__c>>();

        Decimal thisYearMonth = Integer.valueOf(getYearMonthForDate(Date.today()));
        Decimal previousYearMonth = Integer.valueOf(getYearMonthForDate(Date.today().addMonths(-1)));
        Integer numberOfRows = 0;

        for(ADvendio__DeliveryData__c dd : (bUseNewQuery ? 
            [SELECT ADvendio__CampaignItem__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__Placement__c, ADvendio__AdServerID__c, ADvendio__DeliveredImpressions__c FROM ADvendio__DeliveryData__c WHERE ADvendio__Type__c = 'Monthly' AND ADvendio__CampaignItem__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__Ad_Type__r.RecordType.Name = 'DFP' AND ADvendio__CampaignItem__r.ADvendio__Rate_Discount_4_Name__c != 'Storno mit Leistungsfluss' AND ADvendio__CampaignItem__r.ADvendio__Rate_Discount_4_Name__c != 'Storno ohne Leistungsfluss' AND (SomDig_YearMonth__c >= :previousYearMonth) AND ADvendio__CampaignItem__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__Placement__c IN :placementIdSet]
            : 
            [SELECT ADvendio__CampaignItem__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__Placement__c, ADvendio__AdServerID__c, ADvendio__DeliveredImpressions__c FROM ADvendio__DeliveryData__c WHERE ADvendio__Type__c = 'Monthly' AND ADvendio__CampaignItem__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__Ad_Type__r.RecordType.Name = 'DFP' AND ADvendio__CampaignItem__r.ADvendio__Rate_Discount_4_Name__c != 'Storno mit Leistungsfluss' AND ADvendio__CampaignItem__r.ADvendio__Rate_Discount_4_Name__c != 'Storno ohne Leistungsfluss' AND (ADvendio__Month__c = THIS_MONTH OR ADvendio__Month__c = LAST_MONTH) AND ADvendio__CampaignItem__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__Placement__c IN :placementIdSet])) {
            numberOfRows++;
            ID placementId = dd.ADvendio__CampaignItem__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__Placement__c;

            if(placementToDeliveryData.containsKey(placementId)) {
                placementToDeliveryData.get(placementId).add(dd);
            } else {
                placementToDeliveryData.put(placementId, new List<ADvendio__DeliveryData__c> { dd });
            }
        }

        List<Id> listIDs = new List<Id>();
        listIDs.addAll(placementIdSet);
        insert new Lcm_Log__c(Lcm_Info_1__c=listIDs[0], Lcm_Info_2__c='Rows: '+numberOfRows, Lcm_Info_3__c='', Lcm_Info_4__c='216',Lcm_Info_5__c='getPlacementToDeliveryDataMap()', Lcm_Source__c='Adv_AntizipationBatch');

        return placementToDeliveryData;
    }

    private String getYearMonthForDate(Date dt) {
        String strYear = String.valueOf(dt.year());
        String strMonth = String.valueOf(dt.month());
        if(strMonth.length() == 1) strMonth = '0' + strMonth;
        return strYear + strMonth;
    }

}