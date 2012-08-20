public class IdeaDateFormatController {

    public Idea ideaParam { get; set; }
    public IdeaComment commentParam { get; set; }
    public Vote voteParam { get;set;}
    public String dateFormatNeeded { get;set;}
    public Boolean lastCommentDateNeeded
    {get { 
    	if (lastCommentDateNeeded == null ) {
    	   lastCommentDateNeeded =false;
    	}
    	return lastCommentDateNeeded;
        }
        set;}

    public String getDateDisplay() {
        
        Datetime datetimeValue;
        
        if (ideaParam != null) {
            if(lastCommentDateNeeded ) {
                if(ideaParam.lastCommentDate !=null)
                    return formatDateTime(ideaParam.lastCommentDate);
                else
                    return '';
            }
            else {            
                return formatDateTime(ideaParam.createdDate);
            }
        }
        else if (commentParam != null) {
            return formatDateTime(commentParam.createdDate);
        }
        else if (voteParam != null) {
        	return formatDateTime(voteParam.createdDate);
        }
        else {
            return '';
        }        	
    }
 
    public String formatDateTime(Datetime datetimeValue) {
    	return formatDateTime(datetimeValue, DateTime.now());
    }

    public String formatDateTime(Datetime datetimeValue, Datetime baseTime) {
  
        String dateDisplay;
        long nowMS = baseTime.getTime();
        long createdDateMS = datetimeValue.getTime();
        long millisAgo = nowMS - createdDateMS;
        DateTime beginningOfDayNow = DateTime.newInstance(baseTime.year(), baseTime.month(), baseTime.day());
        DateTime beginningOfDayCreatedDate = DateTime.newInstance(datetimeValue.year(), datetimeValue.month(), datetimeValue.day());
        long daysAgo = (beginningOfDayNow.getTime() - beginningOfDayCreatedDate.getTime()) / 86400000;
        
        if (daysAgo > 0) {
        // today, i.e. "7:20am"
          if (daysAgo < 2) {
            // "Yesterday"
            dateDisplay = 'Yesterday';
          } 
          else if (daysAgo < 4) {
            dateDisplay = String.valueOf(daysAgo) + ' days ago';
            // "2 days ago", "3 days ago"
          }
          else {
            // month and date of this year, i.e. "Jul 19, 2002"
            if (dateFormatNeeded == null ) {
            	dateFormatNeeded='MMM d, yyyy';
            }
           dateDisplay = datetimeValue.format(dateFormatNeeded);
          }
        } else if (millisAgo > 1800000) {
          dateDisplay = datetimeValue.format('h:mm a');                   
        } else if (millisAgo > 60000) {
          dateDisplay = String.valueOf(millisAgo / 60000) + ' minutes ago';
        }
        else {
          dateDisplay = String.valueOf(millisAgo / 1000) + ' seconds ago';
        }
        return dateDisplay;
    }
}