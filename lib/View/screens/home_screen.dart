import 'package:bincom_test/View_Model/report_screen_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bincom_test/View_Model/bottom_nav_bar_provider.dart';
import 'package:provider/provider.dart';
import 'package:bincom_test/View/screens/profile_screen.dart';
import 'package:bincom_test/View/screens/report_feed_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add_Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: context.read<BottomNavBarProvider>().getSelectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          context.read<BottomNavBarProvider>().setSelectedIndex(index);
          index == 0
              ? Navigator.pushNamed(context, HomeScreen.id)
              : index == 1
                  ? Navigator.pushNamed(context, AddReportFeed.id)
                  : Navigator.pushNamed(context, AccountScreen.id);
        },
      ),
      appBar: AppBar(
        title: Text("Citizens Reporting Solution"),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('data').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final reports = snapshot.data?.docs ?? [];
            if (reports.isEmpty) {
              return Center(
                child: Text('No reports found.'),
              );
            }

            return ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index].data();

                return Card(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                              (report as Map<String, dynamic>)['description'] ??
                                  ''),
                          subtitle: Text((report)['eventType'] ?? ''),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                (report)[user!.photoURL.toString()] ?? ''),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if ((report)[user!.photoURL.toString()] != null &&
                                  (report)[user!.photoURL.toString()].length >=
                                      1)
                                Image.network(
                                  (report)[user!.photoURL.toString()][0] ?? '',
                                  width: 50.0,
                                  height: 50.0,
                                  fit: BoxFit.cover,
                                ),
                              SizedBox(width: 8.0),
                              if ((report)[user!.photoURL.toString()] != null &&
                                  (report)[user!.photoURL.toString()].length >=
                                      2)
                                Image.network(
                                  (report)[user!.photoURL.toString()][1] ?? '',
                                  width: 50.0,
                                  height: 50.0,
                                  fit: BoxFit.cover,
                                ),
                            ],
                          ),
                        ),
                        Text("location: " +
                                (report as Map<String, dynamic>)['location'] ??
                            ''),
                      ]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}