public class AccountTriggerHandler {
    
    
   
   
    //when account billing address is updated autoupdate related contact billing addreess(use only map)

    Public static void AutoUpdateAddresFROMacctoCon(Map<id,account> newmaps , map<id,account> oldMaps){
        //set<id> accidset = new set<id>();
        map<id,account> mapidvsaccount = new map<id,account>();
        for(account acc: newmaps.values()){
                if(acc.BillingStreet != oldMaps.get(acc.id).BillingStreet ||acc.BillingCity != oldMaps.get(acc.id).BillingCity
                   || acc.BillingCountry != oldMaps.get(acc.id).BillingCountry || acc.BillingState != oldMaps.get(acc.id).BillingState
                    ||acc.BillingPostalCode !=oldMaps.get(acc.id).BillingPostalCode){
                  //  accidset.add(acc.id);
                    mapidvsaccount.put(acc.id, acc);
                }
            
        }
        map<id,contact> conmap = new map<id,contact>([SELECT id,AccountId,MailingAddress from contact WHERE accountId IN: mapidvsaccount.keyset()]);
        system.debug('conMap : ' +conmap);
        map<id,contact> updateMap = new map<id,contact>();
        
        for(account acc : mapidvsaccount.values()){
            for(contact con :conmap.values()){
            if(con.AccountId == acc.id){
             //con.MailingAddress = acc.BillingAddress;
             con.MailingCity = acc.BillingCity;
             con.MailingCountry = acc.BillingCountry;
             con.MailingPostalCode= acc.BillingPostalCode;
             con.MailingState = acc.BillingState;
             con.MailingStreet = acc.BillingStreet;
             updateMap.put(con.id,con);
            
            }
        }                      
        }
        if(updateMap.size()>0){
            update updateMap.values();
        }   
        
        
    }
    
    // When We update the Creat_N_Contacts__c fields in account automatic create or delete the contact
    public static void createNconinAcc(){
        
    }
    
    
    public static void createNconinAcc(list<account> newRec , map<id, account> oldmaps){
        map<id,Integer> mapAccIDvsNewCON = new map<id,Integer>();
        system.debug('print conEnteredMap-newValue : ' + mapAccIDvsNewCON);
        
        set<id> Accids = new set<id>();
        List<contact> insertconlist = new list<contact>();
        system.debug('print insertconlist : ' + insertconlist);
        list<contact> deleteconlist = new list<contact>();
        system.debug('print deleteconlist : ' + deleteconlist);
        for(account acc: newRec){
            if( acc.Creat_N_Contacts__c != null){
                    if(acc.Creat_N_Contacts__c != oldmaps.get(acc.id).Creat_N_Contacts__c  ){ //acc.Creat_N_Contacts__c > 0 || acc.Creat_N_Contacts__c == null
                Accids.add(acc.id);
                mapAccIDvsNewCON.put(acc.id, acc.Creat_N_Contacts__c.intValue());
            
                
            }
            }
             
           
        }
       map<id,Integer> mapAccidvsOLDCON = new map<id,Integer>(); 
        system.debug('print conEnteredMapthroughAggregateResult : ' + mapAccidvsOLDCON);
        for(AggregateResult AR :[select accountId, count(id) countID from contact where accountid IN :Accids GROUP BY accountId]){
            //id ant = (id)AR.get('accountId');
            //integer cont = (integer)AR.get('countID');
            mapAccidvsOLDCON.put((id)AR.get('accountId'),(integer)AR.get('countID'));
        }
        
        for(id accountId : Accids){
           integer newcon  = mapAccIDvsNewCON.get(accountId);
           integer oldcon = mapAccidvsOLDCON.containsKey(accountId) ? mapAccidvsOLDCON.get(accountId) :0 ;
           system.debug('print newcon :' +newcon);
           system.debug('print oldcon :' +oldcon);
            if(oldcon < newcon){
                // 3-7 =-4
              for(Integer i=0; i < (newcon-oldcon); i++){  
                  contact con = new contact();
                      con.AccountId = accountId;
                      con.LastName = 'auto Genertated contact' + i ;
                      insertconlist.add(con);
                  
              }
              } else if(oldcon > newcon){
                  list<contact> delconlist = [select id from contact where AccountId =: AccountId AND Id NOT IN (SELECT ContactId FROM Case WHERE ContactId != NULL) LIMIT :(oldcon-newcon)];
                  
                  system.debug('print deletlist : ' + delconlist);
                 deleteconlist.addall(delconlist); 
              }  
            }
        if(insertconlist.size()>0){
            database.insert(insertconlist, false);
        }
        if(!deleteconlist.isEmpty()){
            delete deleteconlist;
        }
        
            
        }
        
    
    
    
    
    public static void ACCtoCONupdatePhone(list<account> newRec, map<id,account> oldmaps){
        
        list<contact> updateconinlist = new list<contact>();
        set<id> accidinlist = new set<id>();
        for(account acc: newRec){
            if(acc.Phone!= oldmaps.get(acc.id).Phone){
                accidinlist.add(acc.id);
            }  
        }
        list<contact> conlist =[SELECT id ,Phone , accountid FROM contact WHERE AccountId IN : accidinlist];
        for(contact con : conlist){
            for(account acc : newRec){
                con.Phone = acc.Phone;
                updateconinlist.add(con); 
            }
               
        }
        if(!updateconinlist.isEmpty()){
            update updateconinlist;
        }
        
        
    }
    
