public with sharing class Adv_OptimizingChange_PostalCodes extends TriggerController {

	public Adv_OptimizingChange_PostalCodes(Boolean isAfter, Boolean isBefore, Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate,
		List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems) {
		super(isAfter, isBefore, isDelete, isInsert, isUndelete, isUpdate, lstNewItems, mapNewItems, lstOldItems, mapOldItems);
	}

	protected override void runAfterInsert() {
		setPlzWorkaround((List<ADvendio__OptimizingChange__c>) lstNewItems);
	}

	/**
	* check if ADvendio__SelectedAdServerIdInformation__c is changed and set ADvendio__SelectedContentInformation__c changes based on it,
	* delete ADvendio__SelectedContentInformation__c change when there's no ADvendio__SelectedAdServerIdInformation__c around
	* @param	list of ADvendio__OptimizingChange__c records (trigger.new)
	* @param	map of ADvendio__OptimizingChange__c records (trigger.oldMap)
	**/
	private void setPlzWorkaround(List<ADvendio__OptimizingChange__c> changeItems) {

		// version => campaignitem => new item identifier ==> change
		Map<Id, Map<Id, Map<Id, List<ADvendio__OptimizingChange__c>>>> plzChangesByVersion	= new Map<Id, Map<Id, Map<Id, List<ADvendio__OptimizingChange__c>>>>();
		Map<String, ADvendio__OptimizingChange__c> existingPlzByVersion						= new Map<String, ADvendio__OptimizingChange__c>();
		Map<String, ADvendio__OptimizingChange__c> existingAdserverIdByVersion				= new Map<String, ADvendio__OptimizingChange__c>();

		for (ADvendio__OptimizingChange__c change : changeItems) {
			if ('ADvendio__SelectedAdServerIdInformation__c'.equalsIgnoreCase(change.ADvendio__FieldName__c) ||
				(isInsert && 'ADvendio__SelectedContentInformation__c'.equalsIgnoreCase(change.ADvendio__FieldName__c) &&
				(change.ADvendio__OptimizedValue__c == null || change.ADvendio__OptimizedValue__c == ''))) {

				if (!plzChangesByVersion.containsKey(change.ADvendio__OptimizingVersion__c)) {
					plzChangesByVersion.put(change.ADvendio__OptimizingVersion__c, new Map<Id, Map<Id, List<ADvendio__OptimizingChange__c>>>());
				}
				if (!plzChangesByVersion.get(change.ADvendio__OptimizingVersion__c).containsKey(change.ADvendio__CampaignItem__c)) {
					plzChangesByVersion.get(change.ADvendio__OptimizingVersion__c).put(change.ADvendio__CampaignItem__c, new Map<Id, List<ADvendio__OptimizingChange__c>>());
				}
				if (!plzChangesByVersion.get(change.ADvendio__OptimizingVersion__c).get(change.ADvendio__CampaignItem__c).containsKey(change.ADvendio__NewCiIdentifier__c)) {
					plzChangesByVersion.get(change.ADvendio__OptimizingVersion__c).get(change.ADvendio__CampaignItem__c).put(change.ADvendio__NewCiIdentifier__c, new List<ADvendio__OptimizingChange__c>());
				}
				plzChangesByVersion.get(change.ADvendio__OptimizingVersion__c).get(change.ADvendio__CampaignItem__c).get(change.ADvendio__NewCiIdentifier__c).add(change);
			}
		}

		if (!plzChangesByVersion.isEmpty()) {
			for (ADvendio__OptimizingChange__c oc : [SELECT Id, ADvendio__OptimizingVersion__c, ADvendio__OriginalValue__c, ADvendio__OptimizedValue__c, ADvendio__CampaignItem__c, ADvendio__NewCiIdentifier__c,ADvendio__FieldName__c
													 FROM ADvendio__OptimizingChange__c
													 WHERE ADvendio__OptimizingVersion__c IN :plzChangesByVersion.keySet()
													 AND (ADvendio__FieldName__c = 'ADvendio__SelectedAdServerIdInformation__c' OR ADvendio__FieldName__c = 'ADvendio__SelectedContentInformation__c')]) {

				if ('ADvendio__SelectedAdServerIdInformation__c'.equalsIgnoreCase(oc.ADvendio__FieldName__c)) {
					existingAdserverIdByVersion.put(oc.ADvendio__OptimizingVersion__c+'|'+oc.ADvendio__CampaignItem__c+'|'+oc.ADvendio__NewCiIdentifier__c, oc);
				}
				else {
					existingPlzByVersion.put(oc.ADvendio__OptimizingVersion__c+'|'+oc.ADvendio__CampaignItem__c+'|'+oc.ADvendio__NewCiIdentifier__c, oc);
				}
			}
		}

		List<Id> changesToDelete							= new List<Id>();
		List<ADvendio__OptimizingChange__c> changesToUpsert	= new List<ADvendio__OptimizingChange__c>();

		for (Id ovId : plzChangesByVersion.keySet()) {
			for (Id ciId : plzChangesByVersion.get(ovId).keySet()) {
				for (Id ciNewId : plzChangesByVersion.get(ovId).get(ciId).keySet()) {
					for (ADvendio__OptimizingChange__c newChange : plzChangesByVersion.get(ovId).get(ciId).get(ciNewId)) {
						ADvendio__OptimizingChange__c oldChange				= existingPlzByVersion.get(ovId+'|'+ciId+'|'+ciNewId);
						ADvendio__OptimizingChange__c oldAdserverIdChange	= existingAdserverIdByVersion.get(ovId+'|'+ciId+'|'+ciNewId);

						if ('ADvendio__SelectedContentInformation__c'.equalsIgnoreCase(newChange.ADvendio__FieldName__c) && oldAdserverIdChange == null) {
							changesToDelete.add(newChange.Id);
						}

						if ('ADvendio__SelectedAdServerIdInformation__c'.equalsIgnoreCase(newChange.ADvendio__FieldName__c)) {
							String plzStringNew	= createPlzString(newChange.ADvendio__OptimizedValue__c);
							String plzStringOld	= createPlzString(newChange.ADvendio__OriginalValue__c);
							if (oldChange != null) { // update the existing, matching change
								oldChange.ADvendio__OptimizedValue__c	= plzStringNew;
							}
							else { // create a new change based on the chage regarding adserver-id-information
								oldChange	= newChange.clone();
								oldChange.ADvendio__FieldName__c		= 'ADvendio__SelectedContentInformation__c';
								oldChange.ADvendio__OptimizedValue__c	= plzStringNew;
								oldChange.ADvendio__OriginalValue__c	= plzStringOld;
							}
							changesToUpsert.add(oldChange);
						}
					}
				}
			}
		}
		upsert changesToUpsert;
		if (!changesToDelete.isEmpty()) {
			deleteChangeOnInsert(changesToDelete);
		}
	}

	@future
	private static void deleteChangeOnInsert(List<Id> changeIds) {
		List<ADvendio__OptimizingChange__c> changes	= new List<ADvendio__OptimizingChange__c>();
		for (Id changeId : changeIds) {
			changes.add(new ADvendio__OptimizingChange__c(Id=changeId));
		}
		delete changes;
	}

	private static String createPlzString(String adserverIdString) {
		String plzString	= null;
		Pattern postalCodePattern	= pattern.compile('.*?Postal Code: (.*?)(;.*)?$');
		if (adserverIdString != null) {
			Matcher m = postalCodePattern.matcher(adserverIdString);
			if (m.matches()) {
				plzString	= m.group(1);
			}
		}
		return plzString;
	}
}