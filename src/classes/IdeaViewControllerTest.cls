@isTest
private class IdeaViewControllerTest {
    
	private static final User testcurrentUser = IdeaTestUtil.getCurrentUser();
	private static final User testUser2 = IdeaTestUtil.getUser2();
	
    static testMethod void testGetPageName(){
        IdeaTestUtil.setupTest();
    	Idea testGetPageNameIdea = IdeaTestUtil.makeIdea(testcurrentUser, IdeaTestUtil.getCommunityId(), 'Test Idea', 'IdeaBody', '', 0);
        IdeaViewController controller = new IdeaViewController(testGetPageNameIdea.Id);
    	System.assertEquals(IdeaController.PAGE_VIEW, controller.getPageName(), 'Invalid result returned by getPageName()');
    }
    
    static testMethod void testGetNewComment(){
        IdeaTestUtil.setupTest();
    	Idea testGetNewCommentIdea = IdeaTestUtil.makeIdea(testcurrentUser, IdeaTestUtil.getCommunityId(), 'Test Idea', 'IdeaBody', '', 0);
        IdeaViewController controller = new IdeaViewController(testGetNewCommentIdea.id);
    	System.assertEquals(testGetNewCommentIdea.id, controller.getNewComment().IdeaId, 'Invalid new comment');
    }
    
    static testMethod void testGetNumChildIdeas() {
        IdeaTestUtil.setupTest();
        Idea testGetNumChildIdeasIdea = IdeaTestUtil.makeIdea(testcurrentUser, IdeaTestUtil.getCommunityId(), 'Test Idea', 'IdeaBody', '', 0);

        /* TRICKY: kf: Since we can't insert child ideas, the only test we can do is check that
           numChildIdeas returns zero. */

        IdeaViewController controller = new IdeaViewController(testGetNumChildIdeasIdea.ID);
        System.assertEquals(0, controller.getNumChildIdeas());
    }

    static testMethod void testGetChildIdeas() {
        IdeaTestUtil.setupTest();
        Idea testGetChildIdeasIdea = IdeaTestUtil.makeIdea(testcurrentUser, IdeaTestUtil.getCommunityId(), 'Test Idea', 'IdeaBody', '', 0);

        /* TRICKY: kf: Since we can't insert child ideas, the only test we can do is check that
           getChildIdeas returns an empty list */

        IdeaViewController controller = new IdeaViewController(testGetChildIdeasIdea.ID);
        System.assertEquals(0, controller.getChildIdeas().size());
    }

    static testMethod void testGetComments() {
    	IdeaTestUtil.setupTest();
    	Idea testGetCommentsIdea = IdeaTestUtil.makeIdea(testcurrentUser, IdeaTestUtil.getCommunityId(), 'Test Idea', 'IdeaBody', '', 0);
    	IdeaViewController controllerGetComments = new IdeaViewController(testGetCommentsIdea.id);   	
    	// cannot instantiate IdeaStandardController, always returns null
    	System.assertEquals(null, controllerGetComments.getComments(), 'getComments() should not return any comments for this idea');
    }
    
    static testMethod void testGetVotesUp() {
    	IdeaTestUtil.setupTest();
    	Idea testGetVotesUpIdea= IdeaTestUtil.makeIdea(testUser2, IdeaTestUtil.getCommunityId(), 'Test Idea', 'IdeaBody', '', 0);
    	Vote[] votesUp;
    	
    	IdeaViewController controllerIdeaOneVote = new IdeaViewController(testGetVotesUpIdea.id);   
    	votesUp = [select createdById, createdBy.communityNickname, type from vote where parentId = :testGetVotesUpIdea.id and type='Up' order by createdDate desc];
    	
    	//Test that idea has one vote from idea owner.	
    	System.assertEquals(controllerIdeaOneVote.getNumVotesUp(), 1, 'getVotesUp() should  return only one vote up');
    	System.assertEquals(votesUp[0], controllerIdeaOneVote.getVotesUp()[0], 'vote returned by getVotesUp() is invalid');
    	
		IdeaTestUtil.vote(testcurrentUser, testGetVotesUpIdea,'Up');
    	
    	IdeaViewController controllerIdeaVotesUp = new IdeaViewController(testGetVotesUpIdea.id);
    	
    	System.assertEquals(2, controllerIdeaVotesUp.getNumVotesUp(), 'Number of votes up returned by getNumVotesUp() is wrong');
    	System.assertEquals(2, controllerIdeaVotesUp.getVotesUp().size(), 'Number of votes up returned by getVotesUp() is wrong');
    }
    
    
    static testMethod void testGetVotesDown() {
    	IdeaTestUtil.setupTest();
    	Idea testGetVotesDownIdea = IdeaTestUtil.makeIdea(testUser2, IdeaTestUtil.getCommunityId(), 'Test Idea', 'IdeaBody', '', 0);
    	Vote[] votesDown;
    	
    	IdeaViewController controllerIdeaOneVote = new IdeaViewController(testGetVotesDownIdea.id);   
    	votesDown = [select createdById, createdBy.communityNickname, type from vote where parentId = :testGetVotesDownIdea.id and type='Down' order by createdDate desc];
    	
    	//Test that idea has no votes from idea owner.	
    	System.assertEquals(controllerIdeaOneVote.getNumVotesDown(), 0, 'getNumVotesDown() should return 0 votes down');
    	System.assertEquals(controllerIdeaOneVote.getVotesDown().size(), 0, 'getVotesDown() should return 0 votes down');
    	
		IdeaTestUtil.vote(testcurrentUser, testGetVotesDownIdea, 'Down');
    	
    	IdeaViewController controllerIdeaVotesDown = new IdeaViewController(testGetVotesDownIdea.id);
    	System.assertEquals(1, controllerIdeaVotesDown.getNumVotesDown(), 'Number of votes down returned by getVotesDown() is wrong');
    	System.assertEquals(1, controllerIdeaVotesDown.getVotesDown().size(), 'getVotesDown() should return 0 votes down');
    }
    
     static testMethod void testHowUserVoted() {
    	IdeaTestUtil.setupTest();
    	Idea testIdeaHowUserVotedUp = IdeaTestUtil.makeIdea(testUser2, IdeaTestUtil.getCommunityId(), 'Test Idea', 'IdeaBody', '', 0);
    	Idea testIdeaHowUserVotedDown = IdeaTestUtil.makeIdea(testUser2, IdeaTestUtil.getCommunityId(), 'Test Idea', 'IdeaBody', '', 0);
    	Vote voteUp = new Vote();
    	Vote voteDown = new Vote();
    	
    	IdeaViewController controllerTestHowUserVoted = new IdeaViewController(testIdeaHowUserVotedUp.id);   
    	
    	System.assertEquals(controllerTestHowUserVoted.howUserVoted, 'None', 'howUserVoted should be None');
    	
    	IdeaTestUtil.vote(testcurrentUser, testIdeaHowUserVotedUp, 'Up');
    	
    	IdeaViewController controllerTestHowUserVotedUp = new IdeaViewController(testIdeaHowUserVotedUp.id);
    	System.assertEquals(controllerTestHowUserVotedUp.howUserVoted, 'Up', 'howUserVoted should be Up');
    	
        IdeaTestUtil.vote(testcurrentUser, testIdeaHowUserVotedDown, 'Down');
    	
    	IdeaViewController controllerTestHowUserVotedDown = new IdeaViewController(testIdeaHowUserVotedDown.id);
    	System.assertEquals(controllerTestHowUserVotedDown.howUserVoted, 'Down', 'howUserVoted should be Down');
    }
}