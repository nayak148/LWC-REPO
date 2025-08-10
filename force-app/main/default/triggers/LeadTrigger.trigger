trigger LeadTrigger on Lead (before update, after insert) {
    if(trigger.isbefore && trigger.isupdate){
        LeadTriggerHandler.SetLeadStatusToWorkingCondition(Trigger.New);
        LeadTriggerHandler.whenIndIdHealthcareSETcond(trigger.new);
    }
    if(Trigger.isAfter && Trigger.isInsert){
       LeadTriggerHandler.creteTaskforleadOwn(Trigger.New);  
    }
    if(Trigger.IsBefore && Trigger.IsDelete){
        system.debug('Enter in master trigger');
       LeadTriggerHandler.donotDeleteWorkLead(Trigger.old);  
    }
    
    
}