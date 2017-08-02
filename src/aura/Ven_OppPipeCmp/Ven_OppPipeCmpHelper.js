({
	getOppPipeData : function(component, helper){
		component.set("v.renderSpinner", true);

		var action = component.get("c.getOppPipeData");

		action.setCallback(this, function(a){
			if(a.getState() === 'SUCCESS'){
				var result = a.getReturnValue();

				if(result.userRole === result.imRoleId){
					component.set("v.isIm", true);
				}else if(result.userRole === result.scoutRoleId){
					component.set("v.isScout", true);
				}else if(result.userRole === result.analystRoleId){
					component.set("v.isAnalyst", true);
				}

				this.setSummaryItemsVisibility(result, null, true, false);

				component.set("v.oppPipeData", result);
				component.set("v.showButtons", true);
				component.set("v.renderSpinner", false);
				component.set("v.summaryItemsCopy", JSON.parse(JSON.stringify(result.summaryItems)));
				//TODO: change to method
				component.set("v.isAlreadyCheckedThisWeek", result.isAlreadyCheckedThisWeek);
			} else {
				//toastr.error($A.get("$Label.c.Ven_lbl_ContactAdmin"));
				$A.get("e.c:f42_ToastEvt").setParams({"type": "error", "msg" : $A.get("$Label.c.Ven_lbl_ContactAdmin")}).fire();
				component.set("v.renderSpinner", false);
			}
		});

		$A.enqueueAction(action);
	},

	setSummaryItemsVisibility : function(oppPipeData, opp, pipeVisibility, prePipeVisibility){

		if(oppPipeData !== null){
			for(var i=0; i<oppPipeData.summaryItems.length; i+=1){
				var item = oppPipeData.summaryItems[i];

				if(item.StageName === 'In Briefing' || item.StageName === 'M2N' || item.StageName === 'Deal approval'){
					oppPipeData.summaryItems[i].Ven_ShowInPipe__c = pipeVisibility;
				}else if(item.StageName === 'Potential' || item.StageName === 'Contacted' || item.StageName === 'Parked'){
					oppPipeData.summaryItems[i].Ven_ShowInPipe__c = prePipeVisibility;
				}else {
					oppPipeData.summaryItems[i].Ven_ShowInPipe__c = false;
				}
			}
		}else if(opp !== null){
			if(opp.StageName === 'In Briefing' || opp.StageName === 'M2N' || opp.StageName === 'Deal approval'){
				opp.Ven_ShowInPipe__c = pipeVisibility;
			}else if(opp.StageName === 'Potential' || opp.StageName === 'Contacted' || opp.StageName === 'Parked'){
				opp.Ven_ShowInPipe__c = prePipeVisibility;
			}else {
				opp.Ven_ShowInPipe__c = true;
			}
		}
	},

	newOpp : function(component, helper){
		var oppPipeDetail = helper.createNewOppPipeDetail();

		var oppPipeData = component.get("v.oppPipeData");

		if(oppPipeData.userRole === oppPipeData.imRoleId){
			oppPipeDetail.opp.OwnerId = oppPipeData.userId;
		}else if(oppPipeData.userRole === oppPipeData.scoutRoleId){
			oppPipeDetail.opp.Ven_Scount__c = oppPipeData.userId;
		}else if(oppPipeData.userRole === oppPipeData.analystRoleId){
			oppPipeDetail.opp.Ven_Analyst__c = oppPipeData.userId;
		}

		component.set("v.oppPipeDetail", oppPipeDetail);
		component.set("v.isSummary", false);
		component.set("v.isNewOpp", true);
	},

	createNewOppPipeDetail : function(){
		var oppPipeDetail 										= {};
		oppPipeDetail.opp 										= {};
		oppPipeDetail.opp.Id 									= null;
		oppPipeDetail.opp.Name 									= '';
		oppPipeDetail.opp.Ven_EstimateCashYieldCurrentYear__c 	= 0;
		oppPipeDetail.opp.Ven_EstimatePrapYieldCurrentYear__c 	= 0;
		oppPipeDetail.opp.Ven_CashInvest__c 					= 0;
		oppPipeDetail.opp.Ven_NetPotentialCurrentYear__c 		= 0;
		oppPipeDetail.opp.Ven_NetPotentialNextYear__c 			= 0;

		var currentYear = new Date().getFullYear();

		oppPipeDetail.currentYear 				= {};
		oppPipeDetail.currentYear.totalAmount 	= 0;
		oppPipeDetail.currentYear.totalCash 	= 0;
		oppPipeDetail.currentYear.year 			= currentYear;

		var curMonths = [];
		for(var i=1; i<=12; i+=1){
			curMonths.push({
				"Id" 				: null,
				"Ven_Amount__c"		: 0,
				"Ven_Cash__c"		: 0,
				"Ven_Month__c"		: i,
				"Ven_Year__c"		: currentYear,
				"isValid"			: true
			});
		}

		oppPipeDetail.currentYear.oppPipeMonths = curMonths;

		oppPipeDetail.nextYear 				= {};
		oppPipeDetail.nextYear.totalAmount 	= 0;
		oppPipeDetail.nextYear.totalCash 	= 0;
		oppPipeDetail.nextYear.year 		= currentYear+1;

		var nextMonths = [];
		for(var j=1; j<=12; j+=1){
			nextMonths.push({
				"Id" 				: null,
				"Ven_Amount__c"		: 0,
				"Ven_Cash__c"		: 0,
				"Ven_Month__c"		: j,
				"Ven_Year__c"		: currentYear+1,
				"isValid"			: true
			});
		}

		oppPipeDetail.nextYear.oppPipeMonths = nextMonths;

		return oppPipeDetail;
	},

	doDetail : function(component, event, helper){
		component.set("v.renderSpinner", true);

		var opp = event.getParam("opp"),
		getOppPipeDetail = component.get("c.getOppPipeDetail");

		getOppPipeDetail.setParams({"opp": opp});

		getOppPipeDetail.setCallback(this, function(resp){
			if(resp.getState() === 'SUCCESS'){

				component.set("v.setProbability", false);
				component.set("v.oppPipeDetail", helper.fillOpp(resp.getReturnValue()));
				component.set("v.isSummary", false);
				component.set("v.isNewOpp", false);
				component.set("v.renderSpinner", false);
			}else {
				component.set("v.renderSpinner", false);
			}
		});

		$A.enqueueAction(getOppPipeDetail);
	},

	doTurnChBtnToSuccess : function(component, helper){
			$A.util.removeClass(component.find("chkdBtn"), "btn-primary");
			$A.util.addClass(component.find("chkdBtn"), "btn-success");
	},

	setPipeBtns : function(component, pipeBtnValue, prePipeBtnValue){

		if(pipeBtnValue){
			$A.util.removeClass(component.find("pipeBtn"), "btn-default");
			$A.util.addClass(component.find("pipeBtn"), "btn-primary");
			$A.util.addClass(component.find("prePipeBtn"), "btn-default");
			$A.util.removeClass(component.find("prePipeBtn"), "btn-primary");
		}else {
			$A.util.addClass(component.find("pipeBtn"), "btn-default");
			$A.util.removeClass(component.find("pipeBtn"), "btn-primary");
			$A.util.removeClass(component.find("prePipeBtn"), "btn-default");
			$A.util.addClass(component.find("prePipeBtn"), "btn-primary");
		}

		component.set("v.isPipeBtnSelected", pipeBtnValue);
		component.set("v.isPrePipeBtnSelected", prePipeBtnValue);
	},

	fillOpp : function(opd){
		var oppPipeDetail 										= opd;
		oppPipeDetail.opp = this.buildOpp(opd.opp, true);

		if($A.util.isEmpty(oppPipeDetail.opp.Ven_EstimatePrapYieldCurrentYear__c)){
			oppPipeDetail.opp.Ven_EstimatePrapYieldCurrentYear__c = 0;
		}

		if($A.util.isEmpty(oppPipeDetail.opp.Ven_EstimateCashYieldCurrentYear__c) ){
			oppPipeDetail.opp.Ven_EstimateCashYieldCurrentYear__c = 0;
		}

		if($A.util.isEmpty(oppPipeDetail.opp.Ven_CashInvest__c)){
			oppPipeDetail.opp.Ven_CashInvest__c = 0;
		}

		// handle opps that were not created by the opp pipe app
		var currentYear = new Date().getFullYear();

		var curMonths = [];
		if($A.util.isEmpty(oppPipeDetail.currentYear.oppPipeMonths[0])){
			for(var i = 1; i <= 12; i+=1){
				curMonths.push({	"Id"				: null,
									"Ven_Amount__c"		: 0,
									"Ven_Cash__c"		: 0,
									"Ven_Month__c"		: i,
									"Ven_Year__c"		: currentYear,
									"isValid"			: true});
			}
		}else{
			for(var h = 0; h < oppPipeDetail.currentYear.oppPipeMonths.length; h+=1){
				var detail = oppPipeDetail.currentYear.oppPipeMonths[h];
				curMonths.push({	"Id"				: detail.Id,
									"Ven_Amount__c"		: detail.Ven_Amount__c,
									"Ven_Cash__c"		: detail.Ven_Cash__c,
									"Ven_Month__c"		: detail.Ven_Month__c,
									"Ven_Year__c"		: detail.Ven_Year__c,
									"Ven_Opp__c"		: detail.Ven_Opp__c,
									"isValid"			: true});
			}
		}
		oppPipeDetail.currentYear.oppPipeMonths = curMonths;

		var nextMonths 	= [];
		if($A.util.isEmpty(oppPipeDetail.nextYear.oppPipeMonths[0])){
			for(var j = 1; j <= 12; j+=1){
				nextMonths.push({	"Id"				: null,
									"Ven_Amount__c"		: 0,
									"Ven_Cash__c"		: 0,
									"Ven_Month__c"		: j,
									"Ven_Year__c"		: (currentYear+1),
									"isValid"			: true});
			}
		}else{
			for(var k = 0; k < oppPipeDetail.nextYear.oppPipeMonths.length; k+=1){
				var detailNext = oppPipeDetail.nextYear.oppPipeMonths[k];
				nextMonths.push({	"Id"				: detailNext.Id,
									"Ven_Amount__c"		: detailNext.Ven_Amount__c,
									"Ven_Cash__c"		: detailNext.Ven_Cash__c,
									"Ven_Month__c"		: detailNext.Ven_Month__c,
									"Ven_Year__c"		: detailNext.Ven_Year__c,
									"Ven_Opp__c"		: detailNext.Ven_Opp__c,
									"isValid"			: true});
			}
		}
		oppPipeDetail.nextYear.oppPipeMonths = nextMonths;

		return oppPipeDetail;
	},

	saveOpps : function(component, helper){
		component.set("v.renderSpinner", true);

		var saveOpps = component.get("c.saveOpps"),
		opps = this.getOppsByIds(component);

		saveOpps.setParams({"opps" : opps});

		saveOpps.setCallback(this, function(resp){
			if(resp.getState() === 'SUCCESS'){
				var changedOpps = resp.getReturnValue(),
				summaryItems = component.get("v.oppPipeData.summaryItems");

				for(var i=0; i<changedOpps.length; i+=1){
					this.setSummaryItemsVisibility(null, changedOpps[i], component.get("v.isPipeBtnSelected"), component.get("v.isPrePipeBtnSelected"));
					var index = this.getIndex(component, changedOpps[i].Id);
					summaryItems[index] = changedOpps[i];
				}

				component.set("v.oppPipeData.summaryItems", summaryItems);
				component.set("v.summaryItemsCopy", JSON.parse(JSON.stringify(component.get("v.oppPipeData.summaryItems"))));
				component.set("v.changedOppIds", []);
				component.set("v.summaryItemsChanged", false);
				component.set("v.renderSpinner", false);
				$A.get("e.c:f42_ToastEvt").setParams({"type": "success", "msg" : $A.get("$Label.c.Ven_lbl_Saved")}).fire();
			}else {
				component.set("v.renderSpinner", false);
				$A.get("e.c:f42_ToastEvt").setParams({"type": "error", "msg" : $A.get("$Label.c.Ven_lbl_ContactAdmin")}).fire();
			}
		});

		$A.enqueueAction(saveOpps);
	},

	getIndex : function(component, oppId){
		var summaryItems = component.get("v.oppPipeData.summaryItems"),
		index = 0;

		for(var i=0; i<summaryItems.length; i+=1){
			if(oppId === summaryItems[i].Id){
				index = i;
				break;
			}
		}

		return index;
	},

	getOppsByIds : function(component){
		var changedOppIds = component.get("v.changedOppIds"),
		opps = [],
		summaryItems = component.get("v.oppPipeData.summaryItems");

		for(var i=0; i<summaryItems.length; i+=1){
			if(changedOppIds.indexOf(summaryItems[i].Id) !== -1){
				summaryItems[i].sobjectType = "Opportunity";
				opps.push(summaryItems[i]);
			}
		}

		return opps;
	},

	save : function(component, helper){

		component.set("v.renderSpinner", true);

		var detailCmp = component.find('detailCmp');
		detailCmp.checkValidDetailCmp();

		var isOppValid 	= component.get("v.isOppValid");
		var isPipeValid = component.get("v.isPipeValid");
		var isApprovalValid = component.get("v.isApprovalValid");

		if(isOppValid && isPipeValid && isApprovalValid){

			var oppPipeDetail 	= component.get("v.oppPipeDetail"),
			opp = oppPipeDetail.opp,
			approval = oppPipeDetail.approval,
			oppPipes = helper.buildOppPipes(helper, oppPipeDetail),
			saveOppPipeDetail = component.get("c.saveOppPipeDetail");

			var opp2 = this.buildOpp(opp, false)

			saveOppPipeDetail.setParams({
				"opp" : opp2,
				"approval" : approval,
				"oppPipes" : oppPipes
			});

			//TODO Check if approval has all the fields (Do we need a method like buildOpp!?)

			saveOppPipeDetail.setCallback(this, function(a){
				if(a.getState() === 'SUCCESS'){
					helper.setOppInOppPipeData(a.getReturnValue(), component, false);
					component.set("v.isSummary", true);
					component.set("v.renderSpinner", false);
					component.set("v.summaryItemsChanged", false);
					$A.get("e.c:f42_ToastEvt").setParams({"type": "success", "msg" : $A.get("$Label.c.Ven_lbl_Saved")}).fire();
				} else {
					component.set("v.renderSpinner", false);
					$A.get("e.c:f42_ToastEvt").setParams({"type": "error", "msg" : $A.get("$Label.c.Ven_lbl_ContactAdmin")}).fire();
				}
			});

			$A.enqueueAction(saveOppPipeDetail);
		}else {
			$A.get("e.c:f42_ToastEvt").setParams({"type": "warning", "msg" : $A.get("$Label.c.Ven_lbl_CompleteFields")}).fire();
			component.set("v.renderSpinner", false);
		}
	},

	setOppInOppPipeData : function(opp, component, isDelete){
		var summaryItems = component.get("v.oppPipeData.summaryItems"),
		isNewOpp = true;

		this.setSummaryItemsVisibility(null, opp, component.get("v.isPipeBtnSelected"), component.get("v.isPrePipeBtnSelected"));

		for(var i=0; i<summaryItems.length; i+=1){
			if(summaryItems[i].Id === opp.Id){
				if(isDelete){
					summaryItems.splice(i, 1);
					break;
				}else {
					summaryItems[i] = opp;
					isNewOpp = false;
					break;
				}
			}
		}

		if(isNewOpp && !isDelete){
			summaryItems.unshift(opp);
		}

		component.set("v.oppPipeData.summaryItems", summaryItems);
	},

	buildOppPipes : function(helper, oppPipeDetail){
		var oppPipes = [];
		var currentYearMonths = oppPipeDetail.currentYear.oppPipeMonths;
		for(var i = 0; i < currentYearMonths.length; i+=1){

			var month = currentYearMonths[i];
			oppPipes.push({	"sobjectType"			: "Ven_OppPipeline__c",
								"Id"				: month.Id,
								"Ven_Amount__c"		: month.Ven_Amount__c,
								"Ven_Cash__c"		: month.Ven_Cash__c,
								"Ven_Month__c"		: month.Ven_Month__c,
								"Ven_Year__c"		: month.Ven_Year__c,
								"Ven_Opp__c"		: month.Ven_Opp__c});
		}

		var nextYearMonths = oppPipeDetail.nextYear.oppPipeMonths;
		for(var j = 0; j < nextYearMonths.length; j+=1){

			var monthn = nextYearMonths[j];
			oppPipes.push({	"sobjectType"			: "Ven_OppPipeline__c",
								"Id"				: monthn.Id,
								"Ven_Amount__c"		: monthn.Ven_Amount__c,
								"Ven_Cash__c"		: monthn.Ven_Cash__c,
								"Ven_Month__c"		: monthn.Ven_Month__c,
								"Ven_Year__c"		: monthn.Ven_Year__c,
								"Ven_Opp__c"		: monthn.Ven_Opp__c});
		}
		return oppPipes;
	},

	buildOpp : function(opp, loading){

		var backOpp = {
			"sobjectType" 							: "Opportunity",
			"Id" : opp.Id,
			"Name" : opp.Name,
			"Ven_DealType__c" : opp.Ven_DealType__c,
			"Ven_DealCategory__c" : opp.Ven_DealCategory__c,
			"Ven_SubCategory__c" : opp.Ven_SubCategory__c,
			"Ven_CashInvest__c" : opp.Ven_CashInvest__c,
			"Ven_International__c" : opp.Ven_International__c,
			"Ven_TargetPL__c" : opp.Ven_TargetPL__c,
			"StageName" : opp.StageName,
			"Ven_Stage_Finished_Subcategory__c" : opp.Ven_Stage_Finished_Subcategory__c,
			"Ven_Comment__c" : opp.Ven_Comment__c,
			"Ven_Country__c" : opp.Ven_Country__c,
			"Ven_EstimateCashYieldCurrentYear__c" : opp.Ven_EstimateCashYieldCurrentYear__c,
			"Ven_EstimatePrapYieldCurrentYear__c" : opp.Ven_EstimatePrapYieldCurrentYear__c,
			"Ven_EffectiveYield__c" : opp.Ven_EffectiveYield__c,
			"Probability" : opp.Probability,
			"Ven_Verticals__c" : opp.Ven_Verticals__c,
			"OwnerId" : opp.OwnerId,
			"Ven_Im2__c" : opp.Ven_Im2__c,
			"Ven_Scout__c" : opp.Ven_Scout__c,
			"Ven_Analyst__c" : opp.Ven_Analyst__c,
			"CloseDate" : opp.CloseDate,
			"AccountId" : opp.AccountId,
			"CurrencyIsoCode" : opp.CurrencyIsoCode,
			"Ven_Ep__c" : opp.Ven_Ep__c,
			"Ven_EpLight__c" : opp.Ven_EpLight__c,
			"Ven_RevShare__c" : opp.Ven_RevShare__c,
			"Ven_TotalGmvCurrentYear__c" : opp.Ven_TotalGmvCurrentYear__c,
      "Ven_TotalGmvNextYear__c" : opp.Ven_TotalGmvNextYear__c,
      "Ven_Vertical__c" : opp.Ven_Vertical__c,
      "Ven_NetPotentialCurrentYear__c" : opp.Ven_NetPotentialCurrentYear__c,
      "Ven_NetPotentialNextYear__c" : opp.Ven_NetPotentialNextYear__c,
      "Ven_TotalNetPotential__c" : opp.Ven_TotalNetPotential__c,
      "Ven_TotalGmv__c" : opp.Ven_TotalGmv__c,
      "Ven_ScoutText__c" : opp.Ven_ScoutText__c,
      "Ven_MediaPlanner__c" : opp.Ven_MediaPlanner__c,
      "Ven_Contacted__c" : opp.Ven_Contacted__c,
      "Ven_m2n__c" : opp.Ven_m2n__c,
      "Ven_DealApproval__c" : opp.Ven_DealApproval__c,
      "Ven_ClosedWon__c" : opp.Ven_ClosedWon__c,
      "Ven_ClosedLost__c" : opp.Ven_ClosedLost__c,
      "Ven_ParkedDate__c" : opp.Ven_ParkedDate__c,
      "Ven_Cancellation__c" : opp.Ven_Cancellation__c,
      "Ven_DealStartMonth__c" : opp.Ven_DealStartMonth__c,
      "Ven_TestDeal__c" : opp.Ven_TestDeal__c,
      "Ven_IndustryChampion__c" : opp.Ven_IndustryChampion__c,
      "Ven_BusinessModel__c" : opp.Ven_BusinessModel__c,
      "Ven_BusinessType__c" : opp.Ven_BusinessType__c,
      "Ven_CustomerAssesment__c" : opp.Ven_CustomerAssesment__c,
      "Ven_RiskProfile__c" : opp.Ven_RiskProfile__c
		};

		if(loading){
			backOpp.Account = opp.Account;
		}

		return backOpp;
	},

	cancel : function(component){
		component.set("v.isSummary", true);
	},

	discard : function(component){
		component.set("v.renderSpinner", true);

		var opp 	= component.get("v.oppPipeDetail.opp");
		var action 	= component.get("c.deleteOppPipeDetail");

		action.setParams({ "oppId" : opp.Id });

		action.setCallback(this, function(a){
			if(a.getState() === 'SUCCESS'){
				this.setOppInOppPipeData(opp, component, true);
				component.set("v.isSummary", true);
				component.set("v.renderSpinner", false);
			}else {
				$A.get("e.c:f42_ToastEvt").setParams({"type": "error", "msg" : $A.get("$Label.c.Ven_lbl_ContactAdmin")}).fire();
				component.set("v.renderSpinner", false);
			}
		});

		$A.enqueueAction(action);
	},

	onPipelineChecked : function(component, helper){
		component.set("v.renderSpinner", true);

		var action 	= component.get("c.pipelineChecked");

		action.setCallback(this, function(a){
			if(a.getState() === 'SUCCESS'){
				$A.get("e.c:f42_ToastEvt").setParams({"type": "success", "msg" : $A.get("$Label.c.Ven_lbl_PipeChecked")}).fire();
				component.set("v.renderSpinner", false);
				component.set("v.isAlreadyCheckedThisWeek", true);
			}else {
				$A.get("e.c:f42_ToastEvt").setParams({"type": "error", "msg" : $A.get("$Label.c.Ven_lbl_ContactAdmin")}).fire();
				component.set("v.renderSpinner", false);
			}
		});

		$A.enqueueAction(action);
	},

	export2Csv : function(component, helper){
		//var rows 	= helper.buildJson(component, helper);
		component.set("v.renderSpinner", true);

		var rows 				= [],
		isInPermissionSet		= component.get("v.oppPipeData.isInPermissionSet"),
		getExportData 			= component.get("c.getExportData");

		getExportData.setParams({ "isInPermissionSet" : isInPermissionSet});

		getExportData.setCallback(this, function(resp){
			if(resp.getState() === 'SUCCESS'){
				var exportData =  resp.getReturnValue();

				for(var i=0; i<exportData.length; i+=1){
					var row 		= {};
					var opp 		= exportData[i].opp;
					var currentYear = exportData[i].currentYear;
					var nextYear 	= exportData[i].nextYear;

					helper.setOppJson(row, opp, component, helper);
					helper.setYearJson(row, currentYear);
					helper.setYearJson(row, nextYear);

					row["Net Potential "+ currentYear.year] 	= this.setOppValue(opp.Ven_NetPotentialCurrentYear__c, 0);
					row["Net Potential "+ nextYear.year] 		= this.setOppValue(opp.Ven_NetPotentialNextYear__c, 0);
					row["Total Net Potential"] 			= this.setOppValue(opp.Ven_TotalNetPotential__c, 0);

					rows.push(row);
				}

				var csv 	= helper.json2CsvConverter(rows, ";");

				if (navigator.userAgent.search("Trident") >= 0) {
					helper.createCsvIe(csv, "Export_Pipeline");
				}else {
					helper.createCsv(csv, "Export_Pipeline");
				}

				component.set("v.renderSpinner", false);
			}else {
				component.set("v.renderSpinner", false);
			}
		});

		$A.enqueueAction(getExportData);
	},

	setYearJson : function(row, year){
		var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

		if(year.oppPipeMonths.length !== 0){
			for(var j=0; j<year.oppPipeMonths.length; j+=1){
				var month = year.oppPipeMonths[j];
				row["GMV "+months[j]+" "+year.year] = this.setOppPipeMonthValue(month.Ven_Amount__c);
			}
		}else {
			for(var i=0; i<months.length; i+=1){
				row["GMV "+months[i]+" "+year.year] = 0;
			}
		}

		row["Total GMV "+year.year] = year.totalAmount;
	},

	setOppPipeMonthValue : function(value){
		return $A.util.isEmpty(value) ? 0 : value;
	},

	setOppJson : function(row, opp, component, helper){

		row["Id"] 						= helper.setOppValue(opp.Id, '');
		row["Account"] 					= helper.setOppValue(opp.Account.Name, '');
		row["Opportunity"] 				= helper.setOppValue(opp.Name, '');
		row["Vertical"] 				= helper.getPicklistLabel(component.get("v.oppPipeData.selectOptLsts.verticals"), opp.Ven_Verticals__c);
		row["DUMMY"] 			= "";
		row["Deal Type"]				= helper.setOppValue(opp.Ven_DealType__c, '');
		row["Optional"] 				= helper.setOppValue(opp.Ven_TestDeal__c, '');
		row["Country"] 					= helper.getPicklistLabel(component.get("v.oppPipeData.selectOptLsts.countriesAlpha3"), opp.Ven_Country__c);
		row["International"] 			= helper.setOppValue(opp.Ven_International__c, '');
		row["Currency"] 				= helper.setOppValue(opp.CurrencyIsoCode, '');
		row["Target P/L"] 				= helper.setOppValue(opp.Ven_TargetPL__c, '');
		row["EP"] 						= helper.setOppValue(opp.Ven_Ep__c, '');
		row["EP light"] 				= helper.setOppValue(opp.Ven_EpLight__c, '');
		row["Rev Share"] 				= helper.setOppValue(opp.Ven_RevShare__c, '');
		row["IM1"] 						= helper.getPicklistLabel(component.get("v.oppPipeData.selectOptLsts.ims"), opp.OwnerId);
		row["IM2"] 						= helper.getPicklistLabel(component.get("v.oppPipeData.selectOptLsts.ims"), opp.Ven_Im2__c);
		row["Scout"]					= helper.getPicklistLabel(component.get("v.oppPipeData.selectOptLsts.scouts"), opp.Ven_ScoutText__c);
		row["MediaPlanner"]				= helper.getPicklistLabel(component.get("v.oppPipeData.selectOptLsts.analysts"), opp.Ven_MediaPlanner__c);
		row["Status"]					= helper.setOppValue(opp.StageName, '');
		row["Last Edited By"]			= helper.setOppValue(opp.Ven_LastModifiedBy__c, '');
		row["Last Edited On"]			= helper.setOppValue(opp.Ven_LastModifiedDate__c, '');
		row["Account Created Date"]		= helper.setOppValue(opp.Account.CreatedDate, '');
		row["Opportunity Created Date"]	= helper.setOppValue(opp.CreatedDate, '');
		row["Contacted"]				= helper.setOppValue(opp.Ven_Contacted__c, '');
		row["M2N"]						= helper.setOppValue(opp.Ven_m2n__c, '');
		row["Deal Approval"]			= helper.setOppValue(opp.Ven_DealApproval__c, '');
		row["Closed Won"]				= helper.setOppValue(opp.Ven_ClosedWon__c, '');
		row["Closed Lost"]				= helper.setOppValue(opp.Ven_ClosedLost__c, '');
		row["Parked"]					= helper.setOppValue(opp.Ven_Parked__c, '');
		row["Cancelled"]				= helper.setOppValue(opp.Ven_Cancellation__c, '');
		row["Reason"] 					= helper.setOppValue(opp.Ven_Reason__c, '');
		row["Comment"] 					= helper.setOppValue(opp.Ven_Comment__c, '');
		row["Client Likelihood"] 		= helper.setOppValue(opp.Probability, '');

		row["Cash Yield"] 				= helper.setOppValueNumber(opp.Ven_EstimateCashYieldCurrentYear__c, 0);
		row["pRAP Yield"] 				= helper.setOppValueNumber(opp.Ven_EstimatePrapYieldCurrentYear__c, 0);
		row["Effective Yield"] 			= helper.setOppValueNumber(opp.Ven_EffectiveYield__c, 0);

		row["Cash Invest"]				= helper.setOppValue(opp.Ven_CashInvest__c, '');
	},

	setOppValue : function(value, def){
		return $A.util.isEmpty(value) ? def : value;
	},

	setOppValueNumber : function(value, def){
		var number = ($A.util.isEmpty(value) ? def : value);
		return number.toLocaleString('de-DE');
	},

	getPicklistLabel : function(options, value){
		for(var i=0; i<options.length; i+=1){
			if(options[i].text === value){
				return options[i].label;
			}
		}

		return "";
	},



	json2CsvConverter : function(JSONData, Separator){

		//If JSONData is not an object then JSON.parse will parse the JSON string in an Object
	    var arrData = typeof JSONData !== 'object' ? JSON.parse(JSONData) : JSONData;

	    var CSV = '';
	    //Set Report title in first row or line

	    //This condition will generate the Label/Header
	    var rowHead = "";

	    //This loop will extract the label from 1st index of on array
	    for (var h=0; h<Object.keys(arrData[0]).length; h+=1) {
	    	var index = Object.keys(arrData[0])[h];

	        //Now convert each value to string and comma-seprated
	        rowHead += index + Separator;
	    }

	    rowHead = rowHead.slice(0, -1);

	    //append Label row with line break
	    CSV += rowHead + '\r\n';

	    //1st loop is to extract each row
	    for (var i = 0; i < arrData.length; i+=1) {
	        var row = "";

	        //2nd loop will extract each column and convert it in string comma-seprated
	        for (var j=0; j<Object.keys(arrData[i]).length; j+=1) {
	        	var index2 = Object.keys(arrData[i])[j];
	            row += '"' + arrData[i][index2] + '"'+Separator;
	        }

	        row.slice(0, row.length - 1);

	        //add a line break after each row
	        CSV += row + '\r\n';
	    }

	    if (CSV === '') {
	        return;
	    }

	    return CSV;
	},

	createCsv : function(csv, fileName){
		//Initialize file format you want csv or xls
	    var uri = 'data:text/csv;charset=utf-8,' + escape(csv);

	    //this trick will generate a temp <a /> tag
	    var link = document.createElement("a");
	    link.href = uri;

	    //set the visibility hidden so it will not effect on your web-layout
	    link.style = "visibility:hidden";
	    link.download = fileName + ".csv";

	    //this part will append the anchor tag and remove it after automatic click
	    document.body.appendChild(link);
	    link.click();
	    document.body.removeChild(link);
	},

	createCsvIe : function(csv, fileName){
		var oWin = window.open();
	    oWin.document.write('sep=,\r\n' + csv);
	    oWin.document.close();
	    oWin.document.execCommand('SaveAs', true, fileName + ".csv");
	    oWin.close();
	},

    callToast : function(component, event, helper){
        var type = event.getParam("type"),
        msg = event.getParam("msg");
        component.find("toastr").callToast(type, msg);
    }
})