import { LightningElement } from 'lwc';
import getCases from '@salesforce/apex/CaseManagementModule2.getCases';

export default class CaseManagementMopdule2 extends LightningElement {
     cases = [];
     isLoading = false;
     columns = [
        { label: 'Case Number', fieldName: 'CaseNumber', type: 'text' },
        { label: 'Subject', fieldName: 'Subject', type: 'text' },
        { label: 'Account Name', fieldName: 'Account.Name', type: 'text'},
        { label: 'Contact Name', fieldName: 'Contact.name', type: 'text'},
        { label: 'Status', fieldName: 'Status', type: 'text' },
        { label: 'Priority', fieldName: 'Priority', type: 'text' },
        { type: 'button', typeAttributes: { label: 'Close Case', name: 'closeCase', variant: 'brand' } },
        { type: 'button', typeAttributes: { label: 'Reassign', name: 'reassign', variant: 'neutral' } }
    ];

    handleStatusChange(event) {
        const statusFilter = event.target.value;
        this.isLoading = true;
        getCases({ status: statusFilter })
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
        this.handleStatusChange({ target: { value: '' } });
    }
}