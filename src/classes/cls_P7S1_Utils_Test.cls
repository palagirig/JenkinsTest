@isTest
public class cls_P7S1_Utils_Test {
	public static String STRING_TO_REPLACE_WITH_REPLACEMENT = 'TOZLU Tekstil San. Iç ve Dis Tic. Ltd. Sti. to TOZLU TEKSTİL SANAYİ VE TİCARET AŞ';    
    public static String EXPECTED_STRING_WITH_REPLACEMENT = 'TOZLU Tekstil San. Iç ve Dis Tic. Ltd. Sti. to TOZLU TEKST?L SANAY? VE T?CARET A?';
    public static String STRING_WITHOUT_REPLACEMENT = 'Pockit LmedSAGnrbHx360yuz.F&–Vw()52,/QÄüßJ8-4Ö­+79é!1:\'Óë"@àè[]|Í ’?„“®á`Içisôñ´_#*¿ãÏ\\=”©âúù°•ø';
    
    @isTest
    private static void isValidRegexc(){
        try {
            Pattern.compile(cls_P7S1_Utils.REGEX_DWH_NOT_ACCEPTED_CHARS);    
        } catch(Exception e){
        	system.assert(false,'Regex is invalid ' + e);        
        }
    }
    
    @isTest
    private static void replaceUnsupportedCharsForDwh(){
        system.assertEquals(EXPECTED_STRING_WITH_REPLACEMENT,cls_P7S1_Utils.replaceUnsupportedCharsForDwh(STRING_TO_REPLACE_WITH_REPLACEMENT));
    	system.assertEquals(STRING_WITHOUT_REPLACEMENT,cls_P7S1_Utils.replaceUnsupportedCharsForDwh(STRING_WITHOUT_REPLACEMENT));
    }
    
    @isTest
    private static void regexException() {
        cls_P7S1_Utils.REGEX_DWH_NOT_ACCEPTED_CHARS = '][][][][][][]][][';
        system.assert(cls_P7S1_Utils.replaceUnsupportedCharsForDwh(STRING_TO_REPLACE_WITH_REPLACEMENT).contains('Invalid regex'));
    }

    @isTest
    private static void testgetEmailRecipientsByName() {

        insert new P7S1_EmailRecipients__c(Name = 'test recipient', P7S1_Location__c = 'test class', P7S1_Recipients__c = 'max@mustermann.de;john@doe.com');

        Test.startTest();

        List<String> emailRecipientList = cls_P7S1_Utils.getEmailRecipientsByName('test recipient');

        Test.stopTest();

        Set<String> emailRecipientSet = new Set<String>();
        emailRecipientSet.addAll(emailRecipientList);

        System.assertEquals(emailRecipientList.size(), 2);
        System.assert(emailRecipientSet.contains('max@mustermann.de'));
        System.assert(emailRecipientSet.contains('john@doe.com'));

    }
    
    
}