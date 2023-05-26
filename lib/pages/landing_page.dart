import 'package:flutter/material.dart';
import 'package:zoom_lite/components/list_item.dart';
import 'package:file_picker/file_picker.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.black
        )
      ),
      // use search field component
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            const SearchBox(),
            // use list view component
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 20),
                    child: const Text(
                      'Recent Presentations',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ListItem(title: 'Accessibility', thumbnailPath: 'assets/images/slide1.png', onTap: () {}),
                  ListItem(title: 'Accessibility', thumbnailPath: 'assets/images/slide1.png', onTap: () {}),
                  ListItem(title: 'Accessibility', thumbnailPath: 'assets/images/slide1.png', onTap: () {}),
                  ListItem(title: 'Accessibility', thumbnailPath: 'assets/images/slide1.png', onTap: () {}),
                  ListItem(title: 'Accessibility', thumbnailPath: 'assets/images/slide1.png', onTap: () {}),
                  ListItem(title: 'Accessibility', thumbnailPath: 'assets/images/slide1.png', onTap: () {}),
                  ListItem(title: 'Accessibility', thumbnailPath: 'assets/images/slide1.png', onTap: () {}),
                  ListItem(title: 'Accessibility', thumbnailPath: 'assets/images/slide1.png', onTap: () {}),
                ],
              ),
            ),
          ],
        )
      ),
      //FAB bottom right corner with a plus icon
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // open Dialog to create a new presentation
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
  const SearchBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const TextField(
        decoration: InputDecoration(
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

// dialog widget to create a new presentation
// heading: Create a new presentation
// body:
// - TextField to enter presentation name
// - hint that only pdf files are supported
// actions: Cancel and Upload buttons
// Upload button should open the file picker from the file_picker package

class CreatePresentationDialog extends StatelessWidget {
  const CreatePresentationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create a new presentation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter presentation name',
            ),
          ),
          SizedBox(height: 10),
          Text(
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
          onPressed: () async {
            // open file picker
            _pickFile();
            // if file is selected, close dialog and navigate to presentation page
            // if (result != null) {
            //   Navigator.of(context).pop();
            //   Navigator.of(context).pushNamed('/presentation');
            // }
          },
          child: const Text('Upload'),
        ),
      ],
    );
  }
}


void _pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );
}