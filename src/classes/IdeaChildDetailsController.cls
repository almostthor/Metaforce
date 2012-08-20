public class IdeaChildDetailsController extends IdeaDetailsAbstractController {

    static testMethod void testGetters() {
        IdeaTestUtil.setupTest();
        IdeaChildDetailsController controller = new IdeaChildDetailsController();
        Idea idea = IdeaTestUtil.makeIdea();
        controller.conIdea = idea;
        System.assertEquals(IdeaTestUtil.getCurrentUser().communityNickname, controller.getCreatedByCommunityNickname());
        System.assertEquals(IdeaTestUtil.getCurrentUser().Id, controller.getCreatedById());
    }

}