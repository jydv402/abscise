import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

// import 'package:abscise/screens/google_auth_screen.dart';
import 'package:abscise/screens/local_perms_screen.dart';
import 'package:abscise/screens/splash_screen.dart';
import 'package:abscise/screens/local_privacy_screen.dart';
// import 'package:abscise/screens/google_privacy_screen.dart';

import 'package:abscise/screens/local_screen.dart';
// import 'package:abscise/screens/cloud_screen.dart';
import 'package:abscise/screens/bin_screen.dart';
import 'package:abscise/screens/stats_screen.dart';

import 'package:abscise/widgets/nav_bar_widget.dart';

// Private navigator keys for each parallel branch
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _localNavigatorKey = GlobalKey<NavigatorState>();
// final _cloudNavigatorKey = GlobalKey<NavigatorState>();
final _binNavigatorKey = GlobalKey<NavigatorState>();
final _statsNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/splash',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/local-perms',
      builder: (context, state) => const LocalPermsScreen(),
    ),
    // GoRoute(
    //   path: '/google-auth',
    //   builder: (context, state) => const GoogleAuthScreen(),
    // ),
    GoRoute(
      path: '/local-privacy',
      builder: (context, state) => const LocalPrivacyScreen(),
    ),
    // GoRoute(
    //   path: '/google-privacy',
    //   builder: (context, state) => const GooglePrivacyScreen(),
    // ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ShellLifecycleObserver(
          child: Scaffold(
            body: navigationShell,
            floatingActionButton: CustomNavBar(
              navigationShell: navigationShell,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        );
      },
      branches: [
        // Tab 0: Local Photos Branch
        StatefulShellBranch(
          navigatorKey: _localNavigatorKey,
          routes: [
            GoRoute(
              path: '/local',
              builder: (context, state) => const LocalScreen(),
            ),
          ],
        ),
        // Tab 1: Cloud Photos Branch (Temporarily disabled)
        // StatefulShellBranch(
        //   navigatorKey: _cloudNavigatorKey,
        //   routes: [
        //     GoRoute(
        //       path: '/cloud',
        //       builder: (context, state) => const CloudScreen(),
        //     ),
        //   ],
        // ),
        // Tab 2: The Bin Branch
        StatefulShellBranch(
          navigatorKey: _binNavigatorKey,
          routes: [
            GoRoute(
              path: '/bin',
              builder: (context, state) => const BinScreen(),
            ),
          ],
        ),
        // Tab 3: Stats & Settings Branch
        StatefulShellBranch(
          navigatorKey: _statsNavigatorKey,
          routes: [
            GoRoute(
              path: '/stats',
              builder: (context, state) => const StatsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class ShellLifecycleObserver extends StatefulWidget {
  final Widget child;

  const ShellLifecycleObserver({super.key, required this.child});

  @override
  State<ShellLifecycleObserver> createState() => _ShellLifecycleObserverState();
}

class _ShellLifecycleObserverState extends State<ShellLifecycleObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    final status = await PhotoManager.getPermissionState(
      requestOption: PermissionRequestOption(),
    );
    if (!status.isAuth && mounted) {
      context.go('/local-perms');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
