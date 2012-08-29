<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Manual_Change_to_TRUE</fullName>
        <field>Manual_Change__c</field>
        <literalValue>1</literalValue>
        <name>Set Manual Change to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Metadata is Manual Change</fullName>
        <actions>
            <name>Set_Manual_Change_to_TRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Change__c.Metadata__c</field>
            <operation>equals</operation>
            <value>Role Hierarchy</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
