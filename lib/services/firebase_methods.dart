import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bincom_test/View/screens/home_screen.dart';
import 'package:bincom_test/View/screens/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bincom_test/View/utilities/utils.dart';
import 'dart:io' show File;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  UserCredential? userCredential;
  int docNum = 0;
  void docNumber() {
    docNum += 1;
  }

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

  Future<void> uploadData(
      {required Map<String, dynamic> addData,
      required String data,
      required String docsName}) async {
    docNumber();
    final DocumentReference dataCollection = _storage
        .collection(data)
        .doc("$docsName-${userCredential?.user?.displayName}");
    // Upload data to Firestore
    try {
      await dataCollection.set(addData
          // Additional fields or data you want to store
          );
    } on FirebaseException catch (e) {
      Utils.snackBar(e.message);
    }
  }

  initInfo() {
    var androidInitiatize =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iOSInitiatize = const DarwinInitializationSettings();
    var initializationSetting =
        InitializationSettings(android: androidInitiatize, iOS: iOSInitiatize);
    // Configure the callback for when a notification is received while the app is in the foreground and takes you to another screen
    flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (notificationResponse) {
      try {} catch (e) {}
    });
    //listen to messages from firebase. implement this. The event parameter takes a object of the Remote message.
    FirebaseMessaging.onMessage.listen((message) async {
      // Basic settings
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true);
      // Platform specific setting
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('ReportInfo', 'ReportInfo',
              importance: Importance.high,
              styleInformation: bigTextStyleInformation,
              priority: Priority.high,
              playSound: true);
      NotificationDetails plaformChannelSpecifics = NotificationDetails(
          android: androidNotificationDetails,
          iOS: const DarwinNotificationDetails());
      try {
        await flutterLocalNotificationsPlugin.show(
            0,
            message.notification!.title,
            message.notification!.body,
            plaformChannelSpecifics,
            payload: message.data['body']);
      } catch (e) {
        print(e);
      }
    });
  }

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();
    final fCMToken = await firebaseMessaging.getToken();
    uploadData(
        addData: {"Token": fCMToken}, data: 'UserTokens', docsName: 'Users');
    initInfo();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            "Content-Type": "Application/json",
            "Authorization":
                "key=BMiCATdeSXjSZ6Usc2OUcoJrsrw0ZHnz3A3Wd1RAW48wkUZRC3sQlc-qI5IEJN4W1uzY3H3RJ0fmPWr_cX5ccAw"
          },
          body: jsonEncode(<String, dynamic>{
            "priority": "high",
            "data": <String, dynamic>{
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "status": "done",
              "body": body,
              "title": title,
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "ReportInfo"
            },
            "to": token,
          }));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
