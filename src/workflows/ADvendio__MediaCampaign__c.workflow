<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SomDig_ErinnerungFestplatzreservierung</fullName>
        <description>SomDig Erinnerung Festplatzreservierung</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce-admins@prosiebensat1.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/SomDig_ErinnerungsmailFestplatzreservierung</template>
    </alerts>
    <alerts>
        <fullName>SomDig_GenehmigungsprozessVorkasseEntscheidung</fullName>
        <description>SomDig Genehmigungsprozess Vorkasse Entscheidung</description>
        <protected>false</protected>
        <recipients>
            <field>SomDig_BetreuerPam__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>SomDig_BetreuerSales__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SomDig_Genehmigungsprozess_Vorlagen/SomDig_GenehmigungsprozessVorkasseEntscheidung</template>
    </alerts>
    <alerts>
        <fullName>SomDig_IsApprovedWithoutCommitments</fullName>
        <description>SomDig IsApproved Without Commitments</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SomDig_Schlusstermin</template>
    </alerts>
    <alerts>
        <fullName>SomDig_IsRejectedWithoutCommitments</fullName>
        <description>SomDig IsRejected Without Commitments</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SomDig_Schlusstermin</template>
    </alerts>
    <alerts>
        <fullName>SomDig_Schlusstermin</fullName>
        <description>Schlusstermin überprüfen</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce-admins@prosiebensat1.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/SomDig_Schlusstermin</template>
    </alerts>
    <fieldUpdates>
        <fullName>ADvendio__Activate_Media_Campaign_for_Billing</fullName>
        <field>ADvendio__BillMe__c</field>
        <literalValue>1</literalValue>
        <name>Activate Media Campaign for Billing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ADvendio__Deactivate_Media_Campaign_for_Billing</fullName>
        <field>ADvendio__BillMe__c</field>
        <literalValue>0</literalValue>
        <name>Deactivate Media Campaign for Billing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ADvendio__DocumentTypeCancellation</fullName>
        <description>If Probability is 0%, Document Type changes to Cancellation.</description>
        <field>ADvendio__Document_type__c</field>
        <literalValue>Cancellation</literalValue>
        <name>DocumentTypeCancellation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ADvendio__DocumentTypeOrderConfirmation</fullName>
        <description>If Probability is 100%, Document Type changes to Order Confirmation.</description>
        <field>ADvendio__Document_type__c</field>
        <literalValue>Order Confirmation</literalValue>
        <name>DocumentTypeOrderConfirmation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ADvendio__DocumentTypeProposal</fullName>
        <description>If Probability is greater than 0% and less than 100%, Document Type changes to Proposal.</description>
        <field>ADvendio__Document_type__c</field>
        <literalValue>Proposal</literalValue>
        <name>DocumentTypeProposal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDigPDFTitelStornierung</fullName>
        <description>setzt den Wert von Dokument-Titel in einem Auftrag automatisch auf &quot;Stornierung&quot;, wenn einer Kampagne storniert ist</description>
        <field>ADvendio__Document_type__c</field>
        <literalValue>Cancellation</literalValue>
        <name>SomDig PDF Titel &quot;Stornierung&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_AbrechnungFalse</fullName>
        <description>Wenn &quot;Gutschrift Performance&quot; angekreuzt ist, darf keine Rechnung erstellt werden.</description>
        <field>ADvendio__BillMe__c</field>
        <literalValue>0</literalValue>
        <name>SomDig AbrechnungFalse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_AbrechnungTrue</fullName>
        <description>Wenn &quot;Gutschrift Performance&quot; nicht mehr angekreuzt ist soll sichergestellt sein, dass auch eine Rechnung gestellt wird (Voreinstellung).</description>
        <field>ADvendio__BillMe__c</field>
        <literalValue>1</literalValue>
        <name>SomDig AbrechnungTrue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Auftrag</fullName>
        <description>Der User sollte verhindert werden eine Buchung am AdServer vorzunehmen, falls der Auftrag nicht zustande gekommen ist. Daher schaltet dieser WF RT (PL) bei Phase(Stage) = 100% auf &quot;Auftrag&quot; um, wo dieser Button freigeschaltet ist.</description>
        <field>RecordTypeId</field>
        <lookupValue>SomDig_Auftrag</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SomDig Auftrag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_ContractClosingDate</fullName>
        <description>Fügt das Datum ein in das Feld &apos;ContractClosing Date&apos;, wann das Angebot angenommen wurde und somit der Status von Angebot zu Auftrag wurde.</description>
        <field>SomDig_ContractClosingDate__c</field>
        <formula>TODAY()</formula>
        <name>SomDig Contract Closing Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_DescriptionCombined</fullName>
        <field>ADvendio__Description__c</field>
        <formula>SomDig_DescriptionManual__c &amp; 
