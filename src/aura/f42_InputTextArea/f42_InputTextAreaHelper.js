({
    onInit: function(component, helper) {
        var required    = component.get("v.required");
        helper.checkRequired(component, helper, required);
    },

    handleChange: function(component, helper) {
        helper.validateField(component, helper);
    },

    checkRequired : function(component, helper, required) {
        var isValid = component.get("v.isValid");
        if(required) {
            isValid = false;
            helper.validateField(component, helper, isValid);
        } else {
            isValid = true;
        }
        component.set("v.isValid", isValid);

    },

    validateField : function(component, helper, isValid) {
        var isRequired    = component.get("v.required");
        var inputText = component.find("inputText").get("v.value");
        var errorMsg = "";
        var inputStyle = "normal";
        var isEmpty = true;

        if(isRequired) {
           if(typeof inputText === 'undefined' || inputText === null || inputText === '') {
                errorMsg = "Please enter a Text.";
                inputStyle = "error";
                isValid = false;
            } else {
                isEmpty = false;
            }
        } else {
            isValid = true;
        }

        component.set("v.errorMsg", errorMsg);
        component.set("v.inputStyle", inputStyle);
        component.set("v.isValid", isValid);

    }

})