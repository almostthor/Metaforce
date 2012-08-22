/*
 * God, this guy is awesome: 
 * http://techblog.appirio.com/2010/02/relationship-lookup-objects-in-triggers.html
 * Cound't have figured this out without this post.
 * Updated: 2012-08-22
 */

trigger MetaforceCreateChangesAtDestination on Change_Junction__c (after update) {

// Create a set of change ids
Set<id> changeIds = new Set<id>();

// Create a set of change set ids
Set<id> changeSetIds = new Set<id>();

// Create a list to hold the new change records
List<Change__c> nc = new List<Change__c>{};

    // Loop through all records in the Trigger.new collection
    for (Change_Junction__c updatedChangeJunction: Trigger.New){
    
        // Add the change ids to the set
        changeIds.add(updatedChangeJunction.Change__c);
        
        // Add the environment ids to the environment set
        changeSetIds.add(updatedChangeJunction.Change_Set__c);
    }

    // create a map so that Changes are locatable by their Id (key)
    Map<id, Change__c> changeMap = new Map<id, Change__c>(
    [SELECT Description__c, 
            Manual_Change__c,
            Metadata__c, 
            Name__c,
            Story_Id__c,
            Type__c  
     FROM Change__c 
     WHERE Id IN :changeIds]);
    
    // create a map so that Change Sets are locatable by their Id (key)
    Map<id, Change_Set__c> changeSetMap = new Map<id, Change_Set__c>(
    [SELECT Destination__c
//            Destination_Org_Id__c
     FROM Change_Set__c 
     WHERE Id IN :changeSetIds]);

    // Loop (again) through all records in the Trigger.new collection
    for (Change_Junction__c updatedChangeJunction: Trigger.New)
        
        // Only process the records that are complete
        if (updatedChangeJunction.Deployed__c == true){

                // Create new Change records and add them to the list    
                nc.add (new Change__c(
                    Description__c   = changeMap.get(updatedChangeJunction.Change__c).Description__c,
                    Environment__c   = changeSetMap.get(updatedChangeJunction.Change_Set__c).Destination__c,
                    Manual_Change__c = changeMap.get(updatedChangeJunction.Change__c).Manual_Change__c,
                    Metadata__c      = changeMap.get(updatedChangeJunction.Change__c).Metadata__c,
                    Name__c          = changeMap.get(updatedChangeJunction.Change__c).Name__c,
//                    Org_Id__c        = changeSetMap.get(updatedChangeJunction.Change_Set__c).Destination_Org_Id__c,
                    Parent__c        = updatedChangeJunction.Change__c,
                    Story_Id__c      = changeMap.get(updatedChangeJunction.Change__c).Story_Id__c,
                    Type__c          = changeMap.get(updatedChangeJunction.Change__c).Type__c));
    }

insert nc;

}