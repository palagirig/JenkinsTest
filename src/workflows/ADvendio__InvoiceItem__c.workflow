<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ADvendio__SetDeliveryAutoImportTrue</fullName>
        <description>The field Delivery AutoImport is updated automatically to TRUE (Invoice Item).</description>
        <field>ADvendio__DeliveryAutoImport__c</field>
        <literalValue>1</literalValue>
        <name>Set Delivery AutoImport = TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ADvendio__change_temporary_ItemId_to_permanent</fullName>
        <field>ADvendio__ItemId__c</field>
        <formula>SUBSTITUTE(ADvendio__ItemId__c, &quot;|tmp|&quot;, ADvendio__Invoice__r.ADvendio__KeyExtension__c )</formula>
        <name>change temporary ItemId to permanent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ADvendio__change_temporary_UniqueKey_to_perm_Item</fullName>
        <field>ADvendio__UniqueKey__c</field>
        <formula>SUBSTITUTE(ADvendio__UniqueKey__c, &quot;|tmp|&quot;,  ADvendio__Invoice__r.ADvendio__KeyExtension__c )</formula>
        <name>change temporary UniqueKey to permanent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Mediagattungs_Segement_Name</fullName>
        <field>SomDig_Mediagattungs_Segement_Name__c</field>
        <formula>SomDig_Mediagattungs_Segment__r.Name</formula>
        <name>Mediagattungs-Segement Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ADvendio__Invoice %2Fw temporary Key created</fullName>
        <actions>
            <name>ADvendio__change_temporary_ItemId_to_permanent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ADvendio__change_temporary_UniqueKey_to_perm_Item</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() &amp;&amp; (CONTAINS(ADvendio__UniqueKey__c, &apos;|tmp|&apos;) || CONTAINS(ADvendio__ItemId__c, &apos;|tmp|&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ADvendio__Set Delivery AutoImport</fullName>
        <actions>
            <name>ADvendio__SetDeliveryAutoImportTrue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow automatically set Delivery AutoImport to TRUE (Invoice Item).</description>
        <formula>!ADvendio__DeliveryAutoImport__c &amp;&amp; TEXT(ADvendio__Invoice__r.ADvendio__CreationType__c) != &apos;Flex&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Mediagattungs-Segement Name</fullName>
        <actions>
            <name>SomDig_Mediagattungs_Segement_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Befüllt das Feld Mediagattungs-Segement Name an der Rechnungsposition.
Relevant für SAP SST</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
