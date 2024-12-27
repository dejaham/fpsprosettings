import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const FPSProSettingsApp());
}

class FPSProSettingsApp extends StatelessWidget {
  // Ajout du paramètre `key` dans le constructeur
  const FPSProSettingsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FPS Pro Settings',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(), // La page d'accueil
    );
  }
}

