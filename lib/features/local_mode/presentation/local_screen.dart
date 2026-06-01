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
        padding: AppTheme.topPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compact Top Header Row
            Text('Local Photos', style: Theme.of(context).textTheme.titleLarge),
            // // Sleek, low-profile Undo Button
            // AnimatedOpacity(
            //   opacity: state.history.isNotEmpty ? 1.0 : 0.0,
            //   duration: const Duration(milliseconds: 250),
            //   child: IgnorePointer(
            //     ignoring: state.history.isEmpty,
            //     child: Container(
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         color: AppTheme.surfaceColor,
            //         border: Border.all(
            //           color: AppTheme.secondaryPurple.withValues(
            //             alpha: 0.4,
            //           ),
            //           width: 1.5,
            //         ),
            //       ),
            //       child: IconButton(
            //         icon: const Iconify(
            //           MaterialSymbols.undo_rounded,
            //           color: AppTheme.primaryPurple,
            //           size: 24,
            //         ),
            //         onPressed: () =>
            //             ref.read(swipeProvider.notifier).undo(),
            //       ),
            //     ),
            //   ),
            // ),

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

                          // Reserve a 50px buffer at the top of the card stack bounding box
                          // to prevent the up-shifted layered cards from being clipped at the top.
                          const double topShiftBuffer = 25.0;
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
          ],
        ),
      ),
    );
  }
}
