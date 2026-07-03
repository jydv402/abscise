import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

import 'package:abscise/themes/app_theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:abscise/providers/nav_bar_mode_provider.dart';
import 'package:abscise/controllers/swipe_controller.dart';
import 'package:abscise/controllers/bin_controller.dart';
import 'package:abscise/screens/bin_screen.dart';
import 'package:abscise/models/swipe_state.dart';
import 'package:abscise/models/media_model.dart';
import 'package:abscise/providers/shared_prefs_provider.dart';

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

  static List<BoxShadow> get doubleShadow {
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
    double borderRadiusValue,
    double dynamicHeight,
    double circleDiameter,
    double iconSize,
  ) {
    return Container(
      key: const ValueKey('tabNavBar'),
      height: dynamicHeight,
      decoration: BoxDecoration(
        color: AppTheme.primaryPurple,
        borderRadius: BorderRadius.circular(borderRadiusValue),
        boxShadow: doubleShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          _NavBarItem(
            index: 0,
            isSelected: navigationShell.currentIndex == 0,
            onTap: () => _onTabSelected(0),
            circleDiameter: circleDiameter,
            iconSize: iconSize,
          ),
          _NavBarItem(
            index: 1,
            isSelected: navigationShell.currentIndex == 1,
            onTap: () => _onTabSelected(1),
            circleDiameter: circleDiameter,
            iconSize: iconSize,
          ),
          _NavBarItem(
            index: 2,
            isSelected: navigationShell.currentIndex == 2,
            onTap: () => _onTabSelected(2),
            circleDiameter: circleDiameter,
            iconSize: iconSize,
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar(
    BuildContext context,
    WidgetRef ref,
    SwipeState swipeState,
    double borderRadiusValue,
    double dynamicHeight,
    double circleDiameter,
    double gap,
    double iconSize,
  ) {
    final int deleteCount = swipeState.history
        .where((item) => item.isDeleted)
        .length;
    final int keepCount = swipeState.history
        .where((item) => !item.isDeleted)
        .length;
    final bool hasHistory = swipeState.history.isNotEmpty;

    return Row(
      key: const ValueKey('actionBarMode'),
      spacing: 12,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Left Pill: Collapsed Nav Pill
        _ActionIconButton(
          onTap: () =>
              ref.read(navBarModeProvider.notifier).switchToPageSwitch(),
          dynamicHeight: dynamicHeight,
          circleDiameter: circleDiameter,
          iconSize: iconSize,
          icon: Ph.stack_duotone,
        ),

        // Right Pill: Swipe Stats & Undo Pill
        Container(
          height: dynamicHeight,
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple,
            borderRadius: BorderRadius.circular(borderRadiusValue),
            boxShadow: doubleShadow,
          ),
          padding: EdgeInsets.all(gap),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 3,
            children: [
              // Delete Count Pill
              _PillButton(
                position: _PillPosition.left,
                height: circleDiameter,
                padding: const EdgeInsets.fromLTRB(14, 0, 18, 0),
                onTap: swipeState.deck.isNotEmpty
                    ? () {
                        ref.read(swipeTriggerProvider.notifier).state =
                            SwipeTriggerEvent(SwipeTriggerAction.swipeLeft);
                      }
                    : null,
                child: Row(
                  spacing: 8,
                  children: [
                    Iconify(Ph.x_circle_duotone, color: AppTheme.deleteRed),
                    Text(
                      '$deleteCount',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: iconSize - 4,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.deleteRed,
                      ),
                    ),
                  ],
                ),
              ),

              // Keep Count Pill
              _PillButton(
                position: _PillPosition.right,
                height: circleDiameter,
                padding: const EdgeInsets.fromLTRB(18, 0, 14, 0),
                onTap: swipeState.deck.isNotEmpty
                    ? () {
                        ref.read(swipeTriggerProvider.notifier).state =
                            SwipeTriggerEvent(SwipeTriggerAction.swipeRight);
                      }
                    : null,
                child: Row(
                  spacing: 8,
                  children: [
                    Text(
                      '$keepCount',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: iconSize - 4,
                        fontWeight: FontWeight.w500,
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
      final result = await ref
          .read(binProvider.notifier)
          .permanentlyDeleteLocal(items);
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
    WidgetRef ref,
    double borderRadiusValue,
    double dynamicHeight,
    double circleDiameter,
    double gap,
    double fontSize,
    double iconSize,
  ) {
    final selection = ref.watch(binSelectionProvider);
    final binState = ref.watch(binProvider);
    final selectedCount = selection.length;
    final selectedItems = binState.localBin
        .where((i) => selection.contains(i.id))
        .toList();

    return Row(
      key: const ValueKey('binSelectionBar'),
      spacing: 12,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Left Pill: Deselect All
        _ActionIconButton(
          onTap: () => ref.read(binSelectionProvider.notifier).clearSelection(),
          dynamicHeight: dynamicHeight,
          circleDiameter: circleDiameter,
          iconSize: fontSize + 6,
          icon: Ph.stack_duotone,
        ),

        // Right Pill: Restore | Delete | Count
        Container(
          height: dynamicHeight,
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple,
            borderRadius: BorderRadius.circular(borderRadiusValue),
            boxShadow: doubleShadow,
          ),
          padding: EdgeInsets.all(gap),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 3,
            children: [
              // Restore Pill
              _PillButton(
                position: _PillPosition.left,
                height: circleDiameter,
                onTap: () => _handleRestore(context, ref, selectedItems),
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

              // Delete Pill
              _PillButton(
                position: _PillPosition.middle,
                height: circleDiameter,
                onTap: () => _handleDelete(context, ref, selectedItems),
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

              // Count Pill
              _PillButton(
                position: _PillPosition.right,
                height: circleDiameter,
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
    final double fontSize = screenWidth < 340 ? 14.0 : 16.0;

    final double dynamicHeight = paddingValue * 2 + iconSize + marginValue * 2;
    final double circleDiameter = dynamicHeight - 16.0;
    final double gap = (dynamicHeight - circleDiameter) / 2;

    final bool isBinTab = navigationShell.currentIndex == 1;
    final bool hasBinSelection =
        isBinTab && ref.watch(binSelectionProvider).isNotEmpty;

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
              ref,
              borderRadiusValue,
              dynamicHeight,
              circleDiameter,
              gap,
              fontSize,
              iconSize,
            )
          : mode == NavBarMode.pageSwitch
          ? _buildTabNavBar(
              context,
              borderRadiusValue,
              dynamicHeight,
              circleDiameter,
              iconSize,
            )
          : _buildActionBar(
              context,
              ref,
              swipeState,
              borderRadiusValue,
              dynamicHeight,
              circleDiameter,
              gap,
              iconSize,
            ),
    ).animate().slideY(begin: 1.5, end: 0, curve: Curves.easeOutBack);
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.circleDiameter,
    required this.iconSize,
  });
  final int index;
  final bool isSelected;
  final VoidCallback onTap;
  final double circleDiameter;
  final double iconSize;

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: circleDiameter,
        height: circleDiameter,
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

class _ActionIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final double dynamicHeight;
  final double circleDiameter;
  final double iconSize;
  final String icon;

  const _ActionIconButton({
    required this.onTap,
    required this.dynamicHeight,
    required this.circleDiameter,
    required this.iconSize,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: dynamicHeight,
        height: dynamicHeight,
        decoration: BoxDecoration(
          color: AppTheme.primaryPurple,
          shape: BoxShape.circle,
          boxShadow: CustomNavBar.doubleShadow,
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
                icon,
                color: AppTheme.tertiaryLime,
                size: iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _PillPosition { left, middle, right, standalone }

class _PillButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double height;
  final _PillPosition position;
  final EdgeInsetsGeometry padding;

  const _PillButton({
    required this.child,
    this.onTap,
    required this.height,
    this.position = _PillPosition.standalone,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;
    switch (position) {
      case _PillPosition.left:
        borderRadius = const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.borderRadius),
          bottomLeft: Radius.circular(AppTheme.borderRadius),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        );
        break;
      case _PillPosition.middle:
        borderRadius = BorderRadius.circular(8);
        break;
      case _PillPosition.right:
        borderRadius = const BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          topRight: Radius.circular(AppTheme.borderRadius),
          bottomRight: Radius.circular(AppTheme.borderRadius),
        );
        break;
      case _PillPosition.standalone:
        borderRadius = BorderRadius.circular(AppTheme.borderRadius);
        break;
    }

    return Material(
      color: AppTheme.darkBackground,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height,
          alignment: Alignment.center,
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
