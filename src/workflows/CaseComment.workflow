<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>P7S1_Status_Neuer_Kommentar</fullName>
        <field>Status</field>
        <literalValue>Neuer Kommentar</literalValue>
        <name>Status Neuer Kommentar</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_UpdateLastCaseCommentonCase</fullName>
        <field>P7S1_LastCaseComment__c</field>
        <formula>CommentBody</formula>
        <name>Update Last Case Comment on Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Copy Case Comment 2 Case</fullName>
        <actions>
            <name>P7S1_UpdateLastCaseCommentonCase</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy the latest case comment to a field on case object to send an email notification</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P7S1 Status Neuer Kommentar</fullName>
        <actions>
            <name>P7S1_Status_Neuer_Kommentar</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Setze den Status eines Kundenvorgangs auf &quot;Neuer Kommentar&quot; wenn ein anderer Benutzer als der aktuelle Inhaber einen Kommentar verfasst.</description>
        <formula>AND (
 Parent.OwnerId &lt;&gt;  CreatedById ,
 Parent.IsClosed &lt;&gt; TRUE
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
