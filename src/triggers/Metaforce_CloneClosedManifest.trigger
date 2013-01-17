/*
 * Metaforce_CloneClosedManifest.trigger
 *
 * Author:  Philip Nelson <philip.nelson@roundcorner.com>
 * Created: Jan 12, 2013
 * Purpose: Trigger looks for closed manifests at the 'integration' 
 *          environment and clones them and their change junctions and 
 *          links the clones up to the other dev envs. 
 */

trigger Metaforce_CloneClosedManifest on Change_Set__c (after update) {        

    if (System.Label.Metaforce_Clone_Deployed == 'true') {

        // Create a list of Manifests that will be cloned.
        List<Change_Set__c> manifestList = new List<Change_Set__c>();  

        // Grab the name of the designated Integration Environment.
        String intLabel = System.Label.Metaforce_Integration_Environment;

        // Find the environment that is considered the 'Integration' env.	
        ID INT_ENV;
        try {
            INT_ENV = [SELECT Id 
                FROM Environment__c 
                WHERE Name = :intLabel
                AND Type__c = 'Integration' 
                AND Status__c = 'In Use' 
                LIMIT 1
                ].Id;
        } catch (System.QueryException e) {
            for (Change_Set__c cs : Trigger.New) {
                cs.addError('The integration environment "' 
                        + intLabel 
                        + '" is not currently in use. '
                        + 'Please notify your System Administrator.');
            }
        }

        // Grab a list of all the 'dev' orgs
        List<Environment__c> devEnvList = new List<Environment__c>();
        try {
            devEnvList = [SELECT Id, OwnerId 
                FROM Environment__c 
                WHERE Type__c = 'Development' 
                AND Status__c = 'In Use'];
        } catch (System.QueryException e) {
            for (Change_Set__c cs : Trigger.New) {
                cs.addError('There are no development environments in use. '
                        + 'Please notify your System Administrator.');
            }
        }

        Change_Set__c clonedManifest = new Change_Set__c();

        // Find all the records that meet the enterance criteria.
        for (Change_Set__c updatedManifest : Trigger.New){
            if (updatedManifest.Status__c != null 
                    && updatedManifest.Status__c == 'Closed'){
                if (updatedManifest.Destination__c != null 
                        && updatedManifest.Destination__c == INT_ENV){
                    // Add the change set to the list to process
                    manifestList.add(updatedManifest);
                }
            }
        }

        // Find the destionations that need to receive a clone of the
        // manifest
        for (Environment__c recepient : devEnvList){
            for (Change_Set__c manifest : manifestList){
                // Check to make sure we don't clone the manifest back
                // to the originating environment 
                if (recepient.Id != manifest.Origin__c){
                    // Clone the manifests
                    for (Change_Set__c mToClone : manifestList){
                        List<Change_Set__c> clonedManifestList 
                            = new List<Change_Set__c>();
                        clonedManifest = mToClone.clone();

                        // Because it a clone, only change the fields
                        // that need to be different.
                        clonedManifest.Name = mToClone.Name + ' (Clone)';
                        clonedManifest.Status__c = 'Pending Deployment';
                        clonedManifest.Origin__c = INT_ENV;
                        clonedManifest.Destination__c = recepient.Id;
                        clonedManifest.OwnerId = recepient.OwnerId;

                        // Add to the collection
                        clonedManifestList.add(clonedManifest);
                        insert clonedManifestList;
                    }

                    // Create change junctions to the changes that were
                    // inserted.
                    // Via the manifest clone the change junctions and then 
                    // change set id and deployed flag to false
                    List<Change_Junction__c> oldCjList = [SELECT Id, 
                        Change_Set__c, Change__c, IsCodeChange__c 
                            FROM Change_Junction__c 
                            WHERE Change_Set__c = :manifest.Id];

                    for (Change_Junction__c cjToClone : oldCjList){
                        Change_Junction__c clonedCj = new Change_Junction__c();
                        List<Change_Junction__c> clonedCjList 
                            = new List<Change_Junction__c>();
                        clonedCj = cjToClone.clone();

                        // Because it is a clone, only change the fields
                        // that need to be different. 
                        clonedCj.Deployed__c = false;
                        clonedCj.Change_Set__c = clonedManifest.Id;
                        clonedCj.Change__c = cjToClone.Change__c;
                        clonedCjList.add(clonedCj);
                        insert clonedCjList; 
                    } 
                }
            }
        }
    }   
}