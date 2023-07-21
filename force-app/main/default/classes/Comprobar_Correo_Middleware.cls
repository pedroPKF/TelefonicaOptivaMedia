/**
 * @description       : 
 * @author            : alvaro.solana@pkf-attest.es
 * @group             : 
 * @last modified on  : 26-09-2022
 * @last modified by  : alvaro.solana@pkf-attest.es
**/
@RestResource(urlMapping='/comprobarCorreo/*')
global with sharing class Comprobar_Correo_Middleware {
    private final static String serviceName = 'comprobarCorreo';
    private final static String APEX_CLASS = 'Comprobar_Correo_Middleware';
    private final static String APEX_METHOD = 'recuperarDatos';

    global class ComprobarCorreoResponse {
		webservice String message;
        webservice String status;
	}

    @HttpPost
	global static ComprobarCorreoResponse recuperarDatos (String urlVerificacion) {
        //Registro de log
        Map<String, String> mapRequest = new Map<String, String>();
        mapRequest.put('request', urlVerificacion);
		Log__c log = new Log__c();
		log.recordTypeId = Schema.SObjectType.Log__c.getRecordTypeInfosByDeveloperName().get('Inbound').getRecordTypeId();
		log.Endpoint_WS__c = 'services/apexrest/' + serviceName;
		log.Timestamp__c = System.now();
		log.Apex_Class_Name__c    = APEX_CLASS;
		log.Apex_Method_Name__c   = APEX_METHOD;
		log.Service_Name__c = 'comprobarCorreo';
		log.Request__c = JSON.serializePretty(mapRequest);


        Blob key;
        Datetime tiempo_validez_URL;
        Clave_encriptacion__c keyObject;
        ComprobarCorreoResponse comprobarCorreoResponse = new ComprobarCorreoResponse();

        try {
            //Obtengo la key
            keyObject = [ SELECT Clave__c, Tiempo_validez_URL__c FROM Clave_encriptacion__c LIMIT 1 ];

            if (keyObject != null) {
                key = EncodingUtil.base64Decode(keyObject.Clave__c);
                Blob parameterToDecrypted = EncodingUtil.base64Decode(urlVerificacion.SubStringAfter('?'));
                Blob decryptedSuccess = Crypto.decryptWithManagedIV('AES128', key, parameterToDecrypted);
                String urlDesencrypted = decryptedSuccess.toString();

                String idExterno = urlDesencrypted.substringBetween('lite=', '&');

                //Busco el contrato mediante el idExterno
                Contract contract;
                List <Contract> contractList = new List <Contract> ();
                contractList = [
                                SELECT Id_Externo__c, URL_verificacion__c, email_de_contrato__c, isEmailVerified__c, Name, Correo_nuevo__c, Inicio_de_validez_URL__c
                                FROM Contract
                                WHERE Id_Externo__c =:idExterno 
                                LIMIT 1
                            ];
                
                
                //Compruebo si el contrato tiene la misma url que el request
                if (contractList.size() > 0 && contractList[0].URL_verificacion__c == urlVerificacion) {

                    contract = contractList[0];

                    //Compruebo si la url esta caducada
                    if ((DateTime.now().getTime() - contract.Inicio_de_validez_URL__c.getTime())/60000 > keyObject.Tiempo_validez_URL__c) {
                        comprobarCorreoResponse.status = 'KO';
                        comprobarCorreoResponse.message = 'La validez de la URL ha expirado.';
                    }else {
                            if(contract.isEmailVerified__c) {
                                comprobarCorreoResponse.status = 'KO';
                                comprobarCorreoResponse.message = 'Cliente con email verificado. ' + idExterno + ': ' + contract.email_de_contrato__c;
                            }
                            else {
                                contract.email_de_contrato__c = contract.Correo_nuevo__c;
                                contract.Name = contract.Correo_nuevo__c;
                                contract.Correo_nuevo__c = null;
                                contract.isEmailVerified__c = true;

                                ContractTriggerHandler.disabled = true;
                                update contract;
                                ContractTriggerHandler.disabled = false;

                                comprobarCorreoResponse.status = 'OK';
                                comprobarCorreoResponse.message = 'Se ha verificado correctamente el correo electrónico ' + contract.email_de_contrato__c;
                            }
                        }
                    
                } else if(contract == null) {
                    comprobarCorreoResponse.status = 'KO';
                    comprobarCorreoResponse.message = 'Cliente no encontrado.';
                }
            }else {
                comprobarCorreoResponse.status = 'KO';
                comprobarCorreoResponse.message = 'No se ha podido desencriptar URL. No se encuentra la clave de desencriptación.';
            }

		}catch (Exception e)  {
            comprobarCorreoResponse.status = 'KO';
            comprobarCorreoResponse.message = 'Error técnico en la línea: ' + e.getLineNumber() + '. ' + e.getMessage();
        }
        //Inserción de log 
        log.Server_Response__c = comprobarCorreoResponse.status;
        log.Response_Body__c = comprobarCorreoResponse.message;
        log.Result__c = log.Server_Response__c == 'OK' ? 'Success' : 'Error';
        insert log;
        List<Attachment> attachments = new List<Attachment>();
        attachments.add(new Attachment( Name = 'Request Server body.txt', Body = Blob.valueOf(JSON.serializePretty(mapRequest)), ParentId = log.Id));
        attachments.add(new Attachment( Name = 'Response body.txt', Body = Blob.valueOf(JSON.serializePretty(comprobarCorreoResponse)), ParentId = log.Id));
        insert attachments;
        return comprobarCorreoResponse;
	}
}