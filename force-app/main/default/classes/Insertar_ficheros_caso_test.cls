@isTest
public with sharing class Insertar_ficheros_caso_test {
    @TestSetup
    static void makeData()
    {
       
        String idTipoRegistroCaso = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incidencia acceso al contenido').getRecordTypeId();

        Account cuenta =  new Account();
        cuenta.Name ='CuentaTest';
        cuenta.BillingCountry='España';
        cuenta.BillingPostalCode='28022';
        insert cuenta;
        
        //Crear un contrato
        Contract contrato = new Contract();
        contrato.Id_Externo__c = 'ContratoTest';
        contrato.isEmailVerified__c = false;
        contrato.AccountId = cuenta.id;
        ContractTriggerHandler.disabled =true;
        insert contrato;

         //Crear caso   
        Case caso = new Case();
        caso.type = 'Incidencia acceso al contenido';
        caso.recordTypeId = idTipoRegistroCaso;
        caso.subject = 'Test';
        caso.description = 'Test';
        caso.Contratos_relacionados__c = contrato.id;
        insert caso;
        
     

    }
    @isTest 
    static void InsertarFicheroTest()
    {
        
        Case caso = [SELECT Id FROM case WHERE subject = 'Test' LIMIT 1];
        Insertar_ficheros_caso.contentV CV = new Insertar_ficheros_caso.contentV();
        
        CV.Title = 'Test';
        CV.FileExtension ='txt';
        CV.VersionData ='YXBleA==';
     
        Insertar_ficheros_caso.listaDeContentVersion LCV = new Insertar_ficheros_caso.listaDeContentVersion();
        LCV.ContentVersion = new List<Insertar_ficheros_caso.contentV>();
        LCV.ContentVersion.add(CV);
        LCV.LinkedEntityId = String.ValueOf(case.id);

        Insertar_ficheros_caso.Response  respones = Insertar_ficheros_caso.insertarFicheros(LCV,caso.id);

        System.assertEquals('OK',respones.status);
    }
}