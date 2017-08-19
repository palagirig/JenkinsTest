<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SomDig_SetActiveCity</fullName>
        <description>KV 02906. Setzt beim erstellen &quot;Active&quot; auf true.</description>
        <field>ADvendio__Active__c</field>
        <literalValue>1</literalValue>
        <name>SomDig_SetActiveCity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SomDig_SetActiveCity</fullName>
        <actions>
            <name>SomDig_SetActiveCity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>KV 02906. Setzt beim erstellen &quot;Active&quot; auf true.</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
