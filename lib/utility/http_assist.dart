import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:clear_avenues/constants.dart';

Future<bool> loginAuthentication(String email, String password) async {
  var url = Uri(
    scheme: 'http',
    host: Constants.serverIP,
    port: Constants.serverPort,
    path: '/users/login',
    queryParameters: {
      'email_address': email,
      'password': password,
    },
  );

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
