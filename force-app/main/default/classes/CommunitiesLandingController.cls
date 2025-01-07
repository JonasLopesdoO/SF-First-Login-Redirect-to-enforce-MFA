/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CommunitiesLandingController {
    public PageReference forwardToStartPage() {
        User loggedUser = [SELECT Id, FirstLoginDate__c, LastLoginDate FROM User WHERE Id =: UserInfo.getUserId()];
        String communityUrl = Site.getBaseUrl();

        if (loggedUser.FirstLoginDate__c == null) {
            loggedUser.FirstLoginDate__c = loggedUser.LastLoginDate;
            update loggedUser;
            return new PageReference(communityUrl + '/secur/logout.jsp');
        }
        
        return Network.communitiesLanding();
    }
    
    public CommunitiesLandingController() {}
}