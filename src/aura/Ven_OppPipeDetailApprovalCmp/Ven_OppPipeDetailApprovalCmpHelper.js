({
	checkValidCmp : function(component) {
  		var checkCmpList = true;
  		var cmpList = component.find("checkField");

  		if(!$A.util.isEmpty(cmpList)) {
  			for(var cmp = 0; cmpList.length > cmp; cmp+= 1 ) {
  				if (cmpList[cmp].get('v.isValid') === false) {
  					checkCmpList = false;
  					break;
  				}
  			}
  		}
  		component.set("v.isValid", checkCmpList);
  	},

  	handleRevenueChange : function(component){
  	    var amount = component.get("v.approval.MT_VariableRevenue1_SoldAmount__c"),
  	    revenue = component.get("v.approval.MT_VariableRevenue1_RevenuePerUnit__c"),
  	    total;

  	    if(!$A.util.isEmpty(amount) && !$A.util.isEmpty(revenue)){
  	        total = amount * revenue;
        }else{
            total = 0;
        }

        if(!$A.util.isEmpty(component.get("v.approval"))){
            component.set("v.approval.MT_VariableRevenue1_TotalRevenue__c", total.toFixed(2));
        }
    }
})