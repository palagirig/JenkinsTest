<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SomDig_ErinnerungsmailFestplatzreservierung</fullName>
        <description>SomDig Erinnerungsmail Festplatzreservierung</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>dennis.mueller@p7s1.net</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforce-admins@prosiebensat1.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/SomDig_ErinnerungsmailFestplatzreservierung</template>
    </alerts>
    <alerts>
        <fullName>SomDig_ErinnerungsmailFestplatzreservierung2</fullName>
        <description>SomDig Erinnerungsmail Festplatzreservierung</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce-admins@prosiebensat1.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/SomDig_ErinnerungsmailFestplatzreservierung</template>
    </alerts>
    <alerts>
        <fullName>SomDig_MindestTKPPreisUnterschrittenAblehnung</fullName>
        <description>Mindest TKP Preis unterschritten - Ablehnung</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>denis.susko.extern@p7s1.net</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforce-admins@prosiebensat1.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/SomDig_MindestpreisTKPAbgelehnt</template>
    </alerts>
    <alerts>
        <fullName>SomDig_MindestpreisErreichtAlertFuerDatensatzinhaber</fullName>
        <description>Mindestpreis erreicht - Alert für Datensatzinhaber</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce-admins@prosiebensat1.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/SomDig_MindestpreisUnterschritten_AlertFuerInhaber</template>
    </alerts>
    <alerts>
        <fullName>SomDig_RabattlimitUeberschrittenAblehnung</fullName>
        <description>Rabattlimit Überschritten - Ablehnung</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce-admins@prosiebensat1.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SomDig_Genehmigungsprozess_Vorlagen/SomDig_MindestpreisUeberschrittenAbgelehnt</template>
    </alerts>
    <alerts>
        <fullName>SomDig_RabattlimitUeberschrittenAlertFuerDatensatzinhaber</fullName>
        <description>Rabattlimit Überschritten - Alert für Inhaber</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce-admins@prosiebensat1.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SomDig_Genehmigungsprozess_Vorlagen/SomDig_RabattlimitUnterschritten_AlertFuerInhaber</template>
    </alerts>
    <fieldUpdates>
        <fullName>ADvendio__Deactivate_Campaign_Item_for_Billing</fullName>
        <field>ADvendio__BillMe__c</field>
        <literalValue>0</literalValue>
        <name>Deactivate Campaign Item for Billing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ADvendio__DistributionUnitAmountForFixedPrices</fullName>
        <field>ADvendio__DistributionUnit__c</field>
        <literalValue>Amount</literalValue>
        <name>Distribution-Unit = Amount for Fixed pri</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ADvendio__QueryInventoryFalse</fullName>
        <description>If Ad Type is Sponsorship, InHouse or Network -&gt; Query Inventory is false.</description>
        <field>ADvendio__Query_Inventory__c</field>
        <literalValue>0</literalValue>
        <name>QueryInventory false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ADvendio__ResetAvailability</fullName>
        <description>Reset the availability if some fields are changed.</description>
        <field>ADvendio__Availability__c</field>
        <name>Reset Availability</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ADvendio__SetCPMPrice</fullName>
        <field>ADvendio__IsCPMPrice__c</field>
        <literalValue>1</literalValue>
        <name>Set CPM Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ADvendio__Set_LinearDistributionFalse</fullName>
        <description>Turns the linear distribution off by setting the value to false.</description>
        <field>ADvendio__LinearDistribution__c</field>
        <literalValue>0</literalValue>
        <name>Set_LinearDistributionFalse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ADvendio__Set_LinearDistributionTrue</fullName>
        <description>Turns the linear distribution on by setting its value to true.</description>
        <field>ADvendio__LinearDistribution__c</field>
        <literalValue>1</literalValue>
        <name>Set_LinearDistributionTrue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetCampaignToClosedWon</fullName>
        <description>KV 2795. Wenn AdID befüllt wird (beim durchbuchen), setze die Media Kampagne auf Geschlossen &amp; Gewonnen.</description>
        <field>ADvendio__Stage__c</field>
        <literalValue>Booked</literalValue>
        <name>SetCampaignToClosedWon</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ADvendio__Media_Campaign__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetSubmittoAdServerTrue</fullName>
        <field>ADvendio__Submit_to_AdServer__c</field>
        <literalValue>1</literalValue>
        <name>SetSubmittoAdServerTrue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_AE_deaktiviert</fullName>
        <field>ADvendio__AC__c</field>
        <literalValue>0</literalValue>
        <name>SomDig AE deaktiviert</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Abrechnungsmodell_CPC</fullName>
        <description>Für das Abrechnungsmodell CPC werden die Impressiondatenfelder durch jeweiligen Clickdatenfelder ersetzt.</description>
        <field>ADvendio__Delivered_Impressions__c</field>
        <formula>ADvendio__Delivered_Clicks__c</formula>
        <name>SomDig_Abrechnungsmodell CPC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_AdServerOrderId</fullName>
        <description>überträgt AdServer-Order-Id auf Kampagne;
