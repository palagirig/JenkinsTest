({
	setSum : function(component, index) {
		var opms 	= component.get("v.oppPipeYear.oppPipeMonths");
		var oldSum	= component.get("v.oppPipeYear.totalAmount");
		var sum 	= 0;
		var isValid = true;

		for(var i=0; i<opms.length; i+=1){
			if(opms[i].isValid){
				sum += parseInt(opms[i].Ven_Amount__c);
			}else {
				isValid = false;
			}
		}

		if(isValid){
			component.set("v.oppPipeYear.totalAmount", sum);
		}

		component.set("v.isValid", isValid);
		
		if(index < component.get("v.currentMonth") && sum !== 0 && oldSum !== sum && isValid && component.get("v.isCurrentYear")){
			var toolt = component.find("monthtt");
			
			//Show Tooltip
			$A.util.removeClass(toolt, 'hideIt');
			
			//Hide Tooltip
			window.setTimeout($A.getCallback(function(){
	            $A.util.addClass(toolt, 'hideIt');
	        }), 6000);
		}
	},

	calcTotalNetPot : function(component, helper){
		var clientLikelihood 	= component.get("v.clientLikelihood"),
		effYield 		= component.get("v.effYield"),
		totalOfSomLikelihood 	= helper.calcSomLikelihood(component);


		if($A.util.isEmpty(effYield) ||
			$A.util.isEmpty(totalOfSomLikelihood) ||
			$A.util.isEmpty(clientLikelihood)){
			return 0;
		}

		return Math.ceil((effYield/100) * (clientLikelihood/100) * totalOfSomLikelihood);
	},

	calcSomLikelihood : function(component){
		var effYield 		= component.get("v.effYield");
		var somLikelihoods 	= component.get("v.somLikelihoods");
		var opms 		= component.get("v.oppPipeYear.oppPipeMonths");
		var total 		= 0;

		for(var i=0; i<somLikelihoods.length; i+=1){
			var slh = somLikelihoods[i];

			if(effYield >= slh.Ven_Min__c && effYield <= slh.Ven_Max__c){
				if(opms[0].isValid){
					total = total + (slh.Ven_Jan__c/100) * opms[0].Ven_Amount__c;
				}
				if(opms[1].isValid){
					total = total + (slh.Ven_Feb__c/100) * opms[1].Ven_Amount__c;
				}
				if(opms[2].isValid){
					total = total + (slh.Ven_Mar__c/100) * opms[2].Ven_Amount__c;
				}
				if(opms[3].isValid){
					total = total + (slh.Ven_Apr__c/100) * opms[3].Ven_Amount__c;
				}
				if(opms[4].isValid){
					total = total + (slh.Ven_May__c/100) * opms[4].Ven_Amount__c;
				}
				if(opms[5].isValid){
					total = total + (slh.Ven_Jun__c/100) * opms[5].Ven_Amount__c;
				}
				if(opms[6].isValid){
					total = total + (slh.Ven_Jul__c/100) * opms[6].Ven_Amount__c;
				}
				if(opms[7].isValid){
					total = total + (slh.Ven_Aug__c/100) * opms[7].Ven_Amount__c;
				}
				if(opms[8].isValid){
					total = total + (slh.Ven_Sep__c/100) * opms[8].Ven_Amount__c;
				}
				if(opms[9].isValid){
					total = total + (slh.Ven_Oct__c/100) * opms[9].Ven_Amount__c;
				}
				if(opms[10].isValid){
					total = total + (slh.Ven_Nov__c/100) * opms[10].Ven_Amount__c;
				}
				if(opms[11].isValid){
					total = total + (slh.Ven_Dec__c/100) * opms[11].Ven_Amount__c;
				}
				return total;
			}
		}

		return total;
	}

	/******* BS - 21.06.2016 - Old Clalculation **********
	calcTotalNetPot : function(component, helper){
		var clientLikelihood 	= component.get("v.clientLikelihood"),
		totalAmount 		= component.get("v.oppPipeYear.totalAmount"),
		effYield 		= component.get("v.effYield"),
		somLikelihood 	= helper.getSomLikelihood(component);


		if($A.util.isEmpty(totalAmount) ||
			$A.util.isEmpty(effYield) ||
			$A.util.isEmpty(somLikelihood) ||
			$A.util.isEmpty(clientLikelihood)){
			return 0;
		}

		var testOld = Math.ceil(totalAmount * (effYield/100) * (somLikelihood/100) * (clientLikelihood/100));
		var testNew  = Math.ceil((effYield/100) * (clientLikelihood/100) * helper.calcSomLikelihood(component));

		return testOld;
	},

	getSomLikelihood : function(component){
		var effYield 		= component.get("v.effYield");
		var somLikelihoods 	= component.get("v.somLikelihoods");

		for(var i in somLikelihoods){
			var slh = somLikelihoods[i];

			if(effYield >= slh.Ven_Min__c && effYield <= slh.Ven_Max__c){
				var month = new Date().getMonth()+1;

				if(month == 1){
					return slh.Ven_Jan__c;
				}
				else if(month == 2){
					return slh.Ven_Feb__c;
				}
				else if(month == 3){
					return slh.Ven_Mar__c;
				}
				else if(month == 4){
					return slh.Ven_Apr__c;
				}
				else if(month == 5){
					return slh.Ven_May__c;
				}
				else if(month == 6){
					return slh.Ven_Jun__c;
				}
				else if(month == 7){
					return slh.Ven_Jul__c;
				}
				else if(month == 8){
					return slh.Ven_Aug__c;
				}
				else if(month == 9){
					return slh.Ven_Sep__c;
				}
				else if(month == 10){
					return slh.Ven_Oct__c;
				}
				else if(month == 11){
					return slh.Ven_Nov__c;
				}
				else if(month == 12){
					return slh.Ven_Dec__c;
				}
			}
		}

		return null;
	} ******* BS - 21.06.2016 - Old Clalculation **********/

})