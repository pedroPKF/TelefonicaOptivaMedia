/**
 * @description       : 
 * @author            : alvaro.solana@pkf-attest.es
 * @group             : 
 * @last modified on  : 26-09-2022
 * @last modified by  : alvaro.solana@pkf-attest.es
**/
public with sharing class ContractTriggerHelper {

    public static void actualizarContrato(TriggerDispatcher.TriggerParameters tp) {

        Blob key;
        Set<String> idContratos                     = new Set<String>();
        List<Clave_encriptacion__c> keyList         = new List<Clave_encriptacion__c>();
        
        try {

            //Obtengo la Key del custom settings para la encriptación, si no existe la creo.
            keyList = [ SELECT Clave__c FROM Clave_encriptacion__c LIMIT 1 ];

            if (!keyList.isEmpty()) {
                key = EncodingUtil.base64Decode(keyList[0].Clave__c);
            }else {
                Clave_encriptacion__c claveEncriptacion = new Clave_encriptacion__c();
                key = Crypto.generateAesKey(128);
                claveEncriptacion.Clave__c =  EncodingUtil.base64Encode(key);
                claveEncriptacion.Tiempo_validez_URL__c = 60;
                insert claveEncriptacion;
            }

            //Recorremos los contratos insertados o actualizados.
            
            for (Contract contratoNuevo : (List<Contract>)tp.newList) {
                Contract contratoVersionAnterior;
                if(tp.oldMapp != null) {
                    contratoVersionAnterior = (Contract) tp.oldMapp.get(contratoNuevo.Id);
                }
                if ((contratoNuevo.IsNewURL__c && !contratoVersionAnterior.IsNewURL__c) || contratoVersionAnterior == null)
                {
                    idContratos.add(contratoNuevo.Id);

                    String correoNuevo = contratoNuevo.Correo_nuevo__c;
                    //Si es nuevo
                    if(contratoVersionAnterior == null) {
                        correoNuevo = contratoNuevo.email_de_contrato__c;
                    }
                    String urlVerificacion = contratoNuevo.URL_verificacion__c;

                    String urlSubstringToCrypte = urlVerificacion.SubStringAfter('?') + '&email=' + correoNuevo;

                    contratoNuevo.URL_raiz_verificacion__c = urlVerificacion.substringBefore('?') + '?';
                    contratoNuevo.URL_path_encriptada__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES128', key, Blob.valueOf(urlSubstringToCrypte)));
                    
                    //Obtengo y encripto el correo
                    String urlCompleta =    contratoNuevo.URL_raiz_verificacion__c + contratoNuevo.URL_path_encriptada__c;
                    contratoNuevo.isEmailVerified__c = false;
                    //contratoNuevo.IsNewURL__c = false;
                    contratoNuevo.URL_verificacion__c = urlCompleta;
                    contratoNuevo.Inicio_de_validez_URL__c = DateTime.now();
                    contratoNuevo.Email_de_verificacion_enviado__c = false;
                }
             }

		}catch (Exception e) 
        {
            System.debug('Catch AfterUpdate [ContractTriggerHelper]');
            System.debug(e.getCause());
            System.debug(e.getMessage());
        }
    }
    public static void crearAlertaVerificacionEmail(TriggerDispatcher.TriggerParameters tp) {
        List<Alerta__c> alertas = new List<Alerta__c>();
        List<Contract> contratos = new List<Contract>();
        for(Contract contrato : (List<Contract>) tp.newList) {
            if(contrato.URL_verificacion__c != null && contrato.Tipo__c =='Suscriptor' && (tp.oldMapp == null || contrato.IsNewURL__c)) {
                Alerta__c alerta = new Alerta__c();
                alerta.Tipo__c = 'Verificación de email';
                alerta.Contract__c = contrato.Id;
                alerta.Account__c = contrato.AccountId;
                alertas.add(alerta);
                contratos.add(new Contract(Id = contrato.Id, IsNewURL__c = false));
            }
        }
        if(!alertas.isEmpty()) {
            insert alertas;
        }
        
        if(!contratos.isEmpty()) {
            update contratos;
        }
    }

    public static void EnvioEmailVerificacion(TriggerDispatcher.TriggerParameters tp) {

        for (Contract contratoNuevo : (List<Contract>)tp.newList) {
            if(!contratoNuevo.Email_de_verificacion_enviado__c && contratoNuevo.IsNewURL__c != null) {
                  //PENG 24/04/2023: esta parte de la llamada se queda comentado, ya se va hacer la funcion via Journey
                //envioEmailMKT(contratoNuevo.Id);
            }
        }
    }
    @future(callout=true)
    public static void envioEmailMKT(Id idContrato) {
   
        LlamadaMarketingCloud LMC = new LlamadaMarketingCloud(idContrato);
        LMC.Send_Email_Triggered();

    }
}