import 'package:abscise/controllers/bin_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../../controllers/swipe_controller.dart';
import '../../models/swipe_state.dart';
import '../../providers/nav_bar_mode_provider.dart';
import '../button/action_round_button_widget.dart';
import '../button/pill_button_widget.dart';
import '../../themes/app_theme.dart';
import 'nav_bar_widget.dart';

class ActionNavBar extends ConsumerWidget {
  final SwipeState swipeState;
  final double borderRadiusValue;
  final double dynamicHeight;
  final double circleDiameter;
  final double gap;
  final double fontSize;
  final double iconSize;

  const ActionNavBar({
    super.key,
    required this.swipeState,
    required this.borderRadiusValue,
    required this.dynamicHeight,
    required this.circleDiameter,
    required this.gap,
    required this.fontSize,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int deleteCount = ref.watch(binProvider).localBin.length;
    final int keepCount = swipeState.history
        .where((item) => !item.isDeleted)
        .length;
    final bool hasHistory = swipeState.history.isNotEmpty;

    return Padding(
      padding: const .symmetric(horizontal: 16),
      child: Row(
        key: const ValueKey('actionBarMode'),
        spacing: 12,
        mainAxisAlignment: .center,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Left Pill: Collapsed Nav Pill
          ActionRoundButton(
            onTap: () =>
                ref.read(navBarModeProvider.notifier).switchToPageSwitch(),
            dynamicHeight: dynamicHeight,
            circleDiameter: circleDiameter,
            iconSize: iconSize,
            icon: Ph.stack_duotone,
          ),

          // Right Pill: Swipe Stats & Undo Pill
          Expanded(
            child: Container(
              height: dynamicHeight,
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple,
                borderRadius: BorderRadius.circular(borderRadiusValue),
                boxShadow: CustomNavBar.doubleShadow,
              ),
              padding: .all(gap),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                spacing: 3,
                children: [
                  // Delete Count Pill
                  Expanded(
                    child: PillButton(
                      position: PillPosition.left,
                      height: circleDiameter,
                      padding: const .symmetric(horizontal: 4),
                      onTap: swipeState.deck.isNotEmpty
                          ? () {
                              ref
                                  .read(swipeTriggerProvider.notifier)
                                  .state = SwipeTriggerEvent(
                                SwipeTriggerAction.swipeLeft,
                              );
                            }
                          : null,
                      child: Row(
                        mainAxisAlignment: .center,
                        spacing: 8,
                        children: [
                          Iconify(
                            Ph.x_circle_duotone,
                            color: AppTheme.deleteRed,
                            size: fontSize,
                          ),
                          Text(
                            '$deleteCount',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: iconSize,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.deleteRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Keep Count Pill
                  Expanded(
                    child: PillButton(
                      position: PillPosition.right,
                      height: circleDiameter,
                      padding: const .symmetric(horizontal: 4),
                      onTap: swipeState.deck.isNotEmpty
                          ? () {
                              ref
                                  .read(swipeTriggerProvider.notifier)
                                  .state = SwipeTriggerEvent(
                                SwipeTriggerAction.swipeRight,
                              );
                            }
                          : null,
                      child: Row(
                        mainAxisAlignment: .center,
                        spacing: 8,
                        children: [
                          Text(
                            '$keepCount',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: iconSize,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.keepGreen,
                            ),
                          ),
                          Iconify(
                            Ph.check_circle_duotone,
                            color: AppTheme.keepGreen,
                            size: fontSize,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: gap - 3),

                  // Undo Button
                  AnimatedOpacity(
                    opacity: hasHistory ? 1.0 : 0.35,
                    duration: const Duration(milliseconds: 200),
                    child: Material(
                      color: AppTheme.darkBackground,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: hasHistory
                            ? () {
                                final lastSwiped = swipeState.history.last;
                                ref
                                    .read(swipeTriggerProvider.notifier)
                                    .state = SwipeTriggerEvent(
                                  SwipeTriggerAction.undo,
                                  isDeleted: lastSwiped.isDeleted,
                                );
                              }
                            : null,
                        child: SizedBox(
                          width: circleDiameter,
                          height: circleDiameter,
                          child: Center(
                            child: Iconify(
                              Ph.arrow_u_up_left,
                              color: AppTheme.tertiaryLime,
                              size: iconSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
