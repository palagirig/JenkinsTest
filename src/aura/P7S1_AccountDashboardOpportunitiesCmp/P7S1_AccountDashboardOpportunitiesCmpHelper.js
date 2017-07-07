({
            /**************************************
            *   Get data from controller
            **************/
	doLoadData: function(component, helper) {
                var action = component.get("c.getOpportunityData");
                action.setParams({"accountId" : component.get("v.accountId"),
                                              "isAccountIndex" : component.get("v.isAccountIndex")});

                action.setCallback(this, function(a){
                    if(a.getState() == 'SUCCESS'){
                        component.set("v.oppData", helper.roundValues(a.getReturnValue(), helper));
                    } else {
                        $("#error2").fadeIn("fast");
                    }
                    component.set("v.showSpinner", false);

                    //Initiate labels (labels are not replaced if directly mentioned in component - BUG)
                    helper.initLabels(component);
                });

                $A.enqueueAction(action);
	},

            /**************************************
            *   Round values
            **************/
            roundValues: function(data, helper){
                data.sumOpen = helper.MoneyFormat(data.sumOpen);
                data.sumClosed = helper.MoneyFormat(data.sumClosed);
                data.target = helper.MoneyFormat(data.target);

                for(var item in data.tableData){
                    data.tableData[item].open = helper.MoneyFormat(data.tableData[item].open);
                    data.tableData[item].closed = helper.MoneyFormat(data.tableData[item].closed);
                    data.tableData[item].yield = Math.round(data.tableData[item].yield);
                }

                return data;
            },

            /**************************************
            *   Format data depending on amount
            **************/
            formatValues: function(val){
                var formats = {1000000000 : $A.get("$Label.c.P7S1_AccDashboard_Opp_Billion"),
                                       1000000 : $A.get("$Label.c.P7S1_AccDashboard_Opp_Million"),
                                       1000 : $A.get("$Label.c.P7S1_AccDashboard_Opp_Thousan")};
                var numbers = [1000000000, 1000000, 1000];

                var returnValue = val;
                for (var i = 0; i < numbers.length; i++) {
                    var key = numbers[i];
                    var divided = val/key;
                    if(divided > 0){
                        returnValue = Math.round(divided) + formats[key];
                    }
                }

                return returnValue;
            },

            /**************************************
            *   Format data depending on amount - 2015-12-10 AS
            **************/

			MoneyFormat: function MoneyFormat(labelValue) {
                return Math.abs(Number(labelValue)) >= 1.0e+9
					? Math.round(Math.abs(Number(labelValue)) / 1.0e+9 *100) / 100 + $A.get("$Label.c.P7S1_AccDashboard_Opp_Billion")
				: Math.abs(Number(labelValue)) >= 1.0e+6
					? Math.round(Math.abs(Number(labelValue)) / 1.0e+6 *100) / 100 + $A.get("$Label.c.P7S1_AccDashboard_Opp_Million")
			    : Math.abs(Number(labelValue)) >= 1.0e+3
					? Math.round(Math.abs(Number(labelValue)) / 1.0e+3 *100) / 100 + $A.get("$Label.c.P7S1_AccDashboard_Opp_Thousan")
				: Math.abs(Number(labelValue)) > 0
                	? Math.abs(Number(labelValue))
                : labelValue;
			},    
    
            /**************************************
            *   Initiate labels
            **************/
            initLabels: function(component){
                component.set("v.header", $A.get("$Label.c.P7S1_AccDash_lbl_Opportunities"));
                component.set("v.lblUnit", $A.get("$Label.c.P7S1_AccDash_lbl_Unit"));
                component.set("v.lblClosed", $A.get("$Label.c.P7S1_AccDash_lbl_Closed"));
                component.set("v.lblOpen", $A.get("$Label.c.P7S1_AccDash_lbl_Open"));
                component.set("v.lblYield", $A.get("$Label.c.P7S1_AccDash_lbl_Yield"));
                component.set("v.lblSum", $A.get("$Label.c.P7S1_AccDash_lbl_Sum"));
                component.set("v.lblError", $A.get("$Label.c.P7S1_AccDash_lbl_Error"));
                /*
                component.set("v.lblTarget", $A.get("$Label.c.P7S1_AccDash_lbl_Target"));
                component.set("v.lblReached", $A.get("$Label.c.P7S1_AccDash_lbl_Reached"));
                component.set("v.lblNotReached", $A.get("$Label.c.P7S1_AccDash_lbl_NotReached"));
                */
            }
})