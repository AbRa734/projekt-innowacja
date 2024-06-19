import { LightningElement, api, wire } from 'lwc';
import getShelter from '@salesforce/apex/mapController.getShelter'

export default class Map extends LightningElement {
    @api recordId;
    mapMarkers = [];

    @wire(getShelter, {shelterId : '$recordId'})
    wiredMap({ error, data }) {
        if(data) {
            this.mapMarkers = [
                {
                    location: {
                        Street: data.Street__c,
                        City: data.City__c,
                        Country: data.Country__c,
                        PostalCode: data.PostalCode__c
                    },
                    title: data.Name,
                    description:
                        data.City__c + ', ul.' + data.Street__c + '. Kod pocztowy: ' + data.PostalCode__c,
                },
            ];
        }
        else if(error) {
            console.error(error);
        }
    }
}