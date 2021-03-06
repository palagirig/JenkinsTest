<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SomDig_SapDateiUpload</fullName>
        <ccEmails>Petra.Bieringer@P7S1Applications.de</ccEmails>
        <ccEmails>Sabine.Kast@Prosieben.de</ccEmails>
        <ccEmails>Manuela.Heimes@prosieben.de</ccEmails>
        <ccEmails>Julia.Peryshkina@prosiebensat1.com</ccEmails>
        <ccEmails>salesforce-logs@p7s1.onmicrosoft.com</ccEmails>
        <description>SomDig_SapDateiUploadUebermittelt</description>
        <protected>false</protected>
        <recipients>
            <recipient>christian.joentgen@sevenonemedia.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>corinna.sismanis@prosiebensat1.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>dilek.duyar@sevenonemedia.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>dominik.pohl@sevenonemedia.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>elke.eibel@sevenonemedia.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>natascha.fischer@prosiebensat1.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>p7s1.thomaspuhl@gmx.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>regina.schebesch@prosiebensat1.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>roman.walek@sevenonemedia.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>thomas.waber@prosiebensat1.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SomDig_SapDateiUploadUebermittelt</template>
    </alerts>
    <alerts>
        <fullName>SomDig_SapDateiUploadFehler</fullName>
        <description>SomDig_SapDateiUploadFehler</description>
        <protected>false</protected>
        <recipients>
            <recipient>P7S1_Admins</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>p7s1.thomaspuhl@gmx.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SomDig_SapDateiUploadFehler</template>
    </alerts>
    <fieldUpdates>
        <fullName>SomDig_SapDateiUploadUebermittlung</fullName>
        <field>SomDig_Status__c</field>
        <literalValue>Fehler</literalValue>
        <name>SomDig_SapDateiUploadUebermittlung</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Somdig_Fakturasperre_setzen</fullName>
        <field>SomDig_Fakturasperre__c</field>
        <literalValue>1</literalValue>
        <name>Fakturasperre setzen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SomDig_SapDateiUploadFehler</fullName>
        <actions>
            <name>SomDig_SapDateiUploadFehler</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(SomDig_Status__c) &amp;&amp; ISPICKVAL(SomDig_Status__c, &quot;Fehler&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_SapDateiUploadUebermittelt</fullName>
        <actions>
            <name>SomDig_SapDateiUpload</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(SomDig_Status__c) &amp;&amp; ISPICKVAL(SomDig_Status__c, &quot;übermittelt&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_SapDateiUploadUebermittlung</fullName>
        <active>true</active>
        <formula>TEXT(SomDig_Status__c) == &quot;Übermittlung&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SomDig_SapDateiUploadUebermittlung</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Somdig_Fakturasperre_setzen</fullName>
        <actions>
            <name>Somdig_Fakturasperre_setzen</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SomDig_SapDatei__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Hochrechnung</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