    public static void updatebillingcity(List<account> newrec){
            for(account acc: newrec){
            acc.BillingCity ='hyderabad';
            acc.BillingState ='Telangana';
            
       }
       
     }
    
    //=========
   
    public static void whenAccIScreatedAutoInsertCON(list<account> newRec){
        List<contact> insertnewcon = new List<contact>();
        
        for(account acc : newRec){
            
            contact con = new contact();
            con.LastName = acc.Name;
            con.AccountId = acc.id;
            insertnewcon.add(con);               
        }
        if(!insertnewcon.isEmpty()){
            insert insertnewcon;
        }
    }
    //=========
    public static void donotallowUSERtoSETownership(list<account> newRec, map<id,account> oldmap){
        for(account acc : newRec){
            if(acc.Industry == 'Agriculture' && acc.Type == 'Prospect'){
                if(acc.Ownership == 'Private' && acc.Ownership != oldmap.get(acc.id).Ownership){
                    acc.Ownership.AddError('You cannot modifyt the ownership');
                }
            }
        }
    }
    //=========
    public static void autoUPDATEvconWEBSITEandPHONE(list<account> newRec, map<id,account> oldmap){
        
        //list<id> addinlist = new list<id>();
        map<id,string>  addinMap = new map<id,string> ();
        for(account acc : newRec){
            
            if(acc.Website != oldmap.get(acc.id).Website || acc.Phone != oldmap.get(acc.id).Phone || acc.Website == null || acc.Phone == null){
                // addinlist.add(acc.id);
                addinMap.put(acc.id, acc.Phone);
                addinMap.put(acc.id, acc.Website);
                
                
            }
            
            list<contact> addinlistToupdatephone = new list<contact>();
            list<contact> conlist = [Select id,phone,website__c from contact where AccountId IN : addinMap.keyset()]; 
            for(contact con :conlist){
                con.Phone = acc.Phone;
                con.website__c = acc.Website;
                addinlistToupdatephone.add(con);
                
            }
            if(!addinlistToupdatephone.isEmpty()){
                update addinlistToupdatephone;
            }
            
        }
    }
    //==========
    public static void createNcontactsAccount(list<account> newRec){
        
        list<contact> addinlist = new list<contact>();
        
        for(account acc : newRec){
            
                if(acc.Creat_N_Contacts__c != null){
                for(integer i=0; i < acc.Creat_N_Contacts__c; i++){
                    contact con = new contact();
                    con.LastName = acc.Name + i;
                    con.AccountId = acc.id;
                    addinlist.add(con);
                } 
            }
            
           
            
            
            
        }
        if(!addinlist.isEmpty()){
            Insert addinlist;   
        }
        
        
  } 
   //========
    public static void creationNLocation(List<Account> newRec, map<id,Account> oldmaps ){
        integer DeleteOLDdata  = 0;
        integer insertnewdata = 0;
        
       map<id,Location__c> listToDelete;
        list<Location__c> addLocationinListToINSERT = new list<Location__c>();
        if(oldmaps !=null){
          listToDelete = new map<id, Location__c>([select id, Account__c,account__r.id from location__c where account__c IN:oldmaps.keyset()]);
            
        system.debug('get current acc keyset :' + oldmaps.keyset() + ' acc id :' + account.id );
        system.debug('get location list :' + listToDelete );
        }
        
        list<Location__c> DeleteLocationList = new list<Location__c>();
        
        for(Account acc : newRec ){
               if(trigger.isInsert){ 
                 system.debug('Data Entered at Trigger.isInsert');  
                //when account is created &  Number_of_Locations__c field data is given ?
                //==> result (Create Locations__c object based on given data in Number_of_Locations__c)
                if(acc.Number_of_Locations__c != Null ||acc.Number_of_Locations__c > 0 ){
                    for(integer i = 0; i < acc.Number_of_Locations__c ; i++){
                        Location__c insertLocation = new Location__c();
                        insertLocation.Name = 'Location' + i;
                        insertLocation.Account__c = acc.id;
                        addLocationinListToINSERT.add(insertLocation);
                    }
                }
            } 
            Else if(Trigger.isUpdate){
                system.debug('Data Entered at Trigger.isUpdate'); 
                if(oldmaps.get(acc.id).Number_of_Locations__c != acc.Number_of_Locations__c || oldmaps.get(acc.id).Number_of_Locations__c == null){
                    system.debug('Data Entered at Trigger.isUpdate at != condition'); 
                    if(oldmaps.get(acc.id).Number_of_Locations__c < acc.Number_of_Locations__c ){
                        //  old<new ==> 3<5 = +2 ==>3+2 = 5 result (add 2 new data)
                        system.debug('Data Entered at Trigger.isupdate in condition ===> old < new entered' ); 
                        insertnewdata = (integer)(acc.Number_of_Locations__c - oldmaps.get(acc.id).Number_of_Locations__c);
                          system.debug('number of data to insert : ' + insertnewdata );
                        for(integer i=0 ; i < insertnewdata; i++){
                            Location__c insertupdatedLocation = new Location__c();
                            insertupdatedLocation.Name = 'Location' + i;
                            insertupdatedLocation.Account__c = acc.id;
                            system.debug('Data Entered at Trigger.isUpdate to create the list bucket'); 
                            addLocationinListToINSERT.add(insertupdatedLocation); 
                            system.debug('Data Entered at Trigger.isupdate in condition ===> old < new at for loop ==> exid' ); 
                        }} 
                    
                    else if(oldmaps.get(acc.id).Number_of_Locations__c > acc.Number_of_Locations__c){
                        // delete remaining data , old>new , 5-3 = 2 (delete 2 old data), 
                        // to delete we need ids 
                        system.debug('Data Entered at Trigger.isupdate in condition ===> new < old entered' );
                        DeleteOLDdata = (integer)(oldmaps.get(acc.id).Number_of_Locations__c - acc.Number_of_Locations__c);
                       
                        system.debug('number of locations__c to delete :' + DeleteOLDdata);
                        
                        for(Location__c ExitRec :listToDelete.values()){
                            if(ExitRec.Account__c == acc.id){
                                system.debug('Data Entered at Trigger.isupdate in condition ===> id match to delete' + listToDelete.values() );
                                
                              if(listToDelete.size()< DeleteOLDdata){  
                              
                                  system.debug('listToDelete.size :'+ listToDelete.size());
                                    DeleteLocationList.add(ExitRec);
                                     system.debug('Data Entered at Trigger.isupdate in condition ===> id match to delete at exit' ); 
                               }
                        }}}
                }
            }
            
        }     
        
        
        if(!DeleteLocationList.isEmpty()){
            system.debug('data entered in DELETE DML :' + DeleteLocationList);
            Delete DeleteLocationList;
        }	
        
        if(!addLocationinListToINSERT.isEmpty()){
            system.debug('data entered in insert DML : ' + addLocationinListToINSERT);
            insert addLocationinListToINSERT;
            
        }                
        
    }
 }

        /*public static void exampleNLocation(List<account> newrec, Map<id,account> oldmaps){
            // map<id, Decimal> PutAccinMAP = new map<id, Decimal>();
            // set<id> addaccinSet = new set<id>();
            list<Location__c> LocationTOList = new list<Location__c>();
            list<Location__c>  LocationTOListDELETE = new list<Location__c>(); 
            list<Location__c>  LocationTOListUPDATE = new list<Location__c>(); 
            Map<id, Location__c > ExistingRecordSOQL = Map<id, Location__c>([SELECT id, Account.id from Location__c WHERE ID IN:oldmaps.keyset()]);
            for(account acc : newrec){
                if(Trigger.isInsert){
                    if(acc.Number_of_Locations__c != null || acc.Number_of_Locations__c > 0){
                        for(Integer i= 0; i < acc.Number_of_Locations__c ; i++){
                            Location__c  LLL = new  Location__c();
                            lll.Name = 'Location' + i ;
                            lll.Account__c = acc.id;
                            LocationTOList.add(LLL);
                        }
                        
                        // addaccinSet.add(acc.id);
                        //PutAccinMAP.put(acc.id,acc.Number_of_Locations__c);
                        
                    } 
                }
                else(Trigger.isUpdate){
                    if(acc.Number_of_Locations__c != oldmaps.get(acc.id).Number_of_Locations__c){
                        //5>2 : 5-2 = 3
                        if(oldmaps.get(acc.id).Number_of_Locations__c > acc.Number_of_Locations__c){
                            integer recordToDelete = (integer)(oldmaps.get(acc.id).Number_of_Locations__c - acc.Number_of_Locations__c );
                            for(Location__c ExistREC : ExistingRecordSOQL.values()){
                                if(ExistREC.Account.id == acc.id){
                                    if(LocationTOListDELETE.size < recordToDelete){
                                        LocationTOListDELETE.add(ExistREC);
                                    }
                                }
                            }
                            
                            }
                        }
                        // 3<5 : 3+(5-3) = 3+2 =5
                        else if(oldmaps.get(acc.id).Number_of_Locations__c < acc.Number_of_Locations__c){
                            integer recordToINSERT= integer(oldmaps.get(acc.id).Number_of_Locations__c + acc.Number_of_Locations__c );
                            for(integer i=0;i < recordToINSERT  ; i++){
                                Location__c  AAA = new  Location__c();
                                AAA.Name = 'Location' + i ;
                                AAA.Account__c = acc.id;
                                LocationTOListUPDATE.add(AAA);
                            } 
                        }
                    }
                }
                
            }
            
            
            if(!LocationTOList.isEmpty()){
                Insert LocationTOList;
            }
            if(!LocationTOListDELETE.isEmpty()){
                Delete LocationTOListDELETE;
            }
            if(!LocationTOListUPDATE.IsEmpty()){
                update LocationTOListUPDATE;
            }
            
        } */