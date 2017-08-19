<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SomDig_Mediagattung</fullName>
        <description>befüllt das Hilfsfeld um die Info auf LI zu übertragen</description>
        <field>SomDig_Mediagattung__c</field>
        <formula>ADvendio__Placement__r.ADvendio__Site__r.SomDig_Mediagattung__r.Name</formula>
        <name>Mediagattung</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_MediagattungsDifferenzierung</fullName>
        <description>befüllt das Hilfsfeld; übernommen aus der Werbeform</description>
        <field>SomDig_MediagattungsDifferenzierung__c</field>
        <formula>ADvendio__Ad_Type__r.SomDig_MediagattungsDifferenzierung__r.Name</formula>
        <name>Mediagattungs-Differenzierung</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_VAT</fullName>
        <description>befüllt ADvendio__VATType__c mit Standard = 1</description>
        <field>ADvendio__VATType__c</field>
        <literalValue>1</literalValue>
        <name>SomDig_VAT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SomDig_Mediagattung</fullName>
        <actions>
            <name>SomDig_Mediagattung</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>befüllt das Hilfsfeld um die Info auf LI zu übertragen</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_Mediagattungsdifferenzierung</fullName>
        <actions>
            <name>SomDig_MediagattungsDifferenzierung</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>befüllt das Hilfsfeld; übernommen aus der Werbeform</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_VAT</fullName>
        <actions>
            <name>SomDig_VAT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>befüllt ADvendio__VATType__c mit Standard = 1</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
