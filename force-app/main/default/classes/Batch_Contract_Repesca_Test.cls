@isTest
public with sharing class Batch_Contract_Repesca_Test {
    @TestSetup
    static void makeData(){
        List<Account> accounts = new List<Account>();
        List<Contract> contract = new List<Contract>();
        
        for (Integer i=0;i<200;i++) {
            accounts.add(new Account(name='Account '+i, billingcity='Madrid', billingcountry='España',BillingPostalCode='28020'));
        }
        insert accounts;
        
        Date nextMonthDate = System.today().addMonths(1);
        String monthString = String.valueOf(nextMonthDate.month()).length() == 1 ? '0' + String.valueOf(nextMonthDate.month()) : String.valueOf(nextMonthDate.month());
        String nextMonthYear = monthString + '/' + String.valueOf(nextMonthDate.year()).substring(2);
        Integer diaFacturacion = 1;
        for (Account account : [select id from account]) {
            if(diaFacturacion == 31) {
                diaFacturacion = 1;
            }
            contract.add(new Contract(Tipo__c='Suscriptor', Estado_de_suscripcion__c='Pendiente de Cancelación', accountId=account.id, billing_day__c = diaFacturacion));
            diaFacturacion++;
        }
        insert contract;
    }

    @isTest
    static void RepescarTest() {
        Test.startTest();
        String CRON_EXP = '0 0 0 * * ? *';
        Batch_Contract_Repesca bc = new Batch_Contract_Repesca();
        Database.executeBatch(bc);

        //Testeamos el Schedulable para subir la cob3rtura
        String jobId = System.schedule('testBasicScheduledApex', CRON_EXP, new Batch_Contract_Repesca());
        CronTrigger ct = [SELECT Id, CronJobDetail.name,CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        // Verify the next time the job will run
        System.assertEquals('testBasicScheduledApex', ct.CronJobDetail.name);
        Test.stopTest();
    }
}