public class AlertTriggerHandler implements ITriggerHandler{
          
        public void BeforeInsert(TriggerDispatcher.TriggerParameters tp){
        }
        public void BeforeUpdate(TriggerDispatcher.TriggerParameters tp){
        }
        public void BeforeDelete(TriggerDispatcher.TriggerParameters tp){

        }
        public void AfterInsert(TriggerDispatcher.TriggerParameters tp){
            AlertTriggerHelper.envio_codigo_verificacion_datos(tp);
        }
        public void AfterUpdate(TriggerDispatcher.TriggerParameters tp){

        }
        public void AfterDelete(TriggerDispatcher.TriggerParameters tp){

        }
        public void AfterUndelete(TriggerDispatcher.TriggerParameters tp){

        }
        public Boolean IsDisabled(){
           
            return false;
        }
}