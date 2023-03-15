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
const appIP = '192.168.4.37:8080';

Future<void> testGet() async {
  var url = Uri.parse('http://$appIP/allUsers');
  var response = await get(url);
  print('Status code: ${response.statusCode}');
  print('Headers: ${response.headers}');
  print('Body: ${response.body}');
}

Future<void> loginAuthenticaiton() async {

}

Future<void> registerNewUser(String name, String email, String password) async {
  //TODO: Pass in the type of account being registered for in future
  String accountType = "admin";
  var url = Uri.parse('http://$appIP/newUser?email_address=$email&password=$password&display_name=$name&account_type=$accountType');
  //TODO In future this should likely be a POST or equivalent
  Response response = await get(url);

  //Debug text
  print('Status code: ${response.statusCode}');
  print('Headers: ${response.headers}');
  print('Body: ${response.body}');
}