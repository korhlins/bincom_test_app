import 'dart:io' show File;

import 'package:bincom_test/View/screens/home_screen.dart';
import 'package:bincom_test/View/utilities/utils.dart';
import 'package:bincom_test/View_Model/report_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:bincom_test/services/firebase_methods.dart';
import 'package:bincom_test/Model/upload_situation_data_model.dart';

class AddReportFeed extends StatefulWidget {
  static const String id = "AddReportFeed";

  @override
  State<AddReportFeed> createState() => _AddReportFeedState();
}

class _AddReportFeedState extends State<AddReportFeed> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController eventTypeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  List<String> imageUrl = [];
  late List<File> images = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ReportScreenProvider>().resetEventType();
    context.read<ReportScreenProvider>().resetPhoto();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
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
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(labelText: 'Description'),
                      controller: descriptionController,
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButton<String>(
                      value: context
                              .read<ReportScreenProvider>()
                              .getDropDownList
                              .isNotEmpty
                          ? context.watch<ReportScreenProvider>().getSetEvent
                          : "",
                      items: context
                          .read<ReportScreenProvider>()
                          .getDropDownList
                          .map<DropdownMenuItem<String>>(
                              (var listItem) => DropdownMenuItem<String>(
                                    value: listItem,
                                    child: Text(listItem),
                                  ))
                          .toList(),
                      onChanged: (value) {
                        context
                            .read<ReportScreenProvider>()
                            .setEventType(value!);
                      },
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        await Utils().pickImage(context, '');
                        images = context.read<ReportScreenProvider>().getPhoto;
                      },
                      child: Text('Add Photos from gallery'),
                    ),
                    SizedBox(height: 16.0),
                    if (photoList.isNotEmpty)
                      Wrap(
                        children: photoList
                            .map(
                              (photoFile) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.file(
                                  photoFile,
                                  width: 150.0,
                                  height: 150.0,
                                  fit: BoxFit.cover,
                                ),
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
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) async {
                            for (var imageFile in images) {
                              // Upload image to Firebase Cloud Storage
                              imageUrl.add(await FirebaseApis()
                                  .uploadImageToStorage(
                                      childName:
                                          'images/${imageFile.path.split('/')}.last',
                                      image: imageFile));
                            }
                            context.read<ReportScreenProvider>().uploadData(
                                SituationData(
                                    description: descriptionController.text,
                                    eventType: context
                                        .read<ReportScreenProvider>()
                                        .getSetEvent,
                                    location: locationController.text,
                                    imageUrl: imageUrl));
                            Navigator.pushNamed(context, HomeScreen.id);
                          });
                        },
                        child: const Text("Report"))
                  ]),
            ),
          ),
        ));
  }
}
