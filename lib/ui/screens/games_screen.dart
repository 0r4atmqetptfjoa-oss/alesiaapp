import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';
import '../widgets/fancy_tile.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

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
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('Jocuri educative', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
                  crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.1,
                  children: const [
                    FancyTile(title: 'Memorie'),
                    FancyTile(title: 'Puzzle'),
                    FancyTile(title: 'Alfabet'),
                    FancyTile(title: 'Numere'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}