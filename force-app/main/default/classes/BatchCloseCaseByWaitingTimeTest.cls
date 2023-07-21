@isTest
private class BatchCloseCaseByWaitingTimeTest {
	@testSetup
    static void setup() {
        List<Case> casosAcambiar = new List<Case>();
		List<CaseMilestone> milestones = new List<CaseMilestone>();
		List<CaseMilestone> newmilestones = new List<CaseMilestone>();
        Set<Id> setId = new Set<Id>();

		CaseMeta__mdt metadata = [SELECT IdColaEspera__c, TiempoEnEspera__c, Motivo_de_cierre__c FROM CaseMeta__mdt LIMIT 1];
        Integer TiempoEspera = Integer.valueOf(metadata.TiempoEnEspera__c);
        String propietario = metadata.IdColaEspera__c;

            
        datetime fechaAnterior = System.now().addHours(-TiempoEspera);
            
            //Contrucción de fecha porque el formato no es el adecuado
            /*String anno = String.valueOf(fechaAnterior.year());
            String mes = String.valueOf(fechaAnterior.month());
            if(mes.length() <= 1) {
                mes = '0' + mes;    
            }
            String dia2 = String.valueOf(fechaAnterior.day());
            if(dia2.length() <= 1) {
                dia2 = '0' + dia2;    
            }

        String fechaLimite = anno + '-' + mes + '-' + dia2;

        datetime fecha = datetime.valueOf(fechaLimite);*/


        for(Integer i=0;i<11;i++){
			casosAcambiar.add(new Case(
			Status='On Hold',
			Origin='Formulario privado',
			Description='Test',
			Subject='Test',
            Type='Consulta de proceso de alta',
			OwnerId=propietario,
            EmailsSent__c=1
			));
		}
        insert casosAcambiar;
        
		/*milestones = [SELECT CompletionDate FROM CaseMilestone WHERE CompletionDate <> null LIMIT 31];
        for(CaseMilestone c : milestones){
			
			Integer dia = 1;
			DateTime myDateTime = DateTime.newInstance(2002, 12, dia, 3, 3, 3);
			newmilestones.add(new CaseMilestone(
				Id = c.Id,
				CompletionDate = myDateTime
			));
			dia++;
		}
		update newmilestones;*/

        
	}
    @isTest static void test() {

        List<Case> casos = [Select Id from Case];
        Datetime before10Days = Datetime.now().addDays(-10);
        for(Case caso : casos) {
            Test.setCreatedDate(caso.Id, before10Days);
        }
        List<Case> casosact = [Select Id, CreatedDate, LastModifiedDate from Case];
        for(Case caso : casosact) {
            System.debug('CreatedDate: ' + caso.CreatedDate);
            System.debug('LastModifiedDate: ' + caso.LastModifiedDate);
        }
        Test.startTest();
        
        
        BatchCloseCaseByWaitingTime bc = new BatchCloseCaseByWaitingTime();
        Id batchId = Database.executeBatch(bc);

        Test.stopTest();
	}
}