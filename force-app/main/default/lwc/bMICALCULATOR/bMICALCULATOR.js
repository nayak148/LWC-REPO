import { LightningElement } from 'lwc';

export default class BMICALCULATOR extends LightningElement {
height ='';
weight = '';
BMI   = null;
result ='';

handleInputChange(event) {
        this.height= event.target.value;
}

handleInputChange(event) {
        this.weight= event.target.value;
}

 GetHandleevent(event){
     this.event.preventDefault();
     console.log("Height :" +height);
     console.log("Weight :" +weight);
     this.handleClick();
 }

handleClick() {
      const height = number(this.height)/100;
      const weight = number(this.weight);
     
     if(height > 0 && weight >0 ){
         const BMI = weight(height*height);
          this.BMI = bmiValue;
         this.result = this.getBmiCategory(bmiValue);
         console.log("results :" +BMI);
     }else{
         this.BMI = null;
         this.result = 'Please enter valid weight and height values.';
     }
}

getBmiCategory(BMI){
         if(BMI < 18.5){
              return 'you are UnderWeight';
         }else if(BMI >18.5 && BMI < 24.9){
             return 'Yore are Healthy';
         }else if( BMI > 25.0 && BMI < 29.9){
             return 'You are OverWeight';
         }else{
             return 'You are Obese';
         }
     }


}