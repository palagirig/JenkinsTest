<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Ven_Contract_Reminder_Email</fullName>
        <description>Ven Contract Reminder Email</description>
        <protected>false</protected>
        <recipients>
            <field>Ven_AccountOwner7V__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>Ven Deal Analyst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Ven Deal Owner</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Ven Industry Expert</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Ven Media Expert</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Ven Source</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_ContractReminder</template>
    </alerts>
    <alerts>
        <fullName>Ven_ReminderContract_End</fullName>
        <description>Reminder Contract End</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>Ven Deal Analyst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Ven Deal Owner</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Ven Industry Expert</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Ven Media Expert</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Ven Source</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_ContractReminder</template>
    </alerts>
    <fieldUpdates>
        <fullName>Ven_AccountOwnerEmailUpdate</fullName>
        <description>Update Account Owner Email</description>
        <field>Ven_AccountOwner7V__c</field>
        <formula>IF ( ISPICKVAL ( Ven_Opportunity__r.Account.Owner.P7S1_Sphere__c , &apos;Ven&apos; ) , Ven_Opportunity__r.Account.Owner.Email , null)</formula>
        <name>AccountOwnerEmailUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Ven_VertragEmail</fullName>
        <actions>
            <name>Ven_AccountOwnerEmailUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Überträgt die E-Mail des Account Inhabers falls dieser bei 7V arbeitet</description>
        <formula>NOT( ISBLANK( Ven_Opportunity__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Ven_VertragErstellt</fullName>
        <actions>
            <name>Ven_Vertragsende</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(Ven_Deadline__c))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Ven_Vertragsreminder</fullName>
        <actions>
            <name>Ven_Vertragsende</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>Ven_Reminder__c &gt; TODAY()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Ven_Contract_Reminder_Email</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Ven_Vertrag_SevenVentures__c.Ven_Reminder__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Ven_Vertragsende</fullName>
        <assignedToType>owner</assignedToType>
        <description>This contract is about to expire!
 Please contact your client immediately.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Ven_Vertrag_SevenVentures__c.Ven_Reminder__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Reminder Contract Ending</subject>
    </tasks>
</Workflow>
