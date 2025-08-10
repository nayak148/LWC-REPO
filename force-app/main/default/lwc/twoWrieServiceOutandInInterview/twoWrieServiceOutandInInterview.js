import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/twoWrieServiceOutandIn.getAccounts';
import getContactsByAccountId from '@salesforce/apex/twoWrieServiceOutandIn.getContactsByAccountId';

export default class TwoWrieServiceOutandInInterview extends LightningElement {
    accounts;   // Stores the account records
    contacts;   // Stores the related contact records
    selectedAccountId;  // Stores the selected Account ID

    // Fetch all Accounts
    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
        } else if (error) {
            console.error('Error fetching accounts', error);
        }
    }

    // Fetch Contacts based on Account ID
    @wire(getContactsByAccountId, { accountId: '$selectedAccountId' })
    wiredContacts({ error, data }) {
        if (data) {
            this.contacts = data;
        } else if (error) {
            console.error('Error fetching contacts', error);
        }
    }

    // Handle account selection
    handleAccountSelect(event) {
        this.selectedAccountId = event.target.value;
    }
    get accountsOptions() {
    return this.accounts.map(account => {
        return { label: account.Name, value: account.Id };
    });
}
}