import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class PresentationPage extends StatefulWidget {
  final String title;
  final String filePath;

  const PresentationPage({Key? key, required this.title, required this.filePath}) : super(key: key);

  @override
  State createState() => _PresentationPageState();
}

class _PresentationPageState extends State<PresentationPage> {
  PdfDocument? document;
  final controller = PdfViewerController();
  int currentPage = 1;
  // page size of the document should be 16:9
  bool isVerticalMode = true;

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

  void goToNextPage() {
    if (currentPage < document!.pageCount - 1) {
      setState(() {
        currentPage++;
      });
    }
  }

  void goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  void toggleOrientation() {
    setState(() {
      isVerticalMode = !isVerticalMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Open settings
            },
          ),
        ],
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
                    pageNumber: currentPage,
                    pageBuilder: (context, textureBuilder, pageSize) => textureBuilder()
                ),
              ),
            ),
          )
          : const Center(
        child: CircularProgressIndicator(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: goToPreviousPage,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: goToNextPage,
            ),
          ],
        ),
      )
    );
  }
}
