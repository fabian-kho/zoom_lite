import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:zoom_lite/components/list_item.dart';
import 'package:zoom_lite/pages/create_presentation_dialog.dart';
import 'package:zoom_lite/pages/presentation_page.dart';
import 'dart:math';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key, required this.title}) : super(key: key);
  final String title;
  // test realtime Database
  void testRealtimeDatabase() {
    final DatabaseReference testRef = FirebaseDatabase.instance.ref(
        "Hello world!").child("test");
    testRef.set("Hello world! ${Random().nextInt(100)}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(title),
          titleTextStyle: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black)),
      // use search field component
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              SearchBox(),
              // use list view component
              const SizedBox(height: 20),
              const Text(
                'Recent Presentations',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    ListItem(
                      title: 'Accessibility',
                      thumbnailPath: 'assets/images/slide1.png',
                      onTap: () {
                        testRealtimeDatabase();
                        // Start the presentation
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PresentationPage(title: 'Accessibility'),
                          ),
                        );
                      },
                    ),
                    ListItem(
                      title: 'Mobile Storage 1',
                      thumbnailPath: 'assets/images/slide2.png',
                      onTap: () {
                        // Start the presentation
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PresentationPage(
                                title: 'Mobile Storage 1'),
                          ),
                        );
                      },
                    ),
                    ListItem(
                      title: 'Mobile Storage 2',
                      thumbnailPath: 'assets/images/slide3.png',
                      onTap: () {
                        // Start the presentation
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PresentationPage(
                                title: 'Mobile Storage 2'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          )),
      //FAB bottom right corner with a plus icon
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // open Dialog to create a new presentation
          showDialog(
              context: context,
              builder: (context) => const CreatePresentationDialog());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SearchBox extends StatelessWidget {
  final List<String> allPresentations = [
    'Accessibility',
    'Mobile Storage 1',
    'Mobile Storage 2'
  ];

  SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        onChanged: (value) {
          final filteredPresentations = allPresentations
              .where((presentation) =>
                  presentation.toLowerCase().contains(value.toLowerCase()))
              .toList();

          // Weiterverarbeitung der gefilterten Präsentationen
          // Hier können Sie die Ergebnisse anzeigen oder speichern

          print(filteredPresentations);
        },
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
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
