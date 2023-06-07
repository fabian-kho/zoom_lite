import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AudiencePage extends StatefulWidget {
  final String title;
  final String firebaseStorageUrl;

  const AudiencePage({Key? key, required this.title, required this.firebaseStorageUrl}) : super(key: key);

  @override
  State createState() => _AudiencePageState();
}

class _AudiencePageState extends State<AudiencePage> {
  PdfDocument? document;
  String? localFilePath;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  void loadDocument() async {

    // Download the file from Firebase Storage
    File file = await downloadFile(widget.firebaseStorageUrl, widget.title);
    localFilePath = file.path;

    final doc = await PdfDocument.openFile(file.path);
    setState(() {
      document = doc;
    });
  }

  Future<bool> showExitConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure you want to leave the presentation?'),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('LEAVE'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<File> downloadFile(String firebaseStorageUrl, String fileName) async {
    // Get the reference to the file from the Firebase Storage URL
    Reference ref = FirebaseStorage.instance.refFromURL(firebaseStorageUrl);

    // Get the temporary directory of the device
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    // Create a new file in the temporary directory
    File file = File('$tempPath/$fileName.pdf');

    // Download the file from Firebase Storage
    await ref.writeToFile(file);

    return file;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitConfirmationDialog,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldLeavePresentation = await showExitConfirmationDialog();
              if (shouldLeavePresentation == true) {
                if (!mounted) return;
                Navigator.pop(context);
              }
            },
          ),
          title: Text(widget.title),
        ),
        body: document != null && localFilePath != null
            ? Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: PdfDocumentLoader.openFile(
                localFilePath!,
                onError: (err) => print(err),
                pageNumber: 1,
                pageBuilder: (context, textureBuilder, pageSize) => textureBuilder(),
              ),
            ),
          ),
        )
            : const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
