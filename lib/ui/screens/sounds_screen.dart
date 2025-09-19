import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/kid_card.dart';
import '../widgets/adaptive.dart';
import '../../services/audio_manager.dart';

class SoundItem {
  final String title;
  final String imageAsset;
  final String audioAsset;
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: adaptiveCrossAxisCount(context, minTileWidth: 260),
                    childAspectRatio: 16 / 10,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                  ),
                  itemCount: soundItems.length,
                  itemBuilder: (context, index) {
                    final item = soundItems[index];
                    return KidCard(
                      title: item.title,
                      imageAsset: item.imageAsset,
                      badgeText: '${index + 1}',
                      onTap: () async => await audioManager.play(item.audioAsset),
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