<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>P7S1_OwnerChanged</fullName>
        <description>P7S1_OwnerChanged</description>
        <protected>false</protected>
        <recipients>
            <field>P7S1_OldOwnerEmail__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>P7S1/P7S1_OpportunityOwnerChanged</template>
    </alerts>
    <alerts>
        <fullName>SomTv_Angebot_neu</fullName>
        <ccEmails>71m0s03a@sevenonemedia.de</ccEmails>
        <description>SomTv_Angebot neu</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>SomTv/SomTv_Angebot</template>
    </alerts>
    <alerts>
        <fullName>SomTv_OppPhaseGeaendert</fullName>
        <description>SomTv_OppPhaseGeaendert</description>
        <protected>false</protected>
        <recipients>
            <recipient>SomTv_RmAdCc</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SomTv/SomTv_OppPhaseGeaendert</template>
    </alerts>
    <alerts>
        <fullName>SomTv_OppsRabattfreigabe</fullName>
        <description>SomTv_OppsRabattfreigabe</description>
        <protected>false</protected>
        <recipients>
            <recipient>TV_Einkaufsagenturverkäufer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>TV_Einkaufsagenturverkäufer_Innendienst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>TV_Kundenverkäufer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>TV_Kundenverkäufer_Innendienst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>TV_Lead&amp;Kundenverkäufer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>TV_Leadverkäufer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>TV_Planungsagenturverkäufer</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>TV_Planungsagenturverkäufer_Innendienst</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SomTv/SomTv_Opps_Rabattfreigabe</template>
    </alerts>
    <alerts>
        <fullName>Ven_Board_Approval</fullName>
        <description>Ven_Board Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Board_Approval</template>
    </alerts>
    <alerts>
        <fullName>Ven_Board_Approval_Auto</fullName>
        <description>Ven_Board Approval Auto</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Board_Approval_Auto</template>
    </alerts>
    <alerts>
        <fullName>Ven_D_A_Board_hat_Opportunity_abgelehnt</fullName>
        <description>Ven_D&amp;A Board hat Opportunity abgelehnt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_D_A_Board_hat_Opportunity_abgelehnt</template>
    </alerts>
    <alerts>
        <fullName>Ven_D_A_Board_hat_Opportunity_final_genehmigt</fullName>
        <description>Ven_D&amp;A Board hat Opportunity final genehmigt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_D_A_Board_hat_Opportunity_final_genehmigt</template>
    </alerts>
    <alerts>
        <fullName>Ven_D_A_Board_hat_Opportunity_genehmigt</fullName>
        <description>Ven_D&amp;A Board hat Opportunity genehmigt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_D_A_Board_hat_Opportunity_genehmigt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Executive_Board_hat_Opportunity_abgelehnt</fullName>
        <description>Ven_ Executive Board hat Opportunity abgelehnt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Executive_Board_hat_Opportunity_abgelehnt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Executive_Board_hat_Opportunity_final_genehmigt</fullName>
        <description>Ven_Executive Board hat Opportunity final genehmigt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Executive_Board_hat_Opportunity_final_genehmigt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Executive_Board_hat_Opportunity_genehmigt</fullName>
        <description>Ven_ Executive Board hat Opportunity genehmigt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Executive_Board_hat_Opportunity_genehmigt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Genehmigungsgremium_SIC_II_hat_Opportunity_abgelehnt</fullName>
        <description>Ven_Genehmigungsgremium SIC II hat Opportunity abgelehnt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Genehmigungsgremium_SIC_II_hat_Opportunity_abgelehnt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Genehmigungsgremium_SIC_II_hat_Opportunity_genehmigt</fullName>
        <description>Ven_Genehmigungsgremium SIC II hat Opportunity genehmigt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Genehmigungsgremium_SIC_II_hat_Opportunity_genehmigt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Genehmigungsgremium_SIC_I_hat_Opportunity_abgelehnt</fullName>
        <description>Ven_Genehmigungsgremium SIC I hat Opportunity abgelehnt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Genehmigungsgremium_SIC_I_hat_Opportunity_abgelehnt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Genehmigungsgremium_SIC_I_hat_Opportunity_genehmigt</fullName>
        <description>Ven_Genehmigungsgremium SIC I hat Opportunity genehmigt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Genehmigungsgremium_SIC_I_hat_Opportunity_genehmigt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Genehmigungsgremium_SOM_Assessment_hat_Opportunity_abgelehnt</fullName>
        <description>Ven_Genehmigungsgremium SOM Assessment hat Opportunity abgelehnt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Genehmigungsgremium_SOM_Assessment_hat_Opportunity_abgelehnt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Genehmigungsgremium_SOM_Assessment_hat_Opportunity_genehmigt</fullName>
        <description>Ven_Genehmigungsgremium SOM Assessment hat Opportunity genehmigt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Genehmigungsgremium_SOM_Assessment_hat_Opportunity_genehmigt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Genehmigungsgremium_VIC_II_hat_Opportunity_abgelehnt</fullName>
        <description>Ven_Genehmigungsgremium VIC II hat Opportunity abgelehnt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Genehmigungsgremium_VIC_II_hat_Opportunity_abgelehnt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Genehmigungsgremium_VIC_II_hat_Opportunity_genehmigt</fullName>
        <description>Ven_Genehmigungsgremium VIC II hat Opportunity genehmigt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Genehmigungsgremium_VIC_II_hat_Opportunity_genehmigt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Genehmigungsgremium_VIC_I_hat_Opportunity_abgelehnt</fullName>
        <description>Ven_Genehmigungsgremium VIC I hat Opportunity abgelehnt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Genehmigungsgremium_VIC_I_hat_Opportunity_abgelehnt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Genehmigungsgremium_VIC_I_hat_Opportunity_genehmigt</fullName>
        <description>Ven_Genehmigungsgremium VIC I hat Opportunity genehmigt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Genehmigungsgremium_VIC_I_hat_Opportunity_genehmigt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Opp_Approval_Final_Approval_abgelehnt</fullName>
        <description>Ven_Opp. Approval Final Approval abgelehnt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Ven_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Opp_Approval_Final_Approval_abgelehnt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Opp_Approval_Final_Approval_genehmigt</fullName>
        <description>Ven_Opp. Approval Final Approval genehmigt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Ven_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Opp_Approval_Final_Approval_genehmigt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Opp_Approval_Negotiation_Mandate_abgelehnt</fullName>
        <description>Ven_Opp. Approval Negotiation/Mandate abgelehnt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Ven_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Opp_Approval_Negotiation_Mandate_abgelehnt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Opp_Approval_Negotiation_Mandate_genehmigt</fullName>
        <description>Ven_Opp. Approval Negotiation/Mandate genehmigt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Ven_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Opp_Approval_Negotiation_Mandate_genehmigt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Opp_Approval_Wiedervorlagegremium_Final_Approval_abgelehnt</fullName>
        <description>Ven_Opp. Approval Wiedervorlagegremium Final Approval abgelehnt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Ven_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Opp_Approval_Wiedervorlagegremium_Final_Approval_abgelehnt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Opp_Approval_Wiedervorlagegremium_Final_Approval_genehmigt</fullName>
        <description>Ven_Opp. Approval Wiedervorlagegremium Final Approval genehmigt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Ven_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Opp_Approval_Wiedervorlagegremium_Final_Approval_genehmigt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Opp_Approval_Wiedervorlagegremium_Negotiation_Mandate_abgelehnt</fullName>
        <description>Ven_Opp. Approval Wiedervorlagegremium Negotiation/Mandate abgelehnt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Ven_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Opp_Approval_Wiedervorlagegremium_Negotiation_Mandate_abgelehnt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Opp_Approval_Wiedervorlagegremium_Negotiation_Mandate_genehmigt</fullName>
        <description>Ven_Opp. Approval Wiedervorlagegremium Negotiation/Mandate genehmigt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Ven_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Opp_Approval_Wiedervorlagegremium_Negotiation_Mandate_genehmigt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Resubmission_der_Opportunity</fullName>
        <description>Ven Resubmission der Opportunity</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Resubmission_einer_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Ven_Supervisory_Board_hat_Opportunity_abgelehnt</fullName>
        <description>Ven_Supervisory Board hat Opportunity abgelehnt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Supervisory_Board_hat_Opportunity_abgelehnt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Supervisory_Board_hat_Opportunity_final_genehmigt</fullName>
        <description>Ven_ Supervisory Board hat Opportunity final genehmigt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Supervisory_Board_hat_Opportunity_final_genehmigt</template>
    </alerts>
    <alerts>
        <fullName>Ven_Supervisory_Board_hat_Opportunity_genehmigt</fullName>
        <description>Ven_ Supervisory Board hat Opportunity genehmigt</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Ven/Ven_Supervisory_Board_hat_Opportunity_genehmigt</template>
    </alerts>
    <fieldUpdates>
        <fullName>DA_Set_Account_Status</fullName>
        <description>Set Account Status &quot;Bestandskunde&quot; on Opp Won</description>
        <field>P7S1_DandASalesKundenstatus__c</field>
        <literalValue>Bestandskunde</literalValue>
        <name>Set Account Status D&amp;A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Kampagnenname_ndern</fullName>
        <field>Kampagne__c</field>
        <formula>Name</formula>
        <name>Kampagnenname ändern</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_DA_Sales_OppName</fullName>
        <description>update Opp.Name to &lt;Jahr Schlusstermin&gt;_&lt;d&amp;a Sales Cluster&gt;_&lt;Account Name&gt;_&lt;d&amp;a Sales Asset&gt;
