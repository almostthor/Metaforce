public class IdeaActivityTest {

    static testMethod void testIdeaActivity() {
        IdeaTestUtil.setupTest();
        String communityId = IdeaTestUtil.getCommunityId();
        User currentUser = IdeaTestUtil.getCurrentUser();

        String title = 'test idea';
        Idea idea1 = IdeaTestUtil.makeIdea(title, communityId);

        Datetime now = DateTime.now();
        String nickname = 'currentUser';
        IdeaActivity.IdeaCreatedActivity iai = new IdeaActivity.IdeaCreatedActivity(idea1.id, title, currentUser.id, now, nickname, communityId);

        System.assertEquals(idea1.id, iai.getIdeaId());
        System.assertEquals(title, iai.getIdeaTitle());
        System.assertEquals(currentUser.id, iai.getActivityCreatorId());
        System.assertEquals(nickname, iai.getActivityCreatorCommunityNickname());
        System.assert(iai.getFirstLineHtml().startsWith(' submitted'));
        System.assert(iai.getFirstLineHtml().contains(title));
        System.assert(!iai.getShouldShowSecondLineHtml());
        System.assert(!iai.getIsLastActivityInList());
        System.assert(!iai.isConcatenatableWith(null));
        System.assertEquals('IdeaCreatedActivity', iai.getTypeCode());
        System.assertEquals(now, iai.getDate());
    }

    static testMethod void testCommentActivity() {
        IdeaTestUtil.setupTest();
        String communityId = IdeaTestUtil.getCommunityId();
        User currentUser = IdeaTestUtil.getCurrentUser();
        User commentingUser = IdeaTestUtil.getUser2();
        Idea idea1 = IdeaTestUtil.makeIdea('1', communityId);
        IdeaComment newComment = IdeaTestUtil.makeIdeaComment(idea1.id, 'comment body', commentingUser, 0);
        String nickname = 'commentingUser';
        IdeaActivity.CommentCreatedActivity iac = new IdeaActivity.CommentCreatedActivity(idea1.id, 'hello', currentUser.id, DateTime.now(), newComment.id, 'asdf', nickname, commentingUser.id, true);

        System.assertEquals(commentingUser.id, iac.getActivityCreatorId());
        System.assertEquals(nickname, iac.getActivityCreatorCommunityNickname());
        System.assert(iac.getFirstLineHtml().startsWith(' commented on'));
        System.assert(iac.getFirstLineHtml().contains('hello'));
        System.assert(iac.isConcatenatableWith(iac));
        System.assert(iac.getShouldShowSecondLineHtml());
        System.assert(iac.getSecondLineHtml().contains('asdf'));
        System.assertEquals('CommentGroup', iac.getTypeCode());
        System.assertEquals(newComment.id, iac.getCommentId());
        System.assertEquals(commentingUser.id, iac.getCommentorId());
        System.assertEquals(nickname, iac.getCommentorNickname());
        System.assert(iac.getCommentorNicknames().contains(nickname));
        System.assert(iac.getCommentCount() > 0);

        IdeaActivity.CommentCreatedActivity iac2 = new IdeaActivity.CommentCreatedActivity(idea1.id, 'hello', currentUser.id, DateTime.now(), newComment.id, 'asdf', 'notnori', commentingUser.id, true);
        iac.concatenate(iac2);
        System.assert(iac.getFirstLineHtml().contains('other commented on'));
        
        System.assertEquals('', iac.makeCommentSnippet(null, false, 1));
    }

    static testMethod void testVoteActivity() {
        IdeaTestUtil.setupTest();
        String communityId = IdeaTestUtil.getCommunityId();
        User currentUser = IdeaTestUtil.getCurrentUser();
        Idea idea1 = IdeaTestUtil.makeIdea('1', communityId);
        String nickname = 'votingUser';
        IdeaActivity.VoteCreatedActivity ia = new IdeaActivity.VoteCreatedActivity(idea1.id, 'hello', currentUser.id, DateTime.now(), nickname, currentUser.id, communityId,'Up');
        System.assertEquals(currentUser.id, ia.getActivityCreatorId());
        System.assertEquals(nickname, ia.getActivityCreatorCommunityNickname());
        System.assert(ia.getFirstLineHtml().startsWith(' promoted'));
        System.assert(ia.getFirstLineHtml().contains('hello'));
        System.assert(!ia.isConcatenatableWith(null));
        System.assertEquals(null, ia.getSecondLineHtml());
        System.assertEquals('VoteCreatedActivity', ia.getTypeCode());
        
        IdeaActivity.VoteCreatedActivity ia2 = new IdeaActivity.VoteCreatedActivity(idea1.id, 'hello', currentUser.id, DateTime.now(), nickname, currentUser.id, communityId,'Down');
        System.assertEquals('VoteCreatedActivity', ia2.getTypeCode());
        System.assert(ia2.getFirstLineHtml().startsWith(' demoted'));
        
        IdeaActivity.VoteCreatedActivity ia3 = new IdeaActivity.VoteCreatedActivity(idea1.id, 'hello', currentUser.id, DateTime.now(), nickname, currentUser.id, communityId);
        System.assertEquals('VoteCreatedActivity', ia3.getTypeCode());
    }

    static testMethod void testStaticMethods() {
        System.assert(IdeaActivity.getProfileAnchor('foo').contains('foo'));

        System.assertEquals(null, IdeaActivity.toDate(null));

        Datetime now = DateTime.now();

        Date dateResult = IdeaActivity.toDate(now);
        System.assertEquals(now.year(), dateResult.year());
        System.assertEquals(now.month(), dateResult.month());
        System.assertEquals(now.day(), dateResult.day());

        System.assertEquals(0, IdeaActivity.getDaysBefore(now));
        if (now.day() > 1) {
            System.assertEquals(1, IdeaActivity.getDaysBefore(Datetime.newInstance(now.year(), now.month(), now.day() - 1)));
        }

        System.assertEquals('', IdeaActivity.truncateComment(null, 1));
        System.assertEquals('', IdeaActivity.truncateComment('', 1));
        System.assertEquals('0123456789&hellip;', IdeaActivity.truncateComment('012345678901234', 10));
        System.assertEquals('0123456789', IdeaActivity.truncateComment('0123456789', 10));
        System.assertEquals('how now', IdeaActivity.truncateComment('how now', 10));
    }

}