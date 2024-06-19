public class AnimalClass {
    @AuraEnabled
    public static List<Animal__c> getAnimals(String breedFilter, String ageFilter, String sexFilter, String shelterFilter) 
    {
        String query = 'SELECT Id, Name, Age__c, Breed__c, Photo__c, Sex__c, Shelter__r.Name FROM Animal__c';
        List<String> filters = new List<String>();

        if (!String.isBlank(breedFilter)) 
        {
            filters.add('Breed__c = :breedFilter');
        }

        if (!String.isBlank(ageFilter)) 
        {
            filters.add(ageFilter);
        }

        if (!String.isBlank(sexFilter)) 
        {
            filters.add('Sex__c = :sexFilter');
        }

        if (!String.isBlank(shelterFilter)) 
        {
            filters.add('Shelter__r.Name = :shelterFilter');
        }

        if (!filters.isEmpty()) 
        {
            query += ' WHERE ' + String.join(filters, ' AND ');
        }
        return Database.query(query);
    }

    @AuraEnabled
    public static List<Map<String, String>> getBreeds() 
    {
        List<Map<String, String>> breeds = new List<Map<String, String>>();
        Schema.DescribeFieldResult field = Animal__c.Breed__c.getDescribe();
        List<Schema.PicklistEntry> pickListVal = field.getPicklistValues();
        for (Schema.PicklistEntry picklist : pickListVal) 
        {
            breeds.add(new Map<String, String>{
                'label' => picklist.getLabel(),
                'value' => picklist.getValue()
            });
        }
        return breeds;
    }

    @AuraEnabled(cacheable=true)
    public static List<Object> getShelters() 
    {
        List<Object> shelters = new List<Object>();
        for (AggregateResult ar : [SELECT Shelter__r.Name shelterName FROM Animal__c WHERE Shelter__r.Name != null GROUP BY Shelter__r.Name]) 
        {
            String shelterName = (String)ar.get('shelterName');
            shelters.add(new Map<String, String>{'label' => shelterName, 'value' => shelterName});
        }
        return shelters;
    }
}