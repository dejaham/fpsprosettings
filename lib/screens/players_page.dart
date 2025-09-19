import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player.dart';
import '../models/game.dart';
import 'player_details_page.dart';

class PlayersPage extends StatelessWidget {
  final Game game;

  const PlayersPage({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playersCollection = FirebaseFirestore.instance
        .collection('games')
        .doc(game.id)
        .collection('players');

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
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: playersCollection.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'Aucun joueur trouvé pour ${game.name}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              );
            }

            final docs = snapshot.data!.docs;

            double? _toDouble(dynamic v) {
              if (v == null) return null;
              if (v is num) return v.toDouble();
              if (v is String) return double.tryParse(v);
              return null;
            }

            double? _getNumber(Map<String, dynamic> m, List<String> keys) {
              for (final k in keys) {
                if (m.containsKey(k)) {
                  final v = m[k];
                  final d = _toDouble(v);
                  if (d != null) return d;
                }
              }
              return null;
            }

            int? _toInt(dynamic v) {
              if (v == null) return null;
              if (v is int) return v;
              if (v is num) return v.toInt();
              if (v is String) return int.tryParse(v);
              return null;
            }

            int? _getInt(Map<String, dynamic> m, List<String> keys) {
              for (final k in keys) {
                if (m.containsKey(k)) {
                  final v = m[k];
                  final d = _toInt(v);
                  if (d != null) return d;
                }
              }
              return null;
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data();

                // Normalisation du device et mapping des champs
                final deviceRaw =
                    (data['device'] ?? '').toString().toLowerCase();
                String device;
                if (deviceRaw.contains('mouse') ||
                    deviceRaw.contains('souris') ||
                    deviceRaw.contains('kbm') ||
                    deviceRaw.contains('keyboard') ||
                    deviceRaw.contains('clavier') ||
                    deviceRaw.contains('pc')) {
                  device = 'Mouse';
                } else if (deviceRaw.contains('controller') ||
                    deviceRaw.contains('manette') ||
                    deviceRaw.contains('pad') ||
                    deviceRaw.contains('gamepad')) {
                  device = 'Controller';
                } else {
                  // défaut: garder Mouse si DPI/sens souris présent, sinon Controller
                  device = (data.containsKey('dpi') ||
                          data.containsKey('sensitivity'))
                      ? 'Mouse'
                      : 'Controller';
                }

                final player = Player(
                  name: (data['name'] ?? 'Unknown').toString(),
                  device: device,
                  game: game.name,
                  sensitivityMouse: _getNumber(
                      data, ['sensitivity', 'sens', 'mouse_sensitivity']),
                  sensitivityControllerHorizontal: _getNumber(data, [
                    'sens_horizontal',
                    'sensHorizontal',
                    'horizontal',
                    'controller_horizontal'
                  ]),
                  sensitivityControllerVertical: _getNumber(data, [
                    'sens_vertical',
                    'sensVertical',
                    'vertical',
                    'controller_vertical'
                  ]),
                  dpi: _getInt(data, ['dpi', 'DPI', 'mouse_dpi']),
                );

                final isMouse = device == 'Mouse';
                String subtitleText;
                if (isMouse) {
                  final parts = <String>[];
                  parts.add('Mouse');
                  if (player.dpi != null) parts.add('DPI: ${player.dpi}');
                  if (player.sensitivityMouse != null)
                    parts.add('Sens: ${player.sensitivityMouse}');
                  subtitleText = parts.join(' — ');
                } else {
                  final parts = <String>[];
                  parts.add('Controller');
                  if (player.sensitivityControllerHorizontal != null) {
                    parts.add('H: ${player.sensitivityControllerHorizontal}');
                  }
                  if (player.sensitivityControllerVertical != null) {
                    parts.add('V: ${player.sensitivityControllerVertical}');
                  }
                  subtitleText = parts.join(' — ');
                }

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
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                        ),
                        child: Icon(
                          isMouse ? Icons.mouse : Icons.gamepad,
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
                        subtitleText,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlayerDetailsPage(player: player),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
