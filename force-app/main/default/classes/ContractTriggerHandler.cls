/**
 * @description       : 
 * @author            : alvaro.solana@pkf-attest.es
 * @group             : 
 * @last modified on  : 26-09-2022
 * @last modified by  : alvaro.solana@pkf-attest.es
**/
public class ContractTriggerHandler implements ITriggerHandler {
    public static Boolean disabled = false;

    public void BeforeInsert(TriggerDispatcher.TriggerParameters tp){
        if(IsDisabled()) return;
        ContractTriggerHelper.actualizarContrato(tp);
    }
	public void BeforeUpdate(TriggerDispatcher.TriggerParameters tp){
        if(IsDisabled()) return;
        ContractTriggerHelper.actualizarContrato(tp);
    }
	public void BeforeDelete(TriggerDispatcher.TriggerParameters tp){

    }
	public void AfterInsert(TriggerDispatcher.TriggerParameters tp){
        if(IsDisabled()) return;
        ContractTriggerHelper.crearAlertaVerificacionEmail(tp);
    }
	public void AfterUpdate(TriggerDispatcher.TriggerParameters tp){
        if(IsDisabled()) return;
        ContractTriggerHelper.crearAlertaVerificacionEmail(tp);
    }
	public void AfterDelete(TriggerDispatcher.TriggerParameters tp){

    }
	public void AfterUndelete(TriggerDispatcher.TriggerParameters tp){

    }
    public Boolean IsDisabled(){
        if(disabled) return true;
        return false;
    }
}