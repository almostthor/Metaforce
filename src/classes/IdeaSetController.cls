public class IdeaSetController {
    private ApexPages.StandardSetController setCon;
    private SObject[] sObjs;
    public Integer resultSize { get; set; }
    public Integer numPages { get; set; }   
    public Integer currentPage;
    public Integer pageSize { get; set; }
    
    public IdeaSetController(Database.QueryLocator qLoc, Integer pageNum) {
        this(qLoc, pageNum, 20);   	
    }
    
    public IdeaSetController(Database.QueryLocator qLoc, Integer pageNum, Integer pageSize) {
        this.setCon = new ApexPages.StandardSetController(qLoc);
        this.resultSize = setCon.getResultSize();
        this.pageSize = pageSize;
        this.numPages = calcNumPages(resultSize, setCon.getPageSize(), true);
        this.currentPage=pageNum;
        /* doesn't work yet
        if (pageSize != null) {
        	setCon.setPageSize(pageSize);
        }
        */
        setCon.setPageNumber(pageNum);
    }

    public IdeaSetController(Database.QueryLocator partialQLoc, Integer resultSize, Integer pageNum, Integer pageSize) {
        this.setCon = new ApexPages.StandardSetController(partialQLoc);
        this.resultSize = resultSize;
        this.pageSize = pageSize;
        this.numPages = calcNumPages(resultSize, setCon.getPageSize(), true);
        this.currentPage=pageNum;
        /* doesn't work yet
        if (pageSize != null) {
        	setCon.setPageSize(pageSize);
        }
        */
        setCon.setPageNumber(pageNum);
    }

    public IdeaSetController(SObject[] sObjs, Integer pageNum, Integer resultSize, Integer pageSize) {
        this.sObjs = sObjs;
        this.resultSize = resultSize;
        this.pageSize = pageSize;
        this.numPages = calcNumPages(resultSize, pageSize, true);
        this.currentPage=pageNum;
    }
    
    public static Integer calcNumPages(Integer resultSize, Integer objectsPerPage, Boolean respectSoqlLimit) {
    	if (resultSize == 0) resultSize = 1;
        Integer setResultSize = respectSoqlLimit ? Math.min(resultSize, IdeaController.SOQL_ROW_LIMIT) : resultSize;
    	Integer numPages = setResultSize / objectsPerPage;
    	if (Math.mod(setResultSize, objectsPerPage) > 0) {
    		numPages++;
    	}
    	return numPages;
    }
 
    public List<SObject> getRecords() {
    	if (sObjs == null) {
    		sObjs = setCon.getRecords();
    	}
        return sObjs;
    }

    public Integer totalNumPages { 
    	get {
    		if (totalNumPages == null) {
    			totalNumPages = calcNumPages(resultSize, pageSize, false);
    		}
    		return totalNumPages;
    	}
		set; 
	}   

    
}