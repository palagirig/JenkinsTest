<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Media_Broadcast_control_Import_Date_Uniq</fullName>
        <description>Set value to maintain Uniqueness</description>
        <field>Import_Date_Unique__c</field>
        <formula>Text(MT_ImportDate__c)</formula>
        <name>Media Broadcast control Import Date Uniq</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
</Workflow>
