trigger IdeaSiteSetupValidations on IdeasSiteSetup__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isUpdate || Trigger.isInsert) {
        	// validate categories
            List<PicklistEntry> validCategories = Schema.SObjectType.Idea.fields.categories.picklistValues;
            for (Integer i = 0; i < Trigger.new.size(); i++) {
                IdeasSiteSetup__c nw = Trigger.new[i];
                if (nw.categories__c != null) {
	                String[] categories = nw.categories__c.split('\n');
	                Boolean isValid;
	                for (String c : categories) {
	                    isValid = false;
	                    for (PicklistEntry validCategory : validCategories) {
	                        if (c.trim() == validCategory.label) isValid = true;
	                    }
	                    if (!isValid) Trigger.new[i].categories__c.addError('Invalid category: ' + c);
	                }
                }
            }

            // validate statuses
            List<PicklistEntry> validStatuses = Schema.SObjectType.Idea.fields.status.picklistValues;
            for (Integer i = 0; i < Trigger.new.size(); i++) {
                IdeasSiteSetup__c nw = Trigger.new[i];
                if (nw.statuses__c != null) {
	                String[] statuses = nw.statuses__c.split('\n');
	                Boolean isValid;
	                for (String c : statuses) {
	                    isValid = false;
	                    for (PicklistEntry validStatus : validStatuses) {
	                        if (c.trim() == validStatus.label) isValid = true;
	                    }
	                    if (!isValid) Trigger.new[i].statuses__c.addError('Invalid status: ' + c);
	                }
                }
            }

            // validate CommunityId
            for (Integer i = 0; i < Trigger.new.size(); i++) {
                IdeasSiteSetup__c nw = Trigger.new[i];
                if (nw.communityId__c != null) {
                    Integer count = [select count() from community where id = :nw.communityId__c];
                    if (count == 0) Trigger.new[i].communityId__c.addError('Invalid communityId: ' + nw.communityId__c);
                }
            }

            // validate ExpertsGroupId
            for (Integer i = 0; i < Trigger.new.size(); i++) {
                IdeasSiteSetup__c nw = Trigger.new[i];
                if (nw.expertsGroupId__c != null) {
                    Integer count = [select count() from Group where id = :nw.expertsGroupId__c];
                    if (count == 0) Trigger.new[i].expertsGroupId__c.addError('Invalid GroupId: ' + nw.expertsGroupId__c);
                }
            }
        }
    }
}