import { LightningElement, wire, track } from 'lwc';
import getAccounts from '@salesforce/apex/twoWrieServiceOutandIn.getAccounts';
import getContactsByAccountId from '@salesforce/apex/twoWrieServiceOutandIn.getContactsByAccountId';

export default class AccountContactComponent extends LightningElement {
    @track accounts = [];
    @track selectedAccountId; // Reactive property to store selected Account Id
    @track contacts = [];

    // Wire method to get Accounts
    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
            // Automatically set the first Account as the selected Account (for demo)
            if (this.accounts.length > 0) {
                this.selectedAccountId = this.accounts[0].Id; // This will be the input for the second wire
            }
        } else if (error) {
            console.error('Error fetching accounts: ', error);
        }
    }

    // Wire method to get Contacts based on the selected Account Id
    @wire(getContactsByAccountId, { accountId: '$selectedAccountId' }) // Reactive to 'selectedAccountId'
    wiredContacts({ error, data }) {
        if (data) {
            this.contacts = data;
        } else if (error) {
            console.error('Error fetching contacts: ', error);
        }
    }

    // Event handler when user selects a different account
    handleAccountChange(event) {
        this.selectedAccountId = event.target.value; // Update the reactive property
    }

    // Computed property to format accounts for combobox options
get accountsOptions() {
    return this.accounts.map(account => {
        return { label: account.Name, value: account.Id };
    });
}

}