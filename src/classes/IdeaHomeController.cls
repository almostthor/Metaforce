public class IdeaHomeController extends IdeaController {

    public Idea[] recentIdeas {
    	get {
            if (recentIdeas == null) {
            	recentIdeas = [SELECT id, title, createdDate
                                FROM Idea
                                WHERE CommunityId = :getSiteSetup().communityId__c
                                AND parentIdeaId = null
                                ORDER BY createdDate DESC
                                LIMIT 5]; 
            }
            return recentIdeas;
    	}
    	set;
    }

}