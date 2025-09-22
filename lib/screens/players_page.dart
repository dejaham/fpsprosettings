import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player.dart';
import '../models/game.dart';
import 'player_details_page.dart';
import '../utils/player_parsing.dart';

enum DeviceFilterOption { all, mouse, controller }

class PlayersPage extends StatefulWidget {
  final Game game;

  const PlayersPage({Key? key, required this.game}) : super(key: key);

  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  DeviceFilterOption _filter = DeviceFilterOption.all;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playersCollection = FirebaseFirestore.instance
        .collection('games')
        .doc(widget.game.id)
        .collection('players');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.game.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<DeviceFilterOption>(
            icon: const Icon(Icons.filter_list),
            initialValue: _filter,
            onSelected: (value) {
              setState(() {
                _filter = value;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: DeviceFilterOption.all,
                child: Text('Tous les devices'),
              ),
              PopupMenuItem(
                value: DeviceFilterOption.mouse,
                child: Text('Souris uniquement'),
              ),
              PopupMenuItem(
                value: DeviceFilterOption.controller,
                child: Text('Manette uniquement'),
              ),
            ],
          ),
        ],
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
        child: Column(
          children: [
            // Barre de recherche en haut (hors StreamBuilder pour conserver le focus)
            Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top + kToolbarHeight + 8,
                16,
                8,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Rechercher un joueur',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon:
                      Icon(Icons.search, color: Theme.of(context).primaryColor),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.08),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.35),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.25),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1.2,
                    ),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white70),
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                              _searchController.clear();
                            });
                          },
                        )
                      : null,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: playersCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'Aucun joueur trouvé pour ${widget.game.name}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  // Filtrage par device
                  final filteredDocs = docs.where((d) {
                    final dev = normalizeDevice(d.data());
                    switch (_filter) {
                      case DeviceFilterOption.all:
                        return true;
                      case DeviceFilterOption.mouse:
                        return dev == 'Mouse';
                      case DeviceFilterOption.controller:
                        return dev == 'Controller';
                    }
                  }).toList();

                  // Filtrage par nom (insensible à la casse)
                  final q = _searchQuery.trim().toLowerCase();
                  final visibleDocs = filteredDocs.where((d) {
                    if (q.isEmpty) return true;
                    final name =
                        (d.data()['name'] ?? '').toString().toLowerCase();
                    return name.contains(q);
                  }).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: visibleDocs.length,
                    itemBuilder: (context, index) {
                      final data = visibleDocs[index].data();

                      final device = normalizeDevice(data);

                      final player = Player(
                        name: (data['name'] ?? 'Unknown').toString(),
                        device: device,
                        game: widget.game.name,
                        sensitivityMouse: getNumber(
                            data, ['sensitivity', 'sens', 'mouse_sensitivity']),
                        sensitivityControllerHorizontal: getNumber(data, [
                          'sens_horizontal',
                          'sensHorizontal',
                          'horizontal',
                          'controller_horizontal'
                        ]),
                        sensitivityControllerVertical: getNumber(data, [
                          'sens_vertical',
                          'sensVertical',
                          'vertical',
                          'controller_vertical'
                        ]),
                        dpi: getInt(data, ['dpi', 'DPI', 'mouse_dpi']),
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
                          parts.add(
                              'H: ${player.sensitivityControllerHorizontal}');
                        }
                        if (player.sensitivityControllerVertical != null) {
                          parts.add(
                              'V: ${player.sensitivityControllerVertical}');
                        }
                        subtitleText = parts.join(' — ');
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF1A1A1A),
                                Color(0xFF0A0A0A),
                              ],
                            ),
                            border: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
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
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.2),
                              ),
                              child: Icon(
                                isMouse ? Icons.mouse : Icons.gamepad,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            title: Text(
                              player.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            subtitle: Text(
                              subtitleText,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
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
          ],
        ),
      ),
    );
  }
}
