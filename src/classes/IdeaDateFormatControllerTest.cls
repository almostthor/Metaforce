@isTest
private class IdeaDateFormatControllerTest {

    static testMethod void testDateDisplay() {
        IdeaTestUtil.setupTest();
        User testUser = IdeaTestUtil.getCurrentUser();
    	
    	IdeaDateFormatController controller = new IdeaDateFormatController();
        System.assertEquals('', controller.getDateDisplay());

        Idea idea = IdeaTestUtil.makeIdea();
        controller.ideaParam = idea;
        System.assert(controller.getDateDisplay() != '');

        controller = new IdeaDateFormatController();
        DateTime baseTime = DateTime.newInstance(2009, 3, 2, 9, 30, 45);
        
        System.assertEquals('5 seconds ago', controller.formatDateTime(baseTime.addSeconds(-5), baseTime));
        System.assertEquals('5 minutes ago', controller.formatDateTime(baseTime.addSeconds(-5 * 60), baseTime));
        System.assertEquals('4:30 AM', controller.formatDateTime(baseTime.addSeconds(-5 * 60 * 60), baseTime));
        System.assertEquals('Yesterday', controller.formatDateTime(baseTime.addSeconds(-24 * 60 * 60 + 5), baseTime));
        System.assertEquals('3 days ago', controller.formatDateTime(baseTime.addSeconds(-3 * 24 * 60 * 60 + 5), baseTime));
        System.assertEquals('Feb 20, 2009', controller.formatDateTime(baseTime.addSeconds(-10 * 24 * 60 * 60 + 5), baseTime));
    }
    
}