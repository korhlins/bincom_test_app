import 'package:bincom_test/Model/upload_situation_data_model.dart';
import 'package:bincom_test/View/screens/home_screen.dart';
import 'package:bincom_test/View/screens/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bincom_test/View/utilities/utils.dart';
import 'dart:io' show File;
import 'package:firebase_storage/firebase_storage.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification!.title}");
  print("Body: ${message.notification!.body}");
  print("Payload: ${message.data}");
}

class FirebaseApis {
  final navigatorKey = GlobalKey<NavigatorState>();
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseFirestore.instance;
  final firebaseMessaging = FirebaseMessaging.instance;
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
      e.code.isNotEmpty ? Utils.snackBar(e.code) : null;
    } catch (e) {
      Utils.snackBar(e.toString());
    }
    if (userCredential?.user != null) {
      Utils.snackBar("user signed in: ${userCredential?.user?.displayName}");
      Navigator.pushNamed(context!, HomeScreen.id);
    }
  }

  Future<void> signUpWithAndPassword(
      {String? email,
      String? password,
      String? userName,
      File? image,
      BuildContext? context}) async {
    const CircularProgressIndicator();
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
      if (e.code == "email-already-in-use") {
        Utils.snackBar(e.code);
        Navigator.pushNamed(context!, LogInScreen.id);
      } else {
        Utils.snackBar(e.code);
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

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();
    final fCMToken = await firebaseMessaging.getToken();
    print('Token: $fCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