vorausgesetzt - alle Positionen sind mit dem gleichen (DFP) AdServer verlinkt! (Positionen, die nicht mit DFP verlinkt sind (AdServerId leer) werden dabei nicht berücksichtigt.</description>
        <field>SomDig_AdServerOrderId__c</field>
        <formula>ADvendio__Adserver_ID_Order_ID__c</formula>
        <name>SomDig_AdServerOrderId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ADvendio__Media_Campaign__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_AdServerStatusBeiAbgelaufen</fullName>
        <description>setzt AdServer Status nach dem Positionsende zurück</description>
        <field>ADvendio__AdserverStatus__c</field>
        <name>SomDig AdServer Status bei &apos;Abgelaufen&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_AdSpec</fullName>
        <description>Füllt das Feld SomDig_AdSpec über AdPrice-Verbindung</description>
        <field>SomDig_AdSpec__c</field>
        <formula>CASESAFEID( ADvendio__Ad_Price__r.ADvendio__Ad_Spec__c )</formula>
        <name>SomDig_AdSpec</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_AdStatusStorno</fullName>
        <description>KV 02453. Setzt das Feld AdServerStatus, wenn die Position im Optimizer gecancelt wird.</description>
        <field>ADvendio__AdserverStatus__c</field>
        <literalValue>Released</literalValue>
        <name>SomDig_AdStatusStorno</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_AdserverName</fullName>
        <description>Befüllung Feld mit [Kampagnennummer]_[Positionsname]_[Positionsnummer]. Wenn das Feld befüllt ist, wird der Inhalt für den Namen im AdServer verwendet (sollte die Regel sein); wenn es leer ist, wird der Name der KampagnenPosition verwendet (siehe KV 1799)</description>
        <field>ADvendio__AdserverName__c</field>
        <formula>TEXT(ADvendio__PositionNumber__c) 
&amp; &quot;_&quot; &amp; 
ADvendio__Media_Campaign__r.ADvendio__Offer_Number__c 
&amp; &quot;_&quot; &amp; 
Name</formula>
        <name>SomDig Adserver Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_AgenturprovisionFalsch</fullName>
        <description>Bei diversen Auftragstypen soll keine Agenturprovision (AE) eingestellt sein bei allen Positionen der Mediakampagne. Kann vom User verändert werden.</description>
        <field>ADvendio__AC__c</field>
        <literalValue>0</literalValue>
        <name>SomDig Agenturprovision falsch</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Agenturprovision_15</fullName>
        <field>ADvendio__Agency_Commission__c</field>
        <literalValue>15</literalValue>
        <name>SomDig Agenturprovision 15</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Agenturprovision_keine</fullName>
        <field>ADvendio__Agency_Commission__c</field>
        <name>SomDig Agenturprovision keine</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Agenturrabatt</fullName>
        <description>Leert benutzerdefinierte Rabatt-Position, damit der A.-Rabatt aus der MK gezogen wird</description>
        <field>ADvendio__Rate_Discount_3_custom__c</field>
        <name>SomDig Agenturrabatt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_AgenturrabattZahlNull</fullName>
        <description>Wenn Naturalrabatt ausgewählt, soll hier in KampagnePosition kein Wert stehen (Feld leer)</description>
        <field>ADvendio__Rate_Discount_3_custom__c</field>
        <formula>0.00</formula>
        <name>SomDig Agenturrabatt Zahl Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_ClearFCAnzahlPeriode</fullName>
        <field>ADvendio__FC_Ad_served_every__c</field>
        <name>Clear FC Anzahl Periode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_ClearTotalImpressions</fullName>
        <description>KV 03472: Wenn das Feld &quot;ADvendio__Total_Impressions__c&quot; = 0, dann wird es geleert, damit der Fehler &quot;Division by 0&quot; nicht mehr auftritt.</description>
        <field>ADvendio__Total_Impressions__c</field>
        <name>SomDig_ClearTotalImpressions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_DWHGeschaeftsart</fullName>
        <description>setzt DWH Geschäftsart Code nach Nat.Rabatt oder CPM/CPC/CPD</description>
        <field>SomDig_DWHGeschaeftsart__c</field>
        <formula>IF( 


AND( 
OR( 
ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.Name = &quot;Standard&quot;, 
ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.Name = &quot;Performance&quot; 
), 
ISPICKVAL(ADvendio__Rate_Discount_4_Name__c, &quot;Positionsrabatt Natural&quot;) 
), 





&quot;1152&quot;, 



IF( 

AND( 
OR( 
ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.Name = &quot;Standard&quot;, 
ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.Name = &quot;Performance&quot; 
), 
ISPICKVAL(ADvendio__Rate_Discount_4_Name__c, &quot;Kompensation&quot;) 
) 

, 

&quot;1160&quot; 
, 




IF( 
AND( 
OR( 
ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.Name = &quot;Barter&quot;, 
ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.Name = &quot;Eigenwerbung&quot; 
), 
OR( 
ISPICKVAL(ADvendio__Rate_Discount_4_Name__c, &quot;Positionsrabatt Natural&quot;), 
ISPICKVAL(ADvendio__Rate_Discount_4_Name__c, &quot;Kompensation&quot;) 
) 
), 

&quot;&quot;, 
ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_DWHGeschaeftsart__c 
) 


) 




)</formula>
        <name>DWH Geschäftsart</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Default_FC_Anzahl_Periode</fullName>
        <field>ADvendio__FC_Ad_served_every__c</field>
        <formula>1</formula>
        <name>Default FC Anzahl Periode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Durchbuchung1</fullName>
        <description>&apos;WAHR&apos; - die Position ist verändert aber noch nicht im AdServer gebucht</description>
        <field>SomDig_PositionVeraendert__c</field>
        <literalValue>1</literalValue>
        <name>SomDig Durchbuchung 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Durchbuchung2</fullName>
        <description>Das Kontrollkästchen wird per WF zurückgesetzt, wenn &quot;Letzte Buchung&quot; sich ändert</description>
        <field>SomDig_PositionVeraendert__c</field>
        <literalValue>0</literalValue>
        <name>SomDig Durchbuchung 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_FcAnzahlPeriodeEins</fullName>
        <description>Setzt die Anzahl der Zeiteinheiten (FcAdServedEvery) für die ausgewählte Perioden beim FrequencyCapping auf &quot;1&quot;</description>
        <field>ADvendio__FC_Ad_served_every__c</field>
        <formula>1</formula>
        <name>SomDig FC Anzahl Periode Eins</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_FcMengeDrei</fullName>
        <description>Setzt die Anzahl der Einblendungen (Quantity) beim FrequencyCapping auf 3</description>
        <field>ADvendio__FC_Quantity__c</field>
        <formula>3</formula>
        <name>SomDig FC Menge Drei</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_FcMengeZwei</fullName>
        <description>Setzt die Anzahl der Einblendungen (Quantity) beim FrequencyCapping auf 2</description>
        <field>ADvendio__FC_Quantity__c</field>
        <formula>2</formula>
        <name>SomDig FC Menge Zwei</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_FcPeriodeLaufzeit</fullName>
        <description>Setzt beim FrequencyCapping die Zeitperiode auf &quot;Kampagne&quot;</description>
        <field>ADvendio__FC_Period__c</field>
        <literalValue>campaign</literalValue>
        <name>SomDig FC Periode Laufzeit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_FcPeriodeSession</fullName>
        <description>Setzt beim FrequencyCapping die Zeitperiode auf &quot;Session&quot;. Eine Session dauert 30 Minuten</description>
        <field>ADvendio__FC_Period__c</field>
        <literalValue>session</literalValue>
        <name>SomDig FC Periode Session</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_FcPeriodeTag</fullName>
        <description>Setzt beim FrequencyCapping die Zeitperiode auf &quot;Tag&quot;</description>
        <field>ADvendio__FC_Period__c</field>
        <literalValue>day</literalValue>
        <name>SomDig FC Periode Tag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_GesamtrabattKonsekutiv</fullName>
        <field>SomDig_GesamtrabattKonsekutivHelp__c</field>
        <formula>SomDig_GesamtrabattKonsekutiv__c</formula>
        <name>SomDig_GesamtrabattKonsekutiv</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_InhouseProduktion</fullName>
        <description>Das Kontrolkästche wird befüllt, wenn XXL Flashlayer, Wrap oder sonstige Werbeformen, die ausschließlich intern produziert müssen, ausgewählt sind.</description>
        <field>SomDig_Produktion_Erforderlich__c</field>
        <literalValue>1</literalValue>
        <name>SomDig Inhouse Produktion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_KampagnePosition_Exklusiv</fullName>
        <description>Wenn die Abrechnungsart in der Mediakampagne CPD oder CPW ist, wird der Haken im Feld &apos;Exklusiv&apos; gesetzte damit CampaignItem im Belegungsplan erscheint</description>
        <field>ADvendio__Exclusive__c</field>
        <literalValue>1</literalValue>
        <name>SomDig_KampagnePosition_Exklusiv</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_KampagnenPosition_AdType</fullName>
        <description>Setzt den AdType auf Sponsorship, wenn als Abrechnungsart &quot;CPD&quot; oder &quot;CPW&quot; ausgewählt wird.</description>
        <field>ADvendio__AdType__c</field>
        <literalValue>Sponsorship</literalValue>
        <name>SomDig_KampagnenPosition_AdType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_KampagnennummerAnAdserver</fullName>
        <description>Die Mediakampagnennummer soll an den Adserver übertragen werden. Hierfür wird per Feldaktualisierung das Positions-Feld ADvendio__AlternateId__c mit der Kampagnennummer befüllt und an Adserver als &quot;PONumber&quot; übergeben (siehe KV 1597)</description>
        <field>ADvendio__AlternateId__c</field>
        <formula>ADvendio__Media_Campaign__r.ADvendio__Offer_Number__c</formula>
        <name>SomDig_Kampagnennummer an Adserver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Kundenrabatt</fullName>
        <description>Leert benutzerdefinierte Rabatt-Position, damit der K.-Rabatt aus der MK gezogen wird</description>
        <field>ADvendio__Rate_Discount_2_custom__c</field>
        <name>SomDig Kundenrabatt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_KundenrabattZahlNull</fullName>
        <description>Wenn Naturalrabatt ausgewählt, soll hier in KampagnePosition kein Wert stehen (Feld leer)</description>
        <field>ADvendio__Rate_Discount_2_custom__c</field>
        <formula>0.00</formula>
        <name>SomDig Kundenrabatt Zahl Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Lineare_Verteilung</fullName>
        <description>Setzt Checkbox auf WAHR um somit bei Non-AdServer Produkten auf Rechnungen den Betrag zu übertragen (sonst MN2=0)</description>
        <field>ADvendio__LinearDistribution__c</field>
        <literalValue>1</literalValue>
        <name>SomDig Lineare Verteilung</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_MindestTKPZuruecksetzen</fullName>
        <description>setzt checkbox auf &apos;FALSE&apos; wenn Limit nicht erreicht</description>
        <field>SomDig_MindestpreisTKPunterschritten__c</field>
        <literalValue>0</literalValue>
        <name>SomDig_Mindestpreis-TKP zurücksetzen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_MindestpreisTKPUnterschritten</fullName>
        <description>setzt Checkbox auf TRUE, wenn Mindest TKP &gt; MN2</description>
        <field>SomDig_MindestpreisTKPunterschritten__c</field>
        <literalValue>1</literalValue>
        <name>SomDig_Mindestpreis-TKP unterschritten</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Mn2help</fullName>
        <description>Mn2Help-Feld am CampaignItem via Workflow/Feldaktualisierung befüllen anhand Feldwert aus AmountNetNet, um mit dem Help-Feld Formeln für nCPM und eCPM erstellen zu können (da sonst Zeichenanzahl zu groß)</description>
        <field>SomDig_Mn2Help__c</field>
        <formula>ADvendio__Amount_net_net__c</formula>
        <name>MN2 help</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_MotivEingebucht</fullName>
        <description>Checkbox wird beim Klonen auf &apos;FALSE&apos; gesetzt</description>
        <field>SomDig_MotivEingebucht__c</field>
        <literalValue>0</literalValue>
        <name>SomDig Motiv Eingebucht</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_NonMedia</fullName>
        <field>SomDig_NonMedia__c</field>
        <formula>IF(SomDig_MediagattungsSegmentName__c =&quot;NonMedia&quot; 
, &quot;ja&quot; 
, &quot;nein&quot;)</formula>
        <name>SomDig_NonMedia</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_OSI</fullName>
        <description>schreibt den Wert von Leistungskennzahl als Typ &apos;%&apos;</description>
        <field>SomDig_OSIcustom__c</field>
        <formula>IF(ADvendio__PerformanceIndicator__c &lt;= 1, ADvendio__PerformanceIndicator__c, 1)</formula>
        <name>SomDig_OSI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_OSI_Vortag</fullName>
        <description>rechnet OSI vom Vortag</description>
        <field>SomDig_LeistungskennzahlVortag__c</field>
        <formula>ADvendio__PerformanceIndicator__c</formula>
        <name>OSI Vortag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Positionsabschlag_Natural</fullName>
        <description>KV 2702. Setzt Aufschlag B3(%) auf -100%.</description>
        <field>ADvendio__SurchargeB3__c</field>
        <formula>-1</formula>
        <name>SomDig Positionsabschlag Natural</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Positionsabschlag_Natural_weg</fullName>
        <description>KV 2702. Nullt Aufschlag B3(%).</description>
        <field>ADvendio__SurchargeB3__c</field>
        <name>SomDig Positionsabschlag Natural weg</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_RabattGenehmigt</fullName>
        <description>das Kontrolkästchen wird auf &apos;TRUE&apos; gesetzt wenn Rabatt den Limit übeschritten hat</description>
        <field>SomDig_RabattlimitUnterschritten__c</field>
        <literalValue>1</literalValue>
        <name>SomDig_Rabatt genehmigt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_RabattZuruecksetzen</fullName>
        <description>setzt nach der Beendigung des Approval-Prozesses das Kontrollkästchen wieder auf &apos;FALSE&apos;</description>
        <field>SomDig_RabattlimitUnterschritten__c</field>
        <literalValue>0</literalValue>
        <name>SomDig_Rabatt zurücksetzen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_RabatteFreigegebenCheck</fullName>
        <description>Hilfsfeld; wird aktiviert, wenn Rabattlimit/Mindestpreis unterschritten oder nicht genehmigt (eins von beiden)</description>
        <field>SomDig_RabatteFreigegebenCheck__c</field>
        <literalValue>1</literalValue>
        <name>SomDig_Rabatte Freigegeben</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_RabatteFreigegebenZuruecksetzen</fullName>
        <description>deaktiviert Kontrolkästchen, falls genehmigt oder unter Limit</description>
        <field>SomDig_RabatteFreigegebenCheck__c</field>
        <literalValue>0</literalValue>
        <name>SomDig_Rabatte freigegeben zuruecksetzen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_ResetAdID</fullName>
        <description>KV 03344. Wenn die AdID geleert wird, wird der alte Wert wieder reingeschrieben.</description>
        <field>ADvendio__Ad_Id__c</field>
        <formula>PRIORVALUE( ADvendio__Ad_Id__c )</formula>
        <name>SomDig_ResetAdID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_SetLastAdServerStatusChange</fullName>
        <description>KV 01371. Setzt das Feld SomDig_LastAdServerStatusChange auf das jetzige Datum.</description>
        <field>SomDig_LastAdServerStatusChange__c</field>
        <formula>NOW()</formula>
        <name>SomDig_SetLastAdServerStatusChange</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_SetLastDurationChange</fullName>
        <description>KV 01371. Setzt das Feld SomgDig_LastDurationChange__c bei Änderung des Start oder Enddatums auf das jetzige Datum.</description>
        <field>SomgDig_LastDurationChange__c</field>
        <formula>NOW()</formula>
        <name>SetLastDurationChange</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_SetOptimizationActivationDate</fullName>
        <description>KV 03421. Setzt das Feld &quot;SomDig_LastOptimizationActivationDate__c&quot; auf das jetzige Datum, wenn eine Position im Auftragsstatus erstellt wird.</description>
        <field>SomDig_LastOptimizationActivationDate__c</field>
        <formula>NOW()</formula>
        <name>SomDig_SetOptimizationActivationDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_SetZuletztGenehmigt</fullName>
        <description>KV 01741. Setzt &quot;SomDig_MindestpreisZuletztGenehmigt__c&quot; auf jetzt, wenn genehmigt wurde.</description>
        <field>SomDig_MindestpreisZuletztGenehmigt__c</field>
        <formula>now()</formula>
        <name>SomDig_SetZuletztGenehmigt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_SonderrabattHundertProzent</fullName>
        <description>MN2-Wert der Mediakampagne soll bei diversen Auftragstypen immer 0 ,- EUR sein. Daher Lösung durch Sonderrabatt in Höhe von 100 %, damit MN1 genullt wird.</description>
        <field>ADvendio__Rate_Discount_4__c</field>
        <formula>1</formula>
        <name>SomDig Sonderrabatt Hundert Prozent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_SonderrabattStorno</fullName>
        <description>KV 02453. Setzt das Feld Sonderrabatt (Name) auf &quot;Storno ohne Leistungsfluss&quot;, wenn die Position im Optimizer gecancelt wird.</description>
        <field>ADvendio__Rate_Discount_4_Name__c</field>
        <literalValue>Storno ohne Leistungsfluss</literalValue>
        <name>SomDig_SonderrabattStorno</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_SonderrabattZahlNull</fullName>
        <description>Wenn Naturalrabatt ausgewählt, soll hier in KampagnePosition kein Wert stehen (Feld leer); wird über Abschlag MB3 zu MB1 geregelt und nicht via 100 % SR</description>
        <field>ADvendio__Rate_Discount_4__c</field>
        <formula>0.00</formula>
        <name>SomDig Sonderrabatt Zahl Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_StatusAuslieferungAtRisk</fullName>
        <description>Es wird weniger geliefert als täglich vorgesehen ist - Position läuft &quot;@risk&quot;</description>
        <field>SomDig_PositionStatus__c</field>
        <literalValue>Auslieferung-@Risk</literalValue>
        <name>SomDig Status &apos;Auslieferung-@risk&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_StatusAuslieferungNormal</fullName>
        <description>AdServer meldet Leistung</description>
        <field>SomDig_PositionStatus__c</field>
        <literalValue>Auslieferung-normal</literalValue>
        <name>SomDig Status &apos;Auslieferung-normal&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_StatusBereit</fullName>
        <description>Werbemittel sind im AdServer eingebucht und aktiviert</description>
        <field>SomDig_PositionStatus__c</field>
        <literalValue>bereit</literalValue>
        <name>SomDig Status &apos;Bereit&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_StatusEntwurf</fullName>
        <description>bei allen neu erzeugten, bzw. geklonnten LIs muß der Status &quot;Entwurf&quot; stehen</description>
        <field>SomDig_PositionStatus__c</field>
        <literalValue>Entwurf</literalValue>
        <name>SomDig Status Entwurf</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_StatusInaktiv</fullName>
        <description>setzt Position-Status auf &apos;Inaktiv&apos; wenn Motiv nicht eingebucht ist.</description>
        <field>SomDig_PositionStatus__c</field>
        <literalValue>Inaktiv</literalValue>
        <name>SomDig Status &apos;Inaktiv&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_StatusPausiert</fullName>
        <description>setzt PAM Status auf &apos;Pausiert&apos;, wenn AdServer Status &apos;pausiert&apos; ist</description>
        <field>SomDig_PositionStatus__c</field>
        <literalValue>pausiert</literalValue>
        <name>SomDig Status &apos;pausiert&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Status_NonAdServer</fullName>
        <description>setzt Status auf  &apos;NonAdServer&apos;, falls Produktion erforderlich</description>
        <field>SomDig_PositionStatus__c</field>
        <literalValue>NonAdServer</literalValue>
        <name>SomDig Status &apos;NonAdServer&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Status_beendet_erf_llt</fullName>
        <description>Position ausgelaufen und erfüllt</description>
        <field>SomDig_PositionStatus__c</field>
        <literalValue>abgelaufen-erfüllt</literalValue>
        <name>SomDig Status &apos;beendet/erfüllt&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Status_beendet_unterliefert</fullName>
        <description>Position ausgelaufen und hat unterliefert</description>
        <field>SomDig_PositionStatus__c</field>
        <literalValue>abgelaufen-unterliefert</literalValue>
        <name>SomDig Status &apos;beendet/unterliefert&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_StrukturierteUeberlieferung</fullName>
        <description>Die strukturierte Überlieferung, welche am Werbemittel hinterlegt wird, soll nicht bei jedem Auftragstyp greifen. Daher in diesen Fällen das Feld ADvendio__Total_Impressions__c befüllen, da dieser Wert an den Adserver übergeben wird.</description>
        <field>ADvendio__Total_Impressions__c</field>
        <formula>ADvendio__Quantity__c</formula>
        <name>SomDig Strukturierte Überlieferung</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Verteilung_Betrag</fullName>
        <field>ADvendio__DistributionUnit__c</field>
        <literalValue>Amount</literalValue>
        <name>SomDig_Verteilung_Betrag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_WerbeformAuslesen</fullName>
        <field>SomDig_Werbeform__c</field>
        <formula>ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__Ad_Type__r.Name</formula>
        <name>Werbeform auslesen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ADvendio__Deactivate Campaign Item for Billing</fullName>
        <actions>
            <name>ADvendio__Deactivate_Campaign_Item_for_Billing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow deactivates a campaign item, so it can&apos;t be found by the Billing &amp; Accounting module.</description>
        <formula>ADvendio__ConnectedItem__c != null</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ADvendio__Distribution-Unit %3D Amount for Fixed prices</fullName>
        <actions>
            <name>ADvendio__DistributionUnitAmountForFixedPrices</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() &amp;&amp;  ISBLANK( TEXT( ADvendio__DistributionUnit__c ) ) &amp;&amp;  (   TEXT(ADvendio__Billing_category__c) = &quot;allin&quot; ||   TEXT(ADvendio__Billing_category__c) = &quot;Fixed Price&quot; ||   TEXT(ADvendio__Billing_category__c) = &quot;CPD&quot; ||   TEXT(ADvendio__Billing_category__c) = &quot;CPW&quot; ||   TEXT(ADvendio__Billing_category__c) = &quot;CPMo&quot; ||   TEXT(ADvendio__Billing_category__c) = &quot;CPY&quot; ||   TEXT(ADvendio__Billing_category__c) = &quot;edition&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ADvendio__ExcludeCheckAvailabilityWithAdTypes</fullName>
        <actions>
            <name>ADvendio__QueryInventoryFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Ad Type is Sponsorship, InHouse or Network -&gt; Query Inventory is false.</description>
        <formula>ISPICKVAL(ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__Ad_Type__r.ADvendio__Adtype__c,  &quot;InHouse&quot; )  || ISPICKVAL(ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__Ad_Type__r.ADvendio__Adtype__c,&quot;Sponsorship&quot; )  ||  ISPICKVAL(ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__Ad_Type__r.ADvendio__Adtype__c,&quot;Network&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ADvendio__Reset Availability</fullName>
        <actions>
            <name>ADvendio__ResetAvailability</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Reset the availability if some fields are changed.</description>
        <formula>OR(ISCHANGED(ADvendio__AdDayOfWeek__c),    ISCHANGED(ADvendio__AdHourOfDay__c),    ISCHANGED(ADvendio__AdKeyValues__c),    ISCHANGED(ADvendio__AdKeyWords__c),    ISCHANGED(ADvendio__AdOperatingSystems__c),    ISCHANGED(ADvendio__AdWebBrowsers__c),    ISCHANGED(ADvendio__FC_Ad_served_every__c),    ISCHANGED(ADvendio__FC_Period__c),    ISCHANGED(ADvendio__FC_Quantity__c),    ISCHANGED(ADvendio__from_Date__c),    ISCHANGED(ADvendio__Guaranteed_AI__c),    ISCHANGED(ADvendio__Priority__c),    ISCHANGED(ADvendio__Quantity__c),    ISCHANGED(ADvendio__Targetingabbrevation__c),    ISCHANGED(ADvendio__until_Date__c)      )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ADvendio__Reset_LinearDistribution</fullName>
        <actions>
            <name>ADvendio__Set_LinearDistributionFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4</booleanFilter>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__DeliveredClicksManual__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__DeliveredAIsManual__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__InvoiceQuantityManual__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__AvAsViewableAiManual__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow sets the linear distribution flag to false if manual data has been entered.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ADvendio__Set CPM Price</fullName>
        <actions>
            <name>ADvendio__SetCPMPrice</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__Billing_category__c</field>
            <operation>equals</operation>
            <value>CPM,vCPM</value>
        </criteriaItems>
        <description>This Workflow sets depending on Billing Category the checkbox IsCPMPrice.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ADvendio__Set_LinearDistribution</fullName>
        <actions>
            <name>ADvendio__Set_LinearDistributionTrue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND (3 OR 4 OR 5 OR 6)</booleanFilter>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Print Standard</value>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__Billing_category__c</field>
            <operation>notEqual</operation>
            <value>CPM,CPC,vCPM</value>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__DeliveredAIsManual__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__DeliveredClicksManual__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__AvAsViewableAiManual__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__InvoiceQuantityManual__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>This workflow sets the linear distribution flag to true if  the record type = Print Standard OR Billing Category != CPM, CPC, vCPM AND no manual data has been entered.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Clear FC Anzahl Periode</fullName>
        <actions>
            <name>SomDig_ClearFCAnzahlPeriode</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__FC_Period__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__FC_Quantity__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Default FC Anzahl Periode</fullName>
        <actions>
            <name>SomDig_Default_FC_Anzahl_Periode</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__FC_Period__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__FC_Quantity__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SetCampaignToClosedWon</fullName>
        <actions>
            <name>SetCampaignToClosedWon</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>KV 2795. Wenn AdID befüllt wird (beim durchbuchen), setze die Media Kampagne auf Geschlossen &amp; Gewonnen.</description>
        <formula>ADvendio__Ad_Id__c != null &amp;&amp;  PRIORVALUE(ADvendio__Ad_Id__c) == null</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SetSubmittoAdServerTrue</fullName>
        <actions>
            <name>SetSubmittoAdServerTrue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__Submit_to_AdServer__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Adserver Name</fullName>
        <actions>
            <name>SomDig_AdserverName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Befüllung Feld mit [Kampagnennummer]_[Positionsname]_[Positionsnummer]. Wenn das Feld befüllt ist, wird der Inhalt für den Namen im AdServer verwendet (sollte die Regel sein); wenn es leer ist, wird der Name der KampagnenPosition verwendet (siehe KV 1799)</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Agenturprovision falsch</fullName>
        <actions>
            <name>SomDig_AgenturprovisionFalsch</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Bei diversen Auftragstypen soll keine Agenturprovision (AE) voreingestellt sein bei allen Positionen der entsprechenden Mediakampagnen. Einstellung/Steuerung erfolgt via des Feldes &quot;Agenturprovision&quot; am Objekt &quot;Auftragstyp&quot;</description>
        <formula>ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_Agenturprovision__c = FALSE &amp;&amp;  ISNULL(ADvendio__ConnectedItem__c) &amp;&amp; ADvendio__Quantity__c &gt;0</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SomDig FC Eigenwerbung Abrechnungsmodell</fullName>
        <actions>
            <name>SomDig_FcAnzahlPeriodeEins</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_FcMengeDrei</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_FcPeriodeTag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Setzt den FC für Auftragstyp &quot;Eigenwerbung&quot; bei allen Positionen (aber nur, wenn kein FC am Werbemittel gepflegt ist, dies sticht den Auftragstyp von der Hierarchie)</description>
        <formula>ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.Name = &quot;Eigenwerbung&quot;
 &amp;&amp; 
OR(
 ISBLANK( ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__FC_Quantity__c ), 
 ISBLANK( ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__FC_Ad_served_every__c ), 
 ISPICKVAL( ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__FC_Period__c , &quot;&quot;)
)
&amp;&amp; 
(
 ISBLANK( ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_FcAbrechnungsmodell__c) 
 || 
(INCLUDES( ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_FcAbrechnungsmodell__c ,&quot;CPM&quot;) &amp;&amp; TEXT( ADvendio__Billing_category__c ) =&quot;CPM&quot;) 
 || 
(INCLUDES( ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_FcAbrechnungsmodell__c ,&quot;CPC&quot;) &amp;&amp; TEXT( ADvendio__Billing_category__c ) =&quot;CPC&quot;) 
 || 
(INCLUDES( ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_FcAbrechnungsmodell__c ,&quot;CPD&quot;) &amp;&amp; TEXT( ADvendio__Billing_category__c ) =&quot;CPD&quot;) 
 ||
(INCLUDES( ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_FcAbrechnungsmodell__c ,&quot;CPW&quot;) &amp;&amp; TEXT( ADvendio__Billing_category__c ) =&quot;CPW&quot;)  
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomDig FC Forschung Abrechnungsmodell</fullName>
        <actions>
            <name>SomDig_FcAnzahlPeriodeEins</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_FcMengeZwei</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_FcPeriodeLaufzeit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Setzt den FC für Auftragstyp &quot;Forschung&quot; bei allen Positionen (aber nur, wenn kein FC am Werbemittel gepflegt ist, dies sticht den Auftragstyp von der Hierarchie)</description>
        <formula>ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.Name = &quot;Forschung&quot;
 &amp;&amp; 
OR(
 ISBLANK( ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__FC_Quantity__c ), 
 ISBLANK( ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__FC_Ad_served_every__c ), 
 ISPICKVAL( ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__FC_Period__c , &quot;&quot;)
)
&amp;&amp; 
( 
ISBLANK( ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_FcAbrechnungsmodell__c) 
|| 
(INCLUDES( ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_FcAbrechnungsmodell__c ,&quot;CPM&quot;) &amp;&amp; TEXT( ADvendio__Billing_category__c ) =&quot;CPM&quot;) 
|| 
(INCLUDES( ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_FcAbrechnungsmodell__c ,&quot;CPC&quot;) &amp;&amp; TEXT( ADvendio__Billing_category__c ) =&quot;CPC&quot;) 
|| 
(INCLUDES( ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_FcAbrechnungsmodell__c ,&quot;CPD&quot;) &amp;&amp; TEXT( ADvendio__Billing_category__c ) =&quot;CPD&quot;) 
|| 
(INCLUDES( ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_FcAbrechnungsmodell__c ,&quot;CPW&quot;) &amp;&amp; TEXT( ADvendio__Billing_category__c ) =&quot;CPW&quot;) 
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomDig FC Performance Abrechnungsmodell</fullName>
        <actions>
            <name>SomDig_FcAnzahlPeriodeEins</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_FcMengeDrei</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_FcPeriodeSession</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Setzt den FC für Auftragstyp &quot;Performance&quot; bei allen CPC-Positionen (aber nur, wenn kein FC am Werbemittel gepflegt ist, dies sticht den Auftragstyp von der Hierarchie)</description>
        <formula>ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.Name = &quot;Performance&quot; 
 &amp;&amp; 
OR( 
ISBLANK( ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__FC_Quantity__c ), 
ISBLANK( ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__FC_Ad_served_every__c ), 
ISPICKVAL( ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__FC_Period__c , &quot;&quot;) 
)
&amp;&amp; 
( 
ISBLANK( ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_FcAbrechnungsmodell__c) 
|| 
(INCLUDES( ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_FcAbrechnungsmodell__c ,&quot;CPM&quot;) &amp;&amp; TEXT( ADvendio__Billing_category__c ) =&quot;CPM&quot;) 
|| 
(INCLUDES( ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_FcAbrechnungsmodell__c ,&quot;CPC&quot;) &amp;&amp; TEXT( ADvendio__Billing_category__c ) =&quot;CPC&quot;) 
|| 
(INCLUDES( ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_FcAbrechnungsmodell__c ,&quot;CPD&quot;) &amp;&amp; TEXT( ADvendio__Billing_category__c ) =&quot;CPD&quot;) 
|| 
(INCLUDES( ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_FcAbrechnungsmodell__c ,&quot;CPW&quot;) &amp;&amp; TEXT( ADvendio__Billing_category__c ) =&quot;CPW&quot;) 
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Geklonte Position</fullName>
        <actions>
            <name>SomDig_MotivEingebucht</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Bei geklonten Positionen müssen bestimmte Feldwerte zurück gesetzt werden.</description>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Nullwert Mediakampagne</fullName>
        <actions>
            <name>SomDig_SonderrabattHundertProzent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>MN2-Wert der Mediakampagne soll bei diversen &quot;Auftragstypen&quot; immer 0 ,- EUR sein. Daher Lösung durch Sonderrabatt in Höhe von 100 %. Steuerung erfolgt via des Feldes &quot;Nullwert MK&quot; am Objekt &quot;Auftragstyp&quot;</description>
        <formula>ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_NullwertMediakampagne__c = TRUE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Positionsrabatt Natural entfernen</fullName>
        <actions>
            <name>SomDig_Agenturprovision_15</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_Agenturrabatt</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_Kundenrabatt</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_Positionsabschlag_Natural_weg</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Wenn in einem Campaign Item (Kampagne Position) ein Sonderrabatt mit dem Namen &quot;Positionsrabatt Natural&quot; entfernt wird, wird der Abschlag entfernt</description>
        <formula>NOT(ISPICKVAL( ADvendio__Rate_Discount_4_Name__c , &quot;Positionsrabatt Natural&quot;)) &amp;&amp;  NOT(ISPICKVAL( ADvendio__Rate_Discount_4_Name__c , &quot;Storno ohne Leistungsfluss&quot;)) &amp;&amp;  ISCHANGED(ADvendio__Rate_Discount_4_Name__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Positionsrabatt Natural hinzufügen</fullName>
        <actions>
            <name>SomDig_AE_deaktiviert</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_Agenturprovision_keine</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_AgenturrabattZahlNull</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_KundenrabattZahlNull</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_Positionsabschlag_Natural</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_SonderrabattZahlNull</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Wenn in einem Campaign Item (Kampagne Position) ein Sonderrabatt mit dem Namen &quot;Positionsrabatt Natural&quot; ausgewählt wird, soll der MB1 autom. auf 0 EUR gesetzt werden (Text wird autom. in Positionskommentar befüllt)</description>
        <formula>ISPICKVAL( ADvendio__Rate_Discount_4_Name__c , &quot;Positionsrabatt Natural&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig Strukturierte Überlieferung</fullName>
        <actions>
            <name>SomDig_StrukturierteUeberlieferung</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Die strukturierte Überlieferung, welche am Werbemittel hinterlegt wird, soll nicht bei jedem Auftragstyp greifen. Daher in diesen Fällen das Feld ADvendio__Total_Impressions__c befüllen (=100%), da dieser Wert an den Adserver übergeben wird.</description>
        <formula>ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.SomDig_StrukturierteUeberlieferung__c = FALSE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_Abrechnungsmodel CPC</fullName>
        <actions>
            <name>SomDig_Abrechnungsmodell_CPC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__Billing_category__c</field>
            <operation>equals</operation>
            <value>CPC</value>
        </criteriaItems>
        <description>Für das Abrechnungsmodell CPC werden die Impressiondatenfelder durch jeweiligen Clickdatenfelder ersetzt.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_AdServerOrderId</fullName>
        <actions>
            <name>SomDig_AdServerOrderId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>überträgt AdServer-Order-Id auf Kampagne;
vorausgesetzt - alle Positionen sind mit dem gleichen (DFP) AdServer verlinkt! (Positionen, die nicht mit DFP verlinkt sind (AdServerId leer) werden dabei nicht berücksichtigt.</description>
        <formula>NOT(ISBLANK(ADvendio__Adserver_ID_Order_ID__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_AdSpec</fullName>
        <actions>
            <name>SomDig_AdSpec</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Füllt das Feld SomDig_AdSpec__c</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_ClearTotalImpressions</fullName>
        <actions>
            <name>SomDig_ClearTotalImpressions</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>KV 03472: Wenn das Feld &quot;ADvendio__Total_Impressions__c&quot; = 0, dann wird es geleert, damit der Fehler &quot;Division by 0&quot; nicht mehr auftritt.</description>
        <formula>ADvendio__Total_Impressions__c = 0 &amp;&amp; RecordType.Name = &apos;Packet&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_DWH Geschäftsart</fullName>
        <actions>
            <name>SomDig_DWHGeschaeftsart</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>setzt DWH Auftragsart Code (mit/ohne Commitment, bei Eigenwerbung nur &apos;ohne Commitment&apos;)</description>
        <formula>OR( 
ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.Name = &quot;Standard&quot;,
ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.Name = &quot;Barter&quot;,
ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.Name = &quot;Eigenwerbung&quot;,
ADvendio__Media_Campaign__r.ADvendio__Pricelist__r.SomDig_AuftragstypId__r.Name = &quot;Performance&quot;
 )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_Durchbuchung 1</fullName>
        <actions>
            <name>SomDig_Durchbuchung1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Kontrolkästchen wird per FU befüllt, wenn bestimmte Felder verändert sind, aber die Position nach der Veränderung noch nicht im AdServer gebucht ist</description>
        <formula>AND(NOT(ISPICKVAL(SomDig_PositionStatus__c,&quot;NonAdServer&quot;)), OR(AND(ADvendio__Media_Campaign__r.ADvendio__Propability__c =1, ISBLANK(ADvendio__LastBookingProcess__c)), ISCHANGED(ADvendio__from_Date__c), ISCHANGED(ADvendio__until_Date__c), ISCHANGED(ADvendio__Quantity__c), ISCHANGED(Name), ISCHANGED(ADvendio__Sales_Price__c), ISCHANGED(ADvendio__Priority__c), ISCHANGED(ADvendio__FC_Quantity__c), ISCHANGED(ADvendio__FC_Period__c), ISCHANGED(ADvendio__Billing_category__c) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_Durchbuchung 2</fullName>
        <actions>
            <name>SomDig_Durchbuchung2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Das Kontrollkästchen wird per FU zurückgesetzt, wenn &quot;Letzte Buchung&quot; verändert ist.</description>
        <formula>ISCHANGED(ADvendio__LastBookingProcess__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_Festplatzierung</fullName>
        <actions>
            <name>SomDig_KampagnePosition_Exklusiv</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_KampagnenPosition_AdType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__Billing_category__c</field>
            <operation>equals</operation>
            <value>CPD</value>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__Billing_category__c</field>
            <operation>equals</operation>
            <value>CPW</value>
        </criteriaItems>
        <description>Wenn die Abrechnungsart in der Mediakampagne CPD oder CPW ist, wird der Haken im Feld Exklusiv gesetzte (damit CampaignItem im Belegungsplan erscheint) und der AdType wird zudem auf Sponsorship gesetzt</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_GesamtrabattKonsekutiv</fullName>
        <actions>
            <name>SomDig_GesamtrabattKonsekutiv</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() || ISCHANGED(SomDig_GesamtrabattKonsekutiv__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_InhouseProduktion</fullName>
        <actions>
            <name>SomDig_InhouseProduktion</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Das Kontrolkästche wird befüllt, wenn XXL Flashlayer, Wrap oder sonstige Werbeformen, die ausschließlich intern produziert müssen, ausgewählt sind.</description>
        <formula>ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__Ad_Type__r.SomDig_InhouseProduktion__c = TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_Kampagnennummer an Adserver</fullName>
        <actions>
            <name>SomDig_KampagnennummerAnAdserver</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Die Mediakampagnennummer soll an den Adserver übertragen werden. Hierfür wird per Feldaktualisierung das Positions-Feld ADvendio__AlternateId__c mit der Kampagnennummer befüllt und an Adserver als &quot;PONumber&quot; übergeben (siehe KV 1597)</description>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_LineareVerteilung</fullName>
        <actions>
            <name>SomDig_Lineare_Verteilung</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Setzt die Positions-Checkbox &quot;Lineare Vertilung&quot; auf WAHR, wenn es sich um NonAdserver-Produkte handelt (wird anhand Datensatztyp Werbeform ermittelt)</description>
        <formula>OR( ADvendio__Ad_Price__r.ADvendio__Ad_Spec__r.ADvendio__Ad_Type__r.RecordType.Name = &quot;Standard&quot;, ISPICKVAL(ADvendio__Billing_category__c, &apos;CPD&apos;),  ISPICKVAL(ADvendio__Billing_category__c, &apos;CPW&apos;), ISPICKVAL(ADvendio__Billing_category__c, &apos;CPMo&apos;), ISPICKVAL(ADvendio__Billing_category__c, &apos;CPY&apos;), ISPICKVAL(ADvendio__Billing_category__c, &apos;Fixed Price&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_Mindestpreis-TKP unterschritten</fullName>
        <actions>
            <name>SomDig_MindestpreisTKPUnterschritten</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>setzt Checkbox auf &apos;TRUE&apos; wenn eTKP&lt; Mindestpreis</description>
        <formula>AND(ISPICKVAL(ADvendio__Billing_category__c,&quot;CPM&quot;), CONTAINS(SomDig_MediagattungsDifferenzierungName__c, &quot;Video&quot;), NOT(ISBLANK(SomDig_MinCPMPrice__c)), SomDig_Ecpm__c &lt; SomDig_MinCPMPrice__c, ISBLANK( SomDig_MindestpreisZuletztGenehmigt__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_MindestpreisTKP - zurücksetzen</fullName>
        <actions>
            <name>SomDig_MindestTKPZuruecksetzen</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>setzt Checkbox auf &apos;FALSE&apos; wenn Mindest eTKP &gt;= Mindestpreis</description>
        <formula>AND(ISPICKVAL(ADvendio__Billing_category__c,&quot;CPM&quot;), CONTAINS(SomDig_MediagattungsDifferenzierungName__c, &quot;Video&quot;), NOT(ISBLANK(SomDig_MinCPMPrice__c)), ISCHANGED( ADvendio__Amount_net_net__c), SomDig_Ecpm__c &gt;= SomDig_MinCPMPrice__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_Mn2Help</fullName>
        <actions>
            <name>SomDig_Mn2help</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Mn2Help-Feld am CampaignItem via Workflow/Feldaktualisierung befüllen anhand Feldwert aus AmountNetNet, um mit dem Help-Feld Formeln für nCPM und eCPM erstellen zu können (da sonst Zeichenanzahl zu groß)</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_NonMedia</fullName>
        <actions>
            <name>SomDig_NonMedia</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( SomDig_MediagattungsSegmentName__c ) 
|| 
ISBLANK(SomDig_NonMedia__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_OSI</fullName>
        <actions>
            <name>SomDig_OSI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__Billing_category__c</field>
            <operation>equals</operation>
            <value>CPM</value>
        </criteriaItems>
        <description>schreibt den Wert von Leistungskennzahl als Typ &apos;%&apos;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_ResetAdID</fullName>
        <actions>
            <name>SomDig_ResetAdID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>KV 03344. Wenn die AdID geleert wird, wird der alte Wert wieder reingeschrieben.</description>
        <formula>ISBLANK(PRIORVALUE(ADvendio__Ad_Id__c)) = false &amp;&amp; ISBLANK(ADvendio__Ad_Id__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_SetLastAdServerStatusChange</fullName>
        <actions>
            <name>SomDig_SetLastAdServerStatusChange</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>KV 01371. Setzt das Feld SomDig_LastAdServerStatusChange auf der Kampagnenposition, wenn sich der AdServer-Status ändert und nicht von leer auf Active gewechselt ist.</description>
        <formula>ISCHANGED(ADvendio__AdserverStatus__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_SetLastDurationChange</fullName>
        <actions>
            <name>SomDig_SetLastDurationChange</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>KV 01371. Setzt das Feld SomgDig_LastDurationChange__c auf das jetzige Datetime, sobald das Start oder Enddatum geändert wird.</description>
        <formula>ISCHANGED(ADvendio__until_Date__c)  || ISCHANGED( ADvendio__from_Date__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_SetOptimizationActivationDate</fullName>
        <actions>
            <name>SomDig_SetOptimizationActivationDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ADvendio__MediaCampaign__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Auftrag</value>
        </criteriaItems>
        <description>KV 03421. Setzt das Feld &quot;SomDig_LastOptimizationActivationDate__c&quot; auf das jetzige Datum, wenn eine Position im Auftragsstatus erstellt wird.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_SonderrabattStorno</fullName>
        <actions>
            <name>SomDig_AdStatusStorno</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_SonderrabattStorno</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__Rate_Discount_4_Name__c</field>
            <operation>notEqual</operation>
            <value>Storno ohne Leistungsfluss</value>
        </criteriaItems>
        <criteriaItems>
            <field>ADvendio__Campaign_Item__c.ADvendio__OptimizationExclusion__c</field>
            <operation>equals</operation>
            <value>Diese Kampagnenposition wurde bereits optimiert. Bitte optimieren Sie die aktuellste Version dieser Kampagnenposition.</value>
        </criteriaItems>
        <description>KV 02453. Setzt das Feld Sonderrabatt (Name) auf &quot;Storno ohne Leistungsfluss&quot;, wenn die Position im Optimizer gecancelt wird. (deprecated, wird mit Trigger gelöst)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_Verteilung Betrag</fullName>
        <actions>
            <name>SomDig_Verteilung_Betrag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>aktualisiert das Feld &quot;Verteilung (Einheit)&quot; auf den Wert &quot;Betrag&quot; bei Festpreisen</description>
        <formula>(   ISNEW() ||   ISCHANGED( ADvendio__Billing_category__c ) ||   ISCHANGED( ADvendio__LinearDistribution__c ) ) &amp;&amp; ADvendio__LinearDistribution__c = TRUE &amp;&amp; TEXT( ADvendio__Billing_category__c ) = &apos;Fixed Price&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_WerbeformAuslesen</fullName>
        <actions>
            <name>SomDig_WerbeformAuslesen</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>über WM-Preis auf WM</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
