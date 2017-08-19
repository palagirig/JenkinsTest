@isTest
public class P7S1_Account_AutoAprvBatch_Test{

    @TestSetup
    static void test_Setup(){
        List<User> listUsers = new List<User>();
        User Sales_User = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomTv_Sales');
        Sales_User.isActive = true;
        listUsers.add(Sales_User);
        update listUsers;
     }
    
    @isTest
    public static void accountAutoAprvPast(){

        Account objAccount = cls_P7S1_TestData.createTestAccount(true);
        
        // Submit the Account for Approval
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();      
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(objAccount.id);
        req1.setSubmitterId(cls_P7S1_TestData.USER_MAP_PROFILE.get('SomTv_Sales'));
        req1.setProcessDefinitionNameOrId('Som_AccountUngueltigSetzen');
        req1.setSkipEntryCriteria(true);    
        
        Approval.ProcessSubmitRequest[] requestList = new List<Approval.ProcessSubmitRequest>();
        requestlist.add(req1);
        List<Approval.ProcessResult> result = Approval.process(requestList);

        objAccount.P7S1_AutomaticalApproval__c = Datetime.now().addDays(-30);
        update objAccount;

        Test.startTest();
        
        // Start the scheduler, which starts the batch  
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        
        String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new P7S1_Account_AutoAprv());
        
        database.executebatch(new P7S1_Account_AutoAprvBatch(), 20);
                
        Test.stopTest();

        List<ProcessInstance> pendingProcessinstanceList = new List<ProcessInstance>([select id, targetobjectid, (Select id from WorkItems) from ProcessInstance WHERE targetObjectId = :objAccount.Id AND Status = 'Pending']);
        System.assertEquals(0, pendingProcessinstanceList.size());
        
        List<ProcessInstance> approvedProcessinstanceList = new List<ProcessInstance>([select id, targetobjectid, (Select id from WorkItems) from ProcessInstance WHERE targetObjectId = :objAccount.Id AND Status = 'Approved']);
        System.assertEquals(1, approvedProcessinstanceList.size());
        
        for(ProcessInstance pi : approvedProcessinstanceList) {
            System.assert(pi.WorkItems.isEmpty());
        }
        
    }

    @isTest
    public static void accountAutoAprvFuture(){
        
         Account objAccount = cls_P7S1_TestData.createTestAccount(true);
        
        // Submit the Account for Approval
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();      
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(objAccount.id);
        req1.setSubmitterId(cls_P7S1_TestData.USER_MAP_PROFILE.get('SomTv_Sales'));
        req1.setProcessDefinitionNameOrId('Som_AccountUngueltigSetzen');
        req1.setSkipEntryCriteria(true);    
        
        Approval.ProcessSubmitRequest[] requestList = new List<Approval.ProcessSubmitRequest>();
        requestlist.add(req1);
        List<Approval.ProcessResult> result = Approval.process(requestList);

        Test.startTest();
        
        // Start the scheduler, which starts the batch  
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        
        String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new P7S1_Account_AutoAprv());
        
        database.executebatch(new P7S1_Account_AutoAprvBatch(), 20);
                
        Test.stopTest();

        List<ProcessInstance> pendingProcessinstanceList = new List<ProcessInstance>([select id, targetobjectid, (Select id from WorkItems) from ProcessInstance WHERE targetObjectId = :objAccount.Id AND Status = 'Pending']);
        System.assertEquals(1, pendingProcessinstanceList.size());

        for(ProcessInstance pi : pendingProcessinstanceList) {
            System.assert(!pi.WorkItems.isEmpty());
        }      

        List<ProcessInstance> approvedProcessinstanceList = new List<ProcessInstance>([select id, targetobjectid, (Select id from WorkItems) from ProcessInstance WHERE targetObjectId = :objAccount.Id AND Status = 'Approved']);
        System.assertEquals(0, approvedProcessinstanceList.size());
  
    }


}