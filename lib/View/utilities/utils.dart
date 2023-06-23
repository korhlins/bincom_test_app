import 'dart:io' show File;

import 'package:bincom_test/View/utilities/color_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bincom_test/View_Model/report_screen_provider.dart';
import 'package:provider/provider.dart';

final messengerKey = GlobalKey<ScaffoldMessengerState>();

class Utils {
  static snackBar(String? snackBarMessage) {
    if (snackBarMessage == null) return;
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: appBarColor,
          content: Text(
            snackBarMessage,
            style: GoogleFonts.lora(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
  }

  Future<void> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 20);
    if (images != null) {
      for (var image in images) {
        context.read<ReportScreenProvider>().addPhoto(image.path);
      }
    }
  }
}
