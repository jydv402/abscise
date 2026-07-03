import 'package:abscise/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

import 'package:abscise/models/media_model.dart';
import 'package:abscise/widgets/media_fullscreen_widget.dart';
import 'package:abscise/controllers/bin_controller.dart';

// Selection State Provider
class BinSelectionNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String id) {
    final current = Set<String>.from(state);
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    state = current;
  }

  void selectAll(List<MediaItem> items) {
    state = items.map((i) => i.id).toSet();
  }

  void clearSelection() {
    state = {};
  }
}

final binSelectionProvider =
    NotifierProvider<BinSelectionNotifier, Set<String>>(
      BinSelectionNotifier.new,
    );

// BinScreen — Root widget with full-screen masonry + floating action bar
class BinScreen extends ConsumerWidget {
  const BinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final binState = ref.watch(binProvider);
    final localBin = binState.localBin;

    if (localBin.isEmpty) return const _BinEmptyState();

    return _BinMasonryGrid(items: localBin);
  }
}

// _BinMasonryGrid — Pinterest-style staggered masonry layout
class _BinMasonryGrid extends ConsumerWidget {
  final List<MediaItem> items;

  const _BinMasonryGrid({required this.items});

  /// Responsive column count based on screen width.
  int _crossAxisCount(double width) {
    if (width > 700) return 4;
    if (width > 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(binSelectionProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final columns = _crossAxisCount(screenWidth);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: _BinHeader(itemCount: items.length, items: items),
        ),

        // Masonry grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: columns,
            mainAxisSpacing: 3,
            crossAxisSpacing: 3,
            childCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = selection.contains(item.id);
              return _BinMasonryTile(
                item: item,
                isSelected: isSelected,
                onTap: () {
                  ref.read(binSelectionProvider.notifier).toggle(item.id);
                },
              );
            },
          ),
        ),

        // Bottom padding so last tiles aren't hidden behind floating bar / nav
        const SliverPadding(padding: EdgeInsets.only(bottom: 200)),
      ],
    );
  }
}

// _BinHeader — Compact header with title + count
class _BinHeader extends StatelessWidget {
  final int itemCount;
  final List<MediaItem> items;

  const _BinHeader({required this.itemCount, required this.items});

  String _formatTotalSize() {
    double totalMb = 0;
    for (final item in items) {
      totalMb += item.fileSizeMb ?? 0;
    }
    if (totalMb >= 1024) {
      return '${(totalMb / 1024).toStringAsFixed(1)} GB';
    }
    return '${totalMb.toStringAsFixed(0)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('Bin', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(width: 10),
            Text(
              '$itemCount ${itemCount == 1 ? 'item' : 'items'} · ${_formatTotalSize()}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary.withValues(alpha: 0.6),
              ),
            ),
            const Spacer(),
            // Select All / Deselect All
            Consumer(
              builder: (context, ref, _) {
                final selection = ref.watch(binSelectionProvider);
                final binState = ref.watch(binProvider);
                final allSelected =
                    selection.length == binState.localBin.length &&
                    selection.isNotEmpty;

                return GestureDetector(
                  onTap: () {
                    if (allSelected) {
                      ref.read(binSelectionProvider.notifier).clearSelection();
                    } else {
                      ref
                          .read(binSelectionProvider.notifier)
                          .selectAll(binState.localBin);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(6, 6, 18, 6),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Iconify(
                          allSelected
                              ? Ph.check_circle_duotone
                              : Ph.circle_duotone,
                          color: AppTheme.tertiaryLime,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          allSelected ? 'Deselect' : 'Select all',
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.tertiaryLime,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// _BinMasonryTile — Individual tile in the masonry grid
class _BinMasonryTile extends StatelessWidget {
  final MediaItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _BinMasonryTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AssetEntity?>(
      future: AssetEntity.fromId(item.id),
      builder: (context, snapshot) {
        double aspectRatio = 1.0;

        if (snapshot.hasData && snapshot.data != null) {
          final asset = snapshot.data!;
          if (asset.height > 0) {
            aspectRatio = asset.width / asset.height;
          }
        } else {
          // Deterministic placeholder aspect ratio while loading
          final hash = item.id.hashCode.abs();
          aspectRatio = 0.85 + (hash % 70) / 100.0;
        }

        return GestureDetector(
          onTap: onTap,
          onLongPress: () {
            Navigator.of(context, rootNavigator: true).push(
              PageRouteBuilder(
                opaque: false, // For a cleaner look
                pageBuilder: (context, _, _) =>
                    MediaFullscreenViewer(item: item),
                transitionsBuilder: (context, animation, _, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isSelected ? 14 : 8),
              border: isSelected
                  ? Border.all(color: AppTheme.tertiaryLime, width: 2.5)
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isSelected ? 12 : 8),
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Thumbnail image
                    if (snapshot.hasData && snapshot.data != null)
                      AssetEntityImage(
                        snapshot.data!,
                        isOriginal: false,
                        thumbnailSize: const ThumbnailSize(400, 600),
                        fit: BoxFit.cover,
                      )
                    else
                      Container(
                        color: AppTheme.surfaceColor,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: AppTheme.textSecondary,
                            size: 28,
                          ),
                        ),
                      ),

                    // Bottom gradient for badges
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 40,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Video duration badge (bottom-right)
                    if (item.type == MediaType.video && item.duration != null)
                      Positioned(
                        bottom: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                _formatDuration(item.duration!),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // File size badge (bottom-left)
                    if (item.fileSizeMb != null)
                      Positioned(
                        bottom: 6,
                        left: 6,
                        child: Text(
                          _formatSize(item.fileSizeMb!),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 10,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    // Selection overlay + check icon
                    if (isSelected)
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.tertiaryLime.withValues(alpha: 0.12),
                          border: Border.all(
                            color: AppTheme.tertiaryLime.withValues(alpha: 0.4),
                            width: 0,
                          ),
                        ),
                      ),

                    // Check circle (always visible — empty when unselected, filled when selected)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppTheme.tertiaryLime
                              : Colors.black.withValues(alpha: 0.3),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.tertiaryLime
                                : Colors.white.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check_rounded,
                                color: AppTheme.textBlack,
                                size: 14,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatSize(double mb) {
    if (mb >= 1024) return '${(mb / 1024).toStringAsFixed(1)}GB';
    if (mb >= 1) return '${mb.toStringAsFixed(1)}MB';
    return '${(mb * 1024).toStringAsFixed(0)}KB';
  }
}

// _BinEmptyState — Shown when the bin is empty
class _BinEmptyState extends StatelessWidget {
  const _BinEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Iconify(
              Ph.trash_duotone,
              color: AppTheme.textSecondary.withValues(alpha: 0.4),
              size: 72,
            ),
            const SizedBox(height: 20),
            Text(
              'Your bin is empty',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Swipe left on photos to add them here.\nReview and confirm before deleting permanently.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary.withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
