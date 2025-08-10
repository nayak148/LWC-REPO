public class contactApexClasses {
    
    public static void updateconPicklistVAl(){
        list<contact> conlist = [select id,Modules__c from contact limit 5 offset 10];
        list<contact> updateconlist = new list<contact>();
        for(contact con: conlist){
            con.Modules__c = 'GOLD;STEEL;PLATINUM';
            updateconlist.add(con);
        }
        update updateconlist;
    }
     public static void updateconPicklistVAl1(){
        list<contact> conlist = [select id,Modules__c from contact limit 5 offset 15];
        list<contact> updateconlist = new list<contact>();
        for(contact con: conlist){
            con.Modules__c = 'DIAMAND;STEEL;SILVER';
            updateconlist.add(con);
        }
        update updateconlist;
    }
    public static void updateconPicklistVAl2(){
        list<contact> conlist = [select id,Modules__c from contact limit 5 offset 20];
        list<contact> updateconlist = new list<contact>();
        for(contact con: conlist){
            con.Modules__c = 'BRONZE;IRON;SILVER';
            updateconlist.add(con);
        }
        update updateconlist;
    }
    
    

}