@isTest
private class IdeaControllerTest {

    static testMethod void testSortParamDefaultsToPopular() {
        IdeaTestUtil.setupTest();
        TestIdeaController controller = new TestIdeaController();
        System.assertEquals(IdeaController.SORT_POPULAR, controller.sortParam);    
    }
    
    static testMethod void testParamProperties() {
        IdeaTestUtil.setupTest();
        TestIdeaController controller = new TestIdeaController();
        ApexPages.currentPage().getParameters().put(IdeaController.PARAM_COMMUNITY_ID, 'apples');
        System.assertEquals('apples', controller.communityIdParam);         
        ApexPages.currentPage().getParameters().put(IdeaController.PARAM_SORT, 'apples');
        System.assertEquals('apples', controller.sortParam);         
        ApexPages.currentPage().getParameters().put(IdeaController.PARAM_CATEGORY, 'apples');
        System.assertEquals('apples', controller.categoryParam);         
        ApexPages.currentPage().getParameters().put(IdeaController.PARAM_STATUS, 'apples');
        System.assertEquals('apples', controller.statusParam);         
        ApexPages.currentPage().getParameters().put(IdeaController.PARAM_PAGE, 'apples');
        System.assertEquals('apples', controller.pageParam);         
        ApexPages.currentPage().getParameters().put(IdeaController.PARAM_USER_ID, 'apples');
        System.assertEquals('apples', controller.userParam);         
        ApexPages.currentPage().getParameters().put(IdeaController.PARAM_SEARCH_TERM, 'apples');
        System.assertEquals('apples', controller.searchTermParam);         
        ApexPages.currentPage().getParameters().put(IdeaController.PARAM_RETURN_URL, 'apples');
        System.assertEquals('apples', controller.returnUrlParam);         
    }
    
    static testMethod void testSiteSetupGetters() {
        IdeaTestUtil.setupTest();
        IdeasSiteSetup__c siteSetup = [ select id from IdeasSiteSetup__c ];
        Integer i = 0;
        siteSetup.HomeHeading1__c = String.valueOf(i++);
        siteSetup.HomeHeading2__c = String.valueOf(i++);
        siteSetup.HomeHeading3__c = String.valueOf(i++);
        siteSetup.HomeHeading4__c = String.valueOf(i++);
        siteSetup.HomeHeading5__c = String.valueOf(i++);
        siteSetup.HomeBody1__c = String.valueOf(i++);
        siteSetup.HomeBody2__c = String.valueOf(i++);
        siteSetup.HomeBody3__c = String.valueOf(i++);
        siteSetup.HomeBody4__c = String.valueOf(i++);
        siteSetup.HomeBody5__c = String.valueOf(i++);
        siteSetup.HomeRecentIdeasHeading__c = String.valueOf(i++);
        siteSetup.aboutHeading__c = String.valueOf(i++);
        siteSetup.aboutBody__c = String.valueOf(i++);
        siteSetup.loginHeading__c = String.valueOf(i++);
        siteSetup.loginBody__c = String.valueOf(i++);
        siteSetup.registerHeading__c = String.valueOf(i++);
        siteSetup.registerBody__c = String.valueOf(i++);
        siteSetup.forgotPasswordHeading__c = String.valueOf(i++);
        siteSetup.forgotPasswordBody__c = String.valueOf(i++);
        siteSetup.homeBannerImageUrl__c = String.valueOf(i++);
        siteSetup.aboutBannerImageUrl__c = String.valueOf(i++);
        siteSetup.footerText__c = String.valueOf(i++);
        siteSetup.customCssUrl__c = String.valueOf(i++);
        update siteSetup;
        
        TestIdeaController controller = new TestIdeaController();
        System.assertEquals(siteSetup.HomeHeading1__c, controller.getSiteSetup().homeHeading1__c);

        System.assertEquals(controller.homeHeading1, siteSetup.HomeHeading1__c);
        System.assertEquals(controller.homeHeading2, siteSetup.HomeHeading2__c);
        System.assertEquals(controller.homeHeading3, siteSetup.HomeHeading3__c);
        System.assertEquals(controller.homeHeading4, siteSetup.HomeHeading4__c);
        System.assertEquals(controller.homeHeading5, siteSetup.HomeHeading5__c);
        System.assertEquals(controller.homeBody1, siteSetup.HomeBody1__c);
        System.assertEquals(controller.homeBody2, siteSetup.HomeBody2__c);
        System.assertEquals(controller.homeBody3, siteSetup.HomeBody3__c);
        System.assertEquals(controller.homeBody4, siteSetup.HomeBody4__c);
        System.assertEquals(controller.homeBody5, siteSetup.HomeBody5__c);
        System.assertEquals(controller.homeRecentIdeasHeading, siteSetup.HomeRecentIdeasHeading__c);
        System.assertEquals(controller.aboutHeading, siteSetup.aboutHeading__c);
        System.assertEquals(controller.aboutBody, siteSetup.aboutBody__c);
        System.assertEquals(controller.loginHeading, siteSetup.loginHeading__c);
        System.assertEquals(controller.loginBody, siteSetup.loginBody__c);
        System.assertEquals(controller.registerHeading, siteSetup.registerHeading__c);
        System.assertEquals(controller.registerBody, siteSetup.registerBody__c);
        System.assertEquals(controller.forgotPasswordHeading, siteSetup.forgotPasswordHeading__c);
        System.assertEquals(controller.forgotPasswordBody, siteSetup.forgotPasswordBody__c);
        System.assertEquals(controller.homeBannerImageUrl, siteSetup.homeBannerImageUrl__c);
        System.assertEquals(controller.aboutBannerImageUrl, siteSetup.aboutBannerImageUrl__c);
        System.assertEquals(controller.footerText, siteSetup.footerText__c);
        System.assertEquals(controller.customCssUrl, siteSetup.customCssUrl__c);
    }
    
