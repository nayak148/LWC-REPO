public class LeadTourChecklistController {
   @AuraEnabled(cacheable=true)
    public static Lead getLeadWithChecklists(Id recordId) {
        return [
            SELECT Id, Cash__c, UPI__c, NET_BANKING__c,
                (SELECT Id, Lead__c, Script__c, CheckList__c, Sentement__c 
                 FROM Lead_Tour_CheckLists__r)
            FROM Lead
            WHERE Id = :recordId
        ];
    }

    @AuraEnabled
    public static void updateLeadAndChecklists(Lead leadRecord, List<Lead_Tour_CheckList__c> checklists) {
        system.debug('print Lead result :' + leadRecord);
        system.debug('print checklists result :' + checklists);
       
     if (leadRecord != null) {
        update leadRecord;
    }

    if (checklists != null && !checklists.isEmpty()) {
        update checklists;
    }
 
        
    }
}