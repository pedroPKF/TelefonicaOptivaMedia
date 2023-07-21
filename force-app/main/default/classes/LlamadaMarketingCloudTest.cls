@IsTest public with sharing class LlamadaMarketingCloudTest {

    @TestSetup
	static void makeData()
	{
        Lead leadToCreate =new Lead();

        leadToCreate.LastName ='pedro_mpl_317@hotmail.com';
        leadToCreate.Id_Externo__c='LITE-00Q7Y000008UGQjUAO';
        leadToCreate.Email ='test@gmail.com';
        leadToCreate.Status='';
        leadToCreate.PostalCode='28019';
        insert leadToCreate; 
        leadToCreate.Status='Converted';
        update leadToCreate;
        Account accId =[Select id,Name from Account LIMIT 1];

        System.debug(leadToCreate);
        Contract contr = new Contract();
        contr.URL_verificacion__c='www.google.es';
        contr.Id_Externo__c='LITE-00Q7Y000008UGQjUAO';
        contr.accountId = accId.id;
        contr.IsNewURL__c=true;
        insert contr;

        Alerta__c alert = new Alerta__c();
        alert.Tipo__c='Codigo de verificacion';
        alert.Account__c=accId.id;
        alert.contract__c=contr.id;
        insert alert;
    }

    @isTest static void LlamadaMarketingCloudContrato() {
    
        Contract contr = [Select name, correo_nuevo__c,URL_verificacion__c,Id_Externo__c,accountId from Contract LIMIT 1];
        contr.name='test@gmail.es';
        contr.correo_nuevo__c='test@gmail.es';
       
        // Call your @future method here.
        update contr;
        System.debug(contr);
        System.debug('ACC ' +contr.id);
        Test.startTest();
 
        Test.setMock(HttpCalloutMock.class,  new LlamadaMock_LlamadaMarketingCloud());
        LlamadaMarketingCloud LMC = new LlamadaMarketingCloud(contr.id);
        HttpResponse res = LMC.Send_Email_Triggered();
        System.debug('Termina Metodo' + res);

        try{
            final String result = string.valueof(res);
            System.assertNotEquals(null, result);
        }
        catch(NullPointerException e) {
            system.debug('ERROR');
        }

        Test.stopTest();
    }

    @isTest static void LlamadaMarketingCloudAlerta() {
        Account accId =[Select id,Name from Account LIMIT 1];
        Contract contrId =[Select id,Name from Contract LIMIT 1];

         Alerta__c alert = new Alerta__c();
        alert.Tipo__c='Codigo de verificacion';
        alert.Account__c=accId.id;
        alert.contract__c=contrId.id;
        alert.codigo_verificacion__c='1234-1234';
        alert.URL_1__c='www.google.es';
        alert.URL_2__c='www.google.es';
        insert alert;
        System.debug('Alerta creado: ' + alert);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,  new LlamadaMock_LlamadaMarketingCloud());
        
        Test.stopTest();
    }
    
    @isTest static void testContractTriggerHandler(){
        Account accId =[Select id,Name from Account LIMIT 1];

        Contract contr2 =new Contract();
        contr2.URL_verificacion__c='www.google.es';
        contr2.Id_Externo__c='contratoaEliminar';
        contr2.accountId =accId.Id;
        contr2.Name='eliminar';
        insert contr2;
        Test.startTest();
        Contract[] contratoAEliminar =[Select Name From Contract where Name='eliminar'];
        System.debug('Lista Contrato a Eliminar' + contratoAEliminar);
        delete contratoAEliminar;
        Test.stopTest();
    }
    @isTest static void testContractTriggerHandlerEliminar(){

        Test.startTest();

        Contract[] contratoAEliminar =[Select Name From Contract where Name='eliminar'];
        System.debug('Lista Contrato a Eliminar' + contratoAEliminar);
        delete contratoAEliminar;
        Test.stopTest();
    }
    @isTest static void testAlertTriggerHandlerEliminar(){
        Alerta__c[] AlertaActualizar =[Select codigo_verificacion__c From Alerta__c];
        //AlertaActualizar[0].codigo_verificacion__c='1234-324';
        //update AlertaActualizar;
		Test.startTest();
        delete AlertaActualizar;
        Test.stopTest();
    }
    @isTest static void testAlertTriggerHandlerUpdate(){
        Alerta__c[] AlertaActualizar =[Select codigo_verificacion__c From Alerta__c];
        AlertaActualizar[0].codigo_verificacion__c='1234-324';
		Test.startTest();
        update AlertaActualizar;
        Test.stopTest();
    }
}