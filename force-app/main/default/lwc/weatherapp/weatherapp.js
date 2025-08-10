import { LightningElement } from 'lwc';
const API_KEY = `ec8a2ba52b95697a8b9a04bc068ee98a`
import weatherAppIcons from '@salesforce/resourceUrl/weatherAppIcons'
export default class Weatherapp extends LightningElement {
   
    arrowbackIcon = weatherAppIcons +'/weatherAppIcons/arrow-back.svg'
    clearIcon = weatherAppIcons +'/weatherAppIcons/clear.svg'
    cloudIcon = weatherAppIcons + '/weatherAppIcons/cloud.svg'
    dropletIcon = weatherAppIcons + '/weatherAppIcons/droplet.svg'
    hazeIcon = weatherAppIcons + '/weatherAppIcons/haze.svg'
    mapIcon = weatherAppIcons + '/weatherAppIcons/map.svg'
    rainIcon = weatherAppIcons + '/weatherAppIcons/rain.svg'
    snowIcon   = weatherAppIcons + '/weatherAppIcons/snow.svg'
    stormIcon  = weatherAppIcons + '/weatherAppIcons/storm.svg'
    thermometerIcon = weatherAppIcons +'/weatherAppIcons/thermometer.svg'
        

resultdata = [];
cityname
loadingText ='' 
isError= false
response 



get dynamicClass(){
    // if isError = true ? green color or red color 
return this.isError ? 'error-msg':'success-msg'
}

searchhandler(event){
    this.cityname = event.target.value
}
submithandler(event){
    //stop refreshing
    event.preventDefault();
   //calling below method to featch the data
    this.fetchdata()

}

fetchdata(){
    this.isError = false
    this.loadingText ='featching Weather Details....'
    console.log("city name :" , this.cityname)
    
    //calling URL_API
    const URL = `https://api.openweathermap.org/data/2.5/weather?q=${this.cityname}&units=metric&appid=${API_KEY}`
    //do naot make mistake hear check put this and then twice
     fetch(URL)
     .then(res=>res.json())
     .then(result=> {
          this.weatherDetails(result)
         this.resultdata = result;
         console.log("json data from 3rd parety", JSON.stringify(result));
         console.log(JSON.stringify(this.resultdata))
     })
     .catch(error =>{
         this.isError = true
         console.error(" here is errror :" , error)
         console.error("some thing went wrong : ", Error)
     });

}
weatherDetails(info){
    if(info.cod === "404"){
        this.isError = true
        this.loadingText = `${this.cityname}  is not valid CityName`
    } else {
        this.loadingText= ''
        this.isError = false
        // loading the data
        const city = info.name
        const country = info.sys.country
        const {description , id} = info.weather[0]
        const {temp, feels_like, humidity} = info.main

        //here we are mapping
        this.response = {
            city: city,
            temperature:temp,
            description:description,
            location:`${city}, ${country}`,
            feels_like: math.floor(feels_like),
            humidity:`${humidity}%`
        }
    }
}
}