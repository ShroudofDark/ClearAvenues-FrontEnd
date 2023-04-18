class User {
  String? email;
  String? name;
  String? accountType;

  User({this.email,this.name, this.accountType});

  User.fromJson(Map<String, dynamic> json) {
    email = json['emailAddress'];
    name = json['displayName'];
    accountType = json['accountType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emailAddress'] = email;
    data['displayName'] = name;
    data['accountType'] = accountType;
    return data;
  }
  User copyWith({String? email, String? name, String? accountType}){
    return User(
      email: email ?? this.email,
      name: name ?? this.name,
      accountType: accountType ?? this.accountType
    );
  }
}
