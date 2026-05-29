import 'package:photo_manager/photo_manager.dart';

enum StorageMode { local, gPhotos }

enum MediaType { image, video }

class MediaItem {
  final String id;
  final String path;
  final MediaType type;
  final StorageMode source;
  final Duration? duration; // For videos
  final AssetEntity?
  localAsset; // Reference to native local asset for performant thumbnail loading
  final double? fileSizeMb; // Pre-calculated file size in megabytes

  MediaItem({
    required this.id,
    required this.path,
    required this.type,
    required this.source,
    this.duration,
    this.localAsset,
    this.fileSizeMb,
  });
}
