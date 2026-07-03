import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../core/themes/app_theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/nav_bar_mode_provider.dart';
import '../features/local_mode/controllers/swipe_controller.dart';
import '../features/bin/controllers/bin_controller.dart';
import '../features/bin/presentation/bin_screen.dart';
import '../core/const/swipe_state.dart';
import '../core/const/media_item.dart';
import '../core/providers/shared_prefs_provider.dart';

class CustomNavBar extends ConsumerWidget {
  /// The navigation shell provided by GoRouter's StatefulShellRoute
  final StatefulNavigationShell navigationShell;

  const CustomNavBar({super.key, required this.navigationShell});

  /// Helper method to safely switch branches when an item is tapped
  void _onTabSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  List<BoxShadow> _buildDoubleShadow() {
    return [
      BoxShadow(
        color: AppTheme.darkBackground.withValues(alpha: 0.90),
        blurRadius: 16.0,
        spreadRadius: 2.0,
        offset: const Offset(0, 0),
      ),
      BoxShadow(
        color: AppTheme.darkBackground.withValues(alpha: 0.70),
        blurRadius: 32.0,
        spreadRadius: 6.0,
        offset: const Offset(0, 0),
      ),
    ];
  }

  Widget _buildTabNavBar(
    BuildContext context,
    double screenWidth,
    double borderRadiusValue,
    double dynamicHeight,
  ) {
    return Container(
      key: const ValueKey('tabNavBar'),
      height: dynamicHeight,
      decoration: BoxDecoration(
        color: AppTheme.primaryPurple,
        borderRadius: BorderRadius.circular(borderRadiusValue),
        boxShadow: _buildDoubleShadow(),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _NavBarItem(
            index: 0,
            isSelected: navigationShell.currentIndex == 0,
            onTap: () => _onTabSelected(0),
            dynamicHeight: dynamicHeight,
          ),
          _NavBarItem(
            index: 1,
            isSelected: navigationShell.currentIndex == 1,
            onTap: () => _onTabSelected(1),
            dynamicHeight: dynamicHeight,
          ),
          _NavBarItem(
            index: 2,
            isSelected: navigationShell.currentIndex == 2,
            onTap: () => _onTabSelected(2),
            dynamicHeight: dynamicHeight,
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar(
    BuildContext context,
    double screenWidth,
    double borderRadiusValue,
    double dynamicHeight,
    WidgetRef ref,
    SwipeState swipeState,
  ) {
    final double iconSize = screenWidth < 340
        ? 22.0
        : (screenWidth > 400 ? 26.0 : 24.0);

    final int deleteCount = swipeState.history
        .where((item) => item.isDeleted)
        .length;
    final int keepCount = swipeState.history
        .where((item) => !item.isDeleted)
        .length;
    final bool hasHistory = swipeState.history.isNotEmpty;

    final double circleDiameter = dynamicHeight - 16.0;
    final double gap = (dynamicHeight - circleDiameter) / 2; // Always 8.0

    return Row(
      key: const ValueKey('actionBarMode'),
      spacing: 12,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Left Pill: Collapsed Nav Pill
        GestureDetector(
          onTap: () {
            ref.read(navBarModeProvider.notifier).switchToPageSwitch();
          },
          child: Container(
            width: dynamicHeight,
            height: dynamicHeight,
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple,
              shape: BoxShape.circle,
              boxShadow: _buildDoubleShadow(),
            ),
            child: Center(
              child: Container(
                width: circleDiameter,
                height: circleDiameter,
                decoration: const BoxDecoration(
                  color: AppTheme.darkBackground,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Iconify(
                    Ph.stack_duotone,
                    color: AppTheme.tertiaryLime,
                    size: iconSize,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Right Pill: Swipe Stats & Undo Pill
        Container(
          height: dynamicHeight,
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple,
            borderRadius: .circular(borderRadiusValue),
            boxShadow: _buildDoubleShadow(),
          ),
          padding: .all(gap),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Delete Count Pill
              Material(
                color: AppTheme.darkBackground,
                borderRadius: const .only(
                  bottomRight: .circular(8),
                  topRight: .circular(8),
                  bottomLeft: .circular(AppTheme.borderRadius),
                  topLeft: .circular(AppTheme.borderRadius),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: swipeState.deck.isNotEmpty
                      ? () {
                          ref.read(swipeTriggerProvider.notifier).state =
                              SwipeTriggerEvent(SwipeTriggerAction.swipeLeft);
                        }
                      : null,
                  child: Container(
                    height: circleDiameter,
                    alignment: .center,
                    padding: const .fromLTRB(14, 0, 18, 0),
                    child: Row(
                      spacing: 8,
                      children: [
                        Iconify(Ph.x_circle_duotone, color: AppTheme.deleteRed),
                        Text(
                          '$deleteCount',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: iconSize - 4,
                            fontWeight: .w500,
                            color: AppTheme.deleteRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 3),

              // Keep Count Pill
              Material(
                color: AppTheme.darkBackground,
                borderRadius: const .only(
                  bottomRight: .circular(AppTheme.borderRadius),
                  topRight: .circular(AppTheme.borderRadius),
                  bottomLeft: .circular(8),
                  topLeft: .circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: swipeState.deck.isNotEmpty
                      ? () {
                          ref.read(swipeTriggerProvider.notifier).state =
                              SwipeTriggerEvent(SwipeTriggerAction.swipeRight);
                        }
                      : null,
                  child: Container(
                    height: circleDiameter,
                    alignment: .center,
                    padding: const .fromLTRB(18, 0, 14, 0),
                    child: Row(
                      spacing: 8,
                      children: [
                        Text(
                          '$keepCount',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: iconSize - 4,
                            fontWeight: .w500,
                            color: AppTheme.keepGreen,
                          ),
                        ),
                        Iconify(
                          Ph.check_circle_duotone,
                          color: AppTheme.keepGreen,
                          size: iconSize,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: gap),

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
      ],
    );
  }

  Future<bool> _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppTheme.surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Outfit',
                color: AppTheme.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  backgroundColor: confirmColor.withValues(alpha: 0.15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  confirmLabel,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: confirmColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _handleRestore(
    BuildContext context,
    WidgetRef ref,
    List<MediaItem> items,
  ) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: 'Restore ${items.length} items?',
      message:
          'These items will be removed from the bin and will reappear in your swipe deck.',
      confirmLabel: 'Restore',
      confirmColor: AppTheme.keepGreen,
    );
    if (confirmed) {
      await ref.read(binProvider.notifier).restoreItems(items);
      ref.read(binSelectionProvider.notifier).clearSelection();
      ref.read(swipeProvider.notifier).loadNextChunk();
    }
  }

  Future<void> _handleDelete(
    BuildContext context,
    WidgetRef ref,
    List<MediaItem> items,
  ) async {
    final confirmed = await _showConfirmDialog(
      context,
      title: 'Permanently delete ${items.length} items?',
      message:
          'These files will be permanently removed from your device. This action cannot be undone.',
      confirmLabel: 'Delete',
      confirmColor: AppTheme.deleteRed,
    );
    if (confirmed) {
      final result =
          await ref.read(binProvider.notifier).permanentlyDeleteLocal(items);
      ref.read(binSelectionProvider.notifier).clearSelection();
      ref.read(memorySavedProvider.notifier).addMemorySaved(result.mbFreed);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Deleted ${result.deletedCount} items · Freed ${result.mbFreed.toStringAsFixed(1)} MB',
              style: const TextStyle(fontFamily: 'Outfit'),
            ),
            backgroundColor: AppTheme.surfaceColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Widget _buildBinSelectionBar(
    BuildContext context,
    double screenWidth,
    double borderRadiusValue,
    double dynamicHeight,
    WidgetRef ref,
  ) {
    final selection = ref.watch(binSelectionProvider);
    final binState = ref.watch(binProvider);
    final selectedCount = selection.length;
    final selectedItems =
        binState.localBin.where((i) => selection.contains(i.id)).toList();

    final double circleDiameter = dynamicHeight - 16.0;
    final double gap = (dynamicHeight - circleDiameter) / 2;
    final double fontSize = screenWidth < 340 ? 14.0 : 16.0;

    return Row(
      key: const ValueKey('binSelectionBar'),
      spacing: 12,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Left Pill: Deselect All
        GestureDetector(
          onTap: () {
            ref.read(binSelectionProvider.notifier).clearSelection();
          },
          child: Container(
            width: dynamicHeight,
            height: dynamicHeight,
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple,
              shape: BoxShape.circle,
              boxShadow: _buildDoubleShadow(),
            ),
            child: Center(
              child: Container(
                width: circleDiameter,
                height: circleDiameter,
                decoration: const BoxDecoration(
                  color: AppTheme.darkBackground,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Iconify(
                    Ph.stack_duotone,
                    color: AppTheme.tertiaryLime,
                    size: fontSize + 6,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Right Pill: Restore | Delete | Count
        Container(
          height: dynamicHeight,
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple,
            borderRadius: BorderRadius.circular(borderRadiusValue),
            boxShadow: _buildDoubleShadow(),
          ),
          padding: EdgeInsets.all(gap),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Restore Pill
              Material(
                color: AppTheme.darkBackground,
                borderRadius: BorderRadius.only(
                  bottomRight: const Radius.circular(8),
                  topRight: const Radius.circular(8),
                  bottomLeft: Radius.circular(AppTheme.borderRadius),
                  topLeft: Radius.circular(AppTheme.borderRadius),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _handleRestore(context, ref, selectedItems),
                  child: Container(
                    height: circleDiameter,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Restore',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: fontSize,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textWhite,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 3),

              // Delete Pill
              Material(
                color: AppTheme.darkBackground,
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _handleDelete(context, ref, selectedItems),
                  child: Container(
                    height: circleDiameter,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: fontSize,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.deleteRed,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 3),

              // Count Pill
              Material(
                color: AppTheme.darkBackground,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(AppTheme.borderRadius),
                  topRight: Radius.circular(AppTheme.borderRadius),
                  bottomLeft: const Radius.circular(8),
                  topLeft: const Radius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  height: circleDiameter,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '$selectedCount',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final mode = ref.watch(navBarModeProvider);
    final swipeState = ref.watch(swipeProvider);

    // Sleek border radius scaling to match inner items
    final double borderRadiusValue = screenWidth < 340
        ? 32.0
        : (screenWidth > 400 ? 48.0 : 44.0);

    final double paddingValue = screenWidth < 340
        ? 12.0
        : (screenWidth > 400 ? 18.0 : 16.0);
    final double marginValue = screenWidth < 340
        ? 3.0
        : (screenWidth > 400 ? 5.0 : 4.0);
    final double iconSize = screenWidth < 340
        ? 22.0
        : (screenWidth > 400 ? 26.0 : 24.0);

    final double dynamicHeight = paddingValue * 2 + iconSize + marginValue * 2;

    final bool isBinTab = navigationShell.currentIndex == 1;
    final bool hasBinSelection = isBinTab && ref.watch(binSelectionProvider).isNotEmpty;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slideAnimation, child: child),
        );
      },
      child: hasBinSelection
          ? _buildBinSelectionBar(
              context,
              screenWidth,
              borderRadiusValue,
              dynamicHeight,
              ref,
            )
          : mode == NavBarMode.pageSwitch
              ? _buildTabNavBar(
                  context,
                  screenWidth,
                  borderRadiusValue,
                  dynamicHeight,
                )
              : _buildActionBar(
                  context,
                  screenWidth,
                  borderRadiusValue,
                  dynamicHeight,
                  ref,
                  swipeState,
                ),
    ).animate().slideY(begin: 1.5, end: 0, curve: Curves.easeOutBack);
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.dynamicHeight,
  });
  final int index;
  final bool isSelected;
  final VoidCallback onTap;
  final double dynamicHeight;

  static const List<String> _activeIcons = [
    Ph.file_image_duotone,
    Ph.trash_duotone,
    Ph.graph_duotone,
  ];

  static const List<String> _inactiveIcons = [
    Ph.file_image_bold,
    Ph.trash_bold,
    Ph.graph_bold,
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double iconSize = screenWidth < 340
        ? 22.0
        : (screenWidth > 400 ? 26.0 : 24.0);

    final double circleDiameter = dynamicHeight - 16.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: circleDiameter,
        height: circleDiameter,
        margin: index == 0 || index == 2 ? .zero : .symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.darkBackground : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Iconify(
            isSelected ? _activeIcons[index] : _inactiveIcons[index],
            color: isSelected ? AppTheme.tertiaryLime : AppTheme.darkBackground,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
