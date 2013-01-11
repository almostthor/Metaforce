trigger Metaforce_CloneClosedManifest on Change_Set__c (after update) {

	// Create a map of Manifests that will be cloned.
	List<Change_Set__c> manifestList = new List<Change_Set__c>();

    // Find the environment that is considered the 'Integration' env.	
	private static final ID INTEGRATION_ENVIRONMENT = [SELECT Id FROM Environment__c WHERE Type__c = 'Integration' LIMIT 1].Id;

    // Grab a list of all the 'dev' orgs
    private static List<Environment__c> devEnvList = [SELECT Id, OwnerId FROM Environment__c WHERE Type__c = 'Development' AND Status__c = 'In Use'];
	
    // Find all the records that meet the enterance criteria.
    for (Change_Set__c updatedManifest : Trigger.New){
        if (updatedManifest.Status__c != null && updatedManifest.Status__c == 'Closed'){
        	if (updatedManifest.Destination__c != null && updatedManifest.Destination__c == INTEGRATION_ENVIRONMENT){
        		// Add the change set to the list to process
        		manifestList.add(updatedManifest);
        	}
        }
    }
    
    // Find the destionations that need to receive a clone of the manifest
    for (Environment__c recepient : devEnvList){
    	for (Change_Set__c manifest : manifestList){
    		if (recepient.Id != manifest.Origin__c){
			    // Clone the manifests
			    for (Change_Set__c mToClone : manifestList){
			    	Change_Set__c clonedManifest = new Change_Set__c();
			    	List<Change_Set__c> clonedManifestList = new List<Change_Set__c>();
			    	clonedManifest = mToClone.clone();
			    	
			    	// Because it a clone, only change the fields that need to be different.
			    	clonedManifest.Status__c = 'Open';
			    	clonedManifest.Origin__c = INTEGRATION_ENVIRONMENT;
			    	clonedManifest.Destination__c = recepient.Id;
			    	clonedManifest.OwnerId = recepient.OwnerId;
			    	
			    	// Add to the collection
			    	clonedManifestList.add(clonedManifest);
			    	insert clonedManifestList;
			    }
    		}
    	}
    }
    
}