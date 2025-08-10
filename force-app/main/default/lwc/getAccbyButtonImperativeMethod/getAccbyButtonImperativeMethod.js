// accountListImperative.js (continued)
import { LightningElement, track } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';

export default class AccountListImperative extends LightningElement {
    @track accounts;
    @track error;
    @track showAccounts = false;

    columns = [
        { label: 'Account Name', fieldName: 'Name' },
        { label: 'Industry', fieldName: 'Industry' },
    ];

    handleShowAccounts() {
        getAccounts()
            .then(result => {
                this.accounts = result;
                this.error = undefined;
                this.showAccounts = true;
            })
            .catch(error => {
                this.error = error;
                this.accounts = undefined;
            });
    }
}