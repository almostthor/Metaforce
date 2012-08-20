@isTest
private class IdeaDetailsControllerTest {
	
	private static final String ideaCategories = 'Cat1;Cat2;Cat3;Cat4'; 
	private static User testUser = IdeaTestUtil.getCurrentUser();
	private static final Integer MAX_COMMENT_LENGTH = IdeaDetailsController.MAX_COMMENT_LENGTH;
	
	private static Idea createIdea(String ideaTitle, String listOfCategories){		
		String ideaId = IdeaTestUtil.makeIdea(testUser, IdeaTestUtil.getCommunityId(), ideaTitle, 'IdeaBody', listOfCategories, 0).id;
        Idea newIdea = [select id, createdBy.communityNickname, createdBy.id, createdDate, categories, voteTotal from idea where id = :ideaId];
		return newIdea;
	}
	
	 static testMethod void testIdeaDetailsAbstractController() {
        IdeaTestUtil.setupTest();
   		           
        Idea ideaNoCategories = createIdea('IdeaNoCategories', '');
        Idea ideaWithCategories = createIdea('IdeaWithCategories', ideaCategories);
        
        IdeaDetailsController controllerNoCategories = new IdeaDetailsController();
        controllerNoCategories.conIdea = ideaNoCategories;
        IdeaDetailsController controllerWithCategories = new IdeaDetailsController();
        controllerWithCategories.conIdea = ideaWithCategories;
        
		IdeaDetailsController dummyController = new IdeaDetailsController();
        
        controllerNoCategories.conIdea = ideaNoCategories;
        controllerWithCategories.conIdea = ideaWithCategories;
  
  		// Test CommunityNickNameGetter
        System.assertEquals(testUser.communityNickname, controllerNoCategories.getCreatedByCommunityNickname(), 'CommunityNickName is not set correctly');
        
        // Test CreateById Getter
        System.assertEquals(testUser.id, controllerNoCategories.getCreatedById(), 'CreateById was not returned correctly');
        
        // Test GetFormattedDate 
        System.assertEquals(ideaNoCategories.createdDate.format('d MMM yyyy h:mm a'), controllerNoCategories.getFormattedDate(), 'getFormattedDate does not return correct date');
        
        // Test getSplitCategories
		System.assertEquals(0, dummyController.getSplitCategories().size(), 'DummyController should return NULL for getSplitCategories');
		System.assertEquals(0, controllerNoCategories.getSplitCategories().size(), 'controllerNoCategories should return NULL for getSplitCategories');
		
		List<String> categoryList = ideaCategories.split(';');
		List<String> controllerCategoryList = controllerWithCategories.getSplitCategories();
		
		for (Integer i = 0; i < categoryList.size(); i++) {
			verifySameCategory(categoryList.get(i), controllerCategoryList.get(i));
		}
        
        // Test getUpdatedVoteTotal
        System.assertEquals('10', controllerNoCategories.getUpdatedVoteTotal());
    
        //Test getHasCategories
        System.assert (!dummyController.getHasCategories());
        System.assert (!controllerNoCategories.getHasCategories());
        System.assert (controllerWithCategories.getHasCategories());
        
        //Test getLastCategory
        System.assert (dummyController.getLastCategory()==null);
        System.assert (controllerNoCategories.getLastCategory()==null);
        verifySameCategory(categoryList[categoryList.size() - 1], controllerWithCategories.getLastCategory());
    }
    
    static void verifySameCategory(String expected, String actual) {
        System.assertEquals(expected.toLowerCase(), actual.toLowerCase());
    }
	
	static testMethod void testCommentMethods() {
        IdeaTestUtil.setupTest();

		//Idea newIdea = createIdea('New Idea', ideaCategories);
		String suffixString = 'a\n   a \n';
		String trimmedSuffixString = 'a a';
		String prefixString = ' a';
		String trimmedPrefixString = 'a';
		String shortCommentString = IdeaTestUtil.createRandomString(MAX_COMMENT_LENGTH-6);
		String mediumCommentString = IdeaTestUtil.createRandomString(MAX_COMMENT_LENGTH-5);
		String longCommentString = IdeaTestUtil.createRandomString(MAX_COMMENT_LENGTH-4); 
		
		//no comment
		IdeaDetailsController noCommentIdeaController = createIdeaCommentAndController('NoCommentIdea', null);	
		System.assert(noCommentIdeaController.getCommentFragment()==null, 'No Comment is not returned correctly');
		
		//less than MAX_COMMENT_LENGTH
		IdeaDetailsController shortCommentIdeaController = createIdeaCommentAndController('ShortCommentIdea', prefixString + shortCommentString + suffixString);
		String compareString = trimmedPrefixString+ shortCommentString + trimmedSuffixString; 				
		System.assertEquals(compareString, shortCommentIdeaController.getCommentFragment(), 'Comment less than maxCommentLength is not returned correctly');
				
		//equal to MAX_COMMENT_LENGTH
		IdeaDetailsController mediumCommentIdeaController = createIdeaCommentAndController('mediumCommentString', prefixString + mediumCommentString + suffixString);
		compareString = trimmedPrefixString + mediumCommentString + trimmedSuffixString;			
		System.assertEquals(compareString, mediumCommentIdeaController.getCommentFragment(), 'Comment equal to maxCommentLength is not returned correctly');
		
		//greater than MAX_COMMENT_LENGTH
		IdeaDetailsController longCommentIdeaController = createIdeaCommentAndController('longCommentString', prefixString + longCommentString + suffixString);
		compareString = (trimmedPrefixString + longCommentString + trimmedSuffixString).subString(0, MAX_COMMENT_LENGTH) + '&hellip;';				
		System.assertEquals(compareString, longCommentIdeaController.getCommentFragment(), 'Comment greater than maxCommentLength is not returned correctly');
		
		System.assert(IdeaDetailsController.truncateComment(null, MAX_COMMENT_LENGTH)=='', 'when pass in null to truncateComment should return null string');
	}
	
	private static IdeaDetailsController createIdeaCommentAndController(String ideaTitle, String Comment){		
		String ideaId = IdeaTestUtil.makeIdea(testUser, IdeaTestUtil.getCommunityId(), ideaTitle, 'IdeaBody', '', 0).id;		
		
		if (Comment != null)
			IdeaComment newComment = IdeaTestUtil.makeIdeaComment(ideaId, Comment, testUser, 0);
			
		Idea newIdea = [select id, createdBy.communityNickname, createdBy.id, createdDate, categories, lastComment.commentBody from idea where id = :ideaId];		
		IdeaDetailsController testController = new IdeaDetailsController();
		testController.conIdea = newIdea;
		return testController;
	}
	
	
}