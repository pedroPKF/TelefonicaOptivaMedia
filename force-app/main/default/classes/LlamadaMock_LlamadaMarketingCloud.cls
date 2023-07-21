@isTest
global class LlamadaMock_LlamadaMarketingCloud implements HttpCalloutMock{
  global HttpResponse respond(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    res.setStatus('OK');
    res.setStatusCode(200);
    res.setBody('{'+
    '"access_token": "eyJhbGciOiJIUzI1NiIsImtpZCI6IjQiLCJ2ZXIiOiIxIiwidHlwIjoiSldUIn0.eyJhY2Nlc3NfdG9rZW4iOiJXNVpHMno0TnBISlZaUmJTdmJpNjc5QlQiLCJjbGllbnRfaWQiOiJxb3UxOWE1bnZ4cG1yOWVmb2t0bXJjbHYiLCJlaWQiOjUzNjAwMTQ1Niwic3RhY2tfa2V5IjoiUzUxIiwicGxhdGZvcm1fdmVyc2lvbiI6MiwiY2xpZW50X3R5cGUiOiJTZXJ2ZXJUb1NlcnZlciIsInBpZCI6MjcyfQ.xNTV5rM8a9o9JZ4q3MJcabiBiIKx7gToKTotjTWQf5M.Ef6uLlVTStb8fgzwJ49e-gomr2-nmYT_cFSmmyS5pWRxFb6vP5vid3VTotkef0BkxK2P-xhmP3d6rr4ArK-xQtmnfxLRr7pvQzf5VPeq4fATQtd3KqlMC9ZGNZHc4cvGoWD_dv8ukxXyH7fgbOqAz83N7GrYOhcwWnQ7i",'+
    '  "token_type": "Bearer",'+
    '  "expires_in": 1079,'+
    '  "scope": "offline documents_and_images_read documents_and_images_write saved_content_read saved_content_write automations_execute automations_read automations_write journeys_execute journeys_read journeys_write email_read email_send email_write audiences_read audiences_write list_and_subscribers_read list_and_subscribers_write data_extensions_read data_extensions_write file_locations_read file_locations_write tracking_events_read marketing_cloud_connect_read marketing_cloud_connect_write marketing_cloud_connect_send event_notification_callback_create event_notification_callback_read event_notification_callback_update event_notification_callback_delete tracking_events_write key_manage_view key_manage_rotate key_manage_revoke journeys_aspr journeys_delete market_audience_create market_audience_view market_audience_update market_audience_delete market_audience_member_create market_audience_member_view market_audience_member_update market_audience_member_delete contact_bu_mapping_create contact_bu_mapping_view contact_bu_mapping_update contact_bu_mapping_delete http_headers_view http_headers_update http_headers_delete",'+
    '  "soap_instance_url": "https://mcpl71mqlfzyrv0zc2rl2tby76c0.soap.marketingcloudapis.com/",'+
    ' "rest_instance_url": "https://mcpl71mqlfzyrv0zc2rl2tby76c0.rest.marketingcloudapis.com/"'+
    '}'
    );
    return res;
  }
}