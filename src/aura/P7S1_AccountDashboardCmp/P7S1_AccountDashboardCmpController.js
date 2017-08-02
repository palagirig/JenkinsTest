({
	loadData: function(component, event, helper) {
                helper.doLoadData(component, helper);
            },

            doBtnClick : function(component, event, helper){
                helper.doRedirect(component);
            }
})