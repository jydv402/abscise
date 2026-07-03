import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:abscise/models/media_model.dart';

/// Hive-backed persistence service for the local media bin.
///
/// Uses the 'abscise_bin' Hive box (already opened in main.dart) with:
///   Key `bin_ids`        → `List<String>` (asset IDs, loaded as a Set for O(1) lookup)
///   Key `item_<assetId>` → `Map`          (MediaItem JSON for Bin Screen rendering)
class LocalBinService {
  static const String _binIdsKey = 'bin_ids';
  static const String _itemPrefix = 'item_';

  final Box _box;

  /// In-memory cache of binned asset IDs for O(1) lookups.
  late Set<String> _cachedIds;

  LocalBinService(this._box) {
    // Hydrate the in-memory set from Hive on construction.
    final storedIds = _box.get(_binIdsKey, defaultValue: <dynamic>[]);
    _cachedIds = Set<String>.from(storedIds.cast<String>());
  }

  // ---------------------------------------------------------------------------
  // Read Operations
  // ---------------------------------------------------------------------------

  /// O(1) check: is this asset ID in the bin?
  bool isInBin(String id) => _cachedIds.contains(id);

  /// Returns the full set of binned asset IDs (for bulk filtering in SwipeController).
  Set<String> getBinIds() => _cachedIds;

  /// Returns all stored MediaItem JSON maps (for rendering the Bin Screen grid).
  List<Map<String, dynamic>> getAllBinItems() {
    final List<Map<String, dynamic>> items = [];
    for (final id in _cachedIds) {
      final raw = _box.get('$_itemPrefix$id');
      if (raw != null) {
        items.add(Map<String, dynamic>.from(raw));
      }
    }
    return items;
  }

  /// Returns the count of items currently in the bin.
  int get binCount => _cachedIds.length;

  // ---------------------------------------------------------------------------
  // Write Operations
  // ---------------------------------------------------------------------------

  /// Add a MediaItem to the persistent bin.
  Future<void> addToBin(MediaItem item) async {
    _cachedIds.add(item.id);
    await _box.put(_binIdsKey, _cachedIds.toList());
    await _box.put('$_itemPrefix${item.id}', item.toJson());
  }

  /// Remove a single item from the persistent bin (used by undo / restore).
  Future<void> removeFromBin(String id) async {
    _cachedIds.remove(id);
    await _box.put(_binIdsKey, _cachedIds.toList());
    await _box.delete('$_itemPrefix$id');
  }

  /// Batch-remove items after permanent deletion.
  Future<void> clearAll(List<String> ids) async {
    for (final id in ids) {
      _cachedIds.remove(id);
      await _box.delete('$_itemPrefix$id');
    }
    await _box.put(_binIdsKey, _cachedIds.toList());
  }
}

// ---------------------------------------------------------------------------
// Riverpod Provider
// ---------------------------------------------------------------------------

final localBinServiceProvider = Provider<LocalBinService>((ref) {
  final box = Hive.box('abscise_bin');
  return LocalBinService(box);
});
