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
