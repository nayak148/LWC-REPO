import { LightningElement,track } from 'lwc';
import getCon from '@salesforce/apex/contactDatatableController.getCon';
import getContactDataCount from '@salesforce/apex/contactDatatableController.getContactDataCount'

export default class ContactDatatable extends LightningElement {

//* My Table Row Actions
@track rowActions =[
   {
      label: 'View',
      name:'view'
   },
   {
      label: 'Edit',
      name:'edit'
   },
   {
      label: 'Delete',
      name:'delete'
   }

];
// * Table  coloums
@track contactColumns =[
     { 
        label: 'Name',
         fieldName: 'contactURL',
         type: 'url',
         typeAttributes:{ 
            label:{
                fieldName :'Name' // to display in table
            },
            target: '_blank',  // To after click it should open in new tab
            tooltip : 'view Contact!' // to view contact
         },
         sortable:true,  // is used for sort the data a Arrow will get at end of label 
        // wrapText : true,
         hideDefaultActions: true,
         initialWidth: 170
     },
     { 
        label: 'Account Name',
         fieldName: 'accountURL',
         type: 'url',
         typeAttributes:{
            label:{
                fieldName :'accountname'
            },
            target: '_blank',
            tooltip : 'view Account!'
         },
         sortable:true,
         //wrapText : true, // to make default is true ==> we. are making False ==> by true
         hideDefaultActions: true , //we are hinding this default action 
         initialWidth: 160
     },
     {
         label: 'Phone', 
         fieldName: 'Phone', 
         type: 'phone',  // to make click function hyber link to make calls // more type can check in documents of datatable
         sortable:true ,
        // wrapText : true,
         hideDefaultActions: true,
         initialWidth: 150

     },
     { 
        label: 'Email',
         fieldName: 'Email',
         type: 'email',  // to make click function hyber link to send Email
         sortable:true ,
         wrapText : true,
         hideDefaultActions: true,
         initialWidth: 220

     },
     {
        label: 'Lead Source',
        fieldName : 'LeadSource',
        sortable:true ,
       // wrapText : true,
        hideDefaultActions: true,
        initialWidth: 170, 
        // this is dropdown Action at leadsource
        actions: [
          { label: 'All', checked : true, name : 'all'},
          { label: 'Web', checked : false, name : 'web'},
          { label: 'Phone Inquiry', checked : false, name : 'phone_inquiry'},
          { label: 'Partner Referral', checked : false, name : 'partner_referral'},
          { label: 'Purchased List', checked : false, name : 'purchased_list'},
          { label: 'Other', checked : false, name : 'other'},
          { label: 'External Referral', checked : false, name : 'external_referral'},
          { label: 'Partner', checked : false, name : 'partner'},
          { label: 'Public Relations', checked : false, name : 'public_relations'},
          { label: 'Trade Show', checked : false, name : 'trade_show'},
          { label: 'Word of mouth   ', checked : false, name : 'Word_of_mouth'},
          { label: 'Employee Referral', checked : false, name : 'employee_referral'}
        ]
     },
     { 
        label: 'Street', 
        fieldName: 'street',
        sortable:true,
         wrapText : true,
         hideDefaultActions: true,
         initialWidth: 320
     },
     { 
        label: 'City', 
        fieldName: 'city',
        sortable:true ,
       // wrapText : true,
        hideDefaultActions: true,
        //initialWidth = 130
     },
     { 
        label: 'Postal Code',
         fieldName: 'postalcode',
         sortable:true,
         wrapText : true,
         hideDefaultActions: true
         //initialWidth = 100
     },
     { 
        label: 'State',
         fieldName: 'state',
         sortable:true ,
        // wrapText : true,
         hideDefaultActions: true,
         initialWidth : 120

     },
     { 
        label: 'Country',
         fieldName: 'country',
         sortable:true, 
        // wrapText : true,
         hideDefaultActions: true
     },
     { 
        type: 'action',  //  DropDown Menu bar for View/Edit/Delete
         typeAttributes:{
            rowActions : this.rowActions,
            menuAlignment: 'auto' // this is used to visible rowAction Lables(view/Edit/delete) clearly according to device
         }
     }
];

// *Table Data
@track contactData=[];
 // @track originalContactData=[]; // based on event at leadsource the contact is stored in differentlocation for backup
@track selectedRows=[];
recordsLimits =10;
totalRecordsCount= 0; 
recordsFilter ={};
 enableInfiniteLoading = true;
 isLoading = false;
  hideCheckboxColumn = false;
  showRowNumberColumn = true;
// * Shorting Attributs
sortedBy ='Name';
sortedDirection = 'asc';
defaultSortDirection = 'asc'; 



    
    //* This method is called when the component is inserted in Dom
    connectedCallback(){
      this.updateTotalRecordsCount(); // update totalrecords counts and updating quary contact
      
    }
  
// * This Method is Called When A row Action Buton is Clicked
  handleRowAction(event){
   const actionName = event.detail?.action?.name; // ? is used for it is present or not // its also called opetional channing
   const row = event.detail?.row; // row to capture the record details
   console.log('Record Details', row);
   console.log(JSON.parse(JSON.stringify(row)));
   console.log(JSON.stringify(event.detail));
    switch (actionName){
      case 'view':
      console.log('You clicked on view');
            break;
      case 'edit':
      console.log('You clicked on Edit');
             break;
      case 'delete':
      console.log('You clicked on Delete');
             break;
      default :
          break;       

    }
  }

/*
  *.  A and B ==> contact Records
  *   >0 if A should occer after B in the Shorted Array
  *  < 0 is A should occer before B in the Shorted Array
  *  = 0 if the order doesn't matter
  * -> valid for ascending order
      * According to js :  fales - true = -1  and true - fales = 1 ; 
  */

