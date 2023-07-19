import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportFeedProvider extends ChangeNotifier {
  Stream<QuerySnapshot> getReportStream() => FirebaseFirestore.instance
      .collection('data')
      .orderBy('timestamp', descending: true)
      .snapshots();
}
