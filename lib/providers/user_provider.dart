import 'package:flutter/material.dart';
import 'package:flutter_mario_garcia_app/models/user.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;

  UserModel get currentUser => _currentUser!;

  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }
}
