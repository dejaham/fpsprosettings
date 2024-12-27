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
              'Name: ${player.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Device: ${player.device}'),
            const SizedBox(height: 10),
            if (player.device == 'mouse')
              Text('Mouse Sensitivity: ${player.sensitivityMouse}')
            else ...[
              Text('Horizontal Sensitivity: ${player.sensitivityControllerHorizontal}'),
              Text('Vertical Sensitivity: ${player.sensitivityControllerVertical}'),
            ],
            const SizedBox(height: 10),
            Text('Game: ${player.game}'),
          ],
        ),
      ),
    );
  }
}
