public class OppLineItemHandlerTrigger {
    
    public static void showsumOfTotalPrice(list<OpportunityLineItem> newRec,map<id,OpportunityLineItem> oldMaps ,list<OpportunityLineItem> oldRec){
        
        set<id> setofoppi = new set<id>();
        
        if(newRec != null){
            for(OpportunityLineItem oppi : newRec){
                if(oppi.TotalPrice != null){
                    setofoppi.add(oppi.OpportunityId);
                } }
        }else if(oldRec != null){
          for(OpportunityLineItem oppi : oldRec){
                if(oppi.TotalPrice != null){
                    setofoppi.add(oppi.OpportunityId);
                } }
        }else if(oldMaps != null){
            for(OpportunityLineItem oppi : newRec){
                if(oppi.TotalPrice !=  oldMaps.get(oppi.id).TotalPrice){
                    setofoppi.add(oppi.OpportunityId);
                } }            
        }
    
    
    list<opportunity> updatelistopp = new list<opportunity>();
    map<id,AggregateResult> mapidvsAR = new map<id,AggregateResult>();
    
   for(AggregateResult AR : [select opportunityId, sum(TotalPrice) sumTP from OpportunityLineItem where OpportunityId IN : setofoppi Group By opportunityId]){
         id oppid = (id)AR.get('opportunityId');
         mapidvsAR.put(oppid ,AR);
    }
    
    for(id opportunityId : setofoppi){
       opportunity opp = new opportunity(id = opportunityId);
       opp.sumofOppLineItem__c = mapidvsAR.containsKey(OpportunityId) ? (decimal)mapidvsAR.get(OpportunityId).get('sumTP') : 0;
      updatelistopp.add(opp); 
    }
   
    if(!updatelistopp.isEmpty()){
        update updatelistopp;
    }  
    
  }
}