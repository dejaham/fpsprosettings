import 'package:flutter_test/flutter_test.dart';
import 'package:fpsprosettings/utils/player_parsing.dart';

void main() {
  group('normalizeDevice', () {
    test('detects Mouse from explicit keywords', () {
      expect(normalizeDevice({'device': 'Mouse'}), 'Mouse');
      expect(normalizeDevice({'device': 'SOURIS'}), 'Mouse');
      expect(normalizeDevice({'device': 'keyboard and mouse'}), 'Mouse');
      expect(normalizeDevice({'device': 'PC'}), 'Mouse');
    });

    test('detects Controller from explicit keywords', () {
      expect(normalizeDevice({'device': 'controller'}), 'Controller');
      expect(normalizeDevice({'device': 'MANETTE'}), 'Controller');
      expect(normalizeDevice({'device': 'gamepad'}), 'Controller');
      expect(normalizeDevice({'device': 'pad'}), 'Controller');
    });

    test('infers Mouse if sensitivity/dpi-like keys present', () {
      expect(normalizeDevice({'dpi': 800}), 'Mouse');
      expect(normalizeDevice({'sensitivity': 1.2}), 'Mouse');
    });

    test('defaults to Controller otherwise', () {
      expect(normalizeDevice({}), 'Controller');
    });
  });

  group('getNumber', () {
    test('returns first matching double from aliases', () {
      final data = {
        'other': 0.5,
        'sens': '1.25',
        'sensitivity': 0.75,
      };
      final v = getNumber(data, ['missing', 'sens', 'sensitivity']);
      expect(v, 1.25);
    });

    test('parses numeric types and strings', () {
      expect(getNumber({'a': 2}, ['a']), 2.0);
      expect(getNumber({'a': 2.5}, ['a']), 2.5);
      expect(getNumber({'a': '3.14'}, ['a']), 3.14);
      expect(getNumber({'a': null}, ['a']), isNull);
    });

    test('returns null when nothing matches', () {
      expect(getNumber({'x': 1}, ['a', 'b']), isNull);
    });
  });

  group('getInt', () {
    test('returns first matching int from aliases', () {
      final data = {'dpi': '800', 'mouse_dpi': 400};
      final v = getInt(data, ['mouse_dpi', 'dpi']);
      expect(v, 400);
    });

    test('parses numeric types and strings', () {
      expect(getInt({'a': 2}, ['a']), 2);
      expect(getInt({'a': 2.7}, ['a']), 2);
      expect(getInt({'a': '300'}, ['a']), 300);
      expect(getInt({'a': null}, ['a']), isNull);
    });

    test('returns null when nothing matches', () {
      expect(getInt({'x': 1}, ['a', 'b']), isNull);
    });
  });
}
