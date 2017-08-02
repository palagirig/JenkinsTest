<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>P7S1_NielsenDatenName</fullName>
        <description>Account_Jahr_Zeitraum</description>
        <field>Name</field>
        <formula>LEFT(P7S1_Account__r.Name ,71) &amp;&quot;_&quot;&amp; P7S1_Year__c  &amp;&quot;_&quot;&amp;  TEXT(P7S1_ZeitraumTyp__c)</formula>
        <name>Nielsen Daten Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Nielsen Daten Name</fullName>
        <actions>
            <name>P7S1_NielsenDatenName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.P7S1_AccountId18__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Account_Jahr_Zeitraum</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
