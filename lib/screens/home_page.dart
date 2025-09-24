// Page d'accueil affichant la grille des jeux FPS
// Cette page présente les différents jeux disponibles dans l'application

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/game.dart';
import 'players_page.dart';

// Widget principal de la page d'accueil
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Configuration de la barre d'application avec le titre et l'icône
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/app_icon.png',
              height: 32,
            ),
            const SizedBox(width: 10),
            Text(
              'FPS Pro Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(42),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Find the best settings from pro players',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 17,
                      color: Colors.white70,
                      letterSpacing: 0.4,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Container(
                height: 2,
                width: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Theme.of(context).primaryColor,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('games').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'No games available at the moment.',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                );
              }

              final games = snapshot.data!.docs
                  .map((d) => Game.fromDoc(d))
                  .where((g) => g.name.isNotEmpty && g.imageUrl.isNotEmpty)
                  .toList();

              if (games.isEmpty) {
                return Center(
                  child: Text(
                    'No games available at the moment.',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                );
              }

              return GridView.builder(
                padding: EdgeInsets.fromLTRB(
                  16.0,
                  0.0,
                  16.0,
                  24.0 + MediaQuery.of(context).padding.bottom,
                ),
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
              );
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
    // Choisir l'image depuis asset ou réseau en fonction de l'URL
    final ImageProvider imageProvider = widget.game.imageUrl.startsWith('http')
        ? NetworkImage(widget.game.imageUrl)
        : AssetImage(widget.game.imageUrl) as ImageProvider;

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
              image: imageProvider,
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .primaryColor
                    .withOpacity(isPressed ? 0.4 : 0.3),
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
