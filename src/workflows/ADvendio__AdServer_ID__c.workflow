<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SomDig_SetActiveAdServerID</fullName>
        <field>ADvendio__Active__c</field>
        <literalValue>1</literalValue>
        <name>SomDig_SetActiveAdServerID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SomDig_SetActiveAdServerID</fullName>
        <actions>
            <name>SomDig_SetActiveAdServerID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>KV 02906. Setzt beim erstellen &quot;Active&quot; auf true.</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
