trigger Metaforce_CloneClosedManifest on Change_Set__c (after update) {

	// Create a map of Manifests that will be cloned.
	List<Change_Set__c> manifestList = new List<Change_Set__c>();
	
    // Find all the records that meet the enterance criteria.
    for (Change_Set__c updatedManifest : Trigger.New){
        if (updatedManifest.Status__c != null && updatedManifest.Status__c == 'Closed'){
        	// TODO - Remove hard-coded Id (Id points to Krang environment record)
        	if (updatedManifest.Destination__c != null && updatedManifest.Destination__c == 'a0UA000000JMYHs'){
        		// Add the change set to the list to process
        		manifestList.add(updatedManifest);
        	}
        }
    }
    
    // Clone the manifests
    for (Change_Set__c mToClone : manifestList){
    	Change_Set__c clonedManifest = new Change_Set__c();
    	List<Change_Set__c> clonedManifestList = new List<Change_Set__c>();
    	clonedManifest = mToClone.clone();
    	clonedManifestList.add(clonedManifest);
    	insert clonedManifestList;
    }
}