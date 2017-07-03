<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SomTv_AngebotKonsensBRRMnachBR</fullName>
        <description>SomTv_BR_c (&quot;BR (%) Sales&quot;) = SomTv_BRRM_c (&quot;BR (%) RM&quot;)</description>
        <field>SomTv_BR__c</field>
        <formula>SomTv_BRRM__c</formula>
        <name>SomTv_AngebotKonsensBRRMnachBR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_AngebotKonsensBRRMnachBRIST</fullName>
        <description>Übernahme von SomTv_BRRM_c (&quot;BR (%) RM&quot;) nach SomTv_BRIST_c (&quot;BR (%) DSB&quot;)</description>
        <field>SomTv_BRIST__c</field>
        <formula>SomTv_BRRM__c</formula>
        <name>SomTv_AngebotKonsensBRRMnachBRIST</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_AngebotKonsensNRRMnachNR</fullName>
        <description>SomTv_NR_c (&quot;NR (%) Sales&quot;) = SomTv_NRRM_c (&quot;NR (%) RM&quot;)</description>
        <field>SomTv_NR__c</field>
        <formula>SomTv_NRRM__c</formula>
        <name>SomTv_AngebotKonsensNRRMnachNR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_AngebotKonsensNRRMnachNRDSB</fullName>
        <description>Übernahme von SomTv_NRRM_c (&quot;NR (%) RM&quot;) nach SomTv_NR_DSB_c (&quot;NR (%) DSB&quot;)</description>
        <field>SomTv_NR_DSB__c</field>
        <formula>SomTv_NRRM__c</formula>
        <name>SomTv_AngebotKonsensNRRMnachNRDSB</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_AngebotKonsensSon2RMnachSon2</fullName>
        <description>SomTv_Sonder_NR_2_c (&quot;Sonder-NR 2 (%)&quot;) = SomTV_Sonder_NR_2_RM_c (&quot;Sonder-NR 2 (%) RM&quot;)</description>
        <field>SomTv_Sonder_NR_2__c</field>
        <formula>SomTV_Sonder_NR_2_RM__c</formula>
        <name>SomTv_AngebotKonsensSon2RMnachSon2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_AngebotKonsensSon2RMnachSon2DSB</fullName>
        <description>SomTv_Sonder_NR_2DSB_c__c (&quot;Sonder-NR 2 (%)&quot;) = SomTV_Sonder_NR_2_RM_c (&quot;Sonder-NR 2 (%) RM&quot;)</description>
        <field>SomTv_Sonder_NR_2DSB_c__c</field>
        <formula>SomTV_Sonder_NR_2_RM__c</formula>
        <name>SomTv_AngebotKonsensSon2RMnachSon2DSB</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_AngebotKonsensSonNRRMnachSon1DSB</fullName>
        <description>SomTv_SonderNR1DSB_c__c (&quot;Sonder-NR 1 (%)&quot;) = SomTv_SonderNRRM_c (&quot;Sonder-NR 1 (%) RM&quot;)</description>
        <field>SomTv_SonderNR1DSB_c__c</field>
        <formula>SomTv_SonderNRRM__c</formula>
        <name>SomTv_AngebotKonsensSonNRRMnachSon1DSB</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_AngebotKonsensSonderNRRMnachSonNR1</fullName>
        <description>SomTv_SonderNR1_c (&quot;Sonder-NR 1 (%)&quot;) = SomTv_SonderNRRM_c (&quot;Sonder-NR 1 (%) RM&quot;)</description>
        <field>SomTv_SonderNR1__c</field>
        <formula>SomTv_SonderNRRM__c</formula>
        <name>SomTv_AngebotKonsensSonderNRRMnachSonNR1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_AngebotRabatte_In_KopfBR</fullName>
        <description>Schreibt SomTv_BRKopf_c__c nach der Regel: 

