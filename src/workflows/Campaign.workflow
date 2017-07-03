<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Campaign_Active_from_Status</fullName>
        <field>IsActive</field>
        <literalValue>1</literalValue>
        <name>Campaign Active from Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Campaign_Inactive_from_Status</fullName>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Campaign Inactive from Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_SphereCopy</fullName>
        <description>Kopiert den Wert aus P7S1_Sphere, welches als Formel populiert ist in ein Textfeld um es der Freigaberegel verfügbar zu machen.</description>
        <field>P7S1_SphereCopy__c</field>
        <formula>P7S1_Sphere__c</formula>
        <name>P7S1_SphereCopy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_B2BAktionAktivFalse</fullName>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>SomTv_B2BAktion Aktiv = false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_B2BAktionAktivTrue</fullName>
        <field>IsActive</field>
        <literalValue>1</literalValue>
        <name>SomTv_B2BAktion Aktiv = true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
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
            <field>Campaign.P7S1_Sphere__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Kopiert den Wert aus P7S1_Sphere, welches als Formel populiert ist in ein Textfeld um es der Freigaberegel verfügbar zu machen.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Som TV B2B Aktion Checkbox Aktiv</fullName>
        <actions>
            <name>Campaign_Active_from_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Status</field>
            <operation>equals</operation>
            <value>Planung,Durchführung</value>
        </criteriaItems>
        <description>B2B Aktion | Aktiv Haken soll automatisch gesetzt und entfernt werden (CRMSALES-2385)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Som TV B2B Aktion Checkbox Inaktiv</fullName>
        <actions>
            <name>Campaign_Inactive_from_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Status</field>
            <operation>equals</operation>
            <value>Abgeschlossen,Abgebrochen</value>
        </criteriaItems>
        <description>B2B Aktion | Aktiv Haken soll automatisch gesetzt und entfernt werden (CRMSALES-2385)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_B2BAktionEndSetInaktive</fullName>
        <actions>
            <name>SomTv_B2BAktionAktivFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>WENN Datensatztyp = &quot;Event&quot; oder &quot;MutterB2B Aktion&quot; UND Enddatum (Date/Time) = Today, DANN setze inaktiv. (CRMSALES-177)</description>
        <formula>(RecordTypeId  = &quot;012M00000004XbL&quot;  || 
RecordTypeId  = &quot;012M00000004XdO&quot;)  
&amp;&amp;
DATEVALUE(SomTv_UhrzeitEnde__c) = TODAY ()
&amp;&amp;
(P7S1_Sphere__c = &quot;SomDe&quot;  ||  
 P7S1_Sphere__c = &quot;SomAt&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_B2BAktionStartSetAktive</fullName>
        <actions>
            <name>SomTv_B2BAktionAktivTrue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>WENN Datensatztyp = &quot;Event&quot; oder &quot;MutterB2B Aktion&quot; UND Startdatum (Date/Time) = Today, DANN setze aktiv. (CRMSALES-176)</description>
        <formula>(RecordTypeId  = &quot;012M00000004XbL&quot;  || 
RecordTypeId  = &quot;012M00000004XdO&quot;)  
&amp;&amp;    
DATEVALUE( SomTv_UhrzeitStart__c )   &lt;=  TODAY () 
&amp;&amp;    
DATEVALUE( SomTv_UhrzeitEnde__c )    &gt;=   TODAY ()
&amp;&amp;  
(P7S1_Sphere__c = &quot;SomDe&quot;  ||  
 P7S1_Sphere__c = &quot;SomAt&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_B2BAktionStartSetInaktive</fullName>
        <actions>
            <name>SomTv_B2BAktionAktivFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>WENN Datensatztyp = &quot;Event&quot; oder &quot;MutterB2B Aktion&quot; UND Startdatum (Date/Time) = &quot; &quot; ODER Startdatum (Date/Time) &gt; Today, DANN setze inaktiv. (CRMSALES-176)</description>
        <formula>(RecordTypeId  = &quot;012M00000004XbL&quot;   ||  
RecordTypeId  = &quot;012M00000004XdO&quot;)  
&amp;&amp;    
( TEXT(SomTv_UhrzeitEnde__c) = &quot;&quot;  || 
DATEVALUE(SomTv_UhrzeitEnde__c)  &lt;  TODAY ()
)
&amp;&amp;  
(P7S1_Sphere__c = &quot;SomDe&quot; || P7S1_Sphere__c = &quot;SomAt&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
