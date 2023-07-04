import 'dart:io';
import 'package:bincom_test/Model/upload_situation_data_model.dart';
import 'package:bincom_test/services/firebase_methods.dart';
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

  void uploadData(SituationData situationData) async {
    await FirebaseApis().uploadData(situationData);
  }

  String get getSetEvent => eventType!;

  List<File> get getPhoto => photos;

  List get getDropDownList => dropDownButtonList;
}
