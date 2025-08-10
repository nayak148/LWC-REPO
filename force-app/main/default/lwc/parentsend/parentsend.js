import { LightningElement  } from 'lwc';
export default class Parentsend extends LightningElement {

 button =''; // storing data in button to send 
 showdata=''; // tempering storing datat

// capture data
capMe(event){
    this.showdata = event.target.value;
}
// send input value top button
clickMe(){
    if(this.showdata){
       this.button = this.showdata ;
    }else{
        alert('Please enter some data')
    }
}
}