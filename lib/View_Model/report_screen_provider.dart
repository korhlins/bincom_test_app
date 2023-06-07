import 'dart:io';
import 'package:flutter/cupertino.dart';

class ReportScreenProvider extends ChangeNotifier {
  List<File> photos = [];

  List<File> get getPhoto {
    return photos;
  }

  void addPhoto(final filePath) {
    photos.add(File(filePath));
    notifyListeners();
  }

  void resetPhoto() {
    photos.clear();
  }
}
