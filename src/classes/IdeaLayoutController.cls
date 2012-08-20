public class IdeaLayoutController extends IdeaController {

    private static final Set<String> CACHED_PAGES = new Set<String>();

    static {
        CACHED_PAGES.add(IdeaController.getPage('/'));
        CACHED_PAGES.add(IdeaController.PAGE_HOME.toLowerCase());
        CACHED_PAGES.add(IdeaController.PAGE_ABOUT.toLowerCase());
        CACHED_PAGES.add(IdeaController.PAGE_LIST.toLowerCase());
        CACHED_PAGES.add(IdeaController.PAGE_VIEW.toLowerCase());
        CACHED_PAGES.add(IdeaController.PAGE_PROFILE_ACTIVITY.toLowerCase());
        CACHED_PAGES.add(IdeaController.PAGE_PROFILE_LIST.toLowerCase());
    }

    public String currentPageUrl {
        get {
        	return currentPageReference.getUrl();
        }
    }
    
    public String getCurrentPageString() {
        return IdeaController.getPage(currentPageUrl);
    }

    public Boolean getDoCacheThisPage() {
        return CACHED_PAGES.contains(getCurrentPageString().toLowerCase());
    }

    public Boolean getDoCache() {
        return !getIsLoggedIn() && getDoCacheThisPage();
    }

    public Integer getCacheMaxAge() {
        return getDoCache() ? Math.round(getSiteSetup().CacheMaxAge__c) : 0;
    }
}