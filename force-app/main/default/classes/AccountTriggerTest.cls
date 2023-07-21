/**
 * @description       : 
 * @author            : marcos.acuna@blueway.es
 * @group             : 
 * @last modified on  : 02-09-2022
 * @last modified by  : marcos.acuna@blueway.es
**/

@isTest
public class AccountTriggerTest {
   
    @TestSetup
    static void makeData()
    {
        List<Account> listCuentas                   = new List<Account>();
        //List<Contact> listContactos               = new List<Contact>();
        List<Contract> listContratos                = new List<Contract>();
        List<Task> listTareas                       = new List<Task>();
        List<Lead> listCandidatos                   = new List<Lead>();
        List<Case> listCasos                        = new List<Case>();
        List<Campaign> listCampanas                 = new List<Campaign>();
        List<CampaignMember> listMiembros           = new List<CampaignMember>();
        List<Alerta__c> listAlertas                 = new List<Alerta__c>();
        List<Individual> listConsentimientos        = new List<Individual>();
        List<ContentDocumentLink> listContDocs      = new List<ContentDocumentLink>();
        List<ContentNote> listContNotes             = new List<ContentNote>();
        List<Transaction__c> listTransac            = new List<Transaction__c>();

        Account cuenta =  new Account();
        cuenta.Name ='Prueba';
        cuenta.DNI__c = 'x1234q';
        cuenta.Codigo_Postal__c ='28020';
        cuenta.BillingCountry='España';
        cuenta.BillingPostalCode='28020';
        listCuentas.add(cuenta);

        Account cuenta2 =  new Account();
        cuenta2.Name ='Prueba2';
        cuenta2.Primer_apellido__c ='Prueba2';
        cuenta2.Segundo_apellido__c ='Prueba2';
        cuenta2.Codigo_Postal__c ='28020';
        cuenta2.BillingCountry='España';
        cuenta2.BillingPostalCode='28020';
        listCuentas.add(cuenta2);

        Account cuenta3 =  new Account();
        cuenta3.Name ='Prueba3';
        cuenta3.Primer_apellido__c ='Prueba3';
        cuenta3.Segundo_apellido__c ='Prueba3';
        cuenta3.phone = '999888777';
        cuenta3.Codigo_Postal__c ='28020';
        cuenta3.BillingCountry='España';
        cuenta3.BillingPostalCode='28020';
        listCuentas.add(cuenta3);

        Account cuenta4 =  new Account();
        cuenta4.Name ='Prueba4';
        cuenta4.Primer_apellido__c ='Prueba4';
        cuenta4.Segundo_apellido__c ='Prueba4';
        cuenta4.DNI__c = '12345L';
        cuenta4.phone = '999888777';
        cuenta4.Codigo_Postal__c ='28020';
        cuenta4.BillingCountry='España';
        cuenta4.BillingPostalCode='28020';
        listCuentas.add(cuenta4);

        Account cuenta5 =  new Account();
        cuenta5.Name ='Prueba5';
        cuenta5.Primer_apellido__c ='Prueba5';
        cuenta5.Segundo_apellido__c ='Prueba5';
        cuenta5.phone = '999888777';
        cuenta5.Codigo_Postal__c ='28020';
        cuenta5.BillingCountry='España';
        cuenta5.BillingPostalCode='28020';
        listCuentas.add(cuenta5);

        Account cuenta6 =  new Account();
        cuenta6.Name ='Prueba6';
        cuenta6.Primer_apellido__c ='Prueba6';
        cuenta6.Segundo_apellido__c ='Prueba6';
        cuenta6.phone = '999888777';
        cuenta6.Codigo_Postal__c ='28020';
        cuenta6.BillingCountry='España';
        cuenta6.BillingPostalCode='28020';
        listCuentas.add(cuenta6);

        insert listCuentas;

        ////////////////////////////////////////////

        Account cuenta7 =  new Account();
        cuenta7.Name ='Prueba7';
        cuenta7.Primer_apellido__c ='Prueba7';
        cuenta7.Segundo_apellido__c ='Prueba7';
        cuenta7.DNI__c = 'x1234q';
        cuenta7.phone = '999888777';
        cuenta7.Codigo_Postal__c ='28019';
        cuenta7.BillingCountry='España';
        cuenta7.BillingPostalCode='28020';
        cuenta7.Not_Active_Customer__c = true;
        insert cuenta7;
        Account cuenta8 =  new Account();
        cuenta8.Name ='Prueba8';
        cuenta8.Primer_apellido__c ='Prueba8';
        cuenta8.Segundo_apellido__c ='Prueba8';
        cuenta8.DNI__c = 'x1234q';
        cuenta8.phone = '999888777';
        cuenta8.Codigo_Postal__c ='28019';
        cuenta8.BillingCountry='España';
        cuenta8.BillingPostalCode='28020';
        cuenta8.Not_Active_Customer__c = true;
        insert cuenta8;
        Account cuenta9 =  new Account();
        cuenta9.Name ='Prueba9';
        cuenta9.Primer_apellido__c ='Prueba9';
        cuenta9.Segundo_apellido__c ='Prueba9';
        cuenta9.DNI__c = 'x1234q';
        cuenta9.phone = '999888777';
        cuenta9.Codigo_Postal__c ='28019';
        cuenta9.BillingCountry='España';
        cuenta9.BillingPostalCode='28020';
        cuenta9.Not_Active_Customer__c = true;
        insert cuenta9;
        Account cuenta10 =  new Account();
        cuenta10.Name ='Prueba10';
        cuenta10.Primer_apellido__c='Prueba10';
        cuenta10.Segundo_apellido__c='Prueba10';
        cuenta10.DNI__c = 'x1234q';
        cuenta10.phone = '999888777';
        cuenta10.Codigo_Postal__c ='28019';
        cuenta10.BillingCountry='España';
        cuenta10.BillingPostalCode='28020';
        cuenta10.Not_Active_Customer__c = true;
        insert cuenta10;
        Account cuenta11 =  new Account();
        cuenta11.Name ='Prueba11';
        cuenta11.Primer_apellido__c='Prueba11';
        cuenta11.Segundo_apellido__c='Prueba11';
        cuenta11.DNI__c = 'x1234q';
        cuenta11.phone = '999888777';
        cuenta11.Codigo_Postal__c ='28019';
        cuenta11.BillingCountry='España';
        cuenta11.BillingPostalCode='28020';
        cuenta11.Not_Active_Customer__c = true;
        insert cuenta11;
        Account cuenta12 =  new Account();
        cuenta12.Name ='Prueba12';
        cuenta12.Primer_apellido__c='Prueba12';
        cuenta12.Segundo_apellido__c='Prueba12';
        cuenta12.DNI__c = 'x1234q';
        cuenta12.phone = '999888777';
        cuenta12.Codigo_Postal__c ='28019';
        cuenta12.BillingCountry='España';
        cuenta12.BillingPostalCode='28020';
        cuenta12.Not_Active_Customer__c = true;
        insert cuenta12; 
           
        ////////////////////////////////////////////

        Contract contrato = new Contract();
        contrato.Id_Externo__c = 'Contrato1';
        contrato.AccountId = cuenta2.id;
        contrato.status = 'Draft';
        listContratos.add(contrato);

        Contract contrato2 = new Contract();
        contrato2.Id_Externo__c = 'contrato2';
        contrato2.AccountId = cuenta3.id;
        contrato2.status = 'Draft';
        listContratos.add(contrato2);

        Contract contrato3 = new Contract();
        contrato3.Id_Externo__c = 'contrato3';
        contrato3.AccountId = cuenta5.id;
        contrato3.status = 'Draft';
        listContratos.add(contrato3);

        Contract contrato4 = new Contract();
        contrato4.Id_Externo__c = 'contrato4';
        contrato4.AccountId = cuenta6.id;
        contrato4.status = 'Draft';
        listContratos.add(contrato4);

        insert listContratos;

        Task tarea = new Task();
        tarea.WhatId= cuenta2.id;
        tarea.status = 'Open';
        tarea.Subject = 'PruebaTarea';
        listTareas.add(tarea);

        Task tarea2 = new Task();
        tarea2.WhatId= cuenta3.id;
        tarea2.status = 'Open';
        tarea2.Subject = 'PruebaTarea';
        listTareas.add(tarea2);

        Task tarea3 = new Task();
        tarea3.WhatId= cuenta5.id;
        tarea3.status = 'Open';
        tarea3.Subject = 'PruebaTarea';
        listTareas.add(tarea3);

        Task tarea4 = new Task();
        tarea4.WhatId= cuenta6.id;
        tarea4.status = 'Open';
        tarea4.Subject = 'PruebaTarea';
        listTareas.add(tarea4);

        insert listTareas;

        Lead candidato = new Lead();
        candidato.LastName = 'candidato';
        candidato.Account_Created_from_Lead__c = cuenta2.Id;
        listCandidatos.add(candidato);

        Lead candidato2 = new Lead();
        candidato2.LastName = 'candidato2';
        candidato2.Account_Created_from_Lead__c = cuenta3.Id;
        listCandidatos.add(candidato2);

        Lead candidato3 = new Lead();
        candidato3.LastName = 'candidato3';
        candidato3.Account_Created_from_Lead__c = cuenta5.Id;
        listCandidatos.add(candidato3);

        Lead candidato4 = new Lead();
        candidato4.LastName = 'candidat4';
        candidato4.Account_Created_from_Lead__c = cuenta6.Id;
        listCandidatos.add(candidato4);

        insert listCandidatos;

        String idTipoRegistroCuenta = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Consulta de oferta comercial').getRecordTypeId();

        Case caso = new Case();
        caso.RecordTypeId = idTipoRegistroCuenta;
        caso.AccountId = cuenta2.id;
        caso.Origin = 'Email';
        caso.Status = 'Nuevo';
        listCasos.add(caso);

        Case caso2 = new Case();
        caso2.RecordTypeId = idTipoRegistroCuenta;
        caso2.AccountId = cuenta3.id;
        caso2.Origin = 'Email';
        caso2.Status = 'Nuevo';
        listCasos.add(caso2);

        Case caso3 = new Case();
        caso3.RecordTypeId = idTipoRegistroCuenta;
        caso3.AccountId = cuenta5.id;
        caso3.Origin = 'Email';
        caso3.Status = 'Nuevo';
        listCasos.add(caso3);

        Case caso4 = new Case();
        caso4.RecordTypeId = idTipoRegistroCuenta;
        caso4.AccountId = cuenta6.id;
        caso4.Origin = 'Email';
        caso4.Status = 'Nuevo';
        listCasos.add(caso4);

        insert listCasos;


        Campaign campana = new Campaign();
        campana.Name = 'Campana';
        listCampanas.add(campana);

        Campaign campana2 = new Campaign();
        campana2.Name = 'Campana2';
        listCampanas.add(campana2);

        insert listCampanas;
 
        /* 
            MIEMBROS CAMPAÑA
        */

        Alerta__c alerta = new Alerta__c();
        alerta.Account__c = cuenta2.id;
        listAlertas.add(alerta);

        Alerta__c alerta2 = new Alerta__c();
        alerta2.Account__c = cuenta3.id;
        listAlertas.add(alerta2);

        Alerta__c alerta3 = new Alerta__c();
        alerta3.Account__c = cuenta5.id;
        listAlertas.add(alerta3);

        Alerta__c alerta4 = new Alerta__c();
        alerta4.Account__c = cuenta6.id;
        listAlertas.add(alerta4);

        insert listAlertas;

        Individual consentimientoP1 = new Individual();
        consentimientoP1.LastName = 'consentimientoP1';
        consentimientoP1.C111__c = 'Pendiente';
        consentimientoP1.C112__c = 'Pendiente';
        consentimientoP1.C113__c = 'Pendiente';
        consentimientoP1.C114__c = 'Pendiente';
        consentimientoP1.C122__c = 'Pendiente';
        consentimientoP1.AccountRelationship__c = cuenta.Id;
        listConsentimientos.add(consentimientoP1);

        Individual consentimientoP2 = new Individual();
        consentimientoP2.LastName = 'consentimientoP2';
        consentimientoP2.C111__c = 'Pendiente';
        consentimientoP2.C112__c = 'Pendiente';
        consentimientoP2.C113__c = 'Pendiente';
        consentimientoP2.C114__c = 'Pendiente';
        consentimientoP2.C122__c = 'Pendiente';
        consentimientoP2.AccountRelationship__c = cuenta4.Id;
        listConsentimientos.add(consentimientoP2);

        Individual consentimiento = new Individual();
        consentimiento.LastName = 'consentimiento';
        consentimiento.C111__c = 'Pendiente';
        consentimiento.C112__c = 'Pendiente';
        consentimiento.C113__c = 'Pendiente';
        consentimiento.C114__c = 'Pendiente';
        consentimiento.C122__c = 'Pendiente';
        consentimiento.AccountRelationship__c = cuenta2.Id;
        listConsentimientos.add(consentimiento);

        Individual consentimiento2 = new Individual();
        consentimiento2.LastName = 'consentimiento2';
        consentimiento2.C111__c = 'Pendiente';
        consentimiento2.C112__c = 'Pendiente';
        consentimiento2.C113__c = 'Pendiente';
        consentimiento2.C114__c = 'Pendiente';
        consentimiento2.C122__c = 'Pendiente';
        consentimiento2.AccountRelationship__c = cuenta3.Id;
        listConsentimientos.add(consentimiento2);

        Individual consentimiento3 = new Individual();
        consentimiento3.LastName = 'consentimiento3';
        consentimiento3.C111__c = 'Pendiente';
        consentimiento3.C112__c = 'Pendiente';
        consentimiento3.C113__c = 'Pendiente';
        consentimiento3.C114__c = 'Pendiente';
        consentimiento3.C122__c = 'Pendiente';
        consentimiento3.AccountRelationship__c = cuenta5.Id;
        listConsentimientos.add(consentimiento3);

        Individual consentimiento4 = new Individual();
        consentimiento4.LastName = 'consentimiento4';
        consentimiento4.C111__c = 'Pendiente';
        consentimiento4.C112__c = 'Pendiente';
        consentimiento4.C113__c = 'Pendiente';
        consentimiento4.C114__c = 'Pendiente';
        consentimiento4.C122__c = 'Pendiente';
        consentimiento4.AccountRelationship__c = cuenta6.Id;
        listConsentimientos.add(consentimiento4);

        insert listConsentimientos;

        ContentNote cn = new ContentNote();
        cn.Title = 'test';
        String body =  'Hello World';
        cn.Content = Blob.valueOf(body);
        listContNotes.add(cn);

        ContentNote cn2 = new ContentNote();
        cn2.Title = 'test2';
        String body2 =  'Hello World';
        cn2.Content = Blob.valueOf(body2);
        listContNotes.add(cn2);

        ContentNote cn3 = new ContentNote();
        cn3.Title = 'test3';
        String body3 =  'Hello World';
        cn3.Content = Blob.valueOf(body3);
        listContNotes.add(cn3);

        ContentNote cn4 = new ContentNote();
        cn4.Title = 'test4';
        String body4 =  'Hello World';
        cn4.Content = Blob.valueOf(body4);
        listContNotes.add(cn4);

        insert listContNotes;

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cn.id; 
        cdl.LinkedEntityId = cuenta2.Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        listContDocs.add(cdl);

        ContentDocumentLink cdl2 = new ContentDocumentLink();
        cdl2.ContentDocumentId = cn2.id; 
        cdl2.LinkedEntityId = cuenta3.Id;
        cdl2.ShareType = 'V';
        cdl2.Visibility = 'AllUsers';
        listContDocs.add(cdl2);

        ContentDocumentLink cdl3 = new ContentDocumentLink();
        cdl3.ContentDocumentId = cn3.id; 
        cdl3.LinkedEntityId = cuenta5.Id;
        cdl3.ShareType = 'V';
        cdl3.Visibility = 'AllUsers';
        listContDocs.add(cdl3);

        ContentDocumentLink cdl4 = new ContentDocumentLink();
        cdl4.ContentDocumentId = cn4.id; 
        cdl4.LinkedEntityId = cuenta6.Id;
        cdl4.ShareType = 'V';
        cdl4.Visibility = 'AllUsers';
        listContDocs.add(cdl4);

        insert listContDocs;

        Transaction__c transaccion = new Transaction__c();
        transaccion.Cuenta_LookUp__c = cuenta2.id;
        listTransac.add(transaccion);

        Transaction__c transaccion2 = new Transaction__c();
        transaccion2.Cuenta_LookUp__c = cuenta3.id;
        listTransac.add(transaccion2);

        Transaction__c transaccion3 = new Transaction__c();
        transaccion3.Cuenta_LookUp__c = cuenta5.id;
        listTransac.add(transaccion3);

        Transaction__c transaccion4 = new Transaction__c();
        transaccion4.Cuenta_LookUp__c = cuenta6.id;
        listTransac.add(transaccion4);

        insert listTransac;

    }

    
    @isTest 
    static void modificarCuenta()
    {
        List<Account> ListCuentasActualizar = new List<Account>();
        List<Account> ListCuentas= [SELECT Id, Name,Codigo_Postal__c,DNI__c, phone FROM Account];
        Account cuenta2= [SELECT Id, Name,Codigo_Postal__c,DNI__c FROM Account where name ='Prueba2'];
      Individual Consentimiento = new Individual();
      Consentimiento.LastName = 'consentimientoP1';

        Consentimiento.C111__c = 'Aceptado';
        Consentimiento.C112__c = 'No Informado';
        Consentimiento.C113__c = 'Rechazado';
        Consentimiento.C114__c = 'Pendiente';
        Consentimiento.C122__c = 'Aceptado';
        Consentimiento.AccountRelationship__c =cuenta2.id;
        insert Consentimiento;
        for (Account cuenta : ListCuentas) {
            if(cuenta.DNI__c == null){
                if (cuenta.Name =='Prueba2' || cuenta.Name =='Prueba3' ) {
                    cuenta.DNI__c = 'x1234q';
                }else if (cuenta.Name =='Prueba5' || cuenta.Name =='Prueba6' ) {
                    cuenta.DNI__c = '12345L';
                }
                ListCuentasActualizar.add(cuenta);
            }
        }
        
        update ListCuentasActualizar;
    }

