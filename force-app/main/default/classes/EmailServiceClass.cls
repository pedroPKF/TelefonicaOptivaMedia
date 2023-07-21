/**
 * Autor: Pablo Sagredo 
 * Modificado en fecha 2022-09-22, Roberto Caprani
 * Version: 2.1
 * Descripcion: Analisis y relacion de correos entrantes (Case cuenta y contrato)
 */
global class EmailServiceClass implements Messaging.InboundEmailHandler {


	//declaramos la lista de attachment
	private static List<Attachment> attachments = new List<Attachment>();//20221116 Roberto Caprani

	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
		Messaging.InboundEnvelope envelope) {

		Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
	
		//VARS
		String recordId='';
		String body='';
		CaseMeta__mdt metad = CaseMeta__mdt.getInstance('Case1');
		Group obj = [SELECT Id FROM Group WHERE Name =: metad.NombreColaAsignacion__c AND Type = 'Queue' LIMIT 1];
		String QueueID = obj.Id;

		EmailMessage emailMessage = new EmailMessage();
		Log_Email_Service__c LogES = new Log_Email_Service__c();
		//MAIN

		//COMPROBAR QUE EL BODY NO ESTÉ VACIO
		try
		{

		
		if(email.plainTextBody!=null){
			body=email.plainTextBody;
			recordId=lookForObjectId(body);
			system.debug('ID OBTENIDO DEL BODY-->> ' + recordId);
			
			//CREAR OBJETO EMAIL MESSAGE COPIA DE INBOUND MESSAGE
			emailMessage.status = '0'; // email nuevo
			emailMessage.fromAddress = email.fromAddress; // from address
			emailMessage.fromName = email.fromName; // from name
			emailMessage.Subject = email.subject;
			emailMessage.HtmlBody = email.htmlBody;
			//Cambios 30/06/2023
			LogES.Contenido__c = email.htmlBody;
			LogES.Fecha_del_Mensaje__c = Date.Today();
			LogES.Subject__c = email.subject;
			

			if(recordId==null) {
				// 25/08/2022 pablo.gonzalez: anyadida inserccion de una nueva cuenta
				// 05/09/2022 pablo.gonzalez: UPDATE - Si no tiene registro relacionado, buscar contrato con el fromAddress
				
				Case c = new Case();
				
				List<Contract> contratos = [SELECT Id, email_de_contrato__c, AccountId 
											FROM Contract 
											WHERE email_de_contrato__c =: email.fromAddress order by CreatedDate DESC];
			
				if(!contratos.isEmpty()) {
					c.Contratos_relacionados__c = contratos[0].Id;
					c.AccountId = contratos[0].AccountId;
				}
				else {
					List<Account> cuentasAnonimas = [SELECT Id, Name FROM Account WHERE Name = 'Anónimo' OR Anonimo__c = true ];
					if(!cuentasAnonimas.isEmpty()) {
						c.AccountId = cuentasAnonimas[0].Id;  
					}
					else {
						Account cuenta = new Account();
						cuenta.LastName = 'Anónimo';
						cuenta.Anonimo__c = true;
						cuenta.RecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
						insert cuenta;
						
						c.AccountId = cuenta.Id;
					}
				}
				
				c.Subject = email.subject;
				c.Origin = 'Email';
				c.Status = 'New';
				c.SuppliedEmail=email.fromAddress;
				c.Description=email.plainTextBody;
				c.OwnerID=QueueID;
				insert c;

				//Cambios 30/06/2023
				LogES.Id_Relacionado__c = c.Id;
				LogES.Objeto__c = c.Id.getSObjectType().getDescribe().getName();
				//asociar correo a caso
				emailMessage.relatedToId =c.Id ;

			}else {
				// 22/09/2022 Roberto Caprani: anyadido --- Cuando se responda un correo que contenga la marca con el Id de un caso cerrado ***inicio
				//comprobamos que el recordId pasado partenezca a case
				Id idToProccess = recordId; 
				System.debug('-- Case Id not null: ' + idToProccess);
				Schema.sObjectType entityType = idToProccess.getSObjectType();
				//inicializamos un boolean para everiguar si se cumple la condicion que el email es un caso y dicho caso es closed
				Boolean casoEncontrado=false;
				if(entityType == Case.sObjectType){
					//buscamos el id con en cases y si esta cerrado
					Boolean isclosed=true;//buscar con IsCLosed
					List<Case> casoViejo=[SELECT Id,IsClosed,Status, Subject,AccountId,Codigo_de_factura__c,Codigo_tarjeta_proporcionado__c,Codigo_utilizado__c,Comments,ContactEmail,Subtype__c
									,ContactFax,ContactId,ContactMobile,ContactPhone,Contenido__c,Contratos_relacionados__c,Correo__c,CurrentHoldTime__c,Description,DNI_proporcionado__c,
									Nombre_proporcionado__c,Nuevo_codigo_proporcionado__c,Origin,Priority,RecordTypeId,SuppliedEmail,SuppliedName,SuppliedPhone,Type,Usuario_proporcionado__c,
									Usuarios_dado_de_baja__c FROM Case WHERE Id=:recordId LIMIT 1];
					if (!casoViejo.isEmpty() && casoViejo[0].IsClosed == isclosed){
						casoEncontrado=true;
						System.debug('--- caso viejo: ' + JSON.serializePretty(casoViejo));
						Case casoNuevo = new Case();
						casoNuevo.Subject=casoViejo[0].Subject;     
						casoNuevo.AccountId=casoViejo[0].AccountId;                 
						casoNuevo.Codigo_de_factura__c=casoViejo[0].Codigo_de_factura__c;
						casoNuevo.Codigo_tarjeta_proporcionado__c=casoViejo[0].Codigo_tarjeta_proporcionado__c;
						casoNuevo.Codigo_utilizado__c=casoViejo[0].Codigo_utilizado__c;
						casoNuevo.Comments=casoViejo[0].Comments;
						casoNuevo.ContactId=casoViejo[0].ContactId;
						casoNuevo.Contratos_relacionados__c=casoViejo[0].Contratos_relacionados__c;
						casoNuevo.Correo__c=casoViejo[0].Correo__c;
						casoNuevo.CurrentHoldTime__c=casoViejo[0].CurrentHoldTime__c;
						casoNuevo.Description = email.plainTextBody;
						casoNuevo.DNI_proporcionado__c=casoViejo[0].DNI_proporcionado__c;
						casoNuevo.Nombre_proporcionado__c=casoViejo[0].Nombre_proporcionado__c;
						casoNuevo.Nuevo_codigo_proporcionado__c=casoViejo[0].Nuevo_codigo_proporcionado__c;
						casoNuevo.Origin=casoViejo[0].Origin;
						casoNuevo.Priority=casoViejo[0].Priority;
						casoNuevo.RecordTypeId=casoViejo[0].RecordTypeId;
						casoNuevo.SuppliedEmail=casoViejo[0].SuppliedEmail;
						casoNuevo.SuppliedName=casoViejo[0].SuppliedName;
						casoNuevo.SuppliedPhone=casoViejo[0].SuppliedPhone;
						casoNuevo.Type=casoViejo[0].Type;
						casoNuevo.Usuario_proporcionado__c=casoViejo[0].Usuario_proporcionado__c;
						casoNuevo.Usuarios_dado_de_baja__c=casoViejo[0].Usuarios_dado_de_baja__c;
		  				casoNuevo.ParentId=casoViejo[0].Id;
						casoNuevo.OwnerID=QueueID;
						casoNuevo.Subtype__c = casoViejo[0].Subtype__c;
						insert casoNuevo;
						
						LogES.Id_Relacionado__c = casoNuevo.Id;
						LogES.Objeto__c = casoNuevo.Id.getSObjectType().getDescribe().getName();

						emailMessage.relatedToId=casoNuevo.Id;
						System.debug('--- caso insertado: ' + JSON.serializePretty(casoNuevo));
					}else if(!casoViejo.isEmpty() && casoViejo[0].Status == 'On Hold'){
                        //casoEncontrado=true;
                        //emailMessage.relatedToId=recordId;
                        casoViejo[0].OwnerID=QueueID;
                        update casoViejo;
                    }
				}
				// 22/09/2022 Roberto Caprani: anyadido --- Cuando se responda un correo que contenga la marca con el Id de un caso cerrado ***fin
				//si no hemos encontrado el caso
				if(!casoEncontrado){
					emailMessage.relatedToId=recordId;
					system.debug('ASIGNAR ID A CORREO (NO ES CASO)');
				}
			}
		}
		insert emailMessage;
		// Al asociar los attachments al email, automaticamente se adjuntan al record padre del email.
		setAttachment(email, emailMessage.Id);//Roberto Caprani 20221116
		System.debug(JSON.serializePretty(attachments));
		insert attachments;//Roberto Caprani 20221116
		
			//Cambios 30/06/2023
			LogES.Estado__c = 'OK';
			

		}
		Catch(Exception e)
		{
			LogES.Estado__c = 'KO';
			LogES.Mensaje_de_Error__c = e.getMessage() + ' ' + e.getLineNumber();
		
		}
		//FINAL
		result.success = true;
		insert LogES;
		return result;
	}


	//METODOS 

	//buscar el id en el correo
	public static String lookForObjectId(String txt){
		String recordId='';
		recordId=txt.substringBetween('##REF:[', ']##');
		return recordId;
	}


	//añade los attachment a la lista de attachment
	public static void setAttachment(Messaging.InboundEmail email,Id parentId){
		if(email.textAttachments != null) {
			// Save attachments, if any
			for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
				Attachment attachment = new Attachment();
				
				attachment.Name = tAttachment.fileName;
				attachment.Body = Blob.valueOf(tAttachment.body);
				attachment.ParentId = parentId;
				attachments.add(attachment);
			}
		}
		if(email.binaryAttachments != null) {
			for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
				Attachment attachment = new Attachment();
				
				attachment.Name = bAttachment.fileName;
				attachment.Body = bAttachment.body;
				attachment.ParentId = parentId;
				attachments.add(attachment);
			}
		}
	}

}