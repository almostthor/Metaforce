@isTest
private class IdeaProfileControllerTest {
    static User me;
    static User her;
    static long now;

    static void setUp() {
        now = System.currentTimeMillis();
    	me = IdeaTestUtil.getCurrentUser();
        her = IdeaTestUtil.getUser2();
    }

    private static List<IdeaActivity> filter(List<IdeaActivity> activities, String activityTypeCode) {
        List<IdeaActivity> results = new List<IdeaActivity>();
        for (IdeaActivity activity : activities) {
            if (activity.getTypeCode().equals(activityTypeCode)) {
                results.add(activity);
            }
        }
        return results;
    }

    private static void assertMatchesIgnoringHref(String expected, String html) {
        String htmlIgnoringHrefPattern = Pattern.compile('(href *= *)\"[^\"]*\"').matcher(html).replaceAll('$1FOO');
        System.assertEquals(expected, htmlIgnoringHrefPattern);
    }
 
    static testMethod void testGetUserFromParam() {
        IdeaTestUtil.setupTest();
        setUp();
 
        IdeaProfileController controller = new IdeaProfileController();
        controller.userParam = me.id; 
        
        System.assert(controller.getUserFromParam().communitynickname == me.communitynickname, 'getUserFromParam should return the correct user');
    }

    static testMethod void testGetUserNicknameFromParam() {
        IdeaTestUtil.setupTest();
        setUp();
 
        IdeaProfileController controller = new IdeaProfileController();
        controller.userParam = me.id; 
        
        System.assert(controller.getUserNicknameFromParam() == me.communitynickname, 'getUserNicknameFromParam should return the correct community nickname');
    }

    static testMethod void testGetHasActivities() {
        IdeaTestUtil.setupTest();
        setUp();

        ID myIdea2 = IdeaTestUtil.makeIdea('My Idea2', '', me, null).id; 

        IdeaProfileController controller = new IdeaProfileController();
        controller.userParam = her.id;
        List<IdeaActivity> activities = controller.getActivities();
        System.debug('number of activities before voting on other user Idea : ' + activities.size());
        System.assert(controller.getHasActivities() == false, 'getHasActivities should return false when there is no activity');
         
        IdeaTestUtil.vote(her, myIdea2, 'Up');
        controller = new IdeaProfileController();
        controller.userParam = her.id;
        activities = controller.getActivities();
        System.debug('number of activities after voting on the other user Idea : ' + activities.size());
        System.assert(controller.getHasActivities() == true, 'getHasActivities should return true when there is atleast one activity(Vote)');
    }
    
    static testMethod void testGetActivities() {
        IdeaTestUtil.setupTest();
        setUp();    
        ID testIdea = IdeaTestUtil.makeIdea('My Idea', '', me, null).id;	
    	IdeaProfileController controller = new IdeaProfileController();
        controller.userParam = me.id; 
        
    	List<IdeaActivity> activities = controller.getActivities();
    	System.debug('number of activities when created a new Idea: ' + activities.size());
    	System.assert(activities.size() > 0, 'there should be atleast one (Idea) activity for the testuser');
    }

    static testMethod void testGroupActivitiesByDay(){
        IdeaTestUtil.setupTest();
        setUp();

        IdeaProfileController controller = new IdeaProfileController();
        DateTime today = DateTime.now();
        
        List<IdeaActivity> activities = new List<IdeaActivity>();
        
        activities.add(new IdeaActivity.IdeaCreatedActivity('ideaId', 'Idea A', null, today.addDays(-5), null, null));
        activities.add(new IdeaActivity.CommentCreatedActivity('ideaId', 'Idea A', null, today.addDays(-2), null, null, null, null, false));
        activities.add(new IdeaActivity.VoteCreatedActivity('ideaId', 'Idea A', null, today.addDays(-1), null, null, null, 'Up'));
        activities.add(new IdeaActivity.CommentCreatedActivity('ideaId', 'Idea A', null, today, null, null, null, null, false));

        List<IdeaActivitiesByDay> byDay = controller.groupActivitiesByDay(activities);
        System.assertEquals(4, byDay.size());
        System.assertEquals('Recent Activity', byDay.get(0).getSectionName());
        System.assertEquals('Yesterday', byDay.get(1).getSectionName());
        System.assertEquals('2 Days Ago', byDay.get(2).getSectionName());
        System.assertEquals('5 Days Ago', byDay.get(3).getSectionName());

        System.assertEquals(IdeaActivity.TYPE_COMMENT_GROUP, byDay.get(0).getActivity(0).getTypeCode());
        System.assertEquals(IdeaActivity.TYPE_VOTE_CREATED, byDay.get(1).getActivity(0).getTypeCode());
        System.assertEquals(IdeaActivity.TYPE_COMMENT_GROUP, byDay.get(2).getActivity(0).getTypeCode());
        System.assertEquals(IdeaActivity.TYPE_IDEA_CREATED, byDay.get(3).getActivity(0).getTypeCode());
    }

