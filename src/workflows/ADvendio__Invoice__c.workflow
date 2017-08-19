<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ADvendio__Set_Invoice_Number</fullName>
        <description>Sets the Invoice Number as Invoice name after Billing run.</description>
        <field>Name</field>
        <formula>IF(NOT(ISNULL($Setup.ADvendio__InvoicenumberOrigin__c.ADvendio__InvoicenumberOrigin__c)), TEXT(VALUE(ADvendio__InvoiceNumber__r.Name)+$Setup.ADvendio__InvoicenumberOrigin__c.ADvendio__InvoicenumberOrigin__c),ADvendio__InvoiceNumber__r.Name)</formula>
        <name>Set Invoice Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ADvendio__Set_PreInvoice_Number</fullName>
        <description>Sets the PreInvoice Number when there is no InvoiceNumber record linked</description>
        <field>Name</field>
        <formula>ADvendio__PreInvoiceNumber__c</formula>
        <name>Set PreInvoice Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ADvendio__change_temporary_UniqueKey_to_permanent</fullName>
        <field>ADvendio__UniqueKey__c</field>
        <formula>SUBSTITUTE(ADvendio__UniqueKey__c, &quot;|tmp|&quot;, ADvendio__KeyExtension__c )</formula>
        <name>change temporary UniqueKey to permanent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FakturaBuchungssaetzeEnthaltenLeeren</fullName>
        <field>SomDig_FakturaBuchungssaetzeEnthalten__c</field>
        <literalValue>0</literalValue>
        <name>Faktura Buchungssätze Enthalten leeren</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_ZahlungsbedingungRechnungsstorno</fullName>
        <description>Befüllt das Rechnungs-Feld &quot;ADvendio__PaymentTerms__c&quot; ausschließlich mit dem Wert aus &quot;./.&quot;, wenn mit einer anderen RG verlinkt ist (also = Stornorenchung), damit via BA Mapping auf dem RG-Dokument nicht der Zahlungskonditions-Text erscheint (KV 1752)</description>
        <field>ADvendio__PaymentTerms__c</field>
        <formula>&quot;./.&quot;</formula>
        <name>SomDig_ZahlungsbedingungRechnungsstorno</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ADvendio__Invoice %2Fw temporary Key created</fullName>
        <actions>
            <name>ADvendio__change_temporary_UniqueKey_to_permanent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() &amp;&amp; CONTAINS(ADvendio__UniqueKey__c, &apos;|tmp|&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ADvendio__Set Invoice Number</fullName>
        <actions>
            <name>ADvendio__Set_Invoice_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Sets the Invoice Number depending on the record beeing created or invoiced.</description>
        <formula>NOT(    ISBLANK(ADvendio__InvoiceNumber__c)  ) &amp;&amp;  (    ISNEW() ||   ISCHANGED(Name) ||   ISCHANGED(ADvendio__InvoiceNumber__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ADvendio__Set PreInvoice Number</fullName>
        <actions>
            <name>ADvendio__Set_PreInvoice_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the PreInvoice Number depending on the record beeing created or invoiced.</description>
        <formula>ISBLANK(ADvendio__InvoiceNumber__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FakturaBuchungssaetzeEnthaltenLeeren</fullName>
        <actions>
            <name>FakturaBuchungssaetzeEnthaltenLeeren</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Invoice Number</fullName>
        <actions>
            <name>ADvendio__Set_Invoice_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the Invoice Number depending on the record beeing created or invoiced.</description>
        <formula>NOT(   ISBLANK(ADvendio__InvoiceNumber__c) ) &amp;&amp; (   ISNEW() ||   ISCHANGED(ADvendio__InvoiceNumber__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_ZahlungsbedingungRechnungsstorno</fullName>
        <actions>
            <name>SomDig_ZahlungsbedingungRechnungsstorno</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Befüllt das Rechnungs-Feld &quot;ADvendio__PaymentTerms__c&quot; ausschließlich mit dem Wert aus &quot;./.&quot;, wenn mit einer anderen RG verlinkt ist (also = Stornorenchung), damit via BA Mapping auf dem RG-Dokument nicht der Zahlungskonditions-Text erscheint (KV 1752)</description>
        <formula>NOT(ISBLANK( ADvendio__Invoice__c ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
