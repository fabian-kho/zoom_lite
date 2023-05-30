import 'package:flutter/material.dart';
import 'package:zoom_lite/pages/landing_page.dart';

class AudiencePage extends StatelessWidget {
  const AudiencePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Zeigt ein Bestätigungsdialogfeld an, bevor die Präsentation verlassen wird
          final confirmExit = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Exit'),
              content: const Text(
                  'Are you sure you want to leave the presentation?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Leave'),
                ),
              ],
            ),
          );

          if (confirmExit == true) {
            // Navigation zur Startseite
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const LandingPage(title: 'Hello! 👋')),
              (route) =>
                  false, // Entfernt alle vorherigen Seiten aus dem Stapel
            );
          }

          // Verhindert, dass die Präsentation ohne Bestätigung verlassen wird
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Presentation in progress'),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Implementieren Sie die Logik zum Navigieren zur nächsten Folie
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const LandingPage(title: 'Hello! 👋'),
                      ),
                    );
                  },
                  child: const Text('Leave Presentation'),
                ),
              ],
            ),
          ),
        ));
  }
}
