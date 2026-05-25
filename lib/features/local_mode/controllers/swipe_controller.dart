import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/const/media_item.dart';
import '../../../core/const/swipe_state.dart';
import '../../../core/const/swiped_item.dart';

class SwipeController extends Notifier<SwipeState> {
  @override
  SwipeState build() {
    return SwipeState(deck: [], history: [], isLoading: false, currentIndex: 0);
  }

  void loadNextChunk(List<MediaItem> newItems) {
    state = state.copyWith(
      deck: [...state.deck, ...newItems],
      isLoading: false,
    );
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
    // TODO: Add logic to add the item to bin
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
      // TODO: Add logic to remove the item from the bin
    }
  }
}
