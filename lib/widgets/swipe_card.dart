import 'dart:io';
import 'package:flutter/material.dart';

import '../core/const/media_item.dart';
import '../core/themes/app_theme.dart';

class SwipeCard extends StatelessWidget {
  final MediaItem item;
  final double scale;
  final double verticalOffset;
  final Offset dragOffset;
  final double rotationAngle;
  final double keepOpacity;
  final double deleteOpacity;
  final bool isTopCard;

  const SwipeCard({
    super.key,
    required this.item,
    required this.scale,
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
          // Media content preview
          Image.file(File(item.path), fit: BoxFit.cover),

          // Subtle bottom shadow gradient to elevate text overlays
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black87],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Real-time Action Badges (Keep / Delete labels)
          if (isTopCard) ...[
            // "KEEP" badge (Fades in green when dragged right)
            Positioned(
              top: 40,
              left: 40,
              child: Opacity(
                opacity: keepOpacity,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.tertiaryLime, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'KEEP',
                    style: TextStyle(
                      color: AppTheme.tertiaryLime,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // "DELETE" badge (Fades in red/orange when dragged left)
            Positioned(
              top: 40,
              right: 40,
              child: Opacity(
                opacity: deleteOpacity,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.redAccent, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'DELETE',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
        ..scaleByDouble(scale, scale, 1.0, 1.0),
      child: cardBody,
    );
  }
}
