/**
 * An apex class that creates a portal user
 */
public class IdeaSiteRegisterController extends IdeaController {
    
    public IdeaSiteRegisterController () {
    }

    public String email {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }

    public boolean isValid() {
      boolean valid = true;

      if (communityNickname == null || communityNickname == '') {
          addErrorMessage('Display name is required.');
          valid = false;
      }
      
      if (communityNickname.length() > 40) {
          addErrorMessage('Display name cannot be longer than 40 characters.');
          valid = false;
      }      

      if (password == '') {
          addErrorMessage('Password is required.');
          valid = false;
      }

      if (confirmPassword == '') {
          addErrorMessage('Password confirmation is required.');
          valid = false;
      }

      if (password != confirmPassword) {
          addErrorMessage(Label.site.passwords_dont_match);
          valid = false;
      }

      if (email == '') {
          addErrorMessage('Email is required.');
          valid = false;
      }

      List<User> existingUsers = [select id from user where email = :email or username = :email];
      if (existingUsers.size() > 0) {
          addErrorMessage('That email address has already been registered.');
          valid = false;
      }

      existingUsers = [select id from user where communityNickname = :communityNickname];
      if (existingUsers.size() > 0) {
      	addErrorMessage('That display name already exists. Enter a unique display name.');
          valid = false;
      }

      return valid;
    }

    private void addErrorMessage(String message) {
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, message);
        ApexPages.addMessage(msg);
    }

    public PageReference registerUser() {

        if (!isValid()) {
            return null;
        }

        User u = new User();
        u.Username = email;
        u.Email = email;
        u.CommunityNickname = communityNickname;
        // lastName is a required field on user, but if it isn't specified, it gets defaulted to the username somewhere

        String accountId = getSiteSetup().PortalAccount__r.Id;

        String userId = Site.createPortalUser(u, accountId, password);

        if (userId != null) {
            if (password != null && password.length() > 1) {
                return Site.login(u.username, password, null);
            }
        }
        return null;
    }
    
}