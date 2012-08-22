public class MetaforceChangeWrapperCls {
     public Boolean isSelected {get;set;}
     public Change__c cChange {get;set;}

     public MetaforceChangeWrapperCls(Change__c cChange){
          this.cChange = cChange;
     }
}