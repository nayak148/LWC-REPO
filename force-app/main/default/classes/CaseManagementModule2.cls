public class CaseManagementModule2 {
	
	 @AuraEnabled(cacheable=true)
      public static List<Case> getCases(String status) {
        String statusFilter = '%' + status + '%';
        return [SELECT Id,Account.Name, Contact.name,subject, CaseNumber, Status, Priority FROM Case WHERE Status LIKE :statusFilter];
    }
	
}