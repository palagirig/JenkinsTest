({
	doInit : function(component, event, helper){
		helper.getOppPipeData(component, helper);
		component.set("v.isPipeBtnSelected", true);
		component.set("v.isPrePipeBtnSelected", false);
		component.set("v.summaryItemsChanged", false);

		$A.util.removeClass(component.find("pipeBtn"), "btn-default");
		$A.util.addClass(component.find("pipeBtn"), "btn-primary");
		$A.util.addClass(component.find("prePipeBtn"), "btn-default");
		$A.util.removeClass(component.find("prePipeBtn"), "btn-primary");
	},

	doInitScripts : function(component, event, helper){
		/*** Does not work with Locker-Service ***
		helper.initToastr();
		*/
	},

	doHandleOppPipeSummaryEvt : function(component, event, helper){
		helper.doDetail(component, event, helper);
	},

	doHome : function(component, event, helper){
		location.href = "/home/home.jsp";
		//window.location = "/home/home.jsp";
	},

	doExport : function(component, event, helper){
		helper.export2Csv(component, helper);
	},
	
	doChecked : function(component, event, helper){
		helper.onPipelineChecked(component, helper);
	},

	doNewOpp : function(component, event, helper){
		helper.newOpp(component, helper);
	},

	doSave : function(component, event, helper){
		helper.save(component, helper);
	},

	doCancel : function(component, event, helper){
		helper.cancel(component);
	},

	doDelete : function(component, event, helper){
		helper.discard(component);
	},

	onIsAlreadyCheckedThisWeek :  function(component, event, helper) {
		debugger;
		var value = component.get("v.isAlreadyCheckedThisWeek");
		if(value)
		{
			helper.doTurnChBtnToSuccess(component, helper);
		}
	},

	onPipeBtnClick : function(component, event, helper){
		component.set("v.renderSpinner", true);
		helper.setPipeBtns(component, true, false);

		var oppPipeData = component.get("v.oppPipeData");
		helper.setSummaryItemsVisibility(oppPipeData, null, true, false);
		component.set("v.oppPipeData", oppPipeData);
		component.set("v.summaryItemsChanged", false);
		component.set("v.renderSpinner", false);
	},

	onPrePipeBtnClick : function(component, event, helper){
		component.set("v.renderSpinner", true);
		helper.setPipeBtns(component, false, true);

		var oppPipeData = component.get("v.oppPipeData");
		helper.setSummaryItemsVisibility(oppPipeData, null, false, true);
		component.set("v.oppPipeData", oppPipeData);
		component.set("v.summaryItemsChanged", false);
		component.set("v.renderSpinner", false);
	},

	onSummaryItemChange : function(component, event, helper){
	
		component.set("v.summaryItemsChanged", true);

		var changedOppIds = component.get("v.changedOppIds"),
		changedOppId = event.getParam("oppId");

		changedOppIds.push(changedOppId);
		component.set("v.changedOppIds", changedOppIds);
		
		
	},

	onTableSave : function(component, event, helper){
		helper.saveOpps(component);
	},

	onTableCancel : function(component, event, helper){
		component.set("v.renderSpinner", true);

		// ************ BS New - 21.06.16 ****************
		var summaryItemsOld = component.get("v.summaryItemsCopy");
		var summaryItemsChanged = component.get("v.oppPipeData.summaryItems");

		for(var i in summaryItemsChanged){
			if(summaryItemsChanged[i].Id == summaryItemsOld[i].Id && (summaryItemsChanged[i].Probability != summaryItemsOld[i].Probability || summaryItemsChanged[i].StageName != summaryItemsOld[i].StageName || summaryItemsChanged[i].Ven_EstimateCashYieldCurrentYear__c != summaryItemsOld[i].Ven_EstimateCashYieldCurrentYear__c)){
				summaryItemsChanged[i].Probability = summaryItemsOld[i].Probability;
				summaryItemsChanged[i].StageName = summaryItemsOld[i].StageName;
				summaryItemsChanged[i].Ven_EstimateCashYieldCurrentYear__c = summaryItemsOld[i].Ven_EstimateCashYieldCurrentYear__c;
				summaryItemsChanged[i].Ven_EffectiveYield__c = summaryItemsOld[i].Ven_EffectiveYield__c;
			}
		}

		component.set("v.oppPipeData.summaryItems", summaryItemsChanged);
		// ************ BS New - 21.06.16 ****************

		/************ BS Old - 21.06.16 ****************
		var summaryItems = component.get("v.summaryItemsCopy");

		for(var i in summaryItems){
			helper.setSummaryItemsVisibility(null, summaryItems[i], component.get("v.isPipeBtnSelected"), component.get("v.isPrePipeBtnSelected"));
		}

		component.set("v.oppPipeData.summaryItems", JSON.parse(JSON.stringify(summaryItems)));
		************ BS Old - 21.06.16 ****************/

		component.set("v.summaryItemsChanged", false);
		component.set("v.changedOppIds", []);

		component.set("v.renderSpinner", false);
	},

    callToast : function(component, event, helper){
        helper.callToast(component, event, helper);
    }
})