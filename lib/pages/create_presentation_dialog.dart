import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:zoom_lite/pages/presentation_page.dart';

class CreatePresentationDialog extends StatefulWidget {
  const CreatePresentationDialog({Key? key}) : super(key: key);

  @override
  State createState() => _CreatePresentationDialogState();
}

class _CreatePresentationDialogState extends State<CreatePresentationDialog> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final TextEditingController _textFieldController = TextEditingController();

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create a new presentation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(
              hintText: 'Enter presentation name',
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Only PDF files are supported',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
            );

            if (result != null) {
              final filePath = result.files.single.path;
              print(filePath);

              final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
              final firebase_storage.Reference storageRef = storage.ref().child('presentations').child(_textFieldController.text);
              final firebase_storage.UploadTask uploadTask = storageRef.putFile(File(filePath!));

              uploadTask.whenComplete(() async {
                try {
                  final String downloadUrl = await storageRef.getDownloadURL();
                  _databaseRef.child('presentations').push().set({
                    'name': _textFieldController.text,
                    'file_path': downloadUrl,
                  });

                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PresentationPage(title: _textFieldController.text),
                    ),
                  );
                } catch (e) {
                  print('Error uploading file: $e');
                  showErrorDialog();
                }
              });
            }
          },
          child: const Text('Upload'),
        ),
      ],
    );
  }

  void showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: const Text('An error occurred. Please try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
