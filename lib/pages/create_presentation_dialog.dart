import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:zoom_lite/pages/presentaion_page.dart';

// dialog widget to create a new presentation
// heading: Create a new presentation
// body:
// - TextField to enter presentation name
// - hint that only pdf files are supported
// actions: Cancel and Upload buttons
// Upload button should open the file picker from the file_picker package

class CreatePresentationDialog extends StatelessWidget {
  const CreatePresentationDialog({Key? key}) : super(key: key);

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
            final FilePickerResult? result =
                await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
            );

            if (result != null) {
              // Verarbeiten der ausgewählten Datei
              final filePath = result.files.single.path;
              // Führen Sie Aktionen mit dem Dateipfad aus, z. B. das Importieren der Präsentationn

              // Close the dialog
              Navigator.of(context).pop();

              // Navigate to the presentation page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PresentationPage(title: 'Imported Presentation'),
                ),
              );
            }
          },
          child: const Text('Upload'),
        ),
      ],
    );
  }
}
