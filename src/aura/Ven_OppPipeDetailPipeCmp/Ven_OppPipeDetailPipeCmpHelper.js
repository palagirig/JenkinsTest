({
	setEffYield : function(component, helper){
		var cashYield = parseFloat(parseFloat(component.find("cashYield").get("v.value")).toFixed(1));
		var prapYield = parseFloat(parseFloat(component.find("prapYield").get("v.value")).toFixed(1));

		component.find("cashYield").set("v.value", cashYield);
		component.find("prapYield").set("v.value", prapYield);

		var cashYieldValid 	= component.find("cashYield").get("v.isValid");
		var prapYieldValid 	= component.find("prapYield").get("v.isValid");

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

	checkValidCmp : function(component) {
		var checkCmpList = true;
		var checkDealStructure = this.checkValidDealStructure(component);

    var effYieldValid = component.get("v.effYieldValid");
		var cashYield = component.find("cashYield");
		var prapYield = component.find("prapYield");

		var cmpList = component.find("checkField");
		cmpList.push(cashYield);
		cmpList.push(prapYield);

		if(!$A.util.isEmpty(cmpList)) {
			for(var cmp = 0; cmpList.length > cmp; cmp+= 1 ) {
				if (cmpList[cmp].get('v.isValid') === false) {
					checkCmpList = false;
					break;
				}
			}
		}

		component.set("v.isValid", checkCmpList && effYieldValid && checkDealStructure);

	},

	checkValidDealStructure : function(component){
	  var cmpList = component.find("dealStructure"),
	  checkDealStructure = false;

	  if(!$A.util.isEmpty(cmpList)) {
	    for(var cmp = 0; cmpList.length > cmp; cmp+= 1 ) {
        if ( !$A.util.isEmpty(cmpList[cmp].get('v.value')) && cmpList[cmp].get('v.value') === true ) {
          checkDealStructure = true;
          break;
        }
      }
	  }

	  component.set("v.dealStructureValid", checkDealStructure);

	  return checkDealStructure;
  }
})