Maximum length available is 120 characters</description>
        <field>Name</field>
        <formula>TEXT(YEAR(CloseDate)) &amp; &quot;_&quot; &amp;  P7S1_DandACluster__c &amp; &quot;_&quot; &amp; LEFT(Account.Name, 70) &amp; &quot;_&quot; &amp; LEFT( TEXT(   P7S1_DandASalesAsset__c  ),28)</formula>
        <name>d&amp;a Sales OppName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_Maxdome_OppName</fullName>
        <description>update Opp.Name to &lt;Jahr Schlusstermin&gt;_&lt;Unit&gt;_&lt;Account Name&gt;_&lt;Sales Bereich&gt;
Maximum length available is 120 characters</description>
        <field>Name</field>
        <formula>TEXT(YEAR(CloseDate)) &amp; &quot;_&quot; &amp; 
Owner.P7S1_Unit__c &amp; &quot;_&quot; &amp; 
LEFT(Account.Name, 90) &amp; &quot;_&quot; &amp; LEFT( TEXT( Maxdome_SalesBereich__c ),14)</formula>
        <name>maxdome OppName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_Probability_Lost_0</fullName>
        <description>Set Probability to 0% on Lost Opps</description>
        <field>Probability</field>
        <formula>0</formula>
        <name>Probability Lost = 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P7S1_SE_OppName</fullName>
        <description>update Opp.Name to 
