@isTest
private class BatchContractTest {
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        List<Contract> contract = new List<Contract>();
        
        for (Integer i=0;i<200;i++) {
            accounts.add(new Account(name='Account '+i, billingcity='Madrid', billingcountry='España',BillingPostalCode='28020'));
        }
        insert accounts;
        
        Date nextMonthDate = System.today().addMonths(1);
        String monthString = String.valueOf(nextMonthDate.month()).length() == 1 ? '0' + String.valueOf(nextMonthDate.month()) : String.valueOf(nextMonthDate.month());
        String nextMonthYear = monthString + '/' + String.valueOf(nextMonthDate.year()).substring(2);

        for (Account account : [select id from account]) {
            contract.add(new Contract(Tipo__c='Suscriptor', payment_method__c='credit_card', accountId=account.id, Card_Expiration_Date__c = nextMonthYear,billing_day__c = 15));
        }

        insert contract;
    }
    @isTest static void test() {
        Date todayDate = System.today();
        String dateDay = String.valueOf(todayDate.addDays(1).day()).length() == 1 ? '0' + String.valueOf(todayDate.addDays(1).day()) : String.valueOf(todayDate.addDays(1).day());
        //Varaible para la clase test
        String CRON_EXP = '0 0 0 * * ? *';
        Test.startTest();
        BatchContract bc = new BatchContract();
        Database.executeBatch(bc);

        //Testeamos el Schedulable para subir la cob3rtura
        String jobId = System.schedule('testBasicScheduledApex', CRON_EXP, new BatchContract());
        CronTrigger ct = [SELECT Id, CronJobDetail.name,CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        // Verify the next time the job will run
        String monthStr = String.valueOf(todayDate.month());
        System.assertEquals('testBasicScheduledApex', ct.CronJobDetail.name);

        Test.stopTest();
    }
}