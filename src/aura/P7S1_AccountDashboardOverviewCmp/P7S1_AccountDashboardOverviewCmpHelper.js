({
            /**************************************
            *   Get data from controller
            **************/
	doLoadData: function(component, helper) {
                var action = component.get("c.getOverviewData");
                action.setParams({"accountId" : component.get("v.accountId")});

                action.setCallback(this, function(a){
                    if(a.getState() == 'SUCCESS'){
                        component.set("v.ovData", helper.groupValues(a.getReturnValue()));
                    } else {
                        $("#error1").fadeIn("fast");
                    }
                    component.set("v.showSpinner", false);

                    //Initiate labels (labels are not replaced if directly mentioned in component - BUG)
                    helper.initLabels(component);
                });

                $A.enqueueAction(action);
            },

            /**************************************
            *   Group values
            **************/
            groupValues: function(data){

                for(var item in data){
                    data[item].endOfGroup = false;
                    if(item != 0 && data[item].grp != data[item-1].grp){
                        data[item-1].endOfGroup = true;
                    }
                }

                return data;
            },

            /**************************************
            *   Initiate labels
            **************/
            initLabels: function(component){
                component.set("v.header", $A.get("$Label.c.P7S1_AccDash_lbl_Eckdaten"));
                component.set("v.lblError", $A.get("$Label.c.P7S1_AccDash_lbl_Error"));
            }
})