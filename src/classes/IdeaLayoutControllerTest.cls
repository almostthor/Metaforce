@isTest
private class IdeaLayoutControllerTest {

    static testMethod void testGetPageUrl() {
        IdeaLayoutController controller = new IdeaLayoutController();
        Test.setCurrentPage(Page.ideaList);
        System.assertEquals(Page.ideaList.getUrl(), controller.currentPageUrl);
    }

    static testMethod void testGetCurrentPageString() {
        IdeaLayoutController controller = new IdeaLayoutController();
        Test.setCurrentPage(Page.ideaList);
        System.assertEquals('idealist', controller.getCurrentPageString());
    }
    
    static testMethod void testGetDoCacheThisPage() {
        checkDoCacheThisPage(IdeaController.URL_POST, false);
        checkDoCacheThisPage(IdeaController.URL_SEARCH_RESULTS, false);
        checkDoCacheThisPage(IdeaController.URL_REGISTER, false);
        checkDoCacheThisPage(IdeaController.URL_LOGIN, false);
        checkDoCacheThisPage(IdeaController.URL_FORGOT_PASSWORD, false);
        checkDoCacheThisPage(IdeaController.URL_FORGOT_PASSWORD_CONFIRM, false);
        checkDoCacheThisPage(IdeaController.URL_ACCOUNT_DETAILS, false);

        checkDoCacheThisPage(IdeaController.URL_HOME, true);
        checkDoCacheThisPage(IdeaController.URL_ABOUT, true);
        checkDoCacheThisPage(IdeaController.URL_LIST, true);
        checkDoCacheThisPage(IdeaController.URL_VIEW, true);
        checkDoCacheThisPage(IdeaController.URL_PROFILE_LIST, true);
        checkDoCacheThisPage(IdeaController.URL_PROFILE_ACTIVITY, true);
    }
    
    static void checkDoCacheThisPage(String pageStr, Boolean expectedValue) {
        PageReference pageRef = new PageReference(pageStr);
        Test.setCurrentPage(pageRef);
        System.assertEquals(expectedValue, (new IdeaLayoutController()).getDoCacheThisPage());
    }
    
    static testMethod void testGetCacheMaxAge() {
        IdeaTestUtil.setupTest();
        IdeasSiteSetup__c siteSetup = [ select id from IdeasSiteSetup__c ];
        siteSetup.cacheMaxAge__c = 555;
        update siteSetup;

        Test.setCurrentPage(Page.ideaEmpty);
        System.assertEquals(0, (new IdeaLayoutController()).getCacheMaxAge());
        Test.setCurrentPage(Page.ideaList);
        System.assertEquals(0, (new IdeaLayoutController()).getCacheMaxAge());

        /* requires sites with guest user
        System.runAs(IdeaTestUtil.getGuestUser()) {
	        Test.setCurrentPage(Page.ideaEmpty);
	        System.assertEquals(0, (new IdeaLayoutController()).getCacheMaxAge());
	        Test.setCurrentPage(Page.ideaList);
	        System.assertEquals(555, (new IdeaLayoutController()).getCacheMaxAge());
        }
        */
    }
}