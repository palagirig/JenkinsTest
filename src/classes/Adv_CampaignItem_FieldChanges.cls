public with sharing class Adv_CampaignItem_FieldChanges extends TriggerController {

	public Adv_CampaignItem_FieldChanges(Boolean isAfter, Boolean isBefore, Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate,
										List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems) {
		super(isAfter, isBefore, isDelete, isInsert, isUndelete, isUpdate, lstNewItems, mapNewItems, lstOldItems, mapOldItems);
	}

	protected override void runBeforeInsert() {
		setLineDescription((List<ADvendio__Campaign_Item__c>) lstNewItems, null);
		setAdServerStatus((List<ADvendio__Campaign_Item__c>) lstNewItems, null);
		setPlzWorkaround((List<ADvendio__Campaign_Item__c>) lstNewItems, null);
	}
	
	protected override void runBeforeUpdate() {
		setLineDescription((List<ADvendio__Campaign_Item__c>) lstNewItems, (Map<Id, ADvendio__Campaign_Item__c>) mapOldItems);
		setAdServerStatus((List<ADvendio__Campaign_Item__c>) lstNewItems, (Map<Id, ADvendio__Campaign_Item__c>) mapOldItems);
		setPlzWorkaround((List<ADvendio__Campaign_Item__c>) lstNewItems, (Map<Id, ADvendio__Campaign_Item__c>) mapOldItems);
	}

	/**
	* parse postal codes from ADvendio__SelectedAdServerIdInformation__c and copy those to ADvendio__SelectedContentInformation__c
	* @param	list of ADvendio__Campaign_Item__c records (trigger.new)
	* @param	map of ADvendio__Campaign_Item__c records (trigger.oldMap)
	**/
	private void setPlzWorkaround(List<ADvendio__Campaign_Item__c> campaignItems, Map<Id, ADvendio__Campaign_Item__c> oldCampaignItems) {
		Pattern postalCodePattern	= pattern.compile('.*?Postal Code: (.*?)(;.*)?$');
		for (ADvendio__Campaign_Item__c ci : campaignItems) {
			ci.ADvendio__SelectedContentInformation__c	= null;
			if (ci.ADvendio__SelectedAdServerIdInformation__c != null) {
				Matcher m = postalCodePattern.matcher(ci.ADvendio__SelectedAdServerIdInformation__c);
				if (m.matches()) {
					ci.ADvendio__SelectedContentInformation__c	= m.group(1);
				}
			}
		}
	}

	private void setLineDescription(List<ADvendio__Campaign_Item__c> newCampaignItemsList, Map<Id, ADvendio__Campaign_Item__c> oldCampaignItemsMap) {
		for (ADvendio__Campaign_Item__c ci : newCampaignItemsList) {
			if (oldCampaignItemsMap == null ||
				ci.SomDig_Freitextnotiz__c != oldCampaignItemsMap.get(ci.Id).SomDig_Freitextnotiz__c ||
				ci.ADvendio__Rate_Discount_4_Name__c != oldCampaignItemsMap.get(ci.Id).ADvendio__Rate_Discount_4_Name__c ||
				ci.SomDig_OtpAufschlag__c != oldCampaignItemsMap.get(ci.Id).SomDig_OtpAufschlag__c ||
				ci.SomDig_Preiskriterium__c != oldCampaignItemsMap.get(ci.Id).SomDig_Preiskriterium__c ||
				ci.SomDig_Retargeting__c != oldCampaignItemsMap.get(ci.Id).SomDig_Retargeting__c ||
				ci.ADvendio__Quantity__c != oldCampaignItemsMap.get(ci.Id).ADvendio__Quantity__c || 
				ci.SomDig_Menge__c != oldCampaignItemsMap.get(ci.Id).SomDig_Menge__c || 
				ci.SomDig_NaturalRabatt__c != oldCampaignItemsMap.get(ci.Id).SomDig_NaturalRabatt__c 
			) {
				ci.ADvendio__LineDescription__c	= buildLineDescription(ci);
			}
		}
	}

	public static String buildLineDescription(ADvendio__Campaign_Item__c ci) {
		return buildLineDescription(ci, null);
	}

	public static String buildLineDescription(ADvendio__Campaign_Item__c ci, String nrField) {
		List<String> descriptionParts = new List<String>();
		nrField = nrField == null ? 'gebuchte Menge' : nrField;
		String nrPlaceholder = '-Die {0} beinhaltet ein Naturalrabatt von {1}% ({2} Ad Impressions)';

		if (ci.SomDig_Freitextnotiz__c != null && ci.SomDig_Freitextnotiz__c != '') {
			descriptionParts.add('-' + ci.SomDig_Freitextnotiz__c);
		}

		if (ci.ADvendio__Rate_Discount_4_Name__c == 'Positionsrabatt Natural') {
			descriptionParts.add(String.format(nrPlaceholder, new String[]{nrField, '100', String.valueOf(ci.ADvendio__Quantity__c.round())}));
		} else if (ci.ADvendio__Rate_Discount_4_Name__c == 'Nachlieferung') {
			descriptionParts.add('-Nachlieferung');
		} else if (ci.ADvendio__Rate_Discount_4_Name__c == 'Kompensation') {
			descriptionParts.add('-Kompensation');
		} else if (stornoMitOderOhneLeistungsfluss(ci)) {
			descriptionParts.add('-Storno');
		}
        if (ci.SomDig_Naturalrabatt__c != null && ci.SomDig_Naturalrabatt__c != 0 && ci.ADvendio__Quantity__c != null && ci.SomDig_Menge__c != null) {
        	descriptionParts.add(String.format(nrPlaceholder, new String[]{nrField, String.valueOf(ci.SomDig_NaturalRabatt__c.format()), String.valueOf(ci.ADvendio__Quantity__c.round() - ci.SomDig_Menge__c.round())}));
        }
		if (ci.SomDig_OtpAufschlag__c) {
			descriptionParts.add('-OTP');
		}

		if (ci.SomDig_Retargeting__c) {
			descriptionParts.add('-Re-Targeting-Aufschlag');
		}

		if (ci.SomDig_Preiskriterium__c != null && ci.SomDig_Preiskriterium__c != '') {
			descriptionParts.add('-Videolänge: ' + ci.SomDig_Preiskriterium__c);
		}

		return String.join(descriptionParts, '\n');
	}

	private void setAdServerStatus(List<ADvendio__Campaign_Item__c> newCampaignItemsList, Map<Id, ADvendio__Campaign_Item__c> oldCampaignItemsMap) {
		for (ADvendio__Campaign_Item__c ci : newCampaignItemsList) {
			if (oldCampaignItemsMap == null ||
				ci.ADvendio__Rate_Discount_4_Name__c != oldCampaignItemsMap.get(ci.Id).ADvendio__Rate_Discount_4_Name__c
			) {
				if (stornoMitOderOhneLeistungsfluss(ci)) {
					ci.ADvendio__AdserverStatus__c = 'Released';
				} else {
					ci.ADvendio__AdserverStatus__c = 'Active';
				}
			}
		}
	}

	private static Boolean stornoMitOderOhneLeistungsfluss(ADvendio__Campaign_Item__c ci) {
		return (
			ci.ADvendio__Rate_Discount_4_Name__c == 'Storno mit Leistungsfluss' ||
			ci.ADvendio__Rate_Discount_4_Name__c == 'Storno ohne Leistungsfluss'
		);
	}
}