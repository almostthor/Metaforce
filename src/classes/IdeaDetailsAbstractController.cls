public abstract class IdeaDetailsAbstractController extends IdeaController {

    public Idea conIdea { get; set; }
    public String conCategories { 
        get { 
            if (conCategories == null && conIdea != null) { 
                conCategories = conIdea.categories; 
            }
            return conCategories;
        }
        set; 
    }    

    public String getUpdatedVoteTotal() {
        return Math.Round(conIdea.voteTotal).format();
    }

    public String getCreatedByCommunityNickname() {
        User creator = conIdea.createdBy;
        if (creator != null) {
            return creator.communityNickname;
        } else {
            return [select communityNickname from user where id = :conIdea.createdById].communityNickname;
        }
    }

    public String getCreatedById() {
        return conIdea.createdById;
    }
    
    public String getFormattedDate() {
        return conIdea.createdDate.format('d MMM yyyy h:mm a'); 
    }

    public List<String> getSplitCategories() {
        if (conCategories == null) {
            return new String[0];
        } else {
            return conCategories.split(';');
        }
    }

    public Boolean getHasCategories() {
        if (conCategories == null) {
            return false;
        } else {
            return conCategories.length() > 0;
        }
    }
    
    public String getLastCategory() {
    	if (conCategories == null) return null;
        String[] splitCategories = getSplitCategories();
        return splitCategories[splitCategories.size() - 1];
    }

}