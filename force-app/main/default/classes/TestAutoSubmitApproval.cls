public with sharing class TestAutoSubmitApproval {
    @isTest static void TestCreateContact() {
        //Setup Test Data
        Contact contact = TestDataFactory.ContactDataFactory(0);

        //Perform Insert DB Test
        Test.startTest();
        Database.SaveResult result = Database.insert(contact, false);
        Test.stopTest();

        //Verify the trigger inf
        if(result.isSuccess()) {
            System.debug('Test Create Contact Success - Id: ' + result.id);
        } else {
            // Operation failed, so get all errors                
            for(Database.Error err : sr.getErrors()) {
                System.debug('The following error has occurred.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Account fields that affected this error: ' + err.getFields());
            }
        }
    }
}