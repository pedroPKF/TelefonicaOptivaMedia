public with sharing class Llamada_Conexion_Middleware_util {
    public class ListaIndividual{
        public List<consents> consents               { get; set; }

    }

    public class consents {
        public String action			             { get; set; }
        public String legal_entity_id			     { get; set; }
        public String status			             { get; set; }
        public String purpose_id			         { get; set; }
        public String user_prompted			         { get; set; }
        
        public String identifier_tag	    	     { get; set; }
        public String consumer		                 { get; set; }
        public String channel		                 { get; set; }
        public String reason		                 { get; set; }
  
        public identifier identifier                 { get; set; }
        public identifier_parent identifier_parent   { get; set; }
    }

    public class identifier {
        public String id		                     { get; set; }
        public String type		                     { get; set; }

    }
    public class identifier_parent {
        public String id		                     { get; set; }
        public String type		                     { get; set; }

    }

    public class codPostal{
        public String postalCode                       { get; set; }
    }
    // public static ListaIndividual parse(String json){
    //     return System.JSON.serialize(json);
    // }

    public static ListaIndividual Consentimientos_body(Historico_Individual__c individualHistorico) {

        String body = ''; 
        ListaIndividual ListaIndividual = new ListaIndividual();
        listaIndividual.consents = new List<consents>();

       
        //Buscar individual
        Individual individual = [SELECT id, DNI__c, Fecha_y_Hora_de_Captacion_C111__c, Accion_C111__c, C111__c, Sistema_Consumer_C111__c, Canal_C111__c, Reason_C111__c,
                                                    Fecha_y_Hora_de_Captacion_C112__c, Accion_C112__c, C112__c, Sistema_Consumer_C112__c, Canal_C112__c, Reason_C112__c,
                                                    Fecha_y_Hora_de_Captacion_C113__c, Accion_C113__c, C113__c, Sistema_Consumer_C113__c, Canal_C113__c, Reason_C113__c,
                                                    Fecha_y_Hora_de_Captacion_C114__c, Accion_C114__c, C114__c, Sistema_Consumer_C114__c, Canal_C114__c, Reason_C114__c,
                                                    Fecha_y_Hora_de_Captacion_C122__c, Accion_C122__c, C122__c, Sistema_Consumer_C122__c, Canal_C122__c, Reason_C122__c 
                                                    FROM Individual WHERE id =: individualHistorico.Persona__c LIMIT 1];
            consents consents_C111 = new consents();
            consents consents_C112 = new consents();
            consents consents_C113 = new consents();
            consents consents_C114 = new consents();
            consents consents_C122 = new consents();

            boolean activarPicklist1 = false;
            boolean activarPicklist2 = false;
            boolean activarPicklist3 = false;
            boolean activarPicklist4 = false;
            boolean activarPicklist5 = false;

            identifier identifier = new identifier();

            identifier_parent identifier_parent = new identifier_parent();

            //Consentimiento C111
            
            identifier.id = individual.DNI__c;
            identifier.type = 'NIF';

            identifier_parent.id = individual.DNI__c;
            identifier_parent.type = 'NIF';
            consents_C111.legal_entity_id = 'MOVISTAR';
            consents_C112.legal_entity_id = 'MOVISTAR';
            consents_C113.legal_entity_id = 'MOVISTAR';
            consents_C114.legal_entity_id = 'MOVISTAR';
            consents_C122.legal_entity_id = 'MOVISTAR';


            if(individualHistorico.Fecha_y_Hora_de_Captacion_C111__c != individual.Fecha_y_Hora_de_Captacion_C111__c) {
                consents_C111.user_prompted = String.valueOf(System.now());
                consents_C111.identifier_tag = 'LITE';
                consents_C111.purpose_id = 'C111';
                consents_C111.action = individual.Accion_C111__c == null ? 'MODIFICACION' : individual.Accion_C111__c;
                consents_C111.status = individual.C111__c;
                consents_C111.consumer = individual.Sistema_Consumer_C111__c == null ? 'LITE' : individual.Sistema_Consumer_C111__c;
                consents_C111.channel = individual.Canal_C111__c;
                consents_C111.reason = individual.Reason_C111__c;

                consents_C111.identifier = identifier;
                consents_C111.identifier_parent = identifier_parent;

                listaIndividual.consents.add(consents_C111);
                activarPicklist1 = true;
            }
            
            if(individualHistorico.Fecha_y_Hora_de_Captacion_C112__c != individual.Fecha_y_Hora_de_Captacion_C112__c) {

                consents_C112.user_prompted = String.valueOf(System.now());
                consents_C112.identifier_tag = 'LITE';
                consents_C112.purpose_id = 'C112';
                consents_C112.action = individual.Accion_C112__c == null ? 'MODIFICACION' : individual.Accion_C112__c;
                consents_C112.status = individual.C112__c;
                consents_C112.consumer = individual.Sistema_Consumer_C112__c == null ? 'LITE' : individual.Sistema_Consumer_C112__c;
                consents_C112.channel = individual.Canal_C112__c;
                consents_C112.reason = individual.Reason_C112__c;
            
                consents_C112.identifier = identifier;
                consents_C112.identifier_parent = identifier_parent;

                listaIndividual.consents.add(consents_C112);
                activarPicklist2 = true;

            }
            if(individualHistorico.Fecha_y_Hora_de_Captacion_C113__c != individual.Fecha_y_Hora_de_Captacion_C113__c) {

                consents_C113.user_prompted = String.valueOf(System.now());
                consents_C113.identifier_tag = 'LITE';
                consents_C113.purpose_id = 'C113';
                consents_C113.action = individual.Accion_C113__c == null ? 'MODIFICACION' : individual.Accion_C113__c;
                consents_C113.status = individual.C113__c;
                consents_C113.consumer = individual.Sistema_Consumer_C113__c == null ? 'LITE' : individual.Sistema_Consumer_C113__c;
                consents_C113.channel = individual.Canal_C113__c;
                consents_C113.reason = individual.Reason_C113__c;
            
                consents_C113.identifier = identifier;
                consents_C113.identifier_parent = identifier_parent;

                listaIndividual.consents.add(consents_C113);
                activarPicklist3 = true;

            }
            if(individualHistorico.Fecha_y_Hora_de_Captacion_C114__c != individual.Fecha_y_Hora_de_Captacion_C114__c) {

                consents_C114.user_prompted = String.valueOf(System.now());
                consents_C114.identifier_tag = 'LITE';
                consents_C114.purpose_id = 'C114';
                consents_C114.action = individual.Accion_C114__c == null ? 'MODIFICACION' : individual.Accion_C114__c;
                consents_C114.status = individual.C114__c;
                consents_C114.consumer = individual.Sistema_Consumer_C114__c == null ? 'LITE' : individual.Sistema_Consumer_C114__c;
                consents_C114.channel = individual.Canal_C114__c;
                consents_C114.reason = individual.Reason_C114__c;
            
                consents_C114.identifier = identifier;
                consents_C114.identifier_parent = identifier_parent;

                listaIndividual.consents.add(consents_C114);
                activarPicklist4 = true;

            }
            if(individualHistorico.Fecha_y_Hora_de_Captacion_C122__c != individual.Fecha_y_Hora_de_Captacion_C122__c) {

                consents_C122.user_prompted = String.valueOf(System.now());
                consents_C122.identifier_tag = 'LITE';
                consents_C122.purpose_id = 'C122';
                consents_C122.action = individual.Accion_C122__c == null ? 'MODIFICACION' : individual.Accion_C122__c;
                consents_C122.status = individual.C122__c;
                consents_C122.consumer = individual.Sistema_Consumer_C122__c == null ? 'LITE' : individual.Sistema_Consumer_C122__c;
                consents_C122.channel = individual.Canal_C122__c;
                consents_C122.reason = individual.Reason_C122__c;
            
                consents_C122.identifier = identifier;
                consents_C122.identifier_parent = identifier_parent;

                listaIndividual.consents.add(consents_C122);
                activarPicklist5 = true;

            }
                    
            body=  JSON.serialize(listaIndividual);
            body = body.replaceAll('null', '');
            return ListaIndividual;
        
    }

    public static codPostal zipCode_body(String idAcc){
        Account acc = [Select id, Codigo_Postal__c FROM Account where Id_Externo__c =: idAcc];
        codPostal codPostal = new codPostal();
        codPostal.postalCode = acc.Codigo_Postal__c;
        return codPostal;
    }
      
}