&lt;Jahr Schlusstermin&gt;_&lt;Unit&gt;_&lt;Account Name&gt;
Maximum length available is 120 characters</description>
        <field>Name</field>
        <formula>TEXT(YEAR(CloseDate)) &amp; &quot;_&quot; &amp; Owner.P7S1_Unit__c &amp; &quot;_&quot; &amp; LEFT(Account.Name, 90)</formula>
        <name>Sales Excellence OppName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
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
    <fieldUpdates>
        <fullName>P7S1_UpdateDescription255</fullName>
        <field>P7S1_Description255__c</field>
        <formula>LEFT(Description, 254)</formula>
        <name>Update Description (255)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_CloseDate</fullName>
        <description>Setze Closedate für Digital Opps auf 3 Wochen vor Kampagnenstart oder frühestens heute</description>
        <field>CloseDate</field>
        <formula>if (
 ( Kampagnenstart__c - 21 ) &lt;= TODAY() ,
 TODAY() ,
 Kampagnenstart__c -21
)</formula>
        <name>Digital Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_OppName</fullName>
        <field>Name</field>
        <formula>IF ( 
  LEN ( TEXT(YEAR( Kampagnenstart__c))+&quot;_&quot;+Account.Name+&quot;_&quot;+Campaign.Name ) &gt; 120 , 
  LEFT ( TEXT(YEAR( Kampagnenstart__c))+&quot;_&quot;+Account.Name+&quot;_&quot;+Campaign.Name , 120 ) ,
  TEXT(YEAR( Kampagnenstart__c))+&quot;_&quot;+Account.Name+&quot;_&quot;+Campaign.Name
)</formula>
        <name>Digital Opp Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_OpportunityBetrag</fullName>
        <description>Kopiert den Wert des MN2-Feldes in das Salesforce-Feld Betrag/Amount.</description>
        <field>Amount</field>
        <formula>MN2__c</formula>
        <name>Opportunity Betrag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_Opp_Name_TV</fullName>
        <description>Aktualisiert den Opportunity Namen für TV Opps nach der Konvention Geschäftsjahr YYYY_OppsDatensatztyp_Accountname</description>
        <field>Name</field>
        <formula>TEXT(SomTv_Jahr__c)  + &quot;_&quot; + $RecordType.Name + &quot;_&quot;  +  Account.Name</formula>
        <name>SomTv_Opp Name (TV)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_ProbabilityRestore</fullName>
        <field>Probability</field>
        <formula>PRIORVALUE(SomTv_ProbabilityTemp__c)</formula>
        <name>SomTv_ProbabilityRestore</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_ProbabilitySave</fullName>
        <field>SomTv_ProbabilityTemp__c</field>
        <formula>Probability</formula>
        <name>SomTv_ProbabilitySave</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomTv_UniqueKey</fullName>
        <description>füllt SomTv_UniqueKey</description>
        <field>SomTv_UniqueKey__c</field>
        <formula>Account.AccountNumber &amp; &quot;_&quot; &amp;
