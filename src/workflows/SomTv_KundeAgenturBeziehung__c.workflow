<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>DWH_BeziehungsNummerSchreiben</fullName>
        <description>Schreibt eine dynamisch generierte Nummer in das Feld DWH_VKZID wenn dieses leer ist.</description>
        <field>SomTv_DWH_VKZID__c</field>
        <formula>SomTv_DWH_VKZID_SF__c</formula>
        <name>DWH_BeziehungsNummerSchreiben</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_BeziehungsNamenSchreiben</fullName>
        <description>Schreibt in das Feld BeziehungsNr einen sprechenden Namen.</description>
        <field>Name</field>
        <formula>IF(LEN(Kunde__r.Name+&quot;_&quot;+Agentur__r.Name) &gt; 80, 
LEFT(Kunde__r.Name+&quot;_&quot;+Agentur__r.Name, 80), Kunde__r.Name+&quot;_&quot;+Agentur__r.Name)</formula>
        <name>SomTv_BeziehungsNamenSchreiben</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>DWH_BeziehungsNummerSchreiben</fullName>
        <actions>
            <name>DWH_BeziehungsNummerSchreiben</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SomTv_KundeAgenturBeziehung__c.SomTv_DWH_VKZID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Schreibt eine dynamisch generierte Nummer in das Feld DWH_VKZID wenn dieses leer ist.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_BeziehungsNamenSchreiben</fullName>
        <actions>
            <name>SomTv_BeziehungsNamenSchreiben</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SomTv_KundeAgenturBeziehung__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Schreibt einen Sprechenden Beziehungsnamen aus Kunde_Agentur</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
