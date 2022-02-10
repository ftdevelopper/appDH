import 'package:http/http.dart' as http;

class DriversProvider {
  static const String _baseURL = 'doshermanos.teamplace.finneg.com';
  static const String _topHeaderLines = '/BSA/api/';

  final http.Client _httpClient;

  DriversProvider ({http.Client? httpClient})
  : _httpClient = httpClient ?? http.Client();

  Future<http.Response?> callApi({
    required String endpoint, required Map<String, String> parameters
  }) async {
    var uri = Uri.https(_baseURL,_topHeaderLines + endpoint,parameters);
    http.Response? response;

    print('Trying to connect: $uri');
    
    try {
      response = await _httpClient.get(uri);  
    } catch (e) {
      print(e);
      response = null;
    }
    

    print('''Respuesta:
      headers: ${response!.headers}
      status code: ${response.statusCode}
      reason parse: ${response.reasonPhrase}
      body: ${response.body}
    ''');

    return response;
  }
}