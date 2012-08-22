@isTest(seeAllData=true)
private class MetaforceTestTriggers {

    static testMethod void myUnitTest() {
        
        // Setup new origin Environment record
        Environment__c eOrigin = new Environment__c (
            Name = 'Source Org',
            Organization_ID__c = '1239876',
            Status__c = 'In Use',
            Type__c = 'Integration');
            
        insert eOrigin;
        
        // Setup new destination Environment record
        Environment__c eDestination = new Environment__c (
            Name = 'Destination Org',
            Organization_ID__c = '456976',
            Status__c = 'In Use',
            Type__c = 'Production');
            
        insert eDestination;
                    
        // Setup new Change record
        Change__c c = new Change__c (
            Environment__c = eOrigin.Id,
            Metadata__c = 'Object',
            Name__c = 'Change__c',
            Type__c = 'Create');
            
        insert c;
        
        // Setup new Change Set record
        Change_Set__c cs = new Change_Set__c (
            Name = 'Test Change Set',
            Destination__c = eDestination.Id,
            Origin__c = eOrigin.Id);
        
        insert cs;
        
        // Setup new Change Junction record
        Change_Junction__c cj = new Change_Junction__c (
            Change__c = c.Id,
            Change_Set__c = cs.Id);
        
        insert cj;
        
        System.debug('debug: ' + cj.Deployed__c);   
        
        cj.Deployed__c = true;
        
        Test.startTest();
        update cj;
        Test.stopTest();

        System.debug('debug: ' + cj.Deployed__c);   

        // Query for the parent's Change Set's attributes
        List<Change_Set__c> csAttribs = new List<Change_Set__c>([
            SELECT Id, Destination__r.Id
            FROM Change_Set__c
            WHERE Id IN (
                SELECT Change_Set__c
                FROM Change_Junction__c
                WHERE Change_Set__c = :cj.Change_Set__c)
            LIMIT 1]);
        System.debug('debug: ' + csAttribs);
        String dId = csAttribs[0].Destination__r.Id;
        System.debug('debug: ' + dId);
                
        // Query for the IDs of the changes that were inserted
        List<Change__c> listOfChanges = new List<Change__c>([
            SELECT Id, Environment__c
            FROM Change__c
            WHERE Environment__c = :dId 
                AND Id IN (
                SELECT Change__c
                FROM Change_Junction__c
                WHERE Id = :cj.Id)
            LIMIT 1
                ]);
        System.debug('debug: ' + listOfChanges);
        String csDestId = listOfChanges[0].Environment__c;
        
        // Assert that the Environment__c is the same as Parent__c on the interted change records
        System.assertEquals(dId, csDestId);
    }
}