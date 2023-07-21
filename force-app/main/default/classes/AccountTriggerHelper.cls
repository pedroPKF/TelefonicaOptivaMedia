/**
 * @description       : 
 * @author            : marcos.acuna@blueway.es
 * @group             : 
 * @last modified on  : 02-09-2022
 * @last modified by  : marcos.acuna@blueway.es
**/
public with sharing class AccountTriggerHelper {
    //Prueba diiff
    public static void actualizarCuenta(TriggerDispatcher.TriggerParameters tp){

         //Crear trigger after update en account que verificará si hay un cliente con el mismo DNI, se pasarán todos los datos relacionados al cliente existente: Tareas, contratos, emails, leads, casos, campañas

         Map<String, Account> mapCuentasPrincipales             = new Map<String, Account>();
         Map<Id, Account> mapCuentasPrincipalesId               = new Map<Id, Account>();
         Map<String, List<Account>> mapCuentasNuevas            = new Map<String, List<Account>>();
         Set<String> cuentasId                                  = new Set<String>();
         List<Account> listCuentasPrincipales                   = new List<Account>();
         List<Account> listCuentasActualizadas                  = new List<Account>();

         List<Task> listTareas                                  = new List<Task>();
         Map<String, List<Task>> mapTareas                      = new Map<String, List<Task>>();

         List<Contract> listContratos                           = new List<Contract>();
         List<Contract> listContratosActualizar                 = new List<Contract>();
         Map<String, List<Contract>> mapContratos               = new Map<String, List<Contract>>();
         Map<String, List<Contract>> mapContratosActualizar     = new Map<String, List<Contract>>();
         Map<String, String> mapContratosStatus                 = new Map<String, String>();
         Map<String, String> mapContratosIdExtern               = new Map<String, String>();

         List<Lead> listCandidatos                              = new List<Lead>();
         Map<String, List<Lead>> mapCandidatos                  = new Map<String, List<Lead>>();

         List<Case> listCasos                                   = new List<Case>();
         Map<String, List<Case>> mapCasos                       = new Map<String, List<Case>>();

         List<CampaignMember> listMiembrosCampanas              = new List<CampaignMember>();
         List<CampaignMember> listMiembrosCampanasPrincipales   = new List<CampaignMember>();
         Map<String, List<CampaignMember>> mapMiembrosCampanas  = new Map<String, List<CampaignMember>>();
         Map<String, List<CampaignMember>> mapMiembrosCampanasP = new Map<String, List<CampaignMember>>();
         Map<String, List<String>> mapCampanasInsertar          = new Map<String, List<Id>>();
         List<Id> listIdsCampanas                               = new List<Id>();   
         List<Alerta__c> listAlertas           		            = new List<Alerta__c>();
         Map<String, List<Alerta__c>> mapAlertas                = new Map<String, List<Alerta__c>>();
         List<Individual> listIndividual                        = new List<Individual>();
         List<Individual> listIndividualPrincipales             = new List<Individual>();
         Map<String, List<Individual>> mapIndividuals           = new Map<String, List<Individual>>();
         Map<String, List<Individual>> mapIndividualsPrinc      = new Map<String, List<Individual>>();
         Map<String, List<Individual>> mapIndividualsInsertar   = new Map<String, List<Individual>>();
         List<Individual> listIndividualInsertar                = new List<Individual>();
         List<ContentDocumentLink> conDoclist                   = new List<ContentDocumentLink>();
         Map<String, List<ContentDocumentLink>> mapCDL          = new Map<String, List<ContentDocumentLink>>();
         List<ContentDocumentLink> conDocInsertados             = new List<ContentDocumentLink>(); //ContentDocumentLink Insertadas
         List<ContentNote> contentNotes                         = new List<ContentNote>();
         Map<String, List<ContentNote>> mapCN                   = new Map<String, List<ContentNote>>(); 
         List<ContentNote> contentNotesBorrar                   = new List<ContentNote>(); 
         List<ContentNote> contentNotesInsertar                 = new List<ContentNote>(); //ContentNotes Insertadas
         Map<String, List<ContentNote>> mapCNInsertar           = new Map<String, List<ContentNote>>(); 
          
         Set<Id> accountIds= new Set<Id>(); 
         List<Transaction__c> listTransacciones                 = new List<Transaction__c>();
         Map<String, List<Transaction__c>> mapTransaciones      = new Map<String, List<Transaction__c>>();

         CampaignMember nuevoMiembroCampana;
         Individual consentimientoAux;
         Contract contratoAux;
 
         try {

            //Recorremos las cuentas actualizadas y almacenamos los datos.
             for (Account cuentaNueva : (List<Account>)tp.newList) {
                Account cuentaAntigua = (Account) tp.oldMapp.get(cuentaNueva.Id);
                if (String.isNotBlank(cuentaNueva.DNI__C) && cuentaNueva.DNI__C != cuentaAntigua.DNI__C ) {
                    cuentasId.add(cuentaNueva.Id);
                    if(!mapCuentasNuevas.containsKey(cuentaNueva.DNI__C)) {
                        mapCuentasNuevas.put(cuentaNueva.DNI__C, new List<Account>());
                    }
                    mapCuentasNuevas.get(cuentaNueva.DNI__C).add(cuentaNueva);
                }
             }

             if (!mapCuentasNuevas.isEmpty()) {
                 //Obtengo la lista de cuentas ACTUALIZADAS.                                        
                listCuentasActualizadas = [SELECT Id, DNI__C, Not_Active_Customer__c, PersonContactId, CreatedDate, Parent_account__c
                                             FROM Account 
                                             WHERE Id IN :cuentasId AND Not_Active_Customer__c = false];

                listCuentasPrincipales =[SELECT Id, DNI__C, Not_Active_Customer__c, PersonContactId, CreatedDate, Parent_account__c 
                                         FROM Account 
                                         WHERE DNI__C IN :mapCuentasNuevas.keySet() AND Not_Active_Customer__c = false AND Id NOT IN :cuentasId ];

                for (Account acc : listCuentasPrincipales) {
                    if(!mapCuentasPrincipales.containsKey(acc.DNI__C)) {
                        mapCuentasPrincipales.put(acc.DNI__C, acc);
                    }

                    if(!mapCuentasPrincipalesId.containsKey(acc.Id)) {
                        mapCuentasPrincipalesId.put(acc.Id, acc);
                    }
                }

                if (listCuentasActualizadas != null && !listCuentasActualizadas.isEmpty()) {
                    
                     listTareas = [SELECT Id, WhatId
                                     FROM Task 
                                     WHERE WhatId IN :listCuentasActualizadas order by CreatedDate DESC];

                    //Mapeo las tareas por la Id de la cuenta
                    for (Task tarea : listTareas) {

                        if(!mapTareas.containsKey(tarea.WhatId)) {
                            mapTareas.put(tarea.WhatId, new List<Task>());
                        }
                        mapTareas.get(tarea.WhatId).add(tarea);
                    }

                     listContratos = [SELECT Id, AccountId, Status, OwnerId, ActivatedById, ActivatedDate, Pricebook2Id, Name, IsDeleted, ContractNumber,
                                              CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, most_recent_refunds__c, most_recent_billing__c, Email_principal__c,Telefono_principal__c,
                                              fecha_de_baja__c, Cliente_de_baja__c, Tipo__c, cancel_reason__c, billing_day__c, Codigo_promocional__c, email_de_contrato__c,
                                              Mensaje__c, Contrato_activo__c, BypassValidation__c, Telefono_de_contrato__c, Id_Externo__c, Motivo_de_cancelacion__c, Fecha_Alta_Contrato__c
                                         FROM Contract 
                                         WHERE AccountId IN :listCuentasActualizadas AND Status != 'Cancelled' order by CreatedDate DESC];
                    
                    //Mapeo los Contratos por la Id de la cuenta
                    for (Contract contrato : listContratos) {

                        if(!mapContratos.containsKey(contrato.AccountId)) {
                            mapContratos.put(contrato.AccountId, new List<Contract>());
                        }
                        mapContratos.get(contrato.AccountId).add(contrato);
                    }
 
                     listCandidatos = [SELECT Id, Account_Created_from_Lead__c
                                         FROM Lead 
                                         WHERE Account_Created_from_Lead__c IN :listCuentasActualizadas order by CreatedDate DESC];

                    //Mapeo los Candidatos por la Id de la cuenta
                    for (Lead candidato : listCandidatos) {

                        if(!mapCandidatos.containsKey(candidato.Account_Created_from_Lead__c)) {
                            mapCandidatos.put(candidato.Account_Created_from_Lead__c, new List<Lead>());
                        }
                        mapCandidatos.get(candidato.Account_Created_from_Lead__c).add(candidato);
                    }
 
                     listCasos = [SELECT Id, AccountId, Status
                                     FROM Case 
                                     WHERE AccountId IN :listCuentasActualizadas order by CreatedDate DESC];

                    //Mapeo los Casos por la Id de la cuenta
                    for (Case caso : listCasos) {

                        if(!mapCasos.containsKey(caso.AccountId)) {
                            mapCasos.put(caso.AccountId, new List<Case>());
                        }
                        mapCasos.get(caso.AccountId).add(caso);
                    }

                    listMiembrosCampanas = [SELECT Id, AccountId, CampaignId, Status, Contact.AccountId
                                                 FROM CampaignMember 
                                                 WHERE Contact.AccountId IN :listCuentasActualizadas];

                    //Mapeo las MIembros Campaña por la Id de la cuenta
                    for (CampaignMember miembro : listMiembrosCampanas) {

                        if(!mapMiembrosCampanas.containsKey(miembro.Contact.AccountId)) {
                            mapMiembrosCampanas.put(miembro.Contact.AccountId, new List<CampaignMember>());
                        }
                        mapMiembrosCampanas.get(miembro.Contact.AccountId).add(miembro);
                    }

                    listMiembrosCampanasPrincipales = [SELECT Id, AccountId, CampaignId, Status, Contact.AccountId
                                                        FROM CampaignMember 
                                                        WHERE Contact.AccountId IN :listCuentasPrincipales];

                    //Mapeo las MIembros Campaña Principales por el Id de la cuenta
                    for (CampaignMember miembro : listMiembrosCampanasPrincipales) {

                        if(!mapMiembrosCampanasP.containsKey(miembro.Contact.AccountId)) {
                            mapMiembrosCampanasP.put(miembro.Contact.AccountId, new List<CampaignMember>());
                        }
                        mapMiembrosCampanasP.get(miembro.Contact.AccountId).add(miembro);
                    }
 
                     listAlertas = [SELECT Id, Account__c 
                                         FROM Alerta__c 
                                         WHERE Account__c IN :listCuentasActualizadas order by CreatedDate DESC];

                    //Mapeo las Alertas por la Id de la cuenta
                    for (Alerta__c alerta : listAlertas) {

                        if(!mapAlertas.containsKey(alerta.Account__c)) {
                            mapAlertas.put(alerta.Account__c, new List<Alerta__c>());
                        }
                        mapAlertas.get(alerta.Account__c).add(alerta);
                    }

                    listIndividual = [SELECT Id, AccountRelationship__c, C111__c, C112__c, C113__c, C114__c, C122__c
                                             FROM Individual 
                                             WHERE AccountRelationship__c IN :listCuentasActualizadas order by CreatedDate DESC];

                    listIndividualPrincipales = [SELECT Id, AccountRelationship__c, C111__c, C112__c, C113__c, C114__c, C122__c
                                                  FROM Individual 
                                                  WHERE AccountRelationship__c IN :listCuentasPrincipales order by CreatedDate DESC];

                    //Mapeo los Consentimientos por la Id de la cuenta
                    for (Individual consentimiento : listIndividual) {

                        if(!mapIndividuals.containsKey(consentimiento.AccountRelationship__c)) {
                            mapIndividuals.put(consentimiento.AccountRelationship__c, new List<Individual>());
                        }
                        mapIndividuals.get(consentimiento.AccountRelationship__c).add(consentimiento);
                    }

                    //Mapeo los Consentimientos Principales por la Id de la cuenta
                    for (Individual consentimiento : listIndividualPrincipales) {

                        if(!mapIndividualsPrinc.containsKey(consentimiento.AccountRelationship__c)) {
                            mapIndividualsPrinc.put(consentimiento.AccountRelationship__c, new List<Individual>());
                        }
                        mapIndividualsPrinc.get(consentimiento.AccountRelationship__c).add(consentimiento);
                    }

                    listTransacciones = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById,SystemModstamp, LastActivityDate, amount__c, item_type__c,
                                                  original_billing_date__c, item_description__c, Cuenta_LookUp__c, Contract_LookUp__c  
                                             FROM Transaction__c
                                             WHERE Cuenta_LookUp__c IN :listCuentasActualizadas order by CreatedDate DESC];

                    //Mapeo las transacciones por la Id de la cuenta
                    for (Transaction__c transaccion : listTransacciones) {

                        if(!mapTransaciones.containsKey(transaccion.Cuenta_LookUp__c)) {
                            mapTransaciones.put(transaccion.Cuenta_LookUp__c, new List<Transaction__c>());
                        }
                        mapTransaciones.get(transaccion.Cuenta_LookUp__c).add(transaccion);
                    }
                   
                    //Hago un bucle para añadir las id de las cuentas quitando la principal
                    for(Account addIDAccount : listCuentasActualizadas){
                        accountIds.add(addIDAccount.Id);
                        
                    }

                    Set<Id> contentDocumentIds = new Set<Id>();
                    conDoclist =[SELECT ContentDocumentId,LinkedEntityId 
                                    FROM ContentDocumentLink 
                                    WHERE LinkedEntityId IN :accountIds];

                    //Mapeo los ContentDocumentLink por la Id de la cuenta
                    for (ContentDocumentLink cdl : conDoclist) {

                        if(!mapCDL.containsKey(cdl.LinkedEntityId)) {
                            mapCDL.put(cdl.LinkedEntityId, new List<ContentDocumentLink>());
                        }
                        mapCDL.get(cdl.LinkedEntityId).add(cdl);
                    }
                    
                    for(ContentDocumentLink conDoc : conDoclist){
                        contentDocumentIds.add(conDoc.ContentDocumentId);
                    }


                    contentNotes = [SELECT Id, Title, Content from ContentNote where Id In: contentDocumentIds order by CreatedDate DESC];
                    //Mapeo los ContentNote por la Id del ContentDocumentLink
                    for (ContentNote cn : contentNotes) {

                        if(!mapCN.containsKey(cn.Id)) {
                            mapCN.put(cn.Id, new List<ContentNote>());
                        }
                        mapCN.get(cn.Id).add(cn);
                    }
                 }
                
                 for (Account cuenta : listCuentasActualizadas) {
                    //Si la cuenta no es la cuenta principal
                    if (mapCuentasPrincipales.containsKey(cuenta.DNI__c) && !mapCuentasPrincipalesId.containsKey(cuenta.Id) ) {
                        cuenta.Not_Active_Customer__c = true;                                      //Desactivamos la cuenta.     <<-----------------------------------------------
                        cuenta.Parent_account__c = mapCuentasPrincipales.get(cuenta.DNI__c).Id;

                        /* Traspasar tareas a la cuenta Principal */
                        if (mapTareas.containsKey(cuenta.Id)) {
                            for (Task tarea : mapTareas.get(cuenta.Id)) {
                                tarea.WhatId  = mapCuentasPrincipales.get(cuenta.DNI__c).Id;
                            }
                        }

                        /* Traspasar Candidatos - Lead a la cuenta Mas antigua */
                        if (mapCandidatos.containsKey(cuenta.Id)) {
                            for (Lead candidato : mapCandidatos.get(cuenta.Id)) {
                                candidato.Account_Created_from_Lead__c = mapCuentasPrincipales.get(cuenta.DNI__c).Id;
                            }
                        }
                        
                        /* Traspasar casos a la cuenta Mas antigua */
                        if (mapCasos.containsKey(cuenta.id)) {
                            for(Case caso : mapCasos.get(cuenta.Id)){
                                caso.AccountId = mapCuentasPrincipales.get(cuenta.DNI__c).Id;
                                caso.ContactId = mapCuentasPrincipales.get(cuenta.DNI__c).PersonContactId;
                                
                            }
                        }

                        /* Traspasar Alertas a la cuenta Mas antigua */
                        if (mapAlertas.containsKey(cuenta.Id)) {
                            for (Alerta__c alerta : mapAlertas.get(cuenta.Id)) {
                                alerta.Account__c = mapCuentasPrincipales.get(cuenta.DNI__c).Id;
                            }
                        }
                        
                        /* Traspasar Transacciones a la cuenta Mas antigua */
                        if (mapTransaciones.containsKey(cuenta.Id)) {
                            for (Transaction__c  transaccion : mapTransaciones.get(cuenta.Id)) {
                                transaccion.Cuenta_LookUp__c = mapCuentasPrincipales.get(cuenta.DNI__c).Id;
                            }
                        }
                
                        /* Traspasar contratos a la cuenta Mas antigua */
                        
                        if (mapContratos.containsKey(cuenta.id)) {
                            for (Contract contrato : mapContratos.get(cuenta.Id)) {

                                //Mapeo los Contratos por el DNI de la cuenta
                                if(!mapContratosActualizar.containsKey(cuenta.DNI__c)) {
                                    mapContratosActualizar.put(cuenta.DNI__c, new List<Contract>());
                                }
                                mapContratosActualizar.get(cuenta.DNI__c).add(contrato);

                                //Mapeo los estados de los contratos por el ID externo del contrato
                                if(!mapContratosStatus.containsKey(contrato.Id_Externo__c)) {
                                    mapContratosStatus.put(contrato.Id_Externo__c, contrato.Status);
                                }
                                //Mapeo los Id externos de los contratos por el ID del contrato
                                if(!mapContratosIdExtern.containsKey(contrato.Id)) {
                                    mapContratosIdExtern.put(contrato.Id, contrato.Id_Externo__c);
                                }

                                contrato.Status = 'Cancelled';
                                contrato.Id_Externo__c = 'ANT_'+contrato.Id_Externo__c;
                                contrato.Motivo_de_cancelacion__c = 'Traspasado';

                                listContratosActualizar.add(contrato);
                           }
                        }

                        /* Traspasar campañas a la cuenta Mas antigua */
                        if (mapMiembrosCampanas.containsKey(cuenta.Id)) {

                            for (CampaignMember miembroCampana : mapMiembrosCampanas.get(cuenta.Id)) {
                            
                                if(!mapCampanasInsertar.containsKey(cuenta.DNI__c)) {
                                    mapCampanasInsertar.put(cuenta.DNI__c,new List<ID>());
                                }
                                mapCampanasInsertar.get(cuenta.DNI__c).add(miembroCampana.CampaignId);
                            }
                        }

                        /* Traspasar Consentimientos a la cuenta Mas antigua */
                        if (mapIndividuals.containsKey(cuenta.id)) {
                            consentimientoAux = new Individual();
                            for (Individual consentimiento : mapIndividuals.get(cuenta.Id)) {
                                    
                                if(consentimiento.C111__c != null){
                                    consentimientoAux.C111__c = consentimiento.C111__c;
                                }
                                if(consentimiento.C112__c != null){
                                    consentimientoAux.C112__c = consentimiento.C112__c;
                                }
                                if(consentimiento.C113__c != null){
                                    consentimientoAux.C113__c = consentimiento.C113__c;
                                }
                                if(consentimiento.C114__c != null){
                                    consentimientoAux.C114__c = consentimiento.C114__c;
                                }
                                if(consentimiento.C122__c != null){
                                    consentimientoAux.C122__c = consentimiento.C122__c;
                                }
                            }

                            if(!mapIndividualsInsertar.containsKey(cuenta.DNI__c)) {
                                mapIndividualsInsertar.put(cuenta.DNI__c,new List<Individual>());
                            }
                            mapIndividualsInsertar.get(cuenta.DNI__c).add(consentimientoAux);
                        }

                        /* Traspasar Notas a la cuenta Mas antigua */ 
                        if (mapCDL.containsKey(cuenta.id)) {
                            for ( ContentDocumentLink cdl : mapCDL.get(cuenta.id)) {
                                if (mapcn.containsKey(cdl.ContentDocumentId)) {
                                    for (ContentNote cn : mapcn.get(cdl.ContentDocumentId)) {
                                        ContentNote cnAux = new ContentNote();
                                        cnAux.Title = cn.Title;
                                        String body =  cn.Content.toString();
                                        cnAux.Content = Blob.valueOf(body);
                                        contentNotesInsertar.add(cnAux);
                                        contentNotesBorrar.add(cn);

                                        if(!mapCNInsertar.containsKey(cuenta.DNI__c)) {
                                            mapCNInsertar.put(cuenta.DNI__c,new List<ContentNote>());
                                        }
                                        mapCNInsertar.get(cuenta.DNI__c).add(cnAux);
                                    }
                                }
                            }
                        }
                    }
                 }

                 if (listTareas != null) {
                    update listTareas;
                 }
                 
                 if (listCandidatos != null) {
                    update listCandidatos;
                 }

                 if (listCasos != null) {
                    update listCasos;
                 }

                 if (listAlertas != null) {
                    update listAlertas;
                 }

                 if (listTransacciones != null) {
                    update listTransacciones;
                 }

                 if (listContratosActualizar != null) {
                    
                    update listContratosActualizar;
                    listContratosActualizar.clear();
                 }

                 if (listMiembrosCampanas != null) {
                    delete listMiembrosCampanas;
                    listMiembrosCampanas.clear();
                 }

                 if (contentNotesInsertar != null) {
                    insert contentNotesInsertar;
                    delete contentNotesBorrar;
                 }
                 for (Account cuenta : listCuentasPrincipales) {
                    //Insertamos los miembros de campaña
                    if (mapCampanasInsertar.containsKey(cuenta.DNI__c)) {
                        if (mapMiembrosCampanasP.containsKey(cuenta.Id)) {
                            for (CampaignMember miembroCampana : mapMiembrosCampanasP.get(cuenta.Id)) {
                                for (String idCampana : mapCampanasInsertar.get(cuenta.DNI__c)) {
                                    if (idCampana != miembroCampana.CampaignId) {
                                        nuevoMiembroCampana = new CampaignMember(Id = null, CampaignId = idCampana, contactId = cuenta.PersonContactId, Status='Sent');
                                        listMiembrosCampanas.add(nuevoMiembroCampana);
                                    }
                                }
                            }
                        }else {
                            for (String idCampana : mapCampanasInsertar.get(cuenta.DNI__c)) {
                                nuevoMiembroCampana = new CampaignMember(Id = null, CampaignId = idCampana, contactId = cuenta.PersonContactId, Status='Sent');
                                listMiembrosCampanas.add(nuevoMiembroCampana);
                            }
                        }
                    }
                    
                    if (mapIndividualsInsertar.containsKey(cuenta.DNI__c) ) {
                        for (Individual consentimientoPrincipal : mapIndividualsPrinc.get(cuenta.Id)) {
                            
                            
                            for(Individual consentimientoInsert : mapIndividualsInsertar.get(cuenta.DNI__c)){
                                //Cambios Peng #40664 12/12/2022
                                if((consentimientoPrincipal.C111__c =='Rechazado' && consentimientoInsert.C111__c =='Rechazado')||
                                    (consentimientoPrincipal.C111__c =='Aceptado' && (consentimientoInsert.C111__c =='Rechazado' || consentimientoInsert.C111__c =='Aceptado'))||
                                    (consentimientoPrincipal.C111__c =='Pendiente' && (consentimientoInsert.C111__c !='No Informado'))||
                                    (consentimientoPrincipal.C111__c =='No Informado' && consentimientoInsert.C111__c != null)){
                                  consentimientoPrincipal.C111__c = consentimientoInsert.C111__c;
                                        
                                }
                                if((consentimientoPrincipal.C112__c =='Rechazado' && consentimientoInsert.C112__c =='Rechazado')||
                                (consentimientoPrincipal.C112__c =='Aceptado' && (consentimientoInsert.C112__c =='Rechazado' || consentimientoInsert.C112__c =='Aceptado'))||
                                (consentimientoPrincipal.C112__c =='Pendiente' && (consentimientoInsert.C112__c !='No Informado'))||
                                (consentimientoPrincipal.C112__c =='No Informado' && consentimientoInsert.C112__c != null)){
                                    consentimientoPrincipal.C112__c = consentimientoInsert.C112__c;
                                    
                                }
                                if((consentimientoPrincipal.C113__c =='Rechazado' && consentimientoInsert.C113__c =='Rechazado')||
                                (consentimientoPrincipal.C113__c =='Aceptado' && (consentimientoInsert.C113__c =='Rechazado' || consentimientoInsert.C113__c =='Aceptado'))||
                                (consentimientoPrincipal.C113__c =='Pendiente' && (consentimientoInsert.C113__c !='No Informado'))||
                                (consentimientoPrincipal.C113__c =='No Informado' && consentimientoInsert.C113__c != null)){
                                    consentimientoPrincipal.C113__c = consentimientoInsert.C113__c;
                                    
                                }   
                                if((consentimientoPrincipal.C114__c =='Rechazado' && consentimientoInsert.C114__c =='Rechazado')||
                                (consentimientoPrincipal.C114__c =='Aceptado' && (consentimientoInsert.C114__c =='Rechazado' || consentimientoInsert.C114__c =='Aceptado'))||
                                (consentimientoPrincipal.C114__c =='Pendiente' && (consentimientoInsert.C114__c !='No Informado'))||
                                (consentimientoPrincipal.C114__c =='No Informado' && consentimientoInsert.C114__c != null)){
                                    consentimientoPrincipal.C114__c = consentimientoInsert.C114__c;
                                    
                                }
                                if((consentimientoPrincipal.C122__c =='Rechazado' && consentimientoInsert.C122__c =='Rechazado')||
                                (consentimientoPrincipal.C122__c =='Aceptado' && (consentimientoInsert.C122__c =='Rechazado' || consentimientoInsert.C122__c =='Aceptado'))||
                                (consentimientoPrincipal.C122__c =='Pendiente' && (consentimientoInsert.C122__c !='No Informado'))||
                                (consentimientoPrincipal.C122__c =='No Informado' && consentimientoInsert.C122__c != null)){
                                    consentimientoPrincipal.C122__c = consentimientoInsert.C122__c;
                                    
                                }
                                // if(consentimientoInsert.C111__c != null){
                                //     consentimientoPrincipal.C111__c = consentimientoInsert.C111__c;
                                // }
                                // if(consentimientoInsert.C112__c != null){
                                //     consentimientoPrincipal.C112__c = consentimientoInsert.C112__c;
                                // }
                                // if(consentimientoInsert.C113__c != null){
                                //     consentimientoPrincipal.C113__c = consentimientoInsert.C113__c;
                                // }
                                // if(consentimientoInsert.C114__c != null){
                                //     consentimientoPrincipal.C114__c = consentimientoInsert.C114__c;
                                // }
                                // if(consentimientoInsert.C122__c != null){
                                //     consentimientoPrincipal.C122__c = consentimientoInsert.C122__c;
                                // }

                            }
                            listIndividualInsertar.add(consentimientoPrincipal);
                        }
                        
                    }

                    if (mapCNInsertar.containsKey(cuenta.DNI__c)) {
                        for (ContentNote cn : mapCNInsertar.get(cuenta.DNI__c)) {
                            ContentDocumentLink cdl = new ContentDocumentLink();
                            cdl.ContentDocumentId = cn.id; 
                            cdl.LinkedEntityId = cuenta.Id;
                            cdl.ShareType = 'V';
                            cdl.Visibility = 'AllUsers';
                            conDocInsertados.add(cdl);
                        }
                    }

                    if (mapContratosActualizar.containsKey(cuenta.DNI__C)) {
                        for (Contract contrato : mapContratosActualizar.get(cuenta.DNI__c)) {
                            //contratoAux = contrato;
                            if(mapContratosIdExtern.containsKey(contrato.Id)){
                                contrato.Id_Externo__c = mapContratosIdExtern.get(contrato.Id);
                                contrato.Id = null;
                                contrato.AccountId = cuenta.Id;
                                contrato.Status = 'Draft';
                                contrato.Motivo_de_cancelacion__c = null;
                                listContratosActualizar.add(contrato);
                            }
                        }
                    }
                 }

                 // Insertamos los miemnbros de campaña
                if (listMiembrosCampanas!=null) {
                    insert listMiembrosCampanas;
                }
                 // Actualizamos los consentimientos 
                if (listIndividualInsertar!=null) {
                    update listIndividualInsertar;
                }
                 // Insertamos los content document
                if (conDocInsertados!=null) {
                    insert conDocInsertados;
                }
                // Insertamos los contratos en la cuenta principal
                if (listContratosActualizar!=null) {
                    insert listContratosActualizar;
                    listContratosActualizar.clear();
                }

                for (Account cuenta : listCuentasPrincipales) {
                    if (mapContratosActualizar.containsKey(cuenta.DNI__C)) {
                        for (Contract contrato : mapContratosActualizar.get(cuenta.DNI__c)) {
                            if(mapContratosStatus.containsKey(contrato.Id_Externo__c)){
                                contrato.Status = mapContratosStatus.get(contrato.Id_Externo__c);
                                listContratosActualizar.add(contrato);
                            }
                        }
                    }
                }

                // Actualiza los contratos insertados con anterioridad en la cuenta principal
                if (listContratosActualizar!=null) {
                    update listContratosActualizar;
                }
                 update listCuentasActualizadas;
             }

         }catch (Exception e) {
            throw e;
         }

    }

    public static void updateFirstNameLastName(TriggerDispatcher.TriggerParameters tp){
     
        for (Account cuentaNueva : (List<Account>)tp.newList) {
            if ( cuentaNueva.Nombre_de_Cliente__c  != tp.oldMapp.get(cuentaNueva.Id).get('Nombre_de_Cliente__c') ){
                cuentaNueva.FirstName = cuentaNueva.Nombre_de_Cliente__c;
            }

            //Primer_Apellido__c
            //Segundo_Apellido__c
            if ( cuentaNueva.Primer_Apellido__c  != tp.oldMapp.get(cuentaNueva.Id).get('Primer_Apellido__c') ||
                cuentaNueva.Segundo_Apellido__c  != tp.oldMapp.get(cuentaNueva.Id).get('Segundo_Apellido__c')
            ){
                if(cuentaNueva.Segundo_Apellido__c != null){
                    cuentaNueva.LastName = cuentaNueva.Primer_Apellido__c +' '+ cuentaNueva.Segundo_Apellido__c;
                }else{
                    cuentaNueva.LastName = cuentaNueva.Primer_Apellido__c;
                }
            }
        }
    }

    //19/12/2022
    public static void updateZipCodde(TriggerDispatcher.TriggerParameters tp) {
       
            for (Account cuentaNueva : (List<Account>)tp.newList) {
                
                
                Account cuentaAntigua = (Account) tp.oldMapp.get(cuentaNueva.id);
                
                if(cuentaAntigua.BillingPostalCode != cuentaNueva.BillingPostalCode) {
                    
                    Llamada_Conexion_Middleware.ActualizarCodPostalCliente(cuentaNueva.Id_Externo__c);
                }
                
        }
    }

}