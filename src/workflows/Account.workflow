<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Benachrichtige_Account_Ersteller_nach_Pr_fung</fullName>
        <description>Benachrichtige Account Ersteller nach Prüfung</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Som/Som_CRM_Account_geprueft</template>
    </alerts>
    <alerts>
        <fullName>Benachrichtigung_Faktura_nderung</fullName>
        <ccEmails>sosalesforce@sevenonemedia.de</ccEmails>
        <description>Benachrichtigung Faktura Änderung</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>SomTv/SomTv_zuUeberpruefenFakturaAcc</template>
    </alerts>
    <alerts>
        <fullName>SomTv_AccAnfDebitor2Std</fullName>
        <ccEmails>71msostammdaten@71m.de</ccEmails>
        <description>SomTv_AccAnfDebitor2Std</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>SomTv/SomTv_AccAnfDebitorId</template>
    </alerts>
    <alerts>
        <fullName>SomTv_AccAnfProSediId2Std</fullName>
        <ccEmails>71msostammdaten@71m.de</ccEmails>
        <description>SomTv_AccAnfProSediId2Std</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>SomTv/SomTv_AccAnfProSediId</template>
    </alerts>
    <alerts>
        <fullName>SomTv_AccNameDebNummerExistiert</fullName>
        <description>SomTv_AccNameDebNummerExistiert</description>
        <protected>false</protected>
        <recipients>
            <recipient>sara.helleisz@prosiebensat1.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SomTv/SomTv_AccDebNrExistiert</template>
    </alerts>
    <alerts>
        <fullName>Som_AccountGueltigAbsage</fullName>
        <description>Som_AccountGueltigAbsage</description>
        <protected>false</protected>
        <recipients>
            <recipient>bruno.meier@sevenonemedia.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>christian.joentgen@sevenonemedia.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>juliana.hoang@prosiebensat1puls4.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>martin.unsinn@sevenonemedia.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sara.helleisz@prosiebensat1.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Som/Som_AccountGueltigAbsage</template>
    </alerts>
    <alerts>
        <fullName>Som_AccountGueltigZusage</fullName>
        <description>Som_AccountGueltigZusage</description>
        <protected>false</protected>
        <recipients>
            <recipient>bruno.meier@sevenonemedia.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>christian.joentgen@sevenonemedia.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>juliana.hoang@prosiebensat1puls4.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>martin.unsinn@sevenonemedia.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sara.helleisz@prosiebensat1.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Som/Som_AccountGueltigZusage</template>
    </alerts>
    <alerts>
        <fullName>Som_AccountUngueltigAbsage</fullName>
        <description>Som_AccountUngueltigAbsage</description>
        <protected>false</protected>
        <recipients>
            <recipient>bruno.meier@sevenonemedia.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>christian.joentgen@sevenonemedia.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>juliana.hoang@prosiebensat1puls4.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>martin.unsinn@sevenonemedia.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sara.helleisz@prosiebensat1.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Som/Som_AccountUngueltigAbsage</template>
    </alerts>
    <alerts>
        <fullName>Som_AccountUngueltigZusage</fullName>
        <description>Som_AccountUngueltigZusage</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>bruno.meier@sevenonemedia.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>christian.joentgen@sevenonemedia.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>juliana.duhnsen@sevenventures.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>juliana.hoang@prosiebensat1puls4.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>marcel.woehrle@sevenventures.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>martin.unsinn@sevenonemedia.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sara.helleisz@prosiebensat1.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Som/Som_AccountUngueltigZusage</template>
    </alerts>
    <alerts>
        <fullName>Ven_Benachrichtigung_nach_Leadkonversion</fullName>
        <description>Ven_Benachrichtigung nach Leadkonversion</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Benachrichtigung_nach_Leadkonversion</template>
    </alerts>
    <alerts>
        <fullName>Ven_Inhaberschaft_von_Ventures_Account_ge_ndert</fullName>
        <description>Ven_Inhaberschaft von Ventures Account geändert</description>
        <protected>false</protected>
        <recipients>
            <field>Ven_E_Mail_alter_Benutzer__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Account_Inhaberschaft_ge_ndert</template>
    </alerts>
    <fieldUpdates>
        <fullName>ADvendio__UpdateVATIDFlag</fullName>
        <description>Update VATID flag to default if country prefix and vat number is changed.</description>
        <field>ADvendio__VatIdInquiryResults__c</field>
        <name>UpdateVATIDFlag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ADvendio__VATID</fullName>
        <description>Concatenate country prefix and VAT Id and update it to ADvendio_VATID field on account</description>
        <field>ADvendio__VATID__c</field>
        <formula>TEXT(ADvendio__VatIdCountryPrefix__c) + ADvendio__VatIdNumber__c</formula>
        <name>VATID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Genehmigungsstatus_abgelehnt</fullName>
        <field>P7S1_Genehmigungsstatusungueltig__c</field>
        <literalValue>Abgelehnt</literalValue>
        <name>Genehmigungsstatus abgelehnt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Genehmigungsstatus_eingereicht</fullName>
        <field>P7S1_Genehmigungsstatusungueltig__c</field>
        <literalValue>Eingereicht</literalValue>
        <name>Genehmigungsstatus eingereicht</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Genehmigungsstatus_erneut_g_ltig</fullName>
        <field>P7S1_Genehmigungsstatusungueltig__c</field>
        <literalValue>erneut gültig</literalValue>
        <name>Genehmigungsstatus erneut gültig</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Genehmigungsstatus_leeren</fullName>
        <field>P7S1_Genehmigungsstatusungueltig__c</field>
        <name>Genehmigungsstatus leeren</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Genehmigungsstatus_ung_ltig</fullName>
        <field>P7S1_Genehmigungsstatusungueltig__c</field>
        <literalValue>Genehmigt</literalValue>
        <name>Genehmigungsstatus ungültig</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_AccountGueltigDsTyp</fullName>
        <description>Wenn der Haken im Kasten &quot;ungültiger Account&quot; entfernt wird, soll der Datensatztyp &quot;Sonstiger Partner&quot; automatisch gesetzt/aktualisiert werden.</description>
        <field>RecordTypeId</field>
        <lookupValue>sonstiger_Partner</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>P7S1_AccountGueltigDsTyp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_AccountNumberNew</fullName>
        <description>übernimmt neue Accountnummer</description>
        <field>AccountNumber</field>
        <formula>P7S1_AutoNumber__c</formula>
        <name>P7S1_AccountNumberNew</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_AccountNumberUniqueChanged</fullName>
        <description>übernimmt Accountnummer in AccountNumberUnique</description>
        <field>P7S1_AccountNumberUnique__c</field>
        <formula>AccountNumber</formula>
        <name>P7S1_AccountNumberUniqueChanged</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_AccountNumberUniqueNew</fullName>
        <description>übernimmt neue Acountnummer in AccountNumberUnique</description>
        <field>P7S1_AccountNumberUnique__c</field>
        <formula>P7S1_AutoNumber__c</formula>
        <name>P7S1_AccountNumberUniqueNew</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_AccountPruefenSalesSteering</fullName>
        <description>Für Sales Steering. WF &quot;Account zu überprüfen Sales Steering&quot; setzt Haken, wenn ein Account erstellt wurde.</description>
        <field>SomTv_zuUeberpruefenSalesSteeringAcc__c</field>
        <literalValue>1</literalValue>
        <name>Account zu Prüfen Sales Steering</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_AccountUngueltigDsTyp</fullName>
        <description>Wenn der Haken im Kasten &quot;ungültiger Account&quot; gesetzt wird, soll der Datensatztyp &quot;ungültiger Account&quot; automatisch gesetzt/aktualisiert werden.</description>
        <field>RecordTypeId</field>
        <lookupValue>ung_ltiger_Account</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>P7S1_AccountUngueltigDsTyp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_AccountnameDwh</fullName>
        <field>P7S1_NameDwh__c</field>
        <formula>Name</formula>
        <name>P7S1_AccountnameDwh</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_DA_Sales_SetClusterIfEmpty</fullName>
        <description>If Unit = d&amp;a Sales and d&amp;a Sales Cluster = null set d&amp;a Sales Cluster = d&amp;a Sales</description>
        <field>P7S1_DandACluster__c</field>
        <literalValue>d&amp;a Sales</literalValue>
        <name>Set d&amp;a Sales Cluster if empty</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_DWH_ProRexIDChanged</fullName>
        <description>übernimmt Accountnummer ins DWH Feld</description>
        <field>P7S1_DWH_ProRexID__c</field>
        <formula>AccountNumber</formula>
        <name>P7S1_DWH_ProRexIDChanged</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_DWH_ProRexIDNew</fullName>
        <description>übernimmt neue Accountnummer ins DWH Feld</description>
        <field>P7S1_DWH_ProRexID__c</field>
        <formula>P7S1_AutoNumber__c</formula>
        <name>P7S1_DWH_ProRexIDNew</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_NoAutomaticalApproval</fullName>
        <description>Reset Date Time for Automatic Approval</description>
        <field>P7S1_AutomaticalApproval__c</field>
        <name>Remove Automatic Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_Organschaft_False</fullName>
        <field>P7S1_Organschaft__c</field>
        <literalValue>0</literalValue>
        <name>P7S1_Organschaft_False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_RemoveUnitAccess</fullName>
        <description>Entferne die durch Account Freigaben erstellten Freigaben</description>
        <field>P7S1_UnitSharing__c</field>
        <name>Remove Unit Access</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_SetAutomaticApprovalDateTime</fullName>
        <description>Sets the Datetime for the automatical approval on 18 days in future.</description>
        <field>P7S1_AutomaticalApproval__c</field>
        <formula>NOW()+ 18</formula>
        <name>Set automatic approval Date (Today + 18)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_SetMessageforDashboard</fullName>
        <field>P7S1_Dash_Severity__c</field>
        <literalValue>danger</literalValue>
        <name>Set Message for Dashboard</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_SetRecordTypeToCheck</fullName>
        <field>RecordTypeId</field>
        <lookupValue>P7S1_tocheck</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>P7S1_SetRecordTypeToCheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_SpeichereAltenRecordType</fullName>
        <field>P7S1_PreviousRecordTypeId__c</field>
        <formula>CASESAFEID(RecordTypeId)</formula>
        <name>P7S1_SpeichereAltenRecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
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
        <fullName>P7S1_Steuerkennzeichen_A6</fullName>
        <field>P7S1_Steuerkennzeichen__c</field>
        <literalValue>A6</literalValue>
        <name>P7S1_Steuerkennzeichen_A6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_Steuerkennzeichen_AS</fullName>
        <description>füllt Steuerkennzeichen mit AS bzw. A0, abhängig von Konzernmitgliedschaft</description>
        <field>P7S1_Steuerkennzeichen__c</field>
        <literalValue>AS</literalValue>
        <name>P7S1_Steuerkennzeichen_AS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_StoreCurrentRecordTypeId</fullName>
        <field>P7S1_PreviousRecordTypeId__c</field>
        <formula>CASESAFEID(RecordTypeId)</formula>
        <name>P7S1_StoreCurrentRecordTypeId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Setze_Einreicher</fullName>
        <description>Die E-Mail des Users, der den Genehmigungsprozess startet</description>
        <field>P7S1_Submitter4Approval__c</field>
        <formula>$User.Email</formula>
        <name>Setze Einreicher</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTV_Setzt_zu_berpr_fen_Faktura</fullName>
        <field>SomTv_zuUeberpruefenFakturaAcc__c</field>
        <literalValue>1</literalValue>
        <name>Setzt zu überprüfen Faktura</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_AccZuUeberpruefenTrue</fullName>
        <field>SomTv_ZuUeberpruefenAcc__c</field>
        <literalValue>1</literalValue>
        <name>Account zu überprüfen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_CheckDebCheckerEmailVersendet</fullName>
        <field>SomTv_DebCheckerEmailVersendet__c</field>
        <literalValue>1</literalValue>
        <name>SomTv_CheckDebCheckerEmailVersendet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_DebitorennummernStatus</fullName>
        <description>setzt SomTv_Anforderung_Debitorennummer_n__c auf &quot;benötigt&quot;</description>
        <field>SomTv_Anforderung_Debitorennummer_n__c</field>
        <literalValue>benötigt</literalValue>
        <name>SomTv_DebitorennummernStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Som_AccountGueltigSetzen</fullName>
        <description>Account wird auf gültig gesetzt</description>
        <field>ungueltiger_Account__c</field>
        <literalValue>0</literalValue>
        <name>Som_AccountGueltigSetzen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Som_AccountOwner</fullName>
        <description>setzt Inhaber für SomDe/SomAt auf Peter Rozalski</description>
        <field>OwnerId</field>
        <lookupValue>peter.rozalski@prosiebensat1.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Som_AccountOwner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Som_AccountUngueltigSetzen</fullName>
        <description>Account wird wieder auf ungültig gesetzt</description>
        <field>ungueltiger_Account__c</field>
        <literalValue>1</literalValue>
        <name>Som_AccountUngueltigSetzen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Som_TransferToMartinUnsinn</fullName>
        <field>OwnerId</field>
        <lookupValue>martin.unsinn@sevenonemedia.de</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Som_TransferToMartinUnsinn</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Som_TransferToSammeluser</fullName>
        <field>OwnerId</field>
        <lookupValue>sammeluser.ungueltig@p7s1.net</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Som_TransferToSammeluser</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Alten_Account_Inhaber_eintragen</fullName>
        <description>Feldaktualisierung zum Worklow von Seven Ventures.</description>
        <field>Ven_Alter_Account_Inhaber__c</field>
        <formula>PRIORVALUE(  Ven_Aktueller_Account_Inhaber__c  )</formula>
        <name>Alten Account Inhaber eintragen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Email_alter_Benutzer</fullName>
        <description>Feldaktualisierung wegen Workflow für Seven Ventures.</description>
        <field>Ven_E_Mail_alter_Benutzer__c</field>
        <formula>PRIORVALUE( Ven_E_Mail_Aktueller_Benutzer__c )</formula>
        <name>Email alter Benutzer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ADvendio__VatIdConcatenateCountryPrefixAndVatNumber</fullName>
        <actions>
            <name>ADvendio__VATID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Concatenate Country Prefix and VAT ID</description>
        <formula>ISCHANGED(ADvendio__VatIdNumber__c) || ISCHANGED( ADvendio__VatIdCountryPrefix__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ADvendio__VatIdUpdateFlagOnVatOrCountryPrefixChange</fullName>
        <actions>
            <name>ADvendio__UpdateVATIDFlag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Flag on Account if country prefix or Vat Id number is updated.</description>
        <formula>ISCHANGED(ADvendio__VatIdNumber__c) || ISCHANGED( ADvendio__VatIdCountryPrefix__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_AccountGueltigDsTyp</fullName>
        <actions>
            <name>P7S1_AccountGueltigDsTyp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.ungueltiger_Account__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>ungültiger Account</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.P7S1_Sphere__c</field>
            <operation>equals</operation>
            <value>SomDe,SomAt</value>
        </criteriaItems>
        <description>Wenn Account auf gültig gesetzt wird, soll Datensatztyp &quot;sonstiger Partner&quot; gesetzt werden.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_AccountNeuZuÜberprüfenRecType</fullName>
        <actions>
            <name>P7S1_SetRecordTypeToCheck</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.CreatedDate</field>
            <operation>greaterOrEqual</operation>
            <value>1/1/2000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.P7S1_PreviousRecordTypeId__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.P7S1_ValidSalesExcellence__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>setzt &quot;zu überprüfen&quot; Record Type, wenn Account angelegt wird (NEU)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_AccountNumberChanged</fullName>
        <actions>
            <name>P7S1_AccountNumberUniqueChanged</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>P7S1_DWH_ProRexIDChanged</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>stellt sicher, das AccountNumber, Unique und DWH-Feld identisch gefüllt sind.</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_AccountNumberNew</fullName>
        <actions>
            <name>P7S1_AccountNumberNew</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>P7S1_AccountNumberUniqueNew</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>P7S1_DWH_ProRexIDNew</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>füllt alle Felder, die im Bereich Accountnummer relevant sind</description>
        <formula>AccountNumber = null</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_AccountResetOrganschaft</fullName>
        <actions>
            <name>P7S1_Organschaft_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>4572 / Wenn das Feld &quot;p7s1 Konzernmitglied&quot; von WAHR auf FALSCH geändert wird, muss auch die Checkbox &quot;Organschaft&quot; automatisch von WAHR auf FALSCH geändert werden</description>
        <formula>AND(ISCHANGED(P7S1_Konzernmitglied__c),P7S1_Konzernmitglied__c=false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_AccountUngueltigDsTyp</fullName>
        <actions>
            <name>P7S1_AccountUngueltigDsTyp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.ungueltiger_Account__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Wenn Account auf ungültig gesetzt wird, soll Datensatztyp &quot;ungültiger Account&quot; gesetzt werden.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_AccountnameDwh</fullName>
        <actions>
            <name>P7S1_AccountnameDwh</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() || ISCHANGED(Name)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_DA_Sales_AccountSetCluster</fullName>
        <actions>
            <name>P7S1_DA_Sales_SetClusterIfEmpty</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.P7S1_Unit__c</field>
            <operation>equals</operation>
            <value>d&amp;a Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.P7S1_DandACluster__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Setzt bei Unit d&amp;a Sales das Feld P7S1_DandACluster__c, wenn es leer ist, auf Defaultwert &quot;d&amp;a Sales&quot; ==&gt; Logo-Steuerung</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_SphereCopy</fullName>
        <actions>
            <name>P7S1_SphereCopy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.P7S1_Sphere__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Kopiert den Wert aus P7S1_Sphere, welches als Formel populiert ist in ein Textfeld um es der Freigaberegel verfügbar zu machen.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_Steuerkennzeichen_KonzernitgliedNein</fullName>
        <actions>
            <name>P7S1_Steuerkennzeichen_AS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>füllt Steuerkennzeichen mit AS, wenn kein Konzernmitglied und nicht A0</description>
        <formula>P7S1_Konzernmitglied__c=false 
&amp;&amp; TEXT(P7S1_Steuerkennzeichen__c) !=&apos;A0&apos; 
&amp;&amp; TEXT(P7S1_Steuerkennzeichen__c) !=&apos;AS&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_Steuerkennzeichen_KonzernmitgliedJa</fullName>
        <actions>
            <name>P7S1_Steuerkennzeichen_A6</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>füllt Steuerkennzeichen mit A6 wenn Konzernmitglied und nicht AS</description>
        <formula>P7S1_Konzernmitglied__c=true 
&amp;&amp; TEXT(P7S1_Steuerkennzeichen__c) !=&apos;AS&apos; 
&amp;&amp; TEXT(P7S1_Steuerkennzeichen__c) !=&apos;A6&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_AccAnfDebitor2Std</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.SomTv_AnforderungDebitorennummernCheck__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.P7S1_Sphere__c</field>
            <operation>equals</operation>
            <value>SomDe,SomAt</value>
        </criteriaItems>
        <description>Dauert die Vergabe von Debitornummer länger als 2 Stunden, wird eine Erinnerungs-Email an das CRM-Team geschickt</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SomTv_AccAnfDebitor2Std</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SomTv_AccAnfProSediId2Std</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.SomTv_AnforderungProSediIds__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.P7S1_Sphere__c</field>
            <operation>equals</operation>
            <value>SomDe,SomAt</value>
        </criteriaItems>
        <description>Dauert die Vergabe von ProSediIDs länger als 2 Stunden, wird eine Erinnerungs-Email an das CRM-Team geschickt</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SomTv_AccAnfProSediId2Std</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SomTv_AccNameDebNummerExistiert</fullName>
        <actions>
            <name>SomTv_AccNameDebNummerExistiert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SomTv_CheckDebCheckerEmailVersendet</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SomTv_DebitorennummerChecker__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.P7S1_Sphere__c</field>
            <operation>equals</operation>
            <value>SomDe,SomAt</value>
        </criteriaItems>
        <description>Email an Debitorenbuchhaltung: Bei Änderung  des Accountnamens falls Debitorennummer existiert (CRMSALES-60). Zusammen mit AccountTrigger</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_AccountNeuZuÜberprüfen</fullName>
        <actions>
            <name>P7S1_AccountPruefenSalesSteering</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>P7S1_SetMessageforDashboard</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>P7S1_StoreCurrentRecordTypeId</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomTv_AccZuUeberpruefenTrue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.CreatedDate</field>
            <operation>greaterOrEqual</operation>
            <value>1/1/2000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.P7S1_ValidSalesExcellence__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>setzt &quot;zu überprüfen&quot; = true, wenn Account angelegt wird (NEU)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_AccountZuÜberprüfen</fullName>
        <actions>
            <name>SomTv_AccZuUeberpruefenTrue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>setzt &quot;zu überprüfen&quot; = true, wenn Account an bestimmten Feldern geändert wurde</description>
        <formula>$Profile.Id != $Label.ProfileIdAdmin 
&amp;&amp; 
PRIORVALUE( SomTv_ZuUeberpruefenAcc__c ) &lt;&gt; true
&amp;&amp;
 P7S1_ValidSalesExcellence__c = true
&amp;&amp;
(
ISCHANGED(ShippingStreet) || 
ISCHANGED(BillingStreet) || 
ISCHANGED(ShippingPostalCode) || 
ISCHANGED(BillingPostalCode)  || 
ISCHANGED(ShippingCity) || 
ISCHANGED(BillingCity) || 
ISCHANGED(ShippingState) || 
ISCHANGED(BillingState) || 
ISCHANGED(ShippingCountry ) || 
ISCHANGED(BillingCountry) || 
ISCHANGED(Name) || 
(SomTv_AnforderungDebitorennummernCheck__c = true) || 
(SomTv_AnforderungProSediIds__c = true) || 
ISCHANGED( Som_Rechtsform__c )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_AccountZuÜberprüfenFaktura</fullName>
        <actions>
            <name>Benachrichtigung_Faktura_nderung</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SomTV_Setzt_zu_berpr_fen_Faktura</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>setzt &quot;zu überprüfen Faktura&quot; = true, wenn Account an bestimmten Feldern geändert wurde</description>
        <formula>PRIORVALUE( SomTv_zuUeberpruefenFakturaAcc__c  ) &lt;&gt; true
&amp;&amp;
 P7S1_ValidSalesExcellence__c = true
&amp;&amp;
 SomTv_AnzahlProSaProSediIds__c &gt; 0
&amp;&amp;
(
ISCHANGED(BillingStreet) || 
ISCHANGED(BillingPostalCode)  || 
ISCHANGED(BillingCity) || 
ISCHANGED(BillingState) || 
ISCHANGED(BillingCountry) || 
ISCHANGED(Name)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_DebitorennummernStatus</fullName>
        <actions>
            <name>SomTv_DebitorennummernStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.SomTv_AnforderungDebitorennummernCheck__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>wenn SomTv_AnforderungDebitorennummernCheck = true, dann setze SomTv_Anforderung_Debitorennummer auf &quot;benötigt&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Som_AccountOwner</fullName>
        <actions>
            <name>Som_AccountOwner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.P7S1_Sphere__c</field>
            <operation>equals</operation>
            <value>SomDe,SomAt</value>
        </criteriaItems>
        <description>setzt Inhaber für SomDe/SomAt auf Peter Rozalski</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Ven_Account Inhaber Änderung</fullName>
        <actions>
            <name>Ven_Inhaberschaft_von_Ventures_Account_ge_ndert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Ven_Alten_Account_Inhaber_eintragen</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Ven_Email_alter_Benutzer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Der Workflow Informiert den alten und den neuen Inhaber des Account über den Wechsel der Inhaberschaft.</description>
        <formula>ISCHANGED(  OwnerId  ) &amp;&amp;    BEGINS(RecordType.DeveloperName, &quot;Ven&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
