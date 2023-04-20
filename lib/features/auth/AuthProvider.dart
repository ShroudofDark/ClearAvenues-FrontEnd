import 'dart:convert';

import 'package:clear_avenues/models/User.dart';
import 'package:clear_avenues/providers.dart';
import 'package:clear_avenues/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final authServiceProvider = Provider((ref) => AuthService(ref));

class AuthService {
  final Ref ref;
  late final Client client;
  AuthService(this.ref){
    client = ref.read(httpClientProvider);
  }
  Future<bool> loginAuthentication(String email, String password, WidgetRef ref) async {
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

    var response = await client.get(url);

    //Currently authentication returns a true if there is a match
    if (response.body == "true") {
      setUserInformation(email, ref);
      return Future<bool>.value(true);
    }
    if (kDebugMode) {
      print(response.body);
    }

    //Handles basically all error codes, but at the moment on a failed match it returns error code 500
    return Future<bool>.value(false);
  }

  void setUserInformation(String email, WidgetRef ref) async {
    //Fetch user's information from database
    var url = Uri(
      scheme: 'http',
      host: Constants.serverIP,
      port: Constants.serverPort,
      path: '/users/$email',
      queryParameters: {
      },
    );
    var response = await client.get(url);

    if(response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      User temp = User.fromJson(decodedData);
      ref.read(userProvider.notifier).setEmail(temp.email!);
      ref.read(userProvider.notifier).setName(temp.name!);
      ref.read(userProvider.notifier).setAccountType(temp.accountType!);
    }
    else {
      debugPrint("Something Went Wrong");
    }
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
      Response response = await client.post(url);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (err) {
      debugPrint("Error registering account: ${err.toString()}");
    }
    return false;
  }
}
