<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>P7S1_WillkommensEmail</fullName>
        <ccEmails>salesforce-support@p7s1.onmicrosoft.com</ccEmails>
        <description>Willkommens E-Mail</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>salesforce-support@p7s1.onmicrosoft.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/P7S1_Willkommens_E_Mail_neuer_Benutzer</template>
    </alerts>
    <rules>
        <fullName>P7S1_WillkommensEmail</fullName>
        <actions>
            <name>P7S1_WillkommensEmail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.LastLoginDate</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Willkommens E-Mail an den Benutzer, wenn der Benutzer-Datensatz angelegt  wurde.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
