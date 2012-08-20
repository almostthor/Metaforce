public abstract class IdeaActivity {
    private final String ideaId;
    private final String ideaTitle;
    private final String ideaCreatorId;
    private final Datetime createdDate;
    private final String communityId;

    static final String TAGS_WHICH_SHOULD_BE_REPLACED_WITH_NO_SPACE = '(?mi)<\\s*/?\\s*(b|i|strike|u)\\s*>';
    static final String ANY_HTML_TAG = '(?m)<[^>]*>';
    private static final Integer MAX_COMMENT_LENGTH = 110 ;

    public static String TYPE_IDEA_CREATED = 'IdeaCreatedActivity';
    public static String TYPE_VOTE_CREATED = 'VoteCreatedActivity';
    public static String TYPE_VOTE_PROMOTED= 'promoted';
    public static String TYPE_VOTE_DEMOTED = 'demoted';
    public static String TYPE_COMMENT_GROUP = 'CommentGroup';
    
    public Boolean isLastActivityInList = false;

    public IdeaActivity(String ideaId, String ideaTitle, String ideaCreatorId, Datetime createdDate) {
        this(ideaId, ideaTitle, ideaCreatorId, createdDate, null);
    }

    public IdeaActivity(String ideaId, String ideaTitle, String ideaCreatorId, Datetime createdDate, String communityId) {
        this.ideaId = ideaId;
        this.ideaTitle = ideaTitle;
        this.ideaCreatorId = ideaCreatorId;
        this.createdDate= createdDate;
        this.communityId = communityId;
    }
    
    public Boolean getIsLastActivityInList() {
    	return isLastActivityInList ;
    }

    public abstract String getActivityCreatorId();
    public abstract String getActivityCreatorCommunityNickname();

    public String getIdeaId() {
        return ideaId;
    }

    public String getIdeaTitle() {
        return ideaTitle;
    }

    public Datetime getDate() {
        return createdDate;
    }
        
    public static Date toDate(Datetime dt) {
        return dt == null ? null : Date.newInstance(dt.year(), dt.month(), dt.day());
    }
    
    public static Integer getDaysBefore(Datetime activityDay) {
        if (activityDay.isSameDay(Datetime.now())) {
            // this might happen if the web server and database clocks are not synchronized
            return 0;
        } else {
            return (toDate(activityDay)).daysBetween(toDate(Datetime.now()));
        }
    }
    
    public String makeCommentSnippet(String fullComment, boolean commentIsHtml, Integer maxCommentLength) {
        if (fullComment == null) {
            return '';
        }
        String commentSnippet = fullComment;
        if (commentIsHtml) {
            commentSnippet = stripTags(commentSnippet);
        }

        commentSnippet = stripNonBreakingSpaces(commentSnippet);
        commentSnippet = commentSnippet.replaceAll('\\s+', ' ');
        commentSnippet = commentSnippet.trim();
        return truncateComment(commentSnippet, maxCommentLength);
    }

    protected String stripNonBreakingSpaces(String value) {
        return value; // should be value.replaceAll('\u00A0?', '') but we don't know how to do \u in Apex
    }

    protected String stripTags(String value) {
        return value.replaceAll(TAGS_WHICH_SHOULD_BE_REPLACED_WITH_NO_SPACE, '').replaceAll(ANY_HTML_TAG, ' ');
    }

    public static String truncateComment(String text, Integer maxCommentLength) {
        
        if (text == null) {
            return '';
        }
        
        if(text.length() <= maxCommentLength)
            return text;
        else 
            return text.substring(0, maxCommentLength) + '&hellip;';
    }

    public static String getProfileAnchor(String nickname) {
        return '<span class="userLink"><a href="' + IdeaController.getUserPage(nickname).getUrl() + '">' + nickname + '</a></span>';
    }

    public abstract String getTypeCode();

    public abstract boolean isConcatenatableWith(IdeaActivity lookingFor);
        
    public abstract String getFirstLineHtml();

    public abstract String getSecondLineHtml();
      
    public Boolean getShouldShowSecondLineHtml() {
        return getSecondLineHtml() != null;
    }
    
    public class VoteCreatedActivity extends IdeaActivity {
        private String voterNickname;
        private String voterId;
        private String voteType;

        public VoteCreatedActivity(String ideaId, String ideaTitle, String ideaCreatorId, Datetime votedDate, String voterNickname, String voterId, String communityId) {
            super(ideaId, ideaTitle, voterId, votedDate);
            this.voterNickname = voterNickname;
            this.voterId = voterId;
        }
        
        public VoteCreatedActivity(String ideaId, String ideaTitle, String ideaCreatorId, Datetime votedDate, String voterNickname, String voterId, String communityId,String voteType) {
            super(ideaId, ideaTitle, voterId, votedDate);
            this.voterNickname = voterNickname;
            this.voterId = voterId;
            if(voteType == 'Up')
                this.voteType=TYPE_VOTE_PROMOTED;
            else
                this.voteType=TYPE_VOTE_DEMOTED;
        }        

        public override String getActivityCreatorId() {
            return voterId;
        }

        public override String getActivityCreatorCommunityNickname() {
            return voterNickname;
        }

        public override String getFirstLineHtml() {
            String url = IdeaController.URL_VIEW + '?id=' + ideaId;
            return ' '+voteType+ ' <a href=\"' + url + '\">' + ideaTitle + '</a>' ;
        }
        
        public override boolean isConcatenatableWith(IdeaActivity lookingFor) {
            return false;
        }
        
        public override String getSecondLineHtml() {
            return null;
        }

        public override String getTypeCode() {
            return TYPE_VOTE_CREATED;
        }
    }

    public abstract class CommentGroup extends IdeaActivity {
        private final String commentId;
        private final String commentBody;
        protected final String commentorNickname;
        protected final String commentorId;
            
        final Set<String> commentorNicknames = new Set<String>();
        private Integer commentCount = 0;
        private boolean bodyIsRichText;

        public CommentGroup(String ideaId, String ideaTitle, String ideaCreatorId, Datetime createdDate, String commentId, String commentBody, String commentCreatorNickname, String commentCreatorId, boolean bodyIsRichText) {
            super(ideaId, ideaTitle, ideaCreatorId, createdDate);
            this.commentId = commentId;
            this.commentBody = commentBody;
            this.commentorNickname = commentCreatorNickname;
            this.commentorId = commentCreatorId;
            this.bodyIsRichText = bodyIsRichText;
            concatenate(commentCreatorNickname);
        }

        public override String getActivityCreatorId() {
            return commentorId;
        }

        public override String getActivityCreatorCommunityNickname() {
            return commentorNickname;
        }

        public String getCommentId() {
            return commentId;
        }

        public String getCommentorNickname() {
            return commentorNickname;
        }

        public String getCommentorId() {
            return commentorId;
        }

        String getCommentFragment() {
            String fragment = makeCommentSnippet(commentBody, bodyIsRichText, MAX_COMMENT_LENGTH);
            return fragment.length() == 0 ? null : fragment;
        }

        public void concatenate(IdeaActivity activity) {
            concatenate(((CommentGroup)activity).commentorNickname);
        }

        private void concatenate(String actorNickname) {
            commentorNicknames.add(actorNickname);
            commentCount++;
        }

        public Set<String> getCommentorNicknames() {
            return commentorNicknames;
        }

        public override String getSecondLineHtml() {
            return getCommentFragment();
        }

        public Integer getCommentCount() {
            return commentCount;
        }
            
        public override boolean isConcatenatableWith(IdeaActivity lookingFor) {
            return  (lookingFor instanceof CommentGroup) && ideaId.equals(lookingFor.ideaId);
        }
    }
    
    public class IdeaCreatedActivity extends IdeaActivity {
        private String ideaCreatorNickname;

        public IdeaCreatedActivity(String ideaId, String ideaTitle, String ideaCreatorId, Datetime createdDate, String ideaCreatorNickname, String communityId) {
            super(ideaId, ideaTitle, ideaCreatorId, createdDate, communityId);
            this.ideaCreatorNickname = ideaCreatorNickname;
        }

        public override String getActivityCreatorId() {
            return ideaCreatorId;
        }

        public override String getActivityCreatorCommunityNickname() {
            return ideaCreatorNickname;
        }

        public override String getFirstLineHtml() {
            String viewIdeaUrl = IdeaController.getIdeaViewPage(ideaId).getUrl();
            return ' submitted <a href="' + viewIdeaUrl + '">' + ideaTitle + '</a>';
        }
        
        public override String getSecondLineHtml() {
            return null;
        }
        
        public override boolean isConcatenatableWith(IdeaActivity lookingFor) {
            return false;
        }

        public override String getTypeCode() {
            return TYPE_IDEA_CREATED;
        }
    }

    public class CommentCreatedActivity extends CommentGroup {
        Integer zero = 0;
    
        public CommentCreatedActivity(String ideaId, String ideaTitle, String ideaCreatorId, Datetime createdDate, String commentId, String commentBody, String commentCreatorNickname, String commentCreatorId, Boolean commentIsHtml) {
            super(ideaId, ideaTitle, ideaCreatorId, createdDate, commentId, commentBody, commentCreatorNickname, commentCreatorId, commentIsHtml);
        }

        public override String getFirstLineHtml() {
            String viewIdeaUrl = IdeaController.getIdeaViewPage(ideaId).getUrl();
            if((commentorNicknames.size() - 1) == 0)
                return ' commented on <a href=\"' + viewIdeaUrl + '\">' + ideaTitle + '</a>';
            else {
                String firstElement;
                for (String element: commentorNicknames) {
                    firstElement = element;
                    break;
                }
                return ' and ' + (commentorNicknames.size() - 1) + ' other commented on <a href=\"' + viewIdeaUrl + '\">' + ideaTitle + '</a>';    
            }
        
        }

        public override String getTypeCode() {
            return TYPE_COMMENT_GROUP;
        }
    }         
}