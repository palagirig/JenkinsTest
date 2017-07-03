<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SomTv_CreateUniqueKey</fullName>
        <description>Fill check for uniqueness
One Forecast per account per year</description>
        <field>SomTv_CheckOneForecastPerYear__c</field>
        <formula>SomTV_Account__c + &quot;|&quot; + SomTv_Agentur__c + &quot;|&quot; + TEXT( SomTv_Jahr__c )</formula>
        <name>Create Unique Key</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_SetForecastName</fullName>
        <field>Name</field>
        <formula>If ( 
LEN (SomTV_Account__r.Name &amp; &quot; - &quot; &amp; SomTv_Agentur__r.Name &amp; &quot; - &quot; &amp; Text( SomTv_Jahr__c ) ) &gt; 80 , 

LEFT ( (SomTV_Account__r.Name &amp; &quot; - &quot; &amp; SomTv_Agentur__r.Name ), 73) &amp; &quot; - &quot; &amp; Text( SomTv_Jahr__c ) , 

SomTV_Account__r.Name &amp; &quot; - &quot; &amp; SomTv_Agentur__r.Name &amp; &quot; - &quot; &amp; Text( SomTv_Jahr__c ) 

)</formula>
        <name>Set Forecast Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Create Unique Key</fullName>
        <actions>
            <name>SomTv_CreateUniqueKey</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomTv_SetForecastName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SomTv_ForecastTV__c.SomTv_Jahr__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Create unique key for check on uniqueness
One Forecast per account per year</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
