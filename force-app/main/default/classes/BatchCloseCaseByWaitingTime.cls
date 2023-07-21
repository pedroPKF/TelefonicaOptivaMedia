// Yordy Martinez Arteaga
// Creado 09/12/2022
global class BatchCloseCaseByWaitingTime implements Database.Batchable<sObject>, Database.Stateful, Schedulable{
    public Database.QueryLocator start(Database.BatchableContext bc){

        CaseMeta__mdt metadata = [SELECT IdColaEspera__c, TiempoEnEspera__c, Motivo_de_cierre__c FROM CaseMeta__mdt LIMIT 1];
        Integer TiempoEspera = Integer.valueOf(metadata.TiempoEnEspera__c);
        String propietario = metadata.IdColaEspera__c;
        
        datetime fechaAnterior = System.now().addHours(-TiempoEspera);
        
        //Contrucción de fecha porque el formato no es el adecuado
        String anno = String.valueOf(fechaAnterior.year());
        String mes = String.valueOf(fechaAnterior.month());
        if(mes.length() <= 1) {
            mes = '0' + mes;    
        }
        String dia = String.valueOf(fechaAnterior.day());
        if(dia.length() <= 1) {
            dia = '0' + dia;    
        }

        String fechaLimite = anno + '-' + mes + '-' + dia + 'T00:00:00Z'; //2022-11-25T07:35:46.000+0000
    
        return Database.getQueryLocator('SELECT Id FROM Case WHERE Status = \'On Hold\' AND OwnerId =\''+ propietario +'\' AND LastModifiedDate < '+ fechaLimite );
    }
    
 
    
    public void execute(Database.BatchableContext bc, List<Case> scope){
        List<Case> listaATratar = new List<Case>();
        if(scope != null){
            CaseMeta__mdt metadata = CaseMeta__mdt.getInstance('Case1');

            for(Case c : scope){
                Case caso = new Case();
                caso.Id = c.Id;
                caso.Status = 'Closed';
                caso.Razon_de_cierre__c = 'Cliente no responde';
                caso.Motivo_de_cierre__c = metadata.Motivo_de_cierre__c;
                listaATratar.add(caso);
            }
    
            if(!listaATratar.isEmpty()){
                update listaATratar;
            }
        }
    }
    public void finish(Database.BatchableContext bc){
        
    }
    global void execute(SchedulableContext sc) {
        BatchCloseCaseByWaitingTime bc = new BatchCloseCaseByWaitingTime();
        Database.executeBatch(bc, 200);
    }
}