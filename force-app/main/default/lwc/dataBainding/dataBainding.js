import { LightningElement,track } from 'lwc';
export default class DataBainding extends LightningElement {
    isTrackingName = 'Venkatesh nayak Banoth';
  
  @track isTrackingName2 = 'world';

  capMe(event){
    this.isTrackingName2 = event.detail.value;
  }
}