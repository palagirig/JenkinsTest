({
	searchLookups : function(component, helper) {
		var searchTerm 		= component.get("v.searchTerm");

		if(searchTerm.length >= 2){
			var labelApiName 	= component.get("v.labelApiName");
			var objType 		= component.get("v.objType");

			var action 			= component.get("c.getLookups");

			action.setParams({"objType" : objType, "searchTerm" : searchTerm, "labelApiName" : labelApiName});

			action.setCallback(this, function(a){
				if(a.getState() == 'SUCCESS'){
					if(a.getReturnValue().length > 0){
						component.set("v.lookupObjs", a.getReturnValue());
					}
					else {
						toastr.info("No results");
						component.set("v.lookupObjs", []);
					}					
				}
				else {
					$A.get("e.c:f42_ToastEvt").setParams({"type": "error", "msg" : "Something went wrong. Try again or contact your administrator"}).fire();
				}
			});

			$A.enqueueAction(action);
		}
		else {
			$A.get("e.c:f42_ToastEvt").setParams({"type": "info", "msg" : "At least two letters required"}).fire();
		}		
	},

	selectObj : function(component, event, helper){
		var objId 		= event.target.dataset.objid;
		var objLabel 	= event.target.dataset.objlabel;

		component.set("v.objId", objId);
		component.set("v.objLabel", objLabel);

		helper.toggleClassInverse(component, 'backdrop', 'slds-backdrop--');
        helper.toggleClassInverse(component, 'searchModal', 'slds-fade-in-');
	},

	handleChange : function(component){
		var objId 		= component.get("v.objId");
		var objOutput 	= component.find("objOutput");
		var required 	= component.get("v.required");

		component.set("v.isValid", true);

		if(required && (typeof objId == 'undefined' || objId === '')){
			component.set("v.isValid", false);
			component.set("v.objLabel", "");
		}
	},
	
	toggleClass: function(component, componentId, className) {
        var modal = component.find(componentId);
        $A.util.removeClass(modal, className+'hide');
        $A.util.addClass(modal, className+'open');
    },

    toggleClassInverse: function(component, componentId, className) {
        var modal = component.find(componentId);
        $A.util.addClass(modal, className+'hide');
        $A.util.removeClass(modal, className+'open');
    }
})