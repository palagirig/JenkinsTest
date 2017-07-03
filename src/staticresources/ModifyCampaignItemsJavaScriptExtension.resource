(function() {
    var cj$ = jQuery.noConflict();
    
    
    var preventSurchargeCountries	= null; // to be queried
    var specialKeys					= ["Ausschluss-Identifier"];
    var specialValues				= ["Videovalis.de"];
    
    // used to store old values.
    var oldSalesprice = {};
    
    cj$(document).ready(function() {
        cj$.getScript("/soap/ajax/35.0/connection.js").done(function(script, textStatus) { // this runs always async
            preventSurchargeCountries = getPreventSurchargeCountries();
        });
        
        if (adv.getFeatureName() == "Add Items (Optimizer)" || adv.getFeatureName() == "Campaign Item Creation") {
            cj$.each(cj$("tr.LineItemRow"), function() {
                var lineId  = cj$(this).attr("id");
                if (isValidPackageHeaderOrStandardItem(lineId)) {
                    setDefaultDiscounts_AddItemsOptimizer(lineId);
                }
            });
        } else if(adv.getFeatureName() == "Edit Items (Optimizer)") {
            var observer = new MutationObserver(function(mutations) {
                mutations.forEach(function(mutation) {
                    for (var i = 0; i < mutation.addedNodes.length; i++) {
                        if (mutation.addedNodes[i].id == 'page:ModifyCampaignItems:ModifyCiComponent:Form') {
                            fromDates = document.querySelectorAll("[fieldname='advendio__from_date__c']");
                            for (var i = 0; i < fromDates.length; i++) {
                                if(fromDates[i].classList.toString().indexOf('a0YXX00XX') > -1) {
                                    fromDates[i].disabled = false;
                                    $j(fromDates[i]).closest('td').attr('readonlyfield',false);
                                }
                            }
                        }
                    }
                })
            });
            observer.observe(document.body, { childList: true, subtree:true });
        }
        
        // 6005
        removeReadOnlyFromField('input.advendio__ad_id__c');  
        removeReadOnlyFromField('input.advendio__additional_ad_ids__c');
        removeReadOnlyFromField('input.advendio__adserver_id_order_id__c');
        removeHiddenFromField('textarea.advendio__selectedadserverids__r-postalcode');
    });

    function removeHiddenFromField(fieldName) {
        jQuery.each(jQuery(fieldName), function() {
            if (jQuery(this).hasClass("hiddenHtmlElement")) {
                jQuery(this).css('display', 'inline');
            }
        });
    }
    
    // 6005 - Make AdID fields editable.
    function removeReadOnlyFromField(fieldName) {
        jQuery.each(jQuery(fieldName), function() {
            var lineId = adv.getLineId(this);
            if(adv.getValue(lineId, 'somdig_stornoposition__c')) {
                jQuery(this).removeAttr("disabled");
                jQuery(this).parents("td").removeAttr("readonlyfield");
            }
        });
    }
    
    /**
	 * @return countries where SomDig_Zuschlagspflichtig__c equals false
	 */
    function getPreventSurchargeCountries() {
        if (preventSurchargeCountries == null) {
            var queryCountry = "SELECT Id, Name"
            + " FROM ADvendio__Country__c"
            + " WHERE SomDig_Zuschlagspflichtig__c = false";
            
            preventSurchargeCountries = queryNames(queryCountry);
        }
        
        return preventSurchargeCountries;
    }
    
    /**
	 * Executes a query and creates a array of Name field values.
	 * @param query query string to execute, must contain field Name
	 * @return array of Name field values
	 */
    function queryNames(query) {
        var names = [];
        var instanceName = adv.getHostName();
        var remoteUrl	= "https://"+instanceName+"/services/data/v35.0/query/?q="+encodeURI(query);
        var remoteAuth	= 'Bearer '+adv.getSessionId();
        sforce.connection.sessionId = window.ApiUtils.getSessionId();
        sforce.connection.remoteFunction({
            url : remoteUrl,
            method : 'GET', 
            async : false, 
            cache : 'false',
            requestHeaders : {'Authorization' : remoteAuth, "Accept" : "application/json", "Content-Type" : "application/json"},
            onSuccess : function(response) {
                var $json = JSON.parse(response);
                cj$.each($json.records, function(index, obj) {
                    names.push(obj.Name);
                });
            },
            onFailure : function(response) {
                console.log(response);
            }
        });
        
        return names;
    }
    
    /**
	 * Calculates and sets advendio__surchargesalesprice__c depending on surcharge logics.
	 */
    var handlerAufschlag = function() {
        /**
		 * Parses the advendio__keylines__r string into a array of {key string ==> array of values}.
		 * @param keylines key lines string
		 * @return array of {key string ==> array of values}
		 */
        var parseKeyLines = function(keylines) {
            var arrKeyLines = [];
            
            if (keylines != "") {
                cj$.each(keylines.split(/\) OR \(|\) AND \(/g), function(index, keyline) {
                    keyline = keyline.replace(/\(|\)/g, "");
                    var keyAndValues = keyline.split(/!=|=/g);
                    var mapKeyLine = {};
                    mapKeyLine[keyAndValues[0]] = keyAndValues[1].split(/,/g);
                    arrKeyLines.push(mapKeyLine);
                });
            }
            
            return arrKeyLines;
        }
        
        /**
		 * Checks if the key lines are valid for targeting surcharge.
		 * @param arrKeyLines array of {key string ==> array of values}
		 * @return boolean answer
		 */
        var isValidKeyValueTargeting_TargetingAufschlag = function(arrKeyLines) {
            var isValidKeyValueTargeting = false;
            cj$.each(arrKeyLines, function(index, keyToValues) {
                cj$.map(keyToValues, function(values, key) {
                    if (key != "Ausschluss-Identifier") {
                        isValidKeyValueTargeting = true;
                        return;
                    }
                });
            });
            
            return isValidKeyValueTargeting;
        }
        
        /**
		 * Checks if the key lines are valid for rotation surcharge.
		 * @param arrKeyLines array of {key string ==> array of values}
         * @param adSpec_rotationsTyp string containing the rotationsTyp of the placement
		 * @return boolean answer
		 */
        var isValidKeyValueTargeting_RotationsAufschlag = function(arrKeyLines, adSpec_rotationsTyp) {
            var isValidKeyValueTargeting = false;
            cj$.each(arrKeyLines, function(index, keyToValues) {
                cj$.map(keyToValues, function(values, key) {
                    if (key == "Ausschluss-Identifier") {
                        if (values.length > 3 || (cj$.inArray("Videovalis.de", values) > -1 && isValidRotationstyp(adSpec_rotationsTyp) ) ) {
                            isValidKeyValueTargeting = true;
                            return;
                        }
                    }
                });
                
                if (isValidKeyValueTargeting == true) {
                    return;
                }
            });
            
            return isValidKeyValueTargeting;
        }

        /**
         * Checks if the rotationstyp of a placement is Network-Rotation.
         * @param adSpec_rotationsTyp string containing the rotationsTyp of the placement
         * @return boolean answer
         */
         var isValidRotationstyp = function(adSpec_rotationsTyp) {
            var isNetworkRotation = false;
            if(typeof adSpec_rotationsTyp == "string") {
                if(adSpec_rotationsTyp === "Network-Rotation") {
                    isNetworkRotation = true;
                }
            }
            return isNetworkRotation;
         }
        
        /**
		 * Parses the advendio__selected_countries__r string into a array of countries.
		 * @param countries countries string
		 * @return array of countries
		 */
        var parseCountries = function(countries) {
            var arrCountries = [];
            
            if (countries != "") {
                cj$.each(countries.split(/\n/g), function(index, country) {
                    arrCountries.push(country);
                });
            }
            
            return arrCountries;
        }
        
        /**
		 * Checks if the countries are valid for targeting surcharge.
		 * @param arrCountries array of countries
		 * @return boolean answer
		 */
        var isValidCountryTargeting = function(arrCountries) {
            preventSurchargeCountries = getPreventSurchargeCountries();
            
            var isValidCountryTargeting = false;
            cj$.each(arrCountries, function(index, country) {
                if (cj$.inArray(country, preventSurchargeCountries) == -1) {
                    isValidCountryTargeting = true;
                    return;
                }
            });
            
            return isValidCountryTargeting;
        }
        
        // start of constructor
        var lineId			= adv.getLineId(this);
        
        if (isValidPackageHeaderOrStandardItem(lineId)) {
            cj$.getScript("/soap/ajax/35.0/connection.js").done(function(script, textStatus) { // this runs always async
                var surchargeSalesPrice = 0;
                
                var salesPrice			= adv.getValue(lineId, "advendio__sales_price__c");
                var adPrice_listPrice	= adv.getValue(lineId, "advendio__ad_price__r.advendio__list_price__c");
                
                if (salesPrice == adPrice_listPrice) {
                    var adSpec_fcAufschlag	= adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.somdig_fcaufschlag__c");
                    var fcAdServedEvery		= adv.getValue(lineId, "advendio__fc_ad_served_every__c");
                    var fcPeriod			= adv.getValue(lineId, "advendio__fc_period__c");
                    var fcQuantity			= adv.getValue(lineId, "advendio__fc_quantity__c");
                    var billingCategory		= adv.getValue(lineId, "advendio__billing_category__c");
                    var adSpec_mgd			= adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.somdig_mediagattungsdifferenzierung__c");
                    var otpAufschlag		= adv.getValue(lineId, "somdig_otpaufschlag__c");
                    
                    // fc aufschlag
                    if (adSpec_fcAufschlag !== "" && billingCategory != "CPD" && billingCategory != "CPW" && fcAdServedEvery !== "" && fcAdServedEvery >= 1
                        && (fcPeriod == "week" || fcPeriod == "month" || fcPeriod == "campaign") && adSpec_mgd == "InStream/Video" && otpAufschlag == false) {
                        surchargeSalesPrice += adSpec_fcAufschlag;
                    }
                    
                    var adSpec_targetingaufschlag	= adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.somdig_targetingaufschlag__c");
                    var adgapid						= adv.getValue(lineId, "somdig_adgapid__c");
                    var keylines					= cj$(document.getElementById(lineId)).find(".advendio__keylines__r").first().val();
                    var arrKeyLines					= parseKeyLines(keylines);
                    var countries					= cj$(document.getElementById(lineId)).find(".advendio__selected_countries__r").first().val();
                    var arrCountries				= parseCountries(countries);
                    var regions 					= cj$(document.getElementById(lineId)).find(".advendio__selected_regions__r").first().val();
                    var cities 						= cj$(document.getElementById(lineId)).find(".advendio__selected_cities__r").first().val();
                    var plzs 						= cj$(document.getElementById(lineId)).find(".advendio__selectedadserverids__r-postalcode").first().val();
                    
                    if(!plzs) plzs = ''; // incident hotfix. plzs is undefined as it can not find advendio__selectedadserverids__r-postalcode field.
                    
                    // targeting aufschlag
                    if (adSpec_targetingaufschlag !== "" && adgapid == "" && (plzs != "" || regions != "" || cities != "" || isValidKeyValueTargeting_TargetingAufschlag(arrKeyLines) || (arrKeyLines.length == 0 && isValidCountryTargeting(arrCountries)))) {
                        surchargeSalesPrice += adSpec_targetingaufschlag;
                    }
                    
                    var adSpec_retargetingAufschlag	= adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.somdig_retargetingsurcharge__c");
                    var retargeting				= adv.getValue(lineId, "somdig_retargeting__c");
                    
                    // retargeting aufschlag
                    if (adSpec_retargetingAufschlag !== "" && retargeting == true) {
                        surchargeSalesPrice += adSpec_retargetingAufschlag;
                    }
                    
                    var adSpec_rotationsAufschlag	= adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.somdig_rotationexclusionsurcharge__c");
                    var adSpec_rotationsTyp   = adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.somdig_rotationstyp__c");

                    // rotations aufschlag
                    if (adSpec_rotationsAufschlag !== "" && isValidKeyValueTargeting_RotationsAufschlag(arrKeyLines, adSpec_rotationsTyp)) {
                        surchargeSalesPrice += adSpec_rotationsAufschlag;
                    }
                    
                    var adSpec_otpAufschlag	= adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.somdig_otpaufschlag__c");
                    
                    // opt aufschlag
                    if (adSpec_otpAufschlag !== "" && otpAufschlag == true) {
                        surchargeSalesPrice += adSpec_otpAufschlag;
                    }
                }
                
                if (surchargeSalesPrice === 0) {
                    surchargeSalesPrice = "";
                }
                
                adv.setValue(lineId, "advendio__surchargesalesprice__c", surchargeSalesPrice);
                triggerChange(lineId, "advendio__surchargesalesprice__c");
            });
        }
    }
    
    /**
	 * Sets advendio__fc_ad_served_every__c depending on advendio__fc_period__c and advendio__fc_quantity__c.
	 */
    var handlerFC = function() {
        var lineId			= adv.getLineId(this);
        
        var fcPeriod		= adv.getValue(lineId, "advendio__fc_period__c");
        var fcQuantity		= adv.getValue(lineId, "advendio__fc_quantity__c");
        
        if (fcPeriod !== "" && fcQuantity !== "") {
            adv.setValue(lineId, "advendio__fc_ad_served_every__c", 1);
        } else if (fcPeriod === "" && fcQuantity === "") {
            adv.setValue(lineId, "advendio__fc_ad_served_every__c", "");
        }
    }
    
    function getCISalesPrice(ciId) {
        sforce.connection.sessionId = adv.getSessionId();
        var result = sforce.connection.query("SELECT advendio__sales_price__c FROM Advendio__Campaign_Item__c WHERE ID = '"+ciId+"' LIMIT 1");
        if(result.getArray("records").length > 0)
            return result.getArray("records")[0].ADvendio__Sales_Price__c;
        else
            return adv.getValue(ciId,"advendio__sales_price__c");
    }
    
    /**
     * Handles advendio__rate_discount_4_name__c changes.
     */
    var handlerRateDiscount4Name = function() {
        
        var lineId = adv.getLineId(this);
        var rateDiscount4Name = adv.getValue(lineId, "advendio__rate_discount_4_name__c");
        if (oldSalesprice[lineId] == null) oldSalesprice[lineId] = getCISalesPrice(lineId);
        
        if (isValidPackageHeaderOrStandardItem(lineId)) {
            
            if (adv.getFeatureName() == "Add Items (Optimizer)" || adv.getFeatureName() == "Edit Items (Optimizer)") {
                var mgd = adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.somdig_mediagattungsdifferenzierung__c");
                
                if (rateDiscount4Name != "InPage" && rateDiscount4Name != "InStream"
                    || rateDiscount4Name == "InPage" && mgd != "InPage/Display"
                    || rateDiscount4Name == "InStream" && mgd != "InStream/Video") {
                    adv.setValue(lineId, "advendio__rate_discount_2_custom__c", "");
                    triggerChange(lineId, "advendio__rate_discount_2_custom__c");
                    
                    adv.setValue(lineId, "advendio__ratediscount2name__c", "");
                    
                    adv.setValue(lineId, "advendio__rate_discount_4__c", "");
                    triggerChange(lineId, "advendio__rate_discount_4__c");
                    
                    adv.setValue(lineId, "advendio__rate_discount_3_custom__c", "");
                    triggerChange(lineId, "advendio__rate_discount_3_custom__c");
                } else if (adv.getFeatureName() == "Add Items (Optimizer)") {
                    setDefaultDiscounts_AddItemsOptimizer(lineId);
                }
            }
            
            if (rateDiscount4Name == "Storno mit Leistungsfluss" || rateDiscount4Name == "Kompensation" || rateDiscount4Name == "Nachlieferung") {
                adv.setValue(lineId, "advendio__sales_price__c", 0);
                triggerChange(lineId, "advendio__sales_price__c");
                
            } else {
                adv.setValue(lineId, "advendio__sales_price__c", oldSalesprice[lineId]);
                triggerChange(lineId, "advendio__sales_price__c");
            } 
            
            if (rateDiscount4Name == "Positionsrabatt Natural") {
                adv.setValue(lineId, "advendio__surchargeb3__c", -100);
                triggerChange(lineId, "advendio__surchargeb3__c");
            } else {
                adv.setValue(lineId, "advendio__surchargeb3__c", 0);
                triggerChange(lineId, "advendio__surchargeb3__c");
            }
            
        }
    };
    
    /**
     * Gets an array of component elements based on packetId.
     * Copied from ModifyCisJs and adapted for ticket 04411
     */ 
    function getArrEComponentCustom(packetId) {
        var arrEComponent = [];
        
        cj$.each(cj$("span.advendio__packetitem__r-id"), function() {
            if (cj$(this).children().size() > 0) {
                if (j$(this).children().first().text() == packetId) {
                    arrEComponent.push(getRow(cj$(this)));
                }
            }
        });
        
        return arrEComponent;
    }
    
    /**
	 * Determines if its a valid item for the custom javascript logics to run.
	 * @param lineId
	 */
    function isValidPackageHeaderOrStandardItem(lineId) {
        var recordTypeDeveloperName		= adv.getValue(lineId, "recordtype-developername");
        var packetItem__rId				= adv.getValue(lineId, "advendio__packetitem__r.id");
        var distribution				= adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.advendio__distribution__c");
        
        if ((recordTypeDeveloperName == "Packet" && distribution == "Prorated") || (recordTypeDeveloperName != "Packet" && packetItem__rId === "")) {
            return true;
        } else {
            return false;
        }
    }
    
    /**
	 * Sets Default Discounts.
	 * @param lineId
	 */
    function setDefaultDiscounts_AddItemsOptimizer(lineId) {
        var mgd     = adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.somdig_mediagattungsdifferenzierung__c");
        
        if (mgd == "InPage/Display" || mgd == "InStream/Video") {
            var rateDiscount2;
            var rateDiscount2Name;
            var rateDiscount3 = adv.getValue(lineId, "advendio__media_campaign__r.somdig_agenturrabatt__c");
            var rateDiscount4;
            var rateDiscount4Name;
            if (mgd == "InPage/Display") {
                rateDiscount2       = adv.getValue(lineId, "advendio__media_campaign__r.somdig_kundenrabatt_inpage__c");
                rateDiscount2Name   = "InPage";
                rateDiscount4       = adv.getValue(lineId, "advendio__media_campaign__r.somdig_sonderrabatt_inpage__c");
                rateDiscount4Name   = "InPage";
            } else if (mgd == "InStream/Video") {
                rateDiscount2		= adv.getValue(lineId, "advendio__media_campaign__r.somdig_kundenrabatt_instream__c");
                rateDiscount2Name	= "InStream";
                rateDiscount4		= adv.getValue(lineId, "advendio__media_campaign__r.somdig_sonderrabatt_instream__c");
                rateDiscount4Name	= "InStream";
            } // there is no else
            
            adv.setValue(lineId, "advendio__rate_discount_2_custom__c", rateDiscount2);
            triggerChange(lineId, "advendio__rate_discount_2_custom__c");
            
            adv.setValue(lineId, "advendio__ratediscount2name__c", rateDiscount2Name);
            
            adv.setValue(lineId, "advendio__rate_discount_4__c", rateDiscount4);
            triggerChange(lineId, "advendio__rate_discount_4__c");
            
            adv.setValue(lineId, "advendio__rate_discount_4_name__c", rateDiscount4Name);
            
            adv.setValue(lineId, "advendio__rate_discount_3_custom__c", rateDiscount3);
            triggerChange(lineId, "advendio__rate_discount_3_custom__c");
        }
    }
    
    var handlerCopyValues = function(event) {
        var lineId = adv.getLineId(this);
        var fieldName = event.target.getAttribute('fieldname');
        var fieldValue = adv.getValue(lineId, fieldName);
        var rtDeveloperName = adv.getValue(lineId, "recordtype-developername");
        if(rtDeveloperName == "Packet") {
            cj$.each(getArrEComponentCustom(lineId), function() {
                var componentLineId = this[0].id;
                if(isValidForTargeting(componentLineId, fieldName)) {
                    adv.setValue(componentLineId, fieldName, fieldValue);
                    triggerChange(componentLineId, fieldName);
                }
            });
        }
    }
    
    function isValidForTargeting(lineId, fieldName) {
        var isValid = false;
        if(fieldName == 'advendio__fc_period__c' || fieldName == 'advendio__fc_quantity__c') {
            isValid = adv.getValue(lineId, 'advendio__ad_price__r.advendio__ad_spec__r.somdig_fc__c');
        } else if(fieldName == 'advendio__selected_cities__r' || fieldName == 'advendio__selected_regions__r' || fieldName == 'advendio__selected_countries__r') {
            isValid = adv.getValue(lineId, 'advendio__ad_price__r.advendio__ad_spec__r.somdig_gtfaehig__c') || adv.getValue(lineId, 'advendio__ad_price__r.advendio__ad_spec__r.somdig_targetingaufschlag__c') !== null;
        } else if(fieldName == 'advendio__adhourofday__c' || fieldName == 'advendio__addayofweek__c') {
            isValid = true;
        } else if(fieldName == 'advendio__rate_discount_4_name__c') {
            isValid = true;
        }
        return isValid;
    }
    
    /**
	 * Triggers input field change events.
	 * @param lineId
	 * @param className field api name to trigger
	 */
    function triggerChange(lineId, className) {
        if (cj$("tr#"+lineId).find("."+className).length > 0) {
            cj$("tr#"+lineId).find("."+className).first().trigger("change");
        }
    }
    
    // advendio__fc_ad_served_every__c
    cj$(document).on("change", ".advendio__fc_ad_served_every__c", handlerAufschlag);
    
    // advendio__fc_period__c
    cj$(document).on("change", ".advendio__fc_period__c", handlerFC);
    cj$(document).on("change", ".advendio__fc_period__c", handlerAufschlag);
    cj$(document).on("change", ".advendio__fc_period__c", handlerCopyValues);
    
    // advendio__fc_quantity__c
    cj$(document).on("change", ".advendio__fc_quantity__c", handlerFC);
    cj$(document).on("change", ".advendio__fc_quantity__c", handlerAufschlag);
    cj$(document).on("change", ".advendio__fc_quantity__c", handlerCopyValues);
    
    // advendio__keylines__r
    cj$(document).on("change", ".advendio__keylines__r", handlerAufschlag);
    
    // advendio__rate_discount_4_name__c
    cj$(document).on("change", ".advendio__rate_discount_4_name__c", handlerRateDiscount4Name);
    cj$(document).on("change", ".advendio__rate_discount_4_name__c", handlerCopyValues);
    
    // advendio__sales_price__c
    cj$(document).on("change", ".advendio__sales_price__c", handlerAufschlag);

    // advendio__selectedadserverids__r-postalcode
    cj$(document).on("change", ".advendio__selectedadserverids__r-postalcode", handlerAufschlag);
    
    // advendio__selected_countries__r
    cj$(document).on("change", ".advendio__selected_countries__r", handlerAufschlag);
    
    // advendio__selected_regions__r
    cj$(document).on("change", ".advendio__selected_regions__r", handlerAufschlag);
    
    // advendio__selected_cities__r
    cj$(document).on("change", ".advendio__selected_cities__r", handlerAufschlag);
    
    // somdig_adgapid__c
    cj$(document).on("change", ".somdig_adgapid__c", handlerAufschlag);
    
    // somdig_otpaufschlag__c
    cj$(document).on("change", ".somdig_otpaufschlag__c", handlerAufschlag);
    
    // somdig_retargeting__c
    cj$(document).on("change", ".somdig_retargeting__c", handlerAufschlag);
})();