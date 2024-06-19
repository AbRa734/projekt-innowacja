import { LightningElement, wire, api } from 'lwc';
import showHours from '@salesforce/apex/HoursController.showHours';

export default class OpeningHours extends LightningElement {
    @api recordId;
    hour;
    weekendHour;

    @wire(showHours, {shelterId : '$recordId'})
    wiredHours({ error, data }) {
        if (data) {
            this.hour = data.Time_Opened__c || 'Unavaliable';
            this.weekendHour = data.Time_Opened_On_Weekend__c || 'Unavaliable';
        } else if (error) {
            console.error(error);
        }
    }
}