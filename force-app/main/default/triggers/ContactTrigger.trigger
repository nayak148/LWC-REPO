trigger ContactTrigger on Contact(Before Insert,After insert,before update, after update, before delete, after Delete, After Undelete ) {
    
    if( Trigger.isAfter && trigger.isUpdate){
        ContactTriggerHandlerPractice.ConPhoneChangeAutoUpdateAccPh(Trigger.new, Trigger.oldmap);
        ContactTriggerHandlerPractice.AutoupdateRelateConAccId(Trigger.new, Trigger.oldmap);
    }
    
    if(Trigger.IsBefore){
        if(Trigger.IsInsert || Trigger.IsUpdate){
           // ContactTriggerHandlerPractice.CheckPhoneEmailAlreadyExit(Trigger.new, Trigger.oldmap);
        }
    }
    if(Trigger.IsAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
           ContactTriggerHandlerPractice.sumofconAmounttoAcc(Trigger.new, Trigger.oldmap); 
           ContactTriggerHandlerPractice.polulateLastNameOFcontoAccount(Trigger.new, Trigger.oldmap);
            
        }
        
    }
    
    
    
   /* if(Trigger.isBefore){
        if(Trigger.Isinsert){
            //ContactTriggerHandler2.checkPhoneEmailAlreadyPresent(Trigger.new, null);
            system.debug(' Trigger entered in before insert : '  + Trigger.new);
        }
        if(Trigger.isUpdate){
            //ContactTriggerHandler2.checkPhoneEmailAlreadyPresent(Trigger.new, Trigger.oldmap);
            system.debug(' Trigger entered in before update : '  + Trigger.new +' oldmap'+ Trigger.oldmap);
        }
        
    }
    
    if(Trigger.IsAfter){
        if(Trigger.IsInsert || Trigger.isDelete || Trigger.IsUndelete ){
            ContactTriggerHandler.CONcountinAcc(Trigger.new, trigger.old);
           // ContactTriggerHandler2.displayConLastNameinAcc(Trigger.new,null,Trigger.old);
        }
        if(trigger.isUpdate){
            ContactTriggerHandler2.autoupdateAccinCon(trigger.new, trigger.oldmap);
            // ContactTriggerHandler2.displayConLastNameinAcc(Trigger.new,Trigger.oldmap,null);
             //ContactTriggerHandler2.updatecontoAccPhone(trigger.new, trigger.oldmap);
        }
    }
    
    
        
    
    
    if(Trigger.isAfter && Trigger.IsInsert){
       // ContactTriggerHandler.whenCONisCreatedAutoInsertACC(Trigger.new);
         ContactTriggerHandler.UpdateReleatedCONdescription(Trigger.New, trigger.oldmap);
         ContactTriggerHandler.CONcountinAcc(Trigger.new, trigger.old);
    }

    
    if(Trigger.IsBefore && Trigger.IsInsert){
        ContactTriggerHandler.checkemailPHlastname(Trigger.New);
       // ContactTriggerHandler.donotCreateCONwhenThereisNoParent(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
      //  ContactTriggerHandler.UpdateReleatedCONdescription(Trigger.New,trigger.oldmap);
       ContactTriggerHandler.PickListINaccDescription(Trigger.new,Trigger.oldmap); 
        if(ContactTriggerHandler.isFlag){
        ContactTriggerHandler.isFlag = false;
        ContactTriggerHandler.UpdateParentAccountOnContactChange(Trigger.new, trigger.oldmap);
        ContactTriggerHandler.ConNameWithCommaSepratedInACC(Trigger.new, trigger.oldmap);
    }
      if(Trigger.isAfter && Trigger.IsDelete){
         ContactTriggerHandler.CONcountinAcc(Trigger.new, trigger.old);
    } 
     if(Trigger.isAfter && Trigger.IsUnDelete){
         ContactTriggerHandler.CONcountinAcc(Trigger.new, trigger.old);
    } 
        
        
    }*/



}