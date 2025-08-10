public class pdfPageController {
	public string pdfText{get;set;}
	Public pdfPageController(){
		pdfText = String.escapeSingleQuotes(
			ApexPages.currentPage().getParameters().get('pdfText')
        		);
}
}