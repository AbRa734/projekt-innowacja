public class AdoptionTriggerHelper 
{
    public static void updateShelterUnadoptedVirtualAnimals(Shelter__c shelter, Adoption__c adoption, Boolean isDelete, Boolean isUpdate, Boolean isInsert,String oldStatus) 
    {
        if (adoption.Status__c == 'In progress') 
        {
            if (isDelete) 
            {
                shelter.Number_Of_Unadopted_Virtual_Animals__c--;
            }
            else if (isInsert || adoption.Status__c != oldStatus) 
            {
                shelter.Number_Of_Unadopted_Virtual_Animals__c++;
            }
        }
        else if (adoption.Status__c == 'Approved' && isUpdate && adoption.Status__c != oldStatus) 
        {
            shelter.Number_Of_Unadopted_Virtual_Animals__c--;
        }
    }
}