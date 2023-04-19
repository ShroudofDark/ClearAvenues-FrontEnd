import 'package:clear_avenues/models/User.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';

import 'constants.dart';

final userProvider = NotifierProvider<UserNotifier, User>(() {
  return UserNotifier();
});

class UserNotifier extends Notifier<User> {
  @override
  User build() {
    return User();
  }

  void setEmail(String email){
    state = state.copyWith(email:email);
  }
  void setName(String name){
    state = state.copyWith(name:name);
  }
  void setAccountType(String type){
    state.copyWith(accountType: type);
  }

  Future<bool> submitReport(String reportType, String description, String latitude, String longitude, String locationId) async{
    var url = Uri(
      scheme: 'http',
      host: Constants.serverIP,
      port: Constants.serverPort,
      path: '/users/${state.email}/reports',
      queryParameters: {
        'reportType': reportType,
        'latitude': latitude,
        'longitude': longitude,
        'comment': description,
        'locationId': locationId
      }
    );
    var response = await post(url);
    if (response.statusCode == 200){
      return true;
    }
    debugPrint("Error submitting report: ${response.body}");
    return false;
  }
}