Prio: BR Angebot &gt; BR DSB &gt; BR RM &gt; BR Sales &gt; BR Kunde</description>
        <field>SomTv_BRKopf_c__c</field>
        <formula>IF(OR(SomTv_BRAngebot__c &lt;&gt; 0,SomTv_NRAngebot__c &lt;&gt; 0 , SomTv_SonderNR1Angebot__c &lt;&gt; 0,SomTv_Sonder_NR_2_Angebot__c &lt;&gt; 0), SomTv_BRAngebot__c , 
IF(OR(SomTv_BRIST__c &lt;&gt; 0, SomTv_NR_DSB__c &lt;&gt; 0 , SomTv_SonderNR1DSB_c__c &lt;&gt; 0,SomTv_Sonder_NR_2DSB_c__c &lt;&gt; 0), SomTv_BRIST__c , 
IF(OR(SomTv_BRRM__c &lt;&gt; 0, SomTv_NRRM__c &lt;&gt; 0 , SomTv_SonderNRRM__c &lt;&gt; 0,SomTV_Sonder_NR_2_RM__c &lt;&gt; 0), SomTv_BRRM__c , 
IF(OR(SomTv_BR__c &lt;&gt; 0, SomTv_NR__c &lt;&gt; 0 , SomTv_SonderNR1__c &lt;&gt; 0,SomTv_Sonder_NR_2__c &lt;&gt; 0), SomTv_BR__c , 
IF(OR(SomTv_BRKunde__c &lt;&gt; 0, SomTv_NRKunde__c&lt;&gt;0 , SomTv_SonderNR1Kunde__c &lt;&gt; 0,SomTv_Sonder_NR_2_Kunde__c &lt;&gt; 0), SomTv_BRKunde__c ,0)))))</formula>
        <name>SomTv_AngebotRabatte_In_KopfBR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_AngebotRabatte_In_KopfHinweis</fullName>
        <description>Schreibt SomTv_NRKopf_c__c nach der Regel: 

Prio: NR Angebot &gt; NR DSB &gt; NR RM &gt; NR Sales &gt; NR Kunde</description>
        <field>SomTv_Grund_fuer_RabattierungKopf__c</field>
        <formula>IF(OR(SomTv_BRAngebot__c &lt;&gt; 0,SomTv_NRAngebot__c &lt;&gt; 0 , SomTv_SonderNR1Angebot__c &lt;&gt; 0,SomTv_Sonder_NR_2_Angebot__c &lt;&gt; 0), SomTV_Grund_1_fuer_Rabattierung_Angebot__c , 
IF(OR(SomTv_BRIST__c &lt;&gt; 0, SomTv_NR_DSB__c &lt;&gt; 0 , SomTv_SonderNR1DSB_c__c &lt;&gt; 0,SomTv_Sonder_NR_2DSB_c__c &lt;&gt; 0), SomTv_Grund_f_RabattierungDSB_c__c , 
IF(OR(SomTv_BRRM__c &lt;&gt; 0, SomTv_NRRM__c &lt;&gt; 0 , SomTv_SonderNRRM__c &lt;&gt; 0,SomTV_Sonder_NR_2_RM__c &lt;&gt; 0), SomTv_Grund1FuerRabattierungRM__c , 
IF(OR(SomTv_BR__c &lt;&gt; 0, SomTv_NR__c &lt;&gt; 0 , SomTv_SonderNR1__c &lt;&gt; 0,SomTv_Sonder_NR_2__c &lt;&gt; 0), SomTv_Grund1FuerRabattierung__c ,
IF(OR(SomTv_BRKunde__c &lt;&gt; 0, SomTv_NRKunde__c&lt;&gt;0 , SomTv_SonderNR1Kunde__c &lt;&gt; 0,SomTv_Sonder_NR_2_Kunde__c &lt;&gt; 0), SomTv_Grund1FuerRabattierungKunde__c ,&quot;&quot;)))))</formula>
        <name>SomTv_AngebotRabatte_In_KopfHinweis</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_AngebotRabatte_In_KopfNR</fullName>
        <description>Schreibt SomTv_NRKopf_c__c nach der Regel: 

Prio: NR Angebot &gt; NR DSB &gt; NR RM &gt; NR Sales &gt; NR Kunde</description>
        <field>SomTv_NRKopf_c__c</field>
        <formula>IF(OR(SomTv_BRAngebot__c &lt;&gt; 0,SomTv_NRAngebot__c &lt;&gt; 0 , SomTv_SonderNR1Angebot__c &lt;&gt; 0,SomTv_Sonder_NR_2_Angebot__c &lt;&gt; 0), SomTv_NRAngebot__c , 
IF(OR(SomTv_BRIST__c &lt;&gt; 0, SomTv_NR_DSB__c &lt;&gt; 0 , SomTv_SonderNR1DSB_c__c &lt;&gt; 0,SomTv_Sonder_NR_2DSB_c__c &lt;&gt; 0), SomTv_NR_DSB__c , 
IF(OR(SomTv_BRRM__c &lt;&gt; 0, SomTv_NRRM__c &lt;&gt; 0 , SomTv_SonderNRRM__c &lt;&gt; 0,SomTV_Sonder_NR_2_RM__c &lt;&gt; 0), SomTv_NRRM__c , 
IF(OR(SomTv_BR__c &lt;&gt; 0, SomTv_NR__c &lt;&gt; 0 , SomTv_SonderNR1__c &lt;&gt; 0,SomTv_Sonder_NR_2__c &lt;&gt; 0), SomTv_NR__c , 
IF(OR(SomTv_BRKunde__c &lt;&gt; 0, SomTv_NRKunde__c&lt;&gt;0 , SomTv_SonderNR1Kunde__c &lt;&gt; 0,SomTv_Sonder_NR_2_Kunde__c &lt;&gt; 0), SomTv_NRKunde__c ,0)))))</formula>
        <name>SomTv_AngebotRabatte_In_KopfNR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_AngebotRabatte_In_KopfSondderNR1</fullName>
        <description>Schreibt in SomTv_SonderNR1Kopf_c__c nach der Regel: 

