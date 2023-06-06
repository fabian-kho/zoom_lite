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
    print(widget.filePath);
    final doc = await PdfDocument.openFile(widget.filePath);
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
    if (currentPage > 1) {
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

  Future<bool> showExitConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Ending the presentation will disconnect all viewers. Are you sure you want to end the presentation?'),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('END PRESENTATION'),
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
    final isFirstPage = currentPage == 1;
    final isLastPage = currentPage == document?.pageCount;
    return WillPopScope(
      onWillPop: showExitConfirmationDialog,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldEndPresentation = await showExitConfirmationDialog();
              if (shouldEndPresentation == true) {
                if(!mounted) return;
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
                onPressed: isFirstPage ? null : goToPreviousPage,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: isLastPage ? null : goToNextPage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