RecordType.DeveloperName &amp; &quot;_&quot; &amp;
TEXT(SomTv_Jahr__c) &amp; &quot;_&quot; &amp;
TEXT(SomTv_Plattform__c)  &amp; &quot;_&quot; &amp;
TEXT(SomTv_Laufende_Nummer_ProCommit__c)</formula>
        <name>SomTv_UniqueKey</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Star_UpdateComedy</fullName>
        <description>Wird an der Opportunity Comedy als Genre ausgewählt, soll am Account auch das Genre Comedy ausgewählt werden.</description>
        <field>Star_Comedy__c</field>
        <literalValue>1</literalValue>
        <name>Update Comedy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Star_UpdateFamilyEntertainment</fullName>
        <description>Wird an der Opportunity Family Entertainment als Genre ausgewählt, soll am Account auch das Genre Family Entertainment ausgewählt werden.</description>
        <field>Star_FamilyEntertainment__c</field>
        <literalValue>1</literalValue>
        <name>Update Family Entertainment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Star_UpdateFestivals</fullName>
        <description>Wird an der Opportunity Festivals als Genre ausgewählt, soll am Account auch das Genre Festivals ausgewählt werden.</description>
        <field>Star_Festivals__c</field>
        <literalValue>1</literalValue>
        <name>Update Festivals</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Star_UpdateLabel</fullName>
        <description>Wird an der Opportunity Label als Genre ausgewählt, soll am Account auch das Genre Label ausgewählt werden</description>
        <field>Star_Label__c</field>
        <literalValue>1</literalValue>
        <name>Update Label</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Star_UpdateMN3</fullName>
        <field>SomTv_MN3__c</field>
        <formula>Star_UmsatzGesamtNettoFixVariabel__c</formula>
        <name>Update MN3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Star_UpdateMusicals</fullName>
        <description>Wird an der Opportunity Musicals als Genre ausgewählt, soll am Account auch das Genre Musicals ausgewählt werden.</description>
        <field>Star_Musicals__c</field>
        <literalValue>1</literalValue>
        <name>Update Musicals</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Star_UpdateOertlicheVerantstalter</fullName>
        <description>Wird an der Opportunity Örtliche Veranstalter als Genre ausgewählt, soll am Account auch das Genre Örtliche Veranstalter ausgewählt werden.</description>
        <field>Star_OertlicheVeranstalter__c</field>
        <literalValue>1</literalValue>
        <name>Update Örtliche Verantstalter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Star_UpdateRockPopSchlagerTourneen</fullName>
        <description>Wird an der Opportunity Rock, Pop &amp; Schlager Tourneen als Genre ausgewählt, soll am Account auch das Genre Rock, Pop &amp; Schlager Tourneen ausgewählt werden.</description>
        <field>Star_RockPopSchlagerTourneen__c</field>
        <literalValue>1</literalValue>
        <name>Update Rock, Pop &amp; Schlager Tourneen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Star_UpdateSonstige</fullName>
        <description>Wird an der Opportunity Sonstige als Genre ausgewählt, soll am Account auch das Genre Sonstige ausgewählt werden.</description>
        <field>Star_Sonstige__c</field>
        <literalValue>1</literalValue>
        <name>Update Sonstige</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VIC_II_SIC_II_setzen</fullName>
        <description>Die Checkbox wird von dieser Feldaktualisierung gesetzt.</description>
        <field>Ven_VIC_II_SIC_II__c</field>
        <literalValue>1</literalValue>
        <name>VIC II/SIC II setzen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VIC_I_SIC_I_setzen</fullName>
        <description>Die Checkbox wird von dieser Feldaktualisierung gesetzt.</description>
        <field>Ven_VIC_I_SIC_I__c</field>
        <literalValue>1</literalValue>
        <name>VIC I/SIC I setzen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Comment_Input_bei_Rejected</fullName>
        <description>Schreibt die letzte Phase in das Feld &apos;Comment&apos;, wenn die Phase &apos;Rejected&apos; ausgewählt ist.</description>
        <field>Ven_Comment__c</field>
        <formula>IF (ISBLANK(Ven_Comment__c) ,

&quot;Letzte Phase vor Status &apos;Rejected&apos;: &quot; &amp;  PRIORVALUE(Ven_Phase_Hilfsfeld__c),

Ven_Comment__c  &amp; BR() &amp; BR() &amp; &quot;Letzte Phase vor Status &apos;Rejected&apos;: &quot; &amp;  PRIORVALUE(Ven_Phase_Hilfsfeld__c))</formula>
        <name>Ven_Comment_Input_bei_Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Datum_setzen_D_A_Board</fullName>
        <description>Datum der Genehmigung bzw. Ablehnung automatisch setzen.</description>
        <field>Ven_Datum_D_A_Board__c</field>
        <formula>Today()</formula>
        <name>Ven_Datum setzen D&amp;A Board</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Datum_setzen_Executive_Board</fullName>
        <description>Datum der Genehmigung bzw. Ablehnung automatisch setzen.</description>
        <field>Ven_Datum_Executive_Board__c</field>
        <formula>Today()</formula>
        <name>Ven_Datum setzen Executive Board</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Datum_setzen_SIC_I</fullName>
        <description>Datum der Genehmigung bzw. Ablehnung automatisch setzen.</description>
        <field>Ven_Datum_SIC_I__c</field>
        <formula>Today()</formula>
        <name>Ven_Datum setzen SIC I</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Datum_setzen_SIC_II</fullName>
        <description>Datum der Genehmigung bzw. Ablehnung automatisch setzen.</description>
        <field>Ven_Datum_SIC_II__c</field>
        <formula>Today()</formula>
        <name>Ven_Datum setzen SIC II</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Datum_setzen_SOM_Assessment</fullName>
        <description>Datum der Genehmigung bzw. Ablehnung automatisch setzen.</description>
        <field>Ven_Datum_SOM_Assessment__c</field>
        <formula>Today()</formula>
        <name>Ven_Datum setzen SOM Assessment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Datum_setzen_Supervisory_Board</fullName>
        <description>Datum der Genehmigung bzw. Ablehnung automatisch setzen.</description>
        <field>Ven_Datum_Supervisory_Board__c</field>
        <formula>Today()</formula>
        <name>Ven_Datum setzen Supervisory Board</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Datum_setzen_VIC_I</fullName>
        <description>Datum der Genehmigung bzw. Ablehnung automatisch setzen.</description>
        <field>Ven_Datum_VIC_I__c</field>
        <formula>Today()</formula>
        <name>Ven_Datum setzen VIC I</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Datum_setzen_VIC_II</fullName>
        <description>Datum der Genehmigung bzw. Ablehnung automatisch setzen.</description>
        <field>Ven_Datum_VIC_II__c</field>
        <formula>Today ()</formula>
        <name>Ven_Datum setzen VIC II</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Im_Approval_Checkbox_entfernen_OPP</fullName>
        <description>Diese Feldaktualisierung entfernt die Markierung aus der Checkbox &quot;Im Genehmigungsprozess&quot;. Nur für Seven Ventures Opportunities!</description>
        <field>Ven_Im_Genehmigungsprozess__c</field>
        <literalValue>0</literalValue>
        <name>Ven_Im Approval Checkbox entfernen OPP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Im_Approval_Checkbox_setzen_Opp</fullName>
        <description>Diese Feldaktualisierung setzt die Markierung in der Checkbox &quot;Im Genehmigungsprozess&quot;. Nur für Seven Ventures Opportunities!</description>
        <field>Ven_Im_Genehmigungsprozess__c</field>
        <literalValue>1</literalValue>
        <name>Ven_Im Approval Checkbox setzen Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_OPP_Kommentar_D_A_Board_abgelehnt</fullName>
        <description>Diese Feldaktualisierung trägt Abgelehnt in das Status Feld ein.</description>
        <field>Ven_Status_D_A_Board__c</field>
        <formula>&quot;Abgelehnt&quot;</formula>
        <name>Ven_OPP Kommentar D&amp;A Board abgelehnt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_OPP_Kommentar_D_A_Board_auto</fullName>
        <description>Ein Kommentar im Statusfeld des durchlaufenden Gremium.</description>
        <field>Ven_Status_D_A_Board__c</field>
        <formula>&quot;Automatische Genehmigung erteilt&quot;</formula>
        <name>Ven_OPP Kommentar D&amp;A Board auto</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_OPP_Kommentar_D_A_Board_genehmigt</fullName>
        <description>Diese Feldaktualisierung trägt Approved in das Status Feld ein.</description>
        <field>Ven_Status_D_A_Board__c</field>
        <formula>&quot;Genehmigt&quot;</formula>
        <name>Ven_OPP Kommentar D&amp;A Board genehmigt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_OPP_Kommentar_Executive_Board_abgele</fullName>
        <description>Diese Feldaktualisierung trägt Abgelehnt in das Status Feld ein.</description>
        <field>Ven_Status_Executive_Board__c</field>
        <formula>&quot;Abgelehnt&quot;</formula>
        <name>Ven_OPP Kommentar Executive Board abgele</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_OPP_Kommentar_Executive_Board_auto</fullName>
        <description>Ein Kommentar im Statusfeld des durchlaufenden Gremium.</description>
        <field>Ven_Status_Executive_Board__c</field>
        <formula>&quot;Automatische Genehmigung erteilt&quot;</formula>
        <name>Ven_OPP Kommentar Executive Board auto</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_OPP_Kommentar_Executive_Board_geneh</fullName>
        <description>Diese Feldaktualisierung trägt Approved in das Status Feld ein.</description>
        <field>Ven_Status_Executive_Board__c</field>
        <formula>&quot;Genehmigt&quot;</formula>
        <name>Ven_OPP Kommentar Executive Board geneh</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_OPP_Kommentar_Supervisory_Board_abge</fullName>
        <description>Diese Feldaktualisierung trägt Abgelehnt in das Status Feld ein.</description>
        <field>Ven_Status_Supervisory_Board__c</field>
        <formula>&quot;Abgelehnt&quot;</formula>
        <name>Ven_OPP Kommentar Supervisory Board abge</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_OPP_Kommentar_Supervisory_Board_auto</fullName>
        <description>Ein Kommentar im Statusfeld des durchlaufenden Gremium.</description>
        <field>Ven_Status_Supervisory_Board__c</field>
        <formula>&quot;Automatische Genehmigung erteilt&quot;</formula>
        <name>Ven_OPP Kommentar Supervisory Board auto</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_OPP_Kommentar_Supervisory_Board_gene</fullName>
        <description>Diese Feldaktualisierung trägt Approved in das Status Feld ein.</description>
        <field>Ven_Status_Supervisory_Board__c</field>
        <formula>&quot;Genehmigt&quot;</formula>
        <name>Ven_OPP Kommentar Supervisory Board gene</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_OPP_Phase_Board_Approval</fullName>
        <description>Diese Feldaktualisierung setzt die Phase &quot;Board Approval&quot;. Für Seven Ventures.</description>
        <field>StageName</field>
        <literalValue>Board Approval</literalValue>
        <name>Ven_OPP Phase Board Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_OPP_Phase_in_Approved</fullName>
        <description>Der Genehmigungprozess ändern die Phase der Opportunity nach Genehmigung.</description>
        <field>StageName</field>
        <literalValue>Approved</literalValue>
        <name>Ven_OPP Phase in Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_OPP_Phase_in_Board_Rejection</fullName>
        <description>Der Genehmigungprozess ändern die Phase der Opportunity nach Genehmigung oder Ablehnung.</description>
        <field>StageName</field>
        <literalValue>Board Rejection</literalValue>
        <name>Ven_OPP Phase in Board Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_OPP_Phase_in_Negotiation</fullName>
        <description>Der genehmigungprozess ändern die Phase der Opportunity nach Genehmigung.</description>
        <field>StageName</field>
        <literalValue>Negotiation</literalValue>
        <name>Ven_OPP Phase in Negotiation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_OppName</fullName>
        <field>Name</field>
        <formula>TEXT(YEAR(CloseDate)) &amp; &quot;_&quot; &amp; Owner.P7S1_Unit__c &amp; &quot;_&quot; &amp; LEFT(Account.Name, 100)</formula>
        <name>Ven_OppName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Opp_Hilfsfeld_entfernen</fullName>
        <description>Es handelt sich um eine Feldaktualisierung die vom Genehmigungsprozess von Seven Ventures in der Opportunity benutzt wird.</description>
        <field>Ven_Hilfsfeld_Opp_Approval_SV__c</field>
        <literalValue>0</literalValue>
        <name>Ven_Opp. Hilfsfeld entfernen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Opp_Hilfsfeld_final_Rejected_setzen</fullName>
        <field>Hilfsfeld_Opp_Approval_SV_final_Rejecti__c</field>
        <literalValue>1</literalValue>
        <name>Ven_Opp. Hilfsfeld final Rejected setzen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Opp_Hilfsfeld_setzen</fullName>
        <description>Es handelt sich um eine Feldaktualisierung die vom Genehmigungsprozess von Seven Ventures in der Opportunity benutzt wird.</description>
        <field>Ven_Hilfsfeld_Opp_Approval_SV__c</field>
        <literalValue>1</literalValue>
        <name>Ven_Opp. Hilfsfeld setzen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Opp_SIC_II_Status_Abgelehnt</fullName>
        <description>Diese Feldaktualisierung trägt Abgelehnt in das Status Feld ein.</description>
        <field>Ven_Status_SIC_II__c</field>
        <formula>&quot;Abgelehnt&quot;</formula>
        <name>Ven_Opp_SIC_II_Status_Abgelehnt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Opp_SIC_II_Status_Approved</fullName>
        <description>Diese Feldaktualisierung trägt Approved in das Status Feld ein.</description>
        <field>Ven_Status_SIC_II__c</field>
        <formula>&quot;Genehmigt&quot;</formula>
        <name>Ven_Opp_SIC_II_Status_Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Opp_SIC_I_Status_Abgelehnt</fullName>
        <description>Diese Feldaktualisierung trägt Abgelehnt in das Status Feld ein.</description>
        <field>Ven_Status_SIC_I__c</field>
        <formula>&quot;Abgelehnt&quot;</formula>
        <name>Ven_Opp_SIC_I_Status_Abgelehnt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Opp_SIC_I_Status_Approved</fullName>
        <description>Diese Feldaktualisierung trägt Approved in das Status Feld ein.</description>
        <field>Ven_Status_SIC_I__c</field>
        <formula>&quot;Genehmigt&quot;</formula>
        <name>Ven_Opp_SIC_I_Status_Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Opp_SOM_Assessment_Status_Abgelehnt</fullName>
        <description>Diese Feldaktualisierung trägt Abgelehnt in das Status Feld ein.</description>
        <field>Ven_Status_SOM_Assessment__c</field>
        <formula>&quot;Abgelehnt&quot;</formula>
        <name>Ven_Opp_SOM_Assessment_Status_Abgelehnt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Opp_SOM_Assessment_Status_Approved</fullName>
        <description>Diese Feldaktualisierung trägt Approved in das Status Feld ein.</description>
        <field>Ven_Status_SOM_Assessment__c</field>
        <formula>&quot;Genehmigt&quot;</formula>
        <name>Ven_Opp_SOM_Assessment_Status_Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Opp_VIC_II_Status_Abgelehnt</fullName>
        <description>Diese Feldaktualisierung trägt Abgelehnt in das Status Feld ein.</description>
        <field>Ven_Status_VIC_II__c</field>
        <formula>&quot;Abgelehnt&quot;</formula>
        <name>Ven_Opp_VIC_II_Status_Abgelehnt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Opp_VIC_II_Status_Approved</fullName>
        <description>Diese Feldaktualisierung trägt Approved in das Status Feld ein.</description>
        <field>Ven_Status_VIC_II__c</field>
        <formula>&quot;Genehmigt&quot;</formula>
        <name>Ven_Opp_VIC_II_Status_Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Opp_VIC_I_Status_Abgelehnt</fullName>
        <description>Diese Feldaktualisierung trägt Abgelehnt in das Status Feld ein.</description>
        <field>Ven_Status_VIC_I__c</field>
        <formula>&quot;Abgelehnt&quot;</formula>
        <name>Ven_Opp_VIC_I_Status_Abgelehnt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ven_Opp_VIC_I_Status_Approved</fullName>
        <description>Diese Feldaktualisierung trägt Approved in das Status Feld ein.</description>
        <field>Ven_Status_VIC_I__c</field>
        <formula>&quot;Genehmigt&quot;</formula>
        <name>Ven_Opp_VIC_I_Status_Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>D%26A Set Acc Status</fullName>
        <actions>
            <name>DA_Set_Account_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.P7S1_OpportunityOwnerUnit__c</field>
            <operation>equals</operation>
            <value>d&amp;a Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set Account Status &quot;Bestandskunde&quot; on Opp Won</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_DA_Sales_OppName</fullName>
        <actions>
            <name>P7S1_DA_Sales_OppName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Aktualisiert den Opportunity Namen für d&amp;a Sales Opps nach der Konvention 
