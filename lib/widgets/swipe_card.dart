import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../core/const/media_item.dart';
import '../core/themes/app_theme.dart';

class SwipeCard extends StatelessWidget {
  final MediaItem item;
  final double scaleX;
  final double scaleY;
  final double verticalOffset;
  final Offset dragOffset;
  final double rotationAngle;
  final double keepOpacity;
  final double deleteOpacity;
  final bool isTopCard;

  const SwipeCard({
    super.key,
    required this.item,
    required this.scaleX,
    required this.scaleY,
    required this.verticalOffset,
    this.dragOffset = Offset.zero,
    this.rotationAngle = 0.0,
    this.keepOpacity = 0.0,
    this.deleteOpacity = 0.0,
    required this.isTopCard,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardBody = ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Performant downsampled local media loading
          if (item.localAsset != null)
            AssetEntityImage(
              item.localAsset!,
              isOriginal: false,
              thumbnailSize: const ThumbnailSize(500, 800), // Downsampled resolution for fast rendering
              thumbnailFormat: ThumbnailFormat.jpeg,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.file(
                File(item.path),
                fit: BoxFit.cover,
              ),
            )
          else
            Image.file(
              File(item.path),
              fit: BoxFit.cover,
            ),

          // Real-time Solid Full-Card Action Overlays (Keep / Delete color fills)
          if (isTopCard) ...[
            // "KEEP" Green Overlay
            if (keepOpacity > 0.0)
              IgnorePointer(
                child: Container(
                  color: AppTheme.keepGreen.withValues(alpha: keepOpacity * 0.35),
                ),
              ),

            // "DELETE" Red Overlay
            if (deleteOpacity > 0.0)
              IgnorePointer(
                child: Container(
                  color: AppTheme.deleteRed.withValues(alpha: deleteOpacity * 0.35),
                ),
              ),
          ],

          // Clean, crisp edge border drawn on top of the image to maximize contrast
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // Apply scaling and translation for visual deck layering
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..translateByDouble(dragOffset.dx, dragOffset.dy + verticalOffset, 0.0, 1.0)
        ..rotateZ(rotationAngle)
        ..scaleByDouble(scaleX, scaleY, 1.0, 1.0),
      child: cardBody,
    );
  }
}
