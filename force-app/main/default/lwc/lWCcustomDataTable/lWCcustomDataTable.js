import { LightningElement,wire,track,api } from 'lwc';
import getLeadWithChecklists from '@salesforce/apex/LeadTourChecklistController.getLeadWithChecklists';
import updateLeadAndChecklists from '@salesforce/apex/LeadTourChecklistController.updateLeadAndChecklists';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';



export default class LWCcustomDataTable extends LightningElement {
    @api recordId; // passed from record page or action
    @track leadData;
    @track checklists = [];
    wiredResult;
    sentimentOptions = [
        { label: 'Positive', value: 'Positive' },
        { label: 'Neutral', value: 'Neutral' },
        { label: 'Negative', value: 'Negative' }
    ];

    connectedCallback() {
       // this.loadData();
    }
    
    @wire(getLeadWithChecklists, { recordId: '$recordId' })
    wiredData({ data, error }) {
     this.wiredResult = data;

        if (data) {
            //this.leadData = { ...data };
            
             this.leadData = { ...data,
             Id: data.Id,
             Cash__c: data.Cash__c || false,
            UPI__c: data.UPI__c || false,
             NET_BANKING__c: data.NET_BANKING__c || false
             };
        //this.checklists = data.Lead_Tour_CheckLists__r.map(row => ({ ...row }));

        this.checklists = data.Lead_Tour_CheckLists__r.map(record => ({ ...record }));
        console.log('Loaded checklists:', JSON.stringify(this.checklists, null, 2));
          console.log('print data :',data);
        } else if (error) {
            const message = error?.body?.message || error?.message || 'Unknown error';
          this.showToast('Error wire-method records:', error.body.message,`\n${message}`,  'error');
           // this.ShowToast('Error', 'Failed to load lead data', 'error');
        }
    }
 

    handleLeadChange(event) {
        try{
    const field = event.target.dataset.field;
     if (!field) throw new Error('Missing data-field attribute on input');
    const value = event.target.type === 'checkbox' ? event.target.checked : event.target.value;
    this.leadData = { ...this.leadData, [field]: value };
        }catch(error){
          console.error('Error in handleLeadChange:', error);
         //const message = error?.body?.message || error?.message || 'Unknown error';
        // this.showToast('Error', error.body.message,'Error');
        //alert(error);
        }  
    }

    //  handleLeadChange(event){
    //    const field = event.target.dataset.field;
    // //   const id = event.target.dataset.id;
    //    const value = event.target.type === 'checkbox' ? event.target.checked : event.target.value;
    //    this.leadData = { ...this.leadData, [field]: value };

    // }

    handleChecklistChange(event) {
        const field = event.target.dataset.field;
        const id = event.target.dataset.id;
        const value = event.target.type === 'checkbox' ? event.target.checked : event.target.value;
        const row = this.checklists.find(item => item.Id === id);
        if (row) row[field] = value;
    }

    handleSave() {
        

       const leadToUpdate = {
             sobjectType: 'Lead',
            Id: this.leadData.Id,
            Cash__c: this.leadData.Cash__c,
            UPI__c: this.leadData.UPI__c,
            NET_BANKING__c: this.leadData.NET_BANKING__c
        };
      console.log('Saving leadToUpdate:', JSON.stringify(this.leadToUpdate));
      console.log('Saving leadToUpdate 2:',leadToUpdate);
        console.log('Saving checklists:', JSON.stringify(this.checklists));


    //       if (!this.leadToUpdate || !this.checklists) {
    //    // alert('Please select at least one payment method (Cash, UPI, Net Banking)');
    //    this.showToast('Error', 'Please Entered a valid Details', 'Error');
    //     return;
   // }
        updateLeadAndChecklists({    
           // leadRecord: this.leadData,
           leadRecord: leadToUpdate,
            checklists: this.checklists
   
        })
            .then(() => {
               // this.loadData();

             return refreshApex(this.wiredResult);
               // alert('Records updated successfully');
              // window.location.reload();

            })
            .then(() => {
                console.log('Data refreshed after save');
             this.showToast('Success', 'Updated successfully', 'Success');

                //alert('Records updated successfully');
            })
            .catch(error => {
                console.error('Save failed:', JSON.stringify(error, null, 2));
            const message = error?.body?.message || error?.message || 'Unknown error';
          this.showToast('Error updating records:', error.body.message,`\n${message}`,  'Error');
           // alert(`Error updating records://`);
            });
    }
    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}