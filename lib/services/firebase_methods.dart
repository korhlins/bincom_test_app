import 'package:bincom_test/Model/upload_situation_data_model.dart';
import 'package:bincom_test/View/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bincom_test/View/utilities/utils.dart';
import 'dart:io' show File;
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseMethods {
  final navigatorKey = GlobalKey<NavigatorState>();
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseFirestore.instance;
  UserCredential? userCredential;

  Future<String> uploadImageToStorage({String? childName, File? image}) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    final storageRef = storage.ref().child(childName!);
    await storageRef.putFile(image!);
    String imageUrl = await storageRef.getDownloadURL();
    return imageUrl;
  }

  Future<void> signInWithEmailAndPassword(
      {String? email, String? password, BuildContext? context}) async {
    try {
      userCredential = await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        Utils.snackBar("Wrong password provided for that user.");
      } else if (e.code == "user-not-found") {
        Utils.snackBar("No User found for that email.");
      } else if (userCredential?.user != null) {
        Utils.snackBar("user signed in: ${userCredential?.user?.displayName}");
        Navigator.pushNamed(context!, HomeScreen.id);
      }
    } catch (e) {
      Utils.snackBar("An error occurred. Please try again.");
    }
  }

  Future<void> signUpWithAndPassword(
      {String? email,
      String? password,
      String? userName,
      File? image,
      BuildContext? context}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      User user = _auth.currentUser!;
      await user.updateDisplayName(userName);
      if (image != null) {
        String url =
            await uploadImageToStorage(childName: 'profiles', image: image);
        await user.updatePhotoURL(url);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        Utils.snackBar("Invalid email");
      } else if (e.code == "weak-password") {
        Utils.snackBar("The password provided is too weak.");
      } else if (e.code == "email-already-in-use") {
        Utils.snackBar("The account already exit for that email.");
      }
    } catch (e) {
      Utils.snackBar(e.toString());
    }
    if (_auth.currentUser?.uid != null) {
      Utils.snackBar("sign up successful!");
      Navigator.pushNamed(context!, HomeScreen.id);
    }
  }

  Future<void> uploadData(SituationData situationData) async {
    final CollectionReference dataCollection = _storage.collection('data');
    // Upload data to Firestore
    try {
      await dataCollection.add({
        situationData.toMap()
        // Additional fields or data you want to store
      });
    } on FirebaseException catch (e) {
      Utils.snackBar(e.message);
    }
  }
}