    static testMethod void testLayoutNotOverridden() {
        IdeaTestUtil.setupTest();
        TestIdeaController controller = new TestIdeaController();
        System.assert(!controller.getIsLayoutOverridden());      
    }

    static testMethod void testLayoutOverridden() {
        IdeaTestUtil.setupTest();
        IdeasSiteSetup__c siteSetup = [ select id from IdeasSiteSetup__c ];
        Integer i = 0;
        siteSetup.overrideIdeaLayout__c = String.valueOf(i++);
        update siteSetup;
        
        TestIdeaController controller = new TestIdeaController();
        System.assert(controller.getIsLayoutOverridden());
        System.assertEquals('/apex/'+siteSetup.overrideIdeaLayout__c, controller.getLayoutOverride());
    }

    static testMethod void testGetParams() {
        PageReference pageRef = Page.ideaList;
        Test.setCurrentPage(pageRef);
      
        TestIdeaController controller = new TestIdeaController();

        ApexPages.currentPage().getParameters().put(IdeaController.PARAM_CATEGORY, 'apples');
        System.assert(controller.getCategoryParamName() == IdeaController.PARAM_CATEGORY);
        System.assert(controller.getCategoryParam() == 'apples');

        ApexPages.currentPage().getParameters().put(IdeaController.PARAM_STATUS, 'done');
        System.assert(controller.getStatusParamName() == IdeaController.PARAM_STATUS);
        System.assert(controller.getStatusParam() == 'done');

        System.assert(controller.getSearchTermParamName() == IdeaController.PARAM_SEARCH_TERM);
        System.assert(controller.getCommunityNicknameParam() == IdeaController.PARAM_USER_COMMUNITY_NICKNAME);
        System.assert(controller.getUserParamName() == IdeaController.PARAM_USER_ID);

        ApexPages.currentPage().getParameters().put(IdeaController.PARAM_PAGE, '5');
        System.assert(controller.getPageParamInt() == 5);
    }

    static testMethod void testEscapeUrl() {
        System.assertEquals('http:%2F%2Fsalesforce.com%3Fc%3Dhello+world', IdeaController.escapeUrl('http://salesforce.com?c=hello world'));
    }

