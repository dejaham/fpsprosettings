import 'package:flutter/material.dart';
import '../models/player.dart';

class PlayerDetailsPage extends StatelessWidget {
  final Player player;

  const PlayerDetailsPage({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(player.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nom du joueur: ${player.name}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Jeu: ${player.game}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Périphérique: ${player.device}',
              style: TextStyle(fontSize: 18),
            ),
            // Afficher uniquement la sensibilité souris si le périphérique est "Mouse"
            if (player.device == 'Mouse' &&
                player.sensitivityMouse != null) ...[
              SizedBox(height: 8),
              Text(
                'Sensibilité Souris: ${player.sensitivityMouse}',
                style: TextStyle(fontSize: 18),
              ),
            ],
            // Afficher uniquement les sensibilités manette si le périphérique est "Controller"
            if (player.device == 'Controller') ...[
              if (player.sensitivityControllerHorizontal != null) ...[
                SizedBox(height: 8),
                Text(
                  'Sensibilité Manette (Horizontal): ${player.sensitivityControllerHorizontal}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
              if (player.sensitivityControllerVertical != null) ...[
                SizedBox(height: 8),
                Text(
                  'Sensibilité Manette (Vertical): ${player.sensitivityControllerVertical}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
