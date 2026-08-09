import 'package:abscise/models/media_model.dart';
import 'package:abscise/models/swiped_model.dart';

class SwipeState {
  final List<MediaItem> deck; // List of cards currently in the deck
  final List<SwipedItem> history; // List of cards that have been swiped
  final bool isLoading;
  final int currentIndex;
  final int page;
  final bool hasMore;

  /// Session-scoped counters — reset to 0 on each app launch / sort change.
  /// These are the single source of truth for displaying swipe counts in the UI.
  final int sessionKeepCount;
  final int sessionBinCount;

  SwipeState({
    required this.deck,
    required this.history,
    required this.isLoading,
    required this.currentIndex,
    required this.page,
    required this.hasMore,
    this.sessionKeepCount = 0,
    this.sessionBinCount = 0,
  });

  SwipeState copyWith({
    List<MediaItem>? deck,
    List<SwipedItem>? history,
    bool? isLoading,
    int? currentIndex,
    int? page,
    bool? hasMore,
    int? sessionKeepCount,
    int? sessionBinCount,
  }) {
    return SwipeState(
      deck: deck ?? this.deck,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      currentIndex: currentIndex ?? this.currentIndex,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      sessionKeepCount: sessionKeepCount ?? this.sessionKeepCount,
      sessionBinCount: sessionBinCount ?? this.sessionBinCount,
    );
  }
}
