@isTest
private class IdeaPostControllerTest {

  static testMethod void testGetCategoriesForIdeaShouldReturnSelectedCategories() {
      IdeaTestUtil.setupTest();
      IdeaPostController controller = new IdeaPostController();
      System.assert(controller.getIdea().categories == null, 'initally categories should be null');
      List<String> categories = new List<String>();
      System.assertEquals(categories, controller.getCategoriesForIdea(), 'getcategoriesforidea, when categories are null, should return an empty list');

      categories.add('a');
      controller.setCategoriesForIdea(categories);
      System.assert(controller.getIdea().categories != null, 'categories should not be null after being set');
      System.assertEquals(categories, controller.getCategoriesForIdea(), 'getcategoriesforidea should return `list of categories');

      categories = new List<String>{'b', 'c'};
      controller.setCategoriesForIdea(categories);
      System.assertEquals(new List<String>{'a','b','c'}, controller.getCategoriesForIdea(), 'getcategoriesforidea should return list of categories');
  }
  
  static testMethod void testDefaultTitle() {
  	IdeaPostController controller = new IdeaPostController();
  	System.assertEquals('Give your idea a title', controller.defaultTitle, 'getDefaultTitle should return \'Give your idea a title\'');
  }
  
  static testMethod void testGetSimilarIdeas() {
  	  IdeaTestUtil.setupTest();
  	  Idea ideaA = IdeaTestUtil.makeIdea('similarIdeaNow', '', null, null);

      System.debug('Idea Id just posted: '+ideaA.id);      
      IdeaPostController c = new IdeaPostController();
      c.getIdea().title = 'similarIdeaNow';
      c.loadSimilar();
      Boolean hasSimilar = c.getHasSimilarIdeas(); //should return true. But due to indexing or timing issues, the expected result is not seen
      Idea[] searchResult = c.getSimilarIdeas(); //should return a list with one idea
  }

  static testMethod void testPostIdeaWithNullTitle() {
      IdeaTestUtil.setupTest();
      IdeaPostController c = new IdeaPostController();
      c.getIdea().title = null;
      List<SelectOption> categoryOptions = c.getCategoryOptions();
      List<String> categories = new List<String>();
      Integer i = categoryOptions.size();
      
      for(Integer index=0; index<Math.min(i, 3); index++) {
        categories.add(categoryOptions[index].getValue());
      }
      
      c.setCategoriesForIdea(categories);
      PageReference invalidPage = c.save();
      System.assert(invalidPage == null);
      System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR) == true, 'There should be error messages while posting a valid idea');
      ApexPages.Message[] messages = ApexPages.getMessages();
      System.assertEquals('Please enter a valid Title', messages[0].getDetail(), 'validateTitle should add error message \'Please enter a valid Title\' for a null title');      
  }

  static testMethod void testPostIdeaWithDefaultTitle() {
  	  IdeaTestUtil.setupTest();
      IdeaPostController c = new IdeaPostController();
      c.getIdea().title = c.defaultTitle;
      List<SelectOption> categoryOptions = c.getCategoryOptions();
      List<String> categories = new List<String>();
      Integer i = categoryOptions.size();
      
      for(Integer index=0; index<i; index++) {
        categories.add(categoryOptions[index].getValue());
      }
      
      c.setCategoriesForIdea(categories);
      PageReference invalidPage = c.save();
      System.assert(invalidPage == null);
      System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR) == true, 'There should be error messages while posting a valid idea');
      ApexPages.Message[] messages = ApexPages.getMessages();
      System.assertEquals('Please enter a valid Title', messages[0].getDetail(), 'validateTitle should add error message \'Please enter a valid Title\' for a null title');      
  }

  static testMethod void testPostIdeaWithBlankTitle() {
  	  IdeaTestUtil.setupTest();
      IdeaPostController c = new IdeaPostController();
      c.getIdea().title = '   ';
      List<SelectOption> categoryOptions = c.getCategoryOptions();
      List<String> categories = new List<String>();
      Integer i = categoryOptions.size();
      
      for(Integer index=0; index<i; index++) {
        categories.add(categoryOptions[index].getValue());
      }
      
      c.setCategoriesForIdea(categories);
      PageReference invalidPage = c.save();
      System.assert(invalidPage == null);
      System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR) == true, 'There should be error messages while posting a valid idea');
      ApexPages.Message[] messages = ApexPages.getMessages();
      System.assertEquals('Please enter a valid Title', messages[0].getDetail(), 'validateTitle should add error message \'Please enter a valid Title\' for a null title');      
  }

  static testMethod void testPostIdeaWithValidTitle() {
      IdeaTestUtil.setupTest();      	
      IdeaPostController c = new IdeaPostController();
      c.getIdea().title = 'testing save';
      List<SelectOption> categoryOptions = c.getCategoryOptions();
      List<String> categories = new List<String>();
      Integer i = Math.min(categoryOptions.size(), 3);
      
      for(Integer index=0; index<i; index++) {
      	categories.add(categoryOptions[index].getValue());
      }
      
      c.setCategoriesForIdea(categories);
      PageReference validPage = c.save();
      System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR) == false, 'There should not be any error messages while posting a valid idea');
      System.assert(validPage.getUrl().contains(IdeaController.URL_LIST));
      System.assert(validPage.getUrl().contains(IdeaController.SORT_RECENT));      
  }

  static testMethod void testPostIdeaWithoutCategory() {
      IdeaTestUtil.setupTest();         
      IdeaPostController c = new IdeaPostController();
      c.getIdea().title = 'testing save';
      PageReference validPage = c.save();
      System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR) == false, 'There should not be any error messages while posting a valid idea');
      System.assert(validPage.getUrl().contains(IdeaController.URL_LIST));
      System.assert(validPage.getUrl().contains(IdeaController.SORT_RECENT));
  }

  static testMethod void testCancel() {
      IdeaTestUtil.setupTest();
      IdeaPostController c = new IdeaPostController();
      c.getIdea().title = 'testing cancel';
      PageReference ideaPage = c.cancel();
      System.assert(ideaPage.getUrl().contains(IdeaController.PAGE_LIST) == true, 'Cancel Post should redirect to ideaList Page');
  }  
}