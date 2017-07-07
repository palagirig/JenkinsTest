public with sharing class Adv_CampaignItem_PackageSumDeliveries extends TriggerController {
	/**
	 * Constructor.
	 * @see TriggerController   The base class of trigger controller.
	 */
	public Adv_CampaignItem_PackageSumDeliveries(Boolean isAfter, Boolean isBefore,
			Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate,
			List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems)
	{
		super(isAfter, isBefore, isDelete, isInsert, isUndelete, isUpdate, lstNewItems, mapNewItems, lstOldItems, mapOldItems);
	}

	/**
	 * Override method to perform action after an update operation was fired.
	 * @see TriggerController#runAfterUpdate
	 */
	protected override void runAfterUpdate() {
		updatePackageHeadDeliveryData();
	}

	/**
	 * Sum delivered impressions and clicks for package head items
	 */
	private void updatePackageHeadDeliveryData() {
		Set<Id> changedPackageItemIds = new Set<Id>();
		Map<Id, ADvendio__Campaign_Item__c> triggerNewMap = (Map<Id, ADvendio__Campaign_Item__c>)mapNewItems;
		for (ADvendio__Campaign_Item__c ci : (List<ADvendio__Campaign_Item__c>)lstOldItems) {
			if (triggerNewMap.containsKey(ci.Id) 
					&& (ci.ADvendio__Delivered_Impressions__c != triggerNewMap.get(ci.Id).ADvendio__Delivered_Impressions__c
						|| ci.ADvendio__Delivered_Clicks__c != triggerNewMap.get(ci.Id).ADvendio__Delivered_Clicks__c)) {
				changedPackageItemIds.add(ci.ADvendio__PacketItem__c);
			}
		}

		changedPackageItemIds.remove(null);

		if (!changedPackageItemIds.isEmpty()) {
			Map<Id, ADvendio__Campaign_Item__c> packages = new Map<Id, ADvendio__Campaign_Item__c>([
					SELECT Id, ADvendio__PacketItem__c, ADvendio__Delivered_Impressions__c, ADvendio__Delivered_Clicks__c
					FROM ADvendio__Campaign_Item__c 
					WHERE Id IN :changedPackageItemIds OR ADvendio__PacketItem__c IN :changedPackageItemIds]);

			List<ADvendio__Campaign_Item__c> packageItemsToUpdate = new List<ADvendio__Campaign_Item__c>();
			for (ADvendio__Campaign_Item__c packageCi : packages.values()) {
				if (changedPackageItemIds.contains(packageCi.Id)) { // if it is the package head
					Decimal deliveredImpressions;
					Decimal deliveredClicks;
					for (ADvendio__Campaign_Item__c componentCi : packages.values()) {
						if (componentCi.ADvendio__PacketItem__c == packageCi.Id) {
							ADvendio__Campaign_Item__c ciToUse; // if the component is in the trigger, use the updated trigger record, otherwise take the record from the db.
							if (triggerNewMap.containsKey(componentCi.Id)) {
								ciToUse = triggerNewMap.get(componentCi.Id);
							} else {
								ciToUse = componentCi;
							}
							if (ciToUse.ADvendio__Delivered_Impressions__c != null) {
								deliveredImpressions =  (deliveredImpressions != null ? deliveredImpressions : 0) + ciToUse.ADvendio__Delivered_Impressions__c;
							}
							if (ciToUse.ADvendio__Delivered_Clicks__c != null) {
								deliveredClicks = (deliveredClicks != null ? deliveredClicks : 0 ) + ciToUse.ADvendio__Delivered_Clicks__c;
							}
						}
					} // end for component items
					packageCi.ADvendio__Delivered_Impressions__c = deliveredImpressions;
					//packageCi.ADvendio__Delivered_Clicks__c = deliveredClicks;
					packageItemsToUpdate.add(packageCi);
				} // end if is package head item
			}
			update packageItemsToUpdate;
		}
	}
}