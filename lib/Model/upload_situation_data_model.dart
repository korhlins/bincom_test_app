import 'package:cloud_firestore/cloud_firestore.dart';

class SituationData {
  SituationData(
      {this.imageUrl, this.eventType, this.description, this.location});
  String? description;
  String? eventType;
  String? location;
  List<String>? imageUrl;

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'eventType': eventType,
      'location': location,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
