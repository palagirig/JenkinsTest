({
            /**************************************
            *   Get data from controller
            **************/
	doLoadData: function(component, helper) {
                var action = component.get("c.getMediaData");
                action.setParams({"accountId" : component.get("v.accountId")});

                action.setCallback(this, function(a){
                    if(a.getState() == 'SUCCESS'){
                        component.set("v.nielsenData", helper.groupValues(a.getReturnValue(), helper));
                    } else {
                        $("#error3").fadeIn("fast");
                    }
                    component.set("v.showSpinner", false);

                     //Initiate labels (labels are not replaced if directly mentioned in component - BUG)
                    helper.initLabels(component);
                });
                $A.enqueueAction(action);
            },

            /**************************************
            *   Hide media name if it is already in list
            **************/
            groupValues: function(data, helper){

                var group = '';
                for(var item in data.mediaData){

                    //Format values
                    data.mediaData[item].value = helper.MoneyFormat(data.mediaData[item].value);

                    //Group values
                    var current = data.mediaData[item].media;
                    if(current == group){
                        data.mediaData[item].media = '';
                    }
                    group = current;
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
                component.set("v.lblError", $A.get("$Label.c.P7S1_AccDash_lbl_Error"));
                component.set("v.lblNoData", $A.get("$Label.c.P7S1_AccDash_lbl_NoData"));
            }
})