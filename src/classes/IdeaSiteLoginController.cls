/**
 * An apex page controller that exposes the site login functionality
 */
public class IdeaSiteLoginController extends IdeaController {
    String username;
    String password;

    public PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get('startUrl');
        PageReference result = Site.login(username, password, startUrl);
        if (result == null) {
            // try logging in with community nickname
            List<User> users = [select username from user where communityNickname = :username];
            if (users.size() == 1) {
                User u = users.get(0);
                result = Site.login(u.username, password, startUrl);
            }
        }
        if (result == null) {
            // try logging in with username looked up by email address
            List<User> users = [select username from user where email = :username];
            if (users.size() == 1) {
                User u = users.get(0);
                result = Site.login(u.username, password, startUrl);
            }
        }

        return result;
    }

    public String getUsername() {
        return this.username;
    }

    public String getPassword() {
        return this.password;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }

}