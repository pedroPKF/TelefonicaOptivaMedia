trigger ContractTrigger on Contract(before insert, before update, before delete, after insert, after update, after delete, after undelete){
    
    Bypass_flow__c customSetting = Bypass_flow__c.getInstance();
    
    if (customSetting != null && customSetting.isActive__c == false) {
        if(Trigger.isInsert) {
            for(Contract contrato : (List<Contract>) Trigger.new){
                if(contrato.From_converted__c) return;
            }
        }else if(Trigger.isUpdate) {
            for(Contract contrato : (List<Contract>) Trigger.old){
                if(contrato.From_converted__c) return;
            }
        }
        if(CheckRecursive.runOnce()){
            TriggerDispatcher.Run(new ContractTriggerHandler());
        }
    }
}