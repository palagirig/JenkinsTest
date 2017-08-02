<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Star_OppTeamMember</fullName>
        <description>Star OppTeamMember</description>
        <protected>false</protected>
        <recipients>
            <field>UserId</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Excellence_Emails/Star_InfoMailOppTeam</template>
    </alerts>
    <rules>
        <fullName>Star_Info Mail</fullName>
        <actions>
            <name>Star_OppTeamMember</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityTeamMember.TeamMemberRole</field>
            <operation>equals</operation>
            <value>Star_Produktmanager</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