    static testMethod void testGetActivitiesByDay() {
        IdeaTestUtil.setupTest();
        setUp();

        Idea ideaA = IdeaTestUtil.makeIdea('Idea A', '', her, null);

        Idea myIdea1 = IdeaTestUtil.makeIdea('My Idea1', '', me, null);
        IdeaTestUtil.vote(her, myIdea1.id, 'Up');

        Idea ideaB = IdeaTestUtil.makeIdea('Idea B', '', her, null);
        IdeaTestUtil.vote(me, ideaB.id, 'Up');
        
        Idea myIdea2 = IdeaTestUtil.makeIdea('My Idea2', '', me, null);
        IdeaTestUtil.vote(her, myIdea2.id, 'Down');
         
        IdeaProfileController controller = new IdeaProfileController();
        controller.userParam = her.id;
        List<IdeaActivitiesByDay> byDay = controller.getActivitiesByDay();
        
        System.assertEquals(1, byDay.size());
        System.assertEquals('Recent Activity', byDay.get(0).getSectionName());
    }

    static testMethod void testHerProfileViewOfHerCommentOnHerIdea() {
        IdeaTestUtil.setupTest();
        setUp();
        Idea herIdea = IdeaTestUtil.makeIdea('Her Idea', '', her, null);
        IdeaTestUtil.makeIdeaComment(herIdea.id, 'comment she made on her idea.', her, 0);
        
        IdeaProfileController controller = new IdeaProfileController();
        controller.userParam = her.id;        
        
        IdeaActivity comment = filter(controller.getActivities(), IdeaActivity.TYPE_COMMENT_GROUP).get(0);
        assertMatchesIgnoringHref(' commented on <a href=FOO>Her Idea</a>', comment.getFirstLineHtml());
        System.assertEquals(her.communityNickname, comment.getActivityCreatorCommunityNickname());
    }
    
    static testMethod void testHerProfileViewOfYourCommentOnHerIdea() {
        IdeaTestUtil.setupTest();
        setUp();

        Idea herIdea = IdeaTestUtil.makeIdea('Her Idea', '', her, null);
        IdeaTestUtil.makeIdeaComment(herIdea.id, 'comment I made on her idea.', me, 0);
        
        IdeaProfileController controller = new IdeaProfileController();
        controller.userParam = her.id;        
        
        IdeaActivity comment = filter(controller.getActivities(), IdeaActivity.TYPE_COMMENT_GROUP).get(0);
        assertMatchesIgnoringHref(' commented on <a href=FOO>Her Idea</a>', comment.getFirstLineHtml());
        System.assertEquals(me.communityNickname, comment.getActivityCreatorCommunityNickname());
    }

    static testMethod void testHerProfileViewOfYourAndHerCommentsOnHerIdea(){
        IdeaTestUtil.setupTest();
        setUp();
        Idea herIdea = IdeaTestUtil.makeIdea('Her Idea', '', her, null);
        IdeaTestUtil.makeIdeaComment(herIdea.id, 'comment I made on her idea.', me, 0);
        IdeaTestUtil.makeIdeaComment(herIdea.id, 'comment she made on her idea.', her, 0);
        
        IdeaProfileController controller = new IdeaProfileController();
        controller.userParam = her.id;   

        List<IdeaActivity> activities = controller.getActivitiesByDay().get(0).getActivities();

        for (IdeaActivity activity : activities) {
            System.debug('Activity code :' + activity.getTypeCode());
        }
        
        List<IdeaActivity> comments = filter(activities, IdeaActivity.TYPE_COMMENT_GROUP);
        System.assertEquals(1, comments.size());
        IdeaActivity comment = comments.get(0);
        assertMatchesIgnoringHref(' and 1 other commented on <a href=FOO>Her Idea</a>', comment.getFirstLineHtml());
        System.assertEquals(her.communityNickname, comment.getActivityCreatorCommunityNickname());
    }

