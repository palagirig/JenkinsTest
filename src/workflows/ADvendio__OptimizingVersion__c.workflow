<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SetAvailabilityApproved_to_true</fullName>
        <field>Adv_AvailabilityApproved__c</field>
        <literalValue>1</literalValue>
        <name>SetAvailabilityApproved to true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetDeltaMN2Approved_to_true</fullName>
        <field>Adv_DeltaMN2Approved__c</field>
        <literalValue>1</literalValue>
        <name>SetDeltaMN2Approved to true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_SetOptimizingVersionNumber</fullName>
        <description>KV 02462. Schreibt die Versionsnummer ins Kommentar der Optimierung</description>
        <field>ADvendio__Comment__c</field>
        <formula>SomDig_Versionsnummer__c</formula>
        <name>SomDig_SetOptimizingVersionNumber</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SomDig_SetOptimizingVersionNumber</fullName>
        <actions>
            <name>SomDig_SetOptimizingVersionNumber</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>KV 02462. Schreibt die Versionsnummer ins Kommentar der Optimierung</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