Prio: Sonder NR Angebot &gt; Sonder NR DSB &gt; Sonder NR RM &gt; Sonder NR Sales &gt; Sonder NR Kunde</description>
        <field>SomTv_SonderNR1Kopf_c__c</field>
        <formula>IF(OR(SomTv_BRAngebot__c &lt;&gt; 0,SomTv_NRAngebot__c &lt;&gt; 0 , SomTv_SonderNR1Angebot__c &lt;&gt; 0,SomTv_Sonder_NR_2_Angebot__c &lt;&gt; 0), SomTv_SonderNR1Angebot__c , 
IF(OR(SomTv_BRIST__c &lt;&gt; 0, SomTv_NR_DSB__c &lt;&gt; 0 , SomTv_SonderNR1DSB_c__c &lt;&gt; 0,SomTv_Sonder_NR_2DSB_c__c &lt;&gt; 0), SomTv_SonderNR1DSB_c__c , 
IF(OR(SomTv_BRRM__c &lt;&gt; 0, SomTv_NRRM__c &lt;&gt; 0 , SomTv_SonderNRRM__c &lt;&gt; 0,SomTV_Sonder_NR_2_RM__c &lt;&gt; 0), SomTv_SonderNRRM__c , 
IF(OR(SomTv_BR__c &lt;&gt; 0, SomTv_NR__c &lt;&gt; 0 , SomTv_SonderNR1__c &lt;&gt; 0,SomTv_Sonder_NR_2__c &lt;&gt; 0), SomTv_SonderNR1__c , 
IF(OR(SomTv_BRKunde__c &lt;&gt; 0, SomTv_NRKunde__c&lt;&gt;0 , SomTv_SonderNR1Kunde__c &lt;&gt; 0,SomTv_Sonder_NR_2_Kunde__c &lt;&gt; 0), SomTv_SonderNR1Kunde__c ,0)))))</formula>
        <name>SomTv_AngebotRabatte_In_KopfSonderNR1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_AngebotRabatte_In_KopfSondderNR2</fullName>
        <description>Schreibt in SomTv_SonderNR2Kopf_c__c nach der Regel: 

