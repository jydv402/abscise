// dart:io no longer needed since we use PhotoManager for deletions

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:abscise/models/bin_state.dart';
import 'package:abscise/models/media_model.dart';
import 'package:abscise/services/local_bin_service.dart';

class BinController extends Notifier<BinState> {
  @override
  BinState build() {
    // Hydrate the local bin from persistent Hive storage on startup.
    final binService = ref.read(localBinServiceProvider);
    final storedItems = binService.getAllBinItems();
    final localBin = storedItems
        .map((json) => MediaItem.fromJson(json))
        .toList();

    // Sort by binnedAt descending (most recent first) for the Bin Screen.
    localBin.sort((a, b) {
      final aTime = a.binnedAt?.millisecondsSinceEpoch ?? 0;
      final bTime = b.binnedAt?.millisecondsSinceEpoch ?? 0;
      return bTime.compareTo(aTime);
    });

    return BinState(localBin: localBin, cloudBin: []);
  }

  /// Add a MediaItem to the bin.
  /// Stamps the item with [binnedAt] and persists to Hive.
  Future<void> addToBin(MediaItem item) async {
    final binService = ref.read(localBinServiceProvider);

    if (item.source == StorageMode.local) {
      final binnedItem = item.copyWith(binnedAt: DateTime.now());
      state = state.copyWith(localBin: [binnedItem, ...state.localBin]);
      await binService.addToBin(binnedItem);
    } else if (item.source == StorageMode.gPhotos) {
      state = state.copyWith(cloudBin: [...state.cloudBin, item]);
    }
  }

  /// Remove a MediaItem from the bin (used by undo / restore).
  /// Also removes from Hive persistence.
  Future<void> removeFromBin(MediaItem item) async {
    final binService = ref.read(localBinServiceProvider);

    if (item.source == StorageMode.local) {
      state = state.copyWith(
        localBin: state.localBin.where((i) => i.id != item.id).toList(),
      );
      await binService.removeFromBin(item.id);
    } else if (item.source == StorageMode.gPhotos) {
      state = state.copyWith(
        cloudBin: state.cloudBin.where((i) => i.id != item.id).toList(),
      );
    }
  }

  /// Permanently delete local bin items from disk.
  /// Uses File.delete() to bypass MediaStore and avoid Google Photos cloud sync.
  /// Returns the count of successfully deleted files and total MB freed.
  Future<({int deletedCount, double mbFreed})> permanentlyDeleteLocal(
    List<MediaItem> items,
  ) async {
    final binService = ref.read(localBinServiceProvider);
    int deletedCount = 0;
    double mbFreed = 0;
    final List<String> deletedIds = [];

    final idsToDelete = items.map((i) => i.id).toList();

    try {
      final successfullyDeletedIds = await PhotoManager.editor.deleteWithIds(
        idsToDelete,
      );

      for (final id in successfullyDeletedIds) {
        final item = items.firstWhere((element) => element.id == id);
        deletedCount++;
        mbFreed += item.fileSizeMb ?? 0;
        deletedIds.add(id);
      }
    } catch (_) {
      // Catch native errors if any
    }

    // Remove successfully deleted items from Hive and in-memory state.
    await binService.clearAll(deletedIds);

    // Update the in-memory state to reflect the deletions.
    state = state.copyWith(
      localBin: state.localBin
          .where((element) => !deletedIds.contains(element.id))
          .toList(),
    );

    return (deletedCount: deletedCount, mbFreed: mbFreed);
  }

  /// Restore specific items from the local bin.
  /// Items will reappear in the swipe deck on next load.
  Future<void> restoreItems(List<MediaItem> items) async {
    final binService = ref.read(localBinServiceProvider);
    final idsToRestore = items.map((i) => i.id).toSet();

    for (final id in idsToRestore) {
      await binService.removeFromBin(id);
    }

    state = state.copyWith(
      localBin: state.localBin
          .where((i) => !idsToRestore.contains(i.id))
          .toList(),
    );
  }
}

// Defining the provider for the BinController
final binProvider = NotifierProvider<BinController, BinState>(
  BinController.new,
);
