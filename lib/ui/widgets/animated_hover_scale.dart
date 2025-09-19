import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wraps a child and scales it slightly on hover (web/desktop) or tap (mobile).
/// Also sets a pointer cursor on web/desktop and can trigger light haptics on tap.
class AnimatedHoverScale extends StatefulWidget {
  const AnimatedHoverScale({
    super.key,
    required this.child,
    this.onTap,
    this.hoverScale = 0.97,
    this.duration = const Duration(milliseconds: 100),
    this.enableHaptics = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double hoverScale;
  final Duration duration;
  final bool enableHaptics;

  @override
  State<AnimatedHoverScale> createState() => _AnimatedHoverScaleState();
}

class _AnimatedHoverScaleState extends State<AnimatedHoverScale> {
  double _scale = 1.0;

  void _setHover(bool isHovering) {
    if (!kIsWeb) return;
    setState(() => _scale = isHovering ? widget.hoverScale : 1.0);
  }

  Future<void> _hapticTap() async {
    if (kIsWeb) return;
    if (!widget.enableHaptics) return;
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = widget.hoverScale),
        onTapCancel: () => setState(() => _scale = 1.0),
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTap: () async {
          await _hapticTap();
          widget.onTap?.call();
        },
        child: AnimatedScale(
          scale: _scale,
          duration: widget.duration,
          child: widget.child,
        ),
      ),
    );
  }
}