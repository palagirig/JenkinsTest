<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Lcm_TestSphere</fullName>
        <description>Füllt Test-Sphäre aus Test-Modul.</description>
        <field>Lcm_TestSphere__c</field>
        <formula>Text ( Lcm_TestCase__r.Lcm_Requirement__r.Lcm_Version__r.Lcm_Module__r.Lcm_TestSphere__c )</formula>
        <name>Lcm_TestSphere</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Lcm_TestSphere</fullName>
        <actions>
            <name>Lcm_TestSphere</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Füllt Lcm_TestSphere, als Basis für Freigaberegel.</description>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
