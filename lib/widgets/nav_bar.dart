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
              Container(
                height: circleDiameter,
                alignment: .center,
                decoration: const BoxDecoration(
                  color: AppTheme.darkBackground,
                  borderRadius: .only(
                    bottomRight: .circular(8),
                    topRight: .circular(8),
                    bottomLeft: .circular(AppTheme.borderRadius),
                    topLeft: .circular(AppTheme.borderRadius),
                  ),
                ),
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
              const SizedBox(width: 3),

              // Keep Count Pill
              Container(
                height: circleDiameter,
                alignment: .center,
                decoration: const BoxDecoration(
                  color: AppTheme.darkBackground,
                  borderRadius: .only(
                    bottomRight: .circular(AppTheme.borderRadius),
                    topRight: .circular(AppTheme.borderRadius),
                    bottomLeft: .circular(8),
                    topLeft: .circular(8),
                  ),
                ),
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
              SizedBox(width: gap),
              // Undo Button
              GestureDetector(
                onTap: hasHistory
                    ? () => ref.read(swipeProvider.notifier).undo()
                    : null,
                child: AnimatedOpacity(
                  opacity: hasHistory ? 1.0 : 0.35,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: circleDiameter,
                    height: circleDiameter,
                    decoration: const BoxDecoration(
                      color: AppTheme.darkBackground,
                      shape: BoxShape.circle,
                    ),
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
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slideAnimation, child: child),
        );
      },
      child: mode == NavBarMode.pageSwitch
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
