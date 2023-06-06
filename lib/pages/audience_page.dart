import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class AudiencePage extends StatefulWidget {
  final String title;
  final String filePath;

  const AudiencePage({Key? key, required this.title, required this.filePath}) : super(key: key);

  @override
  State createState() => _AudiencePageState();
}

class _AudiencePageState extends State<AudiencePage> {
  PdfDocument? document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  void loadDocument() async {
    final doc = await PdfDocument.openAsset(widget.filePath);
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
        body: document != null
            ? Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: PdfDocumentLoader.openAsset(
                widget.filePath,
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
