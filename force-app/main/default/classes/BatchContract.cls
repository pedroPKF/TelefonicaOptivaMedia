// PKF
// Creado 01/09/2022
global class BatchContract implements Database.Batchable<sObject>, Database.Stateful, Schedulable {
    public Integer recordsProcessed = 0;
    private String tipo_cliente = 'Suscriptor';
    private String tipo_pago = 'credit_card';
    public Database.QueryLocator start(Database.BatchableContext bc) {

        /**
         * PKF modificación para recuperar los contratos con metodo de pago tarjeta de credito y que caduque el mes siguiente
         * 
         */
        Date nextMonthDate = System.today().addMonths(1);
        String monthString = String.valueOf(nextMonthDate.month()).length() == 1 ? '0' + String.valueOf(nextMonthDate.month()) : String.valueOf(nextMonthDate.month());
        String nextMonthYear = monthString + '/' + String.valueOf(nextMonthDate.year()).substring(2);

        String query = 'SELECT Id, AccountId,billing_day__c,Card_Expiration_Date__c FROM Contract ' +
                        'Where Tipo__c = :tipo_cliente AND payment_method__c = :tipo_pago AND Card_Expiration_Date__c = :nextMonthYear';
        
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Contract> scope){
        List<Alerta__c> AlertaLista = new List<Alerta__c>();
        if(!scope.isEmpty()) {
            for (Contract ContractList : scope) {                
                Alerta__c alerta = new Alerta__c();
                alerta.String_Aux_1__c = String.valueOf(ContractList.billing_day__c.intValue())+'/'+ContractList.Card_Expiration_Date__c;
                alerta.Contract__c = ContractList.id;
                alerta.Tipo__c = 'Caducidad del método de pago';
                alerta.Asunto__c ='Metodo de pago próximo a caducar.';
                alerta.Account__c = ContractList.AccountId;
                AlertaLista.add(alerta);
                recordsProcessed = recordsProcessed + 1;
            }
            insert AlertaLista;
        }
    }
    public void finish(Database.BatchableContext bc){
        /*AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];*/
    }

    global void execute(SchedulableContext sc) {
        BatchContract bc = new BatchContract();
        Database.executeBatch(bc, 200);

        String nextScheduleDate = '0 0 0 ';
        if(System.today().day() == 1) {
            nextScheduleDate += '15 ' + System.today().month() + ' ? ' + System.today().year();
        }
        else if(System.today().day() == 15) {
            Date nextMonthDate = System.today().addMonths(1);
            nextScheduleDate += '1 ' + nextMonthDate.month() + ' ? ' + nextMonthDate.year();
        }
        if(!Test.isRunningTest()) {
            
            System.schedule('ScheduleCaducidadMetodoPagoJob', nextScheduleDate, new BatchContract());
        }
    }
    
}