import 'package:flutter/material.dart';
import '../models/game.dart';
import '../data/dummy_players.dart';
import 'player_details_page.dart';

class PlayersPage extends StatelessWidget {
  final Game game;

  const PlayersPage({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredPlayers = dummyPlayers.where((player) => player.game == game.name).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(game.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
        child: filteredPlayers.isEmpty
          ? Center(
              child: Text(
                'Aucun joueur trouvé pour ${game.name}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white70,
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.fromLTRB(16, 100, 16, 16),
              itemCount: filteredPlayers.length,
              itemBuilder: (context, index) {
                final player = filteredPlayers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor.withOpacity(0.2),
                        ),
                        child: Icon(
                          player.device == 'Mouse' ? Icons.mouse : Icons.gamepad,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      title: Text(
                        player.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        player.device,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayerDetailsPage(player: player),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}
