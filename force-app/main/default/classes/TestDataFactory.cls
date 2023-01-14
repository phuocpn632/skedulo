@isTest
public with sharing class TestDataFactory {
    @isTest
    public static ContactDataFactory(Integer number) {
        if(!number) {
            Contact contact = new Contact(
                                    AccountID='001Dn00000DHuUlIAL',
                                    Active__c=FALSE,
                                    Salutation='Mr.',
                                    LastName='Test Contact'
                                );
            //insert contact;
            return contact;
        }
    }
}