 //* This methods is use to short the records
  sortBy(field,reverse,primer){
     const key = primer 
     ? function(x){
      return primer(field , x);
     }
     : function(x){
      return x[field];
     };
     return function(a,b){
      a = key(a);
      b = key(b);
      // * Handle undefined valuse
      if( a === b){
        return 0;
      }else if(a === undefined){
        return reverse * -1;
      }else if(b === undefined){
        return reverse * 1;
      }
      return reverse * ((a > b) - (b > a ));
     }
  }
  
  //* Helper Method for Short by Method
  primer(field, record){
   let returnValue;
   switch (field){
       case 'contactURL':
             returnValue = record['Name'];
             break;
       case 'accountURL':
             returnValue = record['accountname'];
             break;
       default:
            returnValue = record[field];
            break;    
   }
   return returnValue
  }


 
 //* This method is called whenever 
 handleSort(event){
  console.log(JSON.stringify(event.detail));
   const { fieldName : sortedBy, sortDirection : sortedDirection } = event.detail;// *when event is happening on table -header than getting fieldName and sortDirection as assigning from html to js
   const clonedContactData = [...this.contactData]; // we are colning the contactdate in clonedContactData by spread operator to expand it
   clonedContactData.sort(this.sortBy(sortedBy,sortedDirection === 'asc' ? 1 : -1 ,this.primer)); // this sort method is use to compare the function
   this.contactData = clonedContactData; // assigning the new values to ContactData , the data getting from sort() function to clonedContactData
   //now update by sorted by its veriables, when event is happening
   this.sortedBy = sortedBy; 
   this.sortDirection = sortedDirection;
 }

//* this meathod is called when a header action is clicked at leadsourece //clicking dropdown menu
 handleHeaderAction(event){
   console.log(event.detail);
   const {action, columnDefinition } = event.detail; // get action and columnDefination from even
   const contactColumns = this.contactColumns; // this is use to update column definations When event is happened it should checked tick mark
   const actions =  contactColumns.find(contactColumns => contactColumns.fieldName === columnDefinition.fieldName)?.actions;  // whose header is clicked
   if(actions){
     actions.forEach(currentAction => {
      currentAction.checked = currentAction.name === action.name; 

     });
     this.contactColumns =[...contactColumns]; // we are reassigning the colume with arry to colums  
     if(action.name === 'all'){
      //this.contactData = this.originalContactData;
      delete this.recordsFilter[columnDefinition.fieldName];
     }else{
      this.recordsFilter[columnDefinition.fieldName] = action.label;
     //  this.contactData = this.originalContactData.filter(contact => contact.LeadSource === action.label); 
     }
   }
   this.updateTotalRecordsCount();
   console.log(JSON.stringify(actions));
 }


