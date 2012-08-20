public class IdeaWithVote {
    public Idea idea { get; set; }
    public final Vote vote { get; set; }
    public final Boolean read { get; set; }

    public IdeaWithVote(Idea idea, Vote vote) {
        this.idea = idea;
        this.vote = vote;
    }
    
    public IdeaWithVote(Idea idea, Vote vote, Boolean read) {
        this.idea = idea;
        this.vote = vote;
        this.read = read;
    }

    public String getHowUserVoted() {
    	return vote == null ? 'None' : vote.type; 
    }
    
    public static IdeaWithVote[] getIdeasWithVotes(List<Idea> ideas) {
        return getIdeasWithVotes(ideas,UserInfo.getUserId());
    }
    
    public static List<Id> getIdeaIds(List<Idea> ideas) {
        List<Id> ideaIds = new List<Id>();
        for (Idea i : ideas) {
            if (i != null) {
                ideaIds.add(i.id);
            }                
        }
        return ideaIds;
    }

    private static Map<Id, Vote> getIdeaIdToVoteMap(List<Id> ideaIds, String userId) {
        List<Vote> ideaVotes = [select ParentId, Type, CreatedDate from Vote where ParentId in :ideaIds and CreatedById = :userId];
        
        Map<Id, Vote> ideaMap = new Map<Id,Vote>();
        for (Vote v : ideaVotes)
            ideaMap.put(v.ParentId, v);

        return ideaMap;    	
    }


    public static IdeaWithVote[] getIdeasWithVotes(List<Idea> ideas, String userId) {
        IdeaWithVote[] ideasWithVotes = new List<IdeaWithVote>();
        if (ideas != null) {
	        List<Id> ideaIds = getIdeaIds(ideas);
	
	        Map<Id, Vote> ideaToVoteMap = getIdeaIdToVoteMap(ideaIds, userId);
	            
	        for (Idea i : ideas) 
	            ideasWithVotes.add(new IdeaWithVote(i, ideaToVoteMap.get(i.id)));
        }	        
        return ideasWithVotes;
    }
               

    public static IdeaWithVote[] getIdeasWithVotes(List<Vote> votes) {
        IdeaWithVote[] ideasWithVotes = new List<IdeaWithVote>();
        List<Id> ideaIds = new List<Id>();
        for (Vote v : votes) {
        	if (v != null) {
	            ideaIds.add(v.parentId);
        	}                
        }

        List<Idea> ideas = [
        	select id, title, VoteTotal,categories,createdBy.communityNickname,createdDate,body,numComments,status,parentIdeaId,isLocked,LastCommentDate 
        	from Idea 
        	where Id in :ideaIds];
        
        Map<Id, Idea> ideaMap = new Map<Id,Idea>();
        for (Idea i : ideas)
            ideaMap.put(i.Id, i);
            
        for (Vote v : votes) 
            ideasWithVotes.add(new IdeaWithVote(ideaMap.get(v.ParentId), v));
        
        return ideasWithVotes;
    }    
}