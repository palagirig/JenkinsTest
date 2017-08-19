/*
* KV: 02614
* Called from Trigger, Resets Availability
* @change Ticket 5758 + Redesign
*/
public class Adv_CampaignItem_ResetAvailability extends TriggerController{
    public Adv_CampaignItem_ResetAvailability(Boolean isAfter, Boolean isBefore, Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate,
                                        List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems) {
        super(isAfter, isBefore, isDelete, isInsert, isUndelete, isUpdate, lstNewItems, mapNewItems, lstOldItems, mapOldItems);
    }

	Map<ID, Schema.RecordTypeInfo> mapRecordTypes = Schema.SObjectType.ADvendio__Campaign_Item__c.getRecordTypeInfosById();

    protected override void runBeforeUpdate() {
        setAvailability((List<ADvendio__Campaign_Item__c>) lstNewItems, (Map<Id, ADvendio__Campaign_Item__c>) mapOldItems);
    }
    
	/**
	* reset an item's availability if certain changes are done
	* @param	a list of ADvendio__Campaign_Item__c records (trigger.new)
	* @param	a map of ADvendio__Campaign_Item__c records with their id's as key (trigger.oldMap)
	**/
	public void setAvailability(List<ADvendio__Campaign_Item__c> lstNewItems, Map<Id, ADvendio__Campaign_Item__c> mapOldItems) {
        Map<Id, Id> changedCampaignItemsWithPacket = new Map<Id, Id>();
       
        for (ADvendio__Campaign_Item__c ci : lstNewItems) {
            ADvendio__Campaign_Item__c ciOld = mapOldItems.get(ci.Id); // old values                 
            
            if (mapRecordTypes.get(ci.RecordTypeId).getName() !='Packet' && (// ignore package-headers - availability is set through it's components
            	ci.ADvendio__AdDayOfWeek__c					!= ciOld.ADvendio__AdDayOfWeek__c ||
                ci.ADvendio__AdHourOfDay__c					!= ciOld.ADvendio__AdHourOfDay__c ||
                ci.ADvendio__AdKeyValues__c					!= ciOld.ADvendio__AdKeyValues__c ||
                ci.ADvendio__AdKeyWords__c					!= ciOld.ADvendio__AdKeyWords__c ||
                ci.ADvendio__AdOperatingSystems__c			!= ciOld.ADvendio__AdOperatingSystems__c ||
                ci.ADvendio__AdWebBrowsers__c				!= ciOld.ADvendio__AdWebBrowsers__c ||
                //ci.ADvendio__FC_Ad_served_every__c			!= ciOld.ADvendio__FC_Ad_served_every__c ||
                ci.ADvendio__FC_Period__c					!= ciOld.ADvendio__FC_Period__c ||
                ci.ADvendio__from_Date__c					!= ciOld.ADvendio__from_Date__c ||
                ci.ADvendio__Guaranteed_AI__c				!= ciOld.ADvendio__Guaranteed_AI__c ||
                //ci.ADvendio__Priority__c					!= ciOld.ADvendio__Priority__c ||
                ci.ADvendio__Quantity__c					!= ciOld.ADvendio__Quantity__c ||
                ci.ADvendio__Targetingabbrevation__c		!= ciOld.ADvendio__Targetingabbrevation__c ||
                ci.ADvendio__until_Date__c					!= ciOld.ADvendio__until_Date__c ||
                ci.SomDig_Retargeting__c					!= ciOld.SomDig_Retargeting__c ||
				ci.ADvendio__SelectedCountryInformation__c	!= ciOld.ADvendio__SelectedCountryInformation__c ||
				ci.ADvendio__SelectedRegionInformation__c 	!= ciOld.ADvendio__SelectedRegionInformation__c ||
				ci.ADvendio__SelectedCityInformation__c 	!= ciOld.ADvendio__SelectedCityInformation__c ||
				ci.ADvendio__SelectedContentInformation__c 	!= ciOld.ADvendio__SelectedContentInformation__c)
            ){
                changedCampaignItemsWithPacket.put(ci.Id, ci.ADvendio__PacketItem__c);
            }
        }
           
        if (!changedCampaignItemsWithPacket.isEmpty()) {
            // for each paket count how many Youtube Items exist
            Set<Id> packetContainsYouTubeItem	= new Set<Id>();
            for(ADvendio__Campaign_Item__c component : [SELECT Id, Name, ADvendio__PacketItem__c, ADvendio__PacketItem__r.SomDig_Verteilung__c, SomDig_BelegungseinheitTyp__c
            											FROM ADvendio__Campaign_Item__c
            											WHERE ADvendio__PacketItem__c IN :changedCampaignItemsWithPacket.values() AND ADvendio__PacketItem__c != NULL]){
            	
            	// mark packages with YT components										
                if (!packetContainsYouTubeItem.contains(component.ADvendio__PacketItem__c) &&
                	component.SomDig_BelegungseinheitTyp__c == 'YouTube' &&
                	component.ADvendio__PacketItem__r.SomDig_Verteilung__c == 'Prorated') {
                	
	                packetContainsYouTubeItem.add(component.ADvendio__PacketItem__c);
                }
            }
			
            for (ADvendio__Campaign_Item__c ci : lstNewItems) {
            	if (changedCampaignItemsWithPacket.containsKey(ci.Id)) { // item was changed relevantly
	            	if (ci.ADvendio__PacketItem__c == null || // not package component
	            		!packetContainsYouTubeItem.contains(ci.ADvendio__PacketItem__c)) { // package does not contain YT placements
	            		
	            		ci.ADvendio__Availability__c = null;
	            	}
            	}
            }
        }
    }   
}