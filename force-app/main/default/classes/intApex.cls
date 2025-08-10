public class intApex {
    
    public static void example(){
        
        list<string> listoppstagename =  new list<string>();
        map<id, string> maplist = new map<id, string>();
        system.debug(' print : ' + listoppstagename);
        
         map<id, Account> AccMap = new map<id, Account>([Select industry , (select stageName from opportunities) From Account]);
        for(Account acc: AccMap.values()){
            for( opportunity  opp : acc.opportunities){
                listoppstagename.add(opp.stageName);
                maplist.put(opp.id, opp.StageName);
            }
        }
         system.debug(' print : ' + listoppstagename);
         system.debug(' print 2 : ' + maplist.values());
        system.debug(' print 3 : ' + maplist);
        
    }
}