public with sharing class Adv_OptimizingChange_DeliverPrio{

    @testvisible private static List<SomDig_DeliverPrio__c> cachedPrioDatasets {
        get {
            if (cachedPrioDatasets == null) {
                cachedPrioDatasets = [
                    SELECT Id, SomDig_Gueltig_ab__c, SomDig_Gueltig_bis__c, SomDig_Abrechungsart__c, SomDig_Ad_Type__c,
                           SomDig_Belegungseinheitstyp__c, SomDig_Mediagattungsdifferenzierung__c, SomDig_Rotationstyp__c,
                           SomDig_Werbeform_Kurzform__c, SomDig_Auftragstyp__c, SomDig_Prio__c
                      FROM SomDig_DeliverPrio__c
                  ORDER BY SomDig_Werbeform_Kurzform__c DESC, SomDig_Rotationstyp__c DESC
                ];
            }
            return cachedPrioDatasets;
        }
        set;
    }

    public static void calculatePriority(List<ADvendio__OptimizingChange__c> lstNewItems){
        // stop here if trigger context includes OptimizingChanges for more than 1 OptimizingVersion
        if (!Adv_OptimizingChange_Handler.isSingleOptimizingVersion(lstNewItems)) return;    
        
        // Map CampaignItemID with Map of Fieldname & Optimizing change
        Map<ID, Map<String, ADvendio__OptimizingChange__c>> mapCIOpti = Adv_OptimizingChange_Handler.getCIOptiMapNewOnly((List<ADvendio__OptimizingChange__c>) lstNewItems);    

        
        // Get MediaCampaign       
        List<ADvendio__MediaCampaign__c> listMC = new List<ADvendio__MediaCampaign__c>([SELECT ID,ADvendio__Pricelist__r.SomDig_AuftragstypId__c FROM ADvendio__MediaCampaign__c WHERE ID = :lstNewItems[0].SomDig_MediaCampaignID__c LIMIT 1]); 
        if(listMC.size() == 0) return;
        ADvendio__MediaCampaign__c objMC = listMC[0];

        // Get AdPrices for comparison
        Set<ID> setAdPriceIDs = new Set<ID>();
        for (ID ocID : mapCIOpti.keySet()) {
            Map<String, ADvendio__OptimizingChange__c> mapFields = mapCIOpti.get(ocID); 
            System.Debug('#####' + mapFields);             
            if(mapFields.containsKey('advendio__ad_price__c')){
                setAdPriceIDs.add(mapFields.get('advendio__ad_price__c').ADvendio__OptimizedValue__c);
            }                
        }
                 
        
        Map<ID, ADvendio__Ad_price__c> mapAdPrice = new Map<ID, ADvendio__Ad_price__c>([SELECT ID,ADvendio__Ad_Spec__r.ADvendio__Ad_Type__r.SomDig_MediagattungsDifferenzierung__c, ADvendio__Ad_Spec__r.ADvendio__Ad_Type__r.ADvendio__Advertising_Form_Shortform__c, ADvendio__Ad_Spec__r.ADvendio__Placement__r.SomDig_Rotationstyp__c, ADvendio__Ad_Spec__r.ADvendio__Placement__r.SomDig_Typ__c FROM ADvendio__Ad_price__c WHERE ID IN :setAdPriceIDs]);
        
        
        List<SomDig_DeliverPrio__c> step1 = new List<SomDig_DeliverPrio__c>();
        List<SomDig_DeliverPrio__c> step2 = new List<SomDig_DeliverPrio__c>();
        List<SomDig_DeliverPrio__c> step3 = new List<SomDig_DeliverPrio__c>();
        
        // List for new OCs
        List<ADvendio__OptimizingChange__c> listNewOCs = new List<ADvendio__OptimizingChange__c>();
    
        // Calculate Prios
        for (ID ocID : mapCIOpti.keySet()){
        
            Map<String, ADvendio__OptimizingChange__c> mapFields = mapCIOpti.get(ocID);   
            ADvendio__Ad_price__c adPrice = null;
            if(mapFields.containsKey('advendio__ad_price__c')){
                adPrice = mapAdPrice.get(mapFields.get('advendio__ad_price__c').ADvendio__OptimizedValue__c);
            }      
        
            for (SomDig_DeliverPrio__c prio : cachedPrioDatasets) {
                Boolean isDatevalid = false;
                Boolean isAbrechnungsart = false;
                Boolean isAuftragstyp = false;
                Boolean isBelegungseinheit = false;
                Boolean isMediagattungsdifferenz = false;
                Boolean isRotationstyp = false;
                Boolean isWerbeform_Kurzform = false;
                
                
                if(mapFields.containsKey('advendio__from_date__c') && mapFields.containsKey('advendio__until_date__c')){
                    if(Date.valueOf(mapFields.get('advendio__from_date__c').ADvendio__OptimizedValue__c) >= prio.SomDig_Gueltig_ab__c && Date.valueOf(mapFields.get('advendio__until_date__c').ADvendio__OptimizedValue__c)  <= prio.SomDig_Gueltig_bis__c){
                        isDateValid = true;
                    }                                    
                }
                
                if(adPrice != null){
                    String shortform = adPrice.ADvendio__Ad_Spec__r.ADvendio__Ad_Type__r.ADvendio__Advertising_Form_Shortform__c;
                    if (shortform != null && shortform.equals(prio.SomDig_Werbeform_Kurzform__c)) 
                        isWerbeform_Kurzform = true;
  
                    
                    if (adPrice.ADvendio__Ad_Spec__r.ADvendio__Placement__r.SomDig_Rotationstyp__c == prio.SomDig_Rotationstyp__c)
                        isRotationstyp = true;
                    
                    
                    if(adPrice.ADvendio__Ad_Spec__r.ADvendio__Ad_Type__r.SomDig_MediagattungsDifferenzierung__c == prio.SomDig_Mediagattungsdifferenzierung__c)
                        isMediagattungsdifferenz = true;

                    
                    if (adPrice.ADvendio__Ad_Spec__r.ADvendio__Placement__r.SomDig_Typ__c == prio.SomDig_Belegungseinheitstyp__c)
                        isBelegungseinheit = true;                                         
                }                
                      
                String auftragstyp = objMC.ADvendio__Pricelist__r.SomDig_AuftragstypId__c;
                if (auftragstyp != null && auftragstyp == prio.SomDig_Auftragstyp__c) {
                    isAuftragstyp = true;
                }
                
                if (mapFields.containsKey('advendio__billing_category__c')){
                    if(mapFields.get('advendio__billing_category__c').ADvendio__OptimizedValue__c == prio.SomDig_Abrechungsart__c){
                        isAbrechnungsart = true;   
                    }
                }

                System.debug('###Prio: isAbrechnungsart ' + isAbrechnungsart);
                System.debug('###Prio: isAuftragstyp ' + isAuftragstyp);
                System.debug('###Prio: isBelegungseinheit ' + isBelegungseinheit);
                System.debug('###Prio: isMediagattungsdifferenz ' + isMediagattungsdifferenz);
                System.debug('###Prio: isRotationstyp ' + isRotationstyp);
                System.debug('###Prio: isWerbeform_Kurzform ' + isWerbeform_Kurzform);


                // If true add this item to the list: step1
                if (isDateValid && isAbrechnungsart && isAuftragstyp && isBelegungseinheit && isMediagattungsdifferenz && isRotationstyp && isWerbeform_Kurzform) {
                    if (step1.isEmpty()) {
                        listNewOCs.add(createPrioOC(prio.SomDig_Prio__c, mapFields.get('name')));
                        listNewOCs.add(createAdTypeOC(prio.SomDig_Ad_Type__c, mapFields.get('name')));
                        break;
                    }
                } else if (isDateValid && isAbrechnungsart && isAuftragstyp && isBelegungseinheit && isMediagattungsdifferenz && isRotationstyp && prio.SomDig_Werbeform_Kurzform__c == null) {
                    if (step2.isEmpty()) {
                        listNewOCs.add(createPrioOC(prio.SomDig_Prio__c, mapFields.get('name')));
                        listNewOCs.add(createAdTypeOC(prio.SomDig_Ad_Type__c, mapFields.get('name')));
                        break;
                    }

                } else if (isDateValid && isAbrechnungsart && isAuftragstyp && isBelegungseinheit && isMediagattungsdifferenz && prio.SomDig_Werbeform_Kurzform__c == null && prio.SomDig_Rotationstyp__c == null ) {
                    if (step3.isEmpty()) {
                        listNewOCs.add(createPrioOC(prio.SomDig_Prio__c, mapFields.get('name')));
                        listNewOCs.add(createAdTypeOC(prio.SomDig_Ad_Type__c, mapFields.get('name')));
                        break;
                    }
                }
            }   
        }
        
        insert listNewOCs;
    }
    
    public static ADvendio__OptimizingChange__c createPrioOC(String prio, ADvendio__OptimizingChange__c dummy){
        ADvendio__OptimizingChange__c objNewOC = dummy.clone();
        objNewOC.Name = null;
        objNewOC.ADvendio__NewCiIdentifier__c = dummy.ADvendio__NewCiIdentifier__c;
        objNewOC.ADvendio__FieldName__c = 'advendio__priority__c';
        objNewOC.ADvendio__OptimizedValue__c = prio;
        return objNewOC;
    }
    
    public static ADvendio__OptimizingChange__c createAdTypeOC(String adType, ADvendio__OptimizingChange__c dummy){
        ADvendio__OptimizingChange__c objNewOC = dummy.clone();
        objNewOC.Name = null;        
        objNewOC.ADvendio__NewCiIdentifier__c = dummy.ADvendio__NewCiIdentifier__c;        
        objNewOC.ADvendio__FieldName__c = 'advendio__adType__c';
        objNewOC.ADvendio__OptimizedValue__c = adType;
        return objNewOC;        
    }    
}