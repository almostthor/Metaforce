public class IdeaForgotPasswordController extends IdeaController {
    public String email {get; set;}

    public IdeaForgotPasswordController() {
    }

  	public PageReference forgotPassword() {
  	  if (!isValid()) {
  	    return null;
      }

        String username = null;
        if (email != null && email != '') {
            List<User> users = [select username from user where username = :email];
            if (users.size() == 1) {
                // exact match on username
                username = users.get(0).username;
            }
            else {
                users = [select username from user where email = :email];
                if (users.size() == 1) {
                    // exact match on email address
                    username = users.get(0).username;
                }
            }
        }

        if (username == null) {
            addErrorMessage('User not found');
            return null;
        }

  		boolean success = Site.forgotPassword(username);
  		if (success) {
  			PageReference pr = new PageReference(URL_FORGOT_PASSWORD_CONFIRM);
  			pr.setRedirect(true);
  			return pr;
  		}
  		return null;
  	}

  	public boolean isValid() {
      boolean valid = true;

  	  if (email == '') {
        addErrorMessage('Email address is required.');
        valid = false;
      }

  	  return valid;
    }

    private void addErrorMessage(String message) {
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, message);
        ApexPages.addMessage(msg);
    }
}