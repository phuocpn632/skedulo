trigger AutoSubmitApproval on Contact (after insert, after delete) {
    if(Trigger.isAfter && Trigger.isInsert) {	
    	for(Contact contact: trigger.new) {
            if(contact.AccountID != null && contact.Active__c == FALSE) {
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Auto Submit Approval for Contact');
                req.setObjectId(contact.Id);
                Approval.process(req);
            }
        }
    }
    
    if(Trigger.isAfter && Trigger.isDelete) {
        for(Contact contact: trigger.old) {
            if(contact.AccountID != null && contact.Active__c == TRUE) {
                Account acc = [SELECT Id, Total_Contacts__c FROM Account WHERE Id=:contact.AccountID];
                acc.Total_Contacts__c--;
                update acc;
            }
        }
    }
}