import 'package:flutter/material.dart';
import '../data/dummy_players.dart';
import 'player_details_page.dart';

class PlayerListPage extends StatelessWidget {
  final String gameName;

  const PlayerListPage({Key? key, required this.gameName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filtrer les joueurs en fonction du jeu sélectionné
    final filteredPlayers =
        dummyPlayers.where((player) => player.game == gameName).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Players - $gameName'),
      ),
      body: ListView.builder(
        itemCount: filteredPlayers.length,
        itemBuilder: (context, index) {
          final player = filteredPlayers[index];
          return ListTile(
            title: Text(
              player.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerDetailsPage(player: player),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
