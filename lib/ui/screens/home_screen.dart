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
              onHome: () {},
              onAnimals: () => Navigator.pushNamed(context, '/animals'),
              onSongs: () => Navigator.pushNamed(context, '/songs'),
              onGames: () => Navigator.pushNamed(context, '/games'),
              onStories: () => Navigator.pushNamed(context, '/stories'),
              onParents: () => Navigator.pushNamed(context, '/parents'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: LayoutBuilder(builder: (context, c) {
                final w = c.maxWidth;
                final cross = w > 1200 ? 6 : w > 900 ? 4 : w > 600 ? 3 : 2;
                final items = const [
                  _HomeItem('Instrumente', Icons.piano_rounded, '/xylophone'),
                  _HomeItem('Cântece', Icons.library_music_rounded, '/songs'),
                  _HomeItem('Sunete & Animale', Icons.pets_rounded, '/animals'),
                  _HomeItem('Jocuri', Icons.extension_rounded, '/games'),
                  _HomeItem('Povești', Icons.menu_book_rounded, '/stories'),
                ];
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cross, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.05),
                  itemCount: items.length,
                  itemBuilder: (context, i) => _HomeCard(item: items[i]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeItem {
  final String title;
  final IconData icon;
  final String route;
  const _HomeItem(this.title, this.icon, this.route);
}

class _HomeCard extends StatelessWidget {
  final _HomeItem item;
  const _HomeCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, item.route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 48, color: Colors.white),
            const SizedBox(height: 10),
            Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}