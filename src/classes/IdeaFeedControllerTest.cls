@isTest
private class IdeaFeedControllerTest {

    static testMethod void testGetFeedPageForListPages() {
        IdeaTestUtil.setupTest();
        IdeaFeedController controller = new IdeaFeedController();

        String[] paramKeys = new String[] {IdeaFeedController.FEED_PARAM_COMMUNITY, IdeaFeedController.FEED_PARAM_IDEA_TITLE_LINK};
        String[] paramValues = new String[] {controller.getCommunityId(), IdeaController.escapeUrl(controller.getViewUrl())};

        controller = new IdeaFeedController();
        controller.conFeedName = IdeaFeedController.TYPE_POPULAR;
        IdeaTestUtil.checkUrl(IdeaFeedController.POPULAR_IDEAS, paramKeys, paramValues, controller.feedPage.getUrl());        

        controller = new IdeaFeedController();
        controller.conFeedName = IdeaFeedController.TYPE_RECENT;
        IdeaTestUtil.checkUrl(IdeaFeedController.RECENT_IDEAS, paramKeys, paramValues, controller.feedPage.getUrl());        

        controller = new IdeaFeedController();
        controller.conFeedName = IdeaFeedController.TYPE_RECENT_COMMENTS;
        IdeaTestUtil.checkUrl(IdeaFeedController.RECENT_COMMENTS, paramKeys, paramValues, controller.feedPage.getUrl());        

        controller = new IdeaFeedController();
        controller.conFeedName = IdeaFeedController.TYPE_TOP;
        IdeaTestUtil.checkUrl(IdeaFeedController.TOP_IDEAS, paramKeys, paramValues, controller.feedPage.getUrl());
    }
    
    static testMethod void testGetFeedPageForProfilePages() {
        IdeaTestUtil.setupTest();
        IdeaFeedController controller = new IdeaFeedController();

        controller.conUserId = UserInfo.getUserId();
        String[] paramKeys = new String[] {IdeaFeedController.FEED_PARAM_NAME, IdeaFeedController.FEED_PARAM_COMMUNITY, IdeaFeedController.FEED_PARAM_IDEA_TITLE_LINK};
        String[] paramValues = new String[] {UserInfo.getUserId(), controller.getCommunityId(), IdeaController.escapeUrl(controller.getViewUrl())};

        controller = new IdeaFeedController();
        controller.conUserId = UserInfo.getUserId();
        controller.conFeedName = IdeaFeedController.TYPE_MY_COMMENTS;
        IdeaTestUtil.checkUrl(IdeaFeedController.MY_COMMENTS, paramKeys, paramValues, controller.feedPage.getUrl());        

        controller = new IdeaFeedController();
        controller.conUserId = UserInfo.getUserId();
        controller.conFeedName = IdeaFeedController.TYPE_VOTES_ON_MY_IDEAS;
        IdeaTestUtil.checkUrl(IdeaFeedController.VOTES_ON_MY_IDEAS, paramKeys, paramValues, controller.feedPage.getUrl());        
    }
    
    static testMethod void testGetFeedPageForDetailPages() {
        IdeaTestUtil.setupTest();
        IdeaFeedController controller = new IdeaFeedController();
        
        String ideaId = (IdeaTestUtil.makeIdea('idea', controller.getCommunityId())).id;
        controller.conIdeaId = ideaId;
        String[] paramKeys = new String[] {IdeaFeedController.FEED_PARAM_NAME, IdeaFeedController.FEED_PARAM_COMMUNITY, IdeaFeedController.FEED_PARAM_IDEA_TITLE_LINK};
        String[] paramValues = new String[] {ideaId, controller.getCommunityId(), IdeaController.escapeUrl(controller.getViewUrl())};

        controller.conFeedName = IdeaFeedController.TYPE_IDEA_DETAILS;
        IdeaTestUtil.checkUrl(IdeaFeedController.IDEA_DETAILS, paramKeys, paramValues, controller.feedPage.getUrl());        
    }

}