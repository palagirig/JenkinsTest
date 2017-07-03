<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>P7S1_AccountAccess_AccountUebernahmeApprovedAccountOwner</fullName>
        <description>AccountAccess Account-Übernahme Approved an Account Owner</description>
        <protected>false</protected>
        <recipients>
            <field>P7S1_AccountOwner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Excellence_Emails/P7S1_AccountAccessAccountUebernahmeApprovedAccountOwner</template>
    </alerts>
    <alerts>
        <fullName>P7S1_AccountAccess_AccountUebernahmeApprovedAccountTeam</fullName>
        <description>AccountAccess Account-Übernahme Approved an Account Team</description>
        <protected>false</protected>
        <recipients>
            <field>Som_DigitalSales__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Som_Einkaufsagenturverkaeufer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Som_Planungsagenturverkaeufer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Som_TVKundenverkaeufer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Excellence_Emails/P7S1_AccountAccessAccountUebernahmeApprovedAccountTeam</template>
    </alerts>
    <alerts>
        <fullName>P7S1_AccountAccess_AccountUebernahmeApprovedAntragsteller</fullName>
        <description>AccountAccess Account-Übernahme Approved an Antragsteller</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Excellence_Emails/P7S1_AccountAccessAccountUebernahmeApprovedAntragsteller</template>
    </alerts>
    <alerts>
        <fullName>P7S1_AccountAccess_AccountUebernahmeRejectedAccountOwner</fullName>
        <description>AccountAccess Account-Übernahme Rejected an Account Owner</description>
        <protected>false</protected>
        <recipients>
            <field>P7S1_AccountOwner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Excellence_Emails/P7S1_AccountAccessAccountUebernahmeRejectedAccountOwner</template>
    </alerts>
    <alerts>
        <fullName>P7S1_AccountAccess_AccountUebernahmeRejectedAccountTeam</fullName>
        <description>AccountAccess Account-Übernahme Rejected an Account Team</description>
        <protected>false</protected>
        <recipients>
            <field>Som_DigitalSales__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Som_Einkaufsagenturverkaeufer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Som_Planungsagenturverkaeufer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Som_TVKundenverkaeufer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Excellence_Emails/P7S1_AccountAccessAccountUebernahmeRejectedAccountTeam</template>
    </alerts>
    <alerts>
        <fullName>P7S1_AccountAccess_AccountUebernahmeRejectedAntragsteller</fullName>
        <description>AccountAccess Account-Übernahme Rejected an Antragsteller</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Excellence_Emails/P7S1_AccountAccessAccountUebernahmeRejectedAntragsteller</template>
    </alerts>
    <alerts>
        <fullName>P7S1_AccountAccess_LogoIntegrationAufnahmeAccountTeamApprovedAccountTeam</fullName>
        <description>AccountAccess Logo Integration Aufnahme Account Team Approved an Account Team</description>
        <protected>false</protected>
        <recipients>
            <field>P7S1_AccountOwner__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Som_DigitalSales__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Som_Einkaufsagenturverkaeufer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Som_Planungsagenturverkaeufer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Som_TVKundenverkaeufer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Excellence_Emails/P7S1_AccountAccessLogoIntegrationAufnahmeAccountTeamApprovedAccountTeam</template>
    </alerts>
    <alerts>
        <fullName>P7S1_AccountAccess_LogoIntegrationAufnahmeAccountTeamApprovedAntragsteller</fullName>
        <description>AccountAccess Logo Integration Aufnahme Account Team Approved an Antragsteller</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Excellence_Emails/P7S1_AccountAccessLogoIntegrationAufnahmeAccountTeamApprovedAntragsteller</template>
    </alerts>
    <alerts>
        <fullName>P7S1_AccountAccess_LogoIntegrationAufnahmeAccountTeamRejectedAccountTeam</fullName>
        <description>AccountAccess Logo Integration Aufnahme Account Team Rejected an Account Team</description>
        <protected>false</protected>
        <recipients>
            <field>P7S1_AccountOwner__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Som_DigitalSales__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Som_Einkaufsagenturverkaeufer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Som_Planungsagenturverkaeufer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Som_TVKundenverkaeufer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Excellence_Emails/P7S1_AccountAccessLogoIntegrationAufnahmeAccountTeamRejectedAccountTeam</template>
    </alerts>
    <alerts>
        <fullName>P7S1_AccountAccess_LogoIntegrationAufnahmeAccountTeamRejectedAntragsteller</fullName>
        <description>AccountAccess Logo Integration Aufnahme Account Team Rejected an Antragsteller</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Excellence_Emails/P7S1_AccountAccessLogoIntegrationAufnahmeAccountTeamRejectedAntragsteller</template>
    </alerts>
    <alerts>
        <fullName>P7S1_AutomaticAccessApprovalRequestDigitalSales</fullName>
        <ccEmails>jmiksch@factory42.com</ccEmails>
        <description>AutomaticAccess Approval Request Digital Sales</description>
        <protected>false</protected>
        <recipients>
            <field>P7S1_AccountOwner__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Som_DigitalSales__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Som_Einkaufsagenturverkaeufer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Som_Planungsagenturverkaeufer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Som_TVKundenverkaeufer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Excellence_Emails/P7S1_AutomaticAccessApprovalRequestDigitalSales</template>
    </alerts>
    <fieldUpdates>
        <fullName>P7S1_Abgelehnt</fullName>
        <field>P7S1_ApprovalState__c</field>
        <literalValue>Abgelehnt</literalValue>
        <name>Abgelehnt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_Eingereicht</fullName>
        <field>P7S1_ApprovalState__c</field>
        <literalValue>Eingereicht</literalValue>
        <name>Eingereicht</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_Genehmigt</fullName>
        <field>P7S1_ApprovalState__c</field>
        <literalValue>Genehmigt</literalValue>
        <name>Genehmigt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_RenameAccountFreigabe</fullName>
        <field>Name</field>
        <formula>IF(
 ISBLANK( P7S1_AccountIndex__r.Name ),
 P7S1_Account__r.Name  &amp; &quot; - &quot; &amp; RecordType.Name &amp; &quot; - &quot; &amp; Owner:User.P7S1_Unit__c &amp; &quot; - &quot; &amp; TEXT( YEAR( DATEVALUE( CreatedDate ))),
 P7S1_AccountIndex__r.Name &amp; &quot; - &quot; &amp; RecordType.Name &amp; &quot; - &quot; &amp; Owner:User.P7S1_Unit__c &amp; &quot; - &quot; &amp; TEXT( YEAR( DATEVALUE( CreatedDate )))
)</formula>
        <name>Rename Account Freigabe</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_Zurueckgezogen</fullName>
        <field>P7S1_ApprovalState__c</field>
        <name>Zurückgezogen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>P7S1_RenameAccountFreigabe</fullName>
        <actions>
            <name>P7S1_RenameAccountFreigabe</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Setze Wiedervorlage</fullName>
        <actions>
            <name>Account_Freigabe_pruefen</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Wiedervorlage für Inhaber</description>
        <formula>AND (
 NOT ( ISBLANK ( P7S1_Wiedervorlage__c ) ) ,
 P7S1_AccountOwner__c =  $User.Id 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Account_Freigabe_pruefen</fullName>
        <assignedToType>owner</assignedToType>
        <description>Die Account Freigabe liegt auf Wiedervorlage.
Bitte prüfen.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>P7S1_AccountAccess__c.P7S1_Wiedervorlage__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Account Freigabe prüfen</subject>
    </tasks>
</Workflow>