//DELETE ON MERGE!

trigger CalculateFreeFoodPoints on Adoption__c (after insert) {
	// List<Person__c> people = new List<Person__c>();
    // Map<Id, RecordType> recordTypes = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE SObjectType = 'Adoption__c']);
    
    // for(Adoption__c adop : [SELECT RecordType.Name, Person__r.Points__c From Adoption__c where Id IN : Trigger.new])
    // {
    //     if(adop.RecordTypeId != null)
    //     {
    //      	RecordType record = recordTypes.get(adop.RecordTypeId);
    //         if(record.Name == 'Virtual')
    //         {
    //             adop.Person__r.Points__c +=10;
    //         }
    //         if(record.Name == 'Real'){
    //             adop.Person__r.Points__c +=20;
    //         }
            
    //         if(adop.Person__r.Points__c >=30)
    //         {
    //             adop.Person__r.Points__c -=30;
    //             System.debug('Otrzymujesz darmowa karme!');
    //         }
            
    //         people.add(adop.Person__r);
    //     }
    // }
    // update people;
}