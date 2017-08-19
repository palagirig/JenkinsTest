<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SomDig_YearMonth</fullName>
        <field>SomDig_YearMonth__c</field>
        <formula>IF( ISNULL(ADvendio__Month__c ),
  null,
  YEAR( ADvendio__Month__c ) * 100 + MONTH (ADvendio__Month__c)
)</formula>
        <name>SomDig_YearMonth</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SomDig_YearMonth</fullName>
        <actions>
            <name>SomDig_YearMonth</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() ||  ISBLANK(SomDig_YearMonth__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
