// Peng
// Creado 01/09/2022
global class Batch_Contract_Repesca implements Database.Batchable<sObject>, Database.Stateful, Schedulable
{
    public Integer recordsProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) {

        Date todayDate = System.today();
        Date dentroDe2Dias = todayDate.addDays(2);

        Date UltimoDiaMes = todayDate.addMonths(1).toStartOfMonth().addDays(-1);
        System.debug(UltimoDiaMes);
        String queryBuscarDias;

        if(dentroDe2Dias == UltimoDiaMes) {
            switch on dentroDe2Dias.day() {
                when 28 {
                    System.debug('Es 28'); 
                    queryBuscarDias ='billing_day__c IN (28, 29, 30, 31)';
                }
                when 29 {
                    System.debug('Es 29');
                    queryBuscarDias ='billing_day__c IN (29, 30, 31)';
                }
                when 30 {
                    System.debug('Es 30');
                    queryBuscarDias ='billing_day__c IN (30, 31)';
                }
                when 31 {
                    System.debug('Es 31');
                    queryBuscarDias ='billing_day__c IN (31)';
                }
            }
        }
        else {
            queryBuscarDias = 'billing_day__c = ' + String.valueOf(dentroDe2Dias.day()); 
        }

        String queryStr = 'SELECT Id,AccountId,billing_day__c FROM Contract ' +
                        'Where Tipo__c = \'Suscriptor\' AND  Estado_de_suscripcion__c = \'Pendiente de cancelación\' AND ' + queryBuscarDias;

        return Database.getQueryLocator(
            queryStr
        );
    }
    public void execute(Database.BatchableContext bc, List<Contract> scope){
        List<Alerta__c> AlertaLista = new List<Alerta__c>();

        if(!scope.isEmpty()) {
            for (Contract ContractList : scope) {
                Alerta__c alerta = new Alerta__c();
                alerta.Contract__c = ContractList.id;
                alerta.Tipo__c = 'Repesca de suscriptor';
                alerta.Asunto__c ='Repesca de suscriptor.';
                AlertaLista.add(alerta);
                recordsProcessed = recordsProcessed + 1;
                System.debug('Se ha creado alerta' + alerta.Contract__c);
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
        Batch_Contract_Repesca bc = new Batch_Contract_Repesca();
        Database.executeBatch(bc, 200);
    }
}