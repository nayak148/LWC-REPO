/**
* @File Name : AccountDataController.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : July 25, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | July 25, 2025 |   | Initial Version
**/

public class AccountDataController {
	@AuraEnabled (cacheable=true)
    public static List<Account> fetchAccounts(){
        return [SELECT Id, Name, Type, Phone,Checklist__c FROM Account WHERE Type !='' LIMIT 10];       
    }
}