    static testMethod void testGetUrls() {
        TestIdeaController controller = new TestIdeaController();
        System.assert(controller.getListUrl().contains(IdeaController.URL_LIST));
        System.assertEquals(IdeaController.URL_VIEW, controller.getViewUrl());
        System.assertEquals(IdeaController.URL_PROFILE_ACTIVITY, controller.getUserUrl());
        System.assertEquals(IdeaController.URL_SEARCH_RESULTS, controller.getSearchResultsUrl());
        System.assertEquals(IdeaController.URL_REGISTER, controller.getRegisterUrl());
        System.assertEquals(IdeaController.URL_PROFILE_LIST, controller.getProfileListUrl());
        System.assertEquals(IdeaController.URL_ACCOUNT_DETAILS, controller.getAccountDetailsUrl());
        System.assertEquals(IdeaController.URL_HOME, controller.getHomeUrl());
    }

    static testMethod void testGetPageReferences() {
        IdeaTestUtil.setupTest();
        Test.setCurrentPage(Page.ideaList);

        TestIdeaController controller = new TestIdeaController();
        String communityId = IdeaTestUtil.getCommunityId();
        String ideaId = (IdeaTestUtil.makeIdea('idea', communityId)).id;
        
        IdeaTestUtil.checkUrl(IdeaController.URL_LIST, 
	                new String[] {IdeaController.PARAM_COMMUNITY_ID, IdeaController.PARAM_SORT}, 
	                new String[] {communityId, IdeaController.SORT_POPULAR}, 
                    controller.getListPage(null, null, null).getUrl());
        IdeaTestUtil.checkUrl(IdeaController.URL_LIST, 
                    new String[] {IdeaController.PARAM_COMMUNITY_ID, IdeaController.PARAM_SORT, IdeaController.PARAM_CATEGORY, IdeaController.PARAM_STATUS}, 
                    new String[] {communityId, IdeaController.SORT_RECENT, 'apples', 'oranges'}, 
                    controller.getListPage(IdeaController.SORT_RECENT, 'apples', 'oranges').getUrl());
        System.assertEquals(IdeaController.URL_VIEW+'#comments', controller.getIdeaViewPageComments().getUrl());
        System.assertEquals(IdeaController.URL_VIEW, controller.getIdeaViewPage().getUrl());
        ApexPages.currentPage().getParameters().put(IdeaController.PARAM_RETURN_URL, 'apples');
        IdeaTestUtil.checkUrl(IdeaController.URL_VIEW, IdeaController.PARAM_RETURN_URL, 'apples', controller.getIdeaViewPage().getUrl());
        IdeaTestUtil.checkUrl(IdeaController.URL_VIEW, IdeaController.PARAM_IDEA_ID, ideaId, IdeaController.getIdeaViewPage(ideaId).getUrl());
        IdeaTestUtil.checkUrl(IdeaController.URL_VIEW, new String[] {IdeaController.PARAM_IDEA_ID, IdeaController.PARAM_MESSAGE_CODE}, new String[] {ideaId, 'apples'}, controller.getIdeaViewPage(ideaId, 'apples').getUrl());
        IdeaTestUtil.checkUrl(IdeaController.URL_POST, IdeaController.PARAM_SORT, IdeaController.SORT_POPULAR, controller.getIdeaPostPage().getUrl());
        IdeaTestUtil.checkUrl(IdeaController.URL_ABOUT, controller.getAboutPage().getUrl());
        IdeaTestUtil.checkUrl(IdeaController.URL_LOGIN, controller.getLoginPage().getUrl());
        IdeaTestUtil.checkUrl(IdeaController.URL_LOGOUT, controller.getLogoutPage().getUrl());
        IdeaTestUtil.checkUrl(IdeaController.URL_REGISTER, controller.getRegisterPage().getUrl());
        IdeaTestUtil.checkUrl(IdeaController.URL_FORGOT_PASSWORD, controller.getForgotPasswordPage().getUrl());
        IdeaTestUtil.checkUrl(IdeaController.URL_PROFILE_ACTIVITY, IdeaController.PARAM_USER_ID, 'apples', IdeaController.getUserPage('apples').getUrl());
        IdeaTestUtil.checkUrl(IdeaController.URL_ACCOUNT_DETAILS, IdeaController.PARAM_USER_ID, 'apples', IdeaController.getIdeaAccountDetailsPage('apples').getUrl());
        IdeaTestUtil.checkUrl(IdeaController.URL_PROFILE_LIST, new String[] {IdeaController.PARAM_SORT, IdeaController.PARAM_USER_ID}, new String[] {'oranges', 'apples'}, IdeaController.getProfileListPage('apples', 'oranges').getUrl());
        IdeaTestUtil.checkUrl(IdeaController.URL_LIST, controller.getIdeaListPage().getUrl());
        IdeaTestUtil.checkUrl(IdeaController.URL_PROFILE_LIST, controller.getIdeaProfileListPage().getUrl());
    }
    
