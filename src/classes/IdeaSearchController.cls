public class IdeaSearchController extends IdeaController {
	public IdeaSetController setCon { get; set; }
	public IdeaComment[] comments { get; set; }
    public static final Integer SEARCH_RESULTS_PAGE_SIZE = 20;
    public static final Integer SEARCH_RESULTS_MAX_RESULTS = 200;	

    public IdeaSearchController(String searchTermParam) {
        //for tests
        if (searchTermParam != null) {
            doSearch(searchTermParam);
        }        
    }
    
    public IdeaSearchController() {
        if (searchTermParam != null) {
            doSearch(searchTermParam);
        }
    }

    private void doSearch(String searchTermParam) 
    {
    		//Escaping single-quote and backslash does not work so replacing them
    		//with an empty string for now, this is equivalent to converting to wild-char
    		//The behavior in this case is that if you search for either "abc'xyz" or "abc\xyz"
    		//then it returns anything with "abc xyz", "abc/xyz" "abc\xyz" "abcxyz", "abczxyz", "abc'xyz" etc
    		//Note that you will see the same behavior even with chars such as white-space * . $ ^ ,
    		// Which means when user enters the query "abc xyz" or "abc*xyz" she will see the same set of results  
    		Pattern escapeTerm = Pattern.compile('[\\\\]');
    		String escapedSearchTermParam = escapeTerm.matcher(searchTermParam).replaceAll('');
        	escapeTerm = Pattern.compile('[\']');
        	escapedSearchTermParam = escapeTerm.matcher(escapedSearchTermParam).replaceAll('');
            List<List<SObject>> searchList = null;
            escapedSearchTermParam = escapedSearchTermParam.trim();
            //Don't search if search query is empty string or single char
            if(escapedSearchTermParam.length() <= 1) {
            	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please use a search term with more than one valid character.'));
            } else {
            	try {
            		Integer searchRowLimit = Math.min(SEARCH_RESULTS_MAX_RESULTS, getPageParamInt()*SEARCH_RESULTS_PAGE_SIZE);
            		searchList = search.query('FIND \'' + escapedSearchTermParam + '\' IN ALL FIELDS RETURNING Idea (Id WHERE CommunityId = \''+ getCommunityId() +'\') LIMIT '+searchRowLimit);
           	 	} catch(Exception e) {
            		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Invalid search term, please try again'));
            	}
            }
            String[] selectedIds = new String[SEARCH_RESULTS_PAGE_SIZE];
            Integer numResults = 0;
            Idea[] selectedIdeas = new Idea[0];
            if(searchList != null) {
            	Idea[] allIdeas = ((List<Idea>)searchList[0]);
            	for (Integer i = (getPageParamInt()-1)*SEARCH_RESULTS_PAGE_SIZE; i < allIdeas.size(); i++) {
                    selectedIds.add(allIdeas[i].id);
            	}
            
            	selectedIdeas = [
                                    SELECT id, title, VoteTotal,categories,createdBy.communityNickname,createdDate,body,numComments,status,parentIdeaId,isLocked,LastCommentDate
                                    FROM Idea
                                    WHERE Id in :selectedIds
                                    ORDER BY Id DESC];
            }
            setCon = new IdeaSetController(selectedIdeas, getPageParamInt(), numResults, SEARCH_RESULTS_PAGE_SIZE);
    }
    
    public IdeaWithVote[] getIdeasWithVotes() {
        return IdeaWithVote.getIdeasWithVotes(getIdeas());
    }

    public Idea[] getIdeas() {
		return (List<Idea>)(setCon.getRecords());
    }
    
    public String getPageUrl() {
        PageReference pageRef = new PageReference(getSearchResultsUrl());
        if (searchTermParam != null) pageRef.getParameters().put(PARAM_SEARCH_TERM, searchTermParam);
        return pageRef.getUrl();
    }
    
    
    private String getPageUrl(Integer pageOffset) {
        PageReference pageRef = new PageReference(getSearchResultsUrl());
        if (searchTermParam != null) pageRef.getParameters().put(PARAM_SEARCH_TERM, searchTermParam);
        pageRef.getParameters().put(PARAM_PAGE, String.valueOf(getPageParamInt() + pageOffset));
        return pageRef.getUrl();        
    }
    public String getNextPageUrl() {
        return getPageUrl(1);
    }
    
    public String getPreviousPageUrl() {
        return getPageUrl(-1);        
    }
    
    public Boolean getIsFirstPage() {
        return getPageParamInt() == 1;
    }
    
    public Boolean getHasNextPage() {
    	return getPageParamInt() != setCon.totalNumPages;
    }
    
    public Boolean getHasMessages() {
    	return ApexPages.hasMessages();
    }
}