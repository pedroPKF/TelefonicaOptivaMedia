/**
 * @description       : 
 * @author            : marcos.acuna@blueway.es
 * @group             : 
 * @last modified on  : 02-09-2022
 * @last modified by  : marcos.acuna@blueway.es
**/
public class AccountTriggerHandler implements ITriggerHandler {
    public static Boolean Bypass = false;
    
    public void BeforeInsert(TriggerDispatcher.TriggerParameters tp){
    }
	public void BeforeUpdate(TriggerDispatcher.TriggerParameters tp){
        AccountTriggerHelper.updateFirstNameLastName(tp);
    }
	public void BeforeDelete(TriggerDispatcher.TriggerParameters tp){

    }
	public void AfterInsert(TriggerDispatcher.TriggerParameters tp){

    }
	public void AfterUpdate(TriggerDispatcher.TriggerParameters tp){
        AccountTriggerHelper.actualizarCuenta(tp);
        AccountTriggerHelper.updateZipCodde(tp);
        //AccountTriggerHelper.ModificacionDatosPersonales(tp);
    }
	public void AfterDelete(TriggerDispatcher.TriggerParameters tp){

    }
	public void AfterUndelete(TriggerDispatcher.TriggerParameters tp){

    }
    public Boolean IsDisabled(){
        if(Bypass) return true;
        return false;
    }
}