IF(NOT(ISBLANK(SomDig_DescriptionManual__c)), BR(), &quot;&quot;) &amp; 
SomDig_DescriptionAutomated__c</formula>
        <name>SomDig_DescriptionCombined</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_DocumentType</fullName>
        <description>update automatically the field Document type to &quot;Order Confirmation&quot;, if Stage = &apos;booked&apos;</description>
        <field>ADvendio__Document_type__c</field>
        <literalValue>Order Confirmation</literalValue>
        <name>SomDig Document Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_GenehmigtNichtWahr</fullName>
        <description>setzt das Kontrolkästchen auf FALSE, wenn mindestens ein LI über Limit liegt und nicht genehmigt ist</description>
        <field>ADvendio__IsApproved__c</field>
        <literalValue>0</literalValue>
        <name>SomDig_Genehmigt-nicht wahr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_GenehmigtWahr</fullName>
        <description>setzt das Kontrolkästchen auf TRUE, wenn alle darunter liegenden LIs genehmigt oder nicht genehmigungspflichtich sind</description>
        <field>ADvendio__IsApproved__c</field>
        <literalValue>1</literalValue>
        <name>SomDig_Genehmigt-Wahr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_KampagnennummerAnAdserver</fullName>
        <description>Die Mediakampagnennummer soll an den Adserver übertragen werden. Hierfür wird per Feldaktualisierung das Feld ADvendio__AlternateOrderId__c mit der Kampagnennummer befüllt und an Adserver als &quot;PONumber&quot; übergeben (siehe Ticket 03696)</description>
        <field>ADvendio__AlternateOrderId__c</field>
        <formula>ADvendio__Offer_Number__c</formula>
        <name>SomDig_Kampagnennummer an Adserver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_MKFreigabeZuruecksetzen</fullName>
        <description>steuert die Wahl zwischen RTs, bzw. ermöglicht Doc-Erstellung nur wenn die MK freigegeben ist</description>
        <field>RecordTypeId</field>
        <lookupValue>SomDig_Angebot</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SomDig_MK Freigabe zurücksetzen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_MKSetApproved</fullName>
        <description>Setzt die Checkbox &quot;IsApproved&quot; auf true.</description>
        <field>ADvendio__IsApproved__c</field>
        <literalValue>1</literalValue>
        <name>SomDig_MKSetApproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_PDF_TitelAngebot</fullName>
        <description>update automatically the field Document type to &quot;Angebot&quot;, if Stage &lt;&gt; &apos;booked</description>
        <field>ADvendio__Document_type__c</field>
        <literalValue>Offer</literalValue>
        <name>SomDig PDF Titel &quot;Angebot&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_PerformanceTextEntfernen</fullName>
        <description>Wenn nicht als Performance abgerechnet wird,, wird der Beschreibungstext angepasst.</description>
        <field>ADvendio__Description__c</field>
        <formula>SUBSTITUTE(ADvendio__Description__c, &quot;-Die Kampagnen unterliegen dem jederzeitigen Schiebe- und Stornorecht seitens der 71M. Die 71M behält sich ein Vetorecht bei der Auswahl der Kampagnen vor, insbesondere wenn die Gestaltung keine klare Klick /Abverkaufsorientierung erkennen lässt bzw. ein Brandingeffekt im Vordergrund steht. Es besteht keine Garantie auf gleichmäßige Auslieferung über den vereinbarten Schaltungszeitraum. Die vollständige Auslieferung der AI&apos;s wird nicht garantiert. Die Abrechnung erfolgt an Hand der tatsächlich ausgelieferten AI&apos;s. Das Reporting der 71M ist maßgebend.&quot;, &quot;&quot;)</formula>
        <name>SomDig_Performance Text entfernen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_PerformanceTextHinzufuegen</fullName>
        <description>Beschreibung Update auf Dokumenten, falls Performance MK</description>
        <field>ADvendio__Description__c</field>
        <formula>PRIORVALUE( ADvendio__Description__c ) &amp; &quot; -Die Kampagnen unterliegen dem jederzeitigen Schiebe- und Stornorecht seitens der 71M. Die 71M behält sich ein Vetorecht bei der Auswahl der Kampagnen vor, insbesondere wenn die Gestaltung keine klare Klick /Abverkaufsorientierung erkennen lässt bzw. ein Brandingeffekt im Vordergrund steht. Es besteht keine Garantie auf gleichmäßige Auslieferung über den vereinbarten Schaltungszeitraum. Die vollständige Auslieferung der AI&apos;s wird nicht garantiert. Die Abrechnung erfolgt an Hand der tatsächlich ausgelieferten AI&apos;s. Das Reporting der 71M ist maßgebend.&quot;</formula>
        <name>SomDig Performance Text hinzufügen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_PhasePotenzial</fullName>
        <description>wird nach dem Klonen einer Kampagne automatisch gesetzt</description>
        <field>ADvendio__Stage__c</field>
        <literalValue>First contact</literalValue>
        <name>SomDig Phase &quot;Potenzial&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Positionsrabatt_Natural_Text</fullName>
        <field>ADvendio__Description__c</field>
        <formula>ADvendio__Description__c 

