import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bincom_test/View/utilities/utils.dart';
import 'dart:io' show File;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bincom_test/View/screens/home_screen.dart';

class FirebaseMethods {
  FirebaseMethods({this.context});
  BuildContext? context;
  final navigatorKey = GlobalKey<NavigatorState>();

  final _auth = FirebaseAuth.instance;
  Future<String> uploadImageToStorage({String? childName, File? image}) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    UploadTask uploadTask = storage
        .ref()
        .child(childName!)
        .child(_auth.currentUser!.uid)
        .putFile(image!);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> signInWithEmailAndPassword(
      {String? email, String? password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        Utils.snackBar("No User found for that email.");
      } else if (e.code == "wrong-password") {
        Utils.snackBar("Wrong password provided for that user.");
      }
    } catch (e) {
      Utils.snackBar("An error occurred. Please try again.");
    }
  }

  Future<void> signUpWithAndPassword(
      {String? email, String? password, String? userName, File? image}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      User user = _auth.currentUser!;
      await user.updateDisplayName(userName);
      if (image != null) {
        String url =
            await uploadImageToStorage(childName: 'profilepics', image: image);
        await user.updatePhotoURL(url).whenComplete(() =>
            navigatorKey.currentState!.popUntil((route) => route.isFirst));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        Utils.snackBar("The password provided is too weak.");
      } else if (e.code == "email-already-in-use") {
        Utils.snackBar("The account already exit for that email.");
      }
    } catch (e) {
      Utils.snackBar(e.toString());
    }
  }

  Future<void> uploadData(
      {String? description, String? eventType, String? location}) async {
    final CollectionReference dataCollection =
        FirebaseFirestore.instance.collection('data');
    // Upload data to Firestore
    await dataCollection.add({
      'description': description,
      'eventType': eventType,
      'location': location,
      // Additional fields or data you want to store
    });
  }
}