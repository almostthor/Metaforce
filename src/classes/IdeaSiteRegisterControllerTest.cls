@isTest
private class IdeaSiteRegisterControllerTest {
	private static User existingUser = IdeaTestUtil.getCurrentUser();

    private static IdeaSiteRegisterController makeValidController() {
        IdeaSiteRegisterController controller = new IdeaSiteRegisterController();
        controller.communityNickname = 'abc' + Crypto.getRandomInteger();
        controller.password = 'abcdefg123456';
        controller.confirmPassword = 'abcdefg123456';
        controller.email = controller.communityNickname + '@example.com';

        System.assert(controller.isValid(), 'Should validate because all items are specified');
       
        
        return controller;
    }

    static testMethod void testRequiresVariousFields() {
        IdeaTestUtil.setupTest();
        IdeaSiteRegisterController controller = makeValidController();
        
        controller = makeValidController();
        controller.email = '';
        System.assert(!controller.isValid(), 'Should not validate because email is not specified');

        controller = makeValidController();
        controller.password = 'abc';
        controller.confirmPassword = 'xyz';
        System.assert(!controller.isValid(), 'Should not validate because password and confirmPassword do not agree');

        controller = makeValidController();
        controller.confirmPassword = '';
        System.assert(!controller.isValid(), 'Should not validate because confirmPassword is not specified');

        controller = makeValidController();
        controller.password = '';
        System.assert(!controller.isValid(), 'Should not validate because password is not specified');

        controller = makeValidController();
        controller.communityNickname = '';
        System.assert(!controller.isValid(), 'Should not validate because communityNickname is not specified');

		controller = makeValidController();
		controller.communityNickname = IdeaTestUtil.createRandomString(41);
		System.assert(!controller.isValid(), 'Should not validate because communityNickname is longer than 40');

		//Check for duplicate email
        controller = makeValidController();
 		controller.email = existingUser.email;
		System.assert(!controller.isValid(), 'Should not validate because Email is already used');
		
		//check for duplicate username
		controller = makeValidController();
 		controller.communityNickname = existingUser.communityNickname;
		System.assert(!controller.isValid(), 'Should not validate because communityNickname is already used');
		
		//registerUser should call isValid first
		System.assert(controller.registerUser() == null, 'register should call isValid() first, invalid info should return null');
    }
}