import 'package:flutter/material.dart';

class UserInfo extends ChangeNotifier {
  String? username;
  String? password;

  void setUsername(String val) {
    username = val;
    notifyListeners();
  }

  void setPassword(String val) {
    password = val;
    notifyListeners();
  }

  Map get() {
    return {"username": username, "password": password};
  }
}