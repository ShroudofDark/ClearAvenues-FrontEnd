import 'package:clear_avenues/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final authServiceProvider = Provider((ref) => AuthService());

class AuthService {
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

  Future<bool> registerUser(String email, String displayName, String password,
      String accountType) async {
    //If the validation is successful, register user
    var url = Uri(
      scheme: 'http',
      host: Constants.serverIP,
      port: Constants.serverPort,
      path: '/users/new',
      queryParameters: {
        'email_address': email,
        'password': password,
        'display_name': displayName,
        'account_type': accountType,
      },
    );
    try {
      Response response = await post(url);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (err) {
      debugPrint("Error registering account: ${err.toString()}");
    }
    return false;
  }
}
