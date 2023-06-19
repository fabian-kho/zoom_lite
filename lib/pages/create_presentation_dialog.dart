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
  bool _isLoading = false;
  String? _presentationNameError;
  Map<String, dynamic> presentation = {};

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  String? validatePresentationName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Presentation name cannot be empty';
    }
    if (value.contains('#')) {
      return 'Presentation name should not contain "#" symbol';
    }
    return null;
  }

  Future<void> _validateAndUpload() async {
    final String presentationName = _textFieldController.text.trim();
    final String? validationError = validatePresentationName(presentationName);

    setState(() {
      _presentationNameError = validationError;
    });

    if (validationError != null) {
      return;
    }

    final FilePickerResult? result =
    await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _isLoading = true;
      });

    upload(result);
    }
  }

  void upload(FilePickerResult result) {
    final filePath = result.files.single.path;

    final firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    final firebase_storage.Reference storageRef = storage
        .ref()
        .child('presentations')
        .child(_textFieldController.text);
    final firebase_storage.UploadTask uploadTask =
    storageRef.putFile(File(filePath!));

    uploadTask.whenComplete(() async {
      try {
        final String downloadUrl = await storageRef.getDownloadURL();
        final DatabaseReference presentationRef = _databaseRef.child('presentations').push();

        // store the presentation data in the presentation object
        presentation = {
          'id': presentationRef.key as String,
          'file_path': downloadUrl,
        };

        presentationRef.set({
          'title': _textFieldController.text,
          'file_path': downloadUrl,
          'page_number': '1',
          'time': DateTime.now().millisecondsSinceEpoch,
        });
      } catch (e) {
        print('Error uploading file: $e');

        const snackBar = SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } finally {
        setState(() {
          _isLoading = false;
        });
        // Close the upload dialog
        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PresentationPage(
              presentation: presentation,
              title: _textFieldController.text,
              filePath: filePath,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create a new presentation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _textFieldController,
            decoration: const InputDecoration(
              hintText: 'Enter presentation name',
            ),
            validator: validatePresentationName,
          ),
          if (_presentationNameError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _presentationNameError!,
                style: const TextStyle(
                  color: Colors.red,
                ),
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
          onPressed: _validateAndUpload,
          child: _isLoading ? const CircularProgressIndicator() : const Text('Upload'),
        ),
      ],
    );
  }
}
