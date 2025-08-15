import { LightningElement } from 'lwc';
import getCases from '@salesforce/apex/CaseManagementModule2.getCases';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import STATUS_FIELD from '@salesforce/schema/Case.Status';


export default class CaseManagementMopdule2 extends LightningElement {
   
 @track statusOptions = [];
    @track cases = [];
    isLoading=false;

   

    // Get Case object info
    @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
    caseMetadata;

    // Get Status picklist values
    @wire(getPicklistValues, {
        recordTypeId: '$caseMetadata.data.defaultRecordTypeId',
        fieldApiName: STATUS_FIELD
    })
    wiredStatusValues({ error, data }) {
        if (data) {
            this.statusOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));
        } else if (error) {
            console.error('Error fetching Status picklist values:', error);
        }
    }
  
    
     columns = [
        { label: 'Case Number',fieldName:'CaseNumber', type:'text'},
        { label: 'Subject',fieldName:'Subject',type:'text'},
        { label: 'Account Name', fieldName: 'Account.Name', type:'text'},
        { label: 'Contact Name', fieldName: 'Contact.name', type:'text'},
        { label: 'Status', fieldName: 'Status', type:'text'},
        { label: 'Priority', fieldName: 'Priority', type: 'text' },
        { type: 'button', typeAttributes: { label: 'Close Case', name: 'closeCase', variant: 'brand' } },
        { type: 'button', typeAttributes: { label: 'Reassign', name: 'reassign', variant: 'brand' } },
    ];
    selectedStatus = '';
        // When picklist changes
    handleStatusChange(e){
        const selectedStatus = e.detail.value;
        this.isLoading = true;
        getCases({ status: selectedStatus })
            .then(result => {
                this.cases = result;
                this.isLoading = false;
            })
            .catch(error => {
                console.error(error);
                this.isLoading = false;
            });
    }

    handleRefresh() {
        this.handleStatusChange({ target: { statusOptions: '' } });
    }
}