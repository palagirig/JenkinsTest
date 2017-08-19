(function() {
	var cj$ = jQuery.noConflict();
	
	
	var preventSurchargeCountries   = null; // to be queried
	var specialKeys				 = ["Ausschluss-Identifier"];
	var specialValues			   = ["Videovalis.de"];
	var objUser					 = null; // to be queried
	var profiles					= {somdig_billing:"00eD0000001Qk4nIAC", admin:"00e20000000lfOjAAI", somdig_pam:"00eD0000001Qf2oIAC", somdig_bi:"00e570000012uRgAAI", somdig_sales:"00e20000001QBtUAAW", somdig_pm:"00eD0000001QaccIAC", somtv_conversion:"00e570000016NbpAAE"};
	var handlerBugetN2QuantityChangesDone	= false;
	
	// used to store old values.
	var oldSalesprice = {};
	
	cj$(document).ready(function() {
		cj$.getScript("/soap/ajax/35.0/connection.js").done(function(script, textStatus) { // this runs always async
			preventSurchargeCountries = getPreventSurchargeCountries();
			
			objUser = getUser();
			// 6359 - Naturalrabatt - Teil 7 - Berechtigungen
			removeNaturalrabattReadOnlyForAllowedProfiles();
		});

		cj$.each(cj$("tr.LineItemRow"), function() {
			var lineId  = cj$(this).attr("id");
			setDefaults_AddItemsOptimizer(lineId);
			if (adv.getFeatureName() == "Add Items (Optimizer)" || adv.getFeatureName() == "Campaign Item Creation") {
				if (isValidPackageHeaderOrStandardItem(lineId)) {
					setDefaultDiscounts_AddItemsOptimizer(lineId);
				}
			}
		});

		if(adv.getFeatureName() == "Edit Items (Optimizer)") {
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
		removeReadOnlyFromFieldAllRows('input.advendio__ad_id__c');  
		removeReadOnlyFromFieldAllRows('input.advendio__additional_ad_ids__c');
		removeReadOnlyFromFieldAllRows('input.advendio__adserverid_order_id__c');
		removeHiddenFromField('textarea.advendio__selectedadserverids__r-postalcode');
	});

	/*
	 * Removes hidden attributes.
	 */
	function removeHiddenFromField(fieldName) {
		jQuery.each(jQuery(fieldName), function() {
			if (jQuery(this).hasClass("hiddenHtmlElement")) {
				jQuery(this).css('display', 'inline');
			}
		});
	}
	
	// 6005 - Make AdID fields editable.
	function removeReadOnlyFromFieldAllRows(fieldName) {
		jQuery.each(jQuery(fieldName), function() {
			var lineId = adv.getLineId(this);
			if(adv.getValue(lineId, 'somdig_stornoposition__c')) {
				jQuery(this).removeAttr("disabled");
				jQuery(this).parents("td").removeAttr("readonlyfield");
			}
		});
	}

	// 6359 - Naturalrabatt - Teil 7 - Berechtigungen
	function removeNaturalrabattReadOnlyForAllowedProfiles() {
		jQuery.each(jQuery('[fieldname=somdig_naturalrabatt__c]'), function() {
			var lineId = adv.getLineId(this);
			removeNRFieldReadOnly(lineId);
		});
		
	}

	// 6359 - Naturalrabatt - Teil 7 - Berechtigungen
	/**
	 * Evaluates if read-only could be removed from naturalrabatt.
	 * (Mediagattungsdifferenzierung, User Profile, User Teamlead, rate discount 4 name, MK recordtype)
	 * @param lineId ID of the campaign position.
	 */
	function removeNRFieldReadOnly(lineId) {
		var adSpec_mgd		= adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.somdig_mediagattungsdifferenzierung__c");
		var rateDiscount4Name = adv.getValue(lineId, "advendio__rate_discount_4_name__c");
		var billingCategory   = adv.getValue(lineId, "advendio__billing_category__c");
		
		var isOptimizer = adv.getFeatureName() == "Add Items (Optimizer)" || adv.getFeatureName() == "Edit Items (Optimizer)";
		var userHasAuftragKEMPermission = objUser.profileId == profiles['somdig_billing'] || objUser.profileId == profiles['admin'];
		var userHasAuftragPermission = userHasAuftragKEMPermission || (objUser.SomDig_IsTeamLead__c && (objUser.profileId == profiles['somdig_pam'] || objUser.profileId == profiles['somdig_bi']));
		var userHasAngebotPermission = objUser.profileId == profiles['somdig_sales'] || objUser.profileId == profiles['somdig_bi'] || objUser.profileId == profiles['somdig_pam'] || objUser.profileId == profiles['somdig_pm'] || objUser.profileId == profiles['somdig_billing'] || objUser.profileId == profiles['somtv_conversion'] || objUser.profileId == profiles['admin'];
		var mcRecordType = adv.getValue(lineId, "advendio__media_campaign__r.recordtype.developername");

		if('CPM'==billingCategory && adSpec_mgd == 'InPage/Display' && rateDiscount4Name != 'Positionsrabatt Natural' && ((mcRecordType == 'SomDig_Angebot' && userHasAngebotPermission) || (mcRecordType == 'SomDig_Auftrag' && userHasAuftragPermission && (isOptimizer || userHasAuftragKEMPermission))) && isValidPackageHeaderOrStandardItem(lineId)) {
			removeFieldReadOnly(lineId, 'somdig_naturalrabatt__c');
		} else {
			setFieldReadOnly(lineId, 'somdig_naturalrabatt__c');
		}
	}

	function setFieldReadOnly(lineId, fieldName) {
		var element = jQuery("[class*=" + lineId + "][fieldname=" + fieldName + "]");
		if(element.length > 0) {
			element.attr("disabled", "disabled");
			element.parents("td").attr("readonlyfield", "true");
		}
	}

	function removeFieldReadOnly(lineId, fieldName) {
		var element = jQuery("[class*=" + lineId + "][fieldname=" + fieldName + "]");
		if(element.length > 0) {
			element.removeAttr("disabled");
			element.parents("td").removeAttr("readonlyfield");
		}
	}

	function getUser() {
		sforce.connection.sessionId = adv.getSessionId();
		var userInfo = sforce.connection.getUserInfo();
		var result = sforce.connection.query("SELECT id, SomDig_IsTeamLead__c FROM User WHERE ID = '"+userInfo.userId+"' LIMIT 1");
		if(result.getArray("records").length > 0) {
			result.getArray("records")[0].profileId = userInfo.profileId; // Not all users have permission for profile field on user. Add it manually.
			result.getArray("records")[0].SomDig_IsTeamLead__c = "true" == result.getArray("records")[0].SomDig_IsTeamLead__c.toLowerCase() ? true : false;
			return result.getArray("records")[0];
		}
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
		var remoteUrl   = "https://"+instanceName+"/services/data/v35.0/query/?q="+encodeURI(query);
		var remoteAuth  = 'Bearer '+adv.getSessionId();
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
		var lineId		  = adv.getLineId(this);
		
		if (isValidPackageHeaderOrStandardItem(lineId)) {
			cj$.getScript("/soap/ajax/35.0/connection.js").done(function(script, textStatus) { // this runs always async
				var surchargeSalesPrice = 0;
				
				var salesPrice		  = adv.getValue(lineId, "advendio__sales_price__c");
				var adPrice_listPrice   = adv.getValue(lineId, "advendio__ad_price__r.advendio__list_price__c");
				
				if (salesPrice == adPrice_listPrice) {
					var adSpec_fcAufschlag  = adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.somdig_fcaufschlag__c");
					var fcAdServedEvery	 = adv.getValue(lineId, "advendio__fc_ad_served_every__c");
					var fcPeriod			= adv.getValue(lineId, "advendio__fc_period__c");
					var fcQuantity		  = adv.getValue(lineId, "advendio__fc_quantity__c");
					var billingCategory	 = adv.getValue(lineId, "advendio__billing_category__c");
					var adSpec_mgd		  = adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.somdig_mediagattungsdifferenzierung__c");
					var otpAufschlag		= adv.getValue(lineId, "somdig_otpaufschlag__c");
					
					// fc aufschlag
					if (adSpec_fcAufschlag !== "" && billingCategory != "CPD" && billingCategory != "CPW" && fcAdServedEvery !== "" && fcAdServedEvery >= 1
						&& (fcPeriod == "week" || fcPeriod == "month" || fcPeriod == "campaign") && adSpec_mgd == "InStream/Video" && otpAufschlag == false) {
						surchargeSalesPrice += adSpec_fcAufschlag;
					}
					
					var adSpec_targetingaufschlag   = adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.somdig_targetingaufschlag__c");
					var adgapid					 = adv.getValue(lineId, "somdig_adgapid__c");
					var keylines					= cj$(document.getElementById(lineId)).find(".advendio__keylines__r").first().val();
					var arrKeyLines				 = parseKeyLines(keylines);
					var countries				   = cj$(document.getElementById(lineId)).find(".advendio__selected_countries__r").first().val();
					var arrCountries				= parseCountries(countries);
					var regions					 = cj$(document.getElementById(lineId)).find(".advendio__selected_regions__r").first().val();
					var cities					  = cj$(document.getElementById(lineId)).find(".advendio__selected_cities__r").first().val();
					var plzs						= cj$(document.getElementById(lineId)).find(".advendio__selectedadserverids__r-postalcode").first().val();
					
					if(!plzs) plzs = ''; // incident hotfix. plzs is undefined as it can not find advendio__selectedadserverids__r-postalcode field.
					
					// targeting aufschlag
					if (adSpec_targetingaufschlag !== "" && adgapid == "" && (plzs != "" || regions != "" || cities != "" || isValidKeyValueTargeting_TargetingAufschlag(arrKeyLines) || (arrKeyLines.length == 0 && isValidCountryTargeting(arrCountries)))) {
						surchargeSalesPrice += adSpec_targetingaufschlag;
					}
					
					var adSpec_retargetingAufschlag = adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.somdig_retargetingsurcharge__c");
					var retargeting			 = adv.getValue(lineId, "somdig_retargeting__c");
					
					// retargeting aufschlag
					if (adSpec_retargetingAufschlag !== "" && retargeting == true) {
						surchargeSalesPrice += adSpec_retargetingAufschlag;
					}
					
					var adSpec_rotationsAufschlag   = adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.somdig_rotationexclusionsurcharge__c");
					var adSpec_rotationsTyp   = adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.somdig_rotationstyp__c");

					// rotations aufschlag
					if (adSpec_rotationsAufschlag !== "" && isValidKeyValueTargeting_RotationsAufschlag(arrKeyLines, adSpec_rotationsTyp)) {
						surchargeSalesPrice += adSpec_rotationsAufschlag;
					}
					
					var adSpec_otpAufschlag = adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.somdig_otpaufschlag__c");
					
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
		var lineId		  = adv.getLineId(this);
		
		var fcPeriod		= adv.getValue(lineId, "advendio__fc_period__c");
		var fcQuantity	  = adv.getValue(lineId, "advendio__fc_quantity__c");
		
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
	
	var handlerBugetN2QuantityChanges = function() {
		var lineId					= adv.getLineId(this);
		var adv_budgetn2			= adv.getValue(lineId, "advendio__budgetn2__c");

		if (adv_budgetn2 != "" && !handlerBugetN2QuantityChangesDone) {
			var adv_menge			= adv.getValue(lineId, "advendio__quantity__c");
			var som_menge			= adv.getValue(lineId, "somdig_menge__c");
			var som_naturalrabatt	= adv.getValue(lineId, "somdig_naturalrabatt__c");
			som_menge				= som_menge == "" ? 0 : som_menge;
			som_naturalrabatt		= som_naturalrabatt == "" ? 0 : som_naturalrabatt;
			som_menge				= Math.round(adv_menge - (som_menge * som_naturalrabatt / 100));

			handlerBugetN2QuantityChangesDone	= true;
			adv.setValue(lineId, "somdig_menge__c", som_menge);
			triggerChange(lineId, "somdig_menge__c");
			
			handlerBugetN2QuantityChangesDone	= false;
		}
	}

	/**
	 * calculates advendio__quantity__c based on somdig_menge__c and somdig_naturalrabatt__c
	 */
	var handlerNaturalrabatt = function() {
		var lineId			  = adv.getLineId(this);
		var som_menge		   = adv.getValue(lineId, "somdig_menge__c");
		var som_naturalrabatt   = adv.getValue(lineId, "somdig_naturalrabatt__c");
		var adv_salespreis	  = adv.getValue(lineId, "advendio__sales_price__c");
		var adv_preisaufschlag  = adv.getValue(lineId, "advendio__surchargesalesprice__c");
		var adv_frequency	   = adv.getValue(lineId, "advendio__frequency__c");
		var adv_billingcategory = adv.getValue(lineId, "advendio__billing_category__c");
		var rateDiscount4Name   = adv.getValue(lineId, "advendio__rate_discount_4_name__c");
		
		som_menge			   = som_menge == "" ? 0 : som_menge;
		som_naturalrabatt	   = som_naturalrabatt == "" ? 0 : som_naturalrabatt;
		
		var adv_menge		   = Math.round(som_menge + (som_menge * som_naturalrabatt / 100));

		adv.setValue(lineId, "somdig_menge__c", som_menge);
		adv.setValue(lineId, "somdig_naturalrabatt__c", som_naturalrabatt);
		adv.setValue(lineId, "advendio__quantity__c", adv_menge);
		
		var b3Normal					= calculateAmount_B3__c(adv_billingcategory, adv_salespreis, som_menge, adv_frequency, adv_preisaufschlag);
		var b3MitNaturalrabatt		  = calculateAmount_B3__c(adv_billingcategory, adv_salespreis, adv_menge, adv_frequency, adv_preisaufschlag);
		var b3NaturalrabattAufschlag	= b3Normal - b3MitNaturalrabatt;
		
		adv.setValue(lineId, "advendio__surchargeb3abs__c", b3NaturalrabattAufschlag);
		if(adv.getValue(lineId, "somdig_naturalrabatt__c") != 0) {
			adv.setValue(lineId, "advendio__surchargeb3__c", 0);
		}

		triggerChange(lineId, "advendio__quantity__c");
		triggerChange(lineId, "advendio__surchargeb3abs__c");
		
		var recordTypeDeveloperName	 = adv.getValue(lineId, "recordtype-developername");
		var distribution				= adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.advendio__distribution__c");
		var className				   = getClassName(this);
		
		if (recordTypeDeveloperName == "Packet" && distribution == "Linear") {
			if (className == "somdig_naturalrabatt__c") {
				cj$.each(getArrEComponentCustom(lineId), function() {
					var id = this[0].id;
					adv.setValue(id, "somdig_naturalrabatt__c", som_naturalrabatt);
				});
			}
		}
		if (recordTypeDeveloperName == "Packet" && distribution == "Prorated") {
			if (className == "somdig_naturalrabatt__c") {
				cj$.each(getArrEComponentCustom(lineId), function() {
					var id = this[0].id;
					adv.setValue(id, "somdig_naturalrabatt__c", som_naturalrabatt);
				});
			}
			if (className == "somdig_menge__c"){
				var ePacket	 = getEPacket(lineId, className);
				var packetRow   = getRow(ePacket);
				calculatePacketLinearOrProratedCustom(className, packetRow, lineId, getArrEComponentCustom(lineId), distribution);
			}
		}
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
				adv.setValue(lineId, "somdig_naturalrabatt__c", '0'); // 06323 - NR validation.
				setFieldReadOnly(lineId, 'somdig_naturalrabatt__c'); // 06323 - NR validation.
				triggerChange(lineId, "somdig_naturalrabatt__c");
				triggerChange(lineId, "advendio__surchargeb3__c");
			} else {
				adv.setValue(lineId, "advendio__surchargeb3__c", 0);
				removeNRFieldReadOnly(lineId); // 06323 - NR validation.
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
		var recordTypeDeveloperName	 = adv.getValue(lineId, "recordtype-developername");
		var packetItem__rId			 = adv.getValue(lineId, "advendio__packetitem__r.id");
		var distribution				= adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.advendio__distribution__c");
		
		if ((recordTypeDeveloperName == "Packet" && distribution == "Prorated") || (recordTypeDeveloperName != "Packet" && packetItem__rId === "")) {
			return true;
		} else {
			return false;
		}
	}
	
	/**
	 * Calculates a packet (linear) / packet (Prorated).
	 * Packet item and component items.
	 */
	var calculatePacketLinearOrProratedCustom = function(className, packetRow, packetId, arrEComponent, packetAd_Price__rAd_Spec__rDistribution__c) {
		var packetBilling_category__c				   = getValueOfRowFormatted(packetRow, packetId, "advendio__billing_category__c");
		var packetQuantity__c						   = getValueOfRowFormatted(packetRow, packetId, "somdig_menge__c");
		
		var componentSize = arrEComponent.length;
		var componentValueWithoutRest = null;
		var componentValueRest = null;
		
		if (isQuantityShareablePackage(packetBilling_category__c)) {
			if (packetAd_Price__rAd_Spec__rDistribution__c == "Prorated") {
				componentValueWithoutRest = packetQuantity__c;
				componentValueRest = 0;
			} else {
				componentValueWithoutRest = parseInt(packetQuantity__c / componentSize);
				componentValueRest = packetQuantity__c - (componentValueWithoutRest * componentSize);
			}
		} else {
			componentValueWithoutRest = packetQuantity__c;
			componentValueRest = 0;
		}
		
		var sumComponentValue = 0;
		var highestComponentProrated = null;
		
		j$.each(arrEComponent, function() {
			var componentRow = getRow(this);
			var componentId = getValueOfRowFormatted(componentRow, null, "id");
			var componentValue = componentValueWithoutRest;
			
			if (componentValueRest != 0) {
				if (isInt(componentValueRest)) {
					if (componentValueRest > 0) {
						componentValue = componentValue + 1;
						componentValueRest = componentValueRest - 1;
					} else {
						componentValue = componentValue - 1;
						componentValueRest = componentValueRest + 1;
					}
				} else {
					componentValue = parseFloat(componentValue) + componentValueRest;
					componentValueRest = 0;
				}
			} else if (packetAd_Price__rAd_Spec__rDistribution__c == "Prorated" && isQuantityShareablePackage(packetBilling_category__c)) {
				var componentProrated__c = getValueOfRowFormatted(componentRow, componentId, "advendio__prorated__c");
				componentValue = parseInt(componentValue * (componentProrated__c / 100));
				sumComponentValue += componentValue;
				if (highestComponentProrated == null || componentProrated__c > highestComponentProrated) {
					highestComponentProrated = componentProrated__c;
				}
			}
			
			if (componentValue == 0 && getValueOfRow(packetRow, packetId, "somdig_menge__c", false) === "") {
				componentValue = "";
			}
			
			setValueOfRow(componentRow, componentId, className, componentValue);
		});
		
		if (packetAd_Price__rAd_Spec__rDistribution__c == "Prorated" && highestComponentProrated != null) {
			var packetValue;
			
			if (isQuantityShareablePackage(packetBilling_category__c)) {
				packetValue = packetQuantity__c;
			}
			
			if (packetValue != sumComponentValue) {
				j$.each(arrEComponent, function() {
					var componentRow = getRow(this);
					var componentId = getValueOfRowFormatted(componentRow, null, "id");
					
					if (getValueOfRowFormatted(componentRow, componentId, "advendio__prorated__c") > 0 && getValueOfRowFormatted(componentRow, componentId, "advendio__prorated__c") == highestComponentProrated) {
						var componentValue = getValueOfRowFormatted(componentRow, componentId, className);
						var componentValueRest = packetValue - sumComponentValue;
						setValueOfRow(componentRow, componentId, className, (componentValue + componentValueRest));
						
						return false;
					}
				});
			}
		}
	}

	/**
	 * Sets Defaults.
	 * @param lineId
	 */
	function setDefaults_AddItemsOptimizer(lineId) {
		var som_menge   = adv.getValue(lineId, "somdig_menge__c");
		var adv_menge   = adv.getValue(lineId, "advendio__quantity__c");
		
		if (som_menge == "") {
			adv.setValue(lineId, "somdig_menge__c", adv_menge);
		}
	}
	
	/**
	 * Sets Default Discounts.
	 * @param lineId
	 */
	function setDefaultDiscounts_AddItemsOptimizer(lineId) {
		var mgd	 = adv.getValue(lineId, "advendio__ad_price__r.advendio__ad_spec__r.somdig_mediagattungsdifferenzierung__c");
		
		if (mgd == "InPage/Display" || mgd == "InStream/Video") {
			var naturalRabatt = adv.getValue(lineId, "advendio__media_campaign__r.somdig_naturalrabatt_inpage__c");
			var rateDiscount2;
			var rateDiscount2Name;
			var rateDiscount3 = adv.getValue(lineId, "advendio__media_campaign__r.somdig_agenturrabatt__c");
			var rateDiscount4;
			var rateDiscount4Name;
			if (mgd == "InPage/Display") {
				adv.setValue(lineId, "somdig_naturalrabatt__c", naturalRabatt);
				triggerChange(lineId, "somdig_naturalrabatt__c");
			
				rateDiscount2	   = adv.getValue(lineId, "advendio__media_campaign__r.somdig_kundenrabatt_inpage__c");
				rateDiscount2Name   = "InPage";
				rateDiscount4	   = adv.getValue(lineId, "advendio__media_campaign__r.somdig_sonderrabatt_inpage__c");
				rateDiscount4Name   = "InPage";
			} else if (mgd == "InStream/Video") {
				rateDiscount2	   = adv.getValue(lineId, "advendio__media_campaign__r.somdig_kundenrabatt_instream__c");
				rateDiscount2Name   = "InStream";
				rateDiscount4	   = adv.getValue(lineId, "advendio__media_campaign__r.somdig_sonderrabatt_instream__c");
				rateDiscount4Name   = "InStream";
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
	
	cj$(document).on("change", ".somdig_menge__c", handlerNaturalrabatt);
	cj$(document).on("change", ".somdig_naturalrabatt__c", handlerNaturalrabatt);
	
	
	cj$(document).on("change", ".advendio__quantity__c", handlerBugetN2QuantityChanges);
	
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