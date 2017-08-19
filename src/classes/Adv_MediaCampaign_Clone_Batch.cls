global class Adv_MediaCampaign_Clone_Batch implements Database.Batchable<Adv_MediaCampaign_Clone_CampItem> {
	
	Id idOriginalMK;
    Id jobId;
	ADvendio__MediaCampaign__c objNewMK;
    List<Lcm_BatchLog__c> listBatchLogs = new List<Lcm_BatchLog__c>();

	global Adv_MediaCampaign_Clone_Batch(id idOriginalMK, ADvendio__MediaCampaign__c objNewMK) {
		this.idOriginalMK = idOriginalMK;
		this.objNewMK = objNewMK;
	}
	
	global Iterable<Adv_MediaCampaign_Clone_CampItem> start(Database.BatchableContext BC) {
        jobId = BC.getJobId();
		List<ADvendio__Campaign_Item__c> listSourceCI = new List<ADvendio__Campaign_Item__c>([SELECT ID, ADvendio__Prorated__c, SomDig_SourceCampaignItem__c, ADvendio__PacketItem__c, RecordType.DeveloperName, 
                                                                                           RecordTypeID, ADvendio__Rate_Discount_4_Name__c, ADvendio__Rate_Discount_4__c, ADvendio__Rate_Discount_3_custom__c, 
                                                                                           ADvendio__Rate_Discount_2_custom__c, ADvendio__AC__c, ADvendio__Sales_Price__c, ADvendio__RateDiscount2Name__c, Name,
                                                                                           ADvendio__Billing_category__c, ADvendio__Media_Campaign__c, ADvendio__Agency_Commission__c, SomDig_OtpAufschlag__c, 
                                                                                           ADvendio__Quantity__c, SomDig_Menge__c, SomDig_Naturalrabatt__c, ADvendio__until_Date__c, ADvendio__from_Date__c, ADvendio__Ad_Price__c, 
                                                                                           ADvendio__SortOrder__c, ADvendio__Ad_Price__r.ADvendio__Active__c, ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_FC__c,
                                                                                           ADvendio__FC_Quantity__c, ADvendio__FC_Ad_served_every__c, ADvendio__FC_Period__c,
                                                                                           ADvendio__AdHourOfDay__c, ADvendio__AdDayOfWeek__c, ADvendio__Targetingabbrevation__c,
                                                                                           ADvendio__AdOperatingSystems__c, ADvendio__AdWebBrowsers__c, SomDig_ADGapID__c,
                                                                                           ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_GtFaehig__c, 
                                                                                           SomDig_retargeting__c, ADvendio__Ad_Spec__c,
                                                                                           ADvendio__ad_price__r.ADvendio__list_price__c, 
                                                                                           ADvendio__ad_price__r.ADvendio__Valid_from__c,  ADvendio__ad_price__r.ADvendio__Valid_to__c,
                                                                                           ADvendio__ad_price__r.ADvendio__Pricelist__c, ADvendio__ad_price__r.ADvendio__RateCriterion__c,
                                                                                           ADvendio__ad_price__r.ADvendio__ad_spec__r.SomDig_fcaufschlag__c, 
                                                                                           ADvendio__ad_price__r.ADvendio__ad_spec__r.SomDig_mediagattungsdifferenzierung__c, 
                                                                                           ADvendio__ad_price__r.ADvendio__ad_spec__r.SomDig_targetingaufschlag__c, 
                                                                                           ADvendio__ad_price__r.ADvendio__ad_spec__r.SomDig_retargetingsurcharge__c, 
                                                                                           ADvendio__ad_price__r.ADvendio__ad_spec__r.SomDig_rotationexclusionsurcharge__c,
                                                                                           ADvendio__ad_price__r.ADvendio__ad_spec__r.SomDig_rotationstyp__c,
                                                                                           ADvendio__ad_price__r.ADvendio__ad_spec__r.SomDig_otpaufschlag__c,
                                                                                           ADvendio__ad_price__r.ADvendio__ad_spec__r.ADvendio__distribution__c,
                                                                                           ADvendio__Frequency__c

                                                                                                FROM ADvendio__Campaign_Item__c 
                                                                                                WHERE ADvendio__Media_Campaign__c = :idOriginalMK 
                                                                                                    AND ADvendio__Rate_Discount_4_Name__c != 'Storno mit Leistungsfluss' 
                                                                                                    AND ADvendio__Rate_Discount_4_Name__c != 'Storno ohne Leistungsfluss'
                                                                                                    AND ADvendio__Rate_Discount_4_Name__c != 'Kompensation' 
                                                                                                    AND ADvendio__Rate_Discount_4_Name__c != 'Nachlieferung'
                                                                                                    AND (NOT ADvendio__PositionNumberAppendix__c LIKE '.%')
                                                                                                    AND ADvendio__ConnectedItem__c = null]);        
        
        listSourceCI = cleanCampItemList(listSourceCI);
        
        List<Adv_MediaCampaign_Clone_CampItem> listWrappedCI = wrapCampItems(listSourceCI, objNewMK);
        resetQuantityOnProratedComponents(listWrappedCI);
        insert listBatchLogs;
		return listWrappedCI;
	}

   	global void execute(Database.BatchableContext BC, List<Adv_MediaCampaign_Clone_CampItem> scope) {
		cloneCampaignItems(scope);
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}

    /**
     * Helper method to add Batch log records. These will be queried by the polling on the VF-Page. Used for notifying the user of things happening during the cloning process.
     */
    private void addBatchLog(ADvendio__Campaign_Item__c objCI, String reason) {
        listBatchLogs.add(new Lcm_BatchLog__c(Lcm_AsyncApexJobId__c = jobId, Lcm_Message__c = Label.Adv_MediaCampaign_CouldNotCopy + ' <a href="/'+objCI.Id+'">'+objCI.Name+'</a>. '+reason));
    }

    /**
     * Packages with Prorated distribution could have their original distribution modified during the availability check or dynamic quantity process.
     * This method resets it to the original distribution.
     *
     * @param listWrappedCI a list of wrapped campaign items.
     * @return the list of wrapped campaign items with their quantity and prorated ratio resetted.
     */
    private void resetQuantityOnProratedComponents(List<Adv_MediaCampaign_Clone_CampItem> listWrappedCI) {
        Set<Id> setAdSpecIDs = new Set<Id>();
        List<Adv_MediaCampaign_Clone_CampItem> listWrappedPackages = new List<Adv_MediaCampaign_Clone_CampItem>();

        for(Adv_MediaCampaign_Clone_CampItem objWrappedCI : listWrappedCI) {
            if(objWrappedCI.isPackage()) {
                setAdSpecIDs.add(objWrappedCI.getAdSpecID());
                listWrappedPackages.add(objWrappedCI);
            } 
        } 

        Map<id, ADvendio__Ad_Specs__c> mapAdSpecs = new Map<Id, ADvendio__Ad_Specs__c>([SELECT Id, ADvendio__Distribution__c, (SELECT ADvendio__Prorated__c, ADvendio__PacketAdSpec__c, ADvendio__ComponentAdSpec__c, ADvendio__ComponentAdPrice__c, ADvendio__PacketItemAdPrice__c FROM ADvendio__PacketComponents__r) FROM ADvendio__Ad_Specs__c WHERE ID IN :setAdSpecIDs]);
        Map<String, ADvendio__PacketComponent__c> mapPackageComponent = fillMapPackageComponents(mapAdSpecs);

        for(Adv_MediaCampaign_Clone_CampItem objWrappedCIHeader : listWrappedPackages) {
            ADvendio__Ad_Specs__c objAdSpec = mapAdSpecs.get(objWrappedCIHeader.getAdSpecId());
            List<Adv_MediaCampaign_Clone_CampItem> listComponents = objWrappedCIHeader.getComponents();

            Decimal packageQuantity = objWrappedCIHeader.getQuantity();
            Decimal packageMenge = objWrappedCIHeader.getMenge();

            for(Adv_MediaCampaign_Clone_CampItem objComponent : listComponents) {
                if(objAdSpec.ADvendio__Distribution__c == 'Prorated') {
                    String key = ''+objAdSpec.Id+objComponent.getAdSpecId()+objComponent.getAdPriceId();
                    Decimal proratedRatio = mapPackageComponent.get(key).ADvendio__Prorated__c;
                    Decimal proratedQuantity = packageQuantity*(proratedRatio/100);
                    Decimal proratedMenge = packageMenge*(proratedRatio/100);
                    objComponent.setProrated(proratedRatio);
                    objComponent.setQuantity(proratedQuantity);
                    objComponent.setMenge(proratedMenge);
                } 
            }
        }

    }

    /**
     * Creates a map that given a combination of package header adSpec, package component adspec and package component adPrice, returns a PackageComponent record containing the original prorated distribution ratio.
     *
     * @param mapAdSpecs Map that returns an AdSpec record with PackageComponent child records given an AdSpecId.
     * @return the map containing a prorated distributon ratio.
     */
    private Map<String, ADvendio__PacketComponent__c> fillMapPackageComponents(Map<id, ADvendio__Ad_Specs__c> mapAdSpecs) {
        Map<String, ADvendio__PacketComponent__c> mapPackageComponent = new Map<String, ADvendio__PacketComponent__c>();
        for(ADvendio__Ad_Specs__c objAdSpec : mapAdSpecs.values()) {
            for(ADvendio__PacketComponent__c objPackageComponent : objAdSpec.ADvendio__PacketComponents__r) {
                mapPackageComponent.put(''+objAdSpec.Id+objPackageComponent.ADvendio__ComponentAdSpec__c+objPackageComponent.ADvendio__ComponentAdPrice__c, objPackageComponent);
            }
        }
        return mapPackageComponent;
    }
	
	/**
     * 	Removing the ADvendio__Campaign_Item__c from the list, which should not be inserted.
     * 		- Removing all ADvendio__Campaign_Item__c, where the adspec is inactiv
     * 		- Removing all ADvendio__Campaign_Item__c, which are packagecomponente and where 
     * 			the adspec is inactiv or an other part of the package has an inactiv adspec 
     * 
     *  @param listCampItems the unfiltered list of ADvendio__Campaign_Item__c, which should be checked for insertion
     * 	@return the list of ADvendio__Campaign_Item__c, which can be inserted for the copied media campaign
     */
    private List<ADvendio__Campaign_Item__c> cleanCampItemList(List<ADvendio__Campaign_Item__c> listCampItems){
        Set<Id> setBadIds = new Set<Id>();
        
        /*	Filling the setBadIds with the ids from ADvendio__Campaign_Item__c which should not be inserted.
         * 		- Adding all ids from ADvendio__Campaign_Item__c where the adspec is inactiv
         * 		- Adding all ids from packageheader where a component has an inactiv adspec
         * 		- Removing all ADvendio__Campaign_Item__c from the list, where the adspec is inactiv
         */
        for(Integer i=0;i<listCampItems.size();i++){
            if(!listCampItems[i].ADvendio__Ad_Price__r.ADvendio__Active__c || isAdPriceOutdated(listCampItems[i])){
                String reason = isAdPriceOutdated(listCampItems[i]) ? Label.Adv_MediaCampaign_AdPriceOutdated : Label.Adv_MediaCampaign_AdPriceInactive;
                addBatchLog(listCampItems[i], reason);
                setBadIds.add(listCampItems[i].Id);
                if(listCampItems[i].ADvendio__PacketItem__c != null) setBadIds.add(listCampItems[i].ADvendio__PacketItem__c);
                listCampItems.remove(i--);
            }
        }
        
        /* 	- Removing all ADvendio__Campaign_Item__c, where the package header has an inactiv adspec.
         * 	- Removing all ADvendio__Campaign_Item__c, where an other package component has an inactiv adspec
         */
        for(Integer i=0;i<listCampItems.size();i++){
            if(setBadIds.contains(listCampItems[i].Id) || setBadIds.contains(listCampItems[i].ADvendio__PacketItem__c)){
                listCampItems.remove(i--);
            }
        }
        return listCampItems;
    }

    private Boolean isAdPriceOutdated(ADvendio__Campaign_Item__c objCI) {
        return ((objCI.ADvendio__Ad_Price__r.ADvendio__Valid_from__c != null && objCI.ADvendio__Ad_Price__r.ADvendio__Valid_from__c > Date.today()) || (objCI.ADvendio__Ad_Price__r.ADvendio__Valid_to__c != null && objCI.ADvendio__ad_price__r.ADvendio__Valid_to__c < Date.today()));
    }
    
    /**
     *	Wrapping all valid Advendio__Campaign_Item__c for the given Advendio__MediaCampaign__c.
     * 		In the first step all packageheader are wrapped.
     *		In the second step all packagecomponents getting wrapped and associated to their headers.
     *		In the third step all associated targetings, such as geo targeting and key values are added
     *			to the wrappers
	 *
	 * @param	listCampItems, the filtered list of wrapped campaigns items which should be cloned
	 * @param	objCamp, the Advendio__MediaCampaign__c for the campaign items
	 * @return	a list of wrapped ADvendio__Campaign_Item__c to save all the necessary data for the cloning,
	 *			the list only contains packageheaders and standardpositions
     */
    private List<Adv_MediaCampaign_Clone_CampItem> wrapCampItems(List<ADvendio__Campaign_Item__c> listCampItems, ADvendio__MediaCampaign__c objCamp){
        Map<Id, Adv_MediaCampaign_Clone_CampItem> mapWrappedCI = new Map<Id, Adv_MediaCampaign_Clone_CampItem>();
        Map<Id, Adv_MediaCampaign_Clone_CampItem> mapWrappedCIWithComponents = new Map<Id, Adv_MediaCampaign_Clone_CampItem>();

        // Wrapping all package-header
        mapWrappedCI = wrapPackageHeaders(listCampItems, objCamp);

        // Wrapping package-components and standard campaign items
        for(ADvendio__Campaign_Item__c objCampItem :listCampItems){
        	if(objCampItem.ADvendio__PacketItem__c != null){
        		Adv_MediaCampaign_Clone_CampItem component = new Adv_MediaCampaign_Clone_CampItem(objCampItem, objCamp, preventSurchargeCountries);
        		Adv_MediaCampaign_Clone_CampItem header = mapWrappedCI.get(objCampItem.ADvendio__PacketItem__c);
        		header.addComponent(component);
        		mapWrappedCIWithComponents.put(objCampItem.Id,component);
        	}
        	else{
        		mapWrappedCI.put(objCampItem.Id, new Adv_MediaCampaign_Clone_CampItem(objCampItem, objCamp, preventSurchargeCountries));
        	}
        }

        mapWrappedCIWithComponents.putAll(mapWrappedCI);

        saveGeoTargeting(mapWrappedCIWithComponents);
		saveKeyValues(mapWrappedCIWithComponents);
        
		return mapWrappedCI.values();
    }

    /**
     *	Wrapping of all the geo targeting junction objects (ADvendio__Selected_City__c,
     *		ADvendio__Selected_Region__c, ADvendio__Selected_Country__c). The junctions are added to
     *		the given Adv_MediaCampaign_Clone_CampItem in the mapWrappedCI.
     *
     *	@param	mapWrappedCI, a map with all wrapped ADvendio__Campaign_Item__c and their ID as kay
     */
    private void saveGeoTargeting(Map<Id, Adv_MediaCampaign_Clone_CampItem> mapWrappedCI){
    	saveCityTargeting(mapWrappedCI);
    	saveCountryTargeting(mapWrappedCI);
    	saveRegionTargeting(mapWrappedCI);
        savePostalCodeTargeting(mapWrappedCI);
    }

    /**
     *	Wrapping of all the ADvendio__Selected_City__c junction objects 
	 *
     *	@param	mapWrappedCI, a map with all wrapped ADvendio__Campaign_Item__c and their ID as kay
     */
    private void saveCityTargeting(Map<Id, Adv_MediaCampaign_Clone_CampItem> mapWrappedCI){
    	List<ADvendio__Selected_City__c> listCities = [SELECT Id, ADvendio__City__c, ADvendio__Campaign_Item__c, ADvendio__City__r.Name
        												FROM ADvendio__Selected_City__c
        												WHERE ADvendio__Campaign_Item__c in :mapWrappedCI.keySet()
        													AND ADvendio__Campaign_Item__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_GtFaehig__c = true
                                                            AND ADvendio__Campaign_Item__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_targetingaufschlag__c != null];
       	for(ADvendio__Selected_City__c objCity :listCities){
       		mapWrappedCI.get(objCity.ADvendio__Campaign_Item__c).addCity(objCity);
       	}
    }

    /**
     *	Wrapping of all the ADvendio__Selected_Country__c junction objects 
	 *
     *	@param	mapWrappedCI, a map with all wrapped ADvendio__Campaign_Item__c and their ID as kay
     */
    private void saveCountryTargeting(Map<Id, Adv_MediaCampaign_Clone_CampItem> mapWrappedCI){
    	List<ADvendio__Selected_Country__c> listCountries = [SELECT Id, ADvendio__Country__c, ADvendio__Campaign_Item__c, ADvendio__Country__r.Name
        												FROM ADvendio__Selected_Country__c
        												WHERE ADvendio__Campaign_Item__c in :mapWrappedCI.keySet()
        													AND ADvendio__Campaign_Item__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_GtFaehig__c = true
                                                            AND ADvendio__Campaign_Item__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_targetingaufschlag__c != null];
       	for(ADvendio__Selected_Country__c objCountry :listCountries){
   			mapWrappedCI.get(objCountry.ADvendio__Campaign_Item__c).addCountry(objCountry);
       	}
    }

    /**
     *	Wrapping of all the ADvendio__Selected_Region__c junction objects 
	 *
     *	@param	mapWrappedCI, a map with all wrapped ADvendio__Campaign_Item__c and their ID as kay
     */
    private void saveRegionTargeting(Map<Id, Adv_MediaCampaign_Clone_CampItem> mapWrappedCI){
    	List<ADvendio__Selected_Region__c> listRegions = [SELECT Id, ADvendio__Region__c, ADvendio__Campaign_Item__c, ADvendio__Region__r.Name
        												FROM ADvendio__Selected_Region__c
        												WHERE ADvendio__Campaign_Item__c in :mapWrappedCI.keySet()
        													AND ADvendio__Campaign_Item__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_GtFaehig__c = true
                                                            AND ADvendio__Campaign_Item__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_targetingaufschlag__c != null];
       	for(ADvendio__Selected_Region__c objRegion :listRegions){
       		mapWrappedCI.get(objRegion.ADvendio__Campaign_Item__c).addRegion(objRegion);
       	}
    }

    private void savePostalCodeTargeting(Map<Id, Adv_MediaCampaign_Clone_CampItem> mapWrappedCI) {
        List<ADvendio__SelectedAdServerId__c> listPostalCodes = [SELECT Id, ADvendio__AdServerId__c, ADvendio__CampaignItem__c, ADvendio__AdServerId__r.Name
                                                                        FROM ADvendio__SelectedAdServerId__c
                                                                        WHERE ADvendio__CampaignItem__c IN :mapWrappedCI.keySet()
                                                                        AND ADvendio__AdServerId__r.ADvendio__Type__c = 'Postal Code'];
        for(ADvendio__SelectedAdServerId__c objPostalCode : listPostalCodes) {
            mapWrappedCI.get(objPostalCode.ADvendio__CampaignItem__c).addPostalCode(objPostalCode);
        }
    }

    private void saveKeyValues(Map<Id, Adv_MediaCampaign_Clone_CampItem> mapWrappedCI){
    	List<ADvendio__KeyLine__c> listKeyLines = [SELECT ADvendio__CampaignItem__c, Name, ADvendio__CampaignItem__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_targetingaufschlag__c,
													(SELECT ADvendio__Key__c,ADvendio__Key__r.ADvendio__AdServerId__r.Name,ADvendio__Key__r.Name,Advendio__Key__r.ADvendio__ExternalName__c,ADvendio__Key__r.SomDig_TargetingProvider__c,ADvendio__KeyLine__r.ADvendio__CampaignItem__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_Targeting_Provider__c,ADvendio__Value__c,ADvendio__KeyLine__c,ADvendio__FreeformValue__c,Name,ADvendio__Operator__c,ADvendio__Values__c,SomDig_Campaign_Item__c 
														FROM ADvendio__KeyValues__r) 
													FROM ADvendio__KeyLine__c
													WHERE ADvendio__CampaignItem__c in :mapWrappedCI.keySet()
                                                        AND ADvendio__CampaignItem__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_targetingaufschlag__c != null
                                                        AND ADvendio__CampaignItem__r.ADvendio__Ad_Price__r.SomDig_KeyValueTargetingUnterbunden__c = false];

		for(ADvendio__KeyLine__c objKeyLine : listKeyLines){
			Adv_MediaCampaign_Clone_KeyLine wrapperKeyLine = new Adv_MediaCampaign_Clone_KeyLine(objKeyLine);
			for(ADvendio__KeyValue__c objKeyValue :objKeyLine.ADvendio__KeyValues__r){
                if(adSpecTargetingProvidersContainsKeyTargetingProvider(objKeyValue)) wrapperKeyLine.addKeyValue(objKeyValue);
			}
            if(wrapperKeyLine.size() > 0) mapWrappedCI.get(objKeyLine.ADvendio__CampaignItem__c).addKeyLine(wrapperKeyLine);
		}
    }

    private Boolean adSpecTargetingProvidersContainsKeyTargetingProvider(ADvendio__KeyValue__c objKeyValue) {
        String adSpecTargetingProviders = objKeyValue.ADvendio__KeyLine__r.ADvendio__CampaignItem__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_Targeting_Provider__c;
        String keyTargetingProvider = objKeyValue.ADvendio__Key__r.SomDig_TargetingProvider__c;
        return (adSpecTargetingProviders != null && keyTargetingProvider != null && adSpecTargetingProviders.contains(keyTargetingProvider));
    }

    private Map<Id, Adv_MediaCampaign_Clone_CampItem> wrapPackageHeaders(List<ADvendio__Campaign_Item__c> listCampItems, ADvendio__MediaCampaign__c objCamp){
    	Map<Id, Adv_MediaCampaign_Clone_CampItem> mapWrappedCI = new Map<Id, Adv_MediaCampaign_Clone_CampItem>();

    	for(Integer i=0; i<listCampItems.size(); i++){
        	ADvendio__Campaign_Item__c objCampItem = listCampItems.get(i);

        	if(objCampItem.RecordType.DeveloperName == 'Packet'){
        		mapWrappedCI.put(objCampItem.Id, new Adv_MediaCampaign_Clone_CampItem(objCampItem, objCamp, preventSurchargeCountries));
        		listCampItems.remove(i);
        		i--;
        	}
        }

        return mapWrappedCI;
    }

    /**
     *	Inserting all valid Advendio__Campaign_Item__c for the given Advendio__MediaCampaign__c.
     * 		In the first step all packageheader and the standard positions are inserted 
     *		In the second step all packagecomponents
     *		Then additional targeting information such as geo targeting and key values are inserted
     *
     *		The Advendio__Campaign_Item__c and their additional informations must be 
     *		stored in Adv_MediaCampaign_Clone_CampItem-Objects.
	 *
	 * @param	listCampItems, the filtered list of wrapped campaigns items which should be cloned 
     */
    private static void cloneCampaignItems(List<Adv_MediaCampaign_Clone_CampItem> listCampItems){
    	List<ADvendio__Campaign_Item__c> listNewCampItems = new List<ADvendio__Campaign_Item__c>();
    	List<ADvendio__Selected_City__c> listNewSelectedCities = new List<ADvendio__Selected_City__c>();
    	List<ADvendio__Selected_Country__c> listNewSelectedCountries = new List<ADvendio__Selected_Country__c>();
    	List<ADvendio__Selected_Region__c> listNewSelectedRegions = new List<ADvendio__Selected_Region__c>();
        List<ADvendio__SelectedAdServerId__c> listNewPostalCodes = new List<ADvendio__SelectedAdServerId__c>();
    	List<ADvendio__KeyValue__c> listClonedKeyValues = new List<ADvendio__KeyValue__c>();

    	Map<Id, ADvendio__Campaign_Item__c> mapNewIdForOldCI = new Map<Id, ADvendio__Campaign_Item__c>();
    	Map<Id, ADvendio__KeyLine__c> mapClonedKeyLines = new Map<Id, ADvendio__KeyLine__c>();

    	for(Adv_MediaCampaign_Clone_CampItem objCampItem :listCampItems){
    		listNewCampItems.addAll(objCampItem.getNewCampaignItems());
    	}
    	
    	insert listNewCampItems;

    	for(ADvendio__Campaign_Item__c objCampItem :listNewCampItems){
    		mapNewIdForOldCI.put(objCampItem.SomDig_SourceCampaignItem__c, objCampItem);
    	}

    	listNewCampItems = new List<ADvendio__Campaign_Item__c>();
    	for(Adv_MediaCampaign_Clone_CampItem objCampItem :listCampItems){
    		listNewCampItems.addAll(objCampItem.getNewCampaignItemsPackagComponents(mapNewIdForOldCI));
    	}
    	insert listNewCampItems;

    	for(ADvendio__Campaign_Item__c objCampItem :listNewCampItems){
    		mapNewIdForOldCI.put(objCampItem.SomDig_SourceCampaignItem__c, objCampItem);
    	} 	

    	for(Adv_MediaCampaign_Clone_CampItem objCampItem :listCampItems){
    		listNewSelectedCities.addAll(objCampItem.getSelectedCities(mapNewIdForOldCI));
    		listNewSelectedCountries.addAll(objCampItem.getSelectedCountries(mapNewIdForOldCI));
    		listNewSelectedRegions.addAll(objCampItem.getSelectedRegions(mapNewIdForOldCI));
            listNewPostalCodes.addAll(objCampItem.getPostalCodes(mapNewIdForOldCI));
    	}
    	insert listNewSelectedCities;
    	insert listNewSelectedCountries;
    	insert listNewSelectedRegions;
        insert listNewPostalCodes;
    	
    	for(Adv_MediaCampaign_Clone_CampItem objCampItem :listCampItems){
    		mapClonedKeyLines.putAll(objCampItem.cloneKeyLines(mapNewIdForOldCI));
    	}
    	insert mapClonedKeyLines.values();

    	
    	for(Adv_MediaCampaign_Clone_CampItem objCampItem :listCampItems){
    		listClonedKeyValues.addAll(objCampItem.cloneKeyValues(mapClonedKeyLines));
    	}
    	insert listClonedKeyValues;

    }

    private static Set<String> preventSurchargeCountries {
        get {
            if(preventSurchargeCountries == null) {
                preventSurchargeCountries = new Set<String>();
                for(ADvendio__Country__c country : [SELECT Id, Name FROM ADvendio__Country__c WHERE SomDig_Zuschlagspflichtig__c = false]) {
                    preventSurchargeCountries.add(country.Name);
                }
            }
            return preventSurchargeCountries;
        }
        set;
    }

}