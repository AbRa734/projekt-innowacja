public with sharing class HoursController {
    @AuraEnabled(Cacheable = true)
    public static Shelter__c showHours(String shelterId) {
        return [SELECT Time_Opened__c, Time_Opened_On_Weekend__c FROM Shelter__c WHERE Id =: ShelterId];
    }
}