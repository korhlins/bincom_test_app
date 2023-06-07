import 'package:flutter/material.dart';

class TextLink extends StatelessWidget {
  TextLink({required this.text, required this.onTap, required this.decoration});

  String text;
  Function() onTap;
  TextDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
            decoration: decoration),
      ),
    );
  }
}
