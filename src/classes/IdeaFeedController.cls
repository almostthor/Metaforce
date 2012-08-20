public with sharing class IdeaFeedController extends IdeaController {

    public String conFeedName { get; set; }
    public String conUserId { get; set; }
    public String conIdeaId { get; set; }
    
    public static final String ADD_TO_GOOGLE_URL = 'http://fusion.google.com/add?source=atgs';
    
    public static final String RECENT_IDEAS = 'services/xml/_idea_recentideas';
    public static final String RECENT_IDEAS_ALL = 'services/xml/_idea_recentideas_all';
    public static final String POPULAR_IDEAS = 'services/xml/_idea_popular';
    public static final String POPULAR_IDEAS_ALL = 'services/xml/_idea_popular_all';
    public static final String RECENT_COMMENTS= 'services/xml/_idea_recentcomments';
    public static final String RECENT_COMMENTS_ALL= 'services/xml/_idea_recentcomments_all';
    public static final String TOP_IDEAS = 'services/xml/_idea_top';
    public static final String TOP_IDEAS_ALL = 'services/xml/_idea_top_all';
    public static final String RECENT_REPLIES = 'services/xml/_idea_recentreplies';
    public static final String RECENT_USER_VOTES = 'services/xml/_idea_recentuservotes';
    public static final String MY_COMMENTS = 'services/xml/_idea_mycomments';
    public static final String VOTES_ON_MY_IDEAS = 'services/xml/_idea_personalactivityvotes';
    public static final String IDEA_DETAILS = 'services/xml/_idea_details';

    public static final String TYPE_POPULAR = 'PopularIdeas';
    public static final String TYPE_RECENT = 'RecentIdeas';
    public static final String TYPE_RECENT_COMMENTS = 'RecentComments';
    public static final String TYPE_TOP = 'TopIdeas';
    public static final String TYPE_MY_COMMENTS = 'MyComments';
    public static final String TYPE_IDEA_DETAILS = 'IdeaDetails';
    public static final String TYPE_VOTES_ON_MY_IDEAS = 'VotesOnYourIdeaFeed';

    public static final String FEED_PARAM_NAME = 'name';
    public static final String FEED_PARAM_COMMUNITY = 'community';
    public static final String FEED_PARAM_IDEA_TITLE_LINK = 'ideaTitleLink';
    

    private Boolean getHasCategory() {
        return getCategoryParam() != null;
    }
    
    public PageReference feedPage {
        get {
            if (feedPage == null) {
		        String url;
		        String feedTitle;
		        String nameValue;
		        if (conFeedName == TYPE_POPULAR) {
		            url = getHasCategory() ? POPULAR_IDEAS : POPULAR_IDEAS_ALL;
		            nameValue = categoryParam;
		        } else if (conFeedName == TYPE_RECENT) {
		            url = getHasCategory() ? RECENT_IDEAS : RECENT_IDEAS_ALL;
		            nameValue = categoryParam;
		        } else if (conFeedName == TYPE_RECENT_COMMENTS) {
		            url = getHasCategory() ? RECENT_COMMENTS : RECENT_COMMENTS_ALL;
		            nameValue = categoryParam;
		        } else if (conFeedName == TYPE_TOP) {
		            url = getHasCategory() ? TOP_IDEAS : TOP_IDEAS_ALL;
		            nameValue = categoryParam;
		        } else if (conFeedName == TYPE_MY_COMMENTS) {
		            url = MY_COMMENTS;
		            nameValue = conUserId;
		        } else if (conFeedName == TYPE_IDEA_DETAILS) {
		            url = IDEA_DETAILS;
		            nameValue = conIdeaId;
		        } else if (conFeedName == TYPE_VOTES_ON_MY_IDEAS) {
		            url = VOTES_ON_MY_IDEAS;
		            nameValue = conUserId;
		        } else {        	
		            url = getHasCategory() ? POPULAR_IDEAS : POPULAR_IDEAS_ALL;
		        }
		        
		        feedPage = new PageReference(Site.getCurrentSiteUrl()+url);
		        feedPage.getParameters().put(FEED_PARAM_NAME, nameValue);
		        feedPage.getParameters().put(FEED_PARAM_COMMUNITY, getCommunityId());
		        feedPage.getParameters().put(FEED_PARAM_IDEA_TITLE_LINK, getViewUrl());
            }
            return feedPage;
        }
        set;
    }
    
    public PageReference getAddToGooglePage() {
    	PageReference pageRef = new PageReference(ADD_TO_GOOGLE_URL);
        pageRef.getParameters().put('feedurl', feedPage.getUrl());
    	return pageRef;
    }
}