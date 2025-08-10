trigger UserTrigger on User (before update) {
    if(Trigger.isBefore && Trigger.Isupdate){
        UserTriggerHandler.updateDesctiption(Trigger.New);
    }

}