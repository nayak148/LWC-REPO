public class SetListMapCollections {

    public static void AddSetInMAP(){
        
       list<contact> conList = [Select id, AccountId, Name from contact limit 400];
        system.debug('check conlist :' + conList);
        map<id, set<id>> mapAccIdVSconSet = new map<id, set<id>>();
        system.debug('check map :' + mapAccIdVSconSet);
        set<id> ConIdSet = new set<id>();
        system.debug('check set :' + ConIdSet);
        for(contact con :conList){
            if(con.AccountId != Null){
                ConIdSet.add(con.id);
                mapAccIdVSconSet.put(con.AccountId,ConIdSet);
                
            }
            
        }
    }
    
    public static void AddListInMap(){
        
        map<id, List<contact>> mapAccIdVSconSet = new map<id, List<contact>>();
        
        list<contact> conList = new  list<contact>();
        
        for(contact con: [Select id, AccountId, Name from contact limit 400]){
             
            conList.add(con);
             mapAccIdVSconSet.put(con.AccountId,conList);
        } 
        
    }
    public static void AssMapInMap(){
        map<id,map<id,map<id,contact>>> mapAccIDvsOwnerIDvsCon = new map<id,map<id,map<id,contact>>>();
        
        map<id,contact> mapConIdVScon = new map<id,contact>();
        map<id,map<id,contact>> MapOwnerIDvsCon =  new map<id,map<id,contact>>();
        
        for(contact con :  [Select id, AccountId, ownerid, Name,phone from contact]){
            if(con.AccountId != null && con.OwnerId != null){
                mapConIdVScon.put(con.id,con);
                MapOwnerIDvsCon.put(con.OwnerId,mapConIdVScon);
                mapAccIDvsOwnerIDvsCon.put(con.AccountId,MapOwnerIDvsCon);
            }
        }
        }
}