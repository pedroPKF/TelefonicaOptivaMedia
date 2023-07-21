@IsTest public with sharing class Llamada_Conexion_Middleware_test {

    @TestSetup
	static void makeData()
	{
    
      Lead leadToCreate =new Lead();

      leadToCreate.LastName ='pedro_mpl_317@hotmail.com';
      leadToCreate.Id_Externo__c='LITE-00Q7Y000008UGQjUAO';
      leadToCreate.Email ='test@gmail.com';
      leadToCreate.Status='';
      leadToCreate.DNI__c ='58741488D';
      leadToCreate.PostalCode='28019';
      insert leadToCreate; 
      leadToCreate.Status='Converted';
      update leadToCreate;
      Account accId =[Select id,Name from Account LIMIT 1];

      List<Historico_Individual__c> historicos1 = [Select Id from Historico_Individual__c];
        if(!historicos1.isEmpty()) {}
      Individual ind = new Individual();
        ind.AccountRelationship__c = accId.id;

        ind.Id_Externo__c='92883874-66S5-46P3-B7D1-143D110B653';
        ind.LastName ='PEPE';
        ind.C111__c ='No Informado';
        ind.C112__c ='No Informado';
        ind.C113__c ='No Informado';
        ind.C114__c ='No Informado';
        ind.C122__c ='No Informado';

        ind.Reason_C111__c ='ACCION COMERCIAL';
        ind.Reason_C112__c ='ACCION COMERCIAL';
        ind.Reason_C113__c ='ACCION COMERCIAL';
        ind.Reason_C114__c ='ACCION COMERCIAL';
        ind.Reason_C122__c ='ACCION COMERCIAL';

        ind.Canal_C111__c ='OTROS';
        ind.Canal_C112__c ='OTROS';
        ind.Canal_C113__c ='OTROS';
        ind.Canal_C114__c ='OTROS';
        ind.Canal_C122__c ='OTROS';
        
        ind.Accion_C111__c='ALTA';
        ind.Accion_C112__c='ALTA';
        ind.Accion_C113__c='ALTA';
        ind.Accion_C114__c='ALTA';
        ind.Accion_C122__c='ALTA';

        ind.Sistema_Consumer_C111__c ='Service Cloud';
        ind.Sistema_Consumer_C112__c ='Service Cloud';
        ind.Sistema_Consumer_C113__c ='Service Cloud';
        ind.Sistema_Consumer_C114__c ='Service Cloud';
        ind.Sistema_Consumer_C122__c ='Service Cloud';

        ind.Canal_Captacion_C111__c = 'C360';   
        ind.Canal_Captacion_C112__c = 'C360';
        ind.Canal_Captacion_C113__c = 'C360';
        ind.Canal_Captacion_C114__c = 'C360';
        ind.Canal_Captacion_C122__c = 'C360';

        insert ind;

        ind.Fecha_y_Hora_de_Captacion_C111__c='29/10/2022, 10:07';
        update ind;

        List<Historico_Individual__c> historicos = [Select Id from Historico_Individual__c];
        if(!historicos.isEmpty()) {}
    }


    @isTest static void testCallout() {

    String Body;
    String NamedCredential;
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new LlamadaMock_MiddlewareMethod.LlamadaMock_middleware());
    HttpResponse res = 	Llamada_Conexion_Middleware.CallApiVersion('test', 'method');
 
    Body = res.getBody();
    String expectedValue = '0.0.0';
    System.assertEquals(Body, expectedValue);
    System.assertEquals(200, res.getStatusCode());

    Test.stopTest();

    }
    
    @isTest static void testMethodUtil() {
        String Body;
        Individual ind = [Select id,C111__c,C112__c,C113__c,C114__c,C122__c,Reason_C111__c,Reason_C112__c,
        Reason_C113__c ,Reason_C114__c,Reason_C122__c,Fecha_y_Hora_de_Captacion_C111__c,Fecha_y_Hora_de_Captacion_C112__c
        ,Fecha_y_Hora_de_Captacion_C113__c,Fecha_y_Hora_de_Captacion_C114__c,Fecha_y_Hora_de_Captacion_C122__c from Individual LIMIT 1];
        ind.Fecha_y_Hora_de_Captacion_C111__c='29/10/2022, 10:07';
        ind.Fecha_y_Hora_de_Captacion_C112__c='29/10/2022, 10:07';
        ind.Fecha_y_Hora_de_Captacion_C113__c='29/10/2022, 10:07';
        ind.Fecha_y_Hora_de_Captacion_C114__c='29/10/2022, 10:07';
        ind.Fecha_y_Hora_de_Captacion_C122__c='29/10/2022, 10:07';
        String expectedValue ='{'+
        '"id": "0PK7Y0000046DCkWAM",'+
        ' "success": true,'+
        ' "errors": [],'+
        ' "created": true'+
        ' }';
        Test.setMock(HttpCalloutMock.class, new LlamadaMock_MiddlewareMethod.llamadas_Mock());
        Test.startTest();
        update ind;
        List<Historico_Individual__c> listaHistorico = [SELECT id FROM Historico_Individual__c];
        System.assertEquals(2,listaHistorico.size());
        Test.stopTest();


    }

    @isTest static void editHistorico(){
 
        List<Historico_Individual__c> historicos = [Select Id from Historico_Individual__c];
        if(!historicos.isEmpty()) {}

        Historico_Individual__c HI =[Select Accion_C111__c from Historico_Individual__c LIMIT 1];
        HI.Accion_C111__c='Cambio';
        Test.setMock(HttpCalloutMock.class, new LlamadaMock_MiddlewareMethod.llamadas_Mock());
        Test.startTest();
        update HI;     
        Test.stopTest();

    }
    @isTest static void deleteHistorico(){
  
        Historico_Individual__c HI =[Select Accion_C111__c from Historico_Individual__c LIMIT 1];
        Test.startTest(); 
        delete HI;    
        Test.stopTest();

    }

    @isTest static void editzipCode(){
 
        Account acc = [Select Codigo_Postal__c from Account Limit 1];
        acc.Id_Externo__c  ='92883874-66S5-46P3-B7D1-143D112K9685';
        acc.Codigo_Postal__c = '28931';
        Test.setMock(HttpCalloutMock.class, new LlamadaMock_MiddlewareMethod.LlamadaMock_zipCpde());
        Test.startTest();
        update acc;     
        Test.stopTest();

    }
}