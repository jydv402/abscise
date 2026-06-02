import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../core/themes/app_theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/nav_bar_mode_provider.dart';
import '../features/local_mode/controllers/swipe_controller.dart';
import '../core/const/swipe_state.dart';

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
  ) {
    return Container(
      key: const ValueKey('tabNavBar'),
      decoration: BoxDecoration(
        color: AppTheme.primaryPurple,
        borderRadius: BorderRadius.circular(borderRadiusValue),
        boxShadow: _buildDoubleShadow(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _NavBarItem(
            index: 0,
            isSelected: navigationShell.currentIndex == 0,
            onTap: () => _onTabSelected(0),
          ),
          _NavBarItem(
            index: 1,
            isSelected: navigationShell.currentIndex == 1,
            onTap: () => _onTabSelected(1),
          ),
          _NavBarItem(
            index: 2,
            isSelected: navigationShell.currentIndex == 2,
            onTap: () => _onTabSelected(2),
          ),
          _NavBarItem(
            index: 3,
            isSelected: navigationShell.currentIndex == 3,
            onTap: () => _onTabSelected(3),
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
    final double paddingValue = screenWidth < 340
        ? 12.0
        : (screenWidth > 400 ? 18.0 : 16.0);
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

    return Row(
      key: const ValueKey('actionBarMode'),
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
                width: iconSize + paddingValue,
                height: iconSize + paddingValue,
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
        const SizedBox(width: 12),
        // Right Pill: Swipe Stats & Undo Pill
        Container(
          height: dynamicHeight,
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple,
            borderRadius: BorderRadius.circular(borderRadiusValue),
            boxShadow: _buildDoubleShadow(),
          ),
          padding: EdgeInsets.symmetric(horizontal: paddingValue * 1.4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Delete Count
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Iconify(
                    Ph.trash_bold,
                    color: AppTheme.deleteRed,
                    size: iconSize,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$deleteCount',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: iconSize - 5,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBackground,
                    ),
                  ),
                ],
              ),
              SizedBox(width: paddingValue * 1.4),

              // Keep Count
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Iconify(
                    Ph.check_bold,
                    color: AppTheme.keepGreen,
                    size: iconSize,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$keepCount',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: iconSize - 5,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBackground,
                    ),
                  ),
                ],
              ),
              SizedBox(width: paddingValue * 1.4),
              // Undo Button
              GestureDetector(
                onTap: hasHistory
                    ? () => ref.read(swipeProvider.notifier).undo()
                    : null,
                child: AnimatedOpacity(
                  opacity: hasHistory ? 1.0 : 0.35,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: EdgeInsets.all(paddingValue * 0.5),
                    decoration: const BoxDecoration(
                      color: AppTheme.darkBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Iconify(
                      Ph.arrow_u_up_left,
                      color: AppTheme.tertiaryLime,
                      size: iconSize,
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

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        );
      },
      child: mode == NavBarMode.pageSwitch
          ? _buildTabNavBar(context, screenWidth, borderRadiusValue)
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
  });
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  static const List<String> _activeIcons = [
    Ph.file_image_duotone,
    Ph.google_photos_logo_duotone,
    Ph.trash_duotone,
    Ph.graph_duotone,
  ];

  static const List<String> _inactiveIcons = [
    Ph.file_image_bold,
    Ph.google_photos_logo_bold,
    Ph.trash_bold,
    Ph.graph_bold,
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // Dynamic sleek padding that responds to screen width to prevent overflow
    // under high display scaling / small screens, while providing a substantial
    // feel on larger screens.
    final double paddingValue = screenWidth < 340
        ? 12.0
        : (screenWidth > 400 ? 18.0 : 16.0);

    final double marginValue = screenWidth < 340
        ? 3.0
        : (screenWidth > 400 ? 5.0 : 4.0);

    final double iconSize = screenWidth < 340
        ? 22.0
        : (screenWidth > 400 ? 26.0 : 24.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(paddingValue),
        margin: index == 0 || index == 3
            ? EdgeInsets.all(marginValue)
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.darkBackground : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Iconify(
          isSelected ? _activeIcons[index] : _inactiveIcons[index],
          color: isSelected ? AppTheme.tertiaryLime : AppTheme.darkBackground,
          size: iconSize,
        ),
      ),
    );
  }
}
