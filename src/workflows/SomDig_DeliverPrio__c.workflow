<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SomDig_Unique</fullName>
        <field>SomDig_UniqueKey__c</field>
        <formula>TEXT(SomDig_Abrechungsart__c) + &apos;|&apos; +
SomDig_Auftragstyp__c + &apos;|&apos; +
TEXT(SomDig_Belegungseinheitstyp__c) + &apos;|&apos; +
SomDig_Mediagattungsdifferenzierung__c + &apos;|&apos; +
TEXT(SomDig_Rotationstyp__c) + &apos;|&apos; +
TEXT(SomDig_Werbeform_Kurzform__c)</formula>
        <name>SomDig_Unique</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SomDig_Unique</fullName>
        <actions>
            <name>SomDig_Unique</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Füllt Unique Feld mir zusammengesetztem Schlüssel.</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
