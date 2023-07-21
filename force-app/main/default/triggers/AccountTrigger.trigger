trigger AccountTrigger on Account(before insert, before update, before delete, after insert, after update, after delete, after undelete){
    
    Bypass_flow__c customSetting = Bypass_flow__c.getInstance();
    
    if (customSetting != null && customSetting.isActive__c == false) {
        if(Trigger.isInsert) {
            for(Account acc : (List<Account>) Trigger.new){
                if(acc.From_converted__c) return;
            }
        }else if(Trigger.isUpdate) {
            for(Account acc : (List<Account>) Trigger.old){
                if(acc.From_converted__c) return;
            }
        }
        if(CheckRecursive.runOnce()){
            TriggerDispatcher.Run(new AccountTriggerHandler());
        }
    }
}