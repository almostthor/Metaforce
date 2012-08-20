public class IdeaViewController extends IdeaController {
    
    private Integer numPages;
    private IdeaComment[] comments;
    private IdeaComment newComment;
    private transient Vote[] votesUp;
    private transient Vote[] votesDown;
    private Idea[] childIdeas;
    public IdeaSetController setCon { get; set;}    
    ApexPages.IdeaStandardController controller;
    private static final Integer MAX_NUMBER_OF_COMMENTS_PER_PAGE = 50;    
    
        //For tests
    public IdeaViewController(String ideaId) {
        this.ideaId = ideaId;
    }

    public String ideaId {
        get {
            if (ideaId == null) {
                ideaId = controller.getId();
            }
            return ideaId; 
        }
        set;
    }
    

    // Constructor called by Apex.
    public IdeaViewController(ApexPages.IdeaStandardController controller) {
        this.controller = controller;
        if (MESSAGE_CODE_COMMENT_POSTED.equals(System.currentPageReference().getParameters().get(PARAM_MESSAGE_CODE))) {
			System.debug('In msg code check');
        	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, ' Your comment has been posted'));
        }
    }

    public void markIdeaRead() {
    	if(getIsLoggedIn())
      		Ideas.markRead(ideaId);
    }


    public IdeaComment[] getComments() {
        if (comments == null) { 
            if (controller != null) {
                comments = controller.getCommentList();
            } 
        }
        return comments;
    }

    
    public String getPageName() {
        return PAGE_VIEW; 
    }
    
    public IdeaComment getNewComment() {
        if (this.newComment == null) {
            this.newComment = new IdeaComment(IdeaId = ideaId);
        }
        return this.newComment;
    }

    public PageReference saveComment() {
    	
    	if (!Schema.SObjectType.Idea.isCreateable()) {
    		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'You do not have privileges to post a comment.'));
            return null;
    	}
    	
		if (newComment.commentBody == null || newComment.commentBody.trim().length() == 0) {
		    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' You cannot post a zero-length comment'));
			return null;
		}
    	        try {
			insert newComment;
			PageReference ideaPage = getIdeaViewPage(ideaId, MESSAGE_CODE_COMMENT_POSTED);
            ideaPage.getParameters().put(PARAM_PAGE, String.valueOf(this.numPages));
	        if( returnUrlParam != null ) {
	            ideaPage.getParameters().put(PARAM_RETURN_URL,escapeUrl(returnUrlParam));
	        }                        
			System.debug('URL is ' + ideaPage.getUrl());
			ideaPage.setRedirect(true);
			return ideaPage;
		} catch (System.DmlException e) {
		    for (Integer i = 0; i < e.getNumDml(); i++) {
		        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
		    }
		    return null;
    	}
    }    

    private void last50Votes() {
        if (votesUp == null) {
	    votesUp = new Vote[]{};
	    votesDown = new Vote[]{};
            Vote[] last50Votes = [select createdById, createdBy.communityNickname, type from vote where parentId = :ideaId order by createdDate desc limit 50];
	    for (Vote v: last50Votes) {
		if (v.type == 'Up') {
		    votesUp.add(v);
		} else if (v.type == 'Down') {
		    votesDown.add(v);
		} else {
		    throw new IdeaException('Unknown vote type '+v.type);
		}
	    }
        }
        return;
    }

    public Vote[] getVotesUp() {
        if (votesUp == null) {
	    last50Votes();
	}
        return votesUp;
    }

    public Integer getNumVotesUp() {
        return getVotesUp().size();
    }

    public Vote[] getVotesDown() {
        if (votesDown == null) {
	    last50Votes();
	}
        return votesDown;
    }

    public Integer getNumVotesDown() {
        return getVotesDown().size();
    }

    public Integer getNumChildIdeas() {
        return getChildIdeas().size();
    }
    
    public Idea[] getChildIdeas() {
        if (childIdeas == null) {
            childIdeas = [select id, title, body, createdById, createdBy.communityNickname, createdDate, numComments from idea where parentIdeaId = :ideaId order by createdDate];
        }
        return childIdeas;
    }

	public String howUserVoted {
		get {
			if (howUserVoted == null) {
			    List<Vote> v = [select Type from Vote where ParentId = :ideaId and CreatedById = :UserInfo.getUserId()];
			    if (v.size()> 0) {
		        	howUserVoted = v[0].Type;
		        } else {
		            howUserVoted = 'None';
		        }
			}
	        return howUserVoted;
		}
	    set;
	}

    public Boolean getHasCommentsPreviousPage() {
        return getPageParamInt() > 1;
    }

    public Boolean getHasCommentsNextPage() {
    	if (comments != null) {
            return comments.size() == MAX_NUMBER_OF_COMMENTS_PER_PAGE;
    	}
    	return false;
    }	
	
}