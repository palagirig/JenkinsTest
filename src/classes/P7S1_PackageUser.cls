public with sharing class P7S1_PackageUser {
    public static List<User> userlist {get; set;}
    public static string PACKAGE_NAME {get; set;}
    public static string USER_COUNT {get; set;}
    
    public P7S1_PackageUser() {
    PACKAGE_NAME = 'advendio';
    userlist = new List<User>(
    
       [SELECT Id, Name, isactive, Profile.Name, Userrole.Name, p7s1_Unit__c, lastlogindate, P7S1_EmpLink__c, P7S1_Emp__c
       FROM User 
       WHERE Id in (
           SELECT UserId 
           FROM UserPackageLicense 
           WHERE (PackageLicense.NamespacePrefix = :PACKAGE_NAME))
       order by isactive asc, lastlogindate asc
       ]);
    USER_COUNT = string.valueof(userlist.size());
   }
}