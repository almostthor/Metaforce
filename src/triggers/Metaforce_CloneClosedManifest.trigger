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

        // DECLARATIONS
        String intLabel = System.Label.Metaforce_Integration_Environment;
        ID INT_ENV;
        Boolean recordsToProcess = false;
        List<Environment__c> devEnvList = new List<Environment__c>();
        Set<ID> csIds = new Set<ID>();
        List<Change_Set__c> clonedCsList = new List<Change_Set__c>();
        Map<ID,Set<ID>> clonedCsMap = new Map<ID,Set<ID>>();
        Set<ID> clonedCsIds = new Set<ID>();
        List<Change_Junction__c> clonedCjList = new List<Change_Junction__c>();

        // LOGIC
        
        
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
        
        // Check to see if there are any records to process
        for (Change_Set__c cs : Trigger.New) {
            if (cs.Destination__c == INT_ENV 
               && cs.Status__c == 'Closed') {
                recordsToProcess = true;
            }
        }
        
        // Only proceed if there are actually records to process
        if (recordsToProcess) {
        
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
    
            // Map of all the Change Junctions in Trigger.New
            Map<ID,Change_Junction__c> cjMap 
               = new Map<ID,Change_Junction__c>([
                   select Id, Change_Set__c, Change__c
                   from Change_Junction__c 
                   where Change_Set__c in :Trigger.New]);
           
           // Add all the Manifests IDs associated with the change junctions to the set 
            for (Change_Junction__c cj : cjMap.values()) {
               csIds.add(cj.Change_Set__c);
            }
            
            // Map of all the Manifests associated with the set of Manifest IDs
            Map<ID, Change_Set__c> csMap = new Map<ID, Change_Set__c>([
                select Id, Name, Status__c, Origin__c, Parent__c, Destination__c, OwnerId
                from Change_Set__c
                where Status__c = 'Closed' 
                 and Destination__c = :INT_ENV 
                 and Id in :csIds]);
            
            for (Change_Set__c cs : csMap.values()) {
                for (Environment__c recepient : devEnvList) {  // Opportunity to refactor using sets & maps
                    if (recepient.Id != cs.Origin__c) {
                        Change_Set__c clonedCs = new Change_Set__c();
                        clonedCs = cs.clone();
            
                        clonedCs.Name = cs.Name + ' (Clone)';
                        clonedCs.Status__c = 'Pending Deployment';
                        clonedCs.Origin__c = INT_ENV;
                        clonedCs.Parent__c = cs.Id;
                        clonedCs.Destination__c = recepient.Id;  // Opportunity to refactor using sets & maps
                        clonedCs.OwnerId = recepient.OwnerId;  // Opportunity to refactor using sets & maps
            
                        clonedCsList.add(clonedCs);
                    }
                }
            }
            
            insert clonedCsList;
    
            // Build up map of original change set IDs and a
            // a set of child IDs of the cloned change sets
            for (Change_Set__c cs : clonedCsList) {
                
                Set<ID> s = new Set<ID>();
                
                if (clonedCsMap.containsKey(cs.parent__c)) {
                    s = clonedCsMap.get(cs.parent__c);
                    s.add(cs.id);
                    clonedCsMap.put(cs.parent__c, s);
                } else {
                    s.add(cs.id);
                    clonedCsMap.put(cs.parent__c, s);
                }
                
            }
            
            
            // Clone the change junction
            for (Change_Junction__c cj : cjMap.values()) {
                
                clonedCsIds = clonedCsMap.get(cj.change_set__c);
    
                // System.debug(clonedCsIds.size());
                
                if (clonedCsIds != null) {
                    for (ID id : clonedCsIds) {
                        Change_Junction__c clonedCj = cj.clone();
                        clonedCj.change_set__c = id;
                        clonedCj.change__c = cj.Change__c;
                        clonedCj.deployed__c = false;
                        clonedCjList.add(clonedCj);
                    }
                }
                
            }
            insert clonedCjList;
        }
    }   
}