public class AccountTriggerHandler2 {
    // When We update the Creat_N_Contacts__c fields in account automatic create or delete the contact
    public static boolean firstRun = true;
    public static void createNconinAcc(list<account> newRec, List<Account> oldRec, Map<id, Account> oldMaps){
          
       integer OldValue ;
       integer NewValue;
       
        map<id, Integer> mapaccIdvsInteger = new map<id, Integer>();
        
       list<contact> insertConList = new list<contact>();
       list<contact> deleteConList = new list<contact>();
       system.debug('print Insert: ' + insertConList);
        system.debug('print delete: ' + deleteConList);
        
        if(newRec!=null){
          for(account acc : newRec){
            if(acc.Creat_N_Contacts__c != null){
                system.debug('print Creat_N_Contacts__c newRec: ' + acc.Creat_N_Contacts__c);
                for(integer i=0 ; i < acc.Creat_N_Contacts__c ; i++){
                    contact con = new contact();
                    con.AccountId = acc.id;
                    con.LastName = 'new insert' + i ;
                    insertConList.add(con);
                }
                //mapaccIdvsInteger.put(acc.id,acc.Creat_N_Contacts__c.intValue());
            }            
        }
        }else if(oldMaps!= null){
            for(account acc : newRec){
            if(acc.Creat_N_Contacts__c != oldMaps.get(acc.id).Creat_N_Contacts__c){
                system.debug('print Creat_N_Contacts__c oldmaps: ' + acc.Creat_N_Contacts__c);
                mapaccIdvsInteger.put(acc.id,acc.Creat_N_Contacts__c.intValue());
            } 
            }
        }else if(oldRec != null){
             for(account acc : oldRec){
            if(acc.Creat_N_Contacts__c != null){  
                system.debug('print Creat_N_Contacts__c oldRec: ' + acc.Creat_N_Contacts__c);
                mapaccIdvsInteger.put(acc.id,acc.Creat_N_Contacts__c.intValue());
            }            
        }
        }
   
              
       
       //map<id,Account> mapold = map<id, Account>([select id, Creat_N_Contacts_c from Account where id IN : AccIDset]); 
        map<id,AggregateResult> mapAccIdvsAR = new map<id,AggregateResult>();
            for(AggregateResult AR : [select Accountid , count(id) cntId from contact where AccountID IN :mapaccIdvsInteger.keyset() Group By AccountId]){   
              mapAccIdvsAR.put((id)AR.get('AccountId'),AR);
            }
          
            // 5-3 = 2 delete   ,  3 - 6 = -3  insert
            
            for(id AccountId : mapaccIdvsInteger.keyset()){
                OldValue = mapAccIdvsAR.containskey(AccountId) ? (integer)mapAccIdvsAR.get(AccountId).get('cntId') : 0;
                NewValue = (integer)mapaccIdvsInteger.get('AccountId');
                
                if(OldValue < NewValue){
                    for(integer i=0 ; i < (NewValue - OldValue); i++ ){
                        contact con = new contact(id = accountId);
                        con.lastName = 'auto Gen' + i ;
                        insertConList.add(con);
                    }
       
                 }else if(OldValue > NewValue){
                         list<contact> deleteCon = [select id from contact where AccountID IN : mapaccIdvsInteger.keyset() LIMIT : (OldValue - NewValue) ];
                     deleteConList.addall(deleteCon);
                 }                
            }
         if(!insertConList.IsEmpty()){
            Insert insertConList;
        }  
        
        if(!deleteConList.IsEmpty()){
            delete deleteConList;
        }      
            
        
            
    }
}