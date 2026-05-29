import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/const/bin_state.dart';
import '../../../core/const/media_item.dart';

class BinController extends Notifier<BinState> {
  @override
  BinState build() {
    return BinState(localBin: [], cloudBin: []);
  }

  /// Add a MediaItem to the bin
  /// Checks MediaItem.source to determine if it should go to localBin or cloudBin
  /// Updates the BinState accordingly
  void addToBin(MediaItem item) {
    if (item.source == StorageMode.local) {
      state = state.copyWith(localBin: [...state.localBin, item]);
    } else if (item.source == StorageMode.gPhotos) {
      state = state.copyWith(cloudBin: [...state.cloudBin, item]);
    }
  }

  /// Remove a MediaItem from the bin
  /// Checks MediaItem.source to determine if it should be removed from localBin or cloudBin
  /// Updates the BinState accordingly
  void removeFromBin(MediaItem item) {
    if (item.source == StorageMode.local) {
      state = state.copyWith(
        localBin: state.localBin.where((i) => i.id != item.id).toList(),
      );
    } else if (item.source == StorageMode.gPhotos) {
      state = state.copyWith(
        cloudBin: state.cloudBin.where((i) => i.id != item.id).toList(),
      );
    }
  }

  /// Permanently delete items from the bin
  /// Accepts a list of MediaItem IDs to be deleted
  void clearLocalBin(List<String> deletedIDs) {
    state = state.copyWith(
      localBin: state.localBin
          .where((element) => !deletedIDs.contains(element.id))
          .toList(),
    );
  }

  void clearCloudBin(List<String> syncedIDs) {
    state = state.copyWith(
      cloudBin: state.cloudBin
          .where((element) => !syncedIDs.contains(element.id))
          .toList(),
    );
  }
}

// Defining the provider for the BinController
final binProvider = NotifierProvider<BinController, BinState>(
  BinController.new,
);
