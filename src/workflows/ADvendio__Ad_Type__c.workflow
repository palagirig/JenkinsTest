<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SomDig_FC_Ad_served_every</fullName>
        <description>das Feld FC_Ad_served_every__c
a) füllen, wenn die beiden anderen FC Felder gefüllt sind
b) leeren, wenn die beiden anderen FC Felder leer sind.</description>
        <field>SomDig_FcAnzahlPeriode__c</field>
        <formula>IF(
  ISBLANK(TEXT(SomDig_FcPeriode__c)) &amp;&amp; ISBLANK(SomDig_FcMenge__c),
  null,
  1
)</formula>
        <name>SomDig_FC_Ad_served_every</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_SetActiveAdType</fullName>
        <description>KV 02906. Setzt beim erstellen &quot;Active&quot; auf true.</description>
        <field>ADvendio__Active__c</field>
        <literalValue>1</literalValue>
        <name>SomDig_SetActiveAdType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SomDig_FC_Ad_served_every</fullName>
        <actions>
            <name>SomDig_FC_Ad_served_every</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>das Feld FC_Ad_served_every__c
a) füllen, wenn die beiden anderen FC Felder gefüllt sind
b) leeren, wenn die beiden anderen FC Felder leer sind.</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_SetActiveAdType</fullName>
        <actions>
            <name>SomDig_SetActiveAdType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>KV 02906. Setzt beim erstellen &quot;Active&quot; auf true.</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
