@isTest
public class Adv_CampaignItem_PositionStatus_Test {
	
    @isTest
    public static void testAddAdId() {
        ADvendio__MediaCampaign__c mc	= cls_P7S1_TestData.createTestMediaCampaign(true);
        ADvendio__Campaign_Item__c ci1	= cls_P7S1_TestData.createTestCampaignItem(false, mc);
        ADvendio__Campaign_Item__c ci2	= cls_P7S1_TestData.createTestCampaignItem(false, mc);
        
        ci1.ADvendio__Ad_Id__c			= '12340987';
        
        insert new List<ADvendio__Campaign_Item__c>{ci1, ci2};
        
        for (ADvendio__Campaign_Item__c ci : [SELECT Id, SomDig_PositionStatus__c, SomDig_MotivEingebucht__c, ADvendio__LastBookingProcess__c, ADvendio__StatusSubmittedToAdServer__c 
                                              FROM ADvendio__Campaign_Item__c WHERE ADvendio__Media_Campaign__c = :mc.Id]) {
            
        	if (ci.Id == ci1.Id) {
                system.debug(ci);
            	system.assert(!ci.SomDig_MotivEingebucht__c); // welche Logik setzt das wieder inaktiv?
            	system.assert(ci.ADvendio__LastBookingProcess__c != null);
            	system.assertEquals('Created', ci.ADvendio__StatusSubmittedToAdServer__c);
                system.assertEquals('inaktiv', ci.SomDig_PositionStatus__c); // da SomDig_MotivEingebucht__c inaktiv
            }
            else if (ci.Id == ci2.Id) {
            	system.assert(!ci.SomDig_MotivEingebucht__c);
            	system.assert(ci.ADvendio__LastBookingProcess__c == null);
            	system.assert(ci.ADvendio__StatusSubmittedToAdServer__c == null);
                system.assertEquals('An Adserver übermitteln', ci.SomDig_PositionStatus__c);
            }
        }
        
        ci1.ADvendio__Ad_Id__c	= null;
        ci2.ADvendio__Ad_Id__c	= '5143542';
        update new List<ADvendio__Campaign_Item__c>{ci1, ci2};

        for (ADvendio__Campaign_Item__c ci : [SELECT Id, SomDig_PositionStatus__c, SomDig_MotivEingebucht__c, ADvendio__LastBookingProcess__c, ADvendio__StatusSubmittedToAdServer__c 
                                              FROM ADvendio__Campaign_Item__c WHERE ADvendio__Media_Campaign__c = :mc.Id]) {
            
        	if (ci.Id == ci1.Id) { // unverändert zum insert, da nicht auf das Leeren der Ad-Id reagiert wird
            	system.assert(!ci.SomDig_MotivEingebucht__c);
            	system.assert(ci.ADvendio__LastBookingProcess__c != null);
            	system.assertEquals('Created', ci.ADvendio__StatusSubmittedToAdServer__c);
                system.assertEquals('inaktiv', ci.SomDig_PositionStatus__c);
            }
            else if (ci.Id == ci2.Id) {
            	system.assert(ci.SomDig_MotivEingebucht__c);
            	system.assert(ci.ADvendio__LastBookingProcess__c != null);
            	system.assertEquals('Created', ci.ADvendio__StatusSubmittedToAdServer__c);
                system.assertEquals('Auslieferung-@Risk', ci.SomDig_PositionStatus__c);
            }
        }
    }
    
    static testMethod void testCampaignItemPositionStatus(){
    
        Datetime dtNow = System.now();
    
        ADvendio__Campaign_Item__c objCI = cls_P7S1_TestData.createTestCampaignItem(true);
        
        Test.startTest();
        // Status: Ad Status aktualisieren (Status senden)
        objCI.SomDig_LastAdServerStatusProcess__c = dtNow.addDays(-2);
        objCI.SomDig_LastAdServerStatusChange__c = dtNow.addDays(-1);        
        objCI.ADvendio__LastBookingProcess__c = dtNow;
        objCI.ADvendio__until_Date__c = Date.valueOf(dtNow.addDays(1));        
        update objCI;
        
        
        
        // Status:  An Adserver übermitteln (Position buchen)
        objCI.SomgDig_LastDurationChange__c = Date.valueOf(dtNow.addDays(2));
        objCI.SomDig_LastAdServerStatusProcess__c = dtNow.addDays(1);         
        update objCI;               
        
        
        
        ///// Position pausiert oder gestoppt
        objCI.ADvendio__AdserverStatus__c = 'Paused';
        objCI.ADvendio__LastBookingProcess__c = dtNow.addDays(3);                 
        update objCI;                       
        
        
                  
     
        ///// inaktiv
        // BD != dtNull && BD > AOD && BD > UFD && dDeliveredImp == null && !bMotivGebucht && bAdserverRel
        objCI.ADvendio__LastBookingProcess__c = dtNow.addDays(5);        
        objCI.ADvendio__until_Date__c = Date.valueOf(dtNow.addDays(4));   
        objCI.ADvendio__AdserverStatus__c = '';                     
        update objCI;              
        Test.stopTest();
        
    }
}