trigger Metaforce_CloneClosedManifest on Change_Set__c (after update) {

// Build a list of current dev orgs
// Build a list of changes parented to the items in the trigger collection
// For each item in the trigger collection
// Evaluate if Status__c == 'Closed'
// For each item in the dev org list
// Create a new Change_Set__c object with the new values
// Add the Change_Set__c object to a collection to be inserted
// For each item in the change collection where the Manifest Id = trigger manifest Id
// Create a new Change_Junction__c object linking the new manifest to the change
// Add the Change_Junction__c object to a collection to be inserted
// Insert Change_Set__c collection
// Insert Change_Junction__c collection

}