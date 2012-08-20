public class AccountWrapperCls {
     public Boolean isSelected {get;set;}
     public Account cAccount {get;set;}

     public AccountWrapperCls(Account cAccount){
          this.cAccount = cAccount;
     }
}