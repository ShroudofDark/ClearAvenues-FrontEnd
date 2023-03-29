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

Future<bool> loginAuthentication(String email, String password) async {
  var url = Uri(
    scheme: 'http',
    host: appIP,
    port: appPort,
    path: '/users/login',
    queryParameters: {
      'email_address': email,
      'password': password,
    },
  );

  /*
  var url = Uri.parse(
      'http://$appIP/users/login?email_address=$email&password=$password');
  */
  var response = await get(url);

  //Currently authentication returns a true if there is a match
  if (response.body == "true") {
    return Future<bool>.value(true);
  }
  if (kDebugMode) {
    print(response.body);
  }

  //Handles basically all error codes, but at the moment on a failed match it returns error code 500
  return Future<bool>.value(false);
}

Future<void> registerNewUser(String name, String email, String password) async {
  //TODO: Pass in the type of account being registered for in future
  String accountType = "admin";

  // Neater way
  var url = Uri(
    scheme: 'http',
    host: appIP,
    port: 8080,
    path: '/users/new',
    queryParameters: {
      'email': email,
      'password': password,
      'display_name': name,
      'account_type': accountType
    },
  );
  // Old way
  //var url = Uri.parse(
  //    'http://$appIP/users/new?email_address=$email&password=$password&display_name=$name&account_type=$accountType');

  Response response = await post(url);
  // Only print if we're running in debug mode
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
