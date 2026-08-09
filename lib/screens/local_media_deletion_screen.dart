import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ph.dart';

import 'package:abscise/themes/app_theme.dart';
import 'package:abscise/widgets/swipe_deck/stacked_swipe_deck_widget.dart';
import 'package:abscise/controllers/swipe_controller.dart';

import 'package:abscise/providers/shared_prefs_provider.dart';
import 'package:abscise/providers/nav_bar_mode_provider.dart';
import 'package:abscise/widgets/tutorial_bottom_sheet_widget.dart';

class LocalScreen extends ConsumerStatefulWidget {
  const LocalScreen({super.key});

  @override
  ConsumerState<LocalScreen> createState() => _LocalScreenState();
}

class _LocalScreenState extends ConsumerState<LocalScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTutorial();
    });
  }

  Future<void> _checkAndShowTutorial() async {
    final prefs = ref.read(appPreferencesProvider);
    if (!prefs.getTutorialShownLocalScreen()) {
      await prefs.setTutorialShownLocalScreen(true);
      if (mounted) {
        _showTutorial();
      }
    }
  }

  Future<void> _showTutorial() async {
    ref.read(navBarVisibilityProvider.notifier).hide();

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const TutorialBottomSheet(
        title: 'Local Photos Guide',
        instructions: [
          TutorialInstruction(
            icon: Ph.arrow_fat_lines_right_duotone,
            title: 'Keep Media',
            description:
                'Swipe right to keep the photo or video in your gallery.',
          ),
          TutorialInstruction(
            icon: Ph.arrow_fat_lines_left_duotone,
            title: 'Move to Bin',
            description: 'Swipe left to move the photo or video to the bin.',
          ),
          TutorialInstruction(
            icon: Ph.magnifying_glass_plus_duotone,
            title: 'View Fullscreen',
            description:
                'Tap on a photo or video to view it in full screen and zoom in.',
          ),
          TutorialInstruction(
            icon: Ph.arrow_u_up_left_duotone,
            title: 'Undo Swipe',
            description:
                'Use the curved arrow in the bottom bar to undo your last action.',
          ),
          TutorialInstruction(
            icon: Ph.person_simple_walk_duotone,
            title: 'Multi-Action Bar',
            description:
                'You can use the multi-action bar buttons to keep or remove the current media item without swiping.',
          ),
        ],
      ),
    );

    if (mounted) {
      ref.read(navBarVisibilityProvider.notifier).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(swipeProvider);

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Padding(
        padding: const .fromLTRB(16, 70, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compact Top Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Local Photos',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  onPressed: _showTutorial,
                  icon: const Iconify(
                    Ph.info_duotone,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),

            // Card Stack Container (Uses LayoutBuilder to dynamically scale aspect ratio)
            Expanded(
              child: Center(
                child: state.isLoading && state.deck.isEmpty
                    ? CircularProgressIndicator(color: AppTheme.primaryPurple)
                    : state.deck.isEmpty
                    ? Column(
                        mainAxisAlignment: .center,
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
