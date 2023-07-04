import 'package:bincom_test/View/screens/report_feed_screen.dart';
import 'package:bincom_test/View/screens/sign_up_screen.dart';
import 'package:bincom_test/View/screens/sign_in_screen.dart';
import 'package:bincom_test/View/screens/profile_screen.dart';
import 'package:bincom_test/View_Model/bottom_nav_bar_provider.dart';
import 'package:bincom_test/View_Model/report_feed_provider.dart';
import 'package:bincom_test/View_Model/report_screen_provider.dart';
import 'package:bincom_test/View_Model/signIn_provider.dart';
import 'package:bincom_test/View/utilities/utils.dart';
import 'package:bincom_test/services/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:bincom_test/View/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApis().initNotifications();
  runApp(IncidentReportApp());
}

class IncidentReportApp extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<SignInAndOutProvider>(
              create: (BuildContext context) => SignInAndOutProvider()),
          ChangeNotifierProvider<BottomNavBarProvider>(
              create: (BuildContext context) => BottomNavBarProvider()),
          ChangeNotifierProvider<ReportScreenProvider>(
              create: (BuildContext context) => ReportScreenProvider()),
          ChangeNotifierProvider<ReportFeedProvider>(
              create: (BuildContext context) => ReportFeedProvider()),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: messengerKey,
          initialRoute: user != null ? HomeScreen.id : LogInScreen.id,
          routes: {
            HomeScreen.id: (context) => HomeScreen(),
            LogInScreen.id: (context) => LogInScreen(),
            SignUpScreen.id: (context) => SignUpScreen(),
            AccountScreen.id: (context) => AccountScreen(),
            AddReportFeed.id: (context) => AddReportFeed(),
          },
        ));
  }
}
