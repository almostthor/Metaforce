public class IdeaActivitiesByDay {
        private final Integer slot;
        private final List<IdeaActivity> activities = new List<IdeaActivity>();

        public IdeaActivitiesByDay(Integer slot) {
            this.slot = slot;
        }

    
        public boolean addActivity(IdeaActivity activity) {
            IdeaActivity.CommentGroup other = getOthersCommentsActivityFor(activity);
            if (other != null) {
                other.concatenate(activity);
                //activities.add(activity);
                return false;
            } else {
                activities.add(activity);
                return true;
            }
        }

        private IdeaActivity.CommentGroup getOthersCommentsActivityFor(IdeaActivity lookingFor) {
            for (IdeaActivity activity : activities) {
                if (activity.isConcatenatableWith(lookingFor)) {
                    return (IdeaActivity.CommentGroup) activity;
                }
            }
            return null;
        }

        public IdeaActivity getActivity(Integer index) {
            return activities.get(index);
        }

        public String getSectionName() {
            if (slot == 0) 
                return 'Recent Activity';
            else if(slot == 1)
                return 'Yesterday';
            else {
                return slot +' Days Ago';
            }      
        }

        public List<IdeaActivity> getActivities() {
        	activities.get(activities.size()-1).isLastActivityInList = true;
            return activities;
        }
    }