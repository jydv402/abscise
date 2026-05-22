import 'package:photo_manager/photo_manager.dart';

class LocalPermsService {
  /// Checks the current platform storage permission authorization level
  Future<PermissionState> checkCurrentStatus() async {
    return await PhotoManager.getPermissionState(
      requestOption: PermissionRequestOption(),
    );
  }

  /// Explicitly requests storage access from the operating system
  Future<PermissionState> requestExternalStorageAccess() async {
    return await PhotoManager.requestPermissionExtend(
      requestOption: PermissionRequestOption(),
    );
  }
}
