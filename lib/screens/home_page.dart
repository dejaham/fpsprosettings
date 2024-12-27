import 'package:flutter/material.dart';
import '../models/game.dart';
import 'players_page.dart';

// Liste des jeux FPS
final List<Game> games = [
  Game(name: 'Call of Duty', imageUrl: 'assets/images/cod_icon.jpg'),
  Game(name: 'Apex Legends', imageUrl: 'assets/images/apex_icon.jpg'),
  Game(name: 'Valorant', imageUrl: 'assets/images/valorant_icon.jpg'),
  Game(name: 'Rainbow Six Siege', imageUrl: 'assets/images/r6_icon.jpg'),
];

class HomePage extends StatelessWidget {
  // Ajout du paramètre `key` dans le constructeur
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FPS Pro Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayersPage(game: game),
                  ),
                );
              },
              child: Card(
                elevation: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      game.imageUrl,
                      //height: 80,
                      //width: 80,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10),
                    Text(
                      game.name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
