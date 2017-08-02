<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>P7S1_AccountVisibility</fullName>
        <field>P7S1_AccountVisibility__c</field>
        <formula>Account.P7S1_AccountVisibility__c</formula>
        <name>P7S1_AccountVisibility</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_Geschlecht</fullName>
        <description>Füllt Geschlecht auf Basis der Anrede</description>
        <field>Som_Geschlecht__c</field>
        <formula>CASE( Salutation , 
&quot;Herr&quot;, &quot;männlich&quot;, 
&quot;Frau&quot;, &quot;weiblich&quot; , 
&quot;Mr.&quot;, &quot;männlich&quot;, 
&quot;Mrs.&quot;, &quot;weiblich&quot;, 
&quot;?&quot;)</formula>
        <name>P7S1_Geschlecht</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_KontaktDelKontaktdatenLeeren</fullName>
        <description>del SomTv_KontaktdatenGeloescht</description>
        <field>SomTv_KontaktdatenGeloescht__c</field>
        <name>SomTv_KontaktDelKontaktdatenLeeren</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_KontaktZueberpruefen</fullName>
        <field>SomTv_ZuUeberpruefenCon__c</field>
        <literalValue>1</literalValue>
        <name>SomTv_Kontakt zu überprüfen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Som_AustrittAusgeschiedenFalsch</fullName>
        <field>ausgeschieden__c</field>
        <literalValue>0</literalValue>
        <name>Som_AustrittAusgeschiedenFalsch</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Som_AustrittAusgeschiedenWahr</fullName>
        <field>ausgeschieden__c</field>
        <literalValue>1</literalValue>
        <name>Som_AustrittAusgeschiedenWahr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Som_AustrittDsTypAktiv</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Som_StandardAktiverKontakt</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Som_AustrittDsTypAktiv</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Som_AustrittDsTypInaktiv</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Som_InaktiverKontakt</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Som_AustrittDsTypInaktiv</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Som_Birthday</fullName>
        <description>Füllt Birthday aus GeburtsdatumJahr/Monat/Tag-Feldern</description>
        <field>Birthdate</field>
        <formula>DATE( 
IF ( ISBLANK(Geburtstag_Jahr__c), 1904, VALUE(Geburtstag_Jahr__c)) , 
VALUE(Geburtstag_Monat__c), 
VALUE(Geburtstag_Tag__c))</formula>
        <name>Som_Birthday</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Som_ContactOwner</fullName>
        <description>setzt Inhaber für SomDe/SomAt auf Peter Rozalski</description>
        <field>OwnerId</field>
        <lookupValue>peter.rozalski@prosiebensat1.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Som_ContactOwner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>P7S1_AccountVisibility</fullName>
        <actions>
            <name>P7S1_AccountVisibility</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>setzt P7S1_AccountVisibility des Kontakts aus dem Account</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_Geschlecht</fullName>
        <actions>
            <name>P7S1_Geschlecht</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Füllt Geschlecht auf Basis der Anrede. Wird für alle Sphären ausgeführt. Für welche Sphären das Feld Geschlecht verfügbar ist (Feldberechtigung, Layout) ist anderes Thema</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_KontaktDelKontaktdatenLeeren</fullName>
        <actions>
            <name>SomTv_KontaktDelKontaktdatenLeeren</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>wenn ein Kontakt wieder aktiviert wird, so muss das Feld &quot;SomTv_KontaktdatenGeloescht__c&quot; gelöscht werden</description>
        <formula>(P7S1_Sphere__c = &apos;SomDe&apos; || P7S1_Sphere__c = &apos;SomAt&apos;)
&amp;&amp;
ISCHANGED(RecordTypeId )
&amp;&amp;
PRIORVALUE(RecordTypeId)= &quot;012D0000000Qe2p&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_KontaktNeuZuÜberprüfen</fullName>
        <actions>
            <name>SomTv_KontaktZueberpruefen</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.CreatedDate</field>
            <operation>greaterOrEqual</operation>
            <value>1/1/2000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.P7S1_Sphere__c</field>
            <operation>equals</operation>
            <value>SomDe,SomAt</value>
        </criteriaItems>
        <description>setzt &quot;zu überprüfen&quot; = true, wenn Kontakt angelegt wird (NEU)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_KontaktZuÜberprüfen</fullName>
        <actions>
            <name>SomTv_KontaktZueberpruefen</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>setzt &quot;zu überprüfen&quot; = true, wenn Kontakt an bestimmten Feldern geändert wurde</description>
        <formula>(P7S1_Sphere__c = &quot;SomDe&quot; || P7S1_Sphere__c = &quot;SomAt&quot;)
&amp;&amp;
PRIORVALUE( SomTv_ZuUeberpruefenCon__c )  &lt;&gt; true  
&amp;&amp; 
(
  ISCHANGED( LastName )   ||
  ISCHANGED( FirstName )   ||
  ISCHANGED( Salutation ) ||
  ISCHANGED( AccountId )  
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Som_AustrittAktiv</fullName>
        <actions>
            <name>Som_AustrittAusgeschiedenFalsch</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Som_AustrittDsTypAktiv</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>kein Austrittsdatum, oder Austrittsdatum in Zukunft
=&gt; Datensatztyp=aktiv, Ausgeschieden=Falsch
für bestehende Datensätze</description>
        <formula>(P7S1_Sphere__c = &apos;SomDe&apos; || P7S1_Sphere__c = &apos;SomAt&apos;)
&amp;&amp;
( ISBLANK(Austrittsdatum__c)
  || Austrittsdatum__c &gt; TODAY()
)
&amp;&amp;
 NOT( ISNEW() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Som_AustrittInaktivVergangenheit</fullName>
        <actions>
            <name>Som_AustrittAusgeschiedenWahr</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Som_AustrittDsTypInaktiv</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Austrittsdatum gefüllt und in vergangenheit
=&gt; sofort: Datensatztyp=inaktiv, Ausgeschieden=Wahr</description>
        <formula>(P7S1_Sphere__c = &apos;SomDe&apos; || P7S1_Sphere__c = &apos;SomAt&apos;)
&amp;&amp;
NOT ( ISBLANK(Austrittsdatum__c) )
&amp;&amp;
Austrittsdatum__c &lt; Today()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Som_AustrittInaktivZukunft</fullName>
        <active>true</active>
        <description>Austrittsdatum gefüllt
=&gt; zeitbasiert: Datensatztyp=inaktiv, Ausgeschieden=Wahr</description>
        <formula>(P7S1_Sphere__c = &apos;SomDe&apos; || P7S1_Sphere__c = &apos;SomAt&apos;) 
&amp;&amp; 
NOT ( ISBLANK(Austrittsdatum__c) ) 
&amp;&amp; 
Austrittsdatum__c &gt;= Today()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Som_AustrittAusgeschiedenWahr</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Som_AustrittDsTypInaktiv</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contact.Austrittsdatum__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Som_Birthday</fullName>
        <actions>
            <name>Som_Birthday</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Füllt Birthday aus GeburtsdatumJahr/Monat/Tag-Feldern</description>
        <formula>BEGINS ( P7S1_Sphere__c , &apos;Som&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Som_ContactOwner</fullName>
        <actions>
            <name>Som_ContactOwner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.P7S1_Sphere__c</field>
            <operation>equals</operation>
            <value>SomDe,SomAt</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>startsWith</operation>
            <value>Som_</value>
        </criteriaItems>
        <description>setzt Inhaber für SomDe/SomAt auf Peter Rozalski</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
