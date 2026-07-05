import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  void _handleRestore(
    BuildContext context,
    WidgetRef ref,
    List<MediaItem> items,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ActionBottomSheet(
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
          return 'Restored ${items.length} items';
        },
      ),
    );
  }

  void _handleDelete(
    BuildContext context,
    WidgetRef ref,
    List<MediaItem> items,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ActionBottomSheet(
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
          return 'Deleted ${result.deletedCount} items · Freed ${result.mbFreed.toStringAsFixed(1)} MB';
        },
      ),
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

    return Row(
      key: const ValueKey('binSelectionBar'),
      spacing: 12,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Left Pill: Deselect All
        ActionRoundButton(
          onTap: () => ref.read(binSelectionProvider.notifier).clearSelection(),
          dynamicHeight: dynamicHeight,
          circleDiameter: circleDiameter,
          iconSize: iconSize,
          icon: Ph.stack_duotone,
        ),

        // Right Pill: Restore | Delete | Count
        Container(
          height: dynamicHeight,
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple,
            borderRadius: BorderRadius.circular(borderRadiusValue),
            boxShadow: CustomNavBar.doubleShadow,
          ),
          padding: EdgeInsets.all(gap),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 3,
            children: [
              // Restore Pill
              PillButton(
                position: PillPosition.left,
                height: circleDiameter,
                onTap: () => _handleRestore(context, ref, selectedItems),
                child: Text(
                  'Restore',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.tertiaryLime,
                  ),
                ),
              ),

              // Delete Pill
              PillButton(
                position: PillPosition.right,
                height: circleDiameter,
                onTap: () => _handleDelete(context, ref, selectedItems),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.deleteRed,
                  ),
                ),
              ),

              // Count Pill
              PillButton(
                position: PillPosition.standalone,
                height: circleDiameter,
                padding: EdgeInsets.symmetric(horizontal: circleDiameter / 2),
                child: Text(
                  '$selectedCount',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
