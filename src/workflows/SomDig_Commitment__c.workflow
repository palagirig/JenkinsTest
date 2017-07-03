<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SomDig_FreigabeErfolgt</fullName>
        <description>SomDig_Freigabe erfolgt</description>
        <protected>false</protected>
        <recipients>
            <field>SomDig_CommitmentInhaber__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SomDig_Genehmigungsprozess_Vorlagen/SomDig_CommitmentFreigegeben</template>
    </alerts>
    <fieldUpdates>
        <fullName>SomDig_BemerkungComm</fullName>
        <description>Genehmigungsgrenze in mindestens einer Rabattart erreicht, bitte zur Genehmigung einreichen</description>
        <field>SomDig_Bemerkung__c</field>
        <formula>&quot;Genehmigungsgrenze in mindestens einer Rabattart erreicht, bitte zur Genehmigung einreichen&quot;</formula>
        <name>SomDig_BemerkungComm</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_FlagZuruecksetzen</fullName>
        <description>Rabatt genehmigt. Flag Falsch</description>
        <field>SomDig_Flag__c</field>
        <literalValue>0</literalValue>
        <name>SomDig_Flag zurücksetzen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_Limit_Ueberschritten</fullName>
        <description>Rabatt nicht freigegeben, Flag auf WAHR</description>
        <field>SomDig_Flag__c</field>
        <literalValue>1</literalValue>
        <name>SomDig Flag setzen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_RabattGenehmigt</fullName>
        <description>das Kontrollkästchen wird auf &apos;TRUE&apos; gesetzt wenn Rabatt genehmigt ist</description>
        <field>SomDig_RabattGenehmigt__c</field>
        <literalValue>1</literalValue>
        <name>SomDig_Rabatt genehmigt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SomDig_genehmigt_False</fullName>
        <description>Rabatt nicht genehmigt</description>
        <field>SomDig_RabattGenehmigt__c</field>
        <literalValue>0</literalValue>
        <name>SomDig_Rabatt nicht genehmigt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SomDig_Genehmigt und Erhoeht</fullName>
        <actions>
            <name>SomDig_BemerkungComm</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_Limit_Ueberschritten</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_genehmigt_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Steuerung vom Approval-Prozess; zeigt ob die schon genehmigte Rabatte zusätzlich erhöht sind</description>
        <formula>AND(SomDig_RabattGenehmigt__c = TRUE,  OR( AND(SomDig_Kundenrabatt_InPage__c &gt;= 0.65,ISCHANGED(SomDig_Kundenrabatt_InPage__c),PRIORVALUE(SomDig_Kundenrabatt_InPage__c) &lt; SomDig_Kundenrabatt_InPage__c),  AND(SomDig_Kundenrabatt_InStream__c &gt;= 0.65,ISCHANGED(SomDig_Kundenrabatt_InStream__c),PRIORVALUE(SomDig_Kundenrabatt_InStream__c) &lt; SomDig_Kundenrabatt_InStream__c),  AND(SomDig_Sonderrabatt_InPage__c &gt;= 0.65,ISCHANGED(SomDig_Sonderrabatt_InPage__c),PRIORVALUE(SomDig_Sonderrabatt_InPage__c) &lt; SomDig_Sonderrabatt_InPage__c),  AND( SomDig_Agentur_Rabatt__c  &gt;= 0.65, ISCHANGED(SomDig_Agentur_Rabatt__c  ),PRIORVALUE(SomDig_Agentur_Rabatt__c  ) &lt; SomDig_Agentur_Rabatt__c  ),  AND(SomDig_Sonderrabatt_InStream__c &gt;= 0.65,ISCHANGED(SomDig_Sonderrabatt_InStream__c),PRIORVALUE(SomDig_Sonderrabatt_InStream__c) &lt; SomDig_Sonderrabatt_InStream__c) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_Limit Zurücksetzen</fullName>
        <actions>
            <name>SomDig_FlagZuruecksetzen</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_RabattGenehmigt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SomDig_Commitment__c.SomDig_Kundenrabatt_InPage__c</field>
            <operation>lessThan</operation>
            <value>0.65</value>
        </criteriaItems>
        <criteriaItems>
            <field>SomDig_Commitment__c.SomDig_Kundenrabatt_InStream__c</field>
            <operation>lessThan</operation>
            <value>0.65</value>
        </criteriaItems>
        <criteriaItems>
            <field>SomDig_Commitment__c.SomDig_Sonderrabatt_InPage__c</field>
            <operation>lessThan</operation>
            <value>0.65</value>
        </criteriaItems>
        <criteriaItems>
            <field>SomDig_Commitment__c.SomDig_Sonderrabatt_InStream__c</field>
            <operation>lessThan</operation>
            <value>0.65</value>
        </criteriaItems>
        <criteriaItems>
            <field>SomDig_Commitment__c.SomDig_Agentur_Rabatt__c</field>
            <operation>lessThan</operation>
            <value>0.65</value>
        </criteriaItems>
        <description>Das Kontrollkästchen wird auf &apos;FALSE&apos; gesetzt, falls Commitment unter dem Rabattlimit liegt und NICHT genehmigt werden muss.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SomDig_Limit Überschritten</fullName>
        <actions>
            <name>SomDig_BemerkungComm</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_Limit_Ueberschritten</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SomDig_genehmigt_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3 OR 4 OR 7) AND (5 OR 6)</booleanFilter>
        <criteriaItems>
            <field>SomDig_Commitment__c.SomDig_Kundenrabatt_InPage__c</field>
            <operation>greaterOrEqual</operation>
            <value>0.65</value>
        </criteriaItems>
        <criteriaItems>
            <field>SomDig_Commitment__c.SomDig_Kundenrabatt_InStream__c</field>
            <operation>greaterOrEqual</operation>
            <value>0.65</value>
        </criteriaItems>
        <criteriaItems>
            <field>SomDig_Commitment__c.SomDig_Sonderrabatt_InPage__c</field>
            <operation>greaterOrEqual</operation>
            <value>0.65</value>
        </criteriaItems>
        <criteriaItems>
            <field>SomDig_Commitment__c.SomDig_Sonderrabatt_InStream__c</field>
            <operation>greaterOrEqual</operation>
            <value>0.65</value>
        </criteriaItems>
        <criteriaItems>
            <field>SomDig_Commitment__c.SomDig_RabattGenehmigt__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>SomDig_Commitment__c.SomDig_Flag__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>SomDig_Commitment__c.SomDig_Agentur_Rabatt__c</field>
            <operation>greaterOrEqual</operation>
            <value>0.65</value>
        </criteriaItems>
        <description>Das Kontrolkästchen wird auf &apos;TRUE&apos; gesetzt, falls Rabattlimit zu genehmigen ist und das Feld zu genehmigen wird angehakt.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
