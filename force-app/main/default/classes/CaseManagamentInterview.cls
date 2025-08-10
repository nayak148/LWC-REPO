public class CaseManagamentInterview {
	@AuraEnabled
	Public static List<case> GetBySatatus( string searchKey){
      
	   string sk = '%' + searchKey + '%';
	  Return [select id, CaseNumber, type, Status from case where status LIKE : sk]	;
	  
	}
}