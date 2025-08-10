public class ContactTriggerHandler {
    //count contact in account field;
    public static void CONcountinAcc(list<contact> newRec,list<contact> oldRec){
        set<id> Accidset = new set<id>();
        if(newRec != null){
            for(contact con: newRec){
            if(con.AccountId != NULL){
                system.debug('Trigger Entered in newRec :' + newRec );
                Accidset.add(con.AccountId);
            }
            }
        }
        else if (oldRec != null){
             for(contact con: oldRec){
                 if(con.AccountId != NULL){
                system.debug('Trigger Entered in oldRec :' + oldRec );
                Accidset.add(con.AccountId);
           }                
            }
        }
        list<account> updateacclist = new list<account>();
        system.debug('print updateacclist :' + updateacclist );
        map<id,AggregateResult> mapAccidvsAcc = new map<id,AggregateResult>();
       
        for(AggregateResult  AR : [select AccountId, count(id) cntid from contact where accountid IN: Accidset group by AccountID]){
               system.debug('print AR :' + AR );
               id accid = (id)AR.get('AccountId');          
               mapAccidvsAcc.put(accid,AR);                         
        }
        
        for(id AccountId : Accidset){
         Account acc = new account(id = accountId );
         acc.contactCount__c =  mapAccidvsAcc.containsKey(AccountId) ? (integer)mapAccidvsAcc.get(AccountId).get('cntid') : 0 ; 
         updateacclist.add(acc);   
        }
       
        
        if(!updateacclist.isEmpty()){
         Update updateacclist;
        }
        
    }
    
    //Populate all contact names in account field with comma seprated => display in account (AllContactNames__C)
    public static void ConNameWithCommaSepratedInACC(List<contact> newRec, map<id,Contact> oldMaps){
       string updateNames;
       //list<string> oldnames;
        Map<id,contact> MapAccidVScon = new Map<id,contact>();
        for(contact con : newRec){
            if(con.LastName != oldMaps.get(con.Id).LastName){
                MapAccidVScon.put(con.AccountId,con);
           }    
        }
        map<id,account> mapTOupdate = new map<id,account>();
        system.debug('print mapTOupdate :' + mapTOupdate);
        
        map<id,account> updateAccMap = new map<id,account>([select id, AllContactNames__c , (select id,LastName, AccountId from Contacts) From account where ID IN : MapAccidVScon.keyset()]);  
        for(account acc : updateAccMap.values()){
            for(contact con : acc.Contacts){
                if(con.LastName != null){
                    updateNames = updateNames + ' , ' + con.LastName;
                    system.debug('print updateNames :' + updateNames);
                    acc.AllContactNames__c = updateNames;
                     mapTOupdate.put(acc.id,acc); 

                }
            }
        }
        set<id> Removekeyset = new set<id>();
        for(id Key : mapTOupdate.keySet()){
            if(mapTOupdate.get(key) == null){
                Removekeyset.add(key);
            }
        }
        
       
 

// Remove the keys with null values
for (Id key : Removekeyset) {
    mapTOupdate.remove(key);
}
  
        if(!mapTOupdate.IsEmpty()){
            update mapTOupdate.values();
            system.debug('print mapTOupdate.valuse :' + mapTOupdate.values());
            system.debug('print mapTOupdate.Keysets :' + mapTOupdate.keySet());
            
        }
       
    }
    
    
    
   
    //when module__c picklist is update then => display in account description
    public static void PickListINaccDescription(list<contact> newRec, map<id,contact> oldmaps){
        map<id,contact> mapACCidVScon = new map<id,contact>();
        for(contact con: newRec){
            if(con.Modules__c != null && con.Modules__c != oldmaps.get(con.id).Modules__c){      
                mapACCidVScon.put(con.AccountId,con);
            }
        }
        
        map<Id,account> removeDublicateWithMap = new map<Id,account>();
        string modal;
        
        list<contact> conlist = [select id,accountId, Modules__c from contact where accountId IN: mapACCidVScon.keyset()];
        system.debug('print acclist :' + conlist);
            for(contact con : conlist){
                for(account acc : [select id, Description from account where ID IN : mapACCidVScon.keyset()]){
                    if(acc.id == con.AccountId && con.Modules__c != null){
                         modal += ';' + con.Modules__c;
                        acc.Description = + modal ;
                       removeDublicateWithMap.put(acc.id,acc); 
                   }
                }
                         
        }
        if(!removeDublicateWithMap.isEmpty()){
            update removeDublicateWithMap.values();
        }
        
    }
    
    //when child contact accountid is updated autoupdate the releated contac accountId
    public static boolean isFlag = True;
    public static void UpdateParentAccountOnContactChange(list<contact> newRec, map<id,contact> oldmaps){
        
      map<id,id> mapIDvsAccID = new map<id,id>();
        for(contact con: newRec){
            if(con.AccountId != oldmaps.get(con.id).AccountId){
             contact oldcon = oldmaps.get(con.id);
             
             mapIDvsAccID.put(oldcon.AccountId,con.accountId);  
                
            }
        }
   
        list<contact> updatecon = new list<contact>();
        system.debug('print updatecon :' + updatecon);
        list<contact> updateConList = [select id, AccountId from contact where AccountId IN :mapIDvsAccID.keyset()];        
        system.debug('print updateConList : ' + updateConList );
          for(contact con : updateConList){
             con.AccountId = mapIDvsAccID.get(con.AccountId);
               updatecon.add(con);
            }
   
        system.debug('print updatecon : ' + updatecon);
        if(!updatecon.isEmpty()){
            update updatecon;
        }       
    }
    
    
      public static void whenCONisCreatedAutoInsertACC(list<contact> newRec){
          list<account> addinlist = new list<account>();
          for(contact con: newRec){
              Account Acc = new Account();
              Acc.name = Con.LastName;
              addinlist.add(acc);
          }
         
          if(!addinlist.isEmpty())
          {
              insert addinlist;
          }
      }
    public static void donotCreateCONwhenThereisNoParent(list<contact> newRec){
        for(contact con :newRec){
            if(con.AccountId == Null){
                con.AccountId.AddError('Account Information is Mandatary');
            }
        }
    }
    public static void checkemailPHlastname(list<contact> newRec){
        list<contact> existingRec = [select id,LastName,Phone,Email from contact];
        for(contact con : newRec){
            for(contact cc: existingRec){
                if(con.Phone == cc.Phone && con.Email == cc.Email && con.LastName == cc.LastName){
                con.AddError('Dublicate Record Found');
            }  
            }
              
            
        }
    }
    
    Public static void UpdateReleatedCONdescription(list<contact> newRec , map<id,contact> oldmaps ){
        list<contact> updateconlist = new list<contact>();
        map<id,string> conmap = new map<id,string>();
        list<contact> conlist = [SELECT id, Contact__c,Description from contact WHERE Contact__c IN : conmap.keyset()];
        system.debug('get conlist: ' + conlist );
        
        for(contact con : newRec){
            system.debug('data entered in 1st for loop'  );
            if(con.Description != null){
                 if(con.Description  != oldmaps.get(con.id).Description ){
                conmap.put(con.id, con.Description);
            }
           
                
              }
            
            for(contact con1 : conlist ){
                 system.debug('data entered in 2nd for loop'  );
                    Con.Description = con1.Description;
                    updateconlist.add(con1);
                }
                
                if(!updateconlist.isEmpty()){
                    update updateconlist;
                }
            
            }

    }
}
/*
       trigger UpdateParentAccountOnContactChange on Contact (before update) {
    // Create a map to store the AccountId to Contact mapping
    Map<Id, Contact> contactsToUpdate = new Map<Id, Contact>();

    // Loop through all contacts being updated
    for (Contact con : Trigger.new) {
        // Get the old version of the contact
        Contact oldCon = Trigger.oldMap.get(con.Id);

        // Check if the AccountId has changed
        if (con.AccountId != oldCon.AccountId) {
            contactsToUpdate.put(con.Id, con);
        }
    }

    if (!contactsToUpdate.isEmpty()) {
        // Get the new account IDs for the contacts that have changed
        Set<Id> newAccountIds = new Set<Id>();
        for (Contact con : contactsToUpdate.values()) {
            if (con.AccountId != null) {
                newAccountIds.add(con.AccountId);
            }
        }

        // Query the new accounts to update parent accounts
        Map<Id, Account> accountMap = new Map<Id, Account>([
            SELECT Id, ParentId
            FROM Account
            WHERE Id IN :newAccountIds
        ]);

        // Update the related contact's parent account (if applicable)
        for (Contact con : contactsToUpdate.values()) {
            if (con.AccountId != null && accountMap.containsKey(con.AccountId)) {
                con.Parent_Account__c = accountMap.get(con.AccountId).ParentId;
            } else {
                // If the new account doesn't have a parent, clear the field
                con.Parent_Account__c = null;
            }
        }
    }
}

*/