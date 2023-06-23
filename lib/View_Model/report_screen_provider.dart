import 'dart:io';
import 'package:flutter/cupertino.dart';

class ReportScreenProvider extends ChangeNotifier {
  List<File> photos = [];
  List<String> dropDownButtonList = [
    'Riot',
    'Accident',
    'Protest',
    'Stampede',
    'Fighting'
  ];
  String? eventType;

  void setEventType(String value) {
    eventType = value;
    notifyListeners();
  }

  void addPhoto(final filePath) {
    photos.add(File(filePath));
    notifyListeners();
  }

  void resetPhoto() => photos.clear();

  void resetEventType() {
    eventType = dropDownButtonList.first;
    notifyListeners();
  }

  String get getSetEvent => eventType!;

  List<File> get getPhoto => photos;

  List get getDropDownList => dropDownButtonList;
}
