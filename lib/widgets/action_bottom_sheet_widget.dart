import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../themes/app_theme.dart';
import 'button/stack_button_widget.dart';

class ActionBottomSheet extends ConsumerStatefulWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String confirmIcon;
  final Color confirmColor;
  final Future<String> Function(WidgetRef ref) onAction;

  const ActionBottomSheet({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.confirmIcon,
    required this.confirmColor,
    required this.onAction,
  });

  @override
  ConsumerState<ActionBottomSheet> createState() => _ActionBottomSheetState();
}

class _ActionBottomSheetState extends ConsumerState<ActionBottomSheet> {
  bool _isProcessing = false;
  bool _isSuccess = false;
  String _successMessage = '';

  Future<void> _closeSheet() async {
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  Future<void> _handleConfirm() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final successMsg = await widget.onAction(ref);
      if (!mounted) return;

      setState(() {
        _isProcessing = false;
        _isSuccess = true;
        _successMessage = successMsg;
      });

      await Future.delayed(const Duration(milliseconds: 1500));
      await _closeSheet();
    } catch (e) {
      await _closeSheet();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .fromLTRB(24, 32, 24, 24),
      decoration: const BoxDecoration(
        color: AppTheme.darkBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isSuccess
              ? _buildSuccessView()
              : _isProcessing
              ? _buildProcessingView()
              : _buildConfirmView(),
        ),
      ),
    );
  }

  Widget _buildConfirmView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Text(widget.message, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 28),
        Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            StackButton(
              label: 'Cancel',
              iconifyIcon: Ph.x_bold,
              onPressed: () => Navigator.of(context).maybePop(),
              variant: ButtonVariant.tertiary,
            ),
            StackButton(
              label: widget.confirmLabel,
              iconifyIcon: widget.confirmIcon,
              onPressed: _handleConfirm,
              variant: widget.title.contains('Restore')
                  ? ButtonVariant.primary
                  : ButtonVariant.delete,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProcessingView() {
    return const SizedBox(
      height: 120,
      child: Center(
        child: CircularProgressIndicator(
          color: AppTheme.tertiaryLime,
          strokeCap: .round,
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return SizedBox(
      height: 120,
      child:
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                const Iconify(
                  Ph.check_circle_duotone,
                  color: AppTheme.tertiaryLime,
                  size: 54,
                ),
                Text(
                  _successMessage,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ).animate().scale(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
          ),
    );
  }
}
