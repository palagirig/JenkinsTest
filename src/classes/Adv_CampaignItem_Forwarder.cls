public class Adv_CampaignItem_Forwarder {

    public ADvendio__Campaign_Item__c objCI;
    public String dmlType;
    public String sRCName;

    public Adv_CampaignItem_Forwarder(ApexPages.standardController con){
        objCI = (ADvendio__Campaign_Item__c) con.getRecord();

        if (objCI.Id != null) {
            objCI = [SELECT ADvendio__from_Date__c, ADvendio__Rate_Discount_4_Name__c, ADvendio__Media_Campaign__c, ADvendio__Media_Campaign__r.RecordType.Name FROM ADvendio__Campaign_Item__c WHERE ID = :objCI.ID];
            sRCName = objCI.ADvendio__Media_Campaign__r.RecordType.Name;

            if (ApexPages.currentPage().getParameters().containsKey('delID')) {
                dmlType = 'delete';
            } else {
                dmlType = 'update';
            }
        } else {
            dmlType = 'insert';
        }
    }

    public PageReference forward(){
        if (dmlType == 'delete') {
            if (sRCName == 'Angebot') {

                // Ticket 04273 - added try/catch to show message when blocking campaignitem delete.
                try {
                    delete objCI;
                    return mcPage();
                } catch(Exception e) {
                    ApexPages.addMessages(e);
                }

            }

            if (sRCName == 'Auftrag') {
                return pagereferenceOpti();
            }

        } else if (dmlType == 'update') {
            if (forwarderInactiveForCurrentUser()) {
                return editPage();
            }

            if (sRCName == 'Angebot') {
                return pagereferenceKEM();
            }

            if (sRCName == 'Auftrag') {
                if (objCI.ADvendio__from_Date__c > Date.today()) {
                    return pagereferenceKEM();
                } else {
                    return pagereferenceOpti();
                }
            }

        } else {
            if (forwarderInactiveForCurrentUser()) {
                return productSearchPage();
            } else {
                return pagereferenceOpti();
            }
        }

        return null;
    }

    public PageReference pagereferenceKEM(){
        PageReference p1 = Page.ADvendio__MediaConfiguration;
        p1.getParameters().put('retURL', '/' + objCI.ADvendio__Media_Campaign__c);
        p1.getParameters().put('wrapMassAction', '1');
        p1.getParameters().put('scontrolCaching', '1');
        p1.getParameters().put('id', objCI.ADvendio__Media_Campaign__c);
        p1.setRedirect(true);
        return p1;
    }

    public PageReference pagereferenceOpti(){
        PageReference p1 = Page.ADvendio__Optimizer;
        p1.getParameters().put('mcId', objCI.ADvendio__Media_Campaign__c);
        p1.getParameters().put('records', objCI.ID);
        p1.setRedirect(true);
        return p1;
    }

    public PageReference productSearchPage(){
        PageReference productSearchPage = Page.ADvendio__SelectSearch;
        productSearchPage.getParameters().put('id', objCI.ADvendio__Media_Campaign__c);
        productSearchPage.getParameters().put('retURL', '/' + objCI.ADvendio__Media_Campaign__c);
        productSearchPage.getParameters().put('wrapMassAction', '1');
        productSearchPage.getParameters().put('scontrolCaching', '1');
        productSearchPage.setRedirect(true);
        return productSearchPage;
    }

    public PageReference editPage(){
        PageReference editPage = new PageReference('/' + objCI.Id + '/e');
        editPage.getParameters().put('retURL', '/' + objCI.ADvendio__Media_Campaign__c);
        editPage.getParameters().put('nooverride', '1');
        editPage.setRedirect(true);
        return editPage;
    }

    public PageReference mcPage(){
        PageReference mcPage = new PageReference('/' + objCI.ADvendio__Media_Campaign__c);
        mcPage.setRedirect(true);
        return mcPage;
    }

    private Boolean forwarderInactiveForCurrentUser() {
        Integer numberOfCustomPermissionAssignments = [
            SELECT count()
              FROM SetupEntityAccess
             WHERE SetupEntityId IN (SELECT Id FROM CustomPermission WHERE DeveloperName = 'SomDig_CampaignItemForwarderInactive')
               AND ParentId IN (SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId())
        ];

        return (numberOfCustomPermissionAssignments > 0);
    }

}