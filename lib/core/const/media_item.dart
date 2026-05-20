enum StorageMode { local, gPhotos }

enum MediaType { image, video }

class MediaItem {
  final String id;
  final String path;
  final MediaType type;
  final StorageMode source;
  final Duration? duration; // For videos

  MediaItem({
    required this.id,
    required this.path,
    required this.type,
    required this.source,
    this.duration,
  });
}
