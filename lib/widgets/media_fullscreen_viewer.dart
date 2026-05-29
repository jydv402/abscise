import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../core/const/media_item.dart';

class MediaFullscreenViewer extends StatelessWidget {
  final MediaItem item;

  const MediaFullscreenViewer({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Pinch-to-zoom and pan interface
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
