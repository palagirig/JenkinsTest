({
    doHandleChange: function(component, event, helper) {
        helper.handleChange(component, helper);
    },

    defaultChange : function(component, event, helper){
    	var isValid = component.get("v.isValid"),
    	fire = component.get("v.fireChangeEvt");
    	
    	
        if(isValid && fire){
        	//Fire onChange event
            var indicatorStr = component.get("v.indicatorStr"),
            method2Execute = component.get("v.method2Execute"),
            changeEvt = component.getEvent("onChangeInputNumber");
            
            changeEvt.setParams({
            	"indicator": indicatorStr,
            	"method2Execute": method2Execute
            })
            changeEvt.fire();
        }
    }
})