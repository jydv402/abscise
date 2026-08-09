import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../../controllers/bin_controller.dart';
import '../../controllers/swipe_controller.dart';
import '../../models/media_model.dart';
import '../../providers/shared_prefs_provider.dart';
import '../../screens/bin_screen.dart';
import '../../themes/app_theme.dart';
import '../action_bottom_sheet_widget.dart';
import '../button/action_round_button_widget.dart';
import '../button/pill_button_widget.dart';
import 'nav_bar_widget.dart';

class BinSelectionBar extends ConsumerWidget {
  final double borderRadiusValue;
  final double dynamicHeight;
  final double circleDiameter;
  final double gap;
  final double fontSize;
  final double iconSize;

  const BinSelectionBar({
    super.key,
    required this.borderRadiusValue,
    required this.dynamicHeight,
    required this.circleDiameter,
    required this.gap,
    required this.fontSize,
    required this.iconSize,
  });

  /// Handles the restore action for selected items in the bin.
  /// Displays a confirmation bottom sheet and restores the items if confirmed.
  void _handleRestore(
    BuildContext context,
    WidgetRef ref,
    List<MediaItem> items,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ActionBottomSheet(
          title:
              'Restore ${items.length} ${items.length == 1 ? 'item' : 'items'}?',
          message:
              'These items will be removed from the bin and will reappear in the swipe deck.',
          confirmLabel: 'Restore',
          confirmIcon: Ph.arrow_u_up_left_bold,
          confirmColor: AppTheme.keepGreen,
          onAction: (ref) async {
            await ref.read(binProvider.notifier).restoreItems(items);
            ref.read(binSelectionProvider.notifier).clearSelection();
            ref.read(swipeProvider.notifier).loadNextChunk();
            return 'Restored ${items.length} ${items.length == 1 ? 'item' : 'items'}';
          },
        );
      },
    );
  }

  /// Handles the delete action for selected items in the bin.
  /// Displays a confirmation bottom sheet and permanently deletes the items if confirmed.
  void _handleDelete(
    BuildContext context,
    WidgetRef ref,
    List<MediaItem> items,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ActionBottomSheet(
          title:
              'Permanently delete ${items.length} ${items.length == 1 ? 'item' : 'items'}?',
          message:
              'These files will be permanently removed from your device. This action cannot be undone.',
          confirmLabel: 'Delete',
          confirmIcon: Ph.trash_bold,
          confirmColor: AppTheme.deleteRed,
          onAction: (ref) async {
            final result = await ref
                .read(binProvider.notifier)
                .permanentlyDeleteLocal(items);
            ref.read(binSelectionProvider.notifier).clearSelection();
            ref.read(memorySavedProvider.notifier).addMemorySaved(result.mbFreed);
            return 'Deleted ${result.deletedCount} ${result.deletedCount == 1 ? 'item' : 'items'} · Freed ${result.mbFreed.toStringAsFixed(1)} MB';
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(binSelectionProvider);
    final binState = ref.watch(binProvider);
    final selectedCount = selection.length;
    final selectedItems = binState.localBin
        .where((i) => selection.contains(i.id))
        .toList();

    double totalMb = 0.0;
    for (var item in selectedItems) {
      if (item.fileSizeMb != null) {
        totalMb += item.fileSizeMb!;
      }
    }
    final String savedStr = totalMb > 1024
        ? '${(totalMb / 1024).toStringAsFixed(2)} GB'
        : '${totalMb.toStringAsFixed(1)} MB';

    return Padding(
      padding: const .symmetric(horizontal: 16),
      child: Column(
        key: const ValueKey('binSelectionBar'),
        spacing: 18,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: .only(left: dynamicHeight + 12),
            height: dynamicHeight,
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple,
              borderRadius: BorderRadius.circular(borderRadiusValue),
              boxShadow: CustomNavBar.doubleShadow,
            ),
            padding: .all(gap),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              spacing: 3,
              children: [
                Expanded(
                  child: PillButton(
                    position: PillPosition.left,
                    height: circleDiameter,
                    padding: .symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: .center,
                      spacing: 8,
                      children: [
                        Iconify(
                          Ph.check_square_offset_duotone,
                          color: AppTheme.tertiaryLime,
                          size: fontSize,
                        ),
                        Text(
                          '$selectedCount',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: fontSize,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: PillButton(
                    position: PillPosition.right,
                    height: circleDiameter,
                    padding: .symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: .center,
                      spacing: 8,
                      children: [
                        Text(
                          savedStr,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: fontSize,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textWhite,
                          ),
                        ),
                        Iconify(
                          Ph.hard_drives_duotone,
                          color: AppTheme.textWhite,
                          size: fontSize,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            spacing: 12,
            mainAxisAlignment: .center,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Left Pill: Deselect All
              ActionRoundButton(
                onTap: () =>
                    ref.read(binSelectionProvider.notifier).clearSelection(),
                dynamicHeight: dynamicHeight,
                circleDiameter: circleDiameter,
                iconSize: iconSize,
                icon: Ph.stack_duotone,
              ),

              // Right Pill: Restore | Delete
              Expanded(
                child: Container(
                  height: dynamicHeight,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple,
                    borderRadius: BorderRadius.circular(borderRadiusValue),
                    boxShadow: CustomNavBar.doubleShadow,
                  ),
                  padding: .all(gap),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    spacing: 3,
                    children: [
                      // Restore Pill
                      Expanded(
                        child: PillButton(
                          tooltipMessage: 'Restore selected items',
                          position: PillPosition.left,
                          height: circleDiameter,
                          padding: .symmetric(horizontal: 4),
                          onTap: () =>
                              _handleRestore(context, ref, selectedItems),
                          child: Row(
                            mainAxisAlignment: .center,
                            spacing: 8,
                            children: [
                              Iconify(
                                Ph.arrow_u_up_left_duotone,
                                color: AppTheme.tertiaryLime,
                                size: fontSize,
                              ),
                              Text(
                                'Restore',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.tertiaryLime,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Delete Pill
                      Expanded(
                        child: PillButton(
                          tooltipMessage: 'Permanently delete items',
                          position: PillPosition.right,
                          height: circleDiameter,
                          padding: .symmetric(horizontal: 4),
                          onTap: () =>
                              _handleDelete(context, ref, selectedItems),
                          child: Row(
                            mainAxisAlignment: .center,
                            spacing: 8,
                            children: [
                              Iconify(
                                Ph.trash_duotone,
                                color: AppTheme.deleteRed,
                                size: fontSize,
                              ),
                              Text(
                                'Delete',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.deleteRed,
                                ),
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
        ],
      ),
    );
  }
}
