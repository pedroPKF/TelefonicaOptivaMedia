public with sharing class HistoricoIndividualHelper {
      public static void callUpdateConsentimientos(TriggerDispatcher.TriggerParameters tp) {
        String profileName = [SELECT Name FROM Profile WHERE Id =:UserInfo.getProfileId()].Name;
        if(profileName == 'Integration User') {
            return;
        }
        for (Historico_Individual__c historicoIndividual : (List<Historico_Individual__c>)tp.newList) {
            if(historicoIndividual.DNI_Individual__c != null) {
                Llamada_Conexion_Middleware.ActualizacionConsentimientos(historicoIndividual.id);
            }
        }
    }
}