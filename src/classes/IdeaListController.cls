public class IdeaListController extends IdeaController {
    public Idea[] ideas;
    private static final Integer MAX_NUMBER_OF_IDEAS_PER_PAGE = 20;
	ApexPages.IdeaStandardSetController controller;
    
    public IdeaListController() {
    }

    public IdeaListController(ApexPages.IdeaStandardSetController controller) {
    	this.controller = controller;
    }

    public String feedName {
        get {
            if (feedName == null) {
                if (IdeaController.SORT_POPULAR.equals(sortParam)) {
                    feedName = IdeaFeedController.TYPE_POPULAR;
                } else if (IdeaController.SORT_RECENT.equals(sortParam)) {
                    feedName = IdeaFeedController.TYPE_RECENT;
                } else if (IdeaController.SORT_TOP.equals(sortParam)) {
                    feedName = IdeaFeedController.TYPE_TOP;
                } else if (IdeaController.SORT_COMMENTS.equals(sortParam)) {
                    feedName = IdeaFeedController.TYPE_RECENT_COMMENTS;
                } else {
                    feedName = IdeaFeedController.TYPE_POPULAR;
                }            	
            }
            return feedName;
        }
        set;
    }

    public IdeaWithVote[] ideasWithVotes {
    	get {
    		if (ideasWithVotes == null) {
    			ideasWithVotes = IdeaWithVote.getIdeasWithVotes(getIdeas());
    		}
    		return ideasWithVotes;
    	}
    	set;
    }
    
    public Idea[] getIdeas() {
		if (ideas == null) { 
	    	if (controller != null) {
	    		ideas = controller.getIdeaList();
	    	} 
		}
		return ideas;
    }

    public String getPageName() {
        return PAGE_LIST;
    }

    public Boolean getHasPreviousPage() {
        return getPageParamInt() > 1;
    }

    public Boolean getHasNextPage() {
        return ideas.size() == MAX_NUMBER_OF_IDEAS_PER_PAGE;
    }    
}