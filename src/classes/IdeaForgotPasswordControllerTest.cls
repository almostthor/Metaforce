@isTest
private class IdeaForgotPasswordControllerTest {
    static testMethod void testRequiresUsername() {
        IdeaForgotPasswordController controller = new IdeaForgotPasswordController();
        controller.email = '';
        System.assert(!controller.isValid());
        controller.email = IdeaTestUtil.getCurrentUser().email;
        System.assert(controller.isValid());
    }

    static testMethod void testForgotPasswordWithoutUsername() {
        IdeaForgotPasswordController controller = new IdeaForgotPasswordController();
        System.assertEquals(null, controller.forgotPassword());
        System.assertEquals(1, ApexPages.getMessages().size());
    }
    
    static testMethod void testForgotPasswordWithUsername() {
        IdeaForgotPasswordController controller = new IdeaForgotPasswordController();
        controller.email = IdeaTestUtil.getCurrentUser().username;

        PageReference pageRef = controller.forgotPassword();
        
        // expect no validation errors
        System.assertEquals(0, ApexPages.getMessages().size());
        
        // Site.forgotPassword returns false in test mode, resulting in null returned         
        System.assertEquals(null, pageRef);
    }
}