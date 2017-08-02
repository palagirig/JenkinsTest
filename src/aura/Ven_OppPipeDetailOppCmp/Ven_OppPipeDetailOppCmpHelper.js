({
	handleStatusChange : function(component){
		var status = component.get("v.opp.StageName"),
		setProbability= component.get("v.setProbability"),
		cliTT = component.find("likelihoodTT"),
		probability;

		component.set("v.isLostCancelled", false);
		component.set("v.statusString", status);

		if(status === 'Closed Lost' || status === 'Cancelled' || status === 'Storniert'){
			component.set("v.isLostCancelled", true);
		}

		if(setProbability){

			//Show Tooltip
			$A.util.removeClass(cliTT, 'hideIt');

			if(status === 'Closed Lost' || status === 'Cancelled' || status === 'Storniert'){
				// Lost, Cancelled
				probability = 0;
			}else if(status === 'Potential' || status === 'Potenzial'){
				// Potential
				probability = 0;
			}else if(status === 'Contacted' || status === 'Erstgespräch Bedarf/Bestand'){
				// Contacted
				probability = 2;
			}else if(status === 'In Briefing' || status === 'In Briefing/Erstgespräch'){
				// Contacted
				probability = 5;
			}else if(status === 'M2N' || status === 'Rabatt freigegeben'){
				// M2N
				probability = 15;
			}else if(status === 'Deal Approval' || status === 'Deal approval'){
				// Deal approval
				probability = 75;
			}else if(status === 'Parked'){
				// Parked
				probability = 0;
			}else if(status === 'Closed Won'){
				// Parked
				probability = 100;
			}else {
				probability = 0;
			}

			component.set("v.opp.Probability", probability);
			component.set("v.opp.StageName", status);

			//Hide Tooltip
			window.setTimeout($A.getCallback(function(){
                $A.util.addClass(cliTT, 'hideIt');
            }), 6000);


            //Check status of Effective Yield
			this.checkEffectiveYield(component, status);
		}

		component.set("v.setProbability", true);

	},

	checkEffectiveYield : function(component, status){
		var effYield = component.get("v.opp.Ven_EffectiveYield__c");
		//if( (status === 'M2N' || status === 'In Briefing' || status === 'Deal Approval') && ($A.util.isEmpty(effYield) || effYield <= 0) ){
		if( (status === 'M2N' || status === 'Rabatt freigegeben' || status === 'In Briefing' || status === 'In Briefing/Erstgespräch' || status === 'Deal Approval' || status === 'Deal approval') && ($A.util.isEmpty(effYield) || effYield <= 0) ){
			component.set("v.effYieldValid", false);
		}else{
			component.set("v.effYieldValid", true);
		}
	},

	handleCountryChange : function(component) {
		var countryObj 	= component.get("v.countryInternational");
		var country 	= component.get("v.opp.Ven_Country__c");

		if(countryObj[country]){
			component.set("v.opp.Ven_International__c", true);
		} else {
			component.set("v.opp.Ven_International__c", false);
		}
	},

	handleOwnerChange : function(component){
		var im1 		= component.get("v.opp.OwnerId");
		var userRoles 	= component.get("v.userRoles");
		var austria 	= component.get("v.austriaRole");
		var switzerland	= component.get("v.switzerlandRole");

		if(userRoles[im1] === austria){
			component.set("v.opp.Ven_TargetPL__c", "Austria");
		}else if(userRoles[im1] === switzerland){
			component.set("v.opp.Ven_TargetPL__c", "Switzerland");
		}else {
			component.set("v.opp.Ven_TargetPL__c", "Germany");
		}
	},

	handleNameChange : function(component){
		var oppName = component.find("oppName");
		var isValid = true;

		if(!oppName.get("v.value") || oppName.get("v.value").length === 0){
			oppName.set("v.errors", [{message:"Complete this field"}]);
			isValid = false;
		}else {
			oppName.set("v.errors", null);
		}

		component.set("v.isValidName", isValid);
	},

  /**** BS 31.07.17 - EUR as default Currency ****
	handleCurrencyChange : function(component){

		var params = {
			"currency" 			: component.get("v.opp.CurrencyIsoCode"),
			"clientLikelihood" 	: null
		};

		$A.get("e.c:Ven_OppPipeDetailOppEvent").setParams(params).fire();
	},*/

	handleClientLikelihoodChange : function(component){

		var params = {
			"currency" 			: null,
			"clientLikelihood" 	: component.get("v.opp.Probability")
		};

		$A.get("e.c:Ven_OppPipeDetailOppEvent").setParams(params).fire();
	},

	checkValidCmp : function(component) {
		var checkCmpList = true;
		var cmpList = component.find("checkField");
		var validName = component.get("v.isValidName");

		if(!$A.util.isEmpty(cmpList)) {
			for(var cmp = 0; cmpList.length > cmp; cmp+= 1 ) {
				if (cmpList[cmp].get('v.isValid') === false) {
					checkCmpList = false;
					break;
				}
			}
		}
		component.set("v.isValid", checkCmpList && validName);
	}
})