    static testMethod void testHerProfileViewOfHerCommentOnYourIdea() {
        IdeaTestUtil.setupTest();
        setUp();
        Idea myIdea = IdeaTestUtil.makeIdea('My Idea', '', me, null);
        IdeaTestUtil.makeIdeaComment(myIdea.id, 'comment she made on my idea.', her, 0);
        
        IdeaProfileController controller = new IdeaProfileController();
        controller.userParam = her.id;      
        
        List<IdeaActivity> comments = filter(controller.getActivitiesByDay().get(0).getActivities(), IdeaActivity.TYPE_COMMENT_GROUP);
        System.assertEquals(1, comments.size());
        IdeaActivity comment = comments.get(0);
        assertMatchesIgnoringHref(' commented on <a href=FOO>My Idea</a>', comment.getFirstLineHtml());
        System.assertEquals(her.communityNickname, comment.getActivityCreatorCommunityNickname());
    }

    static testMethod void testHerProfileViewOfYourAndHerCommentsOnYourIdea() {
        IdeaTestUtil.setupTest();
        setUp();
        Idea myIdea = IdeaTestUtil.makeIdea('My Idea', '', me, null);
        IdeaTestUtil.makeIdeaComment(myIdea.id, 'comment I made on my idea.', me, 0);
        IdeaTestUtil.makeIdeaComment(myIdea.id, 'comment she made on my idea.', her, 0);

        IdeaProfileController controller = new IdeaProfileController();
        controller.userParam = her.id;      
        
        List<IdeaActivity> comments = filter(controller.getActivitiesByDay().get(0).getActivities(), IdeaActivity.TYPE_COMMENT_GROUP);
        System.assertEquals(1, comments.size());
        IdeaActivity comment = comments.get(0);
        assertMatchesIgnoringHref(' commented on <a href=FOO>My Idea</a>', comment.getFirstLineHtml());
        System.assertEquals(her.communityNickname, comment.getActivityCreatorCommunityNickname());
    }
    
    static testMethod void testGetActivitiesForVotesOnOthersIdeas() {
        IdeaTestUtil.setupTest();
        setUp();
        
        Idea herIdea = IdeaTestUtil.makeIdea('Her Idea', '', her, null);
        IdeaTestUtil.vote(me, herIdea.id, 'Up');

        IdeaProfileController controller = new IdeaProfileController();
        controller.userParam = me.id;
                
        List<IdeaActivity> votes = filter(controller.getActivities(), IdeaActivity.TYPE_VOTE_CREATED);
        System.assertEquals(1, votes.size());

        IdeaActivity.VoteCreatedActivity vote = (IdeaActivity.VoteCreatedActivity)votes.get(0);
        System.assertEquals(herIdea.id, vote.getIdeaId());
        System.assertEquals('Her Idea', vote.getIdeaTitle());
        assertMatchesIgnoringHref(' promoted <a href=FOO>Her Idea</a>', vote.getFirstLineHtml());
        System.assertEquals(me.communityNickname, vote.getActivityCreatorCommunityNickname());
    }

    static testMethod void testGetActivitiesForIdeasByMe() {
        IdeaTestUtil.setupTest();
        setUp();
        IdeaProfileController controller = new IdeaProfileController();
        controller.userParam = me.id;
        List<IdeaActivity> ideas = filter(controller.getActivities(), IdeaActivity.TYPE_IDEA_CREATED);
        Integer initIdeasSize = ideas.size();

        Idea myIdea = IdeaTestUtil.makeIdea('My Idea', '', me, null);
        
        controller = new IdeaProfileController();
        controller.userParam = me.id;
        ideas = filter(controller.getActivities(), IdeaActivity.TYPE_IDEA_CREATED);
        System.assertEquals(initIdeasSize+1, ideas.size());

        IdeaActivity.IdeaCreatedActivity activity = (IdeaActivity.IdeaCreatedActivity)ideas.get(0);
        System.assertEquals(myIdea.id, activity.getIdeaId());
        System.assertEquals('My Idea', activity.getIdeaTitle());
        assertMatchesIgnoringHref(' submitted <a href=FOO>My Idea</a>', activity.getFirstLineHtml());
        System.assertEquals(me.communityNickname, activity.getActivityCreatorCommunityNickname());
    }
}