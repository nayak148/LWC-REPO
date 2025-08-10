public class CaseTriggerHandler {
    Public Static Void whenCaseISPhoneSetPriorityHigh(List<Case> newRec){
        for(Case EC : newRec){
            if(EC.Origin == 'Phone'){
                Ec.Priority ='High';
            }
            else{
               Ec.Priority ='Low'; 
            }
        }
        
    }
   Public Static Void AllowCaseDeleteONLYbySysAdminUser(List<Case> oldRec){
    /*       list<id> addownidinlist = list<id>();
       for(case cc :oldRec){
           if(cc.OwnerId == true){
               addownidinlist.add(cc.id);
           }
       }
       list<user> userlist =[select id from user where id IN : addownidinlist];
       */
   }
    public static void sendMailToCaseOwner(list<case> newRec){
        map<id,case> mapIdVScase = new map<id,case>();
        for(case cc : newRec){
            if(cc.OwnerId != null){
                mapIdVScase.put(cc.OwnerId,cc);
            }     
        }
        
        list<user> userList = [select id, Email from user where id In :mapIdVScase.keyset()];
        for(case cc : mapIdVScase.values()){
        for(user ur : userList){
            if(ur.email != null){
        messaging.SingleEmailMessage SEL= NEW messaging.SingleEmailMessage(); 
        
        
          List<String> TOADD = new List<String> {ur.Email,cc.ContactEmail};
        
        SEL.setToAddresses(TOADD);
        SEL.setSubject('HI Good morning.... Testing the Case email');
        sel.setPlainTextBody('A case is Created Plz , do once check it ');
        
        List<Messaging.Email>  xxx = new List<Messaging.Email> {SEL};
            messaging.sendEmail(xxx);  
            }
        }}
                
            }
            
        }