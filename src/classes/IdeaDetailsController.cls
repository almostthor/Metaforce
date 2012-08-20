public class IdeaDetailsController extends IdeaDetailsAbstractController {
	
    public static final Integer MAX_COMMENT_LENGTH = 110 ;
    private static final String TAGS_WHICH_SHOULD_BE_REPLACED_WITH_NO_SPACE = '(?mi)<\\s*/?\\s*(b|i|strike|u)\\s*>';
    private static final String ANY_HTML_TAG = '(?m)<[^>]*>';

    public IdeaDetailsController() {
    }
    
    public Boolean getIsMerged() {
		return conIdea.ParentIdeaId != null;
    }

    public String getCommentFragment() {
        String fragment = makeCommentSnippet(conIdea.lastComment.commentBody, true, MAX_COMMENT_LENGTH);
        return fragment.length() == 0 ? null : fragment;
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

    private String stripNonBreakingSpaces(String value) {
        return value; // should be value.replaceAll('\u00A0?', '') but we don't know how to do \u in Apex
    }

    private String stripTags(String value) {
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

    private Idea[] childIdeas;

    public Integer getNumChildIdeas() {
        return getChildIdeas().size();
    }
    
    public Idea[] getChildIdeas() {
        if (conIdea != null && childIdeas == null) {
            childIdeas = [select id, title, body, createdById, createdBy.communityNickname, createdDate, numComments, categories from idea where parentIdeaId = :conIdea.id order by createdDate];
        }
        return childIdeas;
    }       
}