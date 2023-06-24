import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:zoom_lite/components/list_item.dart';
import 'package:zoom_lite/models/presentation.dart';
import 'package:zoom_lite/pages/audience_page.dart';
import 'package:zoom_lite/pages/create_presentation_dialog.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child('presentations');

  List<ListItem> allPresentations = [];
  List<ListItem> filteredPresentations = [];

  @override
  void initState() {
    super.initState();
    _fetchPresentations();
  }

  Future<File> downloadPdfFile(String fileUrl) async {
    final Reference ref = FirebaseStorage.instance.refFromURL(fileUrl);

    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final File file = File('$tempPath/${ref.name}');

    await ref.writeToFile(file);

    return file;
  }

  Future<Image> extractFirstPageImage(File pdfFile) async {
    final PdfDocument doc = await PdfDocument.openFile(pdfFile.path);
    // Extract the first page as an image
    final firstPage = await doc.getPage(1);
    final pageImage = await firstPage.render();
    final image = await pageImage.createImageDetached();
    final pngData = await image.toByteData(format: ImageByteFormat.png);

    return Image.memory(Uint8List.view(pngData!.buffer));
  }

  void _fetchPresentations() {
    _databaseRef.onChildAdded.listen((event) async {
      final key = event.snapshot.key as String;
      Map<String, dynamic> _presentation = Map<String, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>);
      final presentation = Presentation.fromRTDB(_presentation);

      // Download the PDF file
      final pdfFile = await downloadPdfFile(presentation.filePath);

      // Extract the first page as an image
      final thumbnail = await extractFirstPageImage(pdfFile);

      final listItem = ListItem(
        key: Key(key),
        title: presentation.title,
        thumbnail: Image.asset('assets/images/background_image.png'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AudiencePage(
                title: presentation.title,
                firebaseStorageUrl: presentation.filePath,
                presentationId: key,
              ),
            ),
          );
        },
      );
      setState(() {
        allPresentations.add(listItem);
        filteredPresentations = allPresentations;
      });
    });

    _databaseRef.onChildRemoved.listen((event) {
      final key = event.snapshot.key as String;
      setState(() {
        allPresentations.removeWhere((listItem) => listItem.key == Key(key));
        filteredPresentations = allPresentations;
      });
    });
  }

  void _filterPresentations(String query) {
    setState(() {
      filteredPresentations = allPresentations.where((presentation) {
        final title = presentation.title.toLowerCase();
        final queryLower = query.toLowerCase();
        return title.contains(queryLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Row(
              children: [
                Image.asset(
                  "assets/images/logo.png", // Pfad zum Logo
                  height: 32,
                  width: 32,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            pinned: true,
            expandedHeight: 75,
            backgroundColor: Colors.indigoAccent, // App bar background color
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  onChanged: _filterPresentations,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    prefixIcon: Icon(Icons.search),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 25,
                      maxHeight: 25,
                    ),
                    border: InputBorder.none,
                    hintText: 'Search for presentations',
                    hintStyle: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                'Recent Presentations',
                style: TextStyle(fontSize: 26),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (filteredPresentations.isEmpty) {
                  // Show message when no presentations are found
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: ListTile(
                      title: const Text('No presentations found.'),
                    ),
                  );
                } else {
                  // Show actual presentation item
                  return filteredPresentations[index];
                }
              },
              childCount: filteredPresentations.isNotEmpty
                  ? filteredPresentations.length
                  : 1,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            Colors.indigoAccent, // Floating action button background color
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const CreatePresentationDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
