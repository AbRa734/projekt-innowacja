public with sharing class AdoptionTriggerHandler {
    public static void handleAfterInsert(List<Adoption__c> newList) {
        FreeFoodService.calculateFreeFoodPoints(newList);
        ShelterCountService.updateShelterCount(newList, false);
    }

    public static void handleAfterUpdate(Map<Id, Adoption__c> oldMap, List<Adoption__c> newList) {
        EmailService.sendAdoptionStatusChangeEmails(oldMap, newList);
        ShelterCountService.updateShelterCount(newList, false);
    }

    public static void handleBeforeDelete(Map<Id, Adoption__c> oldMap) {
        ShelterCountService.updateShelterCount(oldMap.values(), true);
    }
}
