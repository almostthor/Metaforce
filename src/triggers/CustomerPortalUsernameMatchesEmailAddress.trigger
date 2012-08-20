trigger CustomerPortalUsernameMatchesEmailAddress on User (before update) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        for (User u : Trigger.new) {
            if (u.userType.endsWith('CustomerSuccess')) {
                if (u.username != u.email) {
                    u.username = u.email;
                }
            }
        }
    }
}