<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SOM_Verfuegbarkeit_optimiert_berechnen</fullName>
        <field>ADvendio__OptimizedValue__c</field>
        <formula>IF (ISBLANK(ADvendio__OptimizedValue__c) || ISNUMBER(ADvendio__OptimizedValue__c),
    TEXT(
        IF(ISBLANK(ADvendio__OptimizedValue__c), 0, VALUE(ADvendio__OptimizedValue__c))  + 
            CASE ( 
                ADvendio__CampaignItem__r.ADvendio__Billing_category__c, 
                &quot;CPM&quot;, IF(ISNULL(ADvendio__CampaignItem__r.ADvendio__Delivered_Impressions__c), 0, ADvendio__CampaignItem__r.ADvendio__Delivered_Impressions__c), 
                &quot;CPC&quot;, IF(ISNULL(ADvendio__CampaignItem__r.ADvendio__Delivered_Clicks__c), 0, ADvendio__CampaignItem__r.ADvendio__Delivered_Clicks__c),
                0 
            )
    ),
    ADvendio__OptimizedValue__c
)</formula>
        <name>Verfügbarkeit (optimiert) berechnen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Änderung betrifft Verfügbarkeit</fullName>
        <actions>
            <name>SOM_Verfuegbarkeit_optimiert_berechnen</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ADvendio__FieldName__c == &quot;advendio__availability__c&quot; &amp;&amp; (ISCHANGED(ADvendio__OptimizedValue__c) || ISNEW())</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