 handleRowSelection(event){
    const selectedRows = event.detail.selectedRows.map(row => row.Id);
    //const selectedRowsrecord = event.detail.selectedRows.map(record => record.Id);
    this.selectedRows = selectedRows;
   console.log('handleRowSelection print event :' ,JSON.stringify(event.detail.selectedRows));
   console.log(' this.selectedRows print2 ,manually : ', JSON.stringify(this.selectedRows));
 }

 // This methid is use to load more contact as user told to be last record in datatable
 loadContacts(){
  //console.log('loadMoreContacts Print :',event.detail);
  console.log('querying contacts....');
  if(this.contactData.length < this.totalRecordsCount){
    this.quearyContacts();
  }else{
   console.log('No more contactData to quary');
   this.enableInfiniteLoading = false;
  }
  
 }
 //* thi
//this method is use to update total records counts according to the filters applied
 updateTotalRecordsCount(){
   const that = this;
   getContactDataCount({
      recordsFilter: this.recordsFilter
   })
   .then(count =>{
      that.totalRecordsCount = count;
      that.quearyContacts(true); // once the record is count then only quary contact
   })
   .catch(error => console.log('featching totalroecords count :',error))
   .then(() => that.enableInfiniteLoading = true);
 }

//*This Method is used to query contacts based on limit and offset and filters applied by the user
   quearyContacts(overrideContactData){
         this.isLoading = true;
         const that = this;
        console.log('quaring Contacts......');
    //* quaring contacts ...
   getCon({
      quaryLimit : this.recordsLimits,// 10
      queryOffset: overrideContactData? 0 : this.contactData.length, // 0
      recordsFilter : this.recordsFilter
   })
   .then(contactData => {
            contactData.forEach(contact => {
                contact.contactURL = '/' + contact.Id; // it Taking base URL and Appading The ContactId at End ==> when contact name is clicked it should open in new page
                contact.accountURL = '/' + (contact.Account?.Id || ''); // when Account name is clicked it should open in new page
                contact.accountname = contact.Account?.Name || '';   // account name 
                contact.street=contact.MailingStreet || '';  // account MallingAddtess
                contact.city=contact.MailingCity || '';
                contact.postalcode = contact.MailingPostalCode || '';
                contact.state = contact.MailingState || '';
                contact.country = contact.MailingCountry || '';
           });
            console.log(contactData);
            const selectedRows = that.contactData.length === 0;
             if(overrideContactData){
                 that.contactData = contactData;
             }else{
                 that.contactData =that.contactData.concat(contactData); // this contact is filterated based on lead source
             }
             //that.originalContactData = contactData.concat(contactData);
              
             if(selectedRows){
                 // pickup the contact array , get first three contacts and create a new array of ids of three contacts
             that.selectedRows = contactData.slice(0, 3).map(contact => contact.Id); 
             console.log(' this.selectedRows print : ', JSON.stringify(this.selectedRows));
             }
          })
          .catch(error => console.log('getcon error Apex method dint called :', error))
         .then(()=> {
            this.isLoading=false;
           /* if(currentTarget){ // or if not condition means use ==> currentTarget?.isLoading=false;
            currentTarget.isLoading=false;
            } */
            
         })
         
    }
    
   
}