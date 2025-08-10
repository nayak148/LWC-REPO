public class UserTriggerHandler {
    public static void updateDesctiption(list<user> newRec){
        for(user ur: newrec){
            ur.Description__c =  ' This Description Data Came form Trigger : '+
                                 '  User id : '+ ur.id +
                                '  UserAccId: ' + ur.AccountId + 
                                '  Email :  ' + ur.Username  ;
            
        }
    }
}