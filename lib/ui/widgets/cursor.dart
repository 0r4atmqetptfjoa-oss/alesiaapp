import 'package:flutter/material.dart';

class CursorOnDisabled extends StatelessWidget {
  const CursorOnDisabled({
    super.key,
    required this.enabled,
    required this.child,
  });

  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      child: child,
    );
  }
}