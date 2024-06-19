trigger Count_Number_Of_Unadopted_Virtual_Animals on Adoption__c (after update, after insert, before delete) {
    Map<Id, Shelter__c> shelterMap = new Map<Id, Shelter__c>();    
    List<Adoption__c> adoptions;
    
    if(!trigger.isdelete) 
    {
        adoptions = [SELECT Status__c, Animal__r.Shelter__c, Animal__r.Shelter__r.Number_Of_Unadopted_Virtual_Animals__c,
                     RecordType.Name FROM Adoption__c WHERE Id IN: Trigger.new];
    } else 
    {
        adoptions = [SELECT Status__c, Animal__r.Shelter__c, Animal__r.Shelter__r.Number_Of_Unadopted_Virtual_Animals__c,
                     RecordType.Name FROM Adoption__c WHERE Id IN: Trigger.old];
    }
    
    for (Adoption__c a : adoptions) 
    {
        if (a.Animal__r.Shelter__c != null && a.RecordType.Name == 'Virtual') 
        {
            Id shelterId = a.Animal__r.Shelter__c;
            if(shelterMap.containsKey(shelterId))
            {
                Shelter__c shelter = shelterMap.get(shelterId);
				AdoptionTriggerHelper.updateShelterUnadoptedVirtualAnimals(shelter, a, trigger.isDelete, trigger.isUpdate, trigger.isInsert, trigger.isInsert ? null : Trigger.oldMap.get(a.Id).Status__c);

            }
            else
            {
                Shelter__c shelter = a.Animal__r.Shelter__r;
				AdoptionTriggerHelper.updateShelterUnadoptedVirtualAnimals(shelter, a, trigger.isDelete, trigger.isUpdate, trigger.isInsert, trigger.isInsert ? null : Trigger.oldMap.get(a.Id).Status__c);
                shelterMap.put(shelterId, shelter);
            }
        }
    }
    
    update shelterMap.values();
}