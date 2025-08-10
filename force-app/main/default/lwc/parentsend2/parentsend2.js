import { LightningElement } from 'lwc';
export default class Parentsend2 extends LightningElement {

     userData = '';  // Stores the input data
    button =''; // storing the data in button
    // Capture the input value when changed
    handleInputChange(event) {
        this.userData = event.target.value;
    }

    // Handle submit button click
    handleSubmit() {
        if (this.userData) {
            this.button = this.userData;
            console.log('Data submitted:', this.userData);
        } else {
            alert('Please enter some data.');
        }
    }
}