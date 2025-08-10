import { LightningElement,track } from 'lwc';
import GetBySatatus from '@salesforce/apex/CaseManagamentInterview.GetBySatatus';
export default class CaseManagementInterview extends LightningElement {
   @track cases =[]
    @track isLoading = fales
    
    @track columns =[
    { Label: 'case Number' ,fieldName : 'CaseNumber', type : text },
    { Label: 'subject' ,fieldName : 'subject', type : text },
     { Label: 'status' ,fieldName : 'status', type : text },
      { Label: 'type' ,fieldName : 'type', type : text }

    ]
   
   capMe(event){
    this.searchKey = event.taraget.value;
   }
  callME(){
    this.isLoading = true;
     GetBySatatus({ status: searchKey}
     .then(result => {
        this.cases = result;
        this.error = undefined;
        this.isLoading = false;
     }).catch(error =>{
        this.result = error;
         this.isLoading = false;
     })
     );
  }

}