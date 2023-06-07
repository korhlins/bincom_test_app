import 'dart:io' show File;

import 'package:bincom_test/View/screens/home_screen.dart';
import 'package:bincom_test/View/utilities/utils.dart';
import 'package:bincom_test/View_Model/report_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:bincom_test/services/firebase_methods.dart';

class AddReportFeed extends StatefulWidget {
  static const String id = "AddReportFeed";

  @override
  State<AddReportFeed> createState() => _AddReportFeedState();
}

class _AddReportFeedState extends State<AddReportFeed> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController eventTypeController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  String? eventType = "";

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    locationController.dispose();
    descriptionController.dispose();
    eventType = '';
  }

  @override
  Widget build(BuildContext context) {
    final photoList = context.read<ReportScreenProvider>().getPhoto;
    return Scaffold(
        appBar: AppBar(
          title: Text('Upload Data'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Description'),
                      controller: descriptionController,
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: eventType,
                      items: const [
                        // DropdownMenuItem(
                        //   value: 'riot',
                        //   child: Text('Riot'),
                        // ),
                        // DropdownMenuItem(
                        //   child: Text('Accident'),
                        //   value: 'accident',
                        // ),
                        // DropdownMenuItem(
                        //   child: Text('Fighting'),
                        //   value: 'fighting',
                        // ),
                        // DropdownMenuItem(
                        //   child: Text('Stampede'),
                        //   value: 'stampede',
                        // ),
                        // DropdownMenuItem(
                        //   child: Text('Protest'),
                        //   value: 'protest',
                        // ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          eventType = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Type of Event'),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        File? image = await Utils()
                            .pickImage(ImageSource.gallery, context);
                        if (image != null) {
                          // Upload image to Firebase Cloud Storage
                          String imageUrl = await FirebaseMethods()
                              .uploadImageToStorage(image: image);

                          // Add the image URL to the photo list
                          context
                              .read<ReportScreenProvider>()
                              .addPhoto(imageUrl);
                        }
                      },
                      child: Text('Add Photos'),
                    ),
                    SizedBox(height: 16.0),
                    if (photoList.isNotEmpty)
                      Column(
                        children: context
                            .read<ReportScreenProvider>()
                            .getPhoto
                            .map(
                              (photo) => Image.file(
                                photo as File,
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                            )
                            .toList(),
                      ),
                    SizedBox(height: 16.0),
                    TextField(
                      decoration: InputDecoration(labelText: 'Location'),
                      controller: locationController,
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                        onPressed: () async {
                          await FirebaseMethods().uploadData(
                              description: descriptionController.text,
                              eventType: eventType,
                              location: locationController.text);
                          context.read<ReportScreenProvider>().resetPhoto();
                          Navigator.pushNamed(context, HomeScreen.id);
                          // Clear form fields after successful upload
                        },
                        child: Text("Report"))
                  ]),
            ),
          ),
        ));
  }
}
