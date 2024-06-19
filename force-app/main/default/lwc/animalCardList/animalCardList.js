import { LightningElement, track } from 'lwc';
import getAnimals from '@salesforce/apex/AnimalClass.getAnimals';
import getBreeds from '@salesforce/apex/AnimalClass.getBreeds';
import getShelters from '@salesforce/apex/AnimalClass.getShelters';

export default class AnimalCardList extends LightningElement {
    @track animals;
    @track breeds = [];
    @track ages = [
        { label: 'Up to 5 years', value: 'Age__c <= 5' },
        { label: 'Up to 10 years', value: 'Age__c <= 10' },
        { label: 'Over 10 years', value: 'Age__c > 10' }
    ];
    @track sexes = [
        { label: 'Male', value: 'Male' },
        { label: 'Female', value: 'Female' }
    ];
    @track shelters = [];
    @track error;
    @track breedFilter = '';
    @track ageFilter = '';
    @track sexFilter = '';
    @track shelterFilter = '';
    @track isSearchNotAvailable = false;
    @track isLoading = false; 

    connectedCallback() {
        this.isLoading = true; 
        Promise.all([
            this.loadBreeds(),
            this.loadShelters(),
            this.loadAnimals()
        ])
        .catch(error => {
            this.error = error;
        })
        .finally(() => {
            this.isLoading = false; 
        });
    }

    handleBreedChange(event) 
    {
        this.breedFilter = event.target.value;
        this.loadAnimals();
    }

    handleAgeChange(event) 
    {
        this.ageFilter = event.target.value;
        this.loadAnimals();
    }

    handleSexChange(event) 
    {
        this.sexFilter = event.target.value;
        this.loadAnimals();
    }

    handleShelterChange(event)
    {
        this.shelterFilter = event.target.value;
        this.loadAnimals();
    }

    loadAnimals() 
    {
        this.isLoading = true; 
        getAnimals({ breedFilter: this.breedFilter, ageFilter: this.ageFilter, sexFilter: this.sexFilter, shelterFilter: this.shelterFilter })
            .then(result => {
                this.animals = result;
                if (this.animals.length > 0) 
                {
                    this.isSearchNotAvailable = false;
                } else 
                {
                    this.isSearchNotAvailable = true;
                }
            })
            .catch(error => {
                this.isSearchNotAvailable = false;
                this.error = error;
            })
            .finally(() => {
                this.isLoading = false; 
            });
    }

    loadBreeds() {
        return getBreeds()
            .then(result => {
                this.breeds = result;
            })
            .catch(error => {
                this.error = error;
            });
    }

    loadShelters() {
        return getShelters()
            .then(result => {
                this.shelters = result;
            })
            .catch(error => {
                this.error = error;
            });
    }

    resetFilters() {
        this.isLoading = true; 
        this.breedFilter = '';
        this.ageFilter = '';
        this.sexFilter = '';
        this.shelterFilter = '';
        this.loadAnimals()
            .finally(() => {
                this.isLoading = false; 
            });
    }
}