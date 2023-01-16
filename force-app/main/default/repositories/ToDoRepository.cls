public with sharing class ToDoRepository {
    @AuraEnabled(cacheable=true)
    public static List<To_Do__c> getToDoList(){
        String loginUserId = userInfo.getUserId();
        return [SELECT
            Id,
            Name,
            Contact__c,
            Actions__c,
            Status__c,
            CreatedDate            
            FROM To_Do__c
            WHERE CreatedById =:loginUserId
            ORDER BY CreatedDate DESC
            LIMIT 10
        ];
    }
}