&lt;Jahr Schlusstermin&gt;_&lt;d&amp;a Sales Cluster&gt;_&lt;Account Name&gt;_&lt;d&amp;a Sales Asset&gt;
unter Berücksichtigung der maximalen Namenslänge</description>
        <formula>Owner.P7S1_Unit__c = &apos;d&amp;a Sales&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_FillOpportunityDescription%28255%29</fullName>
        <actions>
            <name>P7S1_UpdateDescription255</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Fills Custom Field Description (255) from Standard Description field for usage in formulas</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_Maxdome_OppName</fullName>
        <actions>
            <name>P7S1_Maxdome_OppName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Aktualisiert den Opportunity Namen für Maxdome-Opps nach der Konvention 
&lt;Jahr Schlusstermin&gt;_&lt;Unit&gt;_&lt;Account Name&gt;_&lt;Sales Bereich&gt;</description>
        <formula>RecordType.DeveloperName = &apos;Maxdome_Opportunity&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_OwnerChanged</fullName>
        <actions>
            <name>P7S1_OwnerChanged</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>sendet Mail bei Inhaber-Wechsel an alten und neuen User</description>
        <formula>ISCHANGED (OwnerId)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_SE_OppName</fullName>
        <actions>
            <name>P7S1_SE_OppName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Aktualisiert den Opportunity Namen für Sales Excellence Opps nach der Konvention 
