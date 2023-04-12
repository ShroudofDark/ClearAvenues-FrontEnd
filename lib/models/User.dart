import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  String? email;
  String? name;
  String? passwordHash;
  String? accountType;

  User({this.email, this.name, this.accountType});

  User.fromJson(Map<String, dynamic> json) {
    email = json['emailAddress'];
    name = json['displayName'];
    passwordHash = json['passwordHash'];
    accountType = json['accountType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emailAddress'] = this.email;
    data['displayName'] = this.name;
    data['accountType'] = this.accountType;
    return data;
  }
}
