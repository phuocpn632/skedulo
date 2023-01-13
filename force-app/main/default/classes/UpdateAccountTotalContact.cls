public with sharing class UpdateAccountTotalContact {
    @InvocableMethod(label='UpdateAccountTotalContact')
    public static void UpdateAccountTotalContact(List<id> Ids) {        
        List<Account> accList = [Select Id, Name, Number_of_Contacts__c from Account where Id =:Ids];
        for(Account acc : accList)
        {
            //if(acc.Total_Contact__c != null)
            //{
                acc.Total_Contact__c = acc.Total_Contact__c + 1;
            //}
            update(acc);
        }
    }
}
