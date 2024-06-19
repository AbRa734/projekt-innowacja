trigger CountNumberOfAdoptions on Adoption__c (after update) {

    Map<Id, Shelter__c> shelterMap = new Map<Id, Shelter__c>();
    
    Map<Id, Adoption__c> triggeredAdoptions = new Map<Id, Adoption__c>( [SELECT Status__c, Animal__r.Shelter__r.Id, Animal__r.Shelter__r.Number_Of_Adoptions__c 
                                                                            FROM Adoption__c WHERE Id IN :trigger.newMap.keySet()]);

    Map<Id, List<Adoption__c>> shelterAdoptions = new Map<Id, List<Adoption__c>>();

    for (Adoption__c a : Trigger.new) {
        if (a.Status__c != Trigger.oldMap.get(a.Id).Status__c) {
            if (triggeredAdoptions.get(a.Id).Animal__r.Shelter__r != null) {
                Id shelterId = triggeredAdoptions.get(a.Id).Animal__r.Shelter__r.Id;
                shelterAdoptions.put(shelterId, new List<Adoption__c>{});
            }
        }
    }

    List<Adoption__c> adoptions = [SELECT Status__c, Animal__r.Shelter__r.Id, Animal__r.Shelter__r.Number_Of_Adoptions__c 
                                    FROM Adoption__c WHERE Animal__r.Shelter__r.Id IN :shelterAdoptions.keySet() AND Status__c = 'Approved'];

    for (Adoption__c a : adoptions) {
        Id shelterId = a.Animal__r.Shelter__r.Id;
        shelterAdoptions.get(shelterId).add(a);
    }

    for (Id shelterId : shelterAdoptions.keySet()) {
        Shelter__c shelter = new Shelter__c(Id = shelterId);
        shelter.Number_Of_Adoptions__c = shelterAdoptions.get(shelterId).size();
        shelterMap.put(shelterId, shelter);
    }

    update shelterMap.values();

}