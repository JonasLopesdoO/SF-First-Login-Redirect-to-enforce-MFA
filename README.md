
# Enforce MFA after first password setup - Experience Cloud

Hi everyone, some months ago I had a tricky requirement to solve in Salesforce Experience Cloud with MFA. I was preparing this material some time ago and wanted to share here for who can benefit from it.

## Requirement:
By security reasons, the client asked to only let the user log in the portal by going through the MFA process.

## Problem:
For some reason during the first login after the user sets his password does not fire the MFA in Eperience Cloud, and only triggers the MFA flow in the second login after setting the password.
So after the user set the password the first time he is redirected to the home page alreadu right after setting the password, even though MFA is enabled for that user.
It is only enforced in the second login flow as per Salesforce regular execution.

## Restrictions: 
The field `LastLoginDate` can not be used to trigger a flow, platform event or apex trigger as well as some other standard fields so we can not rely on this standard field to fire some process to enforce MFA.

## Solution: 
The solution involves Custom Field and Controller override.
- Create a new custom field in the User object called [FirstLoginDate__c](https://github.com/JonasLopesdoO/SF-First-Login-Redirect-to-enforce-MFA/blob/main/force-app/main/default/objects/User/fields/FirstLoginDate__c.field-meta.xml) to mimic the standard `LastLoginDate` in the User object so we can rely on it to compare the first login date to redirect the user to MFA if it is the first login.
- An override in the existing [CommunitiesLandingController](https://github.com/JonasLopesdoO/SF-First-Login-Redirect-to-enforce-MFA/blob/main/force-app/main/default/classes/CommunitiesLandingController.cls) apex controller for Login in experience cloud

## Explanation
If the new field is null in the first execution, it means it is the first user login, so we have to set it to be the same value as the current `LastLoginDate`.

After that we need to redirect the user to the logout so we make sure he will login again, and therefore, Salesforce will enforce MFA setup.

The code will be one time execution only for the first login to that user unless manually changed by the system administrator. So the new custom field can be created hidden from all profiles and only visible for the back end execution, with the solely purpose to enforce the MFA setup before login in to home page in the first time login.

---
> ℹ️ **_TIP:_**  This solution is needed as for today, however Salesforce can come up with a solution to that in the future. This is a temporary solution meanwhile this is still a misbehavior from Salesforce.
---