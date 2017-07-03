<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Benachrichtigung_Portal_User_Liferay_Account_Deactivate</fullName>
        <description>Benachrichtigung Portal User Liferay Account Deaktivierung</description>
        <protected>false</protected>
        <recipients>
            <field>P7S1_EMail__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>mysevenone@sevenonemedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>P7S1/P7S1_LiferayUserDeactivated</template>
    </alerts>
    <alerts>
        <fullName>Benachrichtigung_Portal_User_Liferay_Account_DeactivateINTERN</fullName>
        <ccEmails>mysevenone@sevenonemedia.de</ccEmails>
        <description>Benachrichtigung Portal User Liferay Account Deaktivierung INTERN</description>
        <protected>false</protected>
        <senderAddress>mysevenone@sevenonemedia.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>P7S1/P7S1_LiferayUserDeactivated</template>
    </alerts>
    <alerts>
        <fullName>P7S1_Benachrichtigung_Portal_User_nderung</fullName>
        <ccEmails>tobias.forstmeier@p7s1applications.de</ccEmails>
        <ccEmails>service@sevenone-adfactory.de</ccEmails>
        <description>Benachrichtigung Portal User Änderung (AdF)</description>
        <protected>false</protected>
        <senderAddress>service@sevenone-adfactory.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Som/P7S1_Benachrichtigung_AdFactory_Portal_gesperrter_User</template>
    </alerts>
    <fieldUpdates>
        <fullName>P7S1_AdF_User_nderung_am</fullName>
        <field>P7S1_LetzteAenderungKunde__c</field>
        <formula>TODAY()</formula>
        <name>AdF User Änderung am</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_SperrePortalLogin</fullName>
        <field>P7S1_Portal_Status__c</field>
        <literalValue>Gesperrt</literalValue>
        <name>Sperre Portal Login</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AdF Benachrichtigung User Änderung</fullName>
        <actions>
            <name>P7S1_AdF_User_nderung_am</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND (  ISPICKVAL($User.P7S1_UserType__c, &apos;System_Interface&apos;) ,  ISPICKVAL( P7S1_Portal__c , &apos;sevenone-adfactory.de&apos;) , OR (  ISCHANGED( P7S1_Anrede__c ) ,  ISCHANGED( P7S1_Bereich__c ) ,  ISCHANGED( P7S1_EMail__c ) ,   ISCHANGED( P7S1_Fax__c ) ,  ISCHANGED( P7S1_Funktion__c ) ,  ISCHANGED( P7S1_Geburtstag__c ) ,  ISCHANGED( P7S1_Hausnummer__c ) ,  ISCHANGED( P7S1_Land__c ) ,  ISCHANGED( P7S1_Ort__c ) ,  ISCHANGED( P7S1_Postleitzahl__c ) ,  ISCHANGED( P7S1_Strasse__c ) ,  ISCHANGED( P7S1_Telefon__c ) ,  ISCHANGED( P7S1_Titel__c  ) ,  ISCHANGED( P7S1_Unternehmensart__c  ) ,  ISCHANGED( P7S1_Vorname__c  ) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Liferay Benachrichtigung User Änderung</fullName>
        <actions>
            <name>P7S1_Benachrichtigung_Portal_User_nderung</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Benachrichtigt den Liferay User das sein Profil deaktiviert wurde</description>
        <formula>AND (  ISPICKVAL($User.P7S1_UserType__c, &apos;System_Interface&apos;) ,  NOT(ISPICKVAL( P7S1_Portal__c , &apos;sevenone-adfactory.de&apos;)) , OR (  ISCHANGED( P7S1_Anrede__c ) ,  ISCHANGED( P7S1_Bereich__c ) ,  ISCHANGED( P7S1_EMail__c ) ,   ISCHANGED( P7S1_Fax__c ) ,  ISCHANGED( P7S1_Funktion__c ) ,  ISCHANGED( P7S1_Geburtstag__c ) ,  ISCHANGED( P7S1_Hausnummer__c ) ,  ISCHANGED( P7S1_Land__c ) ,  ISCHANGED( P7S1_Ort__c ) ,  ISCHANGED( P7S1_Postleitzahl__c ) ,  ISCHANGED( P7S1_Strasse__c ) ,  ISCHANGED( P7S1_Telefon__c ) ,  ISCHANGED( P7S1_Titel__c  ) ,  ISCHANGED( P7S1_Unternehmensart__c  ) ,  ISCHANGED( P7S1_Vorname__c  ) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sperre Login wegen Datenänderung</fullName>
        <actions>
            <name>P7S1_Benachrichtigung_Portal_User_nderung</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>P7S1_SperrePortalLogin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND ( ISPICKVAL( P7S1_Portal__c , &apos;sevenone-adfactory.de&apos;) , OR ( ISCHANGED( P7S1_Nachname__c ) , ISCHANGED( P7S1_Firma__c ) , ISCHANGED( P7S1_EMail__c )  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sperre Login wegen Datenänderung Liferay</fullName>
        <actions>
            <name>Benachrichtigung_Portal_User_Liferay_Account_Deactivate</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Benachrichtigung_Portal_User_Liferay_Account_DeactivateINTERN</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>P7S1_SperrePortalLogin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND (  ISPICKVAL($User.P7S1_UserType__c, &apos;System_Interface&apos;) , NOT(ISPICKVAL( P7S1_Portal__c , &apos;sevenone-adfactory.de&apos;)) , OR ( ISCHANGED( P7S1_Nachname__c ) , ISCHANGED( P7S1_Firma__c ) , ISCHANGED( P7S1_EMail__c )  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
