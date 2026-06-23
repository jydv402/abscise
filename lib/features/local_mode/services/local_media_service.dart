import 'dart:io';

import 'package:abscise/core/const/media_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

class LocalMediaService {
  /// Fetches and returns local media items
  /// Returns `List<MediaItem>`
  Future<List<MediaItem>> fetchLocalMedia({
    required int page,
    int size = 50,
    required bool ascending,
  }) async {
    // Initially check if permissions are allowed
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      return [];
    }

    // Setup chronological sorting options
    final filterOption = FilterOptionGroup(
      orders: [OrderOption(type: OrderOptionType.createDate, asc: ascending)],
    );

    // Load albums from the device
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: .common,
      filterOption: filterOption,
    );

    // Return if no media is retrieved
    if (albums.isEmpty) {
      return [];
    }

    // The first album contains all consolidated media files (Recents/All Photos)
    final AssetPathEntity cameraRoll = albums.first;

    // Load only the media items corresponding to the size
    final List<AssetEntity> assets = await cameraRoll.getAssetListRange(
      start: page * size,
      end: (page + 1) * size,
    );

    final List<MediaItem> mediaItems = [];

    // Converting the List<AssetEntity> to List<MediaItem>
    for (final asset in assets) {
      final File? file = await asset.file;
      if (file == null) {
        continue;
      }

      final int fileLength = await file.length();
      final double sizeInMb = fileLength / (1024 * 1024);

      // Mapping file attributes to mediaItems
      mediaItems.add(
        MediaItem(
          id: asset.id,
          path: file.path,
          type: asset.type == AssetType.video
              ? MediaType.video
              : MediaType.image,
          source: StorageMode.local,
          duration: asset.type == AssetType.video
              ? Duration(seconds: asset.duration)
              : null,
          localAsset: asset,
          fileSizeMb: sizeInMb,
        ),
      );
    }

    return mediaItems;
  }
}

// Global provider to read the service in controllers
final localMediaServiceProvider = Provider<LocalMediaService>((ref) {
  return LocalMediaService();
});
