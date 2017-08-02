<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>P7S1_GroupedId</fullName>
        <field>P7S1_GroupedId__c</field>
        <formula>SomDig_Werbetreibender__c +&apos;|&apos;+SomDig_BeziehungInhaber__c</formula>
        <name>P7S1 GroupedId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_WtAgBeziehungBeziehungAccountname</fullName>
        <description>Befüllt Feld &quot;WT AG Beziehung&quot; aus Formelfeld &quot;Beziehung Accountname help&quot;, um hiernach in Nachschlagebeziehungen suchen zu können (unter &quot;Alle Felder&quot;, da hier keine Formelfelder)</description>
        <field>SomDig_BeziehungAccountname__c</field>
        <formula>SomDig_BeziehungAccountnameHelp__c</formula>
        <name>SomDig_WtAgBeziehungBeziehungAccountname</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_WtAgBeziehungUniqueKey</fullName>
        <description>Feldaktualisierung befüllt UniqueKey-Feld bei Anlage eines Datensatztes WT AG - Beziehung automatisch, um Dubletten zu vermeiden (18-stellige Salesforce-ID des WT und der AG, mit einem Underscore getrennt)</description>
        <field>SomDig_UniqueKey__c</field>
        <formula>Casesafeid(SomDig_Werbetreibender__r.Id) 
&amp; &quot;_&quot; 
&amp; Casesafeid(SomDig_Agentur__r.Id)</formula>
        <name>SomDig_WtAgBeziehungUniqueKey</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>SomDig_WtAgBeziehung</fullName>
        <actions>
            <name>SomDig_WtAgBeziehungBeziehungAccountname</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_WtAgBeziehungUniqueKey</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow Feldaktualisierung, um UniqueKey-Feld bei Anlage Datensatztes WT AG - Beziehung automatisch zu befüllen &amp; Dubletten zu vermeiden (SF-ID WT und AG, mit Underscore getrennt) sowie Infofeld &quot;Beziehung Accoutname&quot; befüllen zwecks Nachschlageoption</description>
        <formula>SomDig_Werbetreibender__r.Id &lt;&gt; &quot;0&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WTAG Grouped ID</fullName>
        <actions>
            <name>P7S1_GroupedId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SomDig_WtAgBeziehung__c.SomDig_BeziehungInhaber__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
