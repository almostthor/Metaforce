public class IdeaTestUtil {
	
    public static void setupTest() {
        Integer num = [ SELECT count() FROM IdeasSiteSetup__c ];
        IdeasSiteSetup__c siteSetup;
        if (num == 0) {
	        siteSetup = new IdeasSiteSetup__c();
        } else {
        	siteSetup = [ SELECT id FROM IdeasSiteSetup__c ];
        }
        siteSetup.Name = 'test setup';
        Community c = [select id, name from community limit 1];
        siteSetup.communityId__c = ((String)c.Id).substring(0, 15);
        upsert siteSetup;
            
        // force IdeaController to requery the static siteSetup 
        IdeaController.siteSetup = null;
    }
    
    public static String getCommunityId() {
        return (new IdeaListController()).getCommunityId();
    }

    public static User getGuestUser() {
        return [select id, alias, email, lastname, profileid, username, communitynickname from user where userType='Guest'];
    }
    
    private static User currentUser;
    private static User user2;
    
    public static User getCurrentUser() {
    	if (currentUser == null) {
    	   currentUser = [select id, alias, email, lastname, profileid, username, communitynickname from user where id=:UserInfo.getUserId()]; 
    	}
    	return currentUser;
    }
    
    public static User getUser2() {
        if (user2 == null) {
           user2 = makeUser('ideaTestUser2');  
        }
        return user2;
    }

    public static User makeUser() {
    	return makeUser('test' + Math.random());
    }
    
    public static User makeUser(String communityNickname) {
        Profile p = [select id from profile where name='System Administrator'];
        String name = communityNickname + '@ideasbasetheme.salesforce.com';
        User u = new User(
            alias = 'testuser',
            email=name,
            emailencodingkey='UTF-8',
            lastname='Testing',
            languagelocalekey='en_US',
            localesidkey='en_US',
            profileid = p.id,
            timezonesidkey='America/Los_Angeles',
            username=name,
            communityNickname = communityNickname
        );
        insert u;
        return u;
    }
    
    public static Idea makeIdea() {
        return makeIdea('green turtles', null);
    }
    
    public static Idea makeIdea(String title, String communityId) {
    	return makeIdea(title, communityId, '');
    }
    
    public static Idea makeIdeaWithStatus(User user, String status) {
        return IdeaTestUtil.makeIdea(user, IdeaTestUtil.getCommunityId(), 'green turtles', 'super cool', null, status, 0);
    }
    
    
    public static Idea makeIdea(String title, String communityId, String categories) {
		return makeIdea(null, communityId, title, title, categories, 0);
    }

	public static Idea makeIdea(String title, String body, Integer timeLag) {
		return makeIdea(title, body, null, timeLag);
	}		

	public static Idea makeIdea(String title, String body, User user, Integer timeLag) {
		return makeIdea(user, IdeaTestUtil.getCommunityId(), title, body, null, timeLag);
	}
	
	public static Idea makeIdea(User user, String communityId, String title, String body, String categories, Integer timeLag) {
        return makeIdea(user, IdeaTestUtil.getCommunityId(), title, body, categories, null, timeLag);
	}
	
    public static Idea makeIdea(User user, String communityId, String title, String body, String categories, String status, Integer timeLag) {
		Idea idea = fillIdea(communityId, title, body, categories, status, timeLag);
		if (user == null) {
			insert idea;
		} else {
			System.runAs(user) {
				insert idea;
			}
		}
		String id = idea.id;
		idea = [select communityId, title, body, categories, status, createdDate, createdBy.communityNickname from idea where id=:id];
		return idea;
	}
	
	public static Idea fillIdea(String communityId, String title, String body, String categories, String status, Integer timeLag) {
		Idea idea;
		idea = new Idea();
		idea.communityId = (communityId == null) ? IdeaTestUtil.getCommunityId() : communityId;
		idea.title = title;
		if (body != null) idea.body = body;
		//if (timeLag != null) idea.createdDate = Datetime.now().addSeconds(-timeLag);
		if (categories != null) idea.categories = categories;
        if (status != null) idea.status = status;
		//this doesn't completely work
		//if (user != null) idea.createdById = user.id;
		return idea; 
	}		
	
	public static IdeaComment makeIdeaComment(ID ideaId, String commentBody, User user, Integer timeLag) {
		IdeaComment comment = new IdeaComment();
		comment.IdeaId = ideaId;
		comment.commentBody = commentBody;
		//comment.createdDate = Datetime.now().addSeconds(-timeLag);
		//this doesn't completely work
		//comment.createdById = user.id; 
		System.runAs(user) {			
			insert comment;
		}
		return comment;
	}	

    public static void vote(User user, Idea idea, String voteType) {
        // need to vote through controller for proper update to UserStats
        IdeaVoteController controller = new IdeaVoteController(idea);
        controller.newVoteType = voteType;
        System.runAs(user) {
            controller.createVote();
        }
    }

    public static void vote(User user, ID ideaId, String voteType) {
        vote(user, [select Id from Idea where Id = :ideaId], voteType);
        /*
        Vote vote;
        System.runAs(user) {
            vote = new Vote(ParentId = ideaId, Type = voteType);
            insert vote;
        }
        return vote.id;
        */
    }

    public static void deleteExistingIdeas() {
        Idea[] existingIdeas = [SELECT Id, Title FROM Idea WHERE CommunityId = :IdeaTestUtil.getCommunityId()];
        delete existingIdeas;
    }
    
    public static void checkUrl(String expectedUrl, String actualUrl) {
        checkUrl(expectedUrl, new String[] {}, new String[] {}, actualUrl);   
    }

    public static void checkUrl(String expectedUrl, String key, String value, String actualUrl) {
        checkUrl(expectedUrl, new String[] {key}, new String[] {value}, actualUrl);   
    }

    public static void checkUrl(String expectedUrl, String[] keys, String[] values, String actualUrl) {
        System.assert(actualUrl.contains(expectedUrl), actualUrl + ' should contain ' + expectedUrl);     
        if (keys != null && keys.size() > 0) {
            for (Integer i=0; i<keys.size(); i++) {
                System.assert(actualUrl.contains(keys[i] + '=' + values[i]), actualUrl+' should contain '+keys[i] + '=' + values[i]);
            }
        }
    }

	public static String createRandomString(Integer stringLength){
		List<String> alpha = new String [] {'a', 'b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t',
											'u', 'v', 'w', 'x', 'y', 'z'};
		String resultString = '';
		for (Integer i = 0; i<=stringLength; i++) {
			if (math.mod(i, 9) == 0)
				resultString += ' ';	
			else
				resultString += alpha[Math.round(Math.Random()*(alpha.size()-1))];					
		}
		return resultString;
	}
}