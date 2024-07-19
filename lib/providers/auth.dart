import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

var session = SessionManager();

class Auth extends ChangeNotifier {
  String? token;

  void setToken(String val) {
    token = val;
    session.set("_csrf", val);
    notifyListeners();
  }

  void delToken() {
    session.remove("_csrf");
    if (token != null) {
      token = null;
      notifyListeners();
    }
  }

  bool isAuth() {
    return token != null ? true : false;
  }
}