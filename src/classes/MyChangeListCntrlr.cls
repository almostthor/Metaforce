public class MyChangeListCntrlr {
     // PROPERTIES
     public List<ChangeWrapperCls> chgList {get;set;}
     public Set<String> selChangeNames {get;set;}
     public Boolean hasSelChg {get;set;}
     public String chgSetId {set;get;}
     public String chgSetEnv {set;get;}
     private List<Change_Junction__c> ncj;
     private SObject<Change_Set__c> chgSetPr;

     // CONSTRUCTOR
     public MyChangeListCntrlr(){
          chgList = new List<ChangeWrapperCls>();
          selChangeNames = new Set<String>();
          chgSetId = apexpages.currentpage().getparameters().get('csId');
          chgSetEnv = apexpages.currentpage().getparameters().get('csEnv');
          ncj = new List<Change_Junction__c>{};
          chgSetPr = [SELECT Id FROM Change_Set__c Where Id = :chgSetId];

          for(Change__c c : [SELECT Id, Name__c, CreatedDate, Metadata__c 
                                FROM Change__c 
                                WHERE Environment__c = :chgSetEnv AND Id NOT IN (SELECT Change__c 
                                                    FROM Change_Junction__c
                                                    WHERE Change_Set__c  = :chgSetId) 
                                ORDER BY CreatedDate ASC LIMIT 5]){
                                    chgList.add(new ChangeWrapperCls(c));
          }
     }

     // METHODS
     public void displaySelectedChangeNames(){
          selChangeNames.clear();
          hasSelChg = false;
          for(ChangeWrapperCls cWrapper : chgList){
               if(cWrapper.isSelected){
                    hasSelChg = true;
                    selChangeNames.add(cWrapper.cChange.Name__c);
               }
          }
     }
     
     public pageReference createChangeJunctions() {
        selChangeNames.clear();
        hasSelChg = false;
        // Iterate through the list of changes
        for(ChangeWrapperCls cWrapper: chgList){
            if(cWrapper.isSelected){
                hasSelChg = true;
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
}