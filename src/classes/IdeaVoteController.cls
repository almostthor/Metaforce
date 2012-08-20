public with sharing class IdeaVoteController extends IdeaController {

    public Idea conIdea { get; set; }
    public Idea afterVoteIdea { get; set; }
    public String voteIdeaId { get; set; }
    public transient String newVoteType { get; set; }
    public transient Boolean newVote = false;
    public transient Integer voteTotal;

    public IdeaVoteController() {
    }
    
    // used in tests
    public IdeaVoteController(Idea conIdea) {
    	this.conIdea = conIdea;
    	voteIdeaId = conIdea.id;
    }

    public String currentUserVoteType {
        get {
	        if (newVoteType != null) {
	            return newVoteType;
	        }
	        // ideally passing this value in would be optional, and we'd just query here if null; but, even when it's
	        // passed in, it comes up null here sometimes, causing the query to happen anyways.  we want to make sure
	        // that the query does not happen for the list pages
	        return currentUserVoteType;
        }
        set;
    }

    public Boolean getIsVotedUp() {
	return currentUserVotetype == 'Up';
    }

    public Boolean getIsVotedDown() {
	return currentUserVotetype == 'Down';
    }

    public Integer getVoteTotal() {
        return Math.Round(afterVoteIdea == null ? conIdea.voteTotal : afterVoteIdea.voteTotal);
    }

    public PageReference createVote() {
        Vote v = new Vote(ParentId = voteIdeaId, Type = newVoteType);
        try {
            insert v;
            newVote = true;
            afterVoteIdea = [select Id, CommunityId, VoteTotal, IsLocked, createdById from Idea where Id = :conIdea.id];	
        } catch (System.DmlException e) {
            // <!--Good for debugging <apex:pageMessages id="errorMsgs" />-->
            // ApexPages.addMessages(e);
            // ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'parentId ' + voteIdeaId + 'voteType ' + newVoteType));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'Voting disabled'));
            // ignore - most likely they tried to vote twice in 2 browser windows
        }
        return null;
    }

    public Boolean getNewVote() {
        return this.newVote;
    }

    public Boolean getUserHasNotVoted() {
        return 'None'.equals(currentUserVoteType);
    }

}