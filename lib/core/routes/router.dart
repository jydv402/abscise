import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/presentation/sign_in_with_google.dart';
import '../../features/onboarding/presentation/local_perms_screen.dart';

import '../../features/local_mode/presentation/local_screen.dart';
import '../../features/cloud_mode/presentation/cloud_screen.dart';
import '../../features/bin/presentation/bin_screen.dart';
import '../../features/stats/presentation/stats_screen.dart';

import '../../widgets/nav_bar.dart';

// Private navigator keys for each parallel branch
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _localNavigatorKey = GlobalKey<NavigatorState>();
final _cloudNavigatorKey = GlobalKey<NavigatorState>();
final _binNavigatorKey = GlobalKey<NavigatorState>();
final _statsNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/local-perms',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/local-perms',
      builder: (context, state) => const LocalPermsScreen(),
    ),
    GoRoute(
      path: '/google-sign',
      builder: (context, state) => const SignInWithGoogleScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          floatingActionButton: CustomNavBar(navigationShell: navigationShell),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
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
        // Tab 1: Cloud Photos Branch
        StatefulShellBranch(
          navigatorKey: _cloudNavigatorKey,
          routes: [
            GoRoute(
              path: '/cloud',
              builder: (context, state) => const CloudScreen(),
            ),
          ],
        ),
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
