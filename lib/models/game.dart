import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  final String id;
  final String name;
  final String imageUrl;

  Game({required this.id, required this.name, required this.imageUrl});

  factory Game.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return Game(
      id: doc.id,
      name: (data['name'] ?? '').toString(),
      imageUrl: (data['imageUrl'] ?? data['image_url'] ?? '').toString(),
    );
  }
}
