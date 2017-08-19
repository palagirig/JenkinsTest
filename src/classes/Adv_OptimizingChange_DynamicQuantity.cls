public with sharing class Adv_OptimizingChange_DynamicQuantity extends TriggerController {

    public Adv_OptimizingChange_DynamicQuantity(Boolean isAfter, Boolean isBefore, Boolean isDelete, Boolean isInsert, Boolean isUndelete, Boolean isUpdate,
        List<sObject> lstNewItems, Map<Id, sObject> mapNewItems, List<sObject> lstOldItems, Map<Id, sObject> mapOldItems) {
        super(isAfter, isBefore, isDelete, isInsert, isUndelete, isUpdate, lstNewItems, mapNewItems, lstOldItems, mapOldItems);
    }

    protected override void runBeforeUpdate() {
        calculateQuantityOfPacketComponentItem((List<ADvendio__OptimizingChange__c>) lstNewItems, (Map<Id, ADvendio__OptimizingChange__c>) mapOldItems);
    }
    
    protected override void runBeforeInsert() {
        calculateQuantityOfPacketComponentItem((List<ADvendio__OptimizingChange__c>) lstNewItems, (Map<Id, ADvendio__OptimizingChange__c>) mapOldItems);
    }
    
    /**
     * Calculate the Quantity of Packet Component Items.
     *
     * Annahmen: Es werden immer alle Paketbestandteile abgefragt und aktualisiert.
     *
     * @param   lstNewRecords   A list of ADvendio__OptimizingChange__c to check.
     * @param   mapNewRecords   A map of ADvendio__OptimizingChange__c to use for fast access.
     */
    private void calculateQuantityOfPacketComponentItem(List<ADvendio__OptimizingChange__c> triggerNew, Map<Id, ADvendio__OptimizingChange__c> triggerOldMap) {
      Set<Id> updatedCiIds = new Set<Id>();
      Set<Id> newChangesIds = new Set<Id>();
      Id optimizerVersionId;
      for (ADvendio__OptimizingChange__c change : triggerNew) {
        if ('ADvendio__LastAvailabilityForecast__c'.equalsIgnoreCase(change.ADvendio__FieldName__c)) { //TODO ist das ausreichend und korrekt?
          updatedCiIds.add(change.ADvendio__CampaignItem__c);
          optimizerVersionId = change.ADvendio__OptimizingVersion__c;
        }
        newChangesIds.add(change.Id);
      }
    if (!updatedCiIds.isEmpty()) {
      Map<Id, ADvendio__Campaign_Item__c> cis = new Map<Id, ADvendio__Campaign_Item__c>([
          SELECT Id, SomDig_Menge__c, ADvendio__Quantity__c, ADvendio__Delivered_Impressions__c,
            ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__Placement__r.SomDig_Typ__c, ADvendio__Availability__c,
            ADvendio__PacketItem__r.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__Distribution__c,
            ADvendio__PacketItem__c, ADvendio__PacketItem__r.ADvendio__Quantity__c, ADvendio__PacketItem__r.ADvendio__PacketItem__c,
            ADvendio__PacketItem__r.ADvendio__Billing_category__c, ADvendio__PacketItem__r.SomDig_Menge__c, ADvendio__Sales_Price__c, SomDig_Naturalrabatt__c
          FROM ADvendio__Campaign_Item__c
          WHERE Id IN :updatedCiIds AND ADvendio__PacketItem__c != null]);
      List<ADvendio__OptimizingChange__c> otherChanges = [SELECT Id, ADvendio__CampaignItem__c, ADvendio__FieldName__c, ADvendio__NewCiIdentifier__c, 
                                    ADvendio__OptimizedValue__c
                                  FROM ADvendio__OptimizingChange__c
                                  WHERE ADvendio__OptimizingVersion__c = :optimizerVersionId];
      otherChanges.addAll(triggerNew);
      addCisAndApplyRelevantChanges(cis, otherChanges); // Package item quantity changes and newly added packets
      applyTriggerChanges(cis, triggerNew); // set changed availability
      List<ADvendio__OptimizingChange__c> proratedChanges = new List<ADvendio__OptimizingChange__c>();
      for (ADvendio__Campaign_Item__c packetItem : cis.values()) {
        if (packetItem.ADvendio__PacketItem__c == null && 'CPM'.equals(packetItem.ADvendio__Billing_category__c)
            && 'Prorated'.equals(packetItem.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__Distribution__c)) { 
          Boolean hasYoutube = false;
          List<ADvendio__Campaign_Item__c> components = new List<ADvendio__Campaign_Item__c>();
          Decimal availabilitySum = 0;
          for (ADvendio__Campaign_Item__c componentItem : cis.values()) {
            if (packetItem.Id.equals(componentItem.ADvendio__PacketItem__c) && componentItem.ADvendio__Availability__c != null) {
              components.add(componentItem);
              availabilitySum += componentItem.ADvendio__Availability__c;
              try {
                if ('YouTube'.equals(componentItem.ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__Placement__r.SomDig_Typ__c)) {
                  hasYoutube = true;
                }
              } catch (Exception e) {}
            }
          }
          if (hasYoutube) {
            if(packetItem.SomDig_Menge__c == null || packetItem.SomDig_Menge__c == 0) {
              Adv_OptimizingChange_DynamicQuantity.calculateProratedPackageQuantity(packetItem, components, availabilitySum);
            } else {
              Adv_OptimizingChange_DynamicQuantity.calculateProratedPackageMenge(packetItem, components, availabilitySum);
            }
            proratedChanges.addAll(generateProratedChanges(components, otherChanges, newChangesIds));
          }
        }
        
      }
      upsert proratedChanges;
    }
    }
    
    /**
     * Update the Campaign Items list with relevant changes. These are:
     *     - Packetitem Quantity
     *     - Newly added Packages
     *
     * @param cis List of Campaign Items to be updated.
     * @param changes All Optimizer changes of the selected Optimizer Version.
     */
    private void addCisAndApplyRelevantChanges(Map<Id, ADvendio__Campaign_Item__c> cis, List<ADvendio__OptimizingChange__c> changes) {
      for (ADvendio__Campaign_Item__c ci : cis.values()) {
        if (ci.ADvendio__PacketItem__c != null && !cis.containsKey(ci.ADvendio__PacketItem__c)) {
          cis.put(ci.ADvendio__PacketItem__c, ci.ADvendio__PacketItem__r);
        }
      }
      for (ADvendio__OptimizingChange__c change : changes) {
      if (cis.containsKey(change.ADvendio__CampaignItem__c)) {
        if ('ADvendio__Quantity__c'.equalsIgnoreCase(change.ADvendio__FieldName__c)) {
          cis.get(change.ADvendio__CampaignItem__c).ADvendio__Quantity__c = Decimal.valueOf(change.ADvendio__OptimizedValue__c);
        } else if ('SomDig_Menge__c'.equalsIgnoreCase(change.ADvendio__FieldName__c)) {
          cis.get(change.ADvendio__CampaignItem__c).SomDig_Menge__c = Decimal.valueOf(change.ADvendio__OptimizedValue__c);
        }
      } else { // newly added TODO
      }      
    }
    }

  /**
   * Update the availability with the changes from the trigger
   * @param cis Campaign Items to updates
   * @param changes Changes from Trigger.new
   */
    private void applyTriggerChanges(Map<Id, ADvendio__Campaign_Item__c> cis, List<ADvendio__OptimizingChange__c> changes) {
      for (ADvendio__OptimizingChange__c change : changes) {
        if (cis.containsKey(change.ADvendio__CampaignItem__c) && 'ADvendio__Availability__c'.equalsIgnoreCase(change.ADvendio__FieldName__c)) {
          cis.get(change.ADvendio__CampaignItem__c).ADvendio__Availability__c = Decimal.valueOf(change.ADvendio__OptimizedValue__c);
        }
      }
    }
    
    /**
     * Generate Optimizer Changes for optimized prorated packages. Set the Quantity and Prorated factor for the components.
     *
     * @param components Component Campaign Items of one package with updated quantity and prorated factor.
     * @param changes The Optimizer Changes from the database to check if there are existing Quantity or prorated changes that must be updated.
     * @return List of updated or created Optimizer Changes 
     */
    private List<ADvendio__OptimizingChange__c> generateProratedChanges(List<ADvendio__Campaign_Item__c> components, List<ADvendio__OptimizingChange__c> changes,
        Set<Id> newChangesIds) {
      List<ADvendio__OptimizingChange__c> changesToUpsert = new List<ADvendio__OptimizingChange__c>();
      for (ADvendio__Campaign_Item__c ci : components) {
        ADvendio__OptimizingChange__c quantityChange;
        ADvendio__OptimizingChange__c proratedChange;
        ADvendio__OptimizingChange__c lastForecastChange;
        ADvendio__OptimizingChange__c mengeChange;
        for (ADvendio__OptimizingChange__c change : changes) {
          if (ci.Id.equals(change.ADvendio__NewCiIdentifier__c != null ? change.ADvendio__NewCiIdentifier__c : change.ADvendio__CampaignItem__c)) {
            if ('ADvendio__Quantity__c'.equalsIgnoreCase(change.ADvendio__FieldName__c)) {
              quantityChange = change;
            } else if ('ADvendio__Prorated__c'.equalsIgnoreCase(change.ADvendio__FieldName__c)) {
              proratedChange = change;
            } else if ('ADvendio__LastAvailabilityForecast__c'.equalsIgnoreCase(change.ADvendio__FieldName__c)) { // remember change to clone it
              lastForecastChange = change;
            } else if ('SomDig_Menge__c'.equalsIgnoreCase(change.ADvendio__FieldName__c)) {
              mengeChange = change;
            }
          }
        }
        if (lastForecastChange != null) { // lastForecastChange == null should not happen
          if (quantityChange == null) { // create a new change if it does not already exist
            quantityChange = lastForecastChange.clone(false, false, false, false);
            quantityChange.ADvendio__FieldName__c = 'ADvendio__Quantity__c';
            quantityChange.ADvendio__OriginalValue__c = null; // TODO
            quantityChange.ADvendio__OptimizedValue__c = String.valueOf(ci.ADvendio__Quantity__c);
            changesToUpsert.add(quantityChange);
          } else {
            quantityChange.ADvendio__OptimizedValue__c = String.valueOf(ci.ADvendio__Quantity__c);
            if (quantityChange.Id != null && !newChangesIds.contains(quantityChange.Id)) { // add if it is not in the trigger
              changesToUpsert.add(quantityChange);
            }
          }
          if (proratedChange == null) { // create a new change if it does not already exist
            proratedChange = lastForecastChange.clone(false, false, false, false);
            proratedChange.ADvendio__FieldName__c = 'ADvendio__Prorated__c';
            proratedChange.ADvendio__OriginalValue__c = null; // TODO
            proratedChange.ADvendio__OptimizedValue__c = String.valueOf(ci.ADvendio__Prorated__c);
            changesToUpsert.add(proratedChange);
          } else {
            proratedChange.ADvendio__OptimizedValue__c = String.valueOf(ci.ADvendio__Prorated__c);
            if (proratedChange.Id != null && !newChangesIds.contains(proratedChange.Id)) { // add if it is not in the trigger
              changesToUpsert.add(proratedChange);
            }
          }
          if (mengeChange == null) { // create a new change if it does not already exist
            mengeChange = lastForecastChange.clone(false, false, false, false);
            mengeChange.ADvendio__FieldName__c = 'SomDig_Menge__c';
            mengeChange.ADvendio__OriginalValue__c = null; // TODO
            mengeChange.ADvendio__OptimizedValue__c = String.valueOf(ci.SomDig_Menge__c);
            changesToUpsert.add(mengeChange);
          } else {
            mengeChange.ADvendio__OptimizedValue__c = String.valueOf(ci.SomDig_Menge__c);
            if (mengeChange.Id != null && !newChangesIds.contains(mengeChange.Id)) { // add if it is not in the trigger
              changesToUpsert.add(mengeChange);
            }
          }
        }
      }
      return changesToUpsert;
    }  
    
    public static void calculateProratedPackageQuantity(ADvendio__Campaign_Item__c packetItem, List<ADvendio__Campaign_Item__c> components, Decimal sumAvai) {
        List<ADvendio__Campaign_Item__c> cisToReorder = components.clone();
        Boolean moreReorderToDo = true;
        Decimal deliveredSum = 0;
        Decimal availableSum = 0;

        while (moreReorderToDo && !cisToReorder.isEmpty()) { // calculate the prorated factor
            moreReorderToDo = false;
            Integer i = 0;
            while (i < cisToReorder.size()) {
                ADvendio__Campaign_Item__c ci = cisToReorder[i];

                Decimal deliveredWithMinimum    = Math.max((ci.ADvendio__Delivered_Impressions__c == null ? 0 : ci.ADvendio__Delivered_Impressions__c), 10);
                // If there were more impressions delivered that would be calculated via the availability, we set prorated = delivered / package.quantity ...
                if (ci.ADvendio__Availability__c != null &&
                    Math.floor(ci.ADvendio__Availability__c / sumAvai * packetItem.ADvendio__Quantity__c) < deliveredWithMinimum) {
                    ci.ADvendio__Prorated__c = deliveredWithMinimum / packetItem.ADvendio__Quantity__c * 100.0;
                    // ... and add the factor x to sumAvai to keep the calculation of other Campaign Items correct.
                    deliveredSum += deliveredWithMinimum;
                    availableSum += ci.ADvendio__Availability__c;
                    // Factor x is calculated by the availability, delivered impressions and the sum of all availabilities.
                    // If other Campaign Items were adjusted previously, we have to add the availability and delivered impressions values to our calculation
                    Decimal x = (deliveredSum * sumAvai - packetItem.ADvendio__Quantity__c * availableSum ) / (packetItem.ADvendio__Quantity__c - deliveredSum);
                    sumAvai += x;
                    availableSum += x;
                    cisToReorder.remove(i);
                    moreReorderToDo = true;
                } else if (ci.ADvendio__Availability__c != null) { // recalculate the prorated factor for Campaign Items that have delivered less.
                    ci.ADvendio__Prorated__c = 100 * ci.ADvendio__Availability__c / sumAvai; // This line is called for each remaining item on the last run of the while loop.
                    i++;
                }
            }
        }
        if (cisToReorder.isEmpty()) { // If more impressions were delivered than sold throw an error
            for (ADvendio__Campaign_Item__c ci : components) {
                ci.addError(System.Label.ErrorProratedPackageTooMuchDelivery);
            }
        }
        Decimal totalQuantity = 0;
        for (ADvendio__Campaign_Item__c ci : components) { // calculate the quantity
            ci.ADvendio__Quantity__c = Math.floor(packetItem.ADvendio__Quantity__c * ci.ADvendio__Prorated__c / 100);

            //ci.ADvendio__Quantity__c = ci.ADvendio__Quantity__c < 10.0 ? 10.0 : ci.ADvendio__Quantity__c;
            totalQuantity += ci.ADvendio__Quantity__c;
        }

        if (totalQuantity != packetItem.ADvendio__Quantity__c) {
            components.get(components.size()-1).ADvendio__Quantity__c += packetItem.ADvendio__Quantity__c - totalQuantity;
        }
    }

    public static void calculateProratedPackageMenge(ADvendio__Campaign_Item__c packetItem, List<ADvendio__Campaign_Item__c> components, Decimal sumAvai) {
        List<ADvendio__Campaign_Item__c> cisToReorder = components.clone();
        Boolean moreReorderToDo = true;
        Decimal deliveredSum = 0;
        Decimal availableSum = 0;

        while (moreReorderToDo && !cisToReorder.isEmpty()) { // calculate the prorated factor
            moreReorderToDo = false;
            Integer i = 0;
            while (i < cisToReorder.size()) {
                ADvendio__Campaign_Item__c ci = cisToReorder[i];

                Decimal deliveredWithMinimum    = Math.max((ci.ADvendio__Delivered_Impressions__c == null ? 0 : ci.ADvendio__Delivered_Impressions__c), 10);
                // If there were more impressions delivered that would be calculated via the availability, we set prorated = delivered / package.quantity ...
                if (ci.ADvendio__Availability__c != null &&
                    Math.floor(ci.ADvendio__Availability__c / sumAvai * packetItem.SomDig_Menge__c) < deliveredWithMinimum) {
                    ci.ADvendio__Prorated__c = deliveredWithMinimum / packetItem.SomDig_Menge__c * 100.0;
                    // ... and add the factor x to sumAvai to keep the calculation of other Campaign Items correct.
                    deliveredSum += deliveredWithMinimum;
                    availableSum += ci.ADvendio__Availability__c;
                    // Factor x is calculated by the availability, delivered impressions and the sum of all availabilities.
                    // If other Campaign Items were adjusted previously, we have to add the availability and delivered impressions values to our calculation
                    Decimal x = (deliveredSum * sumAvai - packetItem.SomDig_Menge__c * availableSum ) / (packetItem.SomDig_Menge__c - deliveredSum);
                    sumAvai += x;
                    availableSum += x;
                    cisToReorder.remove(i);
                    moreReorderToDo = true;
                } else if (ci.ADvendio__Availability__c != null) { // recalculate the prorated factor for Campaign Items that have delivered less.
                    ci.ADvendio__Prorated__c = 100 * ci.ADvendio__Availability__c / sumAvai; // This line is called for each remaining item on the last run of the while loop.
                    i++;
                }
            }
        }
        if (cisToReorder.isEmpty()) { // If more impressions were delivered than sold throw an error
            for (ADvendio__Campaign_Item__c ci : components) {
                ci.addError(System.Label.ErrorProratedPackageTooMuchDelivery);
            }
        }
        Decimal totalMenge = 0;
        for (ADvendio__Campaign_Item__c ci : components) { // calculate the quantity
            ci.SomDig_Menge__c = Math.floor(packetItem.SomDig_Menge__c * ci.ADvendio__Prorated__c / 100);
            ci = Adv_CampaignItem_Naturalrabatt.setNaturalrabatt(ci);
            //ci.ADvendio__Quantity__c = ci.ADvendio__Quantity__c < 10.0 ? 10.0 : ci.ADvendio__Quantity__c;
            totalMenge += ci.SomDig_Menge__c;
        }

        if (totalMenge != packetItem.SomDig_Menge__c) {
            components.get(components.size()-1).SomDig_Menge__c += packetItem.SomDig_Menge__c - totalMenge;
        }
    }

}