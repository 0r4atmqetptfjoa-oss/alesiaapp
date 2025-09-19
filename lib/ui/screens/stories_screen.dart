import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';
import '../widgets/fancy_tile.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
              const SizedBox(height: 4),
              const TabBar(
                tabs: [
                  Tab(text: 'Basme clasice'),
                  Tab(text: 'Fabule'),
                  Tab(text: 'Povești cu animale'),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TabBarView(
                    children: [
                      _grid(),
                      _grid(),
                      _grid(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget _grid() {
    return GridView.count(
      crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.1,
      children: const [
        FancyTile(title: 'Scufița Roșie'),
        FancyTile(title: 'Alba ca Zăpada'),
        FancyTile(title: 'Prâslea cel voinic'),
      ],
    );
  }
}