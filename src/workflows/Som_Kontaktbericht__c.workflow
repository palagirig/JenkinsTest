<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>P7S1_SphereCopy</fullName>
        <description>Steuert die Feldaktualisierung an - diese Kopiert den Wert aus P7S1_Sphere, welches als Formel populiert ist in ein Textfeld um es der Freigaberegel verfügbar zu machen.</description>
        <field>P7S1_SphereCopy__c</field>
        <formula>P7S1_Sphere__c</formula>
        <name>P7S1_SphereCopy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>P7S1_SphereCopy</fullName>
        <actions>
            <name>P7S1_SphereCopy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Som_Kontaktbericht__c.P7S1_Sphere__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Kopiert den Wert aus P7S1_Sphere, welches als Formel populiert ist in ein Textfeld um es der Freigaberegel verfügbar zu machen.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
