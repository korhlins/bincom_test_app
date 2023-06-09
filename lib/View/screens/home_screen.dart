import 'package:bincom_test/View/utilities/media_query.dart';
import 'package:bincom_test/View_Model/report_feed_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bincom_test/View_Model/bottom_nav_bar_provider.dart';
import 'package:bincom_test/View_Model/report_feed_provider.dart';
import 'package:provider/provider.dart';
import 'package:bincom_test/View/screens/profile_screen.dart';
import 'package:bincom_test/View/screens/report_feed_screen.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance;
  List<String> imageUrl = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    double width = ScreenDimension(context: context).getWidth();

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
        child: SmartRefresher(
          controller: refreshController,
          enablePullDown: true,
          child: StreamBuilder<QuerySnapshot>(
            stream: context.read<ReportFeedProvider>().getReportStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final reports = snapshot.data?.docs ?? [];
              if (reports.isEmpty) {
                return const Center(
                  child: Text('No reports found.'),
                );
              }

              return ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index].data() as Map<String, dynamic>;

                  return Padding(
                    padding: EdgeInsets.only(
                        left: width / 35, right: width / 35, top: width / 50),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(user.currentUser!.photoURL!),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${user.currentUser!.displayName}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    (report)['description'] ?? '',
                                  ),
                                  Wrap(
                                      children: ((report)['imageUrl']
                                              as List<dynamic>)
                                          .map((imageUrl) => Image.network(
                                                imageUrl,
                                                width: width / 5,
                                                height: width / 5,
                                                fit: BoxFit.cover,
                                              ))
                                          .toList())
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: width / 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("EventType: ${(report)['eventType']}" ?? ''),
                              Text("location: ${(report)['location'] ?? ''}"),
                            ],
                          ),
                        ),
                        Divider(thickness: width / 230)
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
