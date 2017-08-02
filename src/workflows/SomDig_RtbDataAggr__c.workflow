<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SomDig_Unique</fullName>
        <field>SomDig_UniqueKey__c</field>
        <formula>SomDig_Advertiser__c &amp; &quot;_&quot; &amp;  SomDig_DemandPartner__c &amp; &quot;_&quot; &amp;  SomDig_Year__c &amp;  SomDig_Month__c</formula>
        <name>SomDig_Unique</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SomDig_Unique</fullName>
        <actions>
            <name>SomDig_Unique</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
