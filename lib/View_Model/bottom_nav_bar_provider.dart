import 'package:flutter/cupertino.dart';

class BottomNavBarProvider extends ChangeNotifier {
  int selectedIndex = 0;

  int get getSelectedIndex {
    return selectedIndex;
  }

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
