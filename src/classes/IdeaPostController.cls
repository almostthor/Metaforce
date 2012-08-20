public class IdeaPostController extends IdeaController {
    private transient Idea ideaObj;
    private transient Idea[] searchResult;
    public String defaultTitle { get { if (defaultTitle == null) { defaultTitle = 'Give your idea a title'; } return defaultTitle; } set; }

    public IdeaPostController(ApexPages.StandardController controller) {
    }

    public IdeaPostController()
    {
    }

    public Idea getIdea() {
        if (ideaObj == null) {
            ideaObj = new Idea();
            ideaObj.communityId = getCommunityId();
        }
        return ideaObj;
    }

    private void validateCategories() {
        if (getIdea().categories != null) {
            String[] categories = getIdea().categories.split(';');
            if (categories.size() > 3) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please select up to 3 categories'));
            }
        }
    }
    
    public void validateTitle() {
        if( (getIdea().title == null) || (getIdea().title == defaultTitle) ) {
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please enter a valid Title'));
        }
    }

    public PageReference save() {
        try {
        	validateTitle();
        	validateCategories();
            if (ApexPages.hasMessages()) {
                return null;
            }

            insert ideaObj;
            PageReference ideaPage = getListPage(IdeaController.SORT_RECENT, null, null);
            ideaPage.setRedirect(true);
            return ideaPage;
        } catch (System.DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDmlMessage(i)));
            }
            return null;
        }
    }

    public PageReference cancel() {
        PageReference ideaPage = getListPage(sortParam, categoryParam, statusParam);
        ideaPage.setRedirect(true);
        return ideaPage;
    }

    public Idea[] getSimilarIdeas() {
        return searchResult;
    }

    public PageReference loadSimilar() {
        getIdea();
        Id[] similarIds = Ideas.findSimilar(ideaObj);
        if (similarIds == null || similarIds.size() == 0) {
            return null;
        } else {
            searchResult = [select title from idea where id in :similarIds];
        }
        return null;
    }

    public Boolean getHasSimilarIdeas() {
        return searchResult != null && searchResult.size() > 0;
    }
    
    public  List<SelectOption> getCategoryOptions() {
        List<SelectOption> valueOptions = new List<SelectOption>();
        for (String value : getCategories()) {
            valueOptions.add(new SelectOption(value, value));
        }
        return valueOptions;
    }
     
    public String[] getCategoriesForIdea() {
        String categories = getIdea().categories;
        if (categories == null) {
          return new List<String>();
        } else {
          return categories.split(';');
        }
    }

    public void setCategoriesForIdea(String[] categories) {
        String categoryString = '';

        for (String category : categories) {
            if (categoryString.length() > 0) {
                categoryString += ';';
            }
            categoryString += category;
        }

        Idea idea = getIdea();
        if (idea.categories == null || idea.categories.length() == 0) {
            idea.categories = categoryString;
        } else if (categoryString.length() > 0) {
            idea.categories += ';';
            idea.categories += categoryString;
        }
    }
}