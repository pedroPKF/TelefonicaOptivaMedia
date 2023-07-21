@RestResource(urlMapping='/insertarFicheros/*')
global with sharing class Insertar_ficheros_caso {
	private final static String serviceName = 'insertarFicheros';
	private final static String APEX_CLASS = 'Insertar_ficheros_caso';
	private final static String APEX_METHOD = 'insertarFicheros';

	global class Response {
		webservice String message;
		webservice String status;
	}
  
	global class listaDeContentVersion{ 
		global List<contentV> ContentVersion        { get; set; }
		global String LinkedEntityId                { get; set; }
	}

	global class contentV{
		global String Title                         { get; set; }
		global String FileExtension                 { get; set; }   
		global String VersionData                   { get; set; }
	}

	@HttpPost 
	global static Response insertarFicheros(listaDeContentVersion listCV, Id recordId) {
		Map<String, Object> mapRequest = new Map<String, Object>();
		List<ContentVersion> listaCVInsertar = new List<ContentVersion>();
		List<ContentDocumentLink> conDocInsertados= new List<ContentDocumentLink>();
		List<Id> listIDCV = new List<Id>();
		Log__c log = new Log__c();
		Response response = new Response();
	
		try{
		
			log.recordTypeId = Schema.SObjectType.Log__c.getRecordTypeInfosByDeveloperName().get('Inbound').getRecordTypeId();
			log.Endpoint_WS__c = 'services/data/v56.0/sobjects/ContentVersion/';
			log.Timestamp__c = System.now();
			log.Apex_Class_Name__c    = APEX_CLASS;
			log.Apex_Method_Name__c   = APEX_METHOD;
			log.Service_Name__c = 'insertarFicheros';
		
			if(!listCV.ContentVersion.isEmpty()) {
				for(contentV contentVersion : listCV.ContentVersion){
					ContentVersion cv = new ContentVersion();
					cv.Title = contentVersion.Title;
					cv.ContentLocation  = 'S';//El archivo relacionado con SF
					cv.versionData  =  EncodingUtil.base64Decode(contentVersion.versionData);
					cv.PathOnClient = contentVersion.Title + '.' + contentVersion.FileExtension;
					listaCVInsertar.add(cv);
				}
				if(!listaCVInsertar.isEmpty()) {
					insert listaCVInsertar;

					List<ContentVersion> ListaCVACtualizar = [SELECT ContentDocumentId FROM ContentVersion WHERE id =: listaCVInsertar];
			
					for(ContentVersion CvActualizar: ListaCVACtualizar){
						ContentDocumentLink cdl = new ContentDocumentLink();
						cdl.ContentDocumentId = CvActualizar.ContentDocumentId; 
						cdl.LinkedEntityId = recordId;
						cdl.ShareType = 'V';
						cdl.Visibility = 'AllUsers';
						conDocInsertados.add(cdl);
					}
					insert conDocInsertados;
					response.message = 'Se han linkado los archivos al registro indicado.';
					response.status= 'OK';
				}
			}
		} catch (Exception e) {
			response.message = 'Ha ocurrido un error técnico: ' + e.getMessage() + ' en la línea ' + e.getLineNumber();
			response.status = 'KO';
		}
		for(contentV attach : listCV.ContentVersion) {
			if(attach.VersionData.length() > 255) {
				attach.VersionData = 'Longitud de archivo truncada.';
			}
		}
		mapRequest.put('request', listCV);
		log.Request__c = JSON.serializePretty(mapRequest);
		log.Server_Response__c = response.status;
		log.Response_Body__c = response.message;
		log.Result__c = log.Server_Response__c == 'OK' ? 'Success' : 'Error';
		log.Result_Description__c = response.message ;
		log.Record_ID__c = recordId;
		insert log;
	
		return response;
	}
}