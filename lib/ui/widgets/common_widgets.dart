import 'package:flutter/material.dart';

class ForestBackground extends StatelessWidget {
  final Widget child;
  const ForestBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF77C9F9), Color(0xFF2D8ECE)],
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}

class RibbonBar extends StatelessWidget {
  final VoidCallback? onHome, onXylophone, onDrums, onSounds, onParents;
  const RibbonBar({super.key, this.onHome, this.onXylophone, this.onDrums, this.onSounds, this.onParents});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            _NavButton(icon: Icons.home_rounded, tooltip: 'Acasă', onTap: onHome),
            const SizedBox(width: 8),
            _NavButton(icon: Icons.piano_rounded, tooltip: 'Xilofon', onTap: onXylophone),
            const SizedBox(width: 8),
            _NavButton(icon: Icons.music_note_rounded, tooltip: 'Tobe', onTap: onDrums),
            const SizedBox(width: 8),
            _NavButton(icon: Icons.volume_up_rounded, tooltip: 'Sunete', onTap: onSounds),
            const Spacer(),
            _NavButton(icon: Icons.lock_outline, tooltip: 'Părinți', onTap: onParents),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  const _NavButton({required this.icon, required this.tooltip, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.14),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 22, color: Colors.white),
          ),
        ),
      ),
    );
  }
}