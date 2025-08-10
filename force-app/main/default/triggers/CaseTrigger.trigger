trigger CaseTrigger on Case (before insert,After Insert ,before delete) {
    if(Trigger.isBefore && Trigger.isInsert){
        CaseTriggerHandler.whenCaseISPhoneSetPriorityHigh(Trigger.New);
    }
    if(Trigger.isBefore && Trigger.isDelete){
        CaseTriggerHandler.AllowCaseDeleteONLYbySysAdminUser(trigger.old);
    }
    if(Trigger.isInsert && Trigger.IsAfter){
       CaseTriggerHandler.sendMailToCaseOwner(Trigger.new);   
    }
    

}