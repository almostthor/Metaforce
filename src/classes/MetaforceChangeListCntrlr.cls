public class MetaforceChangeListCntrlr {
     // PROPERTIES
     public List<MetaforceChangeWrapperCls> chgList {get;set;}
     public Set<String> selChangeNames {get;set;}
     public Boolean hasSelChg {get;set;}
     public String chgSetId {set;get;}
     public String chgSetEnv {set;get;}
     private List<Change_Junction__c> ncj;
     private SObject<Change_Set__c> chgSetPr;

     // CONSTRUCTOR
     public MetaforceChangeListCntrlr(){
          chgList = new List<MetaforceChangeWrapperCls>();
          selChangeNames = new Set<String>();
          chgSetId = apexpages.currentpage().getparameters().get('csId');
          chgSetEnv = apexpages.currentpage().getparameters().get('csEnv');
          ncj = new List<Change_Junction__c>{};
          chgSetPr = [SELECT Id FROM Change_Set__c Where Id = :chgSetId];

          for(Change__c c : [SELECT Id, Name, Type__c, Metadata__c, Name__c, Description__c, Manual_Change__c, Sprint_Number__c, Story_ID__c, CreatedDate 
                                FROM Change__c 
                                WHERE Environment__c = :chgSetEnv AND Id NOT IN (SELECT Change__c 
                                                    FROM Change_Junction__c
                                                    WHERE Change_Set__c  = :chgSetId) 
                                ORDER BY CreatedDate DESC]){
                                    chgList.add(new MetaforceChangeWrapperCls(c));
          }
     }

     // METHODS
     public void displaySelectedChangeNames(){
          selChangeNames.clear();
//          hasSelChg = false;
          for(MetaforceChangeWrapperCls cWrapper : chgList){
               if(cWrapper.isSelected){
//                  hasSelChg = true;
                    selChangeNames.add(cWrapper.cChange.Name__c);
               }
          }
     }
     
     public pageReference createChangeJunctions() {
        selChangeNames.clear();
//        hasSelChg = false;
        // Iterate through the list of changes
        for(MetaforceChangeWrapperCls cWrapper: chgList){
            if(cWrapper.isSelected){
//                hasSelChg = true;
                // build a new change junction record and add to the change junction list
                ncj.add(new Change_Junction__c(
                    Change__c = cWrapper.cChange.Id,
                    Change_Set__c = chgSetId));
            }
        }
        // Insert new change junction records
        insert ncj;
        // Return Id of the originating change set.
        PageReference changeSetPage = new ApexPages.StandardController(chgSetPr).view();
        changeSetPage.setRedirect(true);
        return changeSetPage;
     }
     
    static testMethod void testMetaforceChangeListCntrlr() {
        
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
                
        ApexPages.currentPage().getParameters().put('csId', cs.Id);  
        ApexPages.currentPage().getParameters().put('csEnv', eOrigin.Id); 

        //////////////////////////////////////////////////////////////////                  
        MetaforceChangeListCntrlr metaforceChangeListController = new MetaforceChangeListCntrlr();
        
        metaforceChangeListController.displaySelectedChangeNames();
        metaforceChangeListController.createChangeJunctions();
        
        
        //////////////////////////////////////////////////////////////////
        //Test MetaforceChangeWrapperCls class with "isSelected" set to true.
        MetaforceChangeListCntrlr metaforceChangeListWrapperSelected = new MetaforceChangeListCntrlr();
        MetaforceChangeWrapperCls mWrapper = new MetaforceChangeWrapperCls(c);
        mWrapper.isSelected = true;
        metaforceChangeListWrapperSelected.chgList.add(mWrapper);        
                
        metaforceChangeListWrapperSelected.displaySelectedChangeNames();
        metaforceChangeListWrapperSelected.createChangeJunctions();        
        
    }     
}