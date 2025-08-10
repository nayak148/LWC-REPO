trigger OppLineItemTrigger on OpportunityLineItem (After insert, After Update, After delete , After undelete) {
    
    if(Trigger.IsAfter){
        if(Trigger.isInsert || Trigger.isUpdate || trigger.isDelete || trigger.isundelete){
             OppLineItemHandlerTrigger.showsumOfTotalPrice(Trigger.New, Trigger.oldMap, Trigger.old);
        }
            
        
        
    }

}