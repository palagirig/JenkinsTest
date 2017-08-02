<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>P7S1_Bestaetigtam</fullName>
        <field>P7S1_BestaetigtAm__c</field>
        <formula>NOW()</formula>
        <name>Bestätigt am</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Bestätigt am</fullName>
        <actions>
            <name>P7S1_Bestaetigtam</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(P7S1_CheckSalesforceZugang__c)
&amp;&amp;
NOT ( ISBLANK ( TEXT (P7S1_CheckSalesforceZugang__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
