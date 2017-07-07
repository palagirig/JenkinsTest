({
	doInitScripts : function(component, event, helper){
		helper.initTableSorter(component);
		helper.initFixedHeader(component);
	},

	doUpdateTableSorter : function(component, event, helper){
		helper.updateTableSorter(component);
	},

	goDetail: function(component, event, helper) {
		helper.sendOppPipeSummaryEvt(component, event);
	},

	doHandleTableHeaderClick : function(component, event, helper){
		helper.handleTableHeaderClick(component, event, helper);
	},

	doHandleStatusChange : function(component, event, helper){
		helper.handleStatusChange(component);
	},

	doGoOpp : function(component, event, helper){
		window.open("/"+event.target.dataset.oppid, "_blank");
	},

	doInit : function(component, event, helper){
		component.set("v.currentYear", new Date().getFullYear());
		component.set("v.currentDay", new Date().getDate());
	},

	onStageChange : function(component, event, helper){
		
		var oppId = event.getParam("indicator"),
		stageChange = component.get("v.itemChangedStage");

		if(stageChange == false){
			
			component.set("v.itemChanged", true);
			component.getEvent("summaryItemChanged").setParams({"oppId" : oppId}).fire();

			//Set Probability depending on Stage
			helper.handleStatusChange(component, oppId);
		}
		component.set("v.itemChangedStage", false);
	},

	onCashYieldChange : function(component, event, helper){
	
		/*** TODO 
		var oppId = event.getSource().getElement().parentNode.getAttribute("data-oppid");
		component.set("v.itemChanged", true);
		component.getEvent("summaryItemChanged").setParams({"oppId" : oppId}).fire();
		helper.handleCashYieldChange(component, oppId);***/
	},

	onItemChange : function(component, event, helper){
		
		var method = event.getParam("method2Execute"),
		oppId = event.getParam("indicator");
		
		component.set("v.itemChanged", true);
		component.getEvent("summaryItemChanged").setParams({"oppId" : oppId}).fire();
		
		if(method === 'cashYield'){
			helper.handleCashYieldChange(component, oppId);
		}
		
		/*** TODO 
		var oppId = event.getSource().getElement().parentNode.getAttribute("data-oppid");
		component.set("v.itemChanged", true);
		component.getEvent("summaryItemChanged").setParams({"oppId" : oppId}).fire();***/
	},

	onTableSaveCancel : function(component, event, helper){
		component.set("v.itemChanged", false);
	}
})