import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForestBackground(
        child: Column(
          children: [
            RibbonBar(
              onHome: () => Navigator.pushReplacementNamed(context, '/'),
              onAnimals: () => Navigator.pushReplacementNamed(context, '/animals'),
              onGames: () => Navigator.pushReplacementNamed(context, '/games'),
              onSongs: () => Navigator.pushReplacementNamed(context, '/songs'),
              onStories: () => Navigator.pushReplacementNamed(context, '/stories'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _HomeCard(
                      icon: Icons.pets_rounded, label: 'Animale',
                      onTap: () => Navigator.pushReplacementNamed(context, '/animals')),
                    _HomeCard(
                      icon: Icons.extension_rounded, label: 'Jocuri',
                      onTap: () => Navigator.pushReplacementNamed(context, '/games')),
                    _HomeCard(
                      icon: Icons.library_music_rounded, label: 'Cântece',
                      onTap: () => Navigator.pushReplacementNamed(context, '/songs')),
                    _HomeCard(
                      icon: Icons.menu_book_rounded, label: 'Povești',
                      onTap: () => Navigator.pushReplacementNamed(context, '/stories')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _HomeCard({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 180, height: 140,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}