public class MissingAnimalsManager {

    private static String token='';
    private static String client_id = '3MVG9KlmwBKoC7U0tQGO2yaWKdVkrhut3PJ.Z.dw3qjvqP0Y.fjc_lO_vj3782NIru2vJv9Nheuo4.w7UpDTo';
    private static String client_secret = 'B4B01B6A629E8543BF6156676991E29F0CED4C6830A6FDCDDC315AB4725A2836';
    private static String username = 'restuser@innowacja.rest.inn';
    private static String password = 'restInnowacja123ySNFCDdZkdKBOB7POKaZp9Sx4';
    private static String endpoint = 'https://cw-inn--inn.sandbox.my.salesforce.com/services/data/v58.0/query/?q=SELECT+Name,Breed__c,Age__c,Unique_Features__c,Disappearance_Date__c,Disappearance_Place__Latitude__s,Disappearance_Place__Longitude__s,Image_URL__c,Description__c,Found__c+FROM+Animal__c';

    public static String getToken() {
        String URL = 'https://cw-inn--inn.sandbox.my.salesforce.com/services/oauth2/token';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(URL);
        request.setMethod('POST');
        String requestBody = 'grant_type=password&client_id=' + client_id + '&client_secret=' + client_secret + '&username=' + username + '&password=' + password;
        request.setBody(requestBody);
    
        Http http = new Http();
        HttpResponse response = new HttpResponse();
        try {
            response = http.send(request);
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            if (response.getStatusCode() == 200) {
                String token = (String) results.get('access_token');
                return token;
            } else {
                throw new CalloutException('FAILED TO GET TOKEN: ' + response.getStatusCode() + ' - ' + response.getBody());
            }
        } catch (Exception e) {
            throw new CalloutException('FAILED TO GET TOKEN: ' + e.getMessage());
        }
    }

    @future(callout=true)
    public static void getMissingAnimals() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        token = getToken();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + token);
        
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> records = (List<Object>) resultMap.get('records');

            String allAnimalsDescription = '';
            Integer numberOfMissingAnimals = 0;
        
            for (Object record : records) {
                Map<String, Object> recordMap = (Map<String, Object>) record;
                
                if (recordMap.get('Found__c') == false) {
                    numberOfMissingAnimals++;

                    allAnimalsDescription += 'Animal ' + numberOfMissingAnimals + '\n' + 'Breed: ' + recordMap.get('Breed__c') + '\n' + 
                                    'Age: ' + recordMap.get('Age__c') + '\n' +
                                    'Unique features: ' + recordMap.get('Unique_Features__c') + '\n' +
                                    'Disappearance Date: ' + recordMap.get('Disappearance_Date__c') + '\n' +
                                    'Disappearance Place (Lat, Long): ' + recordMap.get('Disappearance_Place__Latitude__s') + ', ' + recordMap.get('Disappearance_Place__Longitude__s') + '\n' +
                                    'Image URL: ' + recordMap.get('Image_URL__c') + '\n' + 
                                    'Description: ' + recordMap.get('Description__c') + '\n\n';
                }
            }

            if (!String.isEmpty(allAnimalsDescription)) {
                Case c = new Case();
                c.Subject = 'Daily Report of Missing Animals';
                c.Description = 'Number of missing animals: ' + numberOfMissingAnimals + '\n\n' + allAnimalsDescription;
                c.Origin = 'API';
                c.Status = 'New';
                insert c;
            }

        } else {
            throw new CalloutException('FAILED TO CREATE CASES: ' + response.getStatusCode() + ' - ' + response.getBody());
        }

    }

}
