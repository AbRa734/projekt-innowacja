public with sharing class FreeFoodService {
    public static void calculateFreeFoodPoints(List<Adoption__c> newList) {
        Set<Id> personsIds = new Set<Id>();
    	List<Person__c> persons = new List<Person__c>();
        Map<Id, RecordType> recordTypes = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE SObjectType = 'Adoption__c']);
        
        for(Adoption__c adop : [SELECT RecordType.Name,Person__r.Points__c From Adoption__c where Id IN : newList])
        {
            if(adop.RecordTypeId != null)
            {
             	RecordType record = recordTypes.get(adop.RecordTypeId);
                if(record.Name == 'Virtual')
                {
                    adop.Person__r.Points__c +=10;
                }
                else if(record.Name == 'Real'){
                    adop.Person__r.Points__c +=20;
                }
                
                if(adop.Person__r.Points__c >=30)
                {
                    adop.Person__r.Points__c -=30;
                    System.debug('Otrzymujesz darmowa karme!');
                }
                if(!personsIds.contains(adop.Person__r.Id)) 
                { 
                    personsIds.add(adop.Person__r.Id); 
                    persons.add(adop.Person__r);
                }
            }
        }
        if(!persons.isEmpty()) 
        {
        	update persons;
    	}
    }
}
