global class P7S1_RollUpValidator implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        performAction();
    }

	public static void performAction()
    {
        checkRollUps(getRollUpList());
    }
    
    public static void checkRollUps(List<P7S1_Rollup__c> rollUps)
    {
        Map<P7S1_RollUp__c, String> errorMap = performCheck(rollUps);
        if(!errorMap.isEmpty())
        {
            String emailString = String.join(errorMap.values(), '\n');
            sendErrorMail(emailString);
        }
    }
    
    public static List<P7S1_Rollup__c> getRollUpList()
    {
        return [
            SELECT Name, Id, ChildCalculationField__c, ChildObject__c, ParentObject__c, ParentResultField__c,
            	RelationshipField__c, Type__c, WhereCondition__c
            FROM P7S1_Rollup__c
            WHERE Active__c = true
        ];
    }
    
    public static Map<P7S1_RollUp__c, String> performCheck(List<P7S1_Rollup__c> rollUps)
    {
        Map<P7S1_RollUp__c, String> errors = new Map<P7S1_RollUp__c, String>();

        for(P7S1_RollUp__c rollUp : rollUps)
        {
            
            String query = P7S1_RollUp.createQuery(rollUp);
            try
            {
                Set<Id> parentIds = new Set<Id>();
            	List<SObject> results = Database.query(query+' LIMIT 1');
            }
            catch(Exception exc)
            {
                String errorString = System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+rollUp.Id+'\n';
                errorString += query+'\n';
                errorString += exc.getMessage()+'\n';
                errors.put(rollUp, errorString);
            }

            query = getParentQuery(rollUp);
            try
            {
                Set<Id> parentIds = new Set<Id>();
                List<SObject> results = Database.query(query+' LIMIT 1');
            }
            catch(Exception exc)
            {
                String errorString = System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+rollUp.Id+'\n';
                errorString += query+'\n';
                errorString += exc.getMessage()+'\n';
                errors.put(rollUp, errorString);
            }

        }
        return errors;
    }
    
    public static String getParentQuery(P7S1_Rollup__c objRollup){
        return 'SELECT ID, ' + objRollup.ParentResultField__c + ' FROM ' + objRollup.ParentObject__c;
    }

    public static void sendErrorMail(String errorString)
    {
        String opening = '';
        opening += 'Hallo,\n';
        opening += '\n';
        opening += 'für folgende RollUp-Datensätze ist die Vaidierung fehlgeschlagen:\n';
        opening += '\n';        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setPlainTextBody(opening+errorString);
        mail.setToAddresses(cls_P7S1_Utils.getEmailRecipientsByName('P7S1 RollUpValidator'));
        Messaging.sendEmail(new List<Messaging.Email> {mail});
    }
    
}