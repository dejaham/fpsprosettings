// Point d'entrée principal de l'application
// Ce fichier configure le thème global et lance l'application

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const FPSProSettingsApp());
}

// Widget racine de l'application
// Configure le thème global, les couleurs et la police pour toute l'application
class FPSProSettingsApp extends StatelessWidget {
  const FPSProSettingsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FPS Pro Settings',
      // Configuration du thème sombre personnalisé
      theme: ThemeData.dark().copyWith(
        // Couleur principale utilisée pour les accents et les mises en évidence
        primaryColor: Color(0xFF2D00F7),
        // Couleur de fond générale de l'application
        scaffoldBackgroundColor: Color(0xFF121212),
        // Style des cartes utilisées dans l'application
        cardTheme: CardTheme(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        // Configuration de la police Rajdhani pour un style gaming
        textTheme: GoogleFonts.rajdhaniTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        ),
        // Style de la barre d'application
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.rajdhani(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      // Page d'accueil de l'application
      home: const HomePage(),
    );
  }
}
