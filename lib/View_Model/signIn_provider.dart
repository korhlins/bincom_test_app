import 'package:flutter/material.dart';

class SignInAndOutProvider extends ChangeNotifier {
  bool showSpinner = false;
  bool passwordVisible = false;
  String userName = '';

  void setSpinnerAction(bool showLoader) {
    showSpinner = showLoader;
    notifyListeners();
  }

  void setUserName(String user) {
    userName = user;
    notifyListeners();
  }

  void toggleVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  bool get getSpinnerAction => showSpinner;

  String get getUserName => userName;

  bool get getPasswordVisibility => passwordVisible;
}
