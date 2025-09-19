import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common_widgets.dart';
import '../../services/audio_manager.dart';

/// A simple grid of sound cards. Each card represents a sound
/// item and will eventually trigger a playback when tapped.
class SoundsScreen extends StatelessWidget {
  const SoundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // For demonstration we generate eight placeholder items.
    // Associate each sound card with an audio asset. We reuse instrument
    // notes for this demo. Each index corresponds to a note file name.
    final items = [
      'C.wav',
      'D.wav',
      'E.wav',
      'F.wav',
      'G.wav',
      'A.wav',
      'B.wav',
      'C2.wav',
    ];
    return Scaffold(
      body: ForestBackground(
        child: Column(
          children: [
            RibbonBar(
              onHome: () => Navigator.popUntil(context, ModalRoute.withName('/')),
              onXylophone: () => Navigator.pushReplacementNamed(context, '/xylophone'),
              onDrums: () => Navigator.pushReplacementNamed(context, '/drums'),
              onSounds: () {},
              onParents: () => Navigator.pushNamed(context, '/parents'),
            ),
            const SizedBox(height: 12),
            Text(
              'Sunete',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 16 / 9,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _SoundCard(
                      index: index + 1,
                      audioName: items[index],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SoundCard extends StatelessWidget {
  const _SoundCard({required this.index, required this.audioName});
  final int index;
  final String audioName;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(.95),
      borderRadius: BorderRadius.circular(Radii.lg),
      elevation: 6,
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.lg),
        onTap: () async {
          // Play the associated sound when the card is tapped.
          final path = 'assets/audio/instruments/$audioName';
          await audioManager.play(path);
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.bgHill.withOpacity(.5),
                      AppColors.bgGrass.withOpacity(.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(Radii.lg),
                ),
              ),
            ),
            Positioned(
              left: 12,
              top: 12,
              child: _Badge(text: index.toString()),
            ),
            Center(
              child: Icon(
                Icons.pets_rounded,
                size: 64,
                color: AppColors.leaf2.withOpacity(.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.orange,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(blurRadius: 6, color: Colors.black26),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}