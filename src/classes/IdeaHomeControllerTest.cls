@isTest
private class IdeaHomeControllerTest {
    static testMethod void testRecentIdeas() {
        IdeaTestUtil.setupTest();
        IdeaHomeController controller = new IdeaHomeController();
    	for (Integer i=0; i<6; i++) {
            IdeaTestUtil.makeIdea('test', controller.getCommunityId());
    	}
        Idea[] ideas = controller.recentIdeas;
    	System.assertEquals(5, ideas.size());
    	// can't guarantee that ideas have a unique createdDate (granularity is at seconds level)
    	System.assertEquals('test', ideas[0].title); 
    }
}