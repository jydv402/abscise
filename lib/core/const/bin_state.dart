import 'media_item.dart';

class BinState {
  final List<MediaItem> localBin;
  final List<MediaItem> cloudBin;

  BinState({required this.localBin, required this.cloudBin});

  BinState copyWith({List<MediaItem>? localBin, List<MediaItem>? cloudBin}) {
    return BinState(
      localBin: localBin ?? this.localBin,
      cloudBin: cloudBin ?? this.cloudBin,
    );
  }
}
