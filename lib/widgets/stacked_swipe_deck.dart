import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/const/media_item.dart';
import '../core/providers/nav_bar_mode_provider.dart';
import 'swipe_card.dart';

class StackedSwipeDeck extends ConsumerStatefulWidget {
  final List<MediaItem> deck;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  const StackedSwipeDeck({
    super.key,
    required this.deck,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  ConsumerState<StackedSwipeDeck> createState() => _StackedSwipeDeckState();
}

class _StackedSwipeDeckState extends ConsumerState<StackedSwipeDeck>
    with SingleTickerProviderStateMixin {
  Offset _dragOffset = Offset.zero;
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isAnimating || widget.deck.isEmpty) return;
    
    // Switch the bottom navigation bar to Action Bar mode on first drag touch
    ref.read(navBarModeProvider.notifier).switchToActionBar();

    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isAnimating || widget.deck.isEmpty) return;

    final double velocityX = details.velocity.pixelsPerSecond.dx;

    // Decide whether the swipe performed is a left swipe or right swipe
    // Threshold set to 220px
    if (_dragOffset.dx > 220 || velocityX > 400) {
      _dismissCard(toRight: true);
    } else if (_dragOffset.dx < -220 || velocityX < -400) {
      _dismissCard(toRight: false);
    } else {
      _resetCard();
    }
  }

  void _dismissCard({required bool toRight}) {
    if (_isAnimating) return;
    setState(() {
      _isAnimating = true;
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final targetX = toRight ? screenWidth * 1.5 : -screenWidth * 1.5;

    _slideAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset(targetX, _dragOffset.dy),
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward(from: 0.0).then((_) {
      setState(() {
        _dragOffset = Offset.zero;
        _isAnimating = false;
      });
      _animController.reset();

      if (toRight) {
        widget.onSwipeRight();
      } else {
        widget.onSwipeLeft();
      }
    });
  }

  void _resetCard() {
    if (_isAnimating) return;
    setState(() {
      _isAnimating = true;
    });

    _slideAnimation = Tween<Offset>(begin: _dragOffset, end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
        );

    _animController.forward(from: 0.0).then((_) {
      setState(() {
        _dragOffset = Offset.zero;
        _isAnimating = false;
      });
      _animController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.deck.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final activeOffset = _isAnimating ? _slideAnimation.value : _dragOffset;

    // Swipe progress factor for background cards scaling interpolation (0.0 to 1.0)
    final double progress = (activeOffset.dx.abs() / 220.0).clamp(0.0, 1.0);

    // Dynamic rotation angle of top card
    final double rotationAngle = (activeOffset.dx / screenWidth) * 0.25;

    // Badges opacities
    final double keepOpacity = (activeOffset.dx / 220.0).clamp(0.0, 1.0);
    final double deleteOpacity = (-activeOffset.dx / 220.0).clamp(0.0, 1.0);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          // Bottom/Back Card (index 2) - Shifted further upwards and scaled down more aggressively (Option B)
          if (widget.deck.length > 2)
            SwipeCard(
              key: ValueKey(widget.deck[2].id),
              item: widget.deck[2],
              scaleX: lerpDouble(
                0.80,
                0.90,
                progress,
              )!, // Pronounced horizontal offset scale (Option B width)
              scaleY: lerpDouble(
                0.90,
                0.95,
                progress,
              )!, // Softer vertical scale (Option B height)
              verticalOffset: lerpDouble(
                -64.0,
                -32.0,
                progress,
              )!, // Increased stacking offset
              isTopCard: false,
            ),

          // Middle Card (index 1) - Shifted upwards and scaled down aggressively (Option B)
          if (widget.deck.length > 1)
            SwipeCard(
              key: ValueKey(widget.deck[1].id),
              item: widget.deck[1],
              scaleX: lerpDouble(0.90, 1.0, progress)!, // Option B width scale
              scaleY: lerpDouble(0.95, 1.0, progress)!, // Option B height scale
              verticalOffset: lerpDouble(
                -32.0,
                0.0,
                progress,
              )!, // Increased stacking offset
              isTopCard: false,
            ),

          // Active Gesture Card (index 0) - Centered and reactive
          SwipeCard(
            key: ValueKey(widget.deck[0].id),
            item: widget.deck[0],
            scaleX: 1.0,
            scaleY: 1.0,
            verticalOffset: 0.0,
            dragOffset: activeOffset,
            rotationAngle: rotationAngle,
            keepOpacity: keepOpacity,
            deleteOpacity: deleteOpacity,
            isTopCard: true,
          ),
        ],
      ),
    );
  }
}
