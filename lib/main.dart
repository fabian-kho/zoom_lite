import 'package:flutter/material.dart';
import 'package:zoom_lite/pages/landing_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      home: const LandingPage(title: 'Hello! 👋'),
    );
  }
}
