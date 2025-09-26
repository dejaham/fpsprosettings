import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpsprosettings/models/player.dart';
import 'package:fpsprosettings/screens/player_details_page.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: child);

  group('PlayerDetailsPage', () {
    testWidgets('renders Mouse player with DPI and sensitivity cards',
        (tester) async {
      final player = Player(
        name: 'TenZ',
        device: 'Mouse',
        game: 'Valorant',
        dpi: 800,
        sensitivityMouse: 0.4,
      );

      await tester.pumpWidget(wrap(PlayerDetailsPage(player: player)));
      await tester.pumpAndSettle();

      // Name is shown in AppBar and in the page body header
      expect(find.text('TenZ'), findsNWidgets(2));
      expect(find.text('Valorant'), findsOneWidget);

      // Chip shows device label
      expect(find.text('Mouse'), findsOneWidget);

      // Metric cards content
      expect(find.text('DPI'), findsOneWidget);
      expect(find.text('800'), findsOneWidget);
      expect(find.text('Mouse Sensitivity'), findsOneWidget);
      expect(find.text('0.4'), findsOneWidget);

      // Icon
      expect(find.byIcon(Icons.mouse), findsWidgets);
    });

    testWidgets('renders Controller player with horizontal/vertical sens',
        (tester) async {
      final player = Player(
        name: 'Scump',
        device: 'Controller',
        game: 'Call of Duty',
        sensitivityControllerHorizontal: 7,
        sensitivityControllerVertical: 6,
      );

      await tester.pumpWidget(wrap(PlayerDetailsPage(player: player)));
      await tester.pumpAndSettle();

      // Name is shown in AppBar and in the page body header
      expect(find.text('Scump'), findsNWidgets(2));
      expect(find.text('Call of Duty'), findsOneWidget);
      expect(find.text('Controller'), findsOneWidget);

      expect(find.text('Horizontal Sensitivity'), findsOneWidget);
      expect(find.text('7.0'), findsOneWidget); // double toString()
      expect(find.text('Vertical Sensitivity'), findsOneWidget);
      expect(find.text('6.0'), findsOneWidget);

      expect(find.byIcon(Icons.gamepad), findsWidgets);
    });
  });
}
