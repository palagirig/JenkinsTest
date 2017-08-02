<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SomTV_OliNrGoodwillUnitPrice</fullName>
        <description>Setzt den UnitPrice auf NULL bei Goodwill</description>
        <field>UnitPrice</field>
        <formula>0</formula>
        <name>SomTV_OliNrGoodwillUnitPrice</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_GaPaketExtra</fullName>
        <description>füllt SomTv_GaPaketExtra__c aus Produkt</description>
        <field>SomTv_GaPaketExtra__c</field>
        <formula>IF(SomTv_Paket_Extra__c,
  TEXT(Product2.SomTv_PaketExtra__c),
  &apos;&apos;
)</formula>
        <name>SomTv_GaPaketExtra</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_Geschaeftsart</fullName>
        <description>füllt Geschäftsart aus:
a) dem Produkt in das Opportunity LineItem.
b) Paket Extra
c) GA NR/Goodwill
d) GA Sonderfall</description>
        <field>SomTv_Geschaeftsart__c</field>
        <formula>IF (
  SomTv_GaSonder__c &lt;&gt; &apos;&apos;,
  LEFT(SomTv_GaSonder__c, 4),
  IF (
    SomTv_GaPaketExtra__c &lt;&gt; &apos;&apos;,
    LEFT(SomTv_GaPaketExtra__c, 4),
    IF (
      TEXT(SomTv_GeschaeftsartUnbezahlt__c) &lt;&gt; &apos;&apos;,
      LEFT(TEXT(SomTv_GeschaeftsartUnbezahlt__c), 4),
      NULL
    )
  )
)</formula>
        <name>SomTv_Geschaeftsart</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_MB1_Kopf_AdF</fullName>
        <field>SomTv_MB1_Kopf_AdF__c</field>
        <formula>SomTv_MB1Bezahlt__c</formula>
        <name>SomTv_MB1_Kopf_AdF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_MB3_Kopf</fullName>
        <field>SomTv_MB3_Kopf__c</field>
        <formula>IF(ISNULL(SomTv_NrGoodwillInEUR__c),SomTv_MB1Bezahlt__c,  SomTv_NrGoodwillInEUR__c )</formula>
        <name>SomTv_MB3_Kopf</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_OliNrGoodwill_AEProzent</fullName>
        <field>SomTv_AE_inProzent__c</field>
        <formula>0</formula>
        <name>SomTv_OliNrGoodwill_AEProzent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_OliNrGoodwill_BR</fullName>
        <field>BR__c</field>
        <formula>0</formula>
        <name>SomTv_OliNrGoodwill_BR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_OliNrGoodwill_Skonto</fullName>
        <field>SomTv_Skonto__c</field>
        <formula>0</formula>
        <name>SomTv_OliNrGoodwill_Skonto</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_OliRabattierfaehigkeit</fullName>
        <field>SomTv_OliRabattierfaehig__c</field>
        <literalValue>1</literalValue>
        <name>SomTv_OliRabattierfähigkeit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_OliSetTarifart</fullName>
        <description>Übernahme der Tarifarten aus den Produkten im AdF-Preisbuch in die OLIs</description>
        <field>SomTv_Tarifart__c</field>
        <formula>Product2.SomTv_TAGesamt__c</formula>
        <name>SomTv_OliSetTarifart</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_OliSet_Quantity</fullName>
        <field>Quantity</field>
        <formula>1</formula>
        <name>SomTv_OliSet_Quantity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SomTv_GeschaeftsartFelder</fullName>
        <actions>
            <name>SomTv_GaPaketExtra</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomTv_Geschaeftsart</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Füllt alle Felder im Bereich Geschäftsart</description>
        <formula>Opportunity.P7S1_Sphere__c =&apos;SomDe&apos;
||
Opportunity.P7S1_Sphere__c =&apos;SomAt&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_OliNrGoodwill</fullName>
        <actions>
            <name>SomTV_OliNrGoodwillUnitPrice</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomTv_OliNrGoodwill_AEProzent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomTv_OliNrGoodwill_BR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomTv_OliNrGoodwill_Skonto</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.SomTv_NrGoodwill__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.P7S1_Sphere__c</field>
            <operation>equals</operation>
            <value>SomDe,SomAt</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>AdFactory</value>
        </criteriaItems>
        <description>IF OLI.SomTv_NrGoodwill__c &lt;&gt; &quot;&quot; THEN SET

OLI.BR__c=0
OLI.SomTv_AE_inProzent__c=0
OLI.SomTv_Skonto__c=0
OLI.UnitPrice =0

PARALLEL in FORMEL im Feld:

OLI.SomTv_MB1Bezahlt__c=0
OLI.SomTv_MB1__c=0</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_OliRabattierfähigkeit</fullName>
        <actions>
            <name>SomTv_OliRabattierfaehigkeit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>AdFactory</value>
        </criteriaItems>
        <criteriaItems>
            <field>Product2.SomTv_Rabattierfaehig__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>AdF-Produkte rabattierfähig=true, dann Oli rabattierfähig auch = true</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_OliSetTarifart</fullName>
        <actions>
            <name>SomTv_OliSetTarifart</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PricebookEntry.Pricebook2Id</field>
            <operation>equals</operation>
            <value>AdF_Preisbuch</value>
        </criteriaItems>
        <description>Übernahme der Tarifarten aus den Produkten im AdF-Preisbuch in die OLIs</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_OliSet_MB1_MB3</fullName>
        <actions>
            <name>SomTv_MB1_Kopf_AdF</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomTv_MB3_Kopf</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>1/1/1999</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.P7S1_Sphere__c</field>
            <operation>equals</operation>
            <value>SomDe,SomAt</value>
        </criteriaItems>
        <description>Wenn OLI.UnitPrice &lt;&gt;&quot;0&quot;

Dann

OLI.SomTv_MB1_Kopf_AdF_c = OLI.SomTv_MB1Bezahlt_c AND

OLI.SomTv_MB3_Kopf_c = OLI.SomTv_MB1Bezahlt__c + OLI.SomTv_NrGoodwillInEUR__c</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
