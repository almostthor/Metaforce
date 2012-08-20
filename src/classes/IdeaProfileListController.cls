public class IdeaProfileListController extends IdeaController {
    public Idea[] ideas;
    
	private static final Integer DAYS_AGO = 30;
	public static final Integer MAX_NUMBER_OF_IDEAS_PER_PAGE = 20;
	ApexPages.IdeaStandardSetController controller;
   

    public IdeaProfileListController(ApexPages.IdeaStandardSetController controller) {
    	this.controller = controller;    
    }
    
    public IdeaProfileListController() {
    }
        
    public IdeaWithVote[] ideasWithVotes {
    	get {
    		if (ideasWithVotes == null) {
    			ideasWithVotes = IdeaWithVote.getIdeasWithVotes(getIdeas(), userParam);
    		}
    		return ideasWithVotes;
    	}
    	set;
    }

    private Idea[] getIdeasWithParentIdeaId(List<Idea> ideas) {
        List<Id> ideaIds = IdeaWithVote.getIdeaIds(ideas);
        List<Idea> ideasWithParentIdeaId = [select Body, Categories, CreatedBy.CommunityNickname, CreatedBy.Id, CreatedDate, Id, LastCommentDate, LastComment.Id, LastComment.CommentBody, LastComment.CreatedBy.Id, LastComment.CreatedBy.CommunityNickname, NumComments, Status, Title, VoteTotal, ParentIdeaId from Idea where Id in :ideaIds order by CreatedDate desc];
        return ideasWithParentIdeaId;
    }

        
    public Idea[] getIdeas() {
		if (ideas == null) { 
	    	if (controller != null) {
	    		ideas = getIdeasWithParentIdeaId(controller.getIdeaList());
	    	} 
		}
		return ideas;
    }

    public String getPageName() {
        return PAGE_PROFILE_LIST;
    }
    
    public Boolean getHasPreviousPage() {
        return getPageParamInt() > 1;
    }

    public Boolean getHasNextPage() {
        return ideas.size() == MAX_NUMBER_OF_IDEAS_PER_PAGE;
    }
}