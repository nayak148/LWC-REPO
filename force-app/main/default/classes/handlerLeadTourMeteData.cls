public class handlerLeadTourMeteData {
 
    public static void linkMetaTOTourcheclistscript(){
        // Use String as key — assuming CheckListMtd__c is a Text field matching CheckList__c on the object
    Map<boolean, InGeneralTourCheckList__mdt> checklistToScriptMap = new Map<boolean, InGeneralTourCheckList__mdt>();
    
        // 1. Query CMDT records
List<InGeneralTourCheckList__mdt> metaList = [
    SELECT id,CheckListMtd__c, Script__c 
    FROM InGeneralTourCheckList__mdt
];
    if(metaList.size()>0){
       for(InGeneralTourCheckList__mdt mta : metaList){
    //string checklist = mta.CheckListMtd__c;
    checklistToScriptMap.put(mta.CheckListMtd__c,mta); 
     }
    }
  
// 2. Query your Lead_Tour_CheckList__c records
List<Lead_Tour_CheckList__c> checklistsToUpdate = new List<Lead_Tour_CheckList__c>();

for (Lead_Tour_CheckList__c rec : [ SELECT Id,script__c, CheckList__c FROM Lead_Tour_CheckList__c]) {
    if (rec.CheckList__c != null && checklistToScriptMap.containsKey(rec.CheckList__c)) {
        rec.script__c = checklistToScriptMap.get(rec.CheckList__c).script__c;
        checklistsToUpdate.add(rec);
    }
}

if (!checklistsToUpdate.isEmpty()) {
    update checklistsToUpdate;
}
    }

}

    
/*
// 1. Query CMDT records
    list<InGeneralTourCheckList__mdt> metalist =[SELECT CheckListMtd__c, script__c FROM InGeneralTourCheckList__mdt];
      Map<boolean, InGeneralTourCheckList__mdt> checklistToScriptMap = new Map<boolean, InGeneralTourCheckList__mdt>();

     for(InGeneralTourCheckList__mdt meta : metalist){
    checklistToScriptMap.put(meta.CheckListMtd__c, meta);
   }
 

 List<Lead_Tour_CheckList__C> checklistsToUpdate = new List<Lead_Tour_CheckList__C>();
    
// 2. Query your Lead_Tour_CheckList__C records (or use from trigger context)
for (Lead_Tour_CheckList__C rec : [SELECT Id, CheckList__c FROM Lead_Tour_CheckList__C WHERE script__c = null]) {
    if (checklistToScriptMap.containsKey(rec.CheckList__c)) {
        rec.script__c = checklistToScriptMap.get(rec.CheckList__c).script__c;
        checklistsToUpdate.add(rec);
    }
}

if (!checklistsToUpdate.isEmpty()) {
    update checklistsToUpdate;
} */