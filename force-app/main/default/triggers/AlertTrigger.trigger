trigger AlertTrigger on Alerta__c(before insert, before update, before delete, after insert, after update, after delete, after undelete){
    if(CheckRecursive.runOnce()){
        TriggerDispatcher.Run(new AlertTriggerHandler());
    }
    
}