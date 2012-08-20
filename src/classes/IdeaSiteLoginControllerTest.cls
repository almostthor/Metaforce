@isTest
private class IdeaSiteLoginControllerTest {

    static testMethod void testGettersSetters() {
        IdeaSiteLoginController controller = new IdeaSiteLoginController();
        String username = 'abc' + Crypto.getRandomInteger();
        controller.setUsername(username);
        controller.setPassword('abcdefg123456');

        System.assertEquals(controller.getPassword(), 'abcdefg123456');
        System.assertEquals(controller.getUsername(), username);            
    }
}