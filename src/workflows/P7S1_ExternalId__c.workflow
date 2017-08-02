<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Fill_Ext_ID_Number</fullName>
        <description>Wenn der Name eine Nummer ist, wird hier die Nummer noch einmal als Nummer eingetragen.
Wird von RollUp auf Account genutzt.</description>
        <field>ExtIdProSedi__c</field>
        <formula>IF( ISNUMBER(Name) ,  VALUE(Name) , 0)</formula>
        <name>Fill Ext ID Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_Debitorennr</fullName>
        <description>Debitorennummer mit 10 Stellen füllen</description>
        <field>Name</field>
        <formula>IF ( LEN (Name) &lt; 10,
LPAD ( Name, 10, &apos;0&apos; ),
Name)</formula>
        <name>P7S1_Debitorennr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_ExtIdUniqueKey</fullName>
        <description>Verketten von DWHSource + ExterneID.Name</description>
        <field>P7S1_ExtIdUniqueKey__c</field>
        <formula>TEXT(Som_DwhSource__c) &amp; Name</formula>
        <name>P7S1_ExtIdUniqueKey</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>P7S1_Debitorennr</fullName>
        <actions>
            <name>P7S1_Debitorennr</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>P7S1_ExternalId__c.P7S1_Source__c</field>
            <operation>startsWith</operation>
            <value>Debitoren</value>
        </criteriaItems>
        <description>Debitorennummer mit 10 Stellen füllen</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_ExtIdUniqueKey</fullName>
        <actions>
            <name>Fill_Ext_ID_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>P7S1_ExtIdUniqueKey</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Generierung P7S1_ExtIdUniqueKey__c aus DWH_Source &amp; ExterneID.Name</description>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
