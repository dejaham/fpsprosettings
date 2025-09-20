// Page de détails d'un joueur
// Affiche les informations détaillées sur un joueur spécifique, incluant ses paramètres de sensibilité

import 'package:flutter/material.dart';
import '../models/player.dart';

// Widget principal de la page de détails du joueur
class PlayerDetailsPage extends StatelessWidget {
  final Player player;

  const PlayerDetailsPage({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Extension de l'interface derrière la barre d'application
      extendBodyBehindAppBar: true,
      // Barre d'application transparente avec le nom du joueur
      appBar: AppBar(
        title: Text(player.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        // Liste déroulante des informations du joueur
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            MediaQuery.of(context).padding.top + kToolbarHeight + 16,
            16,
            16,
          ),
          children: [
            // Carte principale contenant les informations du joueur
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // En-tête avec l'icône et les informations de base
                    Row(
                      children: [
                        // Icône du périphérique (souris ou manette)
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.2),
                          ),
                          child: Icon(
                            player.device == 'Mouse'
                                ? Icons.mouse
                                : Icons.gamepad,
                            color: Theme.of(context).primaryColor,
                            size: 32,
                          ),
                        ),
                        SizedBox(width: 16),
                        // Nom du joueur et jeu
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                player.game,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.white70,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    // Badges / Chips d'information rapides (ex: Périphérique)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(
                          avatar: Icon(
                            player.device == 'Mouse'
                                ? Icons.mouse
                                : Icons.gamepad,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: Text(
                            player.device,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          backgroundColor: Colors.white.withOpacity(0.08),
                          side: BorderSide(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.35),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Présentation des sensibilités sous forme de cartes métriques
                    if (player.device == 'Mouse') ...[
                      if (player.dpi != null && player.sensitivityMouse != null)
                        Row(
                          children: [
                            Expanded(
                              child: _metricCard(
                                context,
                                icon: Icons.speed,
                                label: 'DPI',
                                value: player.dpi!.toString(),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _metricCard(
                                context,
                                icon: Icons.mouse,
                                label: 'Sensibilité Souris',
                                value: player.sensitivityMouse!.toString(),
                              ),
                            ),
                          ],
                        )
                      else if (player.dpi != null)
                        _metricCard(
                          context,
                          icon: Icons.speed,
                          label: 'DPI',
                          value: player.dpi!.toString(),
                        )
                      else if (player.sensitivityMouse != null)
                        _metricCard(
                          context,
                          icon: Icons.mouse,
                          label: 'Sensibilité Souris',
                          value: player.sensitivityMouse!.toString(),
                        ),
                    ],
                    if (player.device == 'Controller') ...[
                      Row(
                        children: [
                          Expanded(
                            child: _metricCard(
                              context,
                              icon: Icons.swap_horiz,
                              label: 'Sensibilité Horizontale',
                              value: player.sensitivityControllerHorizontal
                                      ?.toString() ??
                                  '-',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _metricCard(
                              context,
                              icon: Icons.swap_vert,
                              label: 'Sensibilité Verticale',
                              value: player.sensitivityControllerVertical
                                      ?.toString() ??
                                  '-',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Nouvelle carte métrique compacte et élégante
  Widget _metricCard(BuildContext context,
      {required IconData icon, required String label, required String value}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black.withOpacity(0.35),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor.withOpacity(0.18),
            ),
            child: Icon(icon, color: Theme.of(context).primaryColor),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
