({
	doInit: function(component, event, helper) {
		component.set("v.currentMonth", new Date().getMonth()+1);
	},

	doHandleOppPipeDetailOppEvent : function(component, event, helper){
		var clientLikelihood = event.getParam("clientLikelihood");

		if(clientLikelihood !== null){
			component.set("v.clientLikelihood", clientLikelihood);
			var totalNetPot = helper.calcTotalNetPot(component, helper);
			component.set("v.totalNetPot", totalNetPot);
		}
	},

	doHandleAmountChange : function(component, event, helper){
		var totalNetPot = helper.calcTotalNetPot(component, helper);
		component.set("v.totalNetPot", totalNetPot);
	},

	doHandleEffYieldChange : function(component, event, helper){
		var totalNetPot = helper.calcTotalNetPot(component, helper);
		component.set("v.totalNetPot", totalNetPot);
	},
	
	doSetSum1 : function(component, event, helper){helper.setSum(component, 1)},
	doSetSum2 : function(component, event, helper){helper.setSum(component, 2)},
	doSetSum3 : function(component, event, helper){helper.setSum(component, 3)},
	doSetSum4 : function(component, event, helper){helper.setSum(component, 4)},
	doSetSum5 : function(component, event, helper){helper.setSum(component, 5)},
	doSetSum6 : function(component, event, helper){helper.setSum(component, 6)},
	doSetSum7 : function(component, event, helper){helper.setSum(component, 7)},
	doSetSum8 : function(component, event, helper){helper.setSum(component, 8)},
	doSetSum9 : function(component, event, helper){helper.setSum(component, 9)},
	doSetSum10 : function(component, event, helper){helper.setSum(component, 10)},
	doSetSum11 : function(component, event, helper){helper.setSum(component, 11)},
	doSetSum12 : function(component, event, helper){helper.setSum(component, 12)}
})