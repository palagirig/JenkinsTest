<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SomDig_IaNummerUnique</fullName>
        <description>füllt Unique Feld</description>
        <field>SomDig_Unique__c</field>
        <formula>SomDig_Mediagattung__c &amp; &quot;_&quot; &amp; SomDig_MediagattungsDifferenzierung__c &amp; &quot;_&quot; &amp; 
SomDig_MediagattungsSegment__c &amp; &quot;_&quot; &amp; 
SomDig_Werbetraergergruppierung__c &amp; &quot;_&quot; &amp; 
SomDig_CSPartnerID__c</formula>
        <name>SomDig_IaNummerUnique</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SomDig_IaNummerUnique</fullName>
        <actions>
            <name>SomDig_IaNummerUnique</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>füllt Unique Feld</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
