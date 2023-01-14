public with sharing class UpdateAccountTotalContact {
    @InvocableMethod(label='UpdateAccountTotalContact')
    public static void UpdateAccountTotalContact(List<Id> Ids) {        
        List<Account> accList = [Select Id, Name, Total_Contacts__c from Account where Id =:Ids];
        for(Account acc : accList)
        {
            acc.Total_Contacts__c +=  Ids.size();
            update acc;
        }
    }
}