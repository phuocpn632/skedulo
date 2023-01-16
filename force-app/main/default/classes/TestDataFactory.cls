@isTest
public with sharing class TestDataFactory {
    @isTest
    public static Contact ContactDataFactory() {
        Contact contact = new Contact(
                                AccountID='001Dn00000DHuUlIAL',
                                Active__c=FALSE,
                                Salutation='Mr.',
                                LastName='Test Contact'
                            );

        return contact;
    }

    @isTest
    public static List<Contact> ContactsDataFactory() {
        List<Contact> contactList = new List<Contact> {};
        for(Integer i=0; i < 2; i++) {
            contactList.add(new Contact(
                                AccountID='001Dn00000DHuUlIAL',
                                Active__c=FALSE,
                                Salutation='Mr.',
                                LastName='Test Contact ' + i
                            ));
        }

        return contactList;
    }
}