import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import 'package:abscise/models/media_model.dart';
import 'package:abscise/themes/app_theme.dart';
import 'package:abscise/widgets/media_fullscreen_widget.dart';

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
          // Backdrop blur effect for glassmorphic card appearance
          BackdropFilter(
            filter: .blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
            ),
          ),
          // Performant downsampled local media loading
          if (item.localAsset != null)
            Padding(
              padding: const .all(4),
              child: AssetEntityImage(
                item.localAsset!,
                isOriginal: false,
                thumbnailSize: const ThumbnailSize(
                  500,
                  800,
                ), // Downsampled resolution for fast rendering
                thumbnailFormat: ThumbnailFormat.jpeg,
                fit: .scaleDown,
                errorBuilder: (context, error, stackTrace) =>
                    Image.file(File(item.path), fit: .scaleDown),
              ),
            )
          else
            Image.file(File(item.path), fit: .scaleDown),

          // Real-time Solid Full-Card Action Overlays (Keep / Delete color fills)
          if (isTopCard) ...[
            // "KEEP" Green Overlay
            if (keepOpacity > 0.0)
              IgnorePointer(
                child: Container(
                  color: AppTheme.keepGreen.withValues(
                    alpha: keepOpacity * 0.35,
                  ),
                ),
              ),

            // "DELETE" Red Overlay
            if (deleteOpacity > 0.0)
              IgnorePointer(
                child: Container(
                  color: AppTheme.deleteRed.withValues(
                    alpha: deleteOpacity * 0.35,
                  ),
                ),
              ),

            // Glassmorphic Fullscreen Inspect Button
            Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    PageRouteBuilder(
                      opaque: false, // Transparent transition overlay
                      pageBuilder: (context, anim1, anim2) =>
                          MediaFullscreenViewer(item: item),
                      transitionsBuilder: (context, anim1, anim2, child) {
                        return FadeTransition(opacity: anim1, child: child);
                      },
                    ),
                  );
                },
                child: Container(
                  padding: const .all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black54,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.24),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Iconify(
                    Ph.arrows_out_bold,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),

            // File type and size in MB (top left corner)
            Positioned(
              top: 20,
              left: 20,
              child: Row(
                spacing: 8,
                children: [
                  Container(
                    padding: const .symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      item.type == MediaType.video ? 'VIDEO' : 'IMAGE',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ),
                  Container(
                    padding: const .symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${item.fileSizeMb?.toStringAsFixed(2) ?? "0.00"} MB',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );

    // Apply scaling and translation for visual deck layering
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..translateByDouble(
          dragOffset.dx,
          dragOffset.dy + verticalOffset,
          0.0,
          1.0,
        )
        ..rotateZ(rotationAngle)
        ..scaleByDouble(scaleX, scaleY, 1.0, 1.0),
      child: cardBody,
    );
  }
}
