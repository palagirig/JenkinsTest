<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>P7S1_StatusNeueEMail</fullName>
        <field>Status</field>
        <literalValue>Neuer Kommentar</literalValue>
        <name>Status Neue E-Mail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>P7S1 Status Neue E-Mail</fullName>
        <actions>
            <name>P7S1_StatusNeueEMail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Parent.Owner:User.Email &lt;&gt;  FromAddress</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
