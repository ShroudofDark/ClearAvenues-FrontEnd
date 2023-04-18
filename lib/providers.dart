import 'package:clear_avenues/models/User.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}
