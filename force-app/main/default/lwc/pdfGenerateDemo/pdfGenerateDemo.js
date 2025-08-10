import { LightningElement,api } from 'lwc';
import generatePdf from '@salesforce/apex/pdfcontroller.generatePdf'
export default class PdfGenerateDemo extends LightningElement {
 imageUrl = 'https://upload.wikimedia.org/wikipedia/commons/1/12/ICICI_Bank_Logo.svg'
  @api recordId
  InvoiceData = {
    invoiceNo : '12345',
    CreatedDate : 'Jan / 1 / 20204',
    invoiceDue : 'jan/ 12/ 2024',
    CompanyName: 'Icici Bank',
    Address : 'Icici Bank, AsRoa Nagar, opp Polamari Hospital,hyd - 500062, Telangana'
     }
  
  ClintData ={
    Clint : 'Acme Crop',
    UserName : 'Vinay Nayak',
    Email : 'sfdc111nayak@Gmail.com'
  }

  Service=[
    { Name :'consultant Fee', Amount : 1000.00 },
    { Name :'Webside Designing', Amount : 3000.00 },
    { Name :'Hosting (3 Months)', Amount : 1200.00 }
  ]
  
  get TotalAmount(){
    return this.services.reduce((total,service)=>{
    return total = total+service.Amount
    },0)
  }
  HandleGeneratePdf(){
    let content = this.template.querySelector('.container')
    console.log(content.outerHTML)
     generatePdf({recordId:this.recordId, htmlData:content.outerHTML}.then(result=>{
      console.log("attachment id", result)
     }).catch(error=>{
      console.error(error)
     }))
  }
}