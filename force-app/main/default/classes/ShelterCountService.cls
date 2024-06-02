public with sharing class ShelterCountService {
    public static void updateShelterCount(List<Adoption__c> adoptions, Boolean isDelete) {
        Map<Id, Integer> shelterCountMap = new Map<Id, Integer>();

        for (Adoption__c a : adoptions) {
            if (a.Animal__r.Shelter__r != null) {
                Id shelterId = a.Animal__r.Shelter__r.Id;
                Integer countChange = 0;

                if (a.Status__c == 'In progress' && a.RecordType.Name == 'Virtual') {
                    countChange = isDelete ? -1 : 1;
                } else if (a.Status__c == 'Approved' && a.RecordType.Name == 'Virtual' && !isDelete) {
                    countChange = -1;
                }

                if (shelterCountMap.containsKey(shelterId)) {
                    shelterCountMap.put(shelterId, shelterCountMap.get(shelterId) + countChange);
                } else {
                    shelterCountMap.put(shelterId, countChange);
                }
            }
        }

        if (!shelterCountMap.isEmpty()) {
            List<Shelter__c> sheltersToUpdate = new List<Shelter__c>();
            for (Id shelterId : shelterCountMap.keySet()) {
                Shelter__c shelter = new Shelter__c(Id = shelterId);
                shelter.Number_Of_Unadopted_Virtual_Animals__c = shelter.Number_Of_Unadopted_Virtual_Animals__c + shelterCountMap.get(shelterId);
                sheltersToUpdate.add(shelter);
            }
            update sheltersToUpdate;
        }
    }
}
