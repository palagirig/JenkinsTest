({
    onInit: function(component, helper) {
        var required    = component.get("v.required");
        helper.checkRequired(component, helper, required);
    },

    handleChange: function(component, helper) {
        helper.validateField(component, helper);
    },

    checkRequired : function(component, helper, required) {
        var isValid;

        if(required) {
            isValid = false;
            helper.validateField(component, helper, isValid);
        } else {
            isValid = true;
        }
        component.set("v.isValid", isValid);
    },

    validateField : function(component, helper, isValid) {
        var displayDatePicker    = component.get("v.displayDatePicker");
        var isValid              = component.get("v.isValid");
        var isRequired           = component.get("v.required");
        var checkDate            = true;
        var isEmpty              = false;
        var errorMsg;
        var errorMsg2            = "";
        var inputStyle;

        var checkDateSelect = new Date(component.get("v.checkDateSelect"));
        var noDateSelect    = component.get("v.noDateSelect");
        var inputDateValue  = new Date(component.find("inputDate").get("v.value"));
        var inputDate       = component.find("inputDate").get("v.value");

        if(noDateSelect === 'before') {
           if(inputDateValue <= checkDateSelect - 1) {
               errorMsg2 = "Please enter a Date after ";
               inputStyle = "error";
               checkDate = false;
           } else {
               checkDate = true;
           }
        }

        if(noDateSelect === 'after') {
           if(inputDateValue - 1 >= checkDateSelect) {
                errorMsg2 = "Please enter a Date before ";
                inputStyle = "error";
                checkDate = false;
             } else {
                checkDate = true;
             }
        }

        if(noDateSelect === 'noDate') {
            checkDate = true;
        }

        if(isRequired) {
           if(typeof inputDate === 'undefined' || inputDate === null || inputDate === '') {
                errorMsg = "Please enter a Date.";
                inputStyle = "error";
                isEmpty = true;
            }
        }

        if(!checkDate || isEmpty) {
            isValid = false;
        } else {
            isValid = true;
        }

        component.set("v.errorMsg", errorMsg);
        component.set("v.errorMsg2", errorMsg2);
        component.set("v.inputStyle", inputStyle);
        component.set("v.isValid", isValid);

    }

})