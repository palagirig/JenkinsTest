({

	doSetEffYield : function(component, event, helper){
		helper.setEffYield(component, helper);
	},

	/**** BS 31.07.17 - EUR as default Currency ****
	doHandleOppPipeDetailOppEvent : function(component, event, helper){
		var currency = event.getParam("currency");

		if(currency !== null){
			component.set("v.currencyy", currency);
		}
	},*/

	checkValid : function(component, event, helper){
		helper.checkValidCmp(component);
	},

	doTestChange : function(component, event, helper){
	  alert('Huhu');
	  var pipe = component.get("v.oppPipeDetail");
	  component.set("v.oppPipeDetail", pipe);
  }
})