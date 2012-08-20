@isTest
private class IdeaVoteControllerTest {

    static Idea setupAndCreateIdeaWithOtherUser() {
        IdeaTestUtil.setupTest();
        User testUser = IdeaTestUtil.getUser2();
        String communityId = IdeaTestUtil.getCommunityId();
        String ideaId = IdeaTestUtil.makeIdea(testUser, communityId, 'IdeaVoteControllerTest', '', '', 0).id;
        return [select id, voteTotal, createdBy.communityNickname, createdBy.id, createdDate from idea where id = :ideaId];
    }

    static testMethod void testGetVoteTotal() {
        Idea idea = setupAndCreateIdeaWithOtherUser();
        IdeaVoteController controller = new IdeaVoteController(idea);
        System.assertEquals(10, controller.getVoteTotal());
    }

    static testMethod void testGetUserHasNotVoted() {
        Idea idea = setupAndCreateIdeaWithOtherUser();
        IdeaVoteController controller = new IdeaVoteController(idea);
        controller.currentUserVoteType = 'None';
        System.assert(controller.getUserHasNotVoted());
        controller.currentUserVoteType = 'Up';
        System.assert(!controller.getUserHasNotVoted());
    }

    static testMethod void testCreateVote() {
        Idea idea = setupAndCreateIdeaWithOtherUser();
        IdeaVoteController controller = new IdeaVoteController(idea);
        System.assert(!controller.getNewVote());

        Integer originalVoteTotal = controller.getVoteTotal();

        System.assert(controller.createVote() == null); // fail because newVoteType not specified
        System.assertEquals(originalVoteTotal, controller.getVoteTotal());

        controller.newVoteType = 'Up';
        System.assertEquals('Up', controller.currentUserVoteType);
        System.assert(controller.createVote() == null);
        System.assertEquals(originalVoteTotal + 10, controller.getVoteTotal());
        System.assert(controller.getNewVote());
    }

}