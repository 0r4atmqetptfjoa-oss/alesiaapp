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
  final VoidCallback? onHome, onAnimals, onSongs, onGames, onStories, onParents;
  const RibbonBar({super.key, this.onHome, this.onAnimals, this.onSongs, this.onGames, this.onStories, this.onParents});

  @override
  Widget build(BuildContext context) {
    return Material( // ✅ Material ancestor pentru toate InkWell din bară
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            _NavButton(icon: Icons.home_rounded, tooltip: 'Acasă', onTap: onHome),
            const SizedBox(width: 8),
            _NavButton(icon: Icons.pets_rounded, tooltip: 'Animale', onTap: onAnimals),
            const SizedBox(width: 8),
            _NavButton(icon: Icons.library_music_rounded, tooltip: 'Cântece', onTap: onSongs),
            const SizedBox(width: 8),
            _NavButton(icon: Icons.extension_rounded, tooltip: 'Jocuri', onTap: onGames),
            const SizedBox(width: 8),
            _NavButton(icon: Icons.menu_book_rounded, tooltip: 'Povești', onTap: onStories),
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