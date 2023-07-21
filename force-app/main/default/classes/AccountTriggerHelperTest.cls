@isTest
public with sharing class AccountTriggerHelperTest {
   
    @TestSetup
    static void makeData()
    {
        Account cuenta =  new Account();
        cuenta.Name ='Prueba';
        cuenta.DNI__c = 'x1234q';
        cuenta.Codigo_Postal__c ='28019';
        cuenta.BillingCountry='España';
        cuenta.BillingPostalCode='28019';
        insert cuenta;
        
        Account cuenta2 =  new Account();
        cuenta2.Name ='Prueba2';
        cuenta2.Codigo_Postal__c ='28019';
        cuenta2.BillingCountry='España';
        cuenta2.BillingPostalCode='28019';
        insert cuenta2;


        Contract contrato = new Contract();
        contrato.AccountId = cuenta2.id;
        contrato.status = 'Draft';
        insert contrato;

        Facturacion__c facturacion = new Facturacion__c();
        facturacion.Cliente__c = cuenta2.id;
        facturacion.Name = 'PruebaFacturacion';
        insert facturacion;

        String idTipoRegistroCuenta = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Consulta de oferta comercial').getRecordTypeId();

        Case caso = new Case();
        caso.RecordTypeId = idTipoRegistroCuenta;
        caso.AccountId = cuenta2.id;
        caso.Origin = 'Email';
        caso.Status = 'Nuevo';
        insert caso;


        Task tarea = new Task();
        tarea.WhatId= cuenta2.id;
        tarea.status = 'Open';
        tarea.Subject = 'PruebaTarea';
        insert tarea;

        EmailMessage email = new EmailMessage();
        email.RelatedToId = cuenta2.id;
        email.Subject ='pruebaEmail';
        email.ValidatedFromAddress ='adminsalesforce@blueway.es';
        email.FromName ='Soporte PKF-Attest';
        insert email;

        ContentNote cn = new ContentNote();
        cn.Title = 'test2';
        String body =  'Hello World';
        cn.Content = Blob.valueOf(body);
        insert cn;

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cn.id; 
        cdl.LinkedEntityId = cuenta2.Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;




    }

    @isTest 
    static void modificarCuenta()
    {
        Account cuenta= [SELECT Id, Name,Codigo_Postal__c,DNI__c FROM Account where name ='Prueba2'];
        cuenta.DNI__c= 'x1234q';
            update cuenta;
        
    }
}