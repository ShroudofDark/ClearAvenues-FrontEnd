import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

/* Example code - https://suragch.medium.com/how-to-make-http-requests-in-flutter-d12e98ee1cef

  //test url
  static const urlPrefix = 'https://jsonplaceholder.typicode.com';

  Future<void> makeGetRequest() async {
    final url = Uri.parse('$urlPrefix/posts');
    Response response = await get(url);
    print('Status code: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');
  }

  Future<void> makePostRequest() async {
    final url = Uri.parse('$urlPrefix/posts');
    final headers = {"Content-type": "application/json"};
    final json = '{"title": "Hello", "body": "body text", "userId": 1}';
    final response = await post(url, headers: headers, body: json);
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');
  }
 */

//Append this wherever the IP address is used to access database
const String appIP = "192.168.137.1";
const int appPort = 8080;

Future<void> testGet() async {
  var url = Uri.parse('http://$appIP/users');
  var response = await get(url);
  if (kDebugMode) {
    print('Status code: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');
  }
}

// In Progress....
//final ReportsProvider = StreamProvider<String>((ref) async* {
// final re
//});
