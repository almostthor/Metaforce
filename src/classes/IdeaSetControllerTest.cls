public class IdeaSetControllerTest {
	
	static testMethod void testGetRecords() {
		Idea[] ideas = new Idea[100];
		IdeaSetController controller = new IdeaSetController(ideas, 1, 100, 20);
		System.assertEquals(100, controller.getRecords().size(), 'Get Records must fetch all the records');
	}

    static testMethod void testCalcNumPagesWithSOQLRowLimit() {
        System.assertEquals(50, IdeaSetController.calcNumPages(20000, 200, true));
    }

    static testMethod void testCalcNumPagesWithoutSOQLRowLimit() {
        System.assertEquals(100, IdeaSetController.calcNumPages(20000, 200, false));
    }

    static testMethod void testCalcNumPagesForNoRecords() {
        System.assertEquals(1, IdeaSetController.calcNumPages(0, 200, false));
    }        
    	
    static testMethod void testTotalNumPages() {
        Idea[] ideas = new Idea[100];
        IdeaSetController controller = new IdeaSetController(ideas, 1, 20000, 200);
        System.assertEquals(100, controller.totalNumPages);
    }

    static testMethod void testContructors() {
    	IdeaTestUtil.setupTest();
    	String communityId = IdeaTestUtil.getCommunityId();
        Idea ideaA = IdeaTestUtil.makeIdea('IdeaSetControllerTest', communityId, '');
        Idea ideaB = IdeaTestUtil.makeIdea('IdeaSetControllerTest', communityId, '');
        Idea ideaC = IdeaTestUtil.makeIdea('IdeaSetControllerTest', communityId, '');    	
        Database.queryLocator qL = Database.getQueryLocator([select Id from Idea where Id in (:ideaA.id, :ideaB.id, :ideaC.id)]);
        IdeaSetController controller = new IdeaSetController(qL,1);
        System.assert(controller.resultSize == 3 );
        System.debug('Result size: ' + controller.resultSize);
        System.assert(controller.getRecords().size() <= controller.pageSize);
        
        controller = new IdeaSetController(qL, 3, 1, 1);
        System.assertEquals(3, controller.resultSize);
        System.assertEquals(3, controller.totalNumPages);
        System.debug('Result size: ' + controller.resultSize);
    }        	
        	
}