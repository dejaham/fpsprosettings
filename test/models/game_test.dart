// Removed unused import of cloud_firestore
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpsprosettings/models/game.dart';

void main() {
  group('Game.fromDoc', () {
    test('reads id, name and logo (preferred key)', () async {
      final firestore = FakeFirebaseFirestore();
      final docRef = await firestore.collection('games').add({
        'name': 'Valorant',
        'logo': 'https://example.com/valorant.png',
      });

      final snap = await docRef.get();
      final g = Game.fromDoc(snap);

      expect(g.id, docRef.id);
      expect(g.name, 'Valorant');
      expect(g.imageUrl, 'https://example.com/valorant.png');
    });

    test('falls back to imageUrl and image_url', () async {
      final firestore = FakeFirebaseFirestore();
      final r1 = await firestore.collection('games').add({
        'name': 'Apex',
        'imageUrl': 'https://example.com/apex.png',
      });
      final r2 = await firestore.collection('games').add({
        'name': 'R6',
        'image_url': 'https://example.com/r6.png',
      });

      final s1 = await r1.get();
      final s2 = await r2.get();

      final g1 = Game.fromDoc(s1);
      final g2 = Game.fromDoc(s2);

      expect(g1.imageUrl, 'https://example.com/apex.png');
      expect(g2.imageUrl, 'https://example.com/r6.png');
    });

    test('handles missing data safely', () async {
      final firestore = FakeFirebaseFirestore();
      final ref = await firestore.collection('games').add({});
      final s = await ref.get();
      final g = Game.fromDoc(s);

      expect(g.name, '');
      expect(g.imageUrl, '');
    });
  });
}
