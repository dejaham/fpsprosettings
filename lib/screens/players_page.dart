import 'package:flutter/material.dart';
import 'package:fpsprosettings/screens/player_details_page.dart';
import '../models/game.dart';
import '../data/dummy_players.dart'; // Assurez-vous que le chemin est correct

class PlayersPage extends StatelessWidget {
  final Game game;

  PlayersPage({Key? key, required this.game}) : super(key: key);

  // Fonction pour obtenir une couleur en fonction du jeu
  Color getGameColor(String game) {
    switch (game) {
      case 'Call of Duty':
        return Colors.red;
      case 'Apex Legends':
        return Colors.orange;
      case 'Valorant':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtrer les joueurs pour le jeu sélectionné
    final filteredPlayers = dummyPlayers.where((player) => player.game == game.name).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(game.name),
        backgroundColor: getGameColor(game.name), // Utilisation de la couleur du jeu
      ),
      body: filteredPlayers.isEmpty
          ? Center(child: Text('Aucun joueur trouvé pour ${game.name}'))
          : ListView.builder(
              itemCount: filteredPlayers.length,
              itemBuilder: (context, index) {
                final player = filteredPlayers[index];
                return Card(
                  elevation: 5, // Ombre autour de chaque carte
                  margin: EdgeInsets.symmetric(vertical: 8.0), // Marge entre les cartes
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Bord arrondi
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    leading: Icon(Icons.person, color: Colors.blue), // Icône de la personne
                    title: Text(
                      player.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    tileColor: Colors.white, // Couleur de fond de chaque carte
                    onTap: () {
                      // Action lorsque l'utilisateur clique sur un joueur
                      // Naviguer vers la page de détails du joueur
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayerDetailsPage(player: player),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