    // intentionally a different implementation of PageReference to ensure that our tests fail on PageReference behavioral changes
    static String getPageUrl(String url, String[] keys, String[] values) {
        if (keys.size() > 0) {
            url = url + '?';            
            for (Integer i=0; i<keys.size(); i++) {
                if (i > 0) url = url + '&';
                url = url + keys[i] + '=' + values[i];
            }
        }
        return url;                
    }
    
    static testMethod void testGetIsPage() {
        IdeaTestUtil.setupTest();
        Test.setCurrentPage(Page.ideaHome);
        TestIdeaController controller = new TestIdeaController();
        System.assert(controller.getIsHomePage());        
        System.assert(!controller.getIsViewPage());        
        System.assert(!controller.getIsAboutPage());        
        System.assert(!controller.getIsIdeaListPage());        
        System.assert(!controller.getIsProfileListPage());        
        System.assert(!controller.getIsRecentActivityPage());        
        System.assert(!controller.getIsSubmittedIdeasPage());        
        System.assert(!controller.getIsVotedIdeasPage());        
        System.assert(!controller.getIsRecentRepliesPage());        
        System.assert(!controller.getIsAccountDetailsPage());        

        Test.setCurrentPage(Page.ideaView);
        controller = new TestIdeaController();
        System.assert(!controller.getIsHomePage());        
        System.assert(controller.getIsViewPage());        

        Test.setCurrentPage(Page.ideaAbout);
        System.assert((new TestIdeaController()).getIsAboutPage());        

        Test.setCurrentPage(Page.ideaList);
        System.assert((new TestIdeaController()).getIsIdeaListPage());        

        Test.setCurrentPage(Page.ideaProfileActivity);
        System.assert((new TestIdeaController()).getIsRecentActivityPage());        

        PageReference pageRef = Page.ideaProfileList;
        pageRef.getParameters().put(IdeaController.PARAM_SORT, IdeaController.SORT_PROFILE_IDEAS);
        Test.setCurrentPage(pageRef);
        System.assert((new TestIdeaController()).getIsSubmittedIdeasPage());        

        pageRef = Page.ideaProfileList;
        pageRef.getParameters().put(IdeaController.PARAM_SORT, IdeaController.SORT_PROFILE_VOTES);
        Test.setCurrentPage(pageRef);
        System.assert((new TestIdeaController()).getIsVotedIdeasPage());        

        pageRef = Page.ideaProfileList;
        pageRef.getParameters().put(IdeaController.PARAM_SORT, IdeaController.SORT_PROFILE_RECENT_REPLIES);
        Test.setCurrentPage(pageRef);
        System.assert((new TestIdeaController()).getIsRecentRepliesPage());        

        Test.setCurrentPage(Page.ideaAccountDetails);
        System.assert((new TestIdeaController()).getIsAccountDetailsPage());        
    }
    
    static testMethod void testGetCurrentProfileListType() {
        PageReference pageRef = Page.ideaProfileList;
        pageRef.getParameters().put(IdeaController.PARAM_SORT, IdeaController.SORT_PROFILE_IDEAS);
        Test.setCurrentPage(pageRef);
        System.assertEquals(IdeaController.PROFILE_LIST_TYPE_IDEAS_SUBMITTED, (new TestIdeaController()).getCurrentProfileListType());        

        pageRef = Page.ideaProfileList;
        pageRef.getParameters().put(IdeaController.PARAM_SORT, IdeaController.SORT_PROFILE_VOTES);
        Test.setCurrentPage(pageRef);
        System.assertEquals(IdeaController.PROFILE_LIST_TYPE_IDEAS_VOTED_ON, (new TestIdeaController()).getCurrentProfileListType());        

        pageRef = Page.ideaProfileList;
        pageRef.getParameters().put(IdeaController.PARAM_SORT, IdeaController.SORT_PROFILE_RECENT_REPLIES);
        Test.setCurrentPage(pageRef);
        System.assertEquals(IdeaController.PROFILE_LIST_TYPE_RECENT_REPLIES, (new TestIdeaController()).getCurrentProfileListType());    
    }
    
