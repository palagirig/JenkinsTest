({
    /**** Init on load ****/
    doInit : function(component, event, helper){
        helper.onInit(component, helper);        
    },

    /**** Show or hide selectlist ****/
    doToggleList : function(component, event, helper) { 
        helper.toggleList(component, event);
    },
    
    doClose : function(component, event, helper){
    	var picklist = component.find("picklist");
    	if($A.util.hasClass(picklist, 'slds-is-open')){
    		$A.util.removeClass(picklist, 'slds-is-open');
    	}
    },
    
    doHideList : function(component, event, helper) {
    	var picklist = component.find("picklist");
        $A.util.removeClass(picklist, 'slds-is-open');
    },

    /**** Select item ****/
    doSelect : function(component, event, helper){
        helper.selectItem(component, event, helper);
    },

    /**** Change state of required ****/
    doChangeRequired : function(component, event, helper){
        helper.checkRequired(component, helper);
    }

})