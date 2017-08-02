<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Letzter_Besuchsbericht_Account</fullName>
        <field>Som_Datum__c</field>
        <formula>Som_Kontaktbericht__r.Som_Datum__c</formula>
        <name>Letzter Besuchsbericht Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Som_AccountKontaktbericht</fullName>
        <actions>
            <name>Letzter_Besuchsbericht_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Letzter Kontaktbericht am Account</description>
        <formula>AND(Som_Account__r.P7S1_SphereCopy__c = &quot;SomDe&quot;,  Som_Account__r.ungueltiger_Account__c &lt;&gt; TRUE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
