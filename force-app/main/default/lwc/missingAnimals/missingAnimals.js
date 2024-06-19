import { LightningElement, api, wire } from 'lwc';
import getAllAnimalPhotos from '@salesforce/apex/MissingAnimals.getAllAnimalPhotos';

export default class GetDayDelta extends LightningElement {
    amount = 1;
    tempAmount = 1;
    mapData = new Map();
    mappedData = [];
    noAnimals = false;

    handleInputChange(e) { this.tempAmount = parseInt(e.detail.value, 10); }

    handleConfirmClick() { this.amount = this.tempAmount; }

    @wire(getAllAnimalPhotos, { day: '$amount' })
    wiredAnimals({ error, data }) {
        if (data) {
            const parsedData = JSON.parse(JSON.stringify(data));
            this.mapData = new Map(Object.entries(parsedData));
            this.mappedData = Array.from(this.mapData, ([key, value]) => ({ key, value }));
            this.noAnimals = this.mappedData.length === 0;
        } else if (error) {
            console.error('Error:', error);
            this.noAnimals = true;
        }
    }
}
