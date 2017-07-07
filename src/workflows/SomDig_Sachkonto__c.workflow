<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SomDig_SachkontoVerwendung</fullName>
        <description>Sachkonto-Name&amp;SomDig_SachkontoTyp__c</description>
        <field>SomDig_VerwendungSachkonto__c</field>
        <formula>IF( ISBLANK(TEXT(SomDig_SachkontoTyp__c)), Name, TEXT(SomDig_SachkontoTyp__c))</formula>
        <name>Sachkonto Verwendung</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SomDig_SachkontoVerwendung</fullName>
        <actions>
            <name>SomDig_SachkontoVerwendung</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>generiert UniqueKey aus Name&amp;&amp;Sachkonto-Typ</description>
        <formula>ISNEW()  ||  ISCHANGED( Name ) ||  ISCHANGED( SomDig_SachkontoTyp__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
