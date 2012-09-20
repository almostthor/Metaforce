<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>OIT_Can_Edit_all_Integration_Destination</fullName>
        <field>DestinationType__c</field>
        <formula>TEXT( Destination__r.Type__c )</formula>
        <name>OIT Can Edit all Integration Destination</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_Closed</fullName>
        <field>Status__c</field>
        <literalValue>Closed</literalValue>
        <name>Set Status to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>All Changes Deployed</fullName>
        <actions>
            <name>Set_Status_to_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Change_Set__c.Num_Outstanding__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Change_Set__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending Deployment</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set DestinationType</fullName>
        <actions>
            <name>OIT_Can_Edit_all_Integration_Destination</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Change_Set__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
