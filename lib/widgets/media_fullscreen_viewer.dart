import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:video_player/video_player.dart';

import '../core/const/media_item.dart';
import '../core/themes/app_theme.dart';

class MediaFullscreenViewer extends StatelessWidget {
  final MediaItem item;

  const MediaFullscreenViewer({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isVideo = item.type == MediaType.video;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (isVideo)
            FullscreenVideoPlayer(item: item)
          else
            // Pinch-to-zoom and pan interface for images / GIFs
            Center(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 5.0, // High zoom tolerance
                clipBehavior: Clip.none,
                child: item.localAsset != null
                    ? AssetEntityImage(
                        item.localAsset!,
                        isOriginal:
                            true, // Loads original high-res for full zooming details
                        fit: BoxFit
                            .contain, // Fits actual aspect ratio of the image
                      )
                    : Image.file(
                        File(item.path),
                        fit: BoxFit.contain, // Fallback
                      ),
              ),
            ),

          // Top-right Close Button
          Positioned(
            top: 24,
            right: 24,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.5),
                  border: Border.all(color: Colors.white24, width: 1.5),
                ),
                child: IconButton(
                  tooltip: 'Close',
                  icon: const Iconify(
                    MaterialSymbols.close_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FullscreenVideoPlayer extends StatefulWidget {
  final MediaItem item;

  const FullscreenVideoPlayer({super.key, required this.item});

  @override
  State<FullscreenVideoPlayer> createState() => _FullscreenVideoPlayerState();
}

class _FullscreenVideoPlayerState extends State<FullscreenVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _showControls = true;
  Timer? _hideTimer;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    if (widget.item.source == StorageMode.local) {
      _controller = VideoPlayerController.file(File(widget.item.path));
    } else {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.item.path),
      );
    }

    try {
      await _controller.initialize();
      _controller.addListener(_videoPlayerListener);
      _controller.setLooping(
        true,
      ); // Loop videos for photo cleanup preview standard
      _controller.play();
      _startHideTimer();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  void _videoPlayerListener() {
    if (mounted) {
      setState(() {});
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideTimer();
    }
  }

  void _togglePlay() {
    _startHideTimer();
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        if (_controller.value.isCompleted) {
          _controller.seekTo(Duration.zero);
        }
        _controller.play();
      }
    });
  }

  void _rewind10Seconds() {
    _startHideTimer();
    final currentPosition = _controller.value.position;
    final targetPosition = currentPosition - const Duration(seconds: 10);
    _controller.seekTo(
      targetPosition < Duration.zero ? Duration.zero : targetPosition,
    );
  }

  void _fastForward10Seconds() {
    _startHideTimer();
    final currentPosition = _controller.value.position;
    final targetPosition = currentPosition + const Duration(seconds: 10);
    final maxDuration = _controller.value.duration;
    _controller.seekTo(
      targetPosition > maxDuration ? maxDuration : targetPosition,
    );
  }

  void _toggleMute() {
    _startHideTimer();
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _buildCircleControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required double iconSize,
    bool isPrimary = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isPrimary ? AppTheme.tertiaryLime : Colors.black54,
        border: Border.all(
          color: isPrimary ? Colors.transparent : Colors.white24,
          width: 1.5,
        ),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: AppTheme.tertiaryLime.withValues(alpha: 0.4),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: IconButton(
        iconSize: iconSize,
        icon: Icon(
          icon,
          color: isPrimary ? AppTheme.darkBackground : Colors.white,
        ),
        onPressed: onPressed,
      ),
    );
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller.removeListener(_videoPlayerListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: AppTheme.deleteRed,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              "Failed to load video",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.tertiaryLime),
      );
    }

    return GestureDetector(
      onTap: _toggleControls,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Zoomable/Pinnable Video Viewport
          Center(
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 5.0,
              clipBehavior: Clip.none,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          ),

          // Custom Controls Overlay
          AnimatedOpacity(
            opacity: _showControls ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: IgnorePointer(
              ignoring: !_showControls,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradual shade to highlight controls
                  Container(color: Colors.black26),

                  // Center Control Buttons
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 24,
                      children: [
                        _buildCircleControlButton(
                          icon: Icons.replay_10_rounded,
                          onPressed: _rewind10Seconds,
                          iconSize: 24,
                        ),
                        _buildCircleControlButton(
                          icon: _controller.value.isCompleted
                              ? Icons.replay_rounded
                              : (_controller.value.isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded),
                          onPressed: _togglePlay,
                          iconSize: 36,
                          isPrimary: true,
                        ),
                        _buildCircleControlButton(
                          icon: Icons.forward_10_rounded,
                          onPressed: _fastForward10Seconds,
                          iconSize: 24,
                        ),
                      ],
                    ),
                  ),

                  // Bottom seek bar and duration info
                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          // Seek bar progress line
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: VideoProgressIndicator(
                              _controller,
                              allowScrubbing: true,
                              colors: const VideoProgressColors(
                                playedColor: AppTheme.tertiaryLime,
                                bufferedColor: Colors.white30,
                                backgroundColor: Colors.white12,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                          // Time duration and Mute toggler
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _isMuted
                                      ? Icons.volume_off_rounded
                                      : Icons.volume_up_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                onPressed: _toggleMute,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
