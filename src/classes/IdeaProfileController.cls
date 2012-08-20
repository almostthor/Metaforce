public class IdeaProfileController extends IdeaController {

    public String communityNickname { get; set; }

    private transient List<IdeaComment> ideaComments = new List<IdeaComment>();
    private transient List<IdeaComment> userComments = new List<IdeaComment>();
    private static final Integer MAX_COMMENT_LENGTH = 100;
    private transient List<IdeaActivitiesByDay> activitiesByDay;
    private transient List<IdeaActivity>  sortedActivities;
    private static final Integer MAX_ACTIVITIES = 25;
    private static final Integer DAYS_AGO = 30;
    private transient String userNicknameFromParam;
    private transient User userFromParam;
    private transient Integer numberOfUnreadRecentRepliesForCurrentUser;


    public IdeaProfileController() {
    }

    
    public boolean getHasActivities() {
        if(getUserFromParam() != null)
            return getActivities().size() > 0;
        else
            return false;
    }

    public String getUserNicknameFromParam() {
        if(userNicknameFromParam == null && userParam != null && userParam.length() != 0) {
            userNicknameFromParam = getUserFromParam().communityNickname;
        }
        return userNicknameFromParam;
    }

    public User getUserFromParam() {
        if (userParam == null) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Missing userId parameter'));
        }
        try {
            if (userFromParam == null && userParam != null) {
                userFromParam = [select Id, communityNickname from user where id = :userParam];
            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Invalid userId parameter'));
        }
        return userFromParam;
    }
    
    public Integer getNumberOfUnreadRecentRepliesForCurrentUser() {
        if (numberOfUnreadRecentRepliesForCurrentUser == null) {
            numberOfUnreadRecentRepliesForCurrentUser = Ideas.getUnreadRecentReplies(UserInfo.getUserId(), getCommunityId()).size();
        }
        return numberOfUnreadRecentRepliesForCurrentUser;
    }
    

    public List<IdeaActivity> getActivities() {
        if(sortedActivities == null) {
            sortedActivities = new List<IdeaActivity>();
            List<String> activityIds = new List<String>(); 
            List<IdeaActivity> yourCmtActivities = new List<IdeaActivity>();
            List<IdeaActivity> cmtOnYourIdeasActivities = new List<IdeaActivity>();
            List<IdeaActivity> cmtActivities = new List<IdeaActivity>();
            List<IdeaActivity> ideaActivities = new List<IdeaActivity>();
            List<IdeaActivity> voteActivities = new List<IdeaActivity>();
        
            Datetime aMonthAgo = System.now().addDays(-DAYS_AGO); 
                
            //System.assert(userNickname !=null, 'User Nickname is null ' + userNickname);
            //System.assert(nickname !=null, 'Nickname is null ' + nickname);
            User userFromParam = getUserFromParam();
            String nickname = getUserNicknameFromParam();
            List<IdeaComment> yourCmtList = [select IdeaId, Idea.Title, Idea.CreatedById, CreatedDate, id, commentBody,  IsHtml from ideaComment 
                                             where Idea.communityId= :getCommunityId() and CreatedById = :userFromParam.Id and CreatedDate > :aMonthAgo order by CreatedDate desc  LIMIT 200];

            List<IdeaComment>  cmtOnYourIdeasList = [select IdeaId, Idea.Title, Idea.CreatedById, CreatedDate, id, commentBody, createdBy.communityNickname, createdById, IsHtml from ideaComment
                                                     where Idea.communityId= :getCommunityId() and Idea.CreatedById = :userFromParam.Id and CreatedById != :userFromParam.Id and CreatedDate > :aMonthAgo order by CreatedDate desc  LIMIT 200];

            List<Idea> ideaList = [select Id, Title, CreatedById, CreatedDate from idea 
                                   where Idea.communityId= :getCommunityId() and Idea.CreatedById = :userFromParam.Id  and CreatedDate > :aMonthAgo  order by CreatedDate desc  LIMIT 200];

            //When a user creates an idea a vote is cast on the idea on behalf of the user automatically
            //So we need to exclude these ideas from the yourVotesList query. Because Apex does not allow us to have
            //a List that is more than 1000 in size we need to limit the query below to 1000.
            //We dont expect the user to have more than 1000 ideas. If the user does have more than a 1000 ideas then 
            //the yourVotesList query (below) will return incorrect results because all the ideas above 1000 will not 
            //be removed from the list of ideas you voted on.  
            List<Idea> allIdeaList = [select Id, Title, CreatedById, CreatedDate from idea 
                                      where Idea.communityId= :getCommunityId() and Idea.CreatedById = :userFromParam.Id  order by CreatedDate desc  LIMIT 200];
        
        
            for (Idea idea : ideaList ) {
                ideaActivities.add(new IdeaActivity.IdeaCreatedActivity(idea.Id, idea.Title, idea.CreatedById, idea.CreatedDate,
                                                                        nickname, null));  
            }
        
            for (IdeaComment comment : yourCmtList) {
                yourCmtActivities.add(new IdeaActivity.CommentCreatedActivity(comment.IdeaId, comment.Idea.Title, comment.idea.CreatedById,
                                                                              comment.CreatedDate, comment.Id, comment.commentBody, nickname, userFromParam.Id, comment.IsHtml));
            }
            
            for (IdeaComment comment : cmtOnYourIdeasList) {
                cmtOnYourIdeasActivities.add(new IdeaActivity.CommentCreatedActivity(comment.IdeaId, comment.Idea.Title, comment.idea.CreatedById,
                                                                                     comment.CreatedDate, comment.Id, comment.commentBody, comment.CreatedBy.communityNickname, comment.createdById, comment.IsHtml));
            }
            mergeSortedLists(yourCmtActivities, 0, yourCmtActivities.size()-1, cmtOnYourIdeasActivities, 0, cmtOnYourIdeasActivities.size()-1, cmtActivities);    
               
            //For votes a lot more processing needs to be done
            String []ideaCreatedIds = new List<String>();
            for (Idea idea : allIdeaList ) {
                ideaCreatedIds.add(idea.id);
            }
                
            List<Vote> yourVotesList = [select ParentId, CreatedDate, Type from Vote 
                                        where CreatedById = :userFromParam.Id and ParentId not in :ideaCreatedIds and CreatedDate > :aMonthAgo order by CreatedDate desc  LIMIT 200];
                
            String[] ideaIds = new String[yourVotesList.size()];
            for (Vote ideaVote : yourVotesList) {       
                ideaIds.add(ideaVote.parentId);
            }
  
            List<Idea> votedIdeaList = [select  Id, Title, CreatedById from Idea where Id in :ideaIds and communityId= :getCommunityId()];        
           
            Map<String, Vote> ideasVoteMap = new Map<String, Vote>();
            for (Vote ideaVote : yourVotesList) {       
                ideasVoteMap.put(ideaVote.parentId, ideaVote);
            }
            
            for (Idea idea : votedIdeaList ) {
                Vote ideaVote = ideasVoteMap.get(idea.id);
                voteActivities.add(new IdeaActivity.VoteCreatedActivity(idea.Id, idea.Title, idea.CreatedById, ideaVote.CreatedDate,
                                                                        nickname, userFromParam.Id, null,ideaVote.Type));
            }

            List<IdeaActivity> sortedVoteActivities = new List<IdeaActivity>(); 
            if(voteActivities.size() > 1) {  
                mergeSort(voteActivities, 0, voteActivities.size()-1, sortedVoteActivities);    
            } else {
                sortedVoteActivities = voteActivities;
            }

            List<IdeaActivity>  semiSortedActivities = new List<IdeaActivity>();
                
            mergeSortedLists(cmtActivities, 0, cmtActivities.size()-1, ideaActivities, 0, ideaActivities.size()-1, semiSortedActivities);
            mergeSortedLists(sortedVoteActivities, 0, sortedVoteActivities.size()-1, semiSortedActivities, 0, semiSortedActivities.size()-1, sortedActivities);    
        }
        return sortedActivities;

    }
    
    void mergeSort(List<IdeaActivity> firstList, Integer startIndex, Integer endIndex, List<IdeaActivity> sortedActivities) {
        if(startIndex < endIndex) {
            Integer mid = (startIndex + endIndex)/2;

            // Create temp arrays to write the sub-sorted arrays to
            List<IdeaActivity> leftList = new List<IdeaActivity>();   
            List<IdeaActivity> rightList = new List<IdeaActivity>();   
            
            mergeSort(firstList, startIndex, mid, leftList);
            mergeSort(firstList, mid+1, endIndex, rightList);
            
            mergeSortedLists(leftList, 0, leftList.size()-1, rightList, 0, rightList.size()-1, sortedActivities);
                    
        } else {
            // Base case, firstList has only 1 element, so write that element to sortedActivities
            sortedActivities.add(firstList.get(startIndex));
        }
    }
        
    void mergeSortedLists(List<IdeaActivity> firstList, Integer startIndex1, Integer endIndex1, List<IdeaActivity> secondList, Integer startIndex2, Integer endIndex2, List<IdeaActivity> sortedActivities) {  
        Integer firstIndex = startIndex1;
        Integer secondIndex = startIndex2;     
        boolean done = false;
        for(; !done;) {
            if(secondIndex <= endIndex2 && firstIndex <= endIndex1 && firstList.get(firstIndex).getDate() >= secondList.get(secondIndex).getDate()) {
                sortedActivities.add(firstList.get(firstIndex));
                //System.debug(Logginglevel.INFO, 'Now adding ' + firstList.get(firstIndex).getFirstLineHtml());
                firstIndex++;
            }
            if(firstIndex <= endIndex1 && secondIndex <= endIndex2 && secondList.get(secondIndex).getDate() >= firstList.get(firstIndex).getDate()) {
                sortedActivities.add(secondList.get(secondIndex));
                //System.debug(Logginglevel.INFO, 'Now adding ' + secondList.get(secondIndex).getFirstLineHtml());
                secondIndex++;
            }
            if(firstIndex > endIndex1)
                done = true;
            if(secondIndex > endIndex2)
                done = true;    
        }
        while(firstIndex <= endIndex1) {
            sortedActivities.add(firstList.get(firstIndex));
            firstIndex++;
        }
        while(secondIndex <= endIndex2) {
            sortedActivities.add(secondList.get(secondIndex));
            secondIndex++;
        }  
    }
    
    public List<IdeaActivitiesByDay> getActivitiesByDay() {
        if (activitiesByDay == null) {
            activitiesByDay = groupActivitiesByDay(getActivities());
        }
        return activitiesByDay;
    }

    public List<IdeaActivitiesByDay> groupActivitiesByDay(List<IdeaActivity> activitiesToGroup) {
        Map<Integer, IdeaActivitiesByDay> result = new Map<Integer, IdeaActivitiesByDay>();
        Integer activityCount = activitiesToGroup.size();
        Integer count = 0;
        for (Integer i = 0; (i < activityCount) && (count < MAX_ACTIVITIES); i++) {
            IdeaActivity activity = activitiesToGroup.get(i);
            Integer slot = IdeaActivity.getDaysBefore(activity.getDate());
            IdeaActivitiesByDay thisDay;
            if (result.get(slot) == null) {
                thisDay = new IdeaActivitiesByDay(slot);
                result.put(slot, thisDay);
            } else {
                thisDay = result.get(slot);
            }
            boolean wasMergedWithExistingActivity = !thisDay.addActivity((IdeaActivity) activity.clone());
            if (!wasMergedWithExistingActivity) {
                count++;
            }
        }
        List<IdeaActivitiesByDay> ideaActivities = new List<IdeaActivitiesByDay>();
        for(Integer index = 0; index < DAYS_AGO; index++) {
            if(result.get(index) != null) {
                ideaActivities.add(result.get(index));
            }
        }
        return ideaActivities;
    }

    public Boolean getIsProfileUserLoggedIn() {
        return userParam.substring(0,15).equals(UserInfo.getUserId().substring(0,15));
    }
}