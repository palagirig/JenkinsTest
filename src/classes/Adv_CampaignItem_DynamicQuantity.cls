public with sharing class Adv_CampaignItem_DynamicQuantity extends TriggerController {

    public Adv_CampaignItem_DynamicQuantity(Boolean isAfter, Boolean isBefore, Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate,
                                            List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems) {
        super(isAfter, isBefore, isDelete, isInsert, isUndelete, isUpdate, lstNewItems, mapNewItems, lstOldItems, mapOldItems);
    }

    protected override void runBeforeUpdate() {
        calculateQuantityOfPacketComponentItem((List<ADvendio__Campaign_Item__c>) lstNewItems, (Map<Id, ADvendio__Campaign_Item__c>) mapNewItems, (Map<Id, ADvendio__Campaign_Item__c>) mapOldItems);
    }


    private void calculateQuantityOfPacketComponentItem(List<ADvendio__Campaign_Item__c> lstNewRecords, Map<Id, ADvendio__Campaign_Item__c> mapNewRecords, Map<Id, ADvendio__Campaign_Item__c> mapOldRecords) {
        if(SomDig_SOQLOptimizer.iDynamicQuantityRun > 4) return;
                
        Map<Id, List<ADvendio__Campaign_Item__c>> mPacketItemId2ComponentItems = new Map<Id, List<ADvendio__Campaign_Item__c>>();
        for (ADvendio__Campaign_Item__c ci : lstNewRecords) {
            if (ci.ADvendio__PacketItem__c != null && ci.ADvendio__Availability__c != mapOldRecords.get(ci.ID).ADvendio__Availability__c) {
                List<ADvendio__Campaign_Item__c> components = mPacketItemId2ComponentItems.get(ci.ADvendio__PacketItem__c);
                if (components == null) {
                    components = new List<ADvendio__Campaign_Item__c>();
                    mPacketItemId2ComponentItems.put(ci.ADvendio__PacketItem__c, components);
                }
                components.add(ci);
            }
        }

        if (mPacketItemId2ComponentItems.isEmpty()) return;

        List<ADvendio__Campaign_Item__c> listCampaignItems = new List<ADvendio__Campaign_Item__c>([Select SomDig_Menge__c, ADvendio__Quantity__c,ADvendio__Availability__c, ADvendio__from_Date__c, ADvendio__Until_Date__c,
                                                                                                  (Select SomDig_BelegungseinheitTyp__c, ADvendio__Availability__c, SomDig_SumDeliveredImpressions__c From ADvendio__PacketComponents__r Where ADvendio__Billing_category__c='CPM' order by ADvendio__Availability__c)
                                                                                                   From ADvendio__Campaign_Item__c Where Id IN :mPacketItemId2ComponentItems.keySet()
                                                                                                   AND ADvendio__Billing_category__c='CPM'
                                                                                                   AND ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__Distribution__c = 'Prorated'
                                                                                                   AND ADvendio__from_Date__c >= TODAY]);
   

        if(!listCampaignItems.isEmpty())
            SomDig_SOQLOptimizer.iDynamicQuantityRun++;
        
        
        Set<ID> setHeaders = new Set<ID>();
        for (ADvendio__Campaign_Item__c objPaket : listCampaignItems){        
            List<ADvendio__Campaign_Item__c> components = objPaket.ADvendio__PacketComponents__r;

            if(components.size() != mPacketItemId2ComponentItems.get(objPaket.ID).size()) return;
            
            ADvendio__Campaign_Item__c ci1 = mPacketItemId2ComponentItems.get(objPaket.ID)[0];
            ADvendio__Campaign_Item__c ci2 = mPacketItemId2ComponentItems.get(objPaket.ID)[1];               
        
            if(ci1.SomDig_BelegungseinheitTyp__c  != 'YouTube' && ci2.SomDig_BelegungseinheitTyp__c  != 'YouTube')
                continue;
                                     
            
            Decimal dNumber1 = ci1.ADvendio__Availability__c == null || ci1.ADvendio__Availability__c < 10 ? 10 : ci1.ADvendio__Availability__c;
            Decimal dNumber2 = ci2.ADvendio__Availability__c == null || ci2.ADvendio__Availability__c < 10 ? 10 : ci2.ADvendio__Availability__c;
            
            if (objPaket.SomDig_Menge__c == null || objPaket.SomDig_Menge__c == 0) {
	            Decimal dQuan1 = objPaket.ADvendio__Quantity__c * (dNumber1 / (dNumber1 + dNumber2));    
	            ci1.ADvendio__Quantity__c = dNumber1 < dNumber2 ? dQuan1.round(System.RoundingMode.UP) : dQuan1.round(System.RoundingMode.DOWN);                   
	            ci2.ADvendio__Quantity__c = objPaket.ADvendio__Quantity__c - ci1.ADvendio__Quantity__c;
	            
	            ci1.ADvendio__Prorated__c = (ci1.ADvendio__Quantity__c/objPaket.ADvendio__Quantity__c)*100;
	            ci2.ADvendio__Prorated__c = (ci2.ADvendio__Quantity__c/objPaket.ADvendio__Quantity__c)*100;
            }
            else {
            	Decimal dQuan1 = objPaket.SomDig_Menge__c * (dNumber1 / (dNumber1 + dNumber2));    
	            ci1.SomDig_Menge__c = dNumber1 < dNumber2 ? dQuan1.round(System.RoundingMode.UP) : dQuan1.round(System.RoundingMode.DOWN);                   
	            ci2.SomDig_Menge__c = objPaket.SomDig_Menge__c - ci1.SomDig_Menge__c;        

	            ci1.ADvendio__Prorated__c = (ci1.SomDig_Menge__c/objPaket.SomDig_Menge__c)*100;
	            ci2.ADvendio__Prorated__c = (ci2.SomDig_Menge__c/objPaket.SomDig_Menge__c)*100;
	            ci1	= Adv_CampaignItem_Naturalrabatt.setNaturalrabatt(ci1);
	            ci2	= Adv_CampaignItem_Naturalrabatt.setNaturalrabatt(ci2);
            }
            
            setHeaders.add(objPaket.ID);
        }
        
        if (!setHeaders.isEmpty()){ 
            Adv_CampaignItem_DynamicQuantity.updateHeaders(setHeaders);            
        }        
        
    }
    
    @future
    public static void updateHeaders(Set<ID> setHeaders){
        List<ADvendio__Campaign_Item__c> listHeader = new List<ADvendio__Campaign_Item__c>([SELECT ADvendio__Prorated__c FROM ADvendio__Campaign_Item__c WHERE ID IN :setHeaders]);
        for(ADvendio__Campaign_Item__c o : listHeader)
            o.ADvendio__Prorated__c = o.ADvendio__Prorated__c == null ? 100 : null;     
        
        update listHeader;
    }    
}