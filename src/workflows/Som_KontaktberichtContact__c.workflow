<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Som_Unique</fullName>
        <field>Som_Unique__c</field>
        <formula>Som_Kontaktbericht__c &amp; &quot;_&quot; &amp; Som_Contact__c</formula>
        <name>Som_Unique</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Som_Unique</fullName>
        <actions>
            <name>Som_Unique</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
