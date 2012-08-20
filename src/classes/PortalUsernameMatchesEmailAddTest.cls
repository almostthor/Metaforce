@isTest
private class PortalUsernameMatchesEmailAddTest {

	/*
	static testMethod void testUserUpdate() {
		String email = 'foo' + Math.random() + '@example.org';
		User u = new User();
        u.Username = email;
        u.Email = email;
        u.CommunityNickname = 'fooNickName';
        // lastName is a required field on user, but if it isn't specified, it gets defaulted to the username somewhere
        String accountId = getSiteSetup().PortalAccount__r.Id;
        String userId = Site.createPortalUser(u, accountId, 'password');
      	String username = 'bar' + Math.random() + '@example.org';
      	//u = new User();
      	//u.Id = userId;
      	u.Username = username;
      	update u;
	}
	*/

    static testMethod void testRegularAppUserUpdate() {
        User u = IdeaTestUtil.makeUser();
        String oldUsername = ([select username from user where id = :u.id]).username;
        String newUsername = 'bar' + Math.random() + '@example.org';
        u.username = newUsername;
        update u;
        String actualNewUsername = ([select username from user where id = :u.id]).username;
        System.assertEquals(newUsername, actualNewUsername);
        System.assert(newUsername != oldUsername);
    }

}