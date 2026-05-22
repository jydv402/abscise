import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

import '../logic/local_perms_service.dart';
import '../state/local_perms_state.dart';

class LocalPermsController extends Notifier<LocalPermsState> {
  late final LocalPermsService _permState;

  @override
  LocalPermsState build() {
    _permState = LocalPermsService();
    return const LocalPermsState();
  }

  // Execute the request flow and update the state accordingly
  Future<void> requestPermissions() async {
    state = state.copyWith(status: PermStatus.requesting);

    try {
      final accessResult = await _permState.requestExternalStorageAccess();

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
