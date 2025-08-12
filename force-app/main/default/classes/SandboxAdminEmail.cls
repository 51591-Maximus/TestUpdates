global class SandboxAdminEmail implements SandboxPostCopy {
    global void runApexClass(SandboxContext context) {
        List<User> users = [SELECT id, email, profileid FROM User
                            WHERE isActive = true AND profile.Name =
                            'System Administrator'];
        for(User u : users) {
            u.email = u.email.replace('@example.com', '').replace('=', '@').removeEndIgnoreCase('.invalid');
        }
        if(users.size() > 0) {
            Database.update(users, false);
        }
    }
}