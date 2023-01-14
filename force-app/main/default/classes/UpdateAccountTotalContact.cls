public with sharing class UpdateAccountTotalContact {
    @InvocableMethod(label='UpdateAccountTotalContact')
    public static void UpdateAccountTotalContact(List<Id> Ids) {
		system.debug(Ids);        
        List<Account> accList = [Select Id, Name, Total_Contacts__c from Account where Id =:Ids];
        for(Account acc : accList)
        {
            if(acc.Total_Contacts__c != null)
            {
                acc.Total_Contacts__c++;
            } else {
                acc.Total_Contacts__c = 1;
            }
            update acc;
        }
    }
}