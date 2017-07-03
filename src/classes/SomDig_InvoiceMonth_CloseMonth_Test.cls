@isTest
public class SomDig_InvoiceMonth_CloseMonth_Test {


    @TestSetup
    static void test_Setup(){
        List<User> listUsers = new List<User>();
        User PAM_User = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_AdTech');
        User Sales_User = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_Billing');
        PAM_User.isActive = true;
        listUsers.add(PAM_User);
        Sales_User.isActive = true;
        listUsers.add(Sales_User);
        update listUsers;
     }

    @isTest
    private static void testForBillingProfile() {
        SomDig_InvoiceMonth__c invoiceMonth = new SomDig_InvoiceMonth__c(SomDig_Month__c = 5, SomDig_Year__c = 2016, SomDig_To__c = Date.today().addMonths(1), SomDig_IsCurrentMonth__c = true);
        insert invoiceMonth;

        SomDig_InvoiceMonth__c invoiceMonth2 = new SomDig_InvoiceMonth__c(SomDig_Month__c = 6, SomDig_Year__c = 2016, SomDig_To__c = Date.today().addMonths(2), SomDig_IsCurrentMonth__c = false);
        insert invoiceMonth2;

        User adTechUser = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_AdTech'); 

        Test.startTest();

        System.runAs(adTechUser) {
            String exceptionString;
            try {
                SomDig_InvoiceMonth_CloseMonth.closeMonthValidation(invoiceMonth.Id);
            } catch(Exception e) {
                exceptionString = e.getMessage();

            }
            System.assert(exceptionString.contains(Label.SomDig_InvoiceMonth_CloseMonth_NotBillingUser));

        }

        Test.stopTest();

    }

    @isTest
    private static void testForCurrentMonth() {
        SomDig_InvoiceMonth__c invoiceMonth = new SomDig_InvoiceMonth__c(SomDig_Month__c = 5, SomDig_Year__c = 2016, SomDig_To__c = Date.today().addMonths(1), SomDig_IsCurrentMonth__c = true);
        insert invoiceMonth;

        SomDig_InvoiceMonth__c invoiceMonth2 = new SomDig_InvoiceMonth__c(SomDig_Month__c = 6, SomDig_Year__c = 2016, SomDig_To__c = Date.today().addMonths(2), SomDig_IsCurrentMonth__c = false);
        insert invoiceMonth2;

        User billingUser = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_Billing');

        Test.startTest();

        System.runAs(billingUser) {
            String exceptionString;
            try {
                SomDig_InvoiceMonth_CloseMonth.closeMonthValidation(invoiceMonth2.Id);
            } catch(Exception e) {
                exceptionString = e.getMessage();

            }
            System.assert(exceptionString.contains(Label.SomDig_InvoiceMonth_CloseMonth_NotCurrentInvoiceMonth));

        }

        Test.stopTest();

    }


    @isTest
    private static void testForPositive() {

        SomDig_InvoiceMonth__c currentInvoiceMonth = new SomDig_InvoiceMonth__c(SomDig_Month__c = 5, SomDig_Year__c = 2016, SomDig_To__c = Date.today().addMonths(1), SomDig_IsCurrentMonth__c = true);
        insert currentInvoiceMonth;

        SomDig_InvoiceMonth__c notCurrentInvoiceMonth = new SomDig_InvoiceMonth__c(SomDig_Month__c = 6, SomDig_Year__c = 2016, SomDig_To__c = Date.today().addMonths(2), SomDig_IsCurrentMonth__c = false);
        insert notCurrentInvoiceMonth;

        User billingUser = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_Billing');

        Test.startTest();

        System.runAs(billingUser) {
            String exceptionString = '';
            try {
                SomDig_InvoiceMonth_CloseMonth.closeMonthValidation(currentInvoiceMonth.Id);
            } catch(Exception e) {
                exceptionString = e.getMessage();
            }
            System.assert(String.isBlank(exceptionString));

            SomDig_InvoiceMonth_CloseMonth.closeMonth(currentInvoiceMonth.Id);

        }

        Test.stopTest();

        SomDig_InvoiceMonth__c checkClosedMonth = [SELECT SomDig_IsCurrentMonth__c, SomDig_ClosureDateTime__c FROM SomDig_InvoiceMonth__c WHERE Id = :currentInvoiceMonth.Id];
        System.assertEquals(false, checkClosedMonth.SomDig_IsCurrentMonth__c);
        System.assert(checkClosedMonth.SomDig_ClosureDateTime__c != null);

        SomDig_InvoiceMonth__c checkNextMonth = [SELECT SomDig_IsCurrentMonth__c FROM SomDig_InvoiceMonth__c WHERE Id = :notCurrentInvoiceMonth.Id];
        System.assert(checkNextMonth.SomDig_IsCurrentMonth__c);


    }

    @isTest
    private static void testForNoNextMonth() {

        SomDig_InvoiceMonth__c currentInvoiceMonth = new SomDig_InvoiceMonth__c(SomDig_Month__c = 5, SomDig_Year__c = 2016, SomDig_To__c = Date.today().addMonths(1), SomDig_IsCurrentMonth__c = true);
        insert currentInvoiceMonth;

        User billingUser = cls_P7S1_TestData.USER_FOR_PROFILE.get('SomDig_Billing');

        Test.startTest();

        System.runAs(billingUser) {
            String exceptionString;
            try {
                SomDig_InvoiceMonth_CloseMonth.closeMonthValidation(currentInvoiceMonth.Id);
            } catch(Exception e) {
                exceptionString = e.getMessage();

            }
            System.assert(exceptionString.contains(Label.SomDig_InvoiceMonth_CloseMonth_NoNextMonth));

        }

        Test.stopTest();

    }

    @isTest
    private static void testGetNextInvoiceMonth() {

        SomDig_InvoiceMonth__c currentInvoiceMonth = new SomDig_InvoiceMonth__c(SomDig_Month__c = 12, SomDig_Year__c = 2016, SomDig_To__c = Date.today().addMonths(1), SomDig_IsCurrentMonth__c = true);
        insert currentInvoiceMonth;
        SomDig_InvoiceMonth__c notCurrentInvoiceMonth = new SomDig_InvoiceMonth__c(SomDig_Month__c = 1, SomDig_Year__c = 2017, SomDig_To__c = Date.today().addMonths(2), SomDig_IsCurrentMonth__c = false);
        insert notCurrentInvoiceMonth;

        Test.startTest();

        SomDig_InvoiceMonth_CloseMonth.getNextInvoiceMonth(currentInvoiceMonth.SomDig_Month__c, currentInvoiceMonth.SomDig_Year__c);

        Test.stopTest();

    }

}