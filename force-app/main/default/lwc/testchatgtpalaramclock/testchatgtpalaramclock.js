import { LightningElement, track } from 'lwc';

export default class AlarmClock extends LightningElement {
    @track currentTime;
    @track alarmTime = '--:--';
    alarmInput = '';

    connectedCallback() {
        this.updateTime();
        setInterval(() => {
            this.updateTime();
        }, 1000);
    }

    updateTime() {
        const date = new Date();
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');
        const seconds = String(date.getSeconds()).padStart(2, '0');
        this.currentTime = `${hours}:${minutes}:${seconds}`;

        if (this.alarmTime !== '--:--' && this.currentTime === this.alarmTime) {
            alert('Alarm Ringing!');
        }
    }

    handleAlarmInput(event) {
        this.alarmInput = event.target.value;
    }

    setAlarm() {
        this.alarmTime = this.alarmInput + ':00'; // assuming seconds are :00
    }
}