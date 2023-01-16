@isTest(SeeAllData=true)
public with sharing class TestAutoSubmitApproval {
    @isTest static void TestCreateContact() {
        //Setup Test Data
        Contact contact = TestDataFactory.ContactDataFactory();

        //Perform Insert DB Test
        Test.startTest();
        Database.SaveResult result = Database.insert(contact, false);
        // Validate Trigger execute and get current record Approval
        ProcessInstance instance = [SELECT Id
									FROM ProcessInstance
									WHERE TargetObjectId =:result.id
                                    AND Status='Pending'
                                    LIMIT 1];
        ProcessInstanceWorkitem workItem = [SELECT Id FROM ProcessInstanceWorkitem
											WHERE ProcessInstanceId=:instance.Id
                                            LIMIT 1];
        // Auto approve
        Approval.ProcessWorkItemRequest req = new Approval.ProcessWorkItemRequest();
		req.setWorkItemId(workItem.Id);
        req.setAction('Approve');
        req.setComments('Test Auto Approve');
        Approval.process(req);
        
        // Validate the Total Contacts updating
        Account acc = [SELECT Id, Total_Contacts__c FROM Account WHERE Id = '001Dn00000DHuUlIAL'];
        System.debug('Test Account Total Contact: ' + acc.Total_Contacts__c);
        Test.stopTest();

        //Verify the trigger inf
        if(result.isSuccess()) {
            System.debug('Test Create Contact Success - Id: ' + result.id);            
        } else {
            // Operation failed, so get all errors                
            for(Database.Error err : result.getErrors()) {
                System.debug('The following error has occurred.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Account fields that affected this error: ' + err.getFields());
            }
        }
    }

    @isTest static void TestCreateContacts() {
        //Setup Test Data
        List<Contact> contactList = TestDataFactory.ContactsDataFactory();

        //Perform Insert DB Test
        Test.startTest();
        Database.SaveResult[] results = Database.insert(contactList, false);
        
        Integer resultSize = results.size() > 0 ? results.size() : 1;
        List<Id> resultIds = new List<Id>();
        for (Database.SaveResult result : results) {
            if (result.isSuccess()) {
                resultIds.add(result.getId());
            }
        }
        
        system.debug(resultIds);
        // Validate Trigger execute and get current record Approval
        ProcessInstance[] instance = [SELECT Id
									FROM ProcessInstance
									WHERE TargetObjectId IN :resultIds
                                    AND Status='Pending'
                                    LIMIT :resultSize];
        
        Map<Id,ProcessInstance> insIds = new Map<Id,ProcessInstance>(instance);
        ProcessInstanceWorkitem[] workItems = [SELECT Id FROM ProcessInstanceWorkitem
											WHERE ProcessInstanceId IN :instance
                                            LIMIT :resultSize];

        // Auto approve
        List <Approval.ProcessWorkItemRequest> reqList = new List <Approval.ProcessWorkItemRequest>();                
        for(ProcessInstanceWorkitem workItem: workItems) {
            Approval.ProcessWorkItemRequest req = new Approval.ProcessWorkItemRequest();
            req.setWorkItemId(workItem.Id);
            req.setAction('Approve');
            req.setComments('Test Auto Approve');
            reqList.add(req);
        }

        Approval.process(reqList);

        // Validate the Total Contacts updating
        Account acc = [SELECT Id, Total_Contacts__c FROM Account WHERE Id = '001Dn00000DHuUlIAL'];
        System.debug('Test Account Total Contact: ' + acc.Total_Contacts__c);
        
        Test.stopTest();

        //Verify the trigger information
        for(Database.SaveResult result : results) {
            if(result.isSuccess()) {            
                System.debug('Test Create Contact Success - Ids: ' + result.getId());
            } else {
                // Operation failed, so get all errors                
                for(Database.Error err : result.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
        }
    }
}