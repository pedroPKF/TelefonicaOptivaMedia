public class TriggerDispatcher {
    public static void Run(ITriggerHandler handler) {
        if (handler.IsDisabled()){return;}
        TriggerParameters tp = new TriggerParameters();
        tp.oldList=Trigger.old; 
        tp.newList=Trigger.new; 
        tp.oldMapp=Trigger.oldMap; 
        tp.newMapp=Trigger.newMap;
        if (Trigger.IsBefore ){
            if (Trigger.IsInsert)
            handler.BeforeInsert(tp);
            if (Trigger.IsUpdate)
            handler.BeforeUpdate(tp); 
            if (Trigger.IsDelete)
            handler.BeforeDelete(tp);
        }         
        if (Trigger.IsAfter) {
            if (Trigger.IsInsert)
            handler.AfterInsert(tp);
            if (Trigger.IsUpdate)
            handler.AfterUpdate(tp);
            if (Trigger.IsDelete)
            handler.AfterDelete(tp);
            if (Trigger.isUndelete)
            handler.AfterUndelete(tp);
        }
    }
    public class TriggerParameters{
        public List<SObject> oldList;
        public List<SObject> newList;
        public Map<Id,SObject> oldMapp;
        public Map<Id,SObject> newMapp;
    }
}