import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/animated_hover_scale.dart';
import '../../services/audio_manager.dart';

class SoundItem {
  final String title;
  final String imageAsset;
  final String audioAsset; // reuse instrument notes for demo
  const SoundItem(this.title, this.imageAsset, this.audioAsset);
}

final List<SoundItem> soundItems = [
  SoundItem('Clopot', 'assets/images/sounds/note1.png', 'assets/audio/instruments/C.wav'),
  SoundItem('Fluier', 'assets/images/sounds/note2.png', 'assets/audio/instruments/D.wav'),
  SoundItem('Tamburină', 'assets/images/sounds/note3.png', 'assets/audio/instruments/E.wav'),
  SoundItem('Trianglu', 'assets/images/sounds/note4.png', 'assets/audio/instruments/F.wav'),
  SoundItem('Clape', 'assets/images/sounds/note5.png', 'assets/audio/instruments/G.wav'),
  SoundItem('Chitară', 'assets/images/sounds/note6.png', 'assets/audio/instruments/A.wav'),
  SoundItem('Vioară', 'assets/images/sounds/note7.png', 'assets/audio/instruments/B.wav'),
  SoundItem('Xilofon', 'assets/images/sounds/note8.png', 'assets/audio/instruments/C2.wav'),
];

class SoundsScreen extends StatelessWidget {
  const SoundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    childAspectRatio: 16 / 10,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                  ),
                  itemCount: soundItems.length,
                  itemBuilder: (context, index) {
                    final item = soundItems[index];
                    return AnimatedHoverScale(
                      onTap: () async => await audioManager.play(item.audioAsset),
                      child: Material(
                        color: Colors.white,
                        elevation: 6,
                        borderRadius: BorderRadius.circular(Radii.lg),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                item.imageAsset,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) => Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.bgHill.withOpacity(.5),
                                        AppColors.bgGrass.withOpacity(.6),
                                      ],
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.graphic_eq_rounded,
                                    size: 64,
                                    color: AppColors.leaf2.withOpacity(.9),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 12,
                              top: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.orange,
                                  borderRadius: BorderRadius.circular(999),
                                  boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black26)],
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                color: Colors.white.withOpacity(.85),
                                child: Text(
                                  item.title,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textDark,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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