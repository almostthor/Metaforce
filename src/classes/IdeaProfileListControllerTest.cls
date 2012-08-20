@isTest
private class IdeaProfileListControllerTest {
	
	static testMethod void testGetPageName() {
		IdeaProfileListController controller = new IdeaProfileListController();
		System.assertEquals(IdeaController.PAGE_PROFILE_LIST, controller.getPageName());
	}

    static testMethod void testGetIdeas() {
        // cannot instantiate IdeaStandardSetController, should return null
        System.assertEquals(null, (new IdeaProfileListController()).getIdeas());                
    }
	
    static testMethod void testIdeasWithVotes() {
        // cannot instantiate IdeaStandardSetController, should return no ideas
        System.assertEquals(0, (new IdeaProfileListController()).ideasWithVotes.size());                
    }

    static testMethod void testGetHasPreviousPage() {
        IdeaProfileListController controller = new IdeaProfileListController();
        controller.pageParam = '1';
        System.assert(!controller.getHasPreviousPage());
        controller.pageParam = '2';
        System.assert(controller.getHasPreviousPage());                
    }    

    static testMethod void testGetHasNextPage() {
        IdeaProfileListController controller = new IdeaProfileListController();
        controller.ideas = new Idea[10];
        System.assert(!controller.getHasNextPage());
        controller.ideas = new Idea[IdeaProfileListController.MAX_NUMBER_OF_IDEAS_PER_PAGE];
        System.assert(controller.getHasNextPage());                
    } 
}