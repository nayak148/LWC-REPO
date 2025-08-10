import { LightningElement } from 'lwc';
import AlarmClockAssets from '@salesforce/resourceUrl/AlarmClockAssets';
export default class Alarmclockapp extends LightningElement {

clockImage = AlarmClockAssets + '/AlarmClockAssets/clock.png';
ringtone = new Audio(AlarmClockAssets + '/AlarmClockAssets/Clocksound.mp3');


CurrentTime = ''; 
hour=[];
min=[];
ampm =['AP','PM'];

hourselected;
minuteselected;
ampmselected;
alaramTimeON;
isAlaramSet = false;
isalaramTriggered = false;



// console.log('hr array: ' + hour=[]);
// console.log("hr array: " + hour);
// console.log("min array:" + Min=[];);
// console.log("hr array:"  + hour);

//when this 3 fields get that data then the butten will apparies
 get  isFieldNotSelected(){
    return !(this.hourselected && this.minuteselected && this.ampmselected)
//     console.log("data entered in isFieldNotSelected")
  }


// LifeCycleHook;
connectedCallback(){
   this.creatHourOptions();
   this.creatMinutsOptions();

   this.CurrentTimeHandler()
   setInterval(()=>{
    this.CurrentTimeHandler()
   },1000)
}
CurrentTimeHandler(){
let DateTime = new Date() //returns current time and date
    let hour = DateTime.getHours() // returns current hour
    let min = DateTime.getMinutes() // returns current min
    let sec = DateTime.getSeconds() // returns current sec
    let mm = DateTime.getMilliseconds()
    let ampm = "AM"
    if(hour === 0){
        hour = 12
    }else if(hour === 12){
         ampm = "PM"
    }
    else if(hour >= 12){
        hour = hour-12 // after 12pm
        ampm = "PM"
    }
    hour = hour<10 ? "0" + hour : hour
    min = min<10 ? "0" + min : min 
    sec = sec<10 ? "0" + sec :sec
    this.CurrentTime = `${hour}: ${min}: ${sec}   ${ampm}`; //here '' this dots not works , `` this works
   //now Campare the clock value and set alaram
   if(this.isAlaramSet === `${hour}: ${min} ${ampm}`){
       console.log("alarmed Trigged");
       this.isalaramTriggered = true;
       this.ringtone.play();
       this.ringtone.loop = true;
   }
}
creatHourOptions(){
    for( let i = 1 ; i<= 12 ; i++){
        let val = i<10 ? "0" + i : i;
        this.hour.push(val);
        // console.log("hr array: " + val); 
    }
}
creatMinutsOptions(){
    for(let i = 0 ; i<= 59 ; i++){
        let val = i < 10 ? "0" + i : i;
        this.min.push(val);
    //  console.log("min array: " + val);   
    }
}
optionhandler(event){
    const {label,value} = event.detail
    if(label === "Hour(s)"){
        this.hourselected = value;
    }else if(label ==="Minute(s)"){
        this.minuteselected = value;
    }else if(label === "AM/PM"){
        this.ampmselected = value;
    }else { }
     console.log(" this.hourSelected : ",  this.hourselected)
     console.log(" this.minSelected : " ,  this.minuteselected)
     console.log(" this.ampmselected : ", this.ampmselected)
}
setAlaramHandle(){
    this.alaramTimeON = `${this.hourselected}: ${this.minuteselected}  ${this.ampmselected}` ;
    this.isAlaramSet = True;
    console.log("data entered in setAlaramHandle", this.alaramTimeON)

}
clearAlaramHandle(){
    this.alaramTimeON ='' ;
    this.isAlaramSet = false;
    this.minuteselected = '';
    this.ampmselected ='';
    this.hourselected ='';
    this.isalaramTriggered = false;
    this.ringtone.pause();
}
get shakeImage(){
    return this.isalaramTriggered ? 'shake':'' ;
}


}