import { LightningElement, track } from 'lwc';

export default class CustomDataTableDemo extends LightningElement {
    columns = [
        { label: 'Name', fieldName: 'name', sortable: true, width: '180px' },
        { label: 'Website', fieldName: 'website', type: 'url', urlLabelField: 'name', width: '220px' },
        { label: 'Revenue', fieldName: 'revenue', type: 'currency', sortable: true, width: '140px' },
        { label: 'Growth', fieldName: 'growth', type: 'percent', sortable: true, width: '120px' },
        { label: 'Founded', fieldName: 'founded', type: 'date', sortable: true, width: '140px' }
    ];

    rows = [
        { id: '1', name: 'Acme Inc', website: 'https://acme.example.com', revenue: 1234567.89, growth: 12.5, founded: '2011-04-22' },
        { id: '2', name: 'Globex', website: 'https://globex.example.com', revenue: 2340000, growth: 8.1, founded: '2005-09-10' },
        { id: '3', name: 'Initech', website: 'https://initech.example.com', revenue: 987654.32, growth: 5.0, founded: '2018-01-15' },
        { id: '4', name: 'Umbrella', website: 'https://umbrella.example.com', revenue: 340000, growth: -2.3, founded: '1998-07-09' },
        { id: '5', name: 'Stark Industries', website: 'https://stark.example.com', revenue: 8765432.1, growth: 22.9, founded: '1970-05-29' },
        { id: '6', name: 'Wayne Enterprises', website: 'https://wayne.example.com', revenue: 7654321.0, growth: 15.0, founded: '1965-10-01' },
        { id: '7', name: 'Wonka', website: 'https://wonka.example.com', revenue: 250000, growth: 3.2, founded: '2000-02-14' }
    ];

    @track selectedInfo;

    handleSelectionChange(event) {
        const keys = event.detail?.selectedKeys || [];
        this.selectedInfo = keys.join(', ');
    }

    handleSort(event) {
        // The child component already sorts internally. You could persist state here if needed.
        // console.log('sort', event.detail);
    }
}