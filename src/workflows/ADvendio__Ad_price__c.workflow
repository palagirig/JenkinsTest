<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SomDig_SetExclusive</fullName>
        <description>KV 03258. Setzt bei Abrechungsart CPD und CPW (und CPMo und CPY) die Checkbox &quot;ADvendio__Exclusive__c&quot; auf true.</description>
        <field>ADvendio__Exclusive__c</field>
        <literalValue>1</literalValue>
        <name>SomDig_SetExclusive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SomDig_SetExclusive</fullName>
        <actions>
            <name>SomDig_SetExclusive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( ISPICKVAL(ADvendio__Billing_Category__c, &apos;CPD&apos;), ISPICKVAL(ADvendio__Billing_Category__c, &apos;CPW&apos;), ISPICKVAL(ADvendio__Billing_Category__c, &apos;CPMo&apos;), ISPICKVAL(ADvendio__Billing_Category__c, &apos;CPY&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
