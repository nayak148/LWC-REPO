import { LightningElement, api } from 'lwc';
export default class ClockDropdown extends LightningElement {
     
@api label = '';
@api option = [];
@api uniqueID = '';

changeHandler(event){
    this.callParent(event.target.value)
    console.log(this.label);
    console.log(event.target.value);
}
callParent(){
this.dispatchEvent ( new customEvent('optionhandler',{
        detail:{
            label: this.label,
            value:value
        }
    }))
}


}