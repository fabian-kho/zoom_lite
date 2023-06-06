import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zoom_lite/pages/landing_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zoom lite',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0A122A),
      ),
      themeMode: ThemeMode.system, // or ThemeMode.dark, ThemeMode.light
      home: FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            if (kDebugMode) {
              print('You have an error! ${snapshot.error.toString()}');
            }
            return const Text('Something went wrong!');
          } else if (snapshot.hasData) {
            return const LandingPage(title: 'Hello! 👋');
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }
}