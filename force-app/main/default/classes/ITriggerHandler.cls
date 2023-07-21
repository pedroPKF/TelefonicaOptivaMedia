public interface ITriggerHandler {
	void BeforeInsert(TriggerDispatcher.TriggerParameters tp);
	void BeforeUpdate(TriggerDispatcher.TriggerParameters tp);
	void BeforeDelete(TriggerDispatcher.TriggerParameters tp);
	void AfterInsert(TriggerDispatcher.TriggerParameters tp);
	void AfterUpdate(TriggerDispatcher.TriggerParameters tp);
	void AfterDelete(TriggerDispatcher.TriggerParameters tp);
	void AfterUndelete(TriggerDispatcher.TriggerParameters tp);
	Boolean IsDisabled();
	//Test de despliegue en Int
}