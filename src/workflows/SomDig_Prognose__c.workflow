<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SomDig_PrognoseUniqueKey</fullName>
        <description>Feldaktualisierung befüllt UniqueKey-Feld bei Anlage eines Datensatztes WT AG - Beziehung automatisch, um Dubletten zu vermeiden (18-stellige Salesforce-ID des WT und der AG, mit einem Underscore getrennt)</description>
        <field>SomDig_Unique__c</field>
        <formula>Text(SomDig_Jahr__c) &amp; &quot;_&quot;
&amp; 
Casesafeid(SomDig_WtAgBeziehung__r.SomDig_Werbetreibender__r.Id )
&amp; &quot;_&quot; 
&amp; Casesafeid( SomDig_WtAgBeziehung__r.SomDig_Agentur__r.Id)</formula>
        <name>SomDig_PrognoseUniqueKey</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_RelativesJahr</fullName>
        <description>Befüllung des Feldes &quot;Relatives Jahr&quot; durch Infofeld aus &quot;Relatives Jahr Help&quot;, da dieses nicht in Kriterien ausgewählt werden kann (z.B. für RollUps).</description>
        <field>SomDig_RelativesJahr__c</field>
        <formula>SomDig_RelativesJahrHelp__c</formula>
        <name>SomDig_RelativesJahr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>SomDig_Prognose</fullName>
        <actions>
            <name>SomDig_PrognoseUniqueKey</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_RelativesJahr</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow für Feldaktualisierung, welche UniqueKey-Feld bei Anlage eines Datensatztes Progonse Digital automatisch befüllt (um Dubletten innerhalb eines Jahres zu vermeiden (GJ, WT ID, Agentur ID)) und das Feld RelativesJahr befüllt</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
