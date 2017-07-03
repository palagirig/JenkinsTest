({
	doSearchLookups : function(component, event, helper) {
		helper.searchLookups(component, helper);
	},

	doSelectObj : function(component, event, helper){
		helper.selectObj(component, event, helper);
	},

	doHandleChange : function(component, event, helper){
		helper.handleChange(component);
	},
	
	showModal: function(component, event, helper) {
        //Toggle CSS styles for opening Modal
        helper.toggleClass(component, 'backdrop', 'slds-backdrop--');
        helper.toggleClass(component, 'searchModal', 'slds-fade-in-');
    },

    hideModal : function(component, event, helper) {
         //Toggle CSS styles for hiding Modal
        helper.toggleClassInverse(component, 'backdrop', 'slds-backdrop--');
        helper.toggleClassInverse(component, 'searchModal', 'slds-fade-in-');
    }
    
    /*** OLD ***
    doInitScripts : function(component, event, helper){
		toastr.options = {
			"closeButton": true,
			"debug": false,
			"newestOnTop": false,
			"progressBar": true,
			"positionClass": "toast-bottom-right",
			"preventDuplicates": false,
			"onclick": null,
			"showDuration": "300",
			"hideDuration": "1000",
			"timeOut": "4000",
			"extendedTimeOut": "1000",
			"showEasing": "swing",
			"hideEasing": "linear",
			"showMethod": "fadeIn",
			"hideMethod": "fadeOut"
		}
	},

	doOpenModal : function(component, event, helper){
		var modal 	= component.find("lookupModal").getElement();
        jQuery(modal).modal();
	}*/
})