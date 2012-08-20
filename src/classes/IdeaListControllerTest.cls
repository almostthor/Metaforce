@isTest
private class IdeaListControllerTest {
    static testMethod void testFeedName() {
        checkFeedName(IdeaController.SORT_POPULAR, IdeaFeedController.TYPE_POPULAR);
        checkFeedName(IdeaController.SORT_RECENT, IdeaFeedController.TYPE_RECENT);
        checkFeedName(IdeaController.SORT_TOP, IdeaFeedController.TYPE_TOP);
        checkFeedName(IdeaController.SORT_COMMENTS, IdeaFeedController.TYPE_RECENT_COMMENTS);
        checkFeedName('foo', IdeaFeedController.TYPE_POPULAR);
    }
    
    static void checkFeedName(String sortValue, String expectedFeedName) {
        ApexPages.currentPage().getParameters().put(IdeaController.PARAM_SORT, sortValue);
        System.assertEquals(expectedFeedName, (new IdeaListController()).feedName);
    }
    
    static testMethod void testGetPageName() {
        System.assertEquals(IdeaController.PAGE_LIST, (new IdeaListController()).getPageName());            	
    }

    static testMethod void testIdeasWithVotes() {
    	// cannot instantiate IdeaStandardSetController, should return no ideas
        System.assertEquals(0, (new IdeaListController()).ideasWithVotes.size());                
    }
    
    static testMethod void testGetHasPreviousPage() {
        ApexPages.currentPage().getParameters().put(IdeaController.PARAM_PAGE, '-1');
        System.assertEquals(false, (new IdeaListController()).getHasPreviousPage());
        ApexPages.currentPage().getParameters().put(IdeaController.PARAM_PAGE, '0');
        System.assertEquals(false, (new IdeaListController()).getHasPreviousPage());
        ApexPages.currentPage().getParameters().put(IdeaController.PARAM_PAGE, '1');
        System.assertEquals(false, (new IdeaListController()).getHasPreviousPage());
        ApexPages.currentPage().getParameters().put(IdeaController.PARAM_PAGE, '2');
        System.assertEquals(true, (new IdeaListController()).getHasPreviousPage());
    }
}