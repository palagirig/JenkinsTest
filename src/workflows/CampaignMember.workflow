<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>P7S1_InviteConfirmationEmail</fullName>
        <ccEmails>event@sevenonemedia.de</ccEmails>
        <description>P7S1_InviteConfirmationEmail</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>event@sevenonemedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>P7S1/P7S1_SendInviteConfirmationEmail</template>
    </alerts>
    <alerts>
        <fullName>P7S1_InviteRefusalEmail</fullName>
        <ccEmails>event@sevenonemedia.de</ccEmails>
        <description>P7S1_InviteRefusalEmail</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>event@sevenonemedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>P7S1/P7S1_SendInviteRefusalEmail</template>
    </alerts>
    <rules>
        <fullName>P7S1_SendInviteConfirmationEmail</fullName>
        <actions>
            <name>P7S1_InviteConfirmationEmail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CampaignMember.Status</field>
            <operation>equals</operation>
            <value>Zusage</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.P7S1_B2B_Aktion_ID__c</field>
            <operation>equals</operation>
            <value>70157000001Ecap,70157000001Ecak,70157000001Ecaf,70157000001Ecaz</value>
        </criteriaItems>
        <description>FRÜHJAHRS-SCREENING 2016</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_SendInviteRefusalEmail</fullName>
        <actions>
            <name>P7S1_InviteRefusalEmail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CampaignMember.Status</field>
            <operation>equals</operation>
            <value>Absage</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.P7S1_B2B_Aktion_ID__c</field>
            <operation>equals</operation>
            <value>70157000001Ecap,70157000001Ecak,70157000001Ecaf,70157000001Ecaz</value>
        </criteriaItems>
        <description>FRÜHJAHRS-SCREENING 2016</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
