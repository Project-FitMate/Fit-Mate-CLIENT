import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class DeviceId {
  DeviceId._();

  static const _key = 'device_id';
  static String? _cached;

  // Server-side pattern: ^[A-Za-z0-9_-]{8,128}$. 32 hex chars satisfies it.
  static Future<String> get() async {
    if (_cached != null) return _cached!;
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(_key);
    if (id == null) {
      id = _generate();
      await prefs.setString(_key, id);
    }
    _cached = id;
    return id;
  }

  static String _generate() {
    final rng = Random.secure();
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
