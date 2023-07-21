global class LlamadaMock_MiddlewareMethod{

global class llamadas_Mock implements HttpCalloutMock{
  global HttpResponse respond(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    res.setStatus('OK');
    res.setStatusCode(201);
    res.setBody('{'+
    '"id": "0PK7Y0000046DCkWAM",'+
    ' "success": true,'+
    ' "errors": [],'+
    ' "created": true'+
    ' }');
    return res;
  }
}
global class LlamadaMock_middleware implements HttpCalloutMock{
  global HTTPResponse respond(HTTPRequest req) {
    HttpResponse res = new HttpResponse();
    res.setStatus('OK');
    res.setStatusCode(200);
    res.setBody('0.0.0');
    return res;
  }
  
}

global class LlamadaMock_zipCpde implements HttpCalloutMock{
  global HTTPResponse respond(HTTPRequest req) {
    HttpResponse res = new HttpResponse();
    res.setStatus('No Content');
    res.setStatusCode(204);
    res.setBody('0.0.0');
    return res;
  }
  
}
}