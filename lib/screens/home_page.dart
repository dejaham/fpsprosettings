// Page d'accueil affichant la grille des jeux FPS
// Cette page présente les différents jeux disponibles dans l'application

import 'package:flutter/material.dart';
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
              return AnimatedGameCard(game: games[index]);
            },
          ),
        ),
      ),
    );
  }
}

// Widget de carte de jeu animée avec effet de pression
class AnimatedGameCard extends StatefulWidget {
  final Game game;

  const AnimatedGameCard({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  _AnimatedGameCardState createState() => _AnimatedGameCardState();
}

// État de la carte de jeu avec animation de pression
class _AnimatedGameCardState extends State<AnimatedGameCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayersPage(game: widget.game),
          ),
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        transform: Matrix4.identity()..scale(isPressed ? 0.95 : 1.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage(widget.game.imageUrl),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(isPressed ? 0.4 : 0.3),
                blurRadius: isPressed ? 12 : 8,
                offset: Offset(0, isPressed ? 2 : 4),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.game.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
