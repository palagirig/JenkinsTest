global class Adv_MediaCampaign_Clone_CampItem {
	private Advendio__Campaign_Item__c objCampItem;
	private Advendio__MediaCampaign__c objNewCampaign;
	private ADvendio__Campaign_Item__c objNewCampaignItem;
	private List<Adv_MediaCampaign_Clone_CampItem> listComponents = new List<Adv_MediaCampaign_Clone_CampItem>();

	// Geo-Targeting
	private List<ADvendio__Selected_City__c> listCities = new List<ADvendio__Selected_City__c>(); 
	private List<ADvendio__Selected_Region__c> listRegions = new List<ADvendio__Selected_Region__c>();
	private List<ADvendio__Selected_Country__c> listCountries = new List<ADvendio__Selected_Country__c>();

	// PLZ Targeting here
	private List<ADvendio__SelectedAdServerId__c> listPostalCodes = new List<ADvendio__SelectedAdServerId__c>();

	// Key Value Targeting
	private List<Adv_MediaCampaign_Clone_KeyLine> listKeyLines = new List<Adv_MediaCampaign_Clone_KeyLine>();

	private Set<String> setPreventSurchargeCountries;

	public Adv_MediaCampaign_Clone_CampItem(Advendio__Campaign_Item__c campItem, Advendio__MediaCampaign__c mediaCampaign, Set<String> preventSurchargeCountries) {
		this.objCampItem = campItem;
		this.objNewCampaign = mediaCampaign;
		this.setPreventSurchargeCountries = preventSurchargeCountries;
	}

	public Id getItemId(){
		return objCampItem.Id;
	}

	public String getItemName() {
		return objCampItem.Name;
	}

	public Id getAdSpecId() {
		return objCampItem.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__c;
	}

	public Id getAdPriceId() {
		return objCampItem.ADvendio__Ad_Price__c;
	}
 
	public void setQuantity(Decimal quantity) {
		objCampItem.ADvendio__Quantity__c = quantity;
	}

	public Decimal getQuantity() {
		return objCampItem.ADvendio__Quantity__c;
	}

	public void setProrated(Decimal prorated) {
		objCampItem.ADvendio__Prorated__c = prorated;
	}

	/**
	 *	Determinates if the wrapper is a package or a standard position
	 *
	 *	@return returns true if the wrapper contains a package
	 */
	public boolean isPackage(){
		return listComponents.size() > 0;
	}

	public void addComponent(Adv_MediaCampaign_Clone_CampItem objComponent){
		if(objComponent != null){
			listComponents.add(objComponent);
		}
	}

	public List<Adv_MediaCampaign_Clone_CampItem> getComponents() {
		return listComponents;
	}

	
	public void addCity(ADvendio__Selected_City__c city){
		if(city != null){
			listCities.add(city);
		}
	}

	public void addCountry(ADvendio__Selected_Country__c country){
		if(country != null){
			listCountries.add(country);
		}
	}

	public void addRegion(ADvendio__Selected_Region__c region){
		if(region != null){
			listRegions.add(region);
		}
	}	

	public void addKeyLine(Adv_MediaCampaign_Clone_KeyLine keyLine){
		if(keyLine != null){
			listKeyLines.add(keyLine);
		}
	}

	public void addPostalCode(ADvendio__SelectedAdServerId__c postalCode) {
		if(postalCode != null) {
			listPostalCodes.add(postalCode);
		}
	}

	/**
	 *	Creates a list with all Advendio__Campaign_Item__c wich are compontents of this package. If the wrapper isn't a 
	 *		package a empty list will be retuned.
	 *
	 * @return a list with new created Advendio__Campaign_Item__c.
	 */
	public List<Advendio__Campaign_Item__c> getNewCampaignItemsPackagComponents(Map<Id, Advendio__Campaign_Item__c> mapPackageHeader){
		List<Advendio__Campaign_Item__c> result = new  List<Advendio__Campaign_Item__c>();
		Advendio__Campaign_Item__c objItem;
		Advendio__Campaign_Item__c objNewItem;

		if(isPackage()){
			for(Adv_MediaCampaign_Clone_CampItem objwrappedItem :listComponents){
				objItem = objwrappedItem.objCampItem;
				objNewItem = objwrappedItem.cloneItem();

				if(mapPackageHeader.containsKey(objItem.ADvendio__PacketItem__c)){
					objNewItem.ADvendio__PacketItem__c = mapPackageHeader.get(objItem.ADvendio__PacketItem__c).Id;
				}
				
				result.add(objNewItem);
			}
		}

		return result;
	}

	/**
	 * Creates an new Advendio__Campaign_Item__c for package header an standard positions.
	 *	Package componentes are not affected.
	 * 
	 * @return	a List with an new Advendio__Campaign_Item__c, it the wrapped campaign item is a package header
	 */
	public List<Advendio__Campaign_Item__c> getNewCampaignItems(){
		List<Advendio__Campaign_Item__c> result =  new  List<Advendio__Campaign_Item__c>();
		result.add(this.cloneItem());
		return result;
	}

	/**
	 * Creates a list with all associated cities, for the wrapped campaign items geo targetings
	 *
	 *	@param 	a mapping, of all cloned campaign items, mapped to their original campaign items
	 *	@return a list, with all cloned selectedCities for this wrapped campaign item
	 */
	public List<ADvendio__Selected_City__c> getSelectedCities(Map<Id, ADvendio__Campaign_Item__c> mapping){
		List<ADvendio__Selected_City__c> result = new List<ADvendio__Selected_City__c>();
		ADvendio__Selected_City__c objNewCity;
		for(ADvendio__Selected_City__c objCity : this.listCities){
			objNewCity = new ADvendio__Selected_City__c();
			objNewCity.ADvendio__City__c = objCity.ADvendio__City__c;
			ADvendio__Campaign_Item__c objNewCI = mapping.get(objCity.ADvendio__Campaign_Item__c);
			objNewCity.ADvendio__Campaign_Item__c = objNewCI.Id;

			result.add(objNewCity);
		}
		for(Adv_MediaCampaign_Clone_CampItem objCampItemWrapper :listComponents){
			result.addAll(objCampItemWrapper.getSelectedCities(mapping));
		}

		return result;
	}

	/**
	 * Creates a list with all associated countries, for the wrapped campaign items geo targetings
	 *
	 *	@param 	a mapping, of all cloned campaign items, mapped to their original campaign items
	 *	@return a list, with all cloned selectedCountries for this wrapped campaign item
	 */
	public List<ADvendio__Selected_Country__c> getSelectedCountries(Map<Id, ADvendio__Campaign_Item__c> mapping){
		List<ADvendio__Selected_Country__c> result = new List<ADvendio__Selected_Country__c>();
		ADvendio__Selected_Country__c objNewCountry;
		for(ADvendio__Selected_Country__c objCountry : this.listCountries){
			objNewCountry = new ADvendio__Selected_Country__c();
			objNewCountry.ADvendio__Country__c = objCountry.ADvendio__Country__c;

			ADvendio__Campaign_Item__c objNewCI = mapping.get(objCountry.ADvendio__Campaign_Item__c);

			objNewCountry.ADvendio__Campaign_Item__c = objNewCI.Id;

			result.add(objNewCountry);
		}
		for(Adv_MediaCampaign_Clone_CampItem objCampItemWrapper :listComponents){
			result.addAll(objCampItemWrapper.getSelectedCountries(mapping));
		}

		return result;
	}

	/**
	 * Creates a list with all associated regions, for the wrapped campaign items geo targetings
	 *
	 *	@param 	a mapping, of all cloned campaign items, mapped to their original campaign items
	 *	@return a list, with all cloned selectedRegions for this wrapped campaign item
	 */
	public List<ADvendio__Selected_Region__c> getSelectedRegions(Map<Id, ADvendio__Campaign_Item__c> mapping){
		List<ADvendio__Selected_Region__c> result = new List<ADvendio__Selected_Region__c>();
		ADvendio__Selected_Region__c objNewRegion;
		for(ADvendio__Selected_Region__c objRegion : this.listRegions){
			objNewRegion = new ADvendio__Selected_Region__c();
			objNewRegion.ADvendio__Region__c = objRegion.ADvendio__Region__c;

			ADvendio__Campaign_Item__c objNewCI = mapping.get(objRegion.ADvendio__Campaign_Item__c);

			objNewRegion.ADvendio__Campaign_Item__c = objNewCI.Id;

			result.add(objNewRegion);
		}
		for(Adv_MediaCampaign_Clone_CampItem objCampItemWrapper :listComponents){
			result.addAll(objCampItemWrapper.getSelectedRegions(mapping));
		}

		return result;
	}

	public List<ADvendio__SelectedAdServerId__c> getPostalCodes(Map<ID, ADvendio__Campaign_Item__c> mapping) {
		List<ADvendio__SelectedAdServerId__c> result = new List<ADvendio__SelectedAdServerId__c>();
		ADvendio__SelectedAdServerId__c objNewPostalCode;
		for(ADvendio__SelectedAdServerId__c objPostalCode : this.listPostalCodes) {
			objNewPostalCode = new ADvendio__SelectedAdServerId__c();
			objNewPostalCode.ADvendio__AdServerId__c = objPostalCode.ADvendio__AdServerId__c;
			objNewPostalCode.ADvendio__CampaignItem__c = mapping.get(objPostalCode.ADvendio__CampaignItem__c).Id;
			result.add(objNewPostalCode);
		}

		for(Adv_MediaCampaign_Clone_CampItem objCampItemWrapper :listComponents){
			result.addAll(objCampItemWrapper.getPostalCodes(mapping));
		}

		return result;
	}

	/**
	 *	Clones all the assosiated key lines for the wrapped campaign items
	 *
	 *	@param	a mapping, of all cloned campaign items, mapped to their original campaign items
	 *	@return a mapping, of all cloned key lines, mapped to their original key line ids
	 */
	public Map<Id, ADvendio__KeyLine__c> cloneKeyLines(Map<Id, ADvendio__Campaign_Item__c> mapping){
		Map<Id ,ADvendio__KeyLine__c> result = new Map<Id, ADvendio__KeyLine__c>();
		for(Adv_MediaCampaign_Clone_KeyLine objKeyLine :listKeyLines){
			result.put(objKeyLine.getKeyLineID(),objKeyLine.cloneKeyLine(mapping));
		}

		for(Adv_MediaCampaign_Clone_CampItem objCampItemWrapper :listComponents){
			result.putAll(objCampItemWrapper.cloneKeyLines(mapping));
		}

		return result;
	}

	/**
	 *	Clones all the attatched KeyValues for the wrapped campaign items
	 *
	 *	@param 	a mapping, for the cloned key lines from this wrapped campaign item
	 *	@return a list, with all cloned key values associated to their key lines
	 */
	public List<ADvendio__KeyValue__c> cloneKeyValues(Map<Id, ADvendio__KeyLine__c> mapping){
		List<ADvendio__KeyValue__c> result = new List<ADvendio__KeyValue__c>();
		// To-Do
		for(Adv_MediaCampaign_Clone_KeyLine objKeyLine :listKeyLines){
			result.addAll(objKeyLine.cloneKeyValues(mapping.get(objKeyLine.getKeyLineID())));
		}

		for(Adv_MediaCampaign_Clone_CampItem objCampItemWrapper :listComponents){
			result.addAll(objCampItemWrapper.cloneKeyValues(mapping));
		}

		return result;
	}

	/**
     *  Creates a flat copy for the given ADvendio__Campaign_Item__c.
     * 		The flat copy is linked to the given ADvendio__MediaCampaign__c.
     * 		The new ADvendio__Campaign_Item__c will not be inserted in this method.
     *  
     *  @param objOldMK ADvendio__MediaCampaign__c which should be cloned
     *  @return The flat copy for the given ADvendio__Campaign_Item__c
     */
    private ADvendio__Campaign_Item__c cloneItem(){    
        ADvendio__Campaign_Item__c objNewCI = new ADvendio__Campaign_Item__c();    
        objNewCI.SomDig_SourceCampaignItem__c = objCampItem.ID;
        
        objNewCI.RecordTypeID = objCampItem.RecordTypeID;        
        objNewCI.ADvendio__Prorated__c = objCampItem.ADvendio__Prorated__c;                
        objNewCI.ADvendio__Media_Campaign__c = this.objNewCampaign.ID;
        objNewCI.Name = objCampItem.Name;
        objNewCI.ADvendio__Agency_Commission__c = objCampItem.ADvendio__Agency_Commission__c;        
        objNewCI.ADvendio__Ad_Price__c = objCampItem.ADvendio__Ad_Price__c;
        objNewCI.ADvendio__from_Date__c = objCampItem.ADvendio__from_Date__c;
        objNewCI.ADvendio__until_Date__c = objCampItem.ADvendio__until_Date__c;
        objNewCI.ADvendio__Quantity__c = objCampItem.ADvendio__Quantity__c;        
        objNewCI.ADvendio__Sales_Price__c = objCampItem.ADvendio__ad_price__r.ADvendio__list_price__c;  
        objNewCI.ADvendio__Billing_category__c = objCampItem.ADvendio__Billing_category__c;
        objNewCI.ADvendio__AC__c = objCampItem.ADvendio__AC__c;        
        objNewCI.ADvendio__Rate_Discount_2_custom__c = objCampItem.ADvendio__Rate_Discount_2_custom__c;                
        objNewCI.ADvendio__Rate_Discount_3_custom__c = objCampItem.ADvendio__Rate_Discount_3_custom__c;                
        objNewCI.ADvendio__Rate_Discount_4__c = objCampItem.ADvendio__Rate_Discount_4__c;                                        
        objNewCI.ADvendio__Rate_Discount_4_Name__c = objCampItem.ADvendio__Rate_Discount_4_Name__c;
        objNewCI.ADvendio__SortOrder__c = objCampItem.ADvendio__SortOrder__c;
        objNewCI.ADvendio__RateDiscount2Name__c = objCampItem.ADvendio__RateDiscount2Name__c;

        // OTP
        if(objCampItem.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_OtpAufschlag__c != null)
        	objNewCI.SomDig_OtpAufschlag__c = objCampItem.SomDig_OtpAufschlag__c;

        // FC
        if(objCampItem.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_FC__c){
	        objNewCI.ADvendio__FC_Quantity__c = objCampItem.ADvendio__FC_Quantity__c;
	        objNewCI.ADvendio__FC_Ad_served_every__c = objCampItem.ADvendio__FC_Ad_served_every__c;
	        objNewCI.ADvendio__FC_Period__c = objCampItem.ADvendio__FC_Period__c;	
        }

        // Timetargeting
        objNewCI.ADvendio__AdHourOfDay__c = objCampItem.ADvendio__AdHourOfDay__c;
        objNewCI.ADvendio__AdDayOfWeek__c = objCampItem.ADvendio__AdDayOfWeek__c;

        // Tech Targeting
        objNewCI.ADvendio__AdOperatingSystems__c = objCampItem.ADvendio__AdOperatingSystems__c;
        objNewCI.ADvendio__AdWebBrowsers__c = objCampItem.ADvendio__AdWebBrowsers__c;
        objNewCI.SomDig_ADGapID__c = objCampItem.SomDig_ADGapID__c;

        // Re-targeting
        if(objCampItem.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.SomDig_RetargetingSurcharge__c != null) {
        	objNewCI.SomDig_Retargeting__c	= objCampItem.SomDig_Retargeting__c;
        } else {
        	objNewCI.SomDig_Retargeting__c = false;
        }



        objNewCI.ADvendio__AdKeyValues__c = getKeyValueTargetingAbbrevation();
        objNewCI.ADvendio__SelectedAdServerIdInformation__c = getPostalCodeAbbreviation();
        objNewCI.ADvendio__Targetingabbrevation__c = getTargetingAbbrevation(objNewCI);
        this.objNewCampaignItem = objNewCI;
        //surcharge logic
        calculateSurcharge();
        return objNewCI;
    }

    /**
     *	Creates the abbrevation string for the given ADvendio__Campaign_Item__c
     *
     *	@param ADvendio__Campaign_Item__c, for which the string should be created
     *	@return the complet abbrevation string for all targetings
     */
    private String getTargetingAbbrevation(ADvendio__Campaign_Item__c objCampItem){
    	// AdDayOfWeek: Sunday; AdHourOfDay: 0:00 - 1:00; AdKeyValues: ((Alter=18 und 19jährige)); AdOperatingSystems: Android; AdWebBrowsers: Firefox; Selected City Information: Wien; Selected Country Information: Schweiz; Selected Region Information: Wien	
    	String sResult = '';

    	sResult += getTimeTargetingAbbrevation(objCampItem);

    	String sStringKeyValues = getKeyValueTargetingAbbrevation();
    	if(sStringKeyValues != '' )
    		if(sResult == '' )
    			sResult = 'AdKeyValues: '+sStringKeyValues;
    		else
    			sResult += '; AdKeyValues: '+sStringKeyValues;

    	
    	String sStringTechTargeting = getTechTargetingAbbrevation(objCampItem);
    	if(sStringTechTargeting != '' )
    		if(sResult == '' )
    			sResult = sStringTechTargeting;
    		else
    			sResult += sStringTechTargeting;
    	
    	// Selected City Information: Aachen, Aschaffenburg, Augsburg; Selected Region Information: Berlin, Bremen, Hamburg
    	String sSelectedCity = this.listCities.isEmpty() ? '' : 'Selected City Information: ';
    	for(ADvendio__Selected_City__c objCity :this.listCities){
    		sSelectedCity+= objCity.ADvendio__City__r.Name+', ';
    	}
    	sSelectedCity = sSelectedCity.removeEnd(', ');
    	if(sResult == '')
    		sResult = sSelectedCity;
    	else
    		if(sSelectedCity != '')
    			sResult += '; '+sSelectedCity;

    	String sSelectedRegions = this.listRegions.isEmpty() ? '' : 'Selected Region Information: ';
    	for(ADvendio__Selected_Region__c objRegion :this.listRegions){
    		sSelectedRegions+= objRegion.ADvendio__Region__r.Name+', ';
    	}
    	sSelectedRegions = sSelectedRegions.removeEnd(', ');
    	if(sResult == '')
    		sResult = sSelectedRegions;
    	else
    		if(sSelectedRegions != '')
    			sResult += '; '+sSelectedRegions;

    	String sSelectedCountries = this.listCountries.isEmpty() ? '' : 'Selected Country Information: ';
    	for(ADvendio__Selected_Country__c objCountry :this.listCountries){
    		sSelectedCountries+= objCountry.ADvendio__Country__r.Name+', ';
    	}
    	sSelectedCountries = sSelectedCountries.removeEnd(', ');
    	if(sResult == '')
    		sResult = sSelectedCountries;
    	else
    		if(sSelectedCountries != '')
    			sResult += '; '+sSelectedCountries;

		return sResult;
    }

    /**
     *	Creates the time targeting part of abbrevation string
     *
     *	@param ADvendio__Campaign_Item__c, for which the string should be created
     *	@return the abbrevation string for the time targeting
     */
    private String getTimeTargetingAbbrevation(ADvendio__Campaign_Item__c objCampItem){
    	String sResult = '';

    	// AdDayOfWeek: Monday; AdHourOfDay: 9:00 - 10:00
    	String sTimeTargetingDay = (objCampItem.ADvendio__AdDayOfWeek__c != null ? 'AdDayOfWeek: '+objCampItem.ADvendio__AdDayOfWeek__c : '');
    	if(sTimeTargetingDay != ''){
    		sTimeTargetingDay = sTimeTargetingDay.replaceAll(';', ',');
    		sResult = sTimeTargetingDay;
    	}
    	String sTimeTargetingHour = (objCampItem.ADvendio__AdHourOfDay__c != null ? 'AdHourOfDay: '+objCampItem.ADvendio__AdHourOfDay__c : '');
    	if(sTimeTargetingHour != ''){
    		sTimeTargetingHour = sTimeTargetingHour.replaceAll(';', ',');
    		sResult += (sResult == '' ? sTimeTargetingHour : '; '+sTimeTargetingHour);
    	}
    	return sResult;
    }

    /**
     *	Creates the tech targeting part of abbrevation string
     *
     *	@param ADvendio__Campaign_Item__c, for which the string should be created
     *	@return the abbrevation string for the tech targeting
     */
    private String getTechTargetingAbbrevation(ADvendio__Campaign_Item__c objCampItem){
    	// AdOperatingSystems: Apple iOS; AdWebBrowsers: Firefox,Mozilla	
    	String sResult = '';

    	String sAdOperatingSystems = (objCampItem.ADvendio__AdOperatingSystems__c != null ? 'AdOperatingSystems: '+objCampItem.ADvendio__AdOperatingSystems__c : '');
    	if(sAdOperatingSystems != ''){
    		sAdOperatingSystems = sAdOperatingSystems.replaceAll(';', ',');
    		sResult += (sResult == '' ? sAdOperatingSystems : '; '+sAdOperatingSystems);
    	}
    	String sAdWebBrowsers = (objCampItem.ADvendio__AdWebBrowsers__c != null ? 'AdWebBrowsers: '+objCampItem.ADvendio__AdWebBrowsers__c : '');
    	if(sAdWebBrowsers != ''){
    		sAdWebBrowsers = sAdWebBrowsers.replaceAll(';', ',');
    		sResult += (sResult == '' ? sAdWebBrowsers : '; '+sAdWebBrowsers);
    	}
    	return sResult;
    }

    /**
     *	Creates the key value part of abbrevation string
     *
     *	@return the key value abbrevation string
     */
    private String getKeyValueTargetingAbbrevation(){
    	String result = '';

    	// 1 KeyLine 2 KeyValue: ((NU_Alter=18 und 19jährige, 20 - 29 jährige, 30 - 39 jährige, 40 - 49 jährige, 50 - 59 jährige, über 60jährige) AND (NU_Haushaltsführer=ist Haushaltsführer))
    	// 3 Keyline 1 KeyValue: ((NU_Alter=30 - 39 jährige)) OR ((NU_Alter=40 - 49 jährige)) OR ((NU_Alter=50 - 59 jährige))

    	for(Adv_MediaCampaign_Clone_KeyLine objKeyLine :listKeyLines){
			result += objKeyLine.toString();
			result += ' OR ';
    	}
    	result = result.removeEnd(' OR ');
    	return result;
    }

    private String getPostalCodeAbbreviation(){
    	// Postal Code: 12345, 12346, 12347
    	String sResult = '';

    	if(!listPostalCodes.isEmpty()){
    		sResult = 'Postal Code: ';
    		for(ADvendio__SelectedAdServerId__c objPostalCode : listPostalCodes) {
    			sResult += objPostalCode.ADvendio__AdServerId__r.Name;
    			sResult += ', ';
    		}
    		sResult = sResult.removeEnd(', ');
    	}
    	return sResult;
    }

    /**
	 * Calculates and sets advendio__surchargesalesprice__c depending on surcharge logics.
	 * function ported from ModifyCampaignItemJavaScriptExtension aka CJS.
	 */
    public void calculateSurcharge() {
    	// get old campaign item for lookup values.
        ADvendio__Campaign_Item__c oldCI = this.objCampItem;
        // get new campaign item for CI values.
        ADvendio__Campaign_Item__c newCI = this.objNewCampaignItem;
        
        if(isValidPackageHeaderOrStandardItem()) {
            Decimal surchargeSalesPrice = 0;
            Decimal salesPrice = newCI.advendio__sales_price__c;
            Decimal adPrice_listPrice = oldCI.advendio__ad_price__r.advendio__list_price__c;
            
            if(salesPrice == adPrice_listPrice) {
                Decimal adSpec_fcAufschlag  = oldCI.advendio__ad_price__r.advendio__ad_spec__r.somdig_fcaufschlag__c;
                Decimal fcAdServedEvery     = newCI.advendio__fc_ad_served_every__c;
                String fcPeriod             = newCI.advendio__fc_period__c;
                Decimal fcQuantity          = newCI.advendio__fc_quantity__c;
                String billingCategory      = newCI.advendio__billing_category__c;
                String adSpec_mgd           = oldCI.advendio__ad_price__r.advendio__ad_spec__r.somdig_mediagattungsdifferenzierung__c;
                Boolean otpAufschlag        = newCI.somdig_otpaufschlag__c;

                // fc aufschlag
                if (adSpec_fcAufschlag != null && billingCategory != 'CPD' && billingCategory != 'CPW' && fcAdServedEvery != null && fcAdServedEvery >= 1
                    && (fcPeriod == 'week' || fcPeriod == 'month' || fcPeriod == 'campaign') && adSpec_mgd == 'InStream/Video' && otpAufschlag == false) {
                    surchargeSalesPrice += adSpec_fcAufschlag;
                }

                Decimal adSpec_targetingaufschlag   				= oldCI.advendio__ad_price__r.advendio__ad_spec__r.somdig_targetingaufschlag__c;
                String adgapid                     					= newCI.somdig_adgapid__c;
                List<Adv_MediaCampaign_Clone_KeyLine>  arrKeyLines	= this.listKeyLines;
                List<ADvendio__Selected_Country__c> arrCountries 	= this.listCountries;
                List<ADvendio__Selected_Region__c> regions			= this.listRegions;
                List<ADvendio__Selected_City__c> cities     		= this.listCities;
                List<ADvendio__SelectedAdServerId__c> postalCodes  = this.listPostalCodes;

                // targeting aufschlag
                if (adSpec_targetingaufschlag != null && String.isBlank(adgapid) && (!postalCodes.isEmpty() || !regions.isEmpty() || !cities.isEmpty() || isValidKeyValueTargeting_TargetingAufschlag(arrKeyLines) || (arrKeyLines.isEmpty() && isValidCountryTargeting(arrCountries)))) {
                    surchargeSalesPrice += adSpec_targetingaufschlag;
                }
                
                Decimal adSpec_retargetingAufschlag	= oldCI.advendio__ad_price__r.advendio__ad_spec__r.somdig_retargetingsurcharge__c;
                Boolean retargeting					= newCI.somdig_retargeting__c;
                
                // retargeting aufschlag
                if (adSpec_retargetingAufschlag != null && retargeting == true) {
                    surchargeSalesPrice += adSpec_retargetingAufschlag;
                }
                
                Decimal adSpec_rotationsAufschlag	= oldCI.advendio__ad_price__r.advendio__ad_spec__r.somdig_rotationexclusionsurcharge__c;
                String adSpec_rotationsTyp   		= oldCI.advendio__ad_price__r.advendio__ad_spec__r.somdig_rotationstyp__c;

                // rotations aufschlag
                if (adSpec_rotationsAufschlag != null && isValidKeyValueTargeting_RotationsAufschlag(arrKeyLines, adSpec_rotationsTyp)) {
                    surchargeSalesPrice += adSpec_rotationsAufschlag;
                }
                
                Decimal adSpec_otpAufschlag	= oldCI.advendio__ad_price__r.advendio__ad_spec__r.somdig_otpaufschlag__c;
                
                // opt aufschlag
                if (adSpec_otpAufschlag != null && otpAufschlag == true) {
                    surchargeSalesPrice += adSpec_otpAufschlag;
                }
                if(surchargeSalesPrice > 0)
                	objNewCampaignItem.advendio__surchargesalesprice__c = surchargeSalesPrice;
            }
        }

    }

    /**
	 * Determines if its a valid item for the custom javascript logics to run.
	 * function ported from ModifyCampaignItemJavaScriptExtension aka CJS.
	 */
    private Boolean isValidPackageHeaderOrStandardItem() {
    	
    	String recordTypeDeveloperName = this.objCampItem.recordType.DeveloperName;
    	String packetItemId = this.objCampItem.advendio__packetitem__c;
    	String distribution = this.objCampItem.advendio__ad_price__r.advendio__ad_spec__r.advendio__distribution__c;
    	Boolean isValidPackageHeaderOrStandardItem = ((recordTypeDeveloperName == 'Packet' && distribution == 'Prorated') || (recordTypeDeveloperName != 'Packet' && String.isBlank(packetItemId)));

    	return isValidPackageHeaderOrStandardItem;
    }

    /**
	 * Checks if the key lines are valid for targeting surcharge.
	 * function ported from ModifyCampaignItemJavaScriptExtension aka CJS.
	 * @param arrKeyLines list of wrapped KeyLines
	 * @return boolean answer
	 */
    private Boolean isValidKeyValueTargeting_TargetingAufschlag(List<Adv_MediaCampaign_Clone_KeyLine> arrKeyLines) {
    	Boolean isValidKeyValueTargeting = false;
    	for(Adv_MediaCampaign_Clone_KeyLine keyline : arrKeyLines) {
    		if(keyline.isValidKeyValueTarget_TargetingAufschlag()) {
    			isValidKeyValueTargeting = true;
    			break;
    		}
    	}
    	return isValidKeyValueTargeting;
    }

    /**
	 * Checks if the countries are valid for targeting surcharge.
	 * function ported from ModifyCampaignItemJavaScriptExtension aka CJS.
	 * @param arrCountries
	 * @return boolean answer
	 */
    private Boolean isValidCountryTargeting(List<ADvendio__Selected_Country__c> arrCountries) {
    	Boolean isValidCountryTargeting = false; 
    	for(ADvendio__Selected_Country__c selCountry : arrCountries) {
    		if(!this.setPreventSurchargeCountries.contains(selCountry.ADvendio__Country__r.Name)) {
    			isValidCountryTargeting = true;
    			break;
    		}
    	}
    	return isValidCountryTargeting;
    }

    /**
	 * Checks if the key lines are valid for rotation surcharge.
	 * function ported from ModifyCampaignItemJavaScriptExtension aka CJS.
	 * @param arrKeyLines
     * @param adSpec_rotationsTyp string containing the rotationsTyp of the placement
	 * @return boolean answer
	 */
    private Boolean isValidKeyValueTargeting_RotationsAufschlag(List<Adv_MediaCampaign_Clone_KeyLine> arrKeyLines, String adSpec_rotationsTyp) {
    	Boolean isValidKeyValueTargeting = false;
    	for(Adv_MediaCampaign_Clone_KeyLine keyline : arrKeyLines) {
    		if(keyline.isValidKeyValueTargeting_RotationsAufschlag(adSpec_rotationsTyp)) {
    			isValidKeyValueTargeting = true;
    			break;
    		}
    	}
    	return isValidKeyValueTargeting;
    }



}