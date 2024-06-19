public with sharing class mapController {
    @AuraEnabled(Cacheable = true)
    public static Shelter__c getShelter(String shelterId) {
        return [SELECT Name, Country__c, City__c, PostalCode__c, Street__c FROM Shelter__c WHERE Id =: shelterId];
    }
}