public class contactDatatableController {

    // this method is used to return list of contact
    @AuraEnabled
    public static list<contact> getCon(Integer quaryLimit, Integer queryOffset, map<string,string> recordsFilter){
        string query = 'SELECT Id,Name,Phone,Email,Account.Id,Account.Name,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,LeadSource FROM Contact';
        query = addFilter(query, recordsFilter);
        query +='ORDER BY Name ASC LIMIT' + quaryLimit + 'OFFSET' + queryOffset;
        return Database.query(query);
        
    }
    //This Method Returns the Total Number of contacts in system
    @AuraEnabled
    public static Integer getContactDataCount(map<string, string> recordsFilter ){
        string query = 'select COUNT() from contact';
        query = addFilter(query, recordsFilter);
        return Database.countQuery(query);
    }
    
    //* this is the helper Method to apply filters (WHERE CONDIDTIONS) on the query
    static string addFilter(string query, Map<string,string> recordsFilter){
        if(recordsFilter != null && !recordsFilter.isEmpty()){
            query +='WHERE';
            for(string fieldName: recordsFilter.keyset()){
               query += fieldName + '= \''  + string.escapeSingleQuotes(recordsFilter.get(fieldName)) +'\' AND ';
            }
           query = query.removeEnd('AND'); 
        }
        return query;
    }
}