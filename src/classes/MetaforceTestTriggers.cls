@isTest(seeAllData=true)
private class MetaforceTestTriggers {

    static testMethod void myUnitTest() {
        String strIntEnvName = System.Label.Metaforce_Integration_Environment;
        // Setup new origin Environment record
        Environment__c eOrigin = new Environment__c (
            Name = strIntEnvName,
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
        Manifest__c cs = new Manifest__c (
            Name = 'Test Change Set',
            Destination__c = eDestination.Id,
            Origin__c = eOrigin.Id);

        insert cs;

        // Setup new Change Junction record
        Change_Junction__c cj = new Change_Junction__c (
            Change__c = c.Id,
            Manifest__c = cs.Id);

        insert cj;

        System.debug('debug: ' + cj.Deployed__c);

        cj.Deployed__c = true;

        Test.startTest();
        update cj;
        Test.stopTest();

        System.debug('debug: ' + cj.Deployed__c);

        // Query for the parent's Change Set's attributes
        List<Manifest__c> csAttribs = new List<Manifest__c>([
            SELECT Id, Destination__r.Id
            FROM Manifest__c
            WHERE Id IN (
                SELECT Manifest__c
                FROM Change_Junction__c
                WHERE Manifest__c = :cj.Manifest__c)
            LIMIT 1]);
        System.debug('debug: ' + csAttribs);
        String dId = csAttribs[0].Destination__r.Id;
        System.debug('debug: ' + dId);


        // Query for the IDs of the changes that were inserted
/*        List<Change__c> listOfChanges = new List<Change__c>([
            SELECT Id, Environment__c
            FROM Change__c
            WHERE Environment__c = :dId
                AND Id IN (
                SELECT Change__c
                FROM Change_Junction__c
                WHERE Id = :cj.Id)
            LIMIT 1
                ]);
                */

        List<Change__c> listOfChanges = new List<Change__c>([
            SELECT Id, Environment__c, Metadata__c, Name__c, Type__c
            FROM Change__c
            WHERE Environment__c = :dId
            LIMIT 1
                ]);
        System.debug('debug: ' + listOfChanges);
        String csDestId = listOfChanges[0].Environment__c;

        // Assert that the Environment__c is the same as Parent__c on the interted change records
        System.assertEquals(dId, csDestId);

        //Verify if change__c row created/inserted for destination Environment has the same set of values as source Environment.
        //Verify if value for "Metadata__c" is same for both Environments.
        System.assertEquals(c.Metadata__c, listOfChanges[0].Metadata__c);

        //Verify if value for "Name__c" is same for both Environments.
        System.assertEquals(c.Name__c, listOfChanges[0].Name__c);

        //Verify if value for "Type__c" is same for both Environments.
        System.assertEquals(c.Type__c, listOfChanges[0].Type__c);

    }

    static testMethod void testCloneClosedManifest()
    {
    	String strIntEnvName = System.Label.Metaforce_Integration_Environment;

    	Environment__c intOrg = newEnvironment(strIntEnvName, 'Integration', 'In Use');
    	insert intOrg;

    	Environment__c devOrg1 = newEnvironment('devOrg', 'Development', 'In Use');
    	insert devOrg1;

    	Environment__c devOrg2 = newEnvironment('devOrg', 'Development', 'In Use');
    	insert devOrg2;

    	Change__c change1 = newChange(devOrg1.Id);
    	insert change1;

    	Manifest__c changeSet1 = newChangeSet(devOrg1.Id, intOrg.Id);
    	insert changeSet1;

    	Change_Junction__c changeJunction1 = newChangeJunction(change1.Id, changeSet1.Id);
    	insert changeJunction1;

    	changeSet1.Status__c = 'Pending Deployment';
    	update changeSet1;

    	changeJunction1.Deployed__c = true;

    	Test.startTest();
    	update changeJunction1;
    	Test.stopTest();

    	// Manifest__c clonedManifest = [SELECT Id FROM Manifest__c WHERE Origin__c = :intOrg.Id];
    }

    static testMethod void testCloneClosedManifestBulkChanges()
    {
    	String strIntEnvName = System.Label.Metaforce_Integration_Environment;

        Environment__c intOrg = newEnvironment(strIntEnvName, 'Integration', 'In Use');
        insert intOrg;

        Environment__c devOrg = newEnvironment('devOrg', 'Development', 'In Use');
        insert devOrg;

        Environment__c devOrg2 = newEnvironment('devOrg', 'Development', 'In Use');
        insert devOrg2;

        Environment__c devOrg3 = newEnvironment('devOrg', 'Development', 'In Use');
        insert devOrg3;

        Environment__c devOrg4 = newEnvironment('devOrg', 'Development', 'In Use');
        insert devOrg4;

        Environment__c devOrg5 = newEnvironment('devOrg', 'Development', 'In Use');
        insert devOrg5;

        List<Change__c> cList = new List<Change__c>();
        for (Integer x=0; x<200;x++) {
            Change__c change = newChange(devOrg.Id);
            cList.add(change);
        }
        insert cList;

        Manifest__c changeSet = newChangeSet(devOrg.Id, intOrg.Id);
        insert changeSet;

        List<Change_Junction__c> cjList = new List<Change_Junction__c>();
        for (Change__c c : cList) {
            Change_Junction__c changeJunction = newChangeJunction(c.Id, changeSet.Id);
            cjList.add(changeJunction);
        }
        insert cjList;

        changeSet.Status__c = 'Pending Deployment';
        update changeSet;

        for (Change_Junction__c cj : cjList) {
            cj.Deployed__c = true;
        }

        Test.startTest();
        update cjList;
        Test.stopTest();

    }

    static testMethod void testCloneClosedManifestBulkManifests()
    {
    	String strIntEnvName = System.Label.Metaforce_Integration_Environment;

        Environment__c intOrg = newEnvironment(strIntEnvName, 'Integration', 'In Use');
        insert intOrg;

        Environment__c devOrg = newEnvironment('devOrg', 'Development', 'In Use');
        insert devOrg;

        Environment__c devOrg2 = newEnvironment('devOrg', 'Development', 'In Use');
        insert devOrg2;

        Environment__c devOrg3 = newEnvironment('devOrg', 'Development', 'In Use');
        insert devOrg3;

        Environment__c devOrg4 = newEnvironment('devOrg', 'Development', 'In Use');
        insert devOrg4;

        Environment__c devOrg5 = newEnvironment('devOrg', 'Development', 'In Use');
        insert devOrg5;

        Change__c change = newChange(devOrg.Id);
        insert change;

        List<Manifest__c> csList = new List<Manifest__c>();
        for (Integer x=0; x<200; x++) {
	        Manifest__c changeSet = newChangeSet(devOrg.Id, intOrg.Id);
        	csList.add(changeSet);
        }
        insert csList;

        List<Change_Junction__c> cjList = new List<Change_Junction__c>();
        for (Manifest__c cs : csList) {
            Change_Junction__c changeJunction = newChangeJunction(change.Id, cs.Id);
            cjList.add(changeJunction);
        }
        insert cjList;

        for (Manifest__c cs : csList) {
	        cs.Status__c = 'Pending Deployment';
        }
        update csList;

        for (Change_Junction__c cj : cjList) {
            cj.Deployed__c = true;
        }

        Test.startTest();
        update cjList;
        Test.stopTest();
    }

    static Environment__c newEnvironment(String eName, String eType, String eStatus)
    {
    	// Setup new origin Environment record
        Environment__c e = new Environment__c (
        Name = eName,
        Organization_ID__c = genOrgId(),
        Status__c = eStatus,
        Type__c = eType);

    	return e;
    }

    static private string genOrgId() {
        String orgId = string.valueOf
        (
            math.abs(crypto.getRandomLong())
        ).substring(0, 14);

        return orgId;
    }

    static Change__c newChange(String envId)
    {
        // Setup new Change record
        Change__c c = new Change__c (
            Environment__c = envId,
            Metadata__c = 'Object',
            Name__c = 'Change__c',
            Type__c = 'Create');

        return c;
    }

    static Manifest__c newChangeSet(String origId, String destId)
    {
        // Setup new Change Set record
        Manifest__c cs = new Manifest__c (
            Name = 'Test Change Set',
            Origin__c = origId,
            Destination__c = destId);

        return cs;
    }

    static Change_Junction__c newChangeJunction(String cId, String csId)
    {
        // Setup new Change Junction record
        Change_Junction__c cj = new Change_Junction__c (
            Change__c = cId,
            Manifest__c = csId);

        return cj;
    }
}