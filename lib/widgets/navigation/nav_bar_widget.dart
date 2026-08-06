import 'package:abscise/widgets/navigation/tab_nav_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:abscise/themes/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:abscise/providers/nav_bar_mode_provider.dart';
import 'package:abscise/controllers/swipe_controller.dart';
import 'package:abscise/screens/bin_screen.dart';
import 'action_nav_bar_widget.dart';
import 'bin_selection_nav_bar_widget.dart';

class CustomNavBar extends ConsumerWidget {
  /// The navigation shell provided by GoRouter's StatefulShellRoute
  final StatefulNavigationShell navigationShell;

  const CustomNavBar({super.key, required this.navigationShell});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final mode = ref.watch(navBarModeProvider);
    final swipeState = ref.watch(swipeProvider);
    final isVisible = ref.watch(navBarVisibilityProvider);

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

    return AnimatedSize(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: Alignment.bottomCenter,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[...previousChildren, ?currentChild],
          );
        },
        transitionBuilder: (child, animation) {
          final slideAnimation =
              Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              );
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: slideAnimation, child: child),
          );
        },
        child: !isVisible
            ? const SizedBox.shrink(key: ValueKey('hidden_nav_bar'))
            : hasBinSelection
            ? BinSelectionBar(
                borderRadiusValue: borderRadiusValue,
                dynamicHeight: dynamicHeight,
                circleDiameter: circleDiameter,
                gap: gap,
                fontSize: fontSize,
                iconSize: iconSize,
              )
            : mode == NavBarMode.pageSwitch
            ? TabNavBar(
                navigationShell: navigationShell,
                borderRadiusValue: borderRadiusValue,
                dynamicHeight: dynamicHeight,
                circleDiameter: circleDiameter,
                iconSize: iconSize,
              )
            : ActionNavBar(
                swipeState: swipeState,
                borderRadiusValue: borderRadiusValue,
                dynamicHeight: dynamicHeight,
                circleDiameter: circleDiameter,
                gap: gap,
                fontSize: fontSize,
                iconSize: iconSize,
              ),
      ),
    ).animate().slideY(begin: 1.5, end: 0, curve: Curves.easeOutBack);
  }
}
