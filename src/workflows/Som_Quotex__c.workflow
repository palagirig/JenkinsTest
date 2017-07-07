<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Som_QuotexdatenName</fullName>
        <field>Name</field>
        <formula>LEFT(Som_Account__r.Name,71) &amp;&quot;_&quot;&amp; Som_Jahr__c &amp;&quot;_&quot;&amp;  Som_ZeitraumTyp__c</formula>
        <name>Som_QuotexdatenName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Som_UniqueKey</fullName>
        <description>stellt Eindeutigkeit sicher des zusammengesetzten Schlüssels: 
Jahr + Zeitraum + Account</description>
        <field>Som_UniqueKey__c</field>
        <formula>CASESAFEID (Som_Account__c) &amp; &apos;_&apos; &amp;  
Som_Jahr__c &amp; &apos;_&apos; &amp;  
Som_ZeitraumTyp__c</formula>
        <name>Som_UniqueKey</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Som_QuotexdatenName</fullName>
        <actions>
            <name>Som_QuotexdatenName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Som_Quotex__c.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>1/1/1975</value>
        </criteriaItems>
        <description>Account_Jahr_Zeitraum gem. CRMSALES-1017</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Som_UniqueKey</fullName>
        <actions>
            <name>Som_UniqueKey</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>stellt Eindeutigkeit sicher des zusammengesetzten Schlüssels: 
Jahr + Zeitraum + Account</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
