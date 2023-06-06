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
    _databaseRef.onValue.listen((event) {
      if (event.snapshot.value == null) {
        return;
      }
      final data = Map<String, dynamic>.from(event.snapshot.value as Map<dynamic, dynamic>);
      print(data);
      allPresentations = data.entries.map((entry) {
        final key = entry.key;
        print(entry.value);
        Map<String, dynamic> _presentation = Map<String, dynamic>.from(entry.value as Map<dynamic, dynamic>);
        final presentation = Presentation.fromRTDB(_presentation);
        return ListItem(
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
                builder: (context) => AudiencePage(title: presentation.title, filePath: 'assets/presentations/example.pdf',),
              ),
            );
          },
        );
      }).toList();
      setState(() {
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
      appBar: AppBar(
        title: Text(widget.title),
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            SearchBox(
              onSearchChanged: _filterPresentations,
            ),
            const SizedBox(height: 20),
            const Text(
              'Recent Presentations',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: filteredPresentations,
              ),
            ),
          ],
        ),
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

  const SearchBox({super.key, required this.onSearchChanged});

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
