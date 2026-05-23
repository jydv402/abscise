import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/providers/shared_prefs_provider.dart';
import '../logic/local_perms_service.dart';
import '../state/local_perms_state.dart';

class LocalPermsController extends Notifier<LocalPermsState> {
  late final LocalPermsService _permState;

  @override
  LocalPermsState build() {
    _permState = LocalPermsService();

    // Check permission status immediately on startup
    _permState.checkCurrentStatus().then((status) {
      if (status.isAuth) {
        state = state.copyWith(status: PermStatus.granted);
      }
    });

    return const LocalPermsState();
  }

  // Execute the request flow and update the state accordingly
  Future<void> requestPermissions() async {
    state = state.copyWith(status: PermStatus.requesting);

    try {
      final currentStatus = await _permState.checkCurrentStatus();
      final prefs = ref.read(sharedPreferencesProvider);
      final hasRequestedBefore = prefs.getBool('has_requested_perms') ?? false;

      // If user has already requested permissions before and it's not authorized,
      // direct them to native app settings since the system prompt won't show again.
      if (hasRequestedBefore && !currentStatus.isAuth) {
        await PhotoManager.openSetting();
        final nextStatus = await _permState.checkCurrentStatus();
        if (nextStatus.isAuth) {
          state = state.copyWith(status: PermStatus.granted);
        } else {
          state = state.copyWith(
            status: PermStatus.denied,
            errorMsg: "Permission denied in settings.",
          );
        }
        return;
      }

      // Otherwise, request access explicitly for the first time
      final accessResult = await _permState.requestExternalStorageAccess();
      await prefs.setBool('has_requested_perms', true);

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
}

// Provider for the UI layer to observe
final permsControllerProvider =
    NotifierProvider.autoDispose<LocalPermsController, LocalPermsState>(
      () => LocalPermsController(),
    );
