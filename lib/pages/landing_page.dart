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

  void _fetchPresentations() {
    _databaseRef.onChildAdded.listen((event) {
      final key = event.snapshot.key as String;
      Map<String, dynamic> _presentation =
      Map<String, dynamic>.from(event.snapshot.value as Map<dynamic, dynamic>);
      final presentation = Presentation.fromRTDB(_presentation);
      final listItem = ListItem(
        key: Key(key),
        title: presentation.title,
        thumbnail: Image.asset(
          'assets/images/placeholder.png',
          fit: BoxFit.cover,
        ),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: SearchBox(onSearchChanged: _filterPresentations),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: const Text(
                  'Recent Presentations',
                  style: TextStyle(fontSize: 20),
                ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPresentations.isNotEmpty ? filteredPresentations.length : 1,
              itemBuilder: (context, index) {
                if (filteredPresentations.isEmpty) {
                  // Show skeleton item
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      tileColor: Theme.of(context).colorScheme.secondaryContainer,
                      title: SizedBox(
                        height: 20,
                        child: Container(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      subtitle: SizedBox(
                        height: 12,
                        child: Container(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      leading: Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  );
                } else {
                  // Show actual presentation item
                  return filteredPresentations[index];
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
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

class SearchBox extends StatelessWidget {
  final Function(String) onSearchChanged;

  const SearchBox({Key? key, required this.onSearchChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        onChanged: onSearchChanged,
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
    );
  }
}
