import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import '../../../core/themes/app_theme.dart';
import '../../../widgets/stacked_swipe_deck.dart';
import '../controllers/swipe_controller.dart';

class LocalScreen extends ConsumerStatefulWidget {
  const LocalScreen({super.key});

  @override
  ConsumerState<LocalScreen> createState() => _LocalScreenState();
}

class _LocalScreenState extends ConsumerState<LocalScreen> {
  @override
  void initState() {
    super.initState();
    // Load the initial chunk of media files on mount
    Future.microtask(() {
      ref.read(swipeProvider.notifier).loadNextChunk();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(swipeProvider);

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Padding(
        // Matches AppTheme.topPadding left, top, and right values
        padding: const EdgeInsets.fromLTRB(16, 100, 16, 0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Left-aligns the header title
          children: [
            // Left-aligned header title matching the rest of the app
            Text(
              'Local Photos',
              style: Theme.of(context).textTheme.headlineLarge,
            ),

            const SizedBox(height: 16),

            // Card Stack Container (Uses LayoutBuilder to dynamically scale aspect ratio)
            Expanded(
              child: Center(
                child: state.isLoading && state.deck.isEmpty
                    ? CircularProgressIndicator(color: AppTheme.primaryPurple)
                    : state.deck.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Iconify(
                            MaterialSymbols.check_circle_outline_rounded,
                            color: AppTheme.tertiaryLime,
                            size: 72,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'All caught up!',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: Colors.white70),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your local media deck is empty.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white38),
                          ),
                        ],
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final availableHeight = constraints.maxHeight;
                          final availableWidth = constraints.maxWidth;

                          // Reserve a 40px buffer at the top of the card stack bounding box
                          // to prevent the up-shifted layered cards from being clipped at the top.
                          const double topShiftBuffer = 40.0;
                          final double usableHeight =
                              availableHeight - topShiftBuffer;

                          // Calculate optimal dimensions preserving a premium 0.7 aspect ratio
                          double cardHeight = usableHeight;
                          double cardWidth = cardHeight * 0.7;

                          if (cardWidth > availableWidth) {
                            cardWidth = availableWidth;
                            cardHeight = cardWidth / 0.7;
                          }

                          return SizedBox(
                            width: cardWidth,
                            height: cardHeight + topShiftBuffer,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  top: topShiftBuffer,
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: StackedSwipeDeck(
                                    deck: state.deck,
                                    onSwipeLeft: () => ref
                                        .read(swipeProvider.notifier)
                                        .swipeLeft(),
                                    onSwipeRight: () => ref
                                        .read(swipeProvider.notifier)
                                        .swipeRight(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),

            const SizedBox(height: 24),

            // Bottom Deletion & Navigation Controls
            if (state.deck.isNotEmpty || state.history.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildRoundButton(
                    icon: MaterialSymbols.undo_rounded,
                    color: AppTheme.secondaryPurple,
                    onPressed: state.history.isEmpty
                        ? null
                        : () => ref.read(swipeProvider.notifier).undo(),
                  ),
                ),
              ),

            // Vertical spacer to elevate the control buttons clear of the floating navigation bar
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundButton({
    required String icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    const double size = 72;
    const double iconSize = 36;
    final bool disabled = onPressed == null;

    return Opacity(
      opacity: disabled ? 0.3 : 1.0,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.darkBackground,
          border: Border.all(
            color: disabled ? Colors.white10 : color.withValues(alpha: 0.4),
            width: 2,
          ),
          boxShadow: disabled
              ? []
              : [
                  BoxShadow(
                    color: color.withValues(alpha: 0.15),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
        ),
        child: ClipOval(
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              icon: Iconify(
                icon,
                color: disabled ? Colors.white38 : color,
                size: iconSize,
              ),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
