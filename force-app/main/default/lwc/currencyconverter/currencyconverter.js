import { LightningElement } from 'lwc';
import { countrycodelist } from 'c/countrycodelist'
import currencyConverterAssets from '@salesforce/resourceUrl/currencyConverterAssets'
export default class Currencyconverter extends LightningElement {
  
  currencyImage = currencyConverterAssets+ '/currencyConverterAssets/currency.svg';

  countrylist = countrycodelist
  countryFrom="USD"
  countryTo="INR"
  
  inp1='';
  result ;
  error ;



  handleChange(event){
      const {name, value} = event.target
      console.log("name", name)
      console.log("value", value)
      this[name] = value
  }
  submithandler(event){
    event.preventDefault();
    this.convert();
  }
  async convert(){
      // const API_URL = `https://api.exchangerate.host/convert?from=${this.countryFrom}&to=${this.countryTo}`;
     const API_KEY ='d0cb67f3b60f0ca924b829bf';
     const API_URL = `https://v6.exchangerate-api.com/v6/${API_KEY}/pair/${this.countryFrom}/${this.countryTo}`
      try{
        const data = await fetch(API_URL);
        this.jsonData = await data.json();
        // this.result = (Number(this.inp1)*jsonData.result).toFixed(2);
        this.result = (Number(this.amount) * jsonData.conversion_rate).toFixed(2)
        console.log(" j data : " + jsonData);
        console.log(jsonData);
        console.log("this j data: " +this.jsonData);

      }catch(error){
        console.log(error);
        this.error="An Error occored PLZ try later";
        console.log("this is error:" + Error);
        console.log("this is errpr2" + this.Error);
      }

  }

}