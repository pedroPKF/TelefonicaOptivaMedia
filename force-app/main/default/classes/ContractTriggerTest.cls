/**
 * @description       : 
 * @author            : alvaro.solana@pkf-attest.es
 * @group             : 
 * @last modified on  : 26-09-2022
 * @last modified by  : alvaro.solana@pkf-attest.es
**/
@isTest
public class ContractTriggerTest {

    @TestSetup
    static void makeData()
    {
        //Creamos la cuenta a la que asignaremos el Contrato
        Account cuenta =  new Account();
        cuenta.Name ='CuentaTest';
        cuenta.BillingCountry='España';
        cuenta.BillingPostalCode='28021';
        insert cuenta;
        
        //Creamos el contrato y le asignamos la cuenta
        Contract contrato = new Contract();
        contrato.Id_Externo__c = 'ContratoTest';
        contrato.AccountId = cuenta.id;
        contrato.Correo_nuevo__c = 'z@z.com';
        contrato.URL_verificacion__c = 'www.test-url.com?email=z@z.com';
        insert contrato;
    }

    @isTest 
    static void modificarContratoTest()
    {
        //Buscamos el contrato
        Contract contrato = [SELECT Id, Correo_nuevo__c, URL_verificacion__c, IsNewURL__c FROM Contract WHERE Id_Externo__c = 'ContratoTest' LIMIT 1];
        
        //Modificamos el contrato
        Test.setMock(HttpCalloutMock.class,  new LlamadaMock_LlamadaMarketingCloud());

        contrato.IsNewURL__c = true;
        contrato.Correo_nuevo__c = 'x@x.com';
        contrato.URL_verificacion__c = 'www.test-url.com?email=x@x.com';
        
        update contrato;
    }

    @isTest 
    static void crearContratoTest()
    {
        //Buscamos la cuenta para asignarsela al contrato
        Account cuenta = [SELECT Id FROM Account WHERE Name = 'CuentaTest' LIMIT 1];

        //Creamos el contrato y le asignamos la cuenta
        Contract contrato = new Contract();
        contrato.IsNewURL__c = true;
        contrato.Id_Externo__c = 'ContratoTest2';
        contrato.AccountId = cuenta.id;
        contrato.Correo_nuevo__c = 'z@z.com';
        contrato.URL_verificacion__c = 'www.test-url.com?email=z@z.com';
        
        insert contrato;
    }
}