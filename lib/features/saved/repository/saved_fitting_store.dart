import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:fit_mate_client/features/saved/model/saved_fitting.dart';

/// Local persistence for saved fittings, backed by shared_preferences.
/// Stores the full list as a JSON string under a single key.
class SavedFittingStore {
  static const _key = 'saved_fittings_v1';

  Future<List<SavedFitting>> list() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List;
      final items = decoded
          .map((e) => SavedFitting.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      // Newest first.
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items;
    } catch (_) {
      return [];
    }
  }

  Future<void> save(SavedFitting fitting) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await list();
    // De-dupe by id, then prepend the new one.
    final next = [fitting, ...current.where((f) => f.id != fitting.id)];
    await prefs.setString(
      _key,
      jsonEncode(next.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> delete(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await list();
    final next = current.where((f) => f.id != id).toList();
    await prefs.setString(
      _key,
      jsonEncode(next.map((e) => e.toJson()).toList()),
    );
  }
}