    static testMethod void testCommunityIdInRequest() {
        IdeaTestUtil.setupTest();
        Test.setCurrentPage(Page.ideaList);
        TestIdeaController controller = new TestIdeaController();
        System.assert(!controller.getIsCommunityIdInRequest());    	

        PageReference newPage = controller.redirectWithCommunityId();
        System.assert(newPage.getUrl().contains(Page.ideaList.getUrl()));
        System.assert(newPage.getUrl().contains(IdeaController.PARAM_COMMUNITY_ID+'='+controller.getCommunityId()));
        
        Test.setCurrentPage(newPage);
        System.assert((new TestIdeaController()).getIsCommunityIdInRequest());     
    }

    static testMethod void testGetCommunityId() {
        IdeaTestUtil.setupTest();
        String communityId = IdeaTestUtil.getCommunityId();
        String ideaId = (IdeaTestUtil.makeIdea('idea', communityId)).id;
        IdeaViewController controller = new IdeaViewController(ideaId);
        System.assertEquals(communityId, controller.getCommunityId());
    }

    static testMethod void testUserChecks() {
        TestIdeaController controller = new TestIdeaController();
        System.assert(controller.getIsStandardUser());
        System.assert(controller.getIsLoggedIn());
        System.assertEquals([select communityNickname from User where id = :UserInfo.getUserId()].communityNickname, controller.getCommunityNicknameOfCurrentUser());
    }

    static testMethod void testGetCurrentPageUrl() {
        IdeaTestUtil.setupTest();
        Test.setCurrentPage(Page.ideaList);
        TestIdeaController controller = new TestIdeaController();
        System.assert(controller.getCurrentPageUrl().contains(Page.ideaList.getUrl()));
    }
    
    static testMethod void testGetPage() {
        System.assertEquals('', IdeaController.getPage(''));
        System.assertEquals('', IdeaController.getPage('/'));
        System.assertEquals('', IdeaController.getPage('//'));
        System.assertEquals('', IdeaController.getPage('/?'));
        System.assertEquals('', IdeaController.getPage('/?a=1'));
        System.assertEquals('', IdeaController.getPage('/?a=1&b=2'));
        System.assertEquals('foo', IdeaController.getPage('foo'));
        System.assertEquals('foo', IdeaController.getPage('/foo'));
        System.assertEquals('foo', IdeaController.getPage('//foo'));
        System.assertEquals('foo', IdeaController.getPage('/foo/'));
        System.assertEquals('foo', IdeaController.getPage('//foo//'));
        System.assertEquals('foo', IdeaController.getPage('/apex/foo'));
        System.assertEquals('foo', IdeaController.getPage('/apex/foo/'));
        System.assertEquals('foo', IdeaController.getPage('/foo?'));
        System.assertEquals('foo', IdeaController.getPage('/foo?a=1'));
        System.assertEquals('foo', IdeaController.getPage('/foo?a=1&b=2'));
        System.assertEquals('foo', IdeaController.getPage('/foo/?'));
        System.assertEquals('foo', IdeaController.getPage('/foo/?a=1'));
        System.assertEquals('foo', IdeaController.getPage('/foo/?a=1&b=2'));
        System.assertEquals('foo', IdeaController.getPage('apex/foo/?'));
        System.assertEquals('foo', IdeaController.getPage('apex/foo/?a=1'));
        System.assertEquals('foo', IdeaController.getPage('apex/foo/?a=1&b=2'));
        System.assertEquals('foo', IdeaController.getPage('/apex/foo/?'));
        System.assertEquals('foo', IdeaController.getPage('/apex/foo/?a=1'));
        System.assertEquals('foo', IdeaController.getPage('/apex/foo/?a=1&b=2'));
    }
    
    public class TestIdeaController extends IdeaController {}
}