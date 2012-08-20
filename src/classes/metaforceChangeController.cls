public class metaforceChangeController {

  public list<Change__c> getChange() {
    return [select id, Name__c from Change__c limit 5];
  }
}