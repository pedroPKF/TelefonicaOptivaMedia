public class EmailSendServiceClass {
 
    //Constructor do nothing.
    public EmailSendServiceClass(){
     
    }
    
    public void createContactAndSendEmail(){
     
     Contact contObj = new Contact();
     contObj.firstName = 'Srinivasa';
     contObj.lastName = 'Balle';
     contObj.email = 'sfdcsrini@gmail.com';
     contObj.Phone = '919014678568';
     contObj.description = 'This is Test contact created for outboundemailservice.';
     insert contObj;
     
     system.debug('==>created Contact is==>'+contObj.id);
     
     // First, reserve email capacity for the current Apex transaction to ensure                  
     // that we won't exceed our daily email limits when sending email after                 
     // the current transaction is committed.
     Messaging.reserveSingleEmailCapacity(2);
     
     // Processes and actions involved in the Apex transaction occur next,
     // which conclude with sending a single email.
     
     // Now create a new single email message object
     // that will send out a single email to the addresses in the To, CC & BCC list.
     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
     
     // Strings to hold the email addresses to which you are sending the email.
     String[] toAddresses = new String[] {contObj.email}; 
       
     
     // Assign the addresses for the To and CC lists to the mail object.
     mail.setToAddresses(toAddresses);
     
     // Specify the address used when the recipients reply to the email. 
     mail.setReplyTo('no@gmail.com');
     
     // Specify the name used as the display name.
     mail.setSenderDisplayName('Salesforce Support');
     
     // Specify the subject line for your email address.
     mail.setSubject('New Contact Created : ' + contObj.Id);
     
     // Set to True if you want to BCC yourself on the email.
     mail.setBccSender(false);
     

     // Specify the text content of the email.
     mail.setPlainTextBody('Your Contact: ' + contObj.Id +' has been created.');
     
     mail.setHtmlBody('Your Contact:<b> ' + contObj.Id +' </b>has been created.<p>'+
          'To view your Contact <a href=https://ap1.salesforce.com/'+contObj.Id+'>click here.</a>');
     
     // Send the email you have created.
     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
   }