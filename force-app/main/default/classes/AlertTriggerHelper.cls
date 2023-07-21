public with sharing class AlertTriggerHelper {
    public static void envio_codigo_verificacion_datos(TriggerDispatcher.TriggerParameters tp) {

        for (Alerta__c alertaNueva : (List<Alerta__c>)tp.newList) {
            if(alertaNueva.URL_1__c != null && alertaNueva.URL_2__c != null && alertaNueva.Tipo__c =='Codigo de verificacion') {
                   //PENG 24/04/2023: esta parte de la llamada se queda comentado, ya se va hacer la funcion via Journey
                //envioEmailMKT(alertaNueva.Id);
            }
        }
    }

    @future(callout=true)
    public static void envioEmailMKT(Id idAlerta) {
   
        LlamadaMarketingCloud LMC = new LlamadaMarketingCloud(idAlerta);
        LMC.Send_Email_Triggered();

    }
}