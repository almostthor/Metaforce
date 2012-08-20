public class IdeaAccountDetailsController extends IdeaController {
    public User currentUser {
        get {
            if (currentUser == null) {
                currentUser = [select Id, Email, CommunityNickname from User where Id = :UserInfo.getUserId()];
            }
            return currentUser;
        }
        set;
    }
    public String oldPassword {get; set {oldPassword = value == null ? value : value.trim(); } }
    public String newPassword {get; set {newPassword = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }

    private void addErrorMessage(String message) {
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, message);
        ApexPages.addMessage(msg);
    }

    private void addConfirmMessage(String message) {
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM, message);
        ApexPages.addMessage(msg);
    }

    public PageReference changePassword() {
        if (oldPassword == '') {
            addErrorMessage('Old password is required.');
        }
        if (newPassword == '') {
            addErrorMessage('Password is required.');
        }
        if (confirmPassword == '') {
            addErrorMessage('Password confirmation is required.');
        }
        if (!ApexPages.hasMessages()) {
	        Site.changePassword(newPassword, confirmPassword, oldPassword);
            if (!ApexPages.hasMessages()) {
	            addConfirmMessage('Your password has been changed.');
	        }
        }
        return null;
    }
    
    public PageReference changeEmail() {
        if (currentUser.email == null || currentUser.email == '') {
            addErrorMessage('Email address is required.');
        }

        List<User> existingUsers = [select id from user where email = :currentUser.email or username = :currentUser.email];
	    if (existingUsers.size() > 0 && existingUsers[0].Id != currentUser.Id) {
	        addErrorMessage('That email address has already been registered.');
	    }
        
        if (!ApexPages.hasMessages()) {
        	try {
                update currentUser;
        	} catch (DmlException ex) {
        		if (ex.getMessage().contains('invalid email address')) {
                    addErrorMessage('Invalid email address');
        		}
        	}
	        if (!ApexPages.hasMessages()) {
	            addConfirmMessage('Your email address has been changed.');
	        }
        }
        return null;
    }

}