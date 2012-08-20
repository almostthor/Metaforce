@isTest
private class IdeaAccountDetailsControllerTest {

    static testMethod void testChangeEmail() {
    	User currentUser = [select Id, Email, CommunityNickname from User where Id = :UserInfo.getUserId()];
        IdeaAccountDetailsController c = new IdeaAccountDetailsController();
        c.currentUser.email = 'testing-change-email@salesforce.com';
        System.assert(c.changeEmail()==null, 'changeEmail should always return null');
    }

    static testMethod void testChangeEmailWithEmptyEmail() {
        User currentUser = [select Id, Email, CommunityNickname from User where Id = :UserInfo.getUserId()];
        IdeaAccountDetailsController c = new IdeaAccountDetailsController();
        c.currentUser.email = null;
        System.assert(c.changeEmail()==null, 'changeEmail should always return null');
        System.assertEquals(ApexPages.getMessages().size(), 1);
        System.assertEquals('Email address is required.', ApexPages.getMessages()[0].getSummary());
    }

    static testMethod void testChangePassword() {
        User currentUser = [select Id, Email, CommunityNickname from User where Id = :UserInfo.getUserId()];
        IdeaAccountDetailsController c = new IdeaAccountDetailsController();
        c.oldPassword = 'asdf';
        c.newPassword = 'asdfasdf';
        c.confirmPassword = 'asdfasdf';
        System.assert(c.changePassword()==null, 'changePassword should always return null' );
        System.assertEquals(ApexPages.getMessages().size(), 1);
        System.assertEquals('Your password has been changed.', ApexPages.getMessages()[0].getSummary());
    } 

    static testMethod void testChangePasswordWithEmptyOldPassword() {
        User currentUser = [select Id, Email, CommunityNickname from User where Id = :UserInfo.getUserId()];
        IdeaAccountDetailsController c = new IdeaAccountDetailsController();
        c.oldPassword = '';
        c.newPassword = 'asdfasdf';
        c.confirmPassword = 'asdfasdf';
        System.assert(c.changePassword()==null, 'changePassword should always return null' );
        System.assertEquals(ApexPages.getMessages().size(), 1);
        System.assertEquals('Old password is required.', ApexPages.getMessages()[0].getSummary());
    }

    static testMethod void testChangePasswordWithEmptyNewPassword() {
        User currentUser = [select Id, Email, CommunityNickname from User where Id = :UserInfo.getUserId()];
        IdeaAccountDetailsController c = new IdeaAccountDetailsController();
        c.oldPassword = 'asdf';
        c.newPassword = '';
        c.confirmPassword = 'asdfasdf';
        System.assert(c.changePassword()==null, 'changePassword should always return null' );
        System.assertEquals(ApexPages.getMessages().size(), 1);
        System.assertEquals('Password is required.', ApexPages.getMessages()[0].getSummary());
    }

    static testMethod void testChangePasswordWithEmptyConfirmPassword() {
        User currentUser = [select Id, Email, CommunityNickname from User where Id = :UserInfo.getUserId()];
        IdeaAccountDetailsController c = new IdeaAccountDetailsController();
        c.oldPassword = 'asdf';
        c.newPassword = 'asdfasdf';
        c.confirmPassword = '';
        System.assert(c.changePassword()==null, 'changePassword should always return null' );
        System.assertEquals(ApexPages.getMessages().size(), 1);
        System.assertEquals('Password confirmation is required.', ApexPages.getMessages()[0].getSummary());
    }   
}