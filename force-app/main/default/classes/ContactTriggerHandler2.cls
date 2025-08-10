public class ContactTriggerHandler2 {
    //before inserting or updateing the contact check phone and email alredy present
    public static void checkPhoneEmailAlreadyPresent(list<contact> newRec, map<id, contact> oldMaps){
        
       map<id,contact> mapconIdvscon = new map<id, contact>();
        system.debug(' Trigger entered in new map : ' + mapconIdvscon );
       map<id,contact> mapconIdvsconold = new map<id, contact>();
        system.debug(' Trigger entered in old map : ' + mapconIdvsconold );
        if(newRec != null){
            for(contact con : newRec){
                if(con.Phone != null || con.Email != null || con.Phone != null && con.Email != null){
                    system.debug(' Trigger entered in first loop : ' );
                   mapconIdvscon.put(con.id,con); 
                }
            }  
            
        }
        if(oldMaps != null){
             for(contact con : newRec){
                if(con.Phone != oldMaps.get(con.id).Phone || con.Email != oldMaps.get(con.id).Email){
                    system.debug(' Trigger entered in 2nd loop : ' );
                    mapconIdvsconold.put(con.id,con); 
                }
            }
        }
        //compare before insert
        list<contact> oldconlist = [select id,Phone,Email from contact where Id IN :mapconIdvscon.keyset()];
        
        for(contact con : oldconlist){
            for(contact con1 : mapconIdvscon.values()){
                if(con.Phone == con1.Phone && con.Email == con1.Email){
                    system.debug(' Trigger entered in insert error  : ');
                    con.addError('This Contact is Already Exits');
                    
                }
            }
        }
        
        map<id, contact> oldMap = new map<id, contact>([select id, phone, email from contact where ID IN:mapconIdvsconold.keyset()]);  
        
        for(contact con : oldMap.values()){
            for(contact con1 :mapconIdvscon.values()){
                if(con.Phone == con1.Phone && con.Email == con1.Email){
                     system.debug(' Trigger entered in update error  : ');
                    con.addError('This Phone and Email is Already Exits');
                }
            }
        }
        
    }
    
    
   // when account is updated in contact auto update related contact
    public static void autoupdateAccinCon(list<contact> newRec, map<id,contact> oldMaps){
        
        map<id,id> mapAccidvsCon = new map<id,id>();
        for(contact con : newRec){
            if(con.AccountID != oldMaps.get(con.id).AccountId){
                id oldcon = oldMaps.get(con.id).AccountId;
                mapAccidvsCon.put(oldcon,con.AccountId);
            }
        }
        list<contact> updateconlist = new list<contact>();
        map<id,contact> ConMap = new map<id,contact>([select id,AccountId from contact where AccountId IN: mapAccidvsCon.keyset()]);
        
        for(contact con : ConMap.values()){
            con.AccountId = mapAccidvsCon.get(con.AccountId);
            updateconlist.add(con);
        }
        if(!updateconlist.IsEmpty()){
           update updateconlist;  
        }
       
        
    }
    

    // Display all contact Last Name in Account AllContactNames__c  fields
    public static void displayConLastNameinAcc(List<contact> newRec, map<id,contact> oldMaps, List<contact> oldRec){
        set<id> setofAcc = new set<id>();
        system.debug('setofAcc : ' + setofAcc);
        if(newRec != null){
           for(contact con: newRec){
            if(con.AccountId != null){
               setofAcc.add(con.accountId); 
            }   
        }  
        }else if(oldRec != null){
           for(contact con: oldRec){
               setofAcc.add(con.accountId);    
        }
        }else if(oldMaps != null){
              for(contact con: newRec){
                  if(con.accountId !=null){
                 if(con.LastName != oldMaps.get(con.id).LastName){
               setofAcc.add(con.accountId); 
            }            
                  }

        }
        }
        list<string> AllLastName = new list<string>();
            map<id,Account> updateAccmap = new map<id,Account>();
            system.debug('updateAccmap :' + updateAccmap);
            map<id, Account> MapAcc = new map<id, Account>([select id, AllContactNames__c,(select id,AccountId,LastName from contacts) from Account where id In :setofAcc]);   
               system.debug('MapAcc :' + MapAcc);
            for(Account Acc: MapAcc.values()){
                for(contact con : Acc.contacts ){
                    if(con.lastName != null && !con.LastName.equalsIgnoreCase('null') && con.LastName.trim().length() > 0){
                         
                        AllLastName.add(Acc.AllContactNames__c);
                    }         
                }
                acc.AllContactNames__c = String.join(AllLastName, ' ; ' );
                updateAccmap.put(Acc.id,Acc);
            }
            if(!updateAccmap.IsEmpty()){
                update updateAccmap.values();
            }
    }
    //when con phone is update automatic update acc phone
    public static void updatecontoAccPhone(list<contact> newRec, map<id,contact> oldMaps){
   
        map<id,string> mapAccIDvsNEW = new map<id,string>();
        for(contact con : newRec){
            if(con.Phone != oldMaps.get(con.id).Phone && con.AccountId != null){
                mapAccIDvsNEW.put(con.AccountId, con.Phone);
            }
            
        }
        map<id,Account> updateAccMap = new map<id,Account>();
        map<id,contact> updateConMap= new map<id,contact>();
        map<id,account> Accmap = new map<id,account>([select id,phone,(select id, accountid , phone from contacts) from Account where id IN : mapAccIDvsNEW.keyset() ]);
        for(Account Acc : Accmap.values()){
            for(contact con : Acc.contacts){
                if(Acc.id == con.AccountId){
                  con.Phone = con.Phone;
                   updateConMap.put(con.id,con);
                }  
                 Acc.phone = con.phone ;
                updateAccMap.put(acc.id,Acc); 
            }
        }
        
        if(!updateAccMap.IsEmpty()){
            update updateAccMap.values();
        }
        if(!updateConMap.IsEmpty()){
            update updateConMap.values();
        }
    }
}