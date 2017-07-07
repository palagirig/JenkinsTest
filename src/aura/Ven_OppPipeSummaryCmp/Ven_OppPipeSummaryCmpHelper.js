({
	initTableSorter : function(component){
		var oppPipeTable = component.find("oppPipeTable").getElement();
		jQuery.tablesorter.defaults.resort = false;

		jQuery.tablesorter.addParser({
			id : 'thousands',
			is: function(s) {
		        		// return false so this parser is not auto detected
		        		return false;
		    	},
		    	format: function(s) {
		        		// format your data for normalization
		        		return s.replace(/\./g, "");
		    	},
		    	// set type, either numeric or text
		    	type: 'numeric'
		});

		jQuery(oppPipeTable).tablesorter({
			headers : {
				0 : {sorter : false},
				12:{sorter:'thousands'},
				13:{sorter:'thousands'},
				14:{sorter:'thousands'},
				15:{sorter:'thousands'},
				16:{sorter:'thousands'},
				17:{sorter:'thousands'}
			}
		});
	},

	initFixedHeader : function(component){
		var oppPipeTable = component.find("oppPipeTable").getElement();
		jQuery(oppPipeTable).tableHeadFixer();
	},

	updateTableSorter : function(component){
        if(typeof jQuery !== 'undefined'){
			var oppPipeTable = component.find("oppPipeTable").getElement();
			jQuery(oppPipeTable).trigger("update");
		}
	},

	sendOppPipeSummaryEvt: function(component, event) {

		var summaryItems = component.get("v.summaryItems"),
		oppId = event.target.dataset.id,
		opp;

		for(var i=0; i<summaryItems.length; i+=1){
			if(summaryItems[i].Id === oppId){
				opp = summaryItems[i];
				break;
			}
		}

		opp.sobjectType = "Opportunity";

		component.getEvent("summaryItemClick").setParams({"opp":opp}).fire();
	},

	handleTableHeaderClick : function(component, event, helper){
        var oppPipeTable 	= component.find("oppPipeTable").getElement();

		var isAsc;
		if(jQuery(event.srcElement).find("i").hasClass("fa-sort-asc")){
			isAsc = false;
		} else {
			isAsc = true;
		}

		jQuery(oppPipeTable).find("i>.fa").addClass("fa-sort");
		jQuery(oppPipeTable).find("i").removeClass("fa-sort-asc");
		jQuery(oppPipeTable).find("i").removeClass("fa-sort-desc");

		if(isAsc){
			jQuery(event.srcElement).find("i").addClass("fa-sort-asc");
		} else {
			jQuery(event.srcElement).find("i").addClass("fa-sort-desc");
		}
	},

	handleCashYieldChange : function(component, oppId){
		var summaryItems = component.get("v.summaryItems"),
		index = 0;

		//Get specific Opportunity element
		for(var i=0; i<summaryItems.length; i+=1){
			if(summaryItems[i].Id === oppId){
				index = i;
				break;
			}
		}

		summaryItems[index].Ven_EffectiveYield__c = summaryItems[index].Ven_EstimateCashYieldCurrentYear__c + summaryItems[index].Ven_EstimatePrapYieldCurrentYear__c;
		component.set("v.summaryItems["+index+"]", summaryItems[index]);
	},

	handleStatusChange : function(component, oppId){

		var summaryItems = component.get("v.summaryItems"),
		index = 0,
		cliTT = component.find("checker");
		
		//Show Tooltip
		$A.util.removeClass(cliTT, 'hideIt');

		//Get specific Opportunity element
		for(var i=0; i<summaryItems.length; i+=1){
			if(summaryItems[i].Id === oppId){
				index = i;
				break;
			}
		}

		var status = summaryItems[index].StageName,
		probability;

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

		summaryItems[index].Probability = probability;
		component.set("v.itemChangedStage", true);
		component.set("v.summaryItems["+index+"]", summaryItems[index]);
		
		//Hide Tooltip
		window.setTimeout($A.getCallback(function(){
            $A.util.addClass(cliTT, 'hideIt');
        }), 6000);
	}
})