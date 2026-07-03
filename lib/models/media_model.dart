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
  final DateTime? binnedAt; // Timestamp when item was added to the bin

  MediaItem({
    required this.id,
    required this.path,
    required this.type,
    required this.source,
    this.duration,
    this.localAsset,
    this.fileSizeMb,
    this.binnedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'type': type.toString().split('.').last,
      'source': source.toString().split('.').last,
      'duration': duration?.inSeconds,
      'fileSizeMb': fileSizeMb,
      'binnedAt': binnedAt?.millisecondsSinceEpoch,
    };
  }

  /// Creates a copy of this MediaItem with the given fields replaced.
  MediaItem copyWith({
    String? id,
    String? path,
    MediaType? type,
    StorageMode? source,
    Duration? duration,
    AssetEntity? localAsset,
    double? fileSizeMb,
    DateTime? binnedAt,
  }) {
    return MediaItem(
      id: id ?? this.id,
      path: path ?? this.path,
      type: type ?? this.type,
      source: source ?? this.source,
      duration: duration ?? this.duration,
      localAsset: localAsset ?? this.localAsset,
      fileSizeMb: fileSizeMb ?? this.fileSizeMb,
      binnedAt: binnedAt ?? this.binnedAt,
    );
  }

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'],
      path: json['path'],
      type: MediaType.values.byName(json['type'] as String),
      source: StorageMode.values.byName(json['source'] as String),
      duration: json['duration'] != null
          ? Duration(seconds: json['duration'] as int)
          : null,
      fileSizeMb: (json['fileSizeMb'] as num?)?.toDouble(),
      localAsset: null, // Resolved asynchronously on startup
      binnedAt: json['binnedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['binnedAt'] as int)
          : null,
    );
  }
}
