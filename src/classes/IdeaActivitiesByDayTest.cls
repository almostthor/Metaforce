public class IdeaActivitiesByDayTest {

    static testmethod void testGetSectionName() {
    	IdeaActivitiesByDay byDay = new IdeaActivitiesByDay(0);
    	System.assertEquals('Recent Activity', byDay.getSectionName());
    	byDay = new IdeaActivitiesByDay(1);
    	System.assertEquals('Yesterday', byDay.getSectionName());
    	byDay = new IdeaActivitiesByDay(4);
    	System.assertEquals('4 Days Ago', byDay.getSectionName());
    	byDay = new IdeaActivitiesByDay(100);
    	System.assertEquals('100 Days Ago', byDay.getSectionName());
    }

    static testmethod void testGetActivities() {
        IdeaActivitiesByDay byDay = new IdeaActivitiesByDay(0);
        
        System.assert(byDay.addActivity(new IdeaActivity.IdeaCreatedActivity('ideaId', 'Idea A', null, null, null, null)));
        System.assert(byDay.addActivity(new IdeaActivity.CommentCreatedActivity('ideaId', 'Idea A', null, null, null, null, null, null, false)));
        System.assert(byDay.addActivity(new IdeaActivity.VoteCreatedActivity('ideaId', 'Idea A', null, null, null, null, null, 'Up')));
        System.assert(!byDay.addActivity(new IdeaActivity.CommentCreatedActivity('ideaId', 'Idea A', null, null, null, null, null, null, false)));

        System.assertEquals(3, byDay.getActivities().size());

        System.assert(!byDay.getActivity(0).getIsLastActivityInList());
        System.assert(byDay.getActivity(2).getIsLastActivityInList());
        
    }

    static testmethod void testGetActivity() {
        IdeaActivitiesByDay byDay = new IdeaActivitiesByDay(0);
        
        System.assert(byDay.addActivity(new IdeaActivity.IdeaCreatedActivity('ideaId', 'Idea A', null, null, null, null)));
        System.assert(byDay.addActivity(new IdeaActivity.VoteCreatedActivity('ideaId', 'Idea A', null, null, null, null, null, 'Up')));
        System.assert(byDay.addActivity(new IdeaActivity.CommentCreatedActivity('ideaId', 'Idea A', null, null, null, null, null, null, false)));
        
        System.assertEquals(IdeaActivity.TYPE_IDEA_CREATED, byDay.getActivity(0).getTypeCode());
        System.assertEquals(IdeaActivity.TYPE_VOTE_CREATED, byDay.getActivity(1).getTypeCode());
        System.assertEquals(IdeaActivity.TYPE_COMMENT_GROUP, byDay.getActivity(2).getTypeCode());
    }

}