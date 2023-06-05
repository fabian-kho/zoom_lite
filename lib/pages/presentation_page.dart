import 'package:flutter/material.dart';
import 'package:zoom_lite/pages/audience_page.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PresentationPage extends StatelessWidget {
  const PresentationPage(
      {Key? key, required this.title, required this.filePath})
      : super(key: key);
  final String title;
  final String filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Presentation Slide'),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const AudiencePage(title: 'Audience Page'),
                      ),
                    );
                  },
                  child: const Text('End Presentation'),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NavigationBar(),
          ),
          PDFView(
            filePath: filePath,
          ),
        ],
      ),
    );
  }
}

class NavigationBar extends StatefulWidget {
  const NavigationBar({Key? key}) : super(key: key);

  @override
  NavigationBarState createState() => NavigationBarState();
}

class NavigationBarState extends State<NavigationBar> {
  bool isPortraitMode = true;
  int currentPage = 1;
  int totalPages =
      10; // Aktualisieren Sie diese Zahl entsprechend der Gesamtzahl der Seiten in Ihrer Präsentation

  void toggleOrientation() {
    setState(() {
      isPortraitMode = !isPortraitMode;
    });
  }

  void goToPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
    }
  }

  void goToNextPage() {
    if (currentPage < totalPages) {
      setState(() {
        currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: goToPreviousPage,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: toggleOrientation,
            icon: Icon(
              isPortraitMode
                  ? Icons.screen_rotation
                  : Icons.screen_lock_landscape,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: goToNextPage,
            icon: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
