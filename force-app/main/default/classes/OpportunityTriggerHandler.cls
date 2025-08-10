public class OpportunityTriggerHandler {
    
    //When opp is created or update name then override with AccName and createdDate
    public static void updateOppNameWITHAccNameCreateDate(list<opportunity> newRec){
        system.debug('trigger enter in Handler class, After Insert insert opp');
       String formattedDate;
       // Date todayDate;
       // Get today's date
       // Date todayDate = Date.today();
         DateTime createdDate;
        
        // Format the date as DDMMYYYY
       // String formattedDate = todayDate.format('ddMMyyyy');
        set<id> accidset = new set<id>();
       
            for(opportunity opp : newRec){
                if(opp.AccountId != null){
                    accidset.add(opp.AccountId);
                    system.debug('trigger enter in Handler class, After Insert insert opp  loop');
                }
            }
        
            //list<Account> AccList =[select id , name , createdDate from Account WHERE Id IN : accidset];
            
            map<Id,Account> MapAccandOpp = New map<Id,Account>([SELECT Id, Name, CreatedDate, (SELECT Id, AccountId, Name,CreatedDate FROM Opportunities) FROM Account WHERE  CreatedDate > 2025-01-01T00:00:00.000Z AND  ID IN :accidset]);
            
            map<id,opportunity> updateMapOppvsAcc = new map<id,opportunity>();
            
            for(Account acc : MapAccandOpp.values()){
                for(opportunity opp : ACC.Opportunities){
                    
                   createdDate = acc.CreatedDate;
                   formattedDate = createdDate.format('ddMMyyyy');
                   // todayDate = Date.today();
                   // formattedDate = todayDate.format('MMddyyyy');
                    //opp.name = Acc.Name + ' - ' + opp.CreatedDate;
                    opp.name = Acc.Name + ' - ' + formattedDate;
                   // opp.name = Acc.Name + ' - ' + system.today();
                   //opp.name = Acc.Name + ' - ' + system.today();
                    system.debug('print result' +  formattedDate );
                    updateMapOppvsAcc.put(opp.id,opp);
                }
                
                
                if(!updateMapOppvsAcc.isEmpty()){
                    update updateMapOppvsAcc.values();   
                }
                system.debug('print updateMapOppvsAcc.values() ' + updateMapOppvsAcc.values() );
                system.debug('print updateMapOppvsAcc.keyset() ' + updateMapOppvsAcc.keyset() );
                system.debug('print updateMapOppvsAcc ' + updateMapOppvsAcc);
            }
            
        }
    
    
    
    
    //when amount is updated in opportunity update sum of opp amount in account sumofOppamount field
    public static void showSUMofOPPinACC(list<opportunity> newRec, map<id,opportunity> oldMaps, list<opportunity> oldRec){
         
         decimal sumamt;
        set<id> accidset = new set<id>();
        if(newRec != null){
            for(opportunity opp : newRec){
                if(opp.AccountId != null){
                    accidset.add(opp.AccountId);
                }
            }
            
        }else if (oldRec != null){
            for(opportunity opp : oldRec){
                if(opp.AccountId != null){
                    accidset.add(opp.AccountId);
                }
            }
            
        }else if(oldMaps!= null){
             for(opportunity opp : newRec){
                if(opp.AccountId != null && opp.Amount != oldMaps.get(opp.id).Amount){ 
                    accidset.add(opp.AccountId);
                }
            }
        }
        //map<id,AggregateResult> mapAccidVSar = new map<id,AggregateResult>();
        map<id,decimal> mapAccidVSar = new map<id,decimal>();
            
        for(AggregateResult AR : [select AccountId , sum(Amount) AmountSUM from Opportunity where  AccountID IN : accidset Group By AccountId]){
            sumamt = (decimal)AR.get('AmountSUM');
            mapAccidVSar.put((id)AR.get('AccountId'), sumamt);
        }
        
        list<Account> updateAcclist = new list<Account>();
        
         for(id AccountId :accidset){
            Account Acc = new Account(id = AccountId);
            Acc.sumofOppAmount__c = (decimal)mapAccidVSar.get(AccountId);
            updateAcclist.add(Acc);
        }
        
         /*for(id AccountId :accidset){
            Account Acc = new Account(id = AccountId);
            Acc.sumofOppAmount__c = mapAccidVSar.containskey(AccountId) ? (decimal)mapAccidVSar.get(AccountId).get('AmountSUM') : 0;
            updateAcclist.add(Acc);
        }*/
        
        if(!updateAcclist.IsEmpty()){
          update updateAcclist;            
        }
        
    }
    
    
    //when amount is updated in opportunity update sum of opp amount in account sumofOppamount field
    
   /* public  static void UpatesumofOPPamtToACCAmt(list<opportunity> newRec, map<id,opportunity> oldmpas ){
        set<id> accids = new set<id>();
        list<account> updateAcclist = new list<account>();
        for(opportunity opp : newRec){
            if(!newRec.IsEmpty()){
                accids.add(opp.AccountId);
            }
            else if(opp.Amount != oldmpas.get(opp.id).Amount || opp.Amount != Null){
                accids.add(opp.AccountId);
            }
          
            
            map<id,AggregateResult> MAPamountSUM = new map<id,AggregateResult>();
            system.debug('print MAPamountSUM : ' + MAPamountSUM );
            for(AggregateResult AR : [select accountId,sum(Amount) amountsum,count(id) Idcount from Opportunity where AccountID IN :accids GROUP BY AccountID ]){
                MAPamountSUM.put((ID)AR.get('accountId'),AR);
            }
            
            for(id accountId :accids){
               Account acc = new Account(id = accountId);
               //acc.id= accountId; 
               acc.sumofOppAmount__c = MAPamountSUM.containsKey(accountId) ? (decimal)MAPamountSUM.get(accountId).get('amountsum') :0 ;
                system.debug('print sumofOppAmount__c : ' + acc.sumofOppAmount__c );
                updateAcclist.add(acc); 
            }
                
            } 
       if(!updateAcclist.IsEmpty()){
           system.debug('print updateAcclist : ' + updateAcclist );
            update updateAcclist;
        }  
            
        }*/
        
 
          
        
    
    
    
    
    Public static Void whenOppisCloseWonCreateTask(list<Opportunity> newRec, map<id,Opportunity> oldmap){
        list<Task> addinlist = new list<Task>();
        for(Opportunity opp : newRec)
        {
            if(opp.StageName != oldmap.get(opp.id).StageName && opp.StageName == 'Closed Won'){
                task creatTask = new Task();
                creatTask.Subject = 'split the Revenue';
                creatTask.OwnerId = opp.OwnerId;
               // creatTask.WhoId = opp.ContactId;
                creatTask.WhatId = opp.id;
                creatTask.Priority ='High';
                creatTask.Description = 'Split the revenue amount among the Team members';
                addinlist.add(creatTask);
            }
        }
        if(!addinlist.IsEmpty()){
            insert addinlist;
        }
    }
    public static Void updateOppAmount(list<Opportunity> newRec, map<id,Opportunity> oldmap){
        for(Opportunity opp : newRec){
            if(opp.StageName != oldmap.get(opp.id).StageName){
                opp.Amount = opp.Probability * opp.ExpectedRevenue;
            }
        }
    }
    public static Void createTaskwhenOppDelete(list<Opportunity> oldRec){
        set<id>  accidinlist = new set<id>();
        for(Opportunity opp : oldRec){
            accidinlist.add(opp.AccountId);
        } 
        list<account> acclist = [select id,ownerid FROM account where Id  IN : accidinlist ];
        list<Task> addtaskinlist = new list<Task>();
        for(account acc: acclist ){
            
            task ct = new task();
            ct.Subject = 'check why opp is deleated';
            ct.Description = 'investage why the opportunity is deleated';
            //ct.AccountId = acc.id;
            ct.OwnerId = acc.OwnerId;
            ct.Priority ='High';
            ct.WhatId = acc.id;
            addtaskinlist.add(ct);
        }
        
        if(!addtaskinlist.IsEmpty()){
            insert addtaskinlist;
        }

    }
    public static Void removeALLoppTEAMmember(list<Opportunity> newRec, map<id,Opportunity> oldmap){
        list<OpportunityTeamMember> deleteThisRec = new list<OpportunityTeamMember>();
        //step 1: we are assding all new ids which is closed lost in list
        list<id> addidsinlist = new list<id>();
        for(Opportunity opp : newRec){
            if(opp.StageName != oldmap.get(opp.id).StageName && opp.StageName == 'Closed Lost'){
                addidsinlist.add(opp.id);
            }
        }
        //step 2: Retreving the oppteamMember from database from step:1 list
        list<OpportunityTeamMember> oppTeamList = [select id from OpportunityTeamMember Where OpportunityId IN :addidsinlist];
        for(OpportunityTeamMember otm :oppTeamList){
                deleteThisRec.add(otm);            
        }
        //step 3: we are taking sObject of OpportunityTeamMember to delete because ids are not accepting to delete
        if(!deleteThisRec.isEmpty()){
            delete deleteThisRec;	
        } 
    }
    
}
/*
 * trigger UpdateAccountSumOfAmount on Opportunity (after insert, after update, after delete, after undelete) {
    // Set to hold all account IDs to be processed
    Set<Id> accountIds = new Set<Id>();

    // Collect account IDs from the trigger context
    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Opportunity opp : Trigger.new) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }
    }

    if (Trigger.isUpdate || Trigger.isDelete) {
        for (Opportunity opp : Trigger.old) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }
    }

    // If there are no account IDs, exit the trigger
    if (accountIds.isEmpty()) {
        return;
    }

    // Aggregate the sum of amounts for each account
    Map<Id, Decimal> accountSums = new Map<Id, Decimal>();
    for (AggregateResult ar : [SELECT accountId, SUM(Amount) sumAmount 
                               FROM Opportunity 
                               WHERE AccountId IN :accountIds 
                               GROUP BY AccountId]) {
        accountSums.put((Id)ar.get('AccountId'), (Decimal)ar.get('sumAmount'));
    }

    // List to hold accounts to be updated
    List<Account> accountsToUpdate = new List<Account>();

    // Update the SumOfAmount__c field on each account
    for (Id accountId : accountIds) {
        Account acc = new Account(Id = accountId);
        acc.SumOfAmount__c = accountSums.containsKey(accountId) ? accountSums.get(accountId) : 0;
        accountsToUpdate.add(acc);
    }

    // Update the accounts
    if (!accountsToUpdate.isEmpty()) {
        update accountsToUpdate;
    }
}


*/

 /*list<OpportunityTeamMember> deletelist = new list<OpportunityTeamMember>();
       // set<id> deleteids = new set<id>();
        for(Opportunity opp : newRec){
            if(opp.StageName != oldmap.get(opp.id).StageName && opp.StageName == 'Closed Lost'){
                OpportunityTeamMember otm = new OpportunityTeamMember();
                otm.OpportunityId = opp.id;
                deletelist.add(otm);
               // deleteids.add(otm.id);
            }
        }
        delete deletelist;
       // if(!deleteids.isEmpty()){
            
       // }*/
       // 
   
   /*
          mydecval = (DECIMAL)agr.get('totalAmount');
            accmap.put((Id)agr.get('AccountId') ,(DECIMAL)agr.get('totalAmount'));
            Account accItem = NEW Account(); 
            accItem.Id=(Id)agr.get('AccountId'); 
            accItem.Total_Booking_Revenue__c = mydecval;
         * / 

       
    /*list<id> addIDSinlist = new list<id>();
        list<OpportunityTeamMember> addTeamidinlistToDelete = new list<OpportunityTeamMember>();
        list<OpportunityTeamMember> teamList = [select id,OpportunityId from OpportunityTeamMember where OpportunityId IN:addIDSinlist];
        for(Opportunity opp : newRec){
            addIDSinlist.add(opp.id);
        }
        for(Opportunity opp : newRec){
            if(opp.StageName == 'Closed Lost' && opp.StageName != oldmap.get(opp.id).StageName){
                 for(OpportunityTeamMember opptm : teamList){
                  addTeamidinlistToDelete.add(opptm);
            }
        }
       
        }
        if(!addTeamidinlistToDelete.isEmpty()){
            delete addTeamidinlistToDelete;
        }  */