Prio: Sonder NR Angebot &gt; Sonder NR DSB &gt; Sonder NR RM &gt; Sonder NR Sales &gt; Sonder NR Kunde</description>
        <field>SomTv_SonderNR2Kopf_c__c</field>
        <formula>IF(OR(SomTv_BRAngebot__c &lt;&gt; 0,SomTv_NRAngebot__c &lt;&gt; 0 , SomTv_SonderNR1Angebot__c &lt;&gt; 0,SomTv_Sonder_NR_2_Angebot__c &lt;&gt; 0), SomTv_Sonder_NR_2_Angebot__c , 
IF(OR(SomTv_BRIST__c &lt;&gt; 0, SomTv_NR_DSB__c &lt;&gt; 0 , SomTv_SonderNR1DSB_c__c &lt;&gt; 0,SomTv_Sonder_NR_2DSB_c__c &lt;&gt; 0), SomTv_Sonder_NR_2DSB_c__c , 
IF(OR(SomTv_BRRM__c &lt;&gt; 0, SomTv_NRRM__c &lt;&gt; 0 , SomTv_SonderNRRM__c &lt;&gt; 0,SomTV_Sonder_NR_2_RM__c &lt;&gt; 0), SomTV_Sonder_NR_2_RM__c , 
IF(OR(SomTv_BR__c &lt;&gt; 0, SomTv_NR__c &lt;&gt; 0 , SomTv_SonderNR1__c &lt;&gt; 0,SomTv_Sonder_NR_2__c &lt;&gt; 0), SomTv_Sonder_NR_2__c , 
IF(OR(SomTv_BRKunde__c &lt;&gt; 0, SomTv_NRKunde__c&lt;&gt;0 , SomTv_SonderNR1Kunde__c &lt;&gt; 0,SomTv_Sonder_NR_2_Kunde__c &lt;&gt; 0), SomTv_Sonder_NR_2_Kunde__c ,0)))))</formula>
        <name>SomTv_AngebotRabatte_In_KopfSondderNR2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_AngebotRabatte_In_KopfText</fullName>
        <field>SomTv_Aktuelle_Sicht__c</field>
        <formula>IF(OR(SomTv_BRAngebot__c &lt;&gt; 0,SomTv_NRAngebot__c &lt;&gt; 0 , SomTv_SonderNR1Angebot__c &lt;&gt; 0,SomTv_Sonder_NR_2_Angebot__c &lt;&gt; 0), &quot;Angebotssicht&quot; , 
IF(OR(SomTv_BRIST__c &lt;&gt; 0, SomTv_NR_DSB__c &lt;&gt; 0 , SomTv_SonderNR1DSB_c__c &lt;&gt; 0,SomTv_Sonder_NR_2DSB_c__c &lt;&gt; 0), &quot;DealSoundBoard Sicht&quot; , 
IF(OR(SomTv_BRRM__c &lt;&gt; 0, SomTv_NRRM__c &lt;&gt; 0 , SomTv_SonderNRRM__c &lt;&gt; 0,SomTV_Sonder_NR_2_RM__c &lt;&gt; 0), &quot;Revenue Management Sicht&quot; , 
IF(OR(SomTv_BR__c &lt;&gt; 0, SomTv_NR__c &lt;&gt; 0 , SomTv_SonderNR1__c &lt;&gt; 0,SomTv_Sonder_NR_2__c &lt;&gt; 0), &quot;Sales Sicht&quot; , 
IF(OR(SomTv_BRKunde__c &lt;&gt; 0, SomTv_NRKunde__c&lt;&gt;0 , SomTv_SonderNR1Kunde__c &lt;&gt; 0,SomTv_Sonder_NR_2_Kunde__c &lt;&gt; 0), &quot;Kundensicht&quot; ,&quot;Keine aktuelle Sicht vorhanden&quot;)))))</formula>
        <name>SomTv_AngebotRabatte_In_KopfText</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SomTv_AngebotKonsens</fullName>
        <actions>
            <name>SomTv_AngebotKonsensBRRMnachBR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomTv_AngebotKonsensBRRMnachBRIST</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomTv_AngebotKonsensNRRMnachNR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomTv_AngebotKonsensNRRMnachNRDSB</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomTv_AngebotKonsensSon2RMnachSon2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomTv_AngebotKonsensSon2RMnachSon2DSB</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomTv_AngebotKonsensSonNRRMnachSon1DSB</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomTv_AngebotKonsensSonderNRRMnachSonNR1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SomTv_Angebot__c.SomTv_Konsens__c</field>
            <operation>equals</operation>
            <value>Konsens</value>
        </criteriaItems>
        <description>Bei Einigkeit zwischen Ad Analytic and Development und Sales bzg Rabattsätzen kennzeichnet Ad Analytics and Development diese als KONSENS und damit werden die Rabattsätze automatisch in die DSB- und Salessicht.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_AngebotRabatte_In_Kopf</fullName>
        <actions>
            <name>SomTv_AngebotRabatte_In_KopfBR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomTv_AngebotRabatte_In_KopfHinweis</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomTv_AngebotRabatte_In_KopfNR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomTv_AngebotRabatte_In_KopfSondderNR1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomTv_AngebotRabatte_In_KopfSondderNR2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomTv_AngebotRabatte_In_KopfText</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>SomTv_Angebot__c.SomTv_MB1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>SomTv_Angebot__c.SomTv_MN3_Bruttoermittlung__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Füllen der Vier Rabattsätze im &quot;Kopfteil&quot; + Begründung
SomTv_BRKopf_c__c
SomTv_NRKopf_c__c
SomTv_SonderNR1Kopf_c__c
SomTv_SonderNR2Kopf_c__c
SomTv_Grund_fuer_RabattierungKopf__c

Prio: Angebot &gt; DSB &gt; RM &gt; Sales &gt; Kunde</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
