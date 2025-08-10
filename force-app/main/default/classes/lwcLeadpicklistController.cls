public class lwcLeadpicklistController {

    @AuraEnabled(cacheable=true)
    public static List<lead> getleadRecords(Id recordId) {
        return [SELECT Id, LeadSource FROM lead WHERE id = :recordId];
    }

    @AuraEnabled(cacheable=true)
    public static List<String> gettPicklistValues() {
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = lead.LeadSource.getDescribe();
        for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
            values.add(entry.getLabel());
        }
        return values;
    }

    @AuraEnabled
    public static void updateLeadSource(Id recordId, String LeadSourceValue) {
        lead record = [SELECT Id, LeadSource FROM lead WHERE Id = :recordId];
        record.LeadSource = LeadSourceValue;
        update record;
    }
}