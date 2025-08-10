public class LeadTriggerHandler {
    public static void SetLeadStatusToWorkingCondition(List<Lead> NewRec){
        for(Lead EL : NewRec){
            El.Status = 'Working - Contacted'; 
        }
    }
    public static void whenIndIdHealthcareSETcond(List<Lead> NewRec){ 
        
        for(lead El : NewRec){
            if(El.Industry == 'Healthcare'){
                El.LeadSource = 'Purchased List';
                El.SICCode__c = '1100' ;
                el.Primary__c = 'Yes';
            }
       }    
    }
    public static void creteTaskforleadOwn(List<Lead> NewRec){
        list<task> addinlist = new list<task>();
        for(lead El : newRec){
            Task Tk = new Task();
            Tk.Subject ='Followup with Customer';
            TK.Priority = 'Normal';
            Tk.OwnerId = El.OwnerId;
            TK.WhoId = El.id;
            addinlist.add(Tk);
         }
        
        if(!addinlist.IsEmpty()){
            insert addinlist;
        }
    } 
    public static void donotDeleteWorkLead(List<Lead> oldRec){
        system.debug('did not enter in loop');
        for(lead ld : oldRec){
            system.debug('lead found');
            system.debug('check status : ' + ld.Status);
            if(ld.Status == 'Closed - Not Converted'){
                  ld.AddError('you are not able to delete this lead');                
            }
        }
    }
}