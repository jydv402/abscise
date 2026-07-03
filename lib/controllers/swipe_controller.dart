import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:abscise/models/swipe_state.dart';
import 'package:abscise/models/swiped_model.dart';
import 'package:abscise/providers/shared_prefs_provider.dart';
import 'package:abscise/controllers/bin_controller.dart';
import 'package:abscise/services/local_bin_service.dart';
import 'package:abscise/services/local_media_service.dart';

class SwipeController extends Notifier<SwipeState> {
  @override
  SwipeState build() {
    // Watch sorting provider so controller resets state when order changes
    ref.watch(mediaFetchAscendingProvider);

    // Schedule initial load when build is called (e.g. on initialization or order change)
    Future.microtask(() {
      loadNextChunk();
    });

    return SwipeState(
      deck: [],
      history: [],
      isLoading: false,
      currentIndex: 0,
      page: 0,
      hasMore: true,
    );
  }

  /// Loads the next chunk of media items.
  /// Filters out items that are already in the persistent bin so they
  /// never reappear in the swipe deck after the app is restarted.
  Future<void> loadNextChunk() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final mediaService = ref.read(localMediaServiceProvider);
      final ascending = ref.read(mediaFetchAscendingProvider);
      final binService = ref.read(localBinServiceProvider);
      final binIds = binService.getBinIds();

      final newItems = await mediaService.fetchLocalMedia(
        page: state.page,
        ascending: ascending,
      );

      if (newItems.isEmpty) {
        state = state.copyWith(isLoading: false, hasMore: false);
      } else {
        // Filter out any items that are already in the persistent bin.
        final filtered = newItems
            .where((item) => !binIds.contains(item.id))
            .toList();

        state = state.copyWith(
          deck: [...state.deck, ...filtered],
          page: state.page + 1,
          isLoading: false,
        );

        // If all items in this chunk were filtered out (already binned),
        // automatically load the next chunk to avoid an empty/stalled deck.
        if (filtered.isEmpty && state.hasMore) {
          loadNextChunk();
        }
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Swipe left for delete
  // Remove the top item from the deck and add it to history with isDeleted = true
  void swipeLeft() {
    if (state.deck.isEmpty) return;

    // Get the top item from the deck
    final swipeItem = state.deck.first;

    state = state.copyWith(
      deck: state.deck.sublist(1), // Remove the top item
      history: [
        ...state.history,
        SwipedItem(item: swipeItem, isDeleted: true),
      ], // Add to history
      currentIndex: state.currentIndex + 1,
    );
    // Add to the bin (persists to Hive automatically)
    ref.read(binProvider.notifier).addToBin(swipeItem);

    // Load the next chunk based on the length of the deck
    if (state.deck.length < 5) {
      loadNextChunk();
    }
  }

  void swipeRight() {
    if (state.deck.isEmpty) return;

    // Get the top item from the deck
    final swipeItem = state.deck.first;

    state = state.copyWith(
      deck: state.deck.sublist(1), // Remove the top item
      history: [
        ...state.history,
        SwipedItem(item: swipeItem, isDeleted: false),
      ], // Add to history
      currentIndex: state.currentIndex + 1,
    );

    // Load the next chunk based on the length of the deck
    if (state.deck.length < 5) {
      loadNextChunk();
    }
  }

  void undo() {
    if (state.history.isEmpty) return;

    // Get the last swiped item from history
    final lastSwiped = state.history.last;

    state = state.copyWith(
      deck: [
        lastSwiped.item,
        ...state.deck,
      ], // Add it back to the top of the deck
      history: state.history.sublist(
        0,
        state.history.length - 1,
      ), // Remove it from history
      currentIndex: state.currentIndex - 1,
    );

    if (lastSwiped.isDeleted) {
      // Remove the item from the bin (also removes from Hive persistence)
      ref.read(binProvider.notifier).removeFromBin(lastSwiped.item);
    }
  }
}

// Defining the provider for the SwipeController\\
final swipeProvider = NotifierProvider<SwipeController, SwipeState>(
  SwipeController.new,
);

enum SwipeTriggerAction { swipeLeft, swipeRight, undo }

class SwipeTriggerEvent {
  final SwipeTriggerAction action;
  final bool isDeleted;
  final int timestamp;

  SwipeTriggerEvent(this.action, {this.isDeleted = false})
    : timestamp = DateTime.now().microsecondsSinceEpoch;
}

class SwipeTriggerNotifier extends Notifier<SwipeTriggerEvent?> {
  @override
  SwipeTriggerEvent? build() => null;

  @override
  set state(SwipeTriggerEvent? value) => super.state = value;
}

final swipeTriggerProvider =
    NotifierProvider<SwipeTriggerNotifier, SwipeTriggerEvent?>(
      SwipeTriggerNotifier.new,
    );
