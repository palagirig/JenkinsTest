({
            /**************************************
            *   Get data from controller
            **************/
	doLoadData: function(component, helper) {
                var action = component.get("c.getAccessData");
                action.setParams({"accountId" : component.get("v.accountId"), "accountIndexId" : component.get("v.accountIndexId")});

                action.setCallback(this, function(a){
                    if(a.getState() == 'SUCCESS'){

                        //Fade Dashboard in
                        $("#fadingDiv").fadeIn("slow");

                        var data = a.getReturnValue();
                        component.set("v.ctrlData", data);

                        //Initiate labels (labels are not replaced if directly mentioned in component - BUG)
                        helper.initLabels(component);

                        //Show log after the source is loaded
                        if(data.imgId != null && data.imgId != ""){
                            document.getElementById("logo").style.display = 'inline';
                        }
                    } else {
                        console.log("error");
                    }
                });

                $A.enqueueAction(action);
            },

            /**************************************
            *   Do redirect to the correct page if button is pressed
            **************/
            doRedirect: function(component) {
                var accId = component.get("v.accountId");
                window.top.location.href = "/" + accId;
            },

            /**************************************
            *   Initiate labels
            **************/
            initLabels: function(component){
                component.set("v.approval", $A.get("$Label.c.P7S1_AccDash_lbl_Approval"));
                component.set("v.accUebernahme", $A.get("$Label.c.P7S1_AccDash_lbl_AccUebernahme"));
                component.set("v.accTeamAufnahme", $A.get("$Label.c.P7S1_AccDash_lbl_AccTeamAufnahme"));
                component.set("v.logoIntegration", $A.get("$Label.c.P7S1_AccDash_lbl_LogoIntegration"));
            }
})