    @isTest 
    static void modificarCuenta2()
    {
        List<Account> ListCuentasActualizar = new List<Account>();
        List<Account> ListCuentas= [SELECT Id, Name,Codigo_Postal__c,DNI__c, phone, Nombre_de_Cliente__c,Primer_Apellido__c,Segundo_Apellido__c FROM Account];
        //Account cuenta= [SELECT Id, Name,Codigo_Postal__c,DNI__c FROM Account where name ='Prueba2'];
        
        for (Account cuenta : ListCuentas) {
            cuenta.Nombre_de_Cliente__c = 'NombreTest2022';
            cuenta.Primer_Apellido__c = 'Apellido1Test2022';
            cuenta.Segundo_Apellido__c = 'Apellido2Test2022';

            ListCuentasActualizar.add(cuenta);

            
        }
        
        update ListCuentasActualizar;
    }

    @isTest 
    static void modificarCuenta3()
    {
        List<Account> ListCuentasActualizar = new List<Account>();
        List<Account> ListCuentas= [SELECT Id, Name,Codigo_Postal__c,DNI__c, phone, Nombre_de_Cliente__c,Primer_Apellido__c,Segundo_Apellido__c FROM Account];
        //Account cuenta= [SELECT Id, Name,Codigo_Postal__c,DNI__c FROM Account where name ='Prueba2'];
        
        for (Account cuenta : ListCuentas) {
            cuenta.Nombre_de_Cliente__c = 'NombreTest2022';
            cuenta.Segundo_Apellido__c = 'Apellido2Test2022';
         

            ListCuentasActualizar.add(cuenta);

            
        }
        
        update ListCuentasActualizar;
    }

