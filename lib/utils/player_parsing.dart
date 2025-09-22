/// Normalize the device type from a player data map.
/// Returns 'Mouse' or 'Controller'.
String normalizeDevice(Map<String, dynamic> data) {
  final deviceRaw = (data['device'] ?? '').toString().toLowerCase();
  if (deviceRaw.contains('mouse') ||
      deviceRaw.contains('souris') ||
      deviceRaw.contains('kbm') ||
      deviceRaw.contains('keyboard') ||
      deviceRaw.contains('clavier') ||
      deviceRaw.contains('pc')) {
    return 'Mouse';
  } else if (deviceRaw.contains('controller') ||
      deviceRaw.contains('manette') ||
      deviceRaw.contains('pad') ||
      deviceRaw.contains('gamepad')) {
    return 'Controller';
  } else {
    return (data.containsKey('dpi') || data.containsKey('sensitivity'))
        ? 'Mouse'
        : 'Controller';
  }
}

/// Try to parse a number from supported key aliases.
/// Returns the first non-null double value.
double? getNumber(Map<String, dynamic> m, List<String> keys) {
  for (final k in keys) {
    if (m.containsKey(k)) {
      final v = m[k];
      final d = _toDouble(v);
      if (d != null) return d;
    }
  }
  return null;
}

/// Try to parse an int from supported key aliases.
int? getInt(Map<String, dynamic> m, List<String> keys) {
  for (final k in keys) {
    if (m.containsKey(k)) {
      final v = m[k];
      final d = _toInt(v);
      if (d != null) return d;
    }
  }
  return null;
}

// Internal helpers

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

int? _toInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}