&lt;Jahr Schlusstermin&gt;_&lt;Unit&gt;_&lt;Account Name&gt;</description>
        <formula>RecordType.DeveloperName = &apos;SalesExcellence_DEFAULT&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P7S1_SphereCopy</fullName>
        <actions>
            <name>P7S1_SphereCopy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.P7S1_Sphere__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Kopiert den Wert aus P7S1_Sphere, welches als Formel populiert ist in ein Textfeld um es der Freigaberegel verfügbar zu machen.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Probability Lost %3D 0</fullName>
        <actions>
            <name>P7S1_Probability_Lost_0</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsWon</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <description>Set Probability to 0% on Lost Opps</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_OppCloseDate</fullName>
        <actions>
            <name>SomDig_CloseDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Setzt das CloseDate auf 3 Wochen vor Kampagnenstart oder frühestens aktuelles Datum</description>
        <formula>AND(
OR( RecordType.DeveloperName = &quot;Standard&quot;, RecordType.DeveloperName = &quot;Standard&quot;
 ),
NOT (ISBLANK ( Kampagnenstart__c ))
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_OppName</fullName>
        <actions>
            <name>SomDig_OppName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Aktualisiert den Opportunity Namen für Digital Opps nach der Konvention Geschäftsjahr YYYY_Accountname_Primärkampagnenquelle</description>
        <formula>OR( RecordType.DeveloperName = &quot;Standard&quot;, RecordType.DeveloperName = &quot;Standard&quot;
 )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_Änderung Opp-Name</fullName>
        <actions>
            <name>Kampagnenname_ndern</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Bei Änderung Opp-Name wird auch der externe Kampagnenname geändert</description>
        <formula>OR( Kampagne__c =&quot;&quot;, ISCHANGED( Name ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_Angebote_erstellt</fullName>
        <actions>
            <name>SomTv_Angebot_neu</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>In Briefing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commitment (TV),Paket (TV),Zubuchung (TV)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_OppName</fullName>
        <actions>
            <name>SomTv_Opp_Name_TV</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Aktualisiert den Opportunity Namen für TV Opps nach der Konvention Geschäftsjahr YYYY_OppsDatensatztyp_Accountname</description>
        <formula>OR( RecordType.DeveloperName = &quot;SomTv_Commitment&quot;, RecordType.DeveloperName = &quot;SomTv_BuchungenOhneVertraege&quot;, RecordType.DeveloperName = &quot;SomTv_AdFactory&quot;, RecordType.DeveloperName = &quot;SomTv_Paket&quot;, RecordType.DeveloperName = &quot;SomTv_SalesPush&quot;, RecordType.DeveloperName = &quot;SomTv_Zubuchung&quot;,
RecordType.DeveloperName = &quot;SomTv_P7S1Intern&quot;
 )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_OppPhaseGeaendert</fullName>
        <actions>
            <name>SomTv_OppPhaseGeaendert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Geschlossene und gewonnene,Geschlossen und verloren,Rabatt freigegeben</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commitment (TV),Paket (TV),Zubuchung (TV)</value>
        </criteriaItems>
        <description>Informiert bestimmten Nutzerkreis über Phasenänderung (gewonnen, verloren, Rabatt freigegeben)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_OppRabattfreigabe</fullName>
        <actions>
            <name>SomTv_OppsRabattfreigabe</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Commitment (TV),Paket (TV),Zubuchung (TV)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Rabatt freigegeben</value>
        </criteriaItems>
        <description>CRMSALES-1423 Opportunity/Angebot: Workflow zur Benachrichtigung bzgl. Rabattfreigabe von Angeboten durch Ad Analytics &amp; Development</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_OppSchlusstermin</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>1/1/1999</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Opp AdFactory,Opp Buchungen ohne Verträge (TV),Opp Commitment (TV),Opp Paket (TV),Opp Zubuchung (TV)</value>
        </criteriaItems>
        <description>NUR bei Erstellung! nimmt Datum aus SomTv_Schlusstermin und schreibt es in CloseDate</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_ProbabilityRestore</fullName>
        <actions>
            <name>SomTv_ProbabilityRestore</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Wiederherstellen der manuell gepflegten Wahrscheinlichkeit beim Phasenwechsel</description>
        <formula>BEGINS(RecordType.DeveloperName, &apos;SomTv_&apos;)  &amp;&amp; ISCHANGED( StageName ) &amp;&amp; Probability = 0 &amp;&amp; NOT CONTAINS(TEXT(StageName), &apos;Geschlossen&apos;)  &amp;&amp; NOT CONTAINS(TEXT(StageName), &apos;Storniert&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_ProbabilitySave</fullName>
        <actions>
            <name>SomTv_ProbabilitySave</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Zwischenspeichern der manuell gepflegten Wahrscheinlichkeit</description>
        <formula>BEGINS(RecordType.DeveloperName, &apos;SomTv_&apos;) &amp;&amp; (    ISNEW()  || ISCHANGED( Probability ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomTv_UniqueKey</fullName>
        <actions>
            <name>SomTv_UniqueKey</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Buchungen ohne Verträge (TV),Commitment (TV),Paket (TV),Zubuchung (TV)</value>
        </criteriaItems>
        <description>füllt SomTv_UniqueKey</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Star_GenreComedy</fullName>
        <actions>
            <name>Star_UpdateComedy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Star_Comedy__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Star_Comedy__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Wird an der Opportunity Comedy als Genre ausgewählt, soll am Account auch das Genre Comedy ausgewählt werden.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Star_GenreFamilyEntertainment</fullName>
        <actions>
            <name>Star_UpdateFamilyEntertainment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Star_FamilyEntertainment__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Star_FamilyEntertainment__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Wird an der Opportunity Family Entertainment als Genre ausgewählt, soll am Account auch das Genre Family Entertainment ausgewählt werden.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Star_GenreFestivals</fullName>
        <actions>
            <name>Star_UpdateFestivals</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Star_Festivals__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Star_Festivals__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Wird an der Opportunity Festivals als Genre ausgewählt, soll am Account auch das Genre Festivals ausgewählt werden.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Star_GenreLabel</fullName>
        <actions>
            <name>Star_UpdateLabel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Star_Label__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Star_Label__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Wird an der Opportunity Label als Genre ausgewählt, soll am Account auch das Genre Label ausgewählt werden.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Star_GenreMusicals</fullName>
        <actions>
            <name>Star_UpdateMusicals</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Star_Musicals__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Star_Musicals__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Wird an der Opportunity Musicals als Genre ausgewählt, soll am Account auch das Genre Musicals ausgewählt werden.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Star_GenreOertlicheVeranstalter</fullName>
        <actions>
            <name>Star_UpdateOertlicheVerantstalter</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Star_OertlicheVeranstalter__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Star_OertlicheVeranstalter__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Wird an der Opportunity Örtliche Veranstalter als Genre ausgewählt, soll am Account auch das Genre Örtliche Veranstalter ausgewählt werden.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Star_GenreRockPopSchlagerTourneen</fullName>
        <actions>
            <name>Star_UpdateRockPopSchlagerTourneen</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Star_RockPopSchlagerTourneen__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Star_RockPopSchlagerTourneen__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Wird an der Opportunity Rock, Pop &amp; Schlager Tourneen als Genre ausgewählt, soll am Account auch das Genre Rock, Pop &amp; Schlager Tourneen ausgewählt werden.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Star_GenreSonstige</fullName>
        <actions>
            <name>Star_UpdateSonstige</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Star_Sonstige__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Star_Sonstige__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Wird an der Opportunity Sonstige als Genre ausgewählt, soll am Account auch das Genre Sonstige ausgewählt werden.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Star_UpdateMN3</fullName>
        <actions>
            <name>Star_UpdateMN3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Star_Default</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Star_UmsatzGesamtNettoFixVariabel__c</field>
            <operation>greaterThan</operation>
            <value>EUR 0</value>
        </criteriaItems>
        <description>Updates MN3 if Umsatz gesamt (fix + vairabel) greater 0</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Ven_Comment_Input_bei_Rejected</fullName>
        <actions>
            <name>Ven_Comment_Input_bei_Rejected</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>startsWith</operation>
            <value>Ven_</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <description>Schreibt die letzte Phase in das Feld &apos;Comment&apos;, wenn die Phase &apos;Rejected&apos; ausgewählt ist.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Ven_OppName</fullName>
        <actions>
            <name>Ven_OppName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Aktualisiert den Opportunity Namen für Ventures Opps nach der Konvention ClosingDate_OppsDatensatztyp_Accountname</description>
        <formula>Owner.P7S1_Unit__c = &apos;7Ventures&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Ven_Opp_Checkbox setzen bei VIC %26 SIC Board</fullName>
        <actions>
            <name>VIC_II_SIC_II_setzen</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VIC_I_SIC_I_setzen</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>startsWith</operation>
            <value>Ven</value>
        </criteriaItems>
        <description>Der Workflow setzt bei Seven Ventures Opportunities die Checkbox VIC I/SIC I &amp; VIC II/SIC II automatisch. Nur bei Neuanlage einer Opportunity läuft der Workflow los..</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Ven_Resubmission_einer_Opportunity</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>startsWith</operation>
            <value>Ven_</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Ven_Resubmission__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Automatische Erzeugung einer E-Mail zur Wiedervorlage für das angegebene Datum.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Ven_Resubmission_der_Opportunity</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Ven_Resubmission__c</offsetFromField>
            <timeLength>8</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Ven_Wiedervorlage bei geparkten Opp%2E</fullName>
        <actions>
            <name>Ven_Wiedervorlage_wegen_geparkter_Opportunity</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Ven_Parked__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Eine Wiedervorlage wird erstellt wenn eine Opportunity als geparkt markiert wird.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Ven_Wiedervorlage_wegen_geparkter_Opportunity</fullName>
        <assignedToType>owner</assignedToType>
        <description>Wiedervorlage wegen einer geparkten Opportunity.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Wiedervorlage wegen geparkter Opportunity</subject>
    </tasks>
</Workflow>
