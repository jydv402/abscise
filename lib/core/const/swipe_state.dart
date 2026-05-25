import 'package:abscise/core/const/media_item.dart';
import 'package:abscise/core/const/swiped_item.dart';

class SwipeState {
  final List<MediaItem> deck; // List of cards currently in the deck
  final List<SwipedItem> history; // List of cards that have been swiped
  final bool isLoading;
  final int currentIndex;

  SwipeState({
    required this.deck,
    required this.history,
    required this.isLoading,
    required this.currentIndex,
  });

  SwipeState copyWith({
    List<MediaItem>? deck,
    List<SwipedItem>? history,
    bool? isLoading,
    int? currentIndex,
  }) {
    return SwipeState(
      deck: deck ?? this.deck,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
