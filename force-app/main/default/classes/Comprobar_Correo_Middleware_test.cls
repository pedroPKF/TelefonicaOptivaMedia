/**
 * @description       : 
 * @author            : alvaro.solana@pkf-attest.es
 * @group             : 
 * @last modified on  : 27-09-2022
 * @last modified by  : alvaro.solana@pkf-attest.es
**/
@isTest
public class Comprobar_Correo_Middleware_test {

    @TestSetup
    static void makeData()
    {
        //Creamos la cuenta a la que asignaremos el Contrato
        Account cuenta =  new Account();
        cuenta.Name ='CuentaTest';
        cuenta.BillingCountry='España';
        cuenta.BillingPostalCode='28020';
        insert cuenta;
        
        //Creamos el contrato y le asignamos la cuenta
        Contract contrato = new Contract();
        contrato.Id_Externo__c = 'ContratoTest';
        contrato.isEmailVerified__c = false;
        contrato.AccountId = cuenta.id;
        insert contrato;
    }

    @isTest 
    static void modificarContratoTest()
    {
        Contract contrato = [SELECT Id, IsNewURL__c, Correo_nuevo__c, URL_verificacion__c, Id_Externo__c FROM Contract WHERE Id_Externo__c = 'ContratoTest' LIMIT 1];
        
        contrato.IsNewURL__c = true;
        contrato.Correo_nuevo__c = 'test@test.com';
        contrato.URL_verificacion__c = 'www.test-url.com?lite=' + contrato.Id_Externo__c;
        
        Test.setMock(HttpCalloutMock.class,  new LlamadaMock_LlamadaMarketingCloud());
        update contrato;
        
        contrato = [SELECT URL_verificacion__c, Id_Externo__c FROM Contract WHERE Id_Externo__c = 'ContratoTest' LIMIT 1];
        Test.startTest();
            Comprobar_Correo_Middleware.ComprobarCorreoResponse result = Comprobar_Correo_Middleware.recuperarDatos(contrato.URL_verificacion__c);
        Test.stopTest();
        contrato = [SELECT email_de_contrato__c FROM Contract WHERE Id_Externo__c = 'ContratoTest' LIMIT 1];
        System.assertNotEquals(null, result);
        System.assertEquals('OK', result.status);
        System.assertEquals('test@test.com', contrato.email_de_contrato__c);
    }

    @isTest 
    static void modificarContratoVerificadoTest()
    {
        Contract contrato = [SELECT Id, IsNewURL__c, Correo_nuevo__c, URL_verificacion__c, isEmailVerified__c, Id_Externo__c FROM Contract WHERE Id_Externo__c = 'ContratoTest' LIMIT 1];
        
        contrato.IsNewURL__c = true;
        contrato.Correo_nuevo__c = 'test@test.com';
        contrato.URL_verificacion__c = 'www.test-url.com?lite=' + contrato.Id_Externo__c;
        
        Test.setMock(HttpCalloutMock.class,  new LlamadaMock_LlamadaMarketingCloud());
        update contrato;
        contrato.isEmailVerified__c = true;
        update contrato;
        
        contrato = [SELECT URL_verificacion__c, Id_Externo__c FROM Contract WHERE Id_Externo__c = 'ContratoTest' LIMIT 1];
        Test.startTest();
            Comprobar_Correo_Middleware.ComprobarCorreoResponse result = Comprobar_Correo_Middleware.recuperarDatos(contrato.URL_verificacion__c);
        Test.stopTest();
        System.assertNotEquals(null, result);
        System.assertEquals('KO', result.status);
    }

    @isTest 
    static void contratoVerificadoTest()
    {
        Contract contrato = [SELECT Id, Correo_nuevo__c, URL_verificacion__c, isEmailVerified__c, Id_Externo__c FROM Contract WHERE Id_Externo__c = 'ContratoTest' LIMIT 1];
        
        contrato.IsNewURL__c = true;
        contrato.Correo_nuevo__c = 'prueba@test.com';
        contrato.Id_Externo__c = 'identificadorTest12345';
        contrato.URL_verificacion__c = 'www.test-url.com?lite=' + contrato.Id_Externo__c;
        
        Test.setMock(HttpCalloutMock.class,  new LlamadaMock_LlamadaMarketingCloud());
        update contrato;
        
        Contract contratoQuery = [SELECT URL_verificacion__c, Id_Externo__c FROM Contract LIMIT 1];   
        Test.startTest();
            Comprobar_Correo_Middleware.ComprobarCorreoResponse result = Comprobar_Correo_Middleware.recuperarDatos(contratoQuery.URL_verificacion__c); 
        Test.stopTest();
         
        System.assertNotEquals(null, result);
        System.assertEquals('OK', result.status);
    }

    @isTest 
    static void contratoNoEncontradoTest()
    {
        Contract contrato = [SELECT Id, IsNewURL__c, Correo_nuevo__c, URL_verificacion__c, Id_Externo__c FROM Contract WHERE Id_Externo__c = 'ContratoTest' LIMIT 1];
        
        contrato.IsNewURL__c = true;
        contrato.Correo_nuevo__c = 'test@test.com';
        contrato.URL_verificacion__c = 'www.test-url.com?lite=' + contrato.Id_Externo__c;
        
        Test.setMock(HttpCalloutMock.class,  new LlamadaMock_LlamadaMarketingCloud());
        update contrato;
  
        Test.startTest();
            Comprobar_Correo_Middleware.ComprobarCorreoResponse result = Comprobar_Correo_Middleware.recuperarDatos('x@x.com'); 
        Test.stopTest();
   
        System.assertNotEquals(null, result);
        System.assertEquals('KO', result.status);
    }

}