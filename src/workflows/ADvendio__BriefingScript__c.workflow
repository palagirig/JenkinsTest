<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ADvendio__NotificationEmailOnAdApprovalByClient</fullName>
        <description>NotificationEmailOnAdApprovalByClient</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ADvendio__ADvendioAdMaterialManagement/ADvendio__MMAdClientApprovalNotification</template>
    </alerts>
    <alerts>
        <fullName>ADvendio__NotificationEmailOnAdRejectionByClient</fullName>
        <description>NotificationEmailOnAdRejectionByClient</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ADvendio__ADvendioAdMaterialManagement/ADvendio__MMAdClientRejectionNotification</template>
    </alerts>
    <alerts>
        <fullName>ADvendio__NotificationEmailOnScriptApprovalByClient</fullName>
        <description>NotificationEmailOnScriptApprovalByClient</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ADvendio__ADvendioAdMaterialManagement/ADvendio__MMScriptClientApprovalNotification</template>
    </alerts>
    <alerts>
        <fullName>ADvendio__NotificationEmailOnScriptRejectionByClient</fullName>
        <description>NotificationEmailOnScriptRejectionByClient</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ADvendio__ADvendioAdMaterialManagement/ADvendio__MMScriptClientRejectionNotification</template>
    </alerts>
    <alerts>
        <fullName>ADvendio__NotificationOfAApproval</fullName>
        <description>Notification of AD approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ADvendio__ADvendioAdMaterialManagement/ADvendio__MMAdManagerApprovalNotification</template>
    </alerts>
    <alerts>
        <fullName>ADvendio__NotificationOfAdRejection</fullName>
        <description>Notification of AD Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ADvendio__ADvendioAdMaterialManagement/ADvendio__MMAdManagerRejectionNotification</template>
    </alerts>
    <alerts>
        <fullName>ADvendio__ScriptApprovalNotification</fullName>
        <description>Notification of script approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ADvendio__ADvendioAdMaterialManagement/ADvendio__MMScriptManagerApprovalNotification</template>
    </alerts>
    <alerts>
        <fullName>ADvendio__ScriptRejectionNotification</fullName>
        <description>Notification of Script Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ADvendio__ADvendioAdMaterialManagement/ADvendio__MMScriptManagerRejectionNotification</template>
    </alerts>
    <fieldUpdates>
        <fullName>ADvendio__AdPendingManagerApproval</fullName>
        <description>Update status to Ad pending manager approval</description>
        <field>ADvendio__Status__c</field>
        <literalValue>Advertise Pending manager approval</literalValue>
        <name>AD Pending Manager Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ADvendio__AdvertiseRejectedByManager</fullName>
        <field>ADvendio__Status__c</field>
        <literalValue>Advertise Rejected by Manager</literalValue>
        <name>Advertise rejected By Manager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ADvendio__GetPublicationDate</fullName>
        <field>ADvendio__PublicationDate__c</field>
        <name>GetPublicationDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ADvendio__ScriptStatusUpdateToPendingApproval</fullName>
        <description>Update Script status to pending for manager approval</description>
        <field>ADvendio__Status__c</field>
        <literalValue>Script Pending manager approval</literalValue>
        <name>Script Status Update to Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ADvendio__MMAutoPopulatePublicationDate</fullName>
        <active>true</active>
        <formula>OR( AND( ISNEW(),NOT(ISNULL(ADvendio__CampaignItem__c)) ), AND( NOT(ISNEW()),NOT(ISNULL(ADvendio__CampaignItem__c)), ISCHANGED(ADvendio__CampaignItem__c) ), AND(NOT(ISNULL(ADvendio__CampaignItem__c)), ISCHANGED(ADvendio__CampaignItem__c) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ADvendio__MMSendNotificationAfterAdApprovalByClient</fullName>
        <actions>
            <name>ADvendio__NotificationEmailOnAdApprovalByClient</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ADvendio__BriefingScript__c.ADvendio__Status__c</field>
            <operation>equals</operation>
            <value>Advertise Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ADvendio__MMSendNotificationAfterAdRejectionByClient</fullName>
        <actions>
            <name>ADvendio__NotificationEmailOnAdRejectionByClient</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ADvendio__BriefingScript__c.ADvendio__Status__c</field>
            <operation>equals</operation>
            <value>Advertise Rejected by Client</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ADvendio__MMSendNotificationAfterScriptApprovalByClient</fullName>
        <actions>
            <name>ADvendio__NotificationEmailOnScriptApprovalByClient</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ADvendio__BriefingScript__c.ADvendio__Status__c</field>
            <operation>equals</operation>
            <value>Script Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ADvendio__MMSendNotificationAfterScriptRejectionByClient</fullName>
        <actions>
            <name>ADvendio__NotificationEmailOnScriptRejectionByClient</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ADvendio__BriefingScript__c.ADvendio__Status__c</field>
            <operation>equals</operation>
            <value>Script Rejected by Client</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
