public class ContactTriggerHandlerPractice {
    // when Account is chenged for contact then automatic change related contact;
    Public Static void AutoupdateRelateConAccId(list<contact> newRec , Map<id, contact> oldMaps){
        map<id,id> mapOldAccIdVSNewAccID = new map<id,id>();
        for(contact con: newRec){
            if(con.AccountId != null){
                if(con.AccountId != oldMaps.get(con.id).AccountId){
                    mapOldAccIdVSNewAccID.put(oldMaps.get(con.id).AccountId,con.AccountID);
                }
            }
            
            list<contact> Conlist =[select id,AccountId from contact where AccountId IN : mapOldAccIdVSNewAccID.keyset() ];
            list<contact>  UpdateConList   = new list<contact>();
            
            for(contact con1 : Conlist){
                Con1.AccountId = mapOldAccIdVSNewAccID.get(con.AccountId);
                UpdateConList.add(con1);
            }
            
            if(!UpdateConList.isEmpty()){
                Update UpdateConList;
            }
        }
    }
        
    
    
    
    
    
    // //Populate all contact  LastNames in account field with comma separated => display in account (AllContactNames__C) 
    Public static void polulateLastNameOFcontoAccount(list<contact> newRec, map<id,contact> oldMaps){
        String AllLastName = '' ;
        set<id> setofAccID  = new set<id>();
        for(contact con : newRec){
            if(con.AccountId != null){
                if(con.LastName != null || con.LastName != oldMaps.get(con.Id).lastName){
                    setofAccID.add(con.AccountId);
                }
            }
        }
        
        list<contact> conList =[select Id, LastName from contact where AccountId IN : setofAccID];
       map<id,Account> mapAccIDvsAcc = new map<id, Account>();
        
        for(id AccountId : setofAccID){
            for(contact con : conList ){
                Account Acc = New Account(id = AccountId);
                AllLastName += con.LastName + ', ';
                 Acc.AllContactNames__c = AllLastName ; 
                mapAccIDvsAcc.put(Acc.id,Acc);
            }
            
        }
        if(!mapAccIDvsAcc.values().isEmpty()){
            Update mapAccIDvsAcc.values();
        }
    } 
    
      //show sum of Amount__c from contact to  Account
    public static void sumofconAmounttoAcc(list<contact> newRec , map<id,contact> oldMaps){
        decimal AmountSUM;
        set<id> setofAccId = new set<id>();
        for(contact con : newRec){
            if(con.AccountId != null){
                if(con.Amount__c != oldMaps.get(con.id).Amount__c){
                    setofAccId.add(con.AccountId);
                }
            }    
        }
       
        map<id,decimal> mapAccidvsAR = new map<id,decimal>();
        
        for(AggregateResult AR : [select AccountId, Sum(Amount__c) sumamt from contact where AccountID  IN : setofAccId  group by AccountId]){
          AmountSUM = (Decimal)AR.get('sumamt');
          mapAccidvsAR.put((id)AR.get('AccountId'),AmountSUM);    
       }
        map<id,Account> AcclisttoUpdate = new map<id,Account>();
        
        for(id AccountID : setofAccId){
            Account Acc = new Account();
            Acc.Id = AccountID;
            Acc.SumOFconAmount__c =  (decimal)mapAccidvsAR.get(AccountId);
            AcclisttoUpdate.put(Acc.Id,Acc);
        }
        
        if(!AcclisttoUpdate.IsEmpty()){
            update AcclisttoUpdate.values();

        }
    }
     //before inserting or updateing the contact check phone and email alredy present
    public static void CheckPhoneEmailAlreadyExit(list<contact> newRec , map<id,contact> oldMaps){
        set<id> SetofconID = new set<id>();
        for(contact con : newRec){
            if(con.phone != null || con.Email != null ||
               con.Phone != oldMaps.get(con.id).Phone || con.Email != oldMaps.get(con.id).Email){
                SetofconID.add(con.Id);
            }
        }
        
        list<contact> conAccList =[select id,Phone,Email,Account.Name from contact where ID IN : SetofconID];
        list<contact> conTotalList =[select id,Phone,Email from contact];
        for(contact con2 : conTotalList){
            for(contact con : newRec){
                for(contact AccCon :conAccList){
                if(con.phone == con2.phone){
                    con.Phone.addError('Phone :' + con.phone + 'Is Alread exits with Account : ' + AccCon.Account.Name +'So! please use new Phone Number');
                }else if(con.Email == con2.Email){
                    con.Email.addError('Email :' + con.Email + 'Is Alread exits with Account : ' + AccCon.Account.Name +' So! please use new Email');
                } 
            }
            }
            
        }
    }
    
    
    // if contact phone is changed then autochange Acc phone
    public static void ConPhoneChangeAutoUpdateAccPh(list<contact> newRec , map<id,contact> oldMaps){
        set<id> Accidinset = new set<id>();
        for(contact con : newRec){
            if(con.AccountId != null && (con.Phone != oldMaps.get(con.id).Phone || con.Phone != null )){
                Accidinset.add(con.AccountId);
            }
        }
        
        list<Account> AccList =[select id, phone from Account where Id IN : Accidinset];
        list<Account> AccListtoUpdate = new list<Account>();
        for(Account Acc : AccList){
            for(contact con :newRec){
                if(con.AccountId == Acc.id){
               Acc.Phone = con.Phone; 
               AccListtoUpdate.add(Acc);     
                }
            }  
        }
       
        if(!AccListtoUpdate.isEmpty()){
            update AccListtoUpdate;
        }
        
    }

}