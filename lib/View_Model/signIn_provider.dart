import 'dart:io' show File;

import 'package:flutter/material.dart';

class SignInAndOutProvider extends ChangeNotifier {
  bool showSpinner = false;
  bool passwordVisible = false;
  String userName = '';
  File? profilePhoto;

  void setSpinnerAction(bool showLoader) {
    showSpinner = showLoader;
    notifyListeners();
  }

  void setUserName(String user) {
    userName = user;
    notifyListeners();
  }

  void addProfilePhoto(final filePath) {
    profilePhoto = File(filePath);
    notifyListeners();
  }

  void toggleVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void resetPhoto() => profilePhoto;

  File? get getProfilePhoto => profilePhoto;

  bool get getSpinnerAction => showSpinner;

  String get getUserName => userName;

  bool get getPasswordVisibility => passwordVisible;
}
