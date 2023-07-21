trigger Historico_Individual_trigger on Historico_Individual__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    Bypass_flow__c customSetting = Bypass_flow__c.getInstance();

    if (customSetting != null && customSetting.isActive__c == false) {
        if(CheckRecursive.runOnce()){
            TriggerDispatcher.Run(new HistoricoIndividualTriggerHandler());
        }
    }
}