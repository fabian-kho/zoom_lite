import 'package:flutter/material.dart';
import 'package:zoom_lite/pages/audience_page.dart';

class PresentationPage extends StatelessWidget {
  const PresentationPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
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
    );
  }
}
