import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = const ['Puzzle', 'Memorie', 'Alfabet', 'Numere'];
    return Scaffold(
      body: ForestBackground(
        child: Column(
          children: [
            RibbonBar(
              onHome: () => Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
              onAnimals: () => Navigator.pushReplacementNamed(context, '/animals'),
              onSongs: () => Navigator.pushReplacementNamed(context, '/songs'),
              onGames: () {},
              onStories: () => Navigator.pushReplacementNamed(context, '/stories'),
              onParents: () => Navigator.pushReplacementNamed(context, '/parents'),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
                itemCount: games.length,
                itemBuilder: (_, i) => Material(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {},
                    child: Center(
                      child: Text(games[i], style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}