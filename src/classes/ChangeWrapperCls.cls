public class ChangeWrapperCls {
     public Boolean isSelected {get;set;}
     public Change__c cChange {get;set;}

     public ChangeWrapperCls(Change__c cChange){
          this.cChange = cChange;
     }
}