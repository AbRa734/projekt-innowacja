public with sharing class EmailService {
    public static void sendAdoptionStatusChangeEmails(Map<Id, Adoption__c> oldMap, List<Adoption__c> newList) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for (Adoption__c a : [SELECT Person__r.Name__c, Person__r.Surname__c, Person__r.Email__c, Status__c, Animal__r.Name FROM Adoption__c WHERE Id IN : newList]) {
            if (oldMap.get(a.Id).Status__c != a.Status__c) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] email = new String[] {a.Person__r.Email__c};
                String message = 'Good Morning ' + a.Person__r.Name__c + ' ' + a.Person__r.Surname__c + '.\nStatus of adoption for your animal ' + a.Animal__r.Name + ' has changed to ' + a.Status__c;
                mail.setToAddresses(email);
                mail.setSubject('Change of adoption status');
                mail.setPlainTextBody(message);
                mails.add(mail);
            }
        }
        Messaging.sendEmail(mails);
    }
}
