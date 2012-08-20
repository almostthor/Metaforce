@isTest
private class IdeaSearchControllerTest {
    static testMethod void testSearchForASingleCharacter() {
        IdeaTestUtil.setupTest();
        IdeaSearchController controller = new IdeaSearchController('a');
        System.assertEquals(0, controller.getIdeas().size());
        System.assert(controller.getHasMessages());
        ApexPages.Message[] messages = ApexPages.getMessages();
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR) == true, 'There should be error messages for an invalid search term');
        System.assertEquals('Please use a search term with more than one valid character.', messages[0].getDetail(), 'search should add error message for invalid search term');        
    }
        
    static testMethod void testSearchForBlankSpace() {
        IdeaTestUtil.setupTest();
        IdeaSearchController controller = new IdeaSearchController(' ');
        System.assertEquals(0, controller.getIdeas().size());
        System.assert(controller.getHasMessages());
        ApexPages.Message[] messages = ApexPages.getMessages();
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR) == true, 'There should be error messages for an invalid search term');
        System.assertEquals('Please use a search term with more than one valid character.', messages[0].getDetail(), 'search should add error message for invalid search term');        
    }        

    static testMethod void testGetHasMessages() {
        IdeaTestUtil.setupTest();
    	IdeaSearchController controller = new IdeaSearchController('Idea');
    	System.assert(!controller.getHasMessages());
    	controller = new IdeaSearchController('a');
    	System.assert(controller.getHasMessages());
        ApexPages.Message[] messages = ApexPages.getMessages();
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR) == true, 'There should be error messages for an invalid search term');
        System.assertEquals('Please use a search term with more than one valid character.', messages[0].getDetail(), 'search should add error message for invalid search term');
    }

    static testMethod void testGetIsFirstPage() {
        IdeaSearchController controller = new IdeaSearchController();
        controller.pageParam = '1';
        System.assert(controller.getIsFirstPage());
        controller.pageParam = '2';
        System.assert(!controller.getIsFirstPage());                
    }    

    static testMethod void testGetHasNextPage() {
        IdeaSearchController controller = new IdeaSearchController('abc');
        controller.pageParam = '1';
        System.assert(!controller.getHasNextPage());
    }
    
    static testMethod void testPageUrlGetters() {
        IdeaSearchController controller = new IdeaSearchController();
        controller.pageParam = '2';
        controller.searchTermParam = 'abc';
        String url = controller.getPageUrl();
        System.debug('MyURL: '+url);
        System.assert(url.contains('s=abc'));
        System.assert(url.contains(controller.getSearchResultsUrl())); 
        url = controller.getPreviousPageUrl();
        System.assert(url.contains('p=1'));
        url = controller.getNextPageUrl();
        System.assert(url.contains('p=3'));
    }    
}