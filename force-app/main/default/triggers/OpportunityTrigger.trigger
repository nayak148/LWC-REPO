trigger OpportunityTrigger on Opportunity (Before Insert,After Insert,Before Update ,After Update,Before Delete,After Delete,After Undelete) {
   
    if(Trigger.IsAfter){
        if(Trigger.isInsert || Trigger.IsUpdate || Trigger.IsDelete || Trigger.IsUndelete){
            OpportunityTriggerHandler.showSUMofOPPinACC(Trigger.new, Trigger.oldmap,Trigger.old);
            //OpportunityTriggerHandler.updateOppNameWITHAccNameCreateDate(Trigger.new);
        }
        
    }
     if(Trigger.IsAfter && Trigger.IsInsert){
       // OpportunityTriggerHandler.updateOppNameWITHAccNameCreateDate(Trigger.new);
         system.debug('trigger enter in to after insert opp');
    }
    if(Trigger.IsBefore && Trigger.IsUpdate){
      //  OpportunityTriggerHandler.updateOppNameWITHAccNameCreateDate(Trigger.new,Trigger.oldMap);
               //system.debug('trigger enter in to After update insert opp');
    }
    

      
    /*if(Trigger.IsAfter && Trigger.IsUpdate){
        OpportunityTriggerHandler.whenOppisCloseWonCreateTask(Trigger.New , Trigger.oldMap);
        OpportunityTriggerHandler.removeALLoppTEAMmember(Trigger.new,trigger.oldmap);
        //OpportunityTriggerHandler.UpatesumofOPPamtToACCAmt(trigger.new,Trigger.oldMap);
        
     }
     if(Trigger.IsBefore && Trigger.IsUpdate){
        OpportunityTriggerHandler.updateOppAmount(Trigger.New,Trigger.oldMap);
         
     }
    if(Trigger.isAfter && Trigger.IsDelete){
       OpportunityTriggerHandler.createTaskwhenOppDelete(Trigger.old);
       // OpportunityTriggerHandler.UpatesumofOPPamtToACCAmt(Trigger.old);
    }
    if(Trigger.IsAfter && Trigger.IsInsert){
        // OpportunityTriggerHandler.UpatesumofOPPamtToACCAmt(trigger.new, null);     
         
    }
    if(Trigger.IsAfter && Trigger.IsUndelete){
         //OpportunityTriggerHandler.UpatesumofOPPamtToACCAmt(trigger.new, null);     
    }*/


   
}