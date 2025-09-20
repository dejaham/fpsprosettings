// Point d'entrée principal de l'application
// Ce fichier configure le thème global et lance l'application

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        useMaterial3: true,
        // Couleur principale utilisée pour les accents et les mises en évidence (vert néon)
        primaryColor: const Color(0xFF39FF14),
        // Couleur de fond générale de l'application
        scaffoldBackgroundColor: const Color(0xFF121212),
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
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF39FF14),
        ).copyWith(
          onPrimary: Colors.black,
        ),
      ),
      // Page d'accueil de l'application
      home: const HomePage(),
    );
  }
}
