import 'package:bincom_test/View/utilities/media_query.dart';
import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  TextFields({
    required this.hintText,
    this.controller,
    required this.passwordVisible,
    this.suffixIcon,
    this.inputTextType,
  });

  String? hintText;
  TextEditingController? controller;
  bool passwordVisible;
  IconButton? suffixIcon;
  TextInputType? inputTextType;

  @override
  Widget build(BuildContext context) {
    double height = ScreenDimension(context: context).getHeight();

    return TextField(
      keyboardType: inputTextType,
      controller: controller,
      enableSuggestions: true,
      textAlign: TextAlign.start,
      obscureText: passwordVisible,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        hintStyle: const TextStyle(
          color: Colors.black26,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFF2F6FF)),
          borderRadius: BorderRadius.circular(height * 0.02),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFF2F6FF),
          ),
          borderRadius: BorderRadius.circular(height * 0.02),
        ),
      ),
    );
  }
}
