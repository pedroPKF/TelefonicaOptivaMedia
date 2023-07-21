public with sharing class LlamadaMarketingCloud {
    private Contract contrato;
    private Alerta__c alerta;
    private Parametro_middleware_Marketing__mdt LMM_mdt = [Select External_key_verification_email__c,External_key_verification_code__c,et_subdomain__c,et_clientId__c,et_clientSecret__c,et_mid__c from Parametro_middleware_Marketing__mdt where label =:'Parametros' LIMIT 1];
    String email;
    String URL_verificacion;
    String idContrato;
    String et_subdomain = string.valueof(LMM_mdt.et_subdomain__c);
    String et_clientId = string.valueof(LMM_mdt.et_clientId__c);
    String et_clientSecret =string.valueof(LMM_mdt.et_clientSecret__c);
    String et_mid = string.valueof(LMM_mdt.et_mid__c);
    String body_token =
     '{"grant_type": "client_credentials",'+ 
     '"client_id":"' + et_clientId +'",'+
     '"client_secret":"'+ et_clientSecret+'",'+
     '"account_id":"'+et_mid+'"}';
    private String body_Send_Email;
    private String fecha_Creacion;
    String codigo_verificacion;
    Map<String, String> mapHeaders = new Map<String, String>();
    private String Fecha_de_Creacion;
    private String Hora_de_Creacion;
    private String objectName;
    //Un solo parametro que sera el id de registro, dentro del constructor a que objeto pertenece check by id what objet is
    //cuando tenga nombre de objeto de id se hace query sobre contrato o alerta, recogiendo ese contrato o alerta
    //Crear un campo tipo texto codigo de verificacion en objeto alerta, en la query de alerta que recoja este campo y nombre y
    //fecha creacion 6329

    public LlamadaMarketingCloud(Id idRecord) {
        try{

       
        String objectName = idRecord.getSObjectType().getDescribe().getName();
        this.objectName = objectName;
        if(objectName == 'Contract'){
            contrato = [Select Id, Account.Name,Account.FirstName, URL_verificacion__c, Correo_nuevo__c from Contract where Id = :idRecord];
            this.contrato = contrato;
            this.email = contrato.Correo_nuevo__c;
            this.idContrato = contrato.id;

        }
        else if(objectName== 'Alerta__c'){
            alerta = [Select Contract__r.Account.FirstName ,contract__r.email_de_contrato__c,codigo_verificacion__c,URL_1__c,URL_2__c,Tipo__c,CreatedDate from Alerta__c where id =: idRecord];
            this.alerta = alerta;
            this.email = alerta.contract__r.email_de_contrato__c;
            DateTime dT = alerta.CreatedDate;
            String dtDay = String.valueOf(dT.day());
            String dayString = dtDay.length() == 1 ? '0' + dtDay : dtDay;
            String monthDay = String.valueOf(dT.month());
            String monthString = monthDay.length() == 1 ? '0' + monthDay : monthDay;
            this.Fecha_de_Creacion =dayString+'/'+monthString+'/'+dT.year();
            this.Hora_de_Creacion = dT.format('HH:mm');
        }
        this.LMM_mdt = LMM_mdt;
        this.body_Token = body_Token;
        
        this.body_send_email = getbody_Send_Email();
        this.mapHeaders = getaAccessToken(); 
    } catch(Exception e)
        {
        }
    }
    
    public String getbody_Send_Email(){
        String body_Send_Email =
         '{'+
          '  "To": {'+
          '     "Address": "'+this.email+'",'+
          '     "SubscriberKey": "'+this.email+'",'+
          '     "ContactAttributes": {'+
            '         "SubscriberAttributes": {';
            if(contrato!= null){

                body_Send_Email+='"Name":"'+ contrato.Account.FirstName+'", "URL":"' +contrato.URL_verificacion__c + '"';

            }
            else if(alerta!=null){
                body_Send_Email+='"UsuarioName":"' + alerta.Contract__r.Account.FirstName + '", "CodeVerificar":"' + alerta.codigo_verificacion__c + '",' +
                                '"Fecha_de_Creacion":"' + Fecha_de_Creacion + '", "Hora_de_Creacion":"' + Hora_de_Creacion+'" ,"URL_Codigo_de_Verificacion" :"'+alerta.URL_1__c+
                                '","URL_Nueva_Verificacion":"'+alerta.URL_2__c+'"';

                            }
            body_Send_Email+=    
                        '         }'+
                        '     }'+
                        '    }'+
                        '   }';
                return body_Send_Email;
    }

    public Map<String,String> getaAccessToken(){
    HttpRequest req = new HttpRequest();
    Http h = new Http();
     req.setEndpoint('https://'+LMM_mdt.et_subdomain__c+'.auth.marketingcloudapis.com/v2/token');
     req.setMethod('POST');
     req.setBody(body_token);
     req.setHeader('Content-Type', 'application/json');
     HttpResponse res = h.send(req);
     Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
     map<string,string> newMap= new Map<string,string>();

     if(m != null && !m.isEmpty()) {
        for(String key : m.keySet()) {
            //Busca el token de acceso para añadirlo al map
            if(key =='access_token')
            {
                //Sustituir postman token por Postman-Token, nombre de header para el envio de email
                newMap.put('Authorization', 'Bearer '+String.ValueOf(m.get(key)));
            }        
        }      
    }   
    return newMap;
    }

    public HttpResponse Send_Email_Triggered(){
        HttpRequest req = new HttpRequest();
        Http h = new Http();
        String externalKey;
        if(this.objectName == 'Contract'){
            externalKey=LMM_mdt.External_key_verification_email__c;
        }
        else if(this.objectName == 'Alerta__c'){
            externalKey=LMM_mdt.External_key_verification_code__c;

        }
       req.setEndpoint('https://'+LMM_mdt.et_subdomain__c+'.rest.marketingcloudapis.com/messaging/v1/messageDefinitionSends/key:'+externalKey+'/send');
        req.setMethod('POST');
        req.setBody(body_send_email);
        if(!mapHeaders.containsKey('Content-Type')) {
            mapHeaders.put('Content-Type', 'application/json');
        }
        //Añadir Aplication/json al mapeao de header
        if(mapHeaders != null && !mapHeaders.isEmpty()) {
			for(String key : mapHeaders.keySet()) {
               
				req.setHeader(key, mapHeaders.get(key));
			}           
		}
     

         HttpResponse res = h.send(req);
         if(this.objectName == 'Contract'){
            List<Contract> contratoActualizar = new List<Contract>();
            Contract contratoUpdate = [Select id,Email_de_verificacion_enviado__c from Contract where id =: this.idContrato];
                    contratoUpdate.Email_de_verificacion_enviado__c = true;
                    contratoActualizar.add(contratoUpdate);
            update contratoActualizar;
         }
     
        return res;
    }
    
}