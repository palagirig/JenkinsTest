<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SomDig_RelativesJahr</fullName>
        <description>Befüllung des Feldes &quot;Relatives Jahr&quot; durch Infofeld aus &quot;Relatives Jahr Help&quot;, da dieses nicht in Kriterien ausgewählt werden kann (z.B. für RollUps).</description>
        <field>SomDig_RelativesJahr__c</field>
        <formula>SomDig_RelativesJahrHelp__c</formula>
        <name>SomDig_RelativesJahr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_SetMediagattungsDiffName</fullName>
        <field>SomDig_MediagattungsDifferenzierungsName__c</field>
        <formula>SomDig_MediagattungsDifferenzierung__r.Name</formula>
        <name>Set MediagattungsDifferenzierungsName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_SetMediagattungsName</fullName>
        <field>SomDig_MediagattungsName__c</field>
        <formula>SomDig_Mediagattung__r.Name</formula>
        <name>Set MediagattungsName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_SetMediagattungsSegmentName</fullName>
        <field>SomDig_MediagattungsSegmentName__c</field>
        <formula>SomDig_MediagattungsSegment__r.Name</formula>
        <name>Set MediagattungsSegmentName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SomDig_SetMediagattungsNames</fullName>
        <actions>
            <name>SomDig_SetMediagattungsDiffName</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_SetMediagattungsName</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_SetMediagattungsSegmentName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() || ISCHANGED(SomDig_Mediagattung__c) || ISCHANGED(SomDig_MediagattungsDifferenzierung__c) || ISCHANGED(SomDig_MediagattungsSegment__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_Umsatz</fullName>
        <actions>
            <name>SomDig_RelativesJahr</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow für Feldaktualisierung, welche bei Anlage eines Datensatztes Umsatz Digital automatisch befüllt hinsichltich Infp über SomDig_RelativesJahr</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