&amp; BR() &amp; BR() &amp; 
&quot; Bei der Gewährung von NR gilt die gebuchte Medialeistung als erfüllt, wenn die Summe aus bezahlter Position und NR Position dem gesamthaft gebuchten Mediavolumen entspricht.&quot;</formula>
        <name>SomDig Positionsrabatt Natural Text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Positionsrabatt_Natural_entfernen</fullName>
        <field>ADvendio__Description__c</field>
        <formula>SUBSTITUTE( ADvendio__Description__c , &quot;Bei der Gewährung von NR gilt die gebuchte Medialeistung als erfüllt, wenn die Summe aus bezahlter Position und NR Position dem gesamthaft gebuchten Mediavolumen entspricht.&quot;, &quot;&quot;)</formula>
        <name>SomDig Positionsrabatt Natural entfernen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_RT_Angebot</fullName>
        <description>beim Erstellen einer neuen MK setzt den RT immer auf &apos;Angebot&apos;</description>
        <field>RecordTypeId</field>
        <lookupValue>SomDig_Angebot</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SomDig_RT Angebot</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_RabatteMediakampagneGenehmigtWahr</fullName>
        <description>wird automatisch belegt; wenn Rabatt genehmigt, dann ‘WAHR‘</description>
        <field>SomDig_RabatteMKgenehmigt__c</field>
        <literalValue>1</literalValue>
        <name>SomDig Rabatte MK Genehmigt Wahr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Rabatte_MK_GenehmigtNichtWahr</fullName>
        <description>setzt automatisch das Kontrollkästchen auf FALSCH, wenn abgelehnt</description>
        <field>SomDig_RabatteMKgenehmigt__c</field>
        <literalValue>0</literalValue>
        <name>SomDig Rabatte MK Genehmigt Nicht Wahr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_RechnungsstellungFalsch</fullName>
        <description>Setzt das Kontrollkästchen BillMe?/Abzurechnen? gemäß ausgewählter Preisliste (Auftragstyp) auf &apos;FALSCH&apos;</description>
        <field>ADvendio__BillMe__c</field>
        <literalValue>0</literalValue>
        <name>SomDig Rechnungsstellung falsch</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_RechnungsstellungWahr</fullName>
        <description>Setzt das Kontrollkästchen BillMe?/Abzurechnen? gemäß ausgewählter Preisliste (Auftragstyp) auf &apos;WAHR&apos;</description>
        <field>ADvendio__BillMe__c</field>
        <literalValue>1</literalValue>
        <name>SomDig Rechnungsstellung wahr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Schlusstermin</fullName>
        <description>setzt Schlusstermin automatisch auf das Datum wenn die Phase auf 100% gesetzt wird</description>
        <field>ADvendio__Close_Date__c</field>
        <formula>TODAY()</formula>
        <name>SomDig Schlusstermin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_SetCustomerDiscount</fullName>
        <description>ADvendio__Rate_Discount_2__c is set to MAX(SomDig_Kundenrabatt_InPage__c, SomDig_Kundenrabatt_InStream__c)</description>
        <field>ADvendio__Rate_Discount_2__c</field>
        <formula>MAX(SomDig_Kundenrabatt_InPage__c, SomDig_Kundenrabatt_InStream__c)</formula>
        <name>SomDig_SetCustomerDiscount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Status_PAM_Cockpit</fullName>
        <description>... wird auf &apos;neu&apos; gesetzt, soweit phase auf &apos;gewonnen &amp; gebucht&apos;</description>
        <field>SomDig_StatusPAMCockpit__c</field>
        <literalValue>neu</literalValue>
        <name>Status PAM Cockpit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Stornierung</fullName>
        <description>setzt Ablehnungsgrund automatisch auf &apos;Stornierung&apos;, wenn Datensatztyp &apos;Auftrag&apos; und Phase (Stage) auf Geschlossen &amp; abgelehnt, 0%</description>
        <field>ADvendio__Reason_for_refusal__c</field>
        <literalValue>Cancellation</literalValue>
        <name>SomDig Stornierung</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_VorkasseInkassostatus</fullName>
        <description>Billing kann Mediakampagne auf Auftrag setzen trotz Inkassostatus des Rechnungsempänger-Accounts &quot;not ok&quot;</description>
        <field>ADvendio__Stage__c</field>
        <literalValue>Booked</literalValue>
        <name>SomDig Vorkasse Inkassostatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Zahlungsbedingung</fullName>
        <description>Befüllt das Feld &quot;ADvendio__PaymentTerms__c&quot; mit dem Wert aus &quot;SomDig_Zahlungsbedingung__c&quot;, damit es via BA Mapping auf dem Rechnungsdokument erschient (KV 1752)</description>
        <field>ADvendio__PaymentTerms__c</field>
        <formula>SomDig_Zahlungsbedingung__r.Name</formula>
        <name>SomDig_Zahlungsbedingung</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_ZahlungsbedingungKampagne</fullName>
        <description>Befüllt das Kampagnen-Feld &quot;ADvendio__PaymentTerms__c&quot; mit dem Wert aus &quot;SomDig_Zahlungsbedingung__c&quot;, damit es auf dem Dokument (AN und AB) erschient (KV 1752). Hinweis: Bei Rechnungen kommt eine separate Lösung zum Einsatz</description>
        <field>ADvendio__PaymentTerms__c</field>
        <formula>SomDig_Zahlungsbedingung__r.Name</formula>
        <name>SomDig ZahlungsbedingungKampagne</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomRabatte_MK_GenehmigtNichtWahr</fullName>
        <description>setzt automatisch das Kontrollkästchen auf FALSCH, wenn abgelehnt</description>
        <field>SomDig_RabatteMKgenehmigt__c</field>
        <literalValue>0</literalValue>
        <name>SomDig Rabatte MK Genehmigt Nicht Wahr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ADvendio__Activate Media Campaign for Billing</fullName>
        <actions>
            <name>ADvendio__Activate_Media_Campaign_for_Billing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.ADvendio__Propability__c</field>
            <operation>equals</operation>
            <value>100</value>
        </criteriaItems>
        <description>This workflow activates a media campaign, so that it can be found by the Billing &amp; Accounting module.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ADvendio__Deactivate Media Campaign for Billing</fullName>
        <actions>
            <name>ADvendio__Deactivate_Media_Campaign_for_Billing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.ADvendio__Propability__c</field>
            <operation>lessThan</operation>
            <value>100</value>
        </criteriaItems>
        <description>This workflow deactivates a media campaign, so that it can be found by the Billing &amp; Accounting module.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ADvendio__Set Document Type to Cancellation</fullName>
        <actions>
            <name>ADvendio__DocumentTypeCancellation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.ADvendio__Propability__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>If Probability is 0%, Document Type changes to Cancellation.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ADvendio__Set Document Type to Order Confirmation</fullName>
        <actions>
            <name>ADvendio__DocumentTypeOrderConfirmation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.ADvendio__Propability__c</field>
            <operation>equals</operation>
            <value>100</value>
        </criteriaItems>
        <description>If Probability is 100%, Document Type changes to Order Confirmation.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ADvendio__Set Document Type to Proposal</fullName>
        <actions>
            <name>ADvendio__DocumentTypeProposal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.ADvendio__Propability__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.ADvendio__Propability__c</field>
            <operation>lessThan</operation>
            <value>100</value>
        </criteriaItems>
        <description>If Probability is greater than 0% and less than 100%, Document Type changes to Proposal.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Erinnerung Festplazierungsreservierung</fullName>
        <active>true</active>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.SomDig_AnzahlFestplazierterPositionen__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.ADvendio__Propability__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.ADvendio__Propability__c</field>
            <operation>notEqual</operation>
            <value>100</value>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.ADvendio__Campaign_Start_Date__c</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>E-Mail an Mediakampagneninhaber, dass in der Medikampagnen (welche in drei Wochen starten würde) eine Festplazierungsposition vorkommt bzw. reserviert ist.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SomDig_ErinnerungFestplatzreservierung</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>ADvendio__MediaCampaign__c.ADvendio__Campaign_Start_Date__c</offsetFromField>
            <timeLength>-21</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SomDig Performance Text entfernen</fullName>
        <actions>
            <name>SomDig_PerformanceTextEntfernen</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Wenn die MK nicht als &apos;Performance&apos; abgerechnet wird, wird der Beschreibungstext angepasst.</description>
        <formula>OR(
NOT(CONTAINS(ADvendio__Pricelist__r.Name , &quot;Performance&quot;)), 
NOT(ADvendio__Pricelist__r.SomDig_AuftragstypId__r.Name = &quot;Performance&quot;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Performance Text hinzufügen</fullName>
        <actions>
            <name>SomDig_PerformanceTextHinzufuegen</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Wenn eine Performance Preislist ausgewählt wird, wird die Beschreibung in der Mediakampagne dem entsprechend angepasst.</description>
        <formula>OR(
CONTAINS( ADvendio__Pricelist__r.Name , &quot;Performance&quot;), 
 ADvendio__Pricelist__r.SomDig_AuftragstypId__r.Name = &quot;Performance&quot;
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Positionsrabatt Natural entfernen</fullName>
        <actions>
            <name>SomDig_Positionsrabatt_Natural_entfernen</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.SomDig_AnzahlNaturalrabattPositionen__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>Wenn es keine Campaign Items mehr mit dem Sonderrabatt &quot;Positionsrabatt Natural&quot; gibt, wird der Beschreibungstext angepasst.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Positionsrabatt Natural hinzufügen</fullName>
        <actions>
            <name>SomDig_Positionsrabatt_Natural_Text</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.SomDig_AnzahlNaturalrabattPositionen__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Wenn in einem Campaign Item (Kampagne Position) ein Sonderrabatt mit dem Namen &quot;Positionsrabatt Natural&quot; ausgewählt wird, wird die Beschreibung in der Mediakampagne angepasst.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomDig RT Angebot</fullName>
        <actions>
            <name>SomDig_RT_Angebot</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.ADvendio__Stage__c</field>
            <operation>notEqual</operation>
            <value>Booked</value>
        </criteriaItems>
        <description>beim Erstellen einer neuen MK setzt den RT immer auf &apos;Angebot&apos;</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Rabatte Freigegeben</fullName>
        <actions>
            <name>SomDig_GenehmigtWahr</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_RabatteMediakampagneGenehmigtWahr</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Wenn Rabattstufe 0, dann Genehmigt (inkl. Wasserzeichen (&quot;Entwurf&quot;) vom Angebot entfernen (Checkbox &apos;Genehmigt&apos; = &quot;TRUE&quot;)</description>
        <formula>SomDig_RabattStufe__c = 0 &amp;&amp; ( ADvendio__IsApproved__c = false || SomDig_RabatteMKgenehmigt__c = false )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Rabatte Nicht Freigegeben</fullName>
        <actions>
            <name>SomRabatte_MK_GenehmigtNichtWahr</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Tritt auf wenn das Rabattlimit erreicht oder der schon genehmigte Rabatt weiter erhöht ist. Gleichzeitig wird das Wasserzeichen (&quot;Entwurf&quot;) auf dem Angebot erscheinen (Checkbox &apos;Genehmigt&apos; = &quot;FALSE&quot;)</description>
        <formula>AND(SomDig_GesamtrabattKonsekutiv__c &gt;= 0.65, 
SomDig_RabatteMKgenehmigt__c =TRUE,
ISCHANGED(SomDig_GesamtrabattKonsekutiv__c),
SomDig_GesamtrabattKonsekutiv__c &gt; 
PRIORVALUE(SomDig_GesamtrabattKonsekutiv__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Rechnungsstellung Preislisten Update falsch</fullName>
        <actions>
            <name>SomDig_RechnungsstellungFalsch</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Passt die Rechnungstellung entsprechend der geänderten Preisliste an.</description>
        <formula>/* 012D0000000Qj96 = Angebot */  ISCHANGED(ADvendio__Pricelist__c)  &amp;&amp;  ADvendio__BillMe__c = TRUE &amp;&amp;  RecordTypeId= &apos;012D0000000Qj96&apos; &amp;&amp; ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_Rechnungstellung__c = FALSE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Rechnungsstellung Preislisten Update wahr</fullName>
        <actions>
            <name>SomDig_RechnungsstellungWahr</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Passt die Rechnungstellung entsprechend der geänderten Preisliste an.</description>
        <formula>/* 012D0000000Qj96 = Angebot */  ISCHANGED(ADvendio__Pricelist__c)  &amp;&amp;  ADvendio__BillMe__c = FALSE &amp;&amp;  RecordTypeId= &apos;012D0000000Qj96&apos; &amp;&amp; ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_Rechnungstellung__c = TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Rechnungsstellung falsch</fullName>
        <actions>
            <name>SomDig_RechnungsstellungFalsch</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Setzt in der Mediakampagne das Kontrollkästchen &quot;Abzurechnen?&quot; gemäß ausgewählter Preisliste bzw. hinterlegtem Auftragstyp fix auf &apos;FALSCH&apos;. Ausnahme: Profil SomDig_Billing darf anpassen/ändern. Steuerung via Feld Rechnungsstellung am Objekt &quot;Auftragstyp&quot;</description>
        <formula>ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_Rechnungstellung__c = FALSE  &amp;&amp;  SomDig_GutschriftPerformance__c = TRUE  &amp;&amp;   ( ISCHANGED(ADvendio__BillMe__c) &amp;&amp; NOT($Profile.Name = &quot;SomDig_Billing&quot;) &amp;&amp; ADvendio__BillMe__c = TRUE )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Rechnungsstellung wahr</fullName>
        <actions>
            <name>SomDig_RechnungsstellungWahr</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Setzt in der Mediakampagne das Kontrollkästchen &quot;Abzurechnen?&quot; gemäß ausgewählter Preisliste bzw. hinterlegtem Auftragstyp auf &apos;WAHR&apos;. Ausnahme: Profil SomDig_Billing darf anpassen/ändern. Steuerung via Feld &quot;Rechnungsstellung&quot; am Objekt &quot;Auftragstyp&quot;.</description>
        <formula>ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_Rechnungstellung__c = TRUE  &amp;&amp;  SomDig_GutschriftPerformance__c = FALSE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Wasserzeichen %28freigegebenes Angebot%29</fullName>
        <actions>
            <name>SomDig_GenehmigtWahr</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2) OR (3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.SomDig_RabatteMKgenehmigt__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.SomDig_AnzahlDerNichtGenehmigtenLIs__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.ADvendio__Rate_Discount_3__c</field>
            <operation>lessThan</operation>
            <value>0.65</value>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.ADvendio__Rate_Discount_2__c</field>
            <operation>lessThan</operation>
            <value>0.65</value>
        </criteriaItems>
        <description>das Wasserzeichen (&quot;Entwurf&quot;) wird vom Angebot entfernt (Checkbox &apos;Genehmigt&apos; = &quot;TRUE&quot;)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Wasserzeichen %28nicht freigegebenes Angebot%29</fullName>
        <actions>
            <name>SomDig_GenehmigtNichtWahr</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>das Wasserzeichen (&quot;Entwurf&quot;) wird nicht vom Angebot entfernt (Checkbox &apos;Genehmigt&apos; = &quot;FALSE&quot;)</description>
        <formula>OR( 
SomDig_AnzahlDerNichtGenehmigtenLIs__c &lt;&gt; 0, 

AND(SomDig_GesamtrabattKonsekutiv__c &gt;= 0.65, 
SomDig_RabatteMKgenehmigt__c =TRUE, 
ISCHANGED(SomDig_GesamtrabattKonsekutiv__c), 
SomDig_GesamtrabattKonsekutiv__c &gt; 
PRIORVALUE(SomDig_GesamtrabattKonsekutiv__c)), 

AND(SomDig_GesamtrabattKonsekutiv__c &gt;= 0.65, 
SomDig_RabatteMKgenehmigt__c =FALSE) 

)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_ContractClosingDate</fullName>
        <actions>
            <name>SomDig_ContractClosingDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.ADvendio__Stage__c</field>
            <operation>equals</operation>
            <value>Booked</value>
        </criteriaItems>
        <description>fügt das Datum ein, wann das Angebot angenommen wurde und somit der Status von Angebot zu Auftrag wurde</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_DescriptionCombined</fullName>
        <actions>
            <name>SomDig_DescriptionCombined</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Combine values from SomDig_DescriptionManual__c and SomDig_DescriptionAutomated__c and write the outcome to ADvendio__Description__c.</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_GutschriftPerformanceFalse</fullName>
        <actions>
            <name>SomDig_AbrechnungTrue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Wenn &quot;Gutschrift Performance&quot; nicht mehr angekreuzt ist soll sichergestellt sein, dass auch eine Rechnung gestellt wird (Voreinstellung). Überarbeitet in Ticket 04209.</description>
        <formula>/* 012D0000000Qj96 = Angebot  * 012D0000000Qj9B = Auftrag  */  SomDig_GutschriftPerformance__c = false  &amp;&amp; RecordTypeId= &apos;012D0000000Qj96&apos;  &amp;&amp; $Profile.Id != &apos;00e20000000lfOj&apos;  &amp;&amp; $Profile.Id != &apos;00eD0000001Qk4n&apos;  &amp;&amp;( ADvendio__Pricelist__r.SomDig_AuftragstypId__r.Name = &apos;Standard&apos;  ||  ADvendio__Pricelist__r.SomDig_AuftragstypId__r.Name != &apos;Standard&apos;   &amp;&amp; $Profile.Id != &apos;00eD0000001Qf2o&apos;  &amp;&amp; $Profile.Id != &apos;00e570000012uRg&apos;  &amp;&amp; $Profile.Id != &apos;00e20000001QBtU&apos; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_GutschriftPerformanceTrue</fullName>
        <actions>
            <name>SomDig_AbrechnungFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.SomDig_GutschriftPerformance__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Es erfolgt keine Rechungsstellung und Weitergabe an SAP via dem Buchungstool, manuelle Handhabung. Daher darf keine Rechnung gestellt werden.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_Kampagnennummer an Adserver</fullName>
        <actions>
            <name>SomDig_KampagnennummerAnAdserver</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Die Mediakampagnennummer soll an den Adserver übertragen werden. Hierfür wird per Feldaktualisierung das Feld ADvendio__AlternateOrderId__c mit der Kampagnennummer befüllt und an Adserver als &quot;PONumber&quot; übergeben (siehe Ticket 03696)</description>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_MKSetApproved</fullName>
        <actions>
            <name>SomDig_MKSetApproved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Setzt die Checkbox &quot;IsApproved&quot; immer auf true.</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_PDF Titel - Angebot</fullName>
        <actions>
            <name>SomDig_PDF_TitelAngebot</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.ADvendio__Stage__c</field>
            <operation>notEqual</operation>
            <value>Booked,Offer denied</value>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.ADvendio__Reason_for_refusal__c</field>
            <operation>notEqual</operation>
            <value>Cancellation</value>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Auftrag</value>
        </criteriaItems>
        <description>Update automatically the field &quot;Document type&quot; to &quot;Angebot&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_PDF Titel - Auftragsbestätigung</fullName>
        <actions>
            <name>SomDig_Auftrag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_DocumentType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.ADvendio__Stage__c</field>
            <operation>equals</operation>
            <value>Booked</value>
        </criteriaItems>
        <description>Update automatically the field &quot;Document type&quot; to &quot;Order Confirmation&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_PDF Titel - Stornierung</fullName>
        <actions>
            <name>SomDigPDFTitelStornierung</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_Stornierung</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Auftrag</value>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.ADvendio__Stage__c</field>
            <operation>equals</operation>
            <value>Offer denied</value>
        </criteriaItems>
        <description>Setzt Ablehnungsgrund automatisch auf &apos;Stornierung&apos;, wenn Datensatztyp &apos;Auftrag&apos; und Phase (Stage) auf Geschlossen &amp; abgelehnt, 0%</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_Rabatte_Freigegeben</fullName>
        <actions>
            <name>SomDig_GenehmigtWahr</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_RabatteMediakampagneGenehmigtWahr</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Tritt auf, wenn das Rabattlimit auf der MK unter dem Limit liegt und keine zu genehmigten Positionen vorliegen. Gleichzeitig wird das Wasserzeichen (&quot;Entwurf&quot;) vom Angebot entfernt (Checkbox &apos;Genehmigt&apos; = &quot;TRUE&quot;)</description>
        <formula>OR( AND(ISBLANK(ADvendio__Rate_Discount_2__c), ADvendio__Rate_Discount_3__c &lt; 0.65), AND(ISBLANK(ADvendio__Rate_Discount_3__c),      ADvendio__Rate_Discount_2__c&lt; 0.65), AND(ISBLANK(ADvendio__Rate_Discount_3__c),      ISBLANK(ADvendio__Rate_Discount_2__c)), SomDig_GesamtrabattKonsekutiv__c   &lt; 0.65, AND(OR(ISCHANGED(ADvendio__Rate_Discount_2__c), ISCHANGED(ADvendio__Rate_Discount_3__c)), SomDig_GesamtrabattKonsekutiv__c  &gt;=  0.65, SomDig_RabatteMKgenehmigt__c =TRUE, PRIORVALUE(SomDig_GesamtrabattKonsekutiv__c)  &gt;=  SomDig_GesamtrabattKonsekutiv__c)   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_Schlusstermin</fullName>
        <active>true</active>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.ADvendio__Stage__c</field>
            <operation>notEqual</operation>
            <value>Booked,Offer denied</value>
        </criteriaItems>
        <description>Dieser Workflow sendet eine ErrinerungsEmail an Kampagneninhaber 14 Tage vor dem Kampagnen Start, falls die Kampagne noch nicht gebucht.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Schluss_termin_ueberpruefen</name>
                <type>Task</type>
            </actions>
            <offsetFromField>ADvendio__MediaCampaign__c.ADvendio__Campaign_Start_Date__c</offsetFromField>
            <timeLength>-14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SomDig_SetCustomerDiscount</fullName>
        <actions>
            <name>SomDig_SetCustomerDiscount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>ADvendio__Rate_Discount_2__c is set to MAX(SomDig_Kundenrabatt_InPage__c, SomDig_Kundenrabatt_InStream__c)</description>
        <formula>ISCHANGED(SomDig_Kundenrabatt_InPage__c) || ISCHANGED(SomDig_Kundenrabatt_InStream__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_Status PAM Cockpit</fullName>
        <actions>
            <name>SomDig_Status_PAM_Cockpit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>dieses WF setzt den initiallen Wert von Status PAM Cockpit auf &apos;neu&apos;</description>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_Zahlungsbedingung</fullName>
        <actions>
            <name>SomDig_Zahlungsbedingung</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Befüllt das Feld &quot;ADvendio__PaymentTerms__c&quot; mit dem Wert aus &quot;SomDig_Zahlungsbedingung__c&quot;, damit es via BA Mapping auf dem Rechnungsdokument erschient (KV 1752)</description>
        <formula>ADvendio__PaymentTerms__c  &lt;&gt;  SomDig_Zahlungsbedingung__r.Name</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_ZahlungsbedingungKampagne</fullName>
        <actions>
            <name>SomDig_ZahlungsbedingungKampagne</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Befüllt das Kampagnen-Feld &quot;ADvendio__PaymentTerms__c&quot; mit dem Wert aus &quot;SomDig_Zahlungsbedingung__c&quot;, damit es auf dem Dokument (AN und  AB) erschient (KV 1752). Hinweis: Bei Rechnungen kommt eine separate Lösung zum Einsatz</description>
        <formula>ADvendio__PaymentTerms__c  &lt;&gt;  SomDig_Zahlungsbedingung__r.Name</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Schluss_termin_ueberpruefen</fullName>
        <assignedToType>owner</assignedToType>
        <description>Die Kampagne für dieses Angebot soll in 14 Tagen beginnen–bitte aktuellen Status des Angebots beim Planer/Werbetreibenden einholen und den Status entsprechend anpassen.
Danke!</description>
        <dueDateOffset>-14</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>ADvendio__MediaCampaign__c.ADvendio__Campaign_Start_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Schlußtermin überprüfen</subject>
    </tasks>
</Workflow>
