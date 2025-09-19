import 'package:flutter/material.dart';

class FancyTile extends StatefulWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  const FancyTile({super.key, required this.title, this.subtitle, this.onTap});

  @override
  State<FancyTile> createState() => _FancyTileState();
}

class _FancyTileState extends State<FancyTile> {
  bool _down = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 100),
      scale: _down ? 0.95 : 1,
      child: Material(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () async {
            setState(() => _down = true);
            await Future.delayed(const Duration(milliseconds: 100));
            setState(() => _down = false);
            widget.onTap?.call();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(widget.subtitle!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}