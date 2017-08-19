/*
* KV: 06323
* Called from Trigger, Naturalrabatt settings and validations
*/
public with sharing class Adv_CampaignItem_Naturalrabatt extends TriggerController {
	public Adv_CampaignItem_Naturalrabatt(Boolean isAfter, Boolean isBefore, Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate,
										List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems) {
		super(isAfter, isBefore, isDelete, isInsert, isUndelete, isUpdate, lstNewItems, mapNewItems, lstOldItems, mapOldItems);
	}

	protected override void runBeforeInsert() {
		presetNaturalrabatt((List<ADvendio__Campaign_Item__c>) lstNewItems, null);
		setNegativeQuantityOnCancellation((List<ADvendio__Campaign_Item__c>) lstNewItems);
	}
	
	protected override void runBeforeUpdate() {
		presetNaturalrabatt((List<ADvendio__Campaign_Item__c>) lstNewItems, (Map<Id, ADvendio__Campaign_Item__c>) mapOldItems);
	}
	
	protected override void runBeforeUndelete() {
		presetNaturalrabatt((List<ADvendio__Campaign_Item__c>) lstNewItems, null);
	}
	
	
	/**
	* when a campaign-item is created with ADvendio__ConnectedItem__c is set, we assume it's a neg. item to cancel another item
	* we then need to neg. SomDig_Menge__c as it's not done during the cancellation process
	* also it's checked if  both quantity got the same signun
	* @param	list of ADvendio__Campaign_Item__c records (trigger.new)
	**/
	private void setNegativeQuantityOnCancellation(List<ADvendio__Campaign_Item__c> campaignItems) {
		for (ADvendio__Campaign_Item__c ci : campaignItems) {
			if (ci.ADvendio__ConnectedItem__c != null) {
				if (Math.signum(ci.ADvendio__Quantity__c) != Math.signum(ci.SomDig_Menge__c)) {
					ci.SomDig_Menge__c	= -ci.SomDig_Menge__c;
				}
			}
		}
	}
	
	/**
	* preset Quantity (w/o Naturalrabatt) and Naturalrabatt  
	* @param	a list of ADvendio__Campaign_Item__c records (trigger.new)
	**/
	public void presetNaturalrabatt(List<ADvendio__Campaign_Item__c> campaignItems, Map<Id, ADvendio__Campaign_Item__c> oldCampaignItems) {
		for (ADvendio__Campaign_Item__c ci : campaignItems) {
			ci.SomDig_Naturalrabatt__c	= ci.SomDig_Naturalrabatt__c == null	? 0							: ci.SomDig_Naturalrabatt__c;
			if (isInsert ||
				isUndelete ||
				oldCampaignItems.get(ci.Id).SomDig_Menge__c == null) { // SomDig_Menge__c is NULL before and was not changed manually to NULL => presetting is OK
				ci.SomDig_Menge__c			= ci.SomDig_Menge__c == null		? ci.ADvendio__Quantity__c	: ci.SomDig_Menge__c;
			}
			else { // isUpdate and SomDig_Menge__c was changed manually to NULL => presetting is NOT OK, instead set 0
				if (ci.SomDig_Menge__c == null || ci.SomDig_Menge__c == 0) {
					ci.SomDig_Menge__c.addError(Label.ADvendio.Required_field_missing_BA + ' ' + ADvendio__Campaign_Item__c.SomDig_Menge__c.getDescribe().getLabel());
				}
			}
		}
	}
	
	/**
	* calculate Quantity including Naturalrabatt 
	* @param	a list of ADvendio__Campaign_Item__c records (trigger.new)
	**/
	public static ADvendio__Campaign_Item__c setNaturalrabatt(ADvendio__Campaign_Item__c ci) {
		
		ci.SomDig_Naturalrabatt__c = ci.SomDig_Naturalrabatt__c == null ? 0 : ci.SomDig_Naturalrabatt__c;
		if (ci.SomDig_Menge__c != null) {
			ci.ADvendio__Quantity__c	= (ci.SomDig_Menge__c * (1 + (ci.SomDig_Naturalrabatt__c/100))).setScale(0, System.RoundingMode.HALF_DOWN);
		}
		
		Decimal b3Normal				= calculateAmount(	ci.ADvendio__Billing_category__c,
															ci.ADvendio__Sales_Price__c,
															ci.SomDig_Menge__c,
															ci.ADvendio__Frequency__c,
															2,
															ci.ADvendio__SurchargeSalesPrice__c);
		Decimal b3MitNaturalrabatt		= calculateAmount(	ci.ADvendio__Billing_category__c,
															ci.ADvendio__Sales_Price__c,
															ci.ADvendio__Quantity__c,
															ci.ADvendio__Frequency__c,
															2,
															ci.ADvendio__SurchargeSalesPrice__c);
		
		ci.ADvendio__SurchargeB3Abs__c	= b3Normal - b3MitNaturalrabatt;
		ci.ADvendio__SurchargeB3__c		= 0;
		return ci;
	}
	
	/**
	 * Calculates amount.
	 *
	 * @param billingCategory
	 * @param salesPrice
	 * @param quantity
	 * @param frequency
	 * @param scale
	 * @param surchargeSalesPrice
	 * @return amount B3
	 */
	public static Decimal calculateAmount(String billingCategory, Decimal salesPrice, Decimal quantity, Decimal frequency, Integer scale, Decimal surchargeSalesPrice) {
		Decimal amount = 0;
		
		if ('cpm'.equalsIgnoreCase(billingCategory) || 'vcpm'.equalsIgnoreCase(billingCategory)) {
			if (surchargeSalesPrice == null) {
				surchargeSalesPrice = 0;
			}
			
			amount = (salesPrice + surchargeSalesPrice) / 1000 * quantity;
		} else {
			amount = salesPrice * quantity;
		}
		
		if (frequency == null || frequency == 0) {
			frequency = 1;
		}
		
		amount = amount * frequency;
		
		return amount.setScale(scale, System.RoundingMode.HALF_UP);
	}
}