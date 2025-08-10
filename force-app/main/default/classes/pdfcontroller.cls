public with sharing class pdfcontroller {
    @AuraEnabled
    public static attachment generatePdf(Id recordId, string htmlData){
        PageReference page =page.renderDemoPDF;
        page.getParameters().put('pdfText',htmlData);
        
        contact con = new contact(id = recordId);
        attachment objAtt = new attachment();
        objAtt.Name = 'invoice.pdf';
        objAtt.ParentId = con.id;
        objAtt.body = page.getContentaspdf();
        objAtt.IsPrivate = false;
        insert objAtt;
        return objAtt;
        
    }

}