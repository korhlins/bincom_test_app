import 'package:flutter/material.dart';

class ScreenDimension {
  ScreenDimension({required this.context});

  BuildContext context;

  double getHeight() {
    double height = MediaQuery.of(context).size.height;
    return height;
  }

  double getWidth() {
    double width = MediaQuery.of(context).size.width;
    return width;
  }
}