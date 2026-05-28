import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/providers/shared_prefs_provider.dart';
import '../../../core/themes/app_theme.dart';
import '../logic/local_perms_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAndRoute();
    });
  }

  Future<void> _initializeAndRoute() async {
    final stopwatch = Stopwatch()..start();

    // Asynchronously check local storage permissions
    final permsService = LocalPermsService();
    final permStatus = await permsService.checkCurrentStatus();

    // Read Google authentication cached flags from SharedPreferences
    final prefs = ref.read(appPreferencesProvider);
    final alreadySkipped = prefs.getGoogleAuthSkipped();
    final alreadyAuthenticated = prefs.getGoogleAuthenticated();

    // Enforcing a minimum splash display duration
    final elapsed = stopwatch.elapsedMilliseconds;
    const minimumSplashDuration = 1200; // Wait for at least 1.2 seconds
    if (elapsed < minimumSplashDuration) {
      await Future.delayed(
        Duration(milliseconds: minimumSplashDuration - elapsed),
      );
    }

    if (!mounted) return;

    // Select the correct destination route
    if (permStatus.isAuth) {
      if (alreadySkipped || alreadyAuthenticated) {
        context.go('/local');
      } else {
        context.go('/google-auth');
      }
    } else {
      context.go('/local-perms');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          spacing: 48,
          children: [
            // Center brand logo
            Image.asset(
                  'assets/branding/abscise_logo_fg.png',
                  width: 156,
                  height: 156,
                )
                .animate()
                .fadeIn(duration: 800.ms)
                .scale(
                  delay: 150.ms,
                  duration: 650.ms,
                  curve: Curves.easeOutBack,
                ),
            // Progress indicator
            Padding(
              padding: .symmetric(horizontal: 100),
              child: LinearProgressIndicator(
                borderRadius: .circular(32),
                backgroundColor: AppTheme.tertiaryLime.withValues(alpha: 0.25),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.tertiaryLime,
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
            ),
          ],
        ),
      ),
      floatingActionButton:
          Text(
                'Abscise',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppTheme.tertiaryLime,
                  fontWeight: .w400,
                ),
              )
              .animate()
              .slide(
                delay: 200.ms,
                duration: 400.ms,
                begin: const Offset(0, 0.5),
                end: Offset.zero,
                curve: Curves.easeOutCubic,
              )
              .fadeIn(delay: 200.ms, duration: 400.ms),
      floatingActionButtonLocation: .centerFloat,
    );
  }
}
