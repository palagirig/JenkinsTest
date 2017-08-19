<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Kundenvorgang_erstellt_aktualisiert</fullName>
        <description>Kundenvorgang erstellt/aktualisiert</description>
        <protected>false</protected>
        <recipients>
            <recipient>Beobachter</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce-admins@prosiebensat1.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>P7S1_Ticket/P7S1_TicketErstelltOderAktualisiert</template>
    </alerts>
    <alerts>
        <fullName>P7S1_CaseCommentTeam</fullName>
        <description>Send E-Mail to Case Team Members</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>P7S1_Ticket/P7S1_Case_Comment_Team</template>
    </alerts>
    <alerts>
        <fullName>P7S1_Case_Severity</fullName>
        <description>P7S1_Case_Severity</description>
        <protected>false</protected>
        <recipients>
            <recipient>P7S1_Admins</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>anton.suppmair@sevenonemedia.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mareike.zaruba@p7s1applications.de</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>p7s1.marcel.weber@mweber.consulting</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sonja.kapfelsberger.extern@p7s1applications.de</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>P7S1_Ticket/P7S1_Case_Severity</template>
    </alerts>
    <alerts>
        <fullName>P7S1_KundenvorgangGeschlossen</fullName>
        <description>P7S1_Kundenvorgang geschlossen</description>
        <protected>false</protected>
        <recipients>
            <recipient>Anforderungsmanager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Beobachter</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Lösungsmanager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Teamlead (Eskalation)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce-admins@prosiebensat1.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>P7S1_Ticket/P7S1_TicketGeschlossen</template>
    </alerts>
    <alerts>
        <fullName>P7S1_KundenvorgangReminderFaelligkeitsdatum</fullName>
        <description>P7S1 Kundenvorgang Reminder Fälligkeitsdatum</description>
        <protected>false</protected>
        <recipients>
            <recipient>Anforderungsmanager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Beobachter</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Lösungsmanager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Teamlead (Eskalation)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce-admins@prosiebensat1.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>P7S1_Ticket/P7S1_TicketReminderFaelligkeitsdatum</template>
    </alerts>
    <alerts>
        <fullName>P7S1_KundenvorgangReminderOverdueFaelligkeitsdatum</fullName>
        <description>P7S1 Kundenvorgang Reminder Overdue Fälligkeitsdatum</description>
        <protected>false</protected>
        <recipients>
            <recipient>Anforderungsmanager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Beobachter</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Lösungsmanager</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Teamlead (Eskalation)</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce-admins@prosiebensat1.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>P7S1_Ticket/P7S1_TicketOverdueFaelligkeitsdatum</template>
    </alerts>
    <alerts>
        <fullName>Zuordnung_Kundenvorgangs</fullName>
        <description>Info über Zuordnung eines neuen Kundenvorgangs</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce-admins@prosiebensat1.de</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>P7S1_Ticket/P7S1_TicketZuweisung</template>
    </alerts>
    <fieldUpdates>
        <fullName>KV_geschlossen</fullName>
        <description>Wenn Status bei Kundenvorgang &quot;Geschlossen&quot;, dann Datensatztyp &quot;Kundenvorgang geschlossen&quot; wählen.</description>
        <field>RecordTypeId</field>
        <lookupValue>P7S1_KundenvorgangGeschlossen</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>KV geschlossen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lcm_Rank</fullName>
        <description>BusinessValue / Storypoints (wenn beide gefüllt) sonst LEER</description>
        <field>Rank__c</field>
        <formula>IF(
   LEN(TEXT(P7S1_BusinessValue__c))&gt;0
&amp;&amp; LEN(TEXT(Lcm_Complexity__c))&gt;0 ,

  VALUE(TEXT(P7S1_BusinessValue__c)) / VALUE(TEXT(Lcm_Complexity__c )),
  NULL
)</formula>
        <name>Lcm_Rank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lcm_TestSphere</fullName>
        <description>Füllt Test-Sphäre aus Test-Requirement.</description>
        <field>Lcm_TestSphere__c</field>
        <formula>Lcm_Requirement__r.Lcm_TestSphere__c</formula>
        <name>Lcm_TestSphere</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rank_l_schen</fullName>
        <description>Löschen des Ranks wenn Kundenvorgang geschlossen ist.</description>
        <field>Rank__c</field>
        <name>Rank löschen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Setze_aktuelles_Datum_Uhrzeit</fullName>
        <field>ReOpenDateTime__c</field>
        <formula>NOW()</formula>
        <name>Setze aktuelles Datum &amp; Uhrzeit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRecordTypeChange</fullName>
        <field>RecordTypeId</field>
        <lookupValue>P7S1_Change</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRecordTypeIncident</fullName>
        <field>RecordTypeId</field>
        <lookupValue>P7S1_Incident</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type Incident</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRecordTypeProblem</fullName>
        <description>Update Record Type Problem</description>
        <field>RecordTypeId</field>
        <lookupValue>P7S1_Problem</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type Problem</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRecordTypeService</fullName>
        <field>RecordTypeId</field>
        <lookupValue>P7S1_Service</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type Service</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Lcm_Rank</fullName>
        <actions>
            <name>Lcm_Rank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>befüllt Rank aus BusinessValue und Storypoints</description>
        <formula>ISNEW() || ISCHANGED( P7S1_BusinessValue__c ) || ISCHANGED ( Lcm_Complexity__c ) || ISCHANGED(Rank__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lcm_TestSphere</fullName>
        <actions>
            <name>Lcm_TestSphere</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Füllt Lcm_TestSphere, als Basis für Freigaberegel.</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P7S1 Update Record Type Change</fullName>
        <actions>
            <name>UpdateRecordTypeChange</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Change</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Wenn Typ &quot;Change&quot; am Ticket ausgewählt, dann soll sich der Datensatztyp automatisch auf &quot;Change&quot; ändern.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>P7S1 Update Record Type Incident</fullName>
        <actions>
            <name>UpdateRecordTypeIncident</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Incident</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Wenn Typ &quot;Incident&quot; am Ticket ausgewählt, dann soll sich der Datensatztyp automatisch auf &quot;Incident&quot; ändern.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>P7S1 Update Record Type Problem</fullName>
        <actions>
            <name>UpdateRecordTypeProblem</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Problem</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Wenn Typ &quot;Problem&quot; am Ticket ausgewählt, dann soll sich der Datensatztyp automatisch auf &quot;Problem&quot; ändern.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>P7S1 Update Record Type Service</fullName>
        <actions>
            <name>UpdateRecordTypeService</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Wenn Typ &quot;Service&quot; am Ticket ausgewählt, dann soll sich der Datensatztyp automatisch auf &quot;Service&quot; ändern.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_Case Datensatztyp geschlossen</fullName>
        <actions>
            <name>P7S1_KundenvorgangGeschlossen</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>KV_geschlossen</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>KV-Datensatztyp nach Status (&quot;Geschlossen&quot; = schreibschutz)</description>
        <formula>AND(ISPICKVAL(Status, &quot;Geschlossen&quot;), ISCHANGED( Status ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_Case DueDate Overdue</fullName>
        <active>true</active>
        <description>Senden einer E-Mail wenn Fälligkeitsdatum mehr als 7 Tage überfällig und der Kundenvorgang nicht geschlossen ist.</description>
        <formula>NOT(ISPICKVAL(Status, &quot;Geschlossen&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>P7S1_KundenvorgangReminderOverdueFaelligkeitsdatum</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Datum_F_lligkeit__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>P7S1_Case DueDate Reminder</fullName>
        <active>true</active>
        <description>Senden einer E-Mail, wenn Fälligkeitsdatum in den nächsten drei Tagen wahr wird und der Kundenvorgang nicht geschlossen ist.</description>
        <formula>NOT(ISPICKVAL(Status, &quot;Geschlossen&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>P7S1_KundenvorgangReminderFaelligkeitsdatum</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Datum_F_lligkeit__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>P7S1_Case Sdt Erstelldatum</fullName>
        <actions>
            <name>Setze_aktuelles_Datum_Uhrzeit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Erstelldatum eines Kundenvorgangs wird gesetzt</description>
        <formula>IF ( 	ISNEW(), 	true, 	IF 	( 		AND 		(  			ISCHANGED(Status), 			(PRIORVALUE(IsClosed) == true), 			(IsClosed == false) 		),  		true,  		false 	) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_Case_Severity</fullName>
        <actions>
            <name>P7S1_Case_Severity</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>True when a case severity has been changed to 1 or 2</description>
        <formula>OR( 
  ISPICKVAL( Severity__c, &apos;1&apos;), 
  ISPICKVAL( Severity__c, &apos;2&apos;) 
) 
&amp;&amp; 
OR(ISCHANGED(Severity__c), ISNEW() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send last Comment to Case Team</fullName>
        <actions>
            <name>P7S1_CaseCommentTeam</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(
ISCHANGED( P7S1_LastCaseComment__c ),
OwnerId = &quot;00557000006tvR4&quot;
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
