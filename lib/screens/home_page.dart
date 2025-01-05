// Page d'accueil affichant la grille des jeux FPS
// Cette page présente les différents jeux disponibles dans l'application

import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/game.dart';
import 'players_page.dart';

// Liste statique des jeux FPS disponibles dans l'application
// Chaque jeu est représenté par son nom et l'URL de son icône
final List<Game> games = [
  Game(name: 'Call of Duty', imageUrl: 'assets/images/cod_icon.jpg'),
  Game(name: 'Apex Legends', imageUrl: 'assets/images/apex_icon.jpg'),
  Game(name: 'Valorant', imageUrl: 'assets/images/valorant_icon.jpg'),
  Game(name: 'Rainbow Six Siege', imageUrl: 'assets/images/r6_icon.jpg'),
];

// Widget principal de la page d'accueil
class HomePage extends StatelessWidget {
  // Ajout du paramètre `key` dans le constructeur
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Extension de l'interface derrière la barre d'application
      extendBodyBehindAppBar: true,
      // Configuration de la barre d'application avec le titre et l'icône
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_esports, color: Theme.of(context).primaryColor),
            SizedBox(width: 10),
            Text('FPS Pro Settings'),
          ],
        ),
      ),
      // Corps principal avec fond dégradé
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A1A),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        // Grille des jeux avec espacement et padding
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return Hero(
                tag: 'game-${game.name}',
                child: Material(
                  color: Colors.transparent,
                  child: AnimatedGameCard(game: game),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Widget de carte de jeu animée
// Gère l'animation au survol et le tap pour naviguer vers la page des joueurs
class AnimatedGameCard extends StatefulWidget {
  final Game game;

  const AnimatedGameCard({Key? key, required this.game}) : super(key: key);

  @override
  _AnimatedGameCardState createState() => _AnimatedGameCardState();
}

// État de la carte de jeu animée
// Gère l'état de survol et les animations
class _AnimatedGameCardState extends State<AnimatedGameCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlayersPage(game: widget.game),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              border: Border.all(
                color: _isHovered 
                    ? Theme.of(context).primaryColor
                    : Colors.white.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  blurRadius: _isHovered ? 12 : 8,
                  spreadRadius: _isHovered ? 2 : 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          widget.game.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      widget.game.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '12 Pros', // À remplacer par le vrai nombre
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
