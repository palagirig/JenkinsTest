({
	checkValid: function(component) {
		var cashYieldValid 	= component.get("v.cashYieldValid");
		var prapYieldValid 	= component.get("v.prapYieldValid");
		var cashInvestValid = component.get("v.cashInvestValid");
		var gmvCurrentValid = component.get("v.gmvCurrentValid");
		var gmvNextValid 	= component.get("v.gmvNextValid");
		var effYieldValid 	= component.get("v.effYieldValid");
		
		component.set("v.isValid", false);
		
		if(cashYieldValid && prapYieldValid && cashInvestValid && gmvCurrentValid && gmvNextValid && effYieldValid){
			component.set("v.isValid", true);
		}
	},

	setEffYield : function(component, helper){
		var cashYield = parseFloat(parseFloat(component.find("cashYield").get("v.value")).toFixed(1));
		var prapYield = parseFloat(parseFloat(component.find("prapYield").get("v.value")).toFixed(1));

		component.find("cashYield").set("v.value", cashYield);
		component.find("prapYield").set("v.value", prapYield);

		var cashYieldValid 	= component.get("v.cashYieldValid");
		var prapYieldValid 	= component.get("v.prapYieldValid");

		if(cashYieldValid && prapYieldValid){
			var effYield = cashYield + prapYield;
			component.find("effYield").set("v.value", Math.round( effYield * 10 ) / 10); // round to 1 decimal place
		}
		
		this.checkEffectiveYield(component);
	},
	
	checkEffectiveYield : function(component){
		var effYield = component.get("v.oppPipeDetail.opp.Ven_EffectiveYield__c"),
		status = component.get("v.oppPipeDetail.opp.StageName");
		
		if( (status === 'M2N' || status === 'In Briefing' || status === 'Deal Approval') && ($A.util.isEmpty(effYield) || effYield <= 0) ){
			component.set("v.effYieldValid", false);
		}else{
			component.set("v.effYieldValid", true);
		}
	},
})