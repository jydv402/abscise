import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:abscise/providers/shared_prefs_provider.dart';
import 'package:abscise/services/local_perms_service.dart';
import 'package:abscise/models/local_perms_state.dart';

class LocalPermsController extends Notifier<LocalPermsState> {
  late final LocalPermsService _permState;

  @override
  LocalPermsState build() {
    _permState = LocalPermsService();

    // Check permission status immediately on startup
    checkPermissionsStatus();

    return const LocalPermsState();
  }

  // Check the current OS permission state and update controller state accordingly
  Future<void> checkPermissionsStatus() async {
    try {
      final status = await _permState.checkCurrentStatus();
      if (status.isAuth) {
        state = state.copyWith(status: PermStatus.granted);
      } else {
        final prefs = ref.read(appPreferencesProvider);
        final hasRequestedBefore = prefs.getHasRequestedPerms();
        if (hasRequestedBefore) {
          state = state.copyWith(status: PermStatus.denied, errorMsg: null);
        }
      }
    } catch (_) {
      // Fail silently for background state checks
    }
  }

  // Execute the request flow and update the state accordingly
  Future<void> requestPermissions() async {
    final prefs = ref.read(appPreferencesProvider);
    final hasRequestedBefore = prefs.getHasRequestedPerms();

    // The normal allow everything button now only works for the first time.
    // If already denied previously, it only shows the error snackbar.
    if (hasRequestedBefore) {
      state = state.copyWith(
        status: PermStatus.denied,
        errorMsg:
            "Permission denied. Please use the settings button in the red container above.",
      );
      return;
    }

    state = state.copyWith(status: PermStatus.requesting);

    try {
      // Request access explicitly for the first time
      final accessResult = await _permState.requestExternalStorageAccess();
      await prefs.setHasRequestedPerms(true);

      if (accessResult.isAuth) {
        state = state.copyWith(status: PermStatus.granted);
      } else {
        state = state.copyWith(
          status: PermStatus.denied,
          errorMsg: "Permission denied.",
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: PermStatus.denied,
        errorMsg: "An error occurred: $e",
      );
    }
  }

  // Open native system settings for permission authorization recovery
  Future<void> openAppSettings() async {
    state = state.copyWith(status: PermStatus.requesting);
    try {
      await PhotoManager.openSetting();
      final nextStatus = await _permState.checkCurrentStatus();
      if (nextStatus.isAuth) {
        state = state.copyWith(status: PermStatus.granted);
      } else {
        state = state.copyWith(
          status: PermStatus.denied,
          errorMsg:
              null, // Transition state back silently without popping up snackbar
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: PermStatus.denied,
        errorMsg: "Could not open settings: $e",
      );
    }
  }
}

// Provider for the UI layer to observe
final permsControllerProvider =
    NotifierProvider.autoDispose<LocalPermsController, LocalPermsState>(
      () => LocalPermsController(),
    );
