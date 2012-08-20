public class IdeaCommentDetails {

    public final Idea idea { get; set; }
    public final IdeaComment ideaComment { get; set; }
    public Boolean read { get; set; }
    
    public IdeaCommentDetails(Idea idea, IdeaComment ideaComment) {
        this.idea = idea;
        this.ideaComment = ideaComment;
        this.read = false;
    }
    
    public static IdeaCommentDetails[] getIdeasWithComments(List<Idea> ideas) {
        IdeaCommentDetails[] ideasWithComments = new List<IdeaCommentDetails>();
        List<Id> ideaCommentIds = new String[ideas.size()];
        for (Idea i : ideas) {
        	if (i != null) {
	            ideaCommentIds.add(i.lastCommentId);
        	}                
        }

        List<IdeaComment> ideaComments = [SELECT Id, CommentBody, CreatedById, createdBy.communityNickname, CreatedDate, IdeaId 
        								  FROM IdeaComment 
        								  WHERE Id in :ideaCommentIds];
        
        Map<Id, IdeaComment> ideaMap = new Map<Id,IdeaComment>();
        for (IdeaComment c : ideaComments)
            ideaMap.put(c.IdeaId, c);
        
        for (Idea i : ideas) 
            ideasWithComments.add(new IdeaCommentDetails(i, ideaMap.get(i.id)));
        
        return ideasWithComments;
    }

    public static IdeaCommentDetails[] getIdeasWithComments(List<Idea> ideas, Map<Id, IdeaComment> ideaCommentMap) {
        IdeaCommentDetails[] ideasWithComments = new List<IdeaCommentDetails>();
        
        for(Idea i : ideas) {
            ideasWithComments.add(new IdeaCommentDetails(i, ideaCommentMap.get(i.id)));       
        }
        
        return ideasWithComments;       
    }
    
    public static IdeaCommentDetails[] getIdeasWithComments(List<Idea> ideas, String createdById) {
        IdeaCommentDetails[] ideasWithComments = new List<IdeaCommentDetails>();
        List<Id> ideaIds = new String[ideas.size()];
        for (Idea i : ideas) {
            if (i != null) {
                ideaIds.add(i.Id);
            }                
        }

        List<IdeaComment> ideaComments = [SELECT Id, CommentBody, CreatedById, createdBy.communityNickname, CreatedDate, IdeaId 
                                          FROM IdeaComment 
                                          WHERE IdeaId in :ideaIds
                                          AND createdById = :createdById];
        
        Map<Id, Idea> ideaMap = new Map<Id, Idea>();
        for (Idea parent : ideas) 
            ideaMap.put(parent.Id, parent);
            
        Map<Id, IdeaComment> ideaCommentMap = new Map<Id, IdeaComment>();
        for (IdeaComment c : ideaComments) 
            ideaCommentMap.put(c.IdeaId, c);
            
        Set<Id> ids = ideaCommentMap.keySet();  
        for (Id id : ids)
            ideasWithComments.add(new IdeaCommentDetails(ideaMap.get(id), ideaCommentMap.get(id)));       
        return ideasWithComments;       
    }

    public static IdeaCommentDetails[] getIdeasWithCommentsAndReadStatus(List<Idea> ideas, List<Id> unreadIdeas) {
        IdeaCommentDetails[] ideasWithComments = getIdeasWithComments(ideas);

        Set<Id> unreadIdeasSet = new Set<Id>();
        for (Id unreadIdeaId : unreadIdeas) {
          unreadIdeasSet.add(IdeaController.toShortId(unreadIdeaId));
        }

        for (IdeaCommentDetails ideaWithComment : ideasWithComments) {
          ideaWithComment.read = !unreadIdeasSet.contains(ideaWithComment.idea.id);
        }

        return ideasWithComments;
    }
}