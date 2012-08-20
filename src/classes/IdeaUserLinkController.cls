public class IdeaUserLinkController extends IdeaController {

    public String userId { get; set; }
    private String communityNickname;
    private static List<GroupMember> experts;

    public String getConCommunityNickname() {
        if (communityNickname == null || communityNickname == '') {
            communityNickname = [select communityNickname from user where id=:userId].communityNickname;
        }
        return communityNickname;
    }

    public void setConCommunityNickname(String newName) {
        communityNickname = newName;
    }

    public PageReference getUserPage() {
        return getUserPage(userId);
    }

    public String getUserStyleClass() {
        return isUserExpert(userId) ? 'ibtUserLinkExpert' : 'ibtUserLinkNormal';
    }

    public static Boolean isUserExpert(String userId) {
        if (experts == null) {
            loadExperts();
        }
        for (GroupMember expert : experts) {
            if ((IdeaController.toShortId((String)expert.userOrGroupId)).equals(userId)) {
                return true;
            }
        }

        return false;
    }

    public static void loadExperts() {
      
        String expertsGroupId = IdeaController.siteSetup.expertsGroupId__c;
        
        if (expertsGroupId != null) {
            experts = [select userOrGroupId from GroupMember where groupId=:expertsGroupId];
        } else {
            experts = new List<GroupMember>();
        }
    }
}