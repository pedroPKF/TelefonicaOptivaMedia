/**
 * @author [pablo.sagredo]
 * @email 
 * @create date 2022-07-13
 * @modify date 2020-07-13 
 * @desc [Test del email service]
 */
@isTest
private class EmailServiceClassTest{

    @TestSetup
    static void makeData()
    {
        // create a new email and envelope object
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

       email.subject = 'prueba del subject';
       email.fromAddress = 'someaddress@email.com';
       email.fromname = 'Name1';
       email.plainTextBody = 'prueba de funcionamiento ';
    }
    
    @isTest
    static void createdCaseFromEmail() {
        Test.startTest();
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        Account cuenta = new Account();
        cuenta.Anonimo__c = true;
        cuenta.LastName = 'Anónimo';
        cuenta.RecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        cuenta.BillingCountry='España';
        cuenta.BillingPostalCode='28021';
        insert cuenta;
        
        email.fromAddress='test@test.com';
        email.fromName='Test'; 
        String Correo='test@mock.com';
        List<String> listaCorreos=new list<String>();
        listaCorreos.add(Correo);
        email.toAddresses=listaCorreos;
        email.plainTextBody='test.com';
        email.subject = 'test';
        env.fromAddress = 'user@acme.com';    

		EmailServiceClass em= new EmailServiceClass();
        em.handleInboundEmail(email,env);
        
      
        Case casos = [Select id, Account.Name, Subject, Origin, Status, SuppliedEmail,Description, OwnerID from Case LIMIT 1];
        System.assertNotEquals(null, casos);
        System.assertEquals(email.subject, casos.Subject);
        System.assertEquals('Anónimo', casos.Account.Name);
        
        Test.stopTest();

       }
    
    @isTest
    static void createdCaseFromEmail2() {
        Test.startTest();
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        //
        Account cuenta2 = new Account();
        cuenta2.Anonimo__c = true;
        cuenta2.LastName = 'Anónimo';
        cuenta2.RecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        cuenta2.BillingCountry='España';
        cuenta2.BillingPostalCode='28021';
        insert cuenta2;
        
        email.fromAddress='test@test.com';
        //email.fromName='Test'; 
        String Correo='test@mock.com';
        List<String> listaCorreos=new list<String>();
        listaCorreos.add(Correo);
        email.toAddresses=listaCorreos;
        email.plainTextBody='test.com';
        email.subject = 'test';
        env.fromAddress = 'user@acme.com';    

		EmailServiceClass em= new EmailServiceClass();
        em.handleInboundEmail(email,env);
        
      
        Case casos = [Select id, Account.Name, Subject, Origin, Status, SuppliedEmail,Description, OwnerID from Case LIMIT 1];
        System.assertNotEquals(null, casos);
        System.assertEquals(email.subject, casos.Subject);
        System.assertEquals('Anónimo', casos.Account.Name);
        
        Test.stopTest();

       }
    
    @isTest
    static void createdCaseWithContractFromEmail() {
        Test.startTest();
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        Account cuenta = new Account();
        cuenta.LastName = 'Test';
        cuenta.RecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        cuenta.BillingCountry='España';
        cuenta.BillingPostalCode='28021';
        insert cuenta;
        
        Contract contrato = new Contract();
        contrato.AccountId = cuenta.Id;
        contrato.email_de_contrato__c = 'test@test.com';
        insert contrato;
        
        email.fromAddress='test@test.com';
        email.fromName='Test'; 
        String Correo='test@mock.com';
        List<String> listaCorreos=new list<String>();
        listaCorreos.add(Correo);
        email.toAddresses=listaCorreos;
        email.plainTextBody='test.com';
        email.subject = 'test';
        env.fromAddress = 'user@acme.com';    

		EmailServiceClass em= new EmailServiceClass();
        em.handleInboundEmail(email,env);
        
      
        Case casos = [Select id, Account.Name, Subject, Origin, Status, SuppliedEmail,Description, OwnerID, Contratos_relacionados__c from Case LIMIT 1];
        System.assertNotEquals(null, casos);
        System.assertEquals(email.subject, casos.Subject);
        System.assertEquals(cuenta.LastName, casos.Account.Name);
        System.assertEquals(contrato.Id, casos.Contratos_relacionados__c);
        
        Test.stopTest();

       }
    
    @isTest
    static void existingCase() {
        Test.startTest();
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        Case caso = new Case();
        insert caso;
        
        email.fromAddress='test@test.com';
        email.fromName='Test'; 
        String Correo='test@mock.com';
        List<String> listaCorreos=new list<String>();
        listaCorreos.add(Correo);
        email.toAddresses=listaCorreos;
        email.plainTextBody='##REF:[' + caso.Id + ']##';
        email.subject = 'test with case';
        env.fromAddress = 'user@acme.com';    

		EmailServiceClass em= new EmailServiceClass();
        em.handleInboundEmail(email,env);
        
        Test.stopTest();
        
        EmailMessage message = [SELECT Id, Subject, Status, FromAddress, ToAddress, RelatedToId FROM EmailMessage LIMIT 1];
        System.AssertEquals(caso.Id, message.RelatedToId);
    }
    
    @isTest
    static void existingCaseClosed() {
        Test.startTest();
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        Case caso = new Case();
        //caso.Status = 'Closed';
        //caso.EmailsSent__c = 0;
        
        insert caso;
        caso.Status = 'Closed';
        update caso;


        email.fromAddress='test@test.com';
        email.fromName='Test'; 
        String Correo='test@mock.com';
        List<String> listaCorreos=new list<String>();
        listaCorreos.add(Correo);
        email.toAddresses=listaCorreos;
        email.plainTextBody='##REF:[' + caso.Id + ']##';
        email.subject = 'test with case';
        env.fromAddress = 'user@acme.com';    

		EmailServiceClass em= new EmailServiceClass();
        em.handleInboundEmail(email,env);
        
        Test.stopTest();
        
        List<Case> casos=[SELECT Id,ParentId from Case ];
        System.AssertEquals(2, casos.size());
        List<Case> casos2=[SELECT Id,ParentId from Case WHERE ParentId=:caso.Id ];
        System.AssertEquals(1, casos2.size());
    }

    @isTest
    static void existingCaseOnHold() {
        Case caso = new Case();
        //caso.Status = 'Closed';
        //caso.EmailsSent__c = 0;
        caso.Status = 'On Hold';
        insert caso;
        Test.startTest();
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        
        
        


        email.fromAddress='test@test.com';
        email.fromName='Test'; 
        String Correo='test@mock.com';
        List<String> listaCorreos=new list<String>();
        listaCorreos.add(Correo);
        email.toAddresses=listaCorreos;
        email.plainTextBody='##REF:[' + caso.Id + ']##';
        email.subject = 'test with case';
        env.fromAddress = 'user@acme.com';    

		EmailServiceClass em= new EmailServiceClass();
        em.handleInboundEmail(email,env);
        
        Test.stopTest();
        
        List<Case> casos=[SELECT Id,ParentId from Case ];
        System.AssertEquals(1, casos.size());

    }
}