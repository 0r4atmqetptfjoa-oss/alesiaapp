import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/kid_card.dart';
import '../../widgets/adaptive.dart';

class GamesHomeScreen extends StatelessWidget {
  const GamesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_GameItem>[
      _GameItem('Puzzle', 'assets/images/games/puzzle.png', '/puzzle'),
      _GameItem('Memorie', 'assets/images/games/memory.png', '/memory'),
      _GameItem('Alfabet', 'assets/images/games/alphabet.png', '/alphabet'),
      _GameItem('Numere', 'assets/images/games/numbers.png', '/numbers'),
    ];

    return Scaffold(
      body: ForestBackground(
        child: Column(
          children: [
            RibbonBar(
              onHome: () => Navigator.popUntil(context, ModalRoute.withName('/')),
              onXylophone: () => Navigator.pushReplacementNamed(context, '/xylophone'),
              onDrums: () => Navigator.pushReplacementNamed(context, '/drums'),
              onSounds: () => Navigator.pushReplacementNamed(context, '/sounds'),
              onParents: () => Navigator.pushNamed(context, '/parents'),
            ),
            const SizedBox(height: 12),
            Text('Jocuri', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: adaptiveCrossAxisCount(context, minTileWidth: 260),
                    childAspectRatio: 4/3,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final it = items[index];
                    return KidCard(
                      title: it.title,
                      imageAsset: it.image,
                      onTap: () => Navigator.pushNamed(context, it.route),
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

class _GameItem {
  final String title;
  final String image;
  final String route;
  _GameItem(this.title, this.image, this.route);
}