    @isTest 
    static void modificarCuenta4()
    {
        List<Account> ListCuentasActualizar = new List<Account>();
        List<Account> ListCuentas= [SELECT Id, Name,Codigo_Postal__c,DNI__c, phone, Nombre_de_Cliente__c,Primer_Apellido__c,Segundo_Apellido__c FROM Account];
        //Account cuenta= [SELECT Id, Name,Codigo_Postal__c,DNI__c FROM Account where name ='Prueba2'];
        
        for (Account cuenta : ListCuentas) {
            cuenta.Nombre_de_Cliente__c = 'NombreTest2022';
            cuenta.Primer_Apellido__c = 'Apellido1Test2022';
         

            ListCuentasActualizar.add(cuenta);

            
        }
        
        update ListCuentasActualizar;
    }
    // //Peng 12/12/2022
    // @isTest 
    // static void modificarConsentimiento()
    // {
  
    //     Account Cuenta= [SELECT Id FROM Account WHERE name ='Prueba2'];
   

      
    // }

    // @isTest 
    // static void ModificacionDatosPersonales()
    // {        
    //  
        
    //     List<Account> CuentaList= [SELECT Id, Name,Codigo_Postal__c,DNI__c, phone FROM Account limit 12];
    //     for (integer i=0 ; i<CuentaList.size() ; i++)
    //     {
    //      
    //         if (i<=0 && i <3)
    //             {CuentaList[i].Phone='0000000';}
    //         else if ((i>=3 && i <6)) 
    //             {CuentaList[i].Name='Juan';}
    //         else if ((i>=6 && i <9)) 
    //             {CuentaList[i].Codigo_Postal__c='00000';}
    //         else if ((i>=9 && i <12)) 
    //             {CuentaList[i].DNI__c='654asdfgh';}
    //     }
    //     update CuentaList;
    //  
    // }
}