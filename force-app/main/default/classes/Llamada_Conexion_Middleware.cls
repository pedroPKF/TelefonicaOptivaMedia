/*Clase para realizar las llamadas de los metodos de Integration_SFDC2EWS_Util
Peng 07/07/2022 */

public with sharing class Llamada_Conexion_Middleware {
    public static String namedCredentialMiddleware = 'Conexi_n_Middleware';
    public static String METHOD_GET = 'GET';
    public static String METHOD_POST = 'POST';
    public static String METHOD_PATCH = 'PATCH';
    public static Parametro_middleware_Marketing__mdt parametro = Parametro_middleware_Marketing__mdt.getInstance('Parametros');

    public static HttpResponse CallApiVersion(String APEX_CLASS, String APEX_METHOD) {
        Map<String, String> mapHeaders = new Map<String, String>();
        //mapHeaders.put('X-Api-Key','AjoSme1Y828ze2BQQSLiv1psHOhveZof7am8P6cQ');
        mapHeaders.put('X-Api-Key', parametro.X_api_key_Vindicia__c);

        HttpResponse respuesta = Integration_SFDC2EWS_Util.callRestWS(namedCredentialMiddleware, 'api/version', METHOD_GET, null, mapHeaders, APEX_CLASS, APEX_METHOD);
        
        return respuesta;
    }

  
    @future(callout=true)
    public static void ActualizacionConsentimientos(String idHistorico) {
        String namedCredentialConsentimiento = '';
        String APEX_CLASS1 = 'Llamada_Conexion_Middleware';
        String APEX_METHOD1 = 'ActualizacionConsentimientos';
        Historico_Individual__c hist = [SELECT id,Persona__c, Persona__r.Id_Externo__c,Fecha_y_Hora_de_Captacion_C111__c,Fecha_y_Hora_de_Captacion_C112__c
                                        ,Fecha_y_Hora_de_Captacion_C113__c,Fecha_y_Hora_de_Captacion_C114__c,Fecha_y_Hora_de_Captacion_C122__c ,Accion_C111__c,
                                        Accion_C112__c,Accion_C113__c,Accion_C114__c,Accion_C122__c,C111__c,C112__c,C113__c,C114__c,C122__c,Sistema_Consumer_C111__c
                                        ,Sistema_Consumer_C112__c,Sistema_Consumer_C113__c,Sistema_Consumer_C114__c,Sistema_Consumer_C122__c,Reason_C111__c
                                        ,Reason_C112__c,Reason_C113__c,Reason_C114__c,Reason_C122__c,Canal_C111__c,Canal_C112__c,Canal_C113__c,Canal_C114__c,
                                        Canal_C122__c
                                        FROM Historico_Individual__c WHERE id= :idHistorico];
        namedCredentialConsentimiento = 'salesforce/accounts/'+hist.Persona__r.Id_Externo__c+'/consents';

        Map<String, String> mapHeaders = new Map<String, String>();
        mapHeaders.put('X-Api-Key', parametro.X_api_key_Vindicia__c);
        Llamada_Conexion_Middleware_util.ListaIndividual request2 = new Llamada_Conexion_Middleware_util.ListaIndividual();
        request2 = Llamada_Conexion_Middleware_util.Consentimientos_body(hist);
        HttpResponse respuesta = Integration_SFDC2EWS_Util.callRestWS(namedCredentialMiddleware, namedCredentialConsentimiento, METHOD_PATCH, request2, mapHeaders, APEX_CLASS1, APEX_METHOD1);
    }

    @future(callout=true)
    public static void ActualizarCodPostalCliente(String idCuenta) {
        String namedCredentialConsentimiento = '';
        String APEX_CLASS1 = 'Llamada_Conexion_Middleware';
        String APEX_METHOD1 = 'ActualizarCodPostalCliente';

        namedCredentialConsentimiento = '/customers/'+idCuenta+'/postal-code';

        Map<String, String> mapHeaders = new Map<String, String>();
        mapHeaders.put('X-Api-Key', parametro.X_api_key_Vindicia__c);
        Llamada_Conexion_Middleware_util.codPostal request2 = new Llamada_Conexion_Middleware_util.codPostal();
        request2 = Llamada_Conexion_Middleware_util.zipCode_body(idCuenta);
        HttpResponse respuesta = Integration_SFDC2EWS_Util.callRestWS(namedCredentialMiddleware, namedCredentialConsentimiento, METHOD_PATCH, request2, mapHeaders, APEX_CLASS1, APEX_METHOD1);
    }
}