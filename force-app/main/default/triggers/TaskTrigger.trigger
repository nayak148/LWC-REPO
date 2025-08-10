trigger TaskTrigger on Task (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        TaskTriggerHandler.SetPriorityHighWhenTaskCreat(Trigger.new);
    }

}