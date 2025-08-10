trigger AccountTrigger on Account (after insert,Before insert, before update, After Update) {
   
    if(AccountTriggerHandler2.firstRun){
          AccountTriggerHandler2.firstRun = false;
      if(Trigger.IsAfter){
        if(Trigger.IsInsert||Trigger.isUpdate|| Trigger.isDelete||Trigger.isUndelete){
            AccountTriggerHandler2.createNconinAcc(trigger.new,trigger.old,Trigger.oldmap);
        }
   
    }
    }
    
    
    /*if(trigger.isAfter && trigger.isInsert){
       // AccountTriggerHandler.createNcontactsAccount(Trigger.New);
       // AccountTriggerHandler.creationNLocation(Trigger.new,Null);
       // AccountTriggerHandler.createNconinAcc(Trigger.new,null);
        
       // AccountTriggerHandler.autoUPDATEvconWEBSITEandPHONE(trigger.new,trigger.oldmap);
        
       // AccountTriggerHandler.whenAccIScreatedAutoInsertCON(Trigger.new);
    }
    if(trigger.isBefore && trigger.isInsert){
     // AccountTriggerHandler.updatebillingcity(trigger.new); 
    }
    
    
    if(trigger.IsBefore && trigger.isUpdate){
       // AccountTriggerHandler.donotallowUSERtoSETownership(Trigger.new,Trigger.oldMap);
    }
    
    if(trigger.IsAfter && trigger.isUpdate){
        //AccountTriggerHandler.createNcontactsAccount(Trigger.New);
      // AccountTriggerHandler.createNconinAcc(Trigger.new,trigger.oldmap);
      // AccountTriggerHandler.creationNLocation(Trigger.new, Trigger.oldmap);
     //AccountTriggerHandler.autoUPDATEvconWEBSITEandPHONE(trigger.new,trigger.oldmap);  
     // AccountTriggerHandler.ACCtoCONupdatePhone(Trigger.new, Trigger.oldmap);
        //AccountTriggerHandler.AutoUpdateAddresFROMacctoCon(trigger.newmap,trigger.oldmap);
